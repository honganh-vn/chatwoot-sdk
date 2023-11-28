// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatwoot_conversation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatwootConversationAdapter extends TypeAdapter<ChatwootConversation> {
  @override
  final int typeId = 1;

  @override
  ChatwootConversation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatwootConversation(
      id: fields[0] as int,
      inboxId: fields[1] as int,
      messages: (fields[2] as List).cast<ChatwootMessage>(),
      contact: fields[3] as ChatwootContact,
      unreadCount: fields[4] as int?,
      contactLastSeen: fields[5] as String?,
      status: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatwootConversation obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.inboxId)
      ..writeByte(2)
      ..write(obj.messages)
      ..writeByte(3)
      ..write(obj.contact)
      ..writeByte(4)
      ..write(obj.unreadCount)
      ..writeByte(5)
      ..write(obj.contactLastSeen)
      ..writeByte(6)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatwootConversationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatwootConversation _$ChatwootConversationFromJson(
        Map<String, dynamic> json) =>
    ChatwootConversation(
      id: json['id'] as int,
      inboxId: json['inbox_id'] as int,
      messages: (json['messages'] as List<dynamic>)
          .map((e) => ChatwootMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      contact:
          ChatwootContact.fromJson(json['contact'] as Map<String, dynamic>),
      unreadCount: json['unreadCount'] as int?,
      contactLastSeen: createdAtFromJson(json['contact_last_seen']),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$ChatwootConversationToJson(
        ChatwootConversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inbox_id': instance.inboxId,
      'messages': instance.messages.map((e) => e.toJson()).toList(),
      'contact': instance.contact.toJson(),
      'unreadCount': instance.unreadCount,
      'contact_last_seen': instance.contactLastSeen,
      'status': instance.status,
    };
