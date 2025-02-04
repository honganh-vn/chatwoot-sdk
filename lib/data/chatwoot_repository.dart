import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:chatwoot_sdk/chatwoot_callbacks.dart';
import 'package:chatwoot_sdk/chatwoot_client.dart';
import 'package:chatwoot_sdk/data/local/entity/chatwoot_user.dart';
import 'package:chatwoot_sdk/data/local/local_storage.dart';
import 'package:chatwoot_sdk/data/remote/chatwoot_client_exception.dart';
import 'package:chatwoot_sdk/data/remote/requests/chatwoot_action_data.dart';
import 'package:chatwoot_sdk/data/remote/requests/chatwoot_new_message_request.dart';
import 'package:chatwoot_sdk/data/remote/responses/chatwoot_event.dart';
import 'package:chatwoot_sdk/data/remote/service/chatwoot_client_auth_service.dart';
import 'package:chatwoot_sdk/data/remote/service/chatwoot_client_service.dart';
import 'package:flutter/material.dart';

import 'local/entity/chatwoot_contact.dart';
import 'local/entity/chatwoot_conversation.dart';

/// Handles interactions between chatwoot client api service[clientService] and
/// [localStorage] if persistence is enabled.
///
/// Results from repository operations are passed through [callbacks] to be handled
/// appropriately
abstract class ChatwootRepository {
  @protected
  final ChatwootClientService clientService;
  @protected
  final ChatwootClientAuthService clientAuthService;

  @protected
  final LocalStorage localStorage;
  @protected
  ChatwootCallbacks callbacks;

  @protected
  String inboxIdentifier;

  List<StreamSubscription> _subscriptions = [];

  ChatwootRepository(this.clientService, this.clientAuthService,
      this.localStorage, this.callbacks, this.inboxIdentifier);

  Future<void> initialize(ChatwootUser? user);

  void getPersistedMessages();

  ChatwootConversation? getPersistedConversation();

  Future<void> getMessages();

  void listenForEvents();

  Future<void> sendMessage(ChatwootNewMessageRequest request);

  Future<void> sendFile(String filePath, String echoId, bool? isImage);

  void sendAction(ChatwootActionType action);

  Future<void> clear();

  Future<void> seenAll();

  void dispose();
}

class ChatwootRepositoryImpl extends ChatwootRepository {
  bool _isListeningForEvents = false;
  Timer? _publishPresenceTimer;
  Timer? _presenceResetTimer;

  ChatwootRepositoryImpl(
      {required ChatwootClientService clientService,
        required ChatwootClientAuthService clientAuthService,
      required LocalStorage localStorage,
      required ChatwootCallbacks streamCallbacks, required String inboxIdentifier})
      : super(clientService, clientAuthService, localStorage,
      streamCallbacks, inboxIdentifier);

  /// Fetches persisted messages.
  ///
  /// Calls [ChatwootCallbacks.onMessagesRetrieved] when [ChatwootClientService.getAllMessages] is successful
  /// Calls [ChatwootCallbacks.onError] when [ChatwootClientService.getAllMessages] fails
  @override
  Future<void> getMessages() async {
    try {
      var persistedConversation = localStorage.conversationDao.getConversation();
      if (persistedConversation != null){
        final messages = await clientService.getAllMessages();
        await localStorage.messagesDao.saveAllMessages(messages);
        callbacks.onMessagesRetrieved?.call(messages);
      }
      // try to reconnect the websocket if need
      if (clientService.connection != null && !_isListeningForEvents) {
        listenForEvents();
      }

    } on ChatwootClientException catch (e) {
      callbacks.onError?.call(e);
    }
  }

  /// Fetches persisted messages.
  ///
  /// Calls [ChatwootCallbacks.onPersistedMessagesRetrieved] if persisted messages are found
  @override
  void getPersistedMessages() {
    final persistedMessages = localStorage.messagesDao.getMessages();
    if (persistedMessages.isNotEmpty) {
      callbacks.onPersistedMessagesRetrieved?.call(persistedMessages);
    }
  }

  /// Initializes chatwoot client repository
  Future<void> initialize(ChatwootUser? user) async {
    try {
      if (user != null) {
        await localStorage.userDao.saveUser(user);
      }

      //refresh contact
      final contact = await clientService.getContact();
      localStorage.contactDao.saveContact(contact);

      //refresh conversation
      final conversations = await clientService.getConversations();
      final persistedConversation =
          localStorage.conversationDao.getConversation();
      if (persistedConversation != null){
        final refreshedConversation = conversations.firstWhere(
                (element) => element.id == persistedConversation.id,
            orElse: () =>
            persistedConversation //highly unlikely orElse will be called but still added it just in case
        );
        localStorage.conversationDao.saveConversation(refreshedConversation);
      }

    } on ChatwootClientException catch (e) {
      callbacks.onError?.call(e);
    }

    listenForEvents();
  }

  ///Sends message to chatwoot inbox
  Future<void> sendMessage(ChatwootNewMessageRequest request) async {
    try {
      ChatwootContact? contact = localStorage.contactDao.getContact();
      ChatwootConversation? conversation = localStorage.conversationDao.getConversation();

      if (contact == null) {
        // create new contact from user if no token found
        contact = await clientAuthService.createNewContact(inboxIdentifier, localStorage.userDao.getUser());
        await localStorage.contactDao.saveContact(contact);
      }

      if (conversation == null || conversation.status == "resolved") {
        conversation =
        await clientAuthService.createNewConversation(inboxIdentifier, contact.contactIdentifier!, {});
        await localStorage.conversationDao.saveConversation(conversation);
        callbacks.onConversationCreated?.call(conversation);
      }
      final createdMessage = await clientService.createMessage(request);
      await localStorage.messagesDao.saveMessage(createdMessage);
      callbacks.onMessageSent?.call(createdMessage, request.echoId);
      if (clientService.connection != null && !_isListeningForEvents) {
        listenForEvents();
      }
    } on ChatwootClientException catch (e) {
      callbacks.onError?.call(
          ChatwootClientException(e.cause, e.type, data: request.echoId));
    }
  }

  ///Sends message file
  Future<void> sendFile(String filePath, String echoId, bool? isImage) async {
    try {
      ChatwootContact? contact = localStorage.contactDao.getContact();
      ChatwootConversation? conversation = localStorage.conversationDao.getConversation();

      if (contact == null) {
        // create new contact from user if no token found
        contact = await clientAuthService.createNewContact(inboxIdentifier, localStorage.userDao.getUser());
        await localStorage.contactDao.saveContact(contact);
      }

      if (conversation == null || conversation.status == "resolved") {
        conversation =
        await clientAuthService.createNewConversation(inboxIdentifier, contact.contactIdentifier!, {});
        await localStorage.conversationDao.saveConversation(conversation);
        callbacks.onConversationCreated?.call(conversation);
      }
      final createdMessage = await clientService.sendFile(filePath, echoId, isImage);
      await localStorage.messagesDao.saveMessage(createdMessage);
      callbacks.onMessageSent?.call(createdMessage, echoId);
      if (clientService.connection != null && !_isListeningForEvents) {
        listenForEvents();
      }
    } on ChatwootClientException catch (e) {
      callbacks.onError?.call(
          ChatwootClientException(e.cause, e.type, data: echoId));
    }
  }

  /// Connects to chatwoot websocket and starts listening for updates
  ///
  /// Received events/messages are pushed through [ChatwootClient.callbacks]
  @override
  void listenForEvents() {
    final token = localStorage.contactDao.getContact()?.pubsubToken;
    if (token == null) {
      return;
    }
    clientService.startWebSocketConnection(
        localStorage.contactDao.getContact()?.pubsubToken ?? "");

    final newSubscription = clientService.connection!.stream.listen((event) {
      ChatwootEvent chatwootEvent = ChatwootEvent.fromJson(jsonDecode(event));
      if (chatwootEvent.type == ChatwootEventType.welcome) {
        callbacks.onWelcome?.call();
      } else if (chatwootEvent.type == ChatwootEventType.ping) {
        callbacks.onPing?.call();
      } else if (chatwootEvent.type == ChatwootEventType.confirm_subscription) {
        if (!_isListeningForEvents) {
          _isListeningForEvents = true;
        }
        _publishPresenceUpdates();
        callbacks.onConfirmedSubscription?.call();
      } else if (chatwootEvent.message?.event ==
          ChatwootEventMessageType.message_created) {
        final message = chatwootEvent.message!.data!.getMessage();
        print("hello6 raw message ${jsonDecode(event)}");
        localStorage.messagesDao.saveMessage(message);
        if (message.isMine) {
          callbacks.onMessageDelivered
              ?.call(message, chatwootEvent.message!.data!.echoId!);
        } else {
          callbacks.onMessageReceived?.call(message);
        }
      } else if (chatwootEvent.message?.event ==
          ChatwootEventMessageType.message_updated) {

        final message = chatwootEvent.message!.data!.getMessage();
        localStorage.messagesDao.saveMessage(message);

        callbacks.onMessageUpdated?.call(message);
      } else if (chatwootEvent.message?.event ==
          ChatwootEventMessageType.conversation_typing_off) {
        callbacks.onConversationStoppedTyping?.call();
      } else if (chatwootEvent.message?.event ==
          ChatwootEventMessageType.conversation_typing_on) {
        callbacks.onConversationStartedTyping?.call();
      } else if (chatwootEvent.message?.event ==
              ChatwootEventMessageType.conversation_status_changed &&
          chatwootEvent.message?.data?.id ==
              (localStorage.conversationDao.getConversation()?.id ?? 0)) {
        // delete conversation result
        var persistedConversation = localStorage.conversationDao.getConversation()!;
        persistedConversation.status = chatwootEvent.message?.data?.status;
        localStorage.conversationDao.saveConversation(persistedConversation);
        if (chatwootEvent.message?.data?.status == "resolved"){
          localStorage.messagesDao.clear();
          callbacks.onConversationResolved?.call();        }
      } else if (chatwootEvent.message?.event ==
          ChatwootEventMessageType.presence_update) {
        final presenceStatuses =
            (chatwootEvent.message!.data!.users as Map<dynamic, dynamic>)
                .values;
        final isOnline = presenceStatuses.contains("online");
        if (isOnline) {
          callbacks.onConversationIsOnline?.call();
          _presenceResetTimer?.cancel();
          _startPresenceResetTimer();
        } else {
          callbacks.onConversationIsOffline?.call();
        }
      } else if (chatwootEvent.message?.event ==
          ChatwootEventMessageType.conversation_updated){
        // clientService.getConversations().then((value) {
          clientService.getConversations().then((conversations) {
            final persistedConversation = localStorage.conversationDao.getConversation()!;
            final refreshedConversation = conversations.firstWhere(
                    (element) => element.id == persistedConversation.id,
                orElse: () =>
                persistedConversation //highly unlikely orElse will be called but still added it just in case
            );
            localStorage.conversationDao.saveConversation(refreshedConversation);
            callbacks.onConversationUpdated?.call(refreshedConversation);
          });
      } else {
        print("chatwoot unknown event: $event");
      }
    }, onDone: (){
      _isListeningForEvents = false;
    });
    _subscriptions.add(newSubscription);
  }

  /// Clears all data related to current chatwoot client instance
  @override
  Future<void> clear() async {
    await localStorage.clear();
  }
    /// Clears all data related to current chatwoot client instance
  @override
  Future<void> seenAll() async {
    var persistedConversation = localStorage.conversationDao.getConversation();
    if (persistedConversation != null){
      await clientService.seenAll().then((value) {
        clientService.getConversations().then((conversations) {
          final persistedConversation = localStorage.conversationDao
              .getConversation()!;
          final refreshedConversation = conversations.firstWhere(
                  (element) => element.id == persistedConversation.id,
              orElse: () =>
              persistedConversation //highly unlikely orElse will be called but still added it just in case
          );
          localStorage.conversationDao.saveConversation(refreshedConversation);
          callbacks.onConversationUpdated?.call(refreshedConversation);
        });
      });
    }
  }

  /// Cancels websocket stream subscriptions and disposes [localStorage]
  @override
  void dispose() {
    localStorage.dispose();
    callbacks = ChatwootCallbacks();
    _presenceResetTimer?.cancel();
    _publishPresenceTimer?.cancel();
    _subscriptions.forEach((subs) {
      subs.cancel();
    });
  }

  ///Send actions like user started typing
  @override
  void sendAction(ChatwootActionType action) {
    clientService.sendAction(
        localStorage.contactDao.getContact()!.pubsubToken ?? "", action);
  }

  ///Publishes presence update to websocket channel at a 30 second interval
  void _publishPresenceUpdates() {
    sendAction(ChatwootActionType.update_presence);
    _publishPresenceTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      sendAction(ChatwootActionType.update_presence);
    });
  }

  ///Triggers an offline presence event after 40 seconds without receiving a presence update event
  void _startPresenceResetTimer() {
    _presenceResetTimer = Timer.periodic(Duration(seconds: 40), (timer) {
      callbacks.onConversationIsOffline?.call();
      _presenceResetTimer?.cancel();
    });
  }

  @override
  ChatwootConversation? getPersistedConversation() {
    final persistedConversation = localStorage.conversationDao.getConversation();
    return persistedConversation;
  }
}
