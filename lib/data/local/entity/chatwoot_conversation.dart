import 'package:chatwoot_sdk/chatwoot_sdk.dart';
import 'package:chatwoot_sdk/data/local/entity/chatwoot_contact.dart';
import 'package:chatwoot_sdk/data/local/local_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'chatwoot_conversation.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: CHATWOOT_CONVERSATION_HIVE_TYPE_ID)
class ChatwootConversation extends Equatable {
  ///The numeric ID of the conversation
  @JsonKey()
  @HiveField(0)
  final int id;

  ///The numeric ID of the inbox
  @JsonKey(name: "inbox_id")
  @HiveField(1)
  final int inboxId;

  ///List of all messages from the conversation
  @JsonKey()
  @HiveField(2)
  final List<ChatwootMessage> messages;

  ///Contact of the conversation
  @JsonKey()
  @HiveField(3)
  final ChatwootContact contact;

 ///Total unread
  @JsonKey()
  @HiveField(4)
  final int? unreadCount;

  ///date and time message was created
  @JsonKey(name: "contact_last_seen_at", )
  @HiveField(5)
  final int? contactLastSeen;

  ChatwootConversation(
      {required this.id,
      required this.inboxId,
      required this.messages,
      required this.contact,
      required this.unreadCount,
      required this.contactLastSeen,
      });

  factory ChatwootConversation.fromJson(Map<String, dynamic> json) =>
      _$ChatwootConversationFromJson(json);

  Map<String, dynamic> toJson() => _$ChatwootConversationToJson(this);

  @override
  List<Object?> get props => [id, inboxId, messages, contact, unreadCount, contactLastSeen];
}
