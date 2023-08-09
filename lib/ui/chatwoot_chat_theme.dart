// import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';

// const CHATWOOT_COLOR_PRIMARY = Color(0xff1f93ff);
// const CHATWOOT_BG_COLOR = Color(0xfff4f6fb);
// const CHATWOOT_AVATAR_COLORS = [CHATWOOT_COLOR_PRIMARY];

// /// Dark.
// const dark = Color(0xff1f1c38);

// /// Error.
// const ERROR = Color(0xffff6767);

// /// N0.
// const NEUTRAL_0 = Color(0xff1d1c21);

// /// N1.
// const neutral1 = Color(0xff615e6e);

// /// N2.
// const NEUTRAL_2 = Color(0xff9e9cab);

// /// N7.
// const NEUTRAL_7 = Color(0xffffffff);

// /// N7 with opacity.
// const NEUTRAL_7_WITH_OPACITY = Color(0x80ffffff);

// /// Primary.
// const PRIMARY = Color(0xff6f61e8);

// /// Default chatwoot chat theme which extends [ChatTheme]
// @immutable
// class ChatwootChatTheme extends ChatTheme {
//   /// Creates a chatwoot chat theme. Use this constructor if you want to
//   /// override only a couple of variables.

//   final Widget? attachmentButtonIcon;
//   final Color? backgroundColor;
//   final TextStyle dateDividerTextStyle;
//   final Widget? deliveredIcon;
//   final Widget? documentIcon;
//   final TextStyle emptyChatPlaceholderTextStyle;
//   final Color errorColor;
//   final Widget? errorIcon;
//   final Color inputBackgroundColor;
//   final BorderRadius inputBorderRadius;
//   final Color inputTextColor;
//   final TextStyle inputTextStyle;
//   final double messageBorderRadius;
//   final Color primaryColor;
//   final TextStyle receivedMessageBodyTextStyle;
//   final TextStyle receivedMessageCaptionTextStyle;
//   final Color receivedMessageDocumentIconColor;
//   final TextStyle receivedMessageLinkDescriptionTextStyle;
//   final TextStyle receivedMessageLinkTitleTextStyle;
//   final Color secondaryColor;
//   final Widget? seenIcon;
//   final Widget? sendButtonIcon;
//   final Widget? sendingIcon;
//   final TextStyle sentMessageBodyTextStyle;
//   final TextStyle sentMessageCaptionTextStyle;
//   final Color sentMessageDocumentIconColor;
//   final TextStyle sentMessageLinkDescriptionTextStyle;
//   final TextStyle sentMessageLinkTitleTextStyle;
//   final List<Color> userAvatarNameColors;
//   final TextStyle userAvatarTextStyle;
//   final TextStyle userNameTextStyle;

//   const ChatwootChatTheme(
//       {this.attachmentButtonIcon,
//       this.backgroundColor,
//       this.dateDividerTextStyle = const TextStyle(
//         color: Colors.black26,
//         fontSize: 12,
//         fontWeight: FontWeight.w800,
//         height: 1.333,
//       ),
//       this.deliveredIcon,
//       this.documentIcon,
//       this.emptyChatPlaceholderTextStyle = const TextStyle(
//         color: NEUTRAL_2,
//         fontSize: 16,
//         fontWeight: FontWeight.w500,
//         height: 1.5,
//       ),
//       this.errorColor = ERROR,
//       this.errorIcon,
//       this.inputBackgroundColor = Colors.white,
//       this.inputBorderRadius = const BorderRadius.all(
//         Radius.circular(10),
//       ),
//       this.inputTextColor = Colors.black87,
//       this.inputTextStyle = const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w500,
//         height: 1.5,
//       ),
//       this.messageBorderRadius = 20.0,
//       this.primaryColor = CHATWOOT_COLOR_PRIMARY,
//       this.receivedMessageBodyTextStyle = const TextStyle(
//         color: Colors.black87,
//         fontSize: 16,
//         fontWeight: FontWeight.w500,
//         height: 1.5,
//       ),
//       this.receivedMessageCaptionTextStyle = const TextStyle(
//         color: NEUTRAL_2,
//         fontSize: 12,
//         fontWeight: FontWeight.w500,
//         height: 1.333,
//       ),
//       this.receivedMessageDocumentIconColor = PRIMARY,
//       this.receivedMessageLinkDescriptionTextStyle = const TextStyle(
//         color: NEUTRAL_0,
//         fontSize: 14,
//         fontWeight: FontWeight.w400,
//         height: 1.428,
//       ),
//       this.receivedMessageLinkTitleTextStyle = const TextStyle(
//         color: NEUTRAL_0,
//         fontSize: 16,
//         fontWeight: FontWeight.w800,
//         height: 1.375,
//       ),
//       this.secondaryColor = Colors.white,
//       this.seenIcon,
//       this.sendButtonIcon,
//       this.sendingIcon,
//       this.sentMessageBodyTextStyle = const TextStyle(
//         color: Colors.white,
//         fontSize: 16,
//         fontWeight: FontWeight.w500,
//         height: 1.5,
//       ),
//       this.sentMessageCaptionTextStyle = const TextStyle(
//         color: NEUTRAL_7_WITH_OPACITY,
//         fontSize: 12,
//         fontWeight: FontWeight.w500,
//         height: 1.333,
//       ),
//       this.sentMessageDocumentIconColor = NEUTRAL_7,
//       this.sentMessageLinkDescriptionTextStyle = const TextStyle(
//         color: NEUTRAL_7,
//         fontSize: 14,
//         fontWeight: FontWeight.w400,
//         height: 1.428,
//       ),
//       this.sentMessageLinkTitleTextStyle = const TextStyle(
//         color: NEUTRAL_7,
//         fontSize: 16,
//         fontWeight: FontWeight.w800,
//         height: 1.375,
//       ),
//       this.userAvatarNameColors = CHATWOOT_AVATAR_COLORS,
//       this.userAvatarTextStyle = const TextStyle(
//         color: NEUTRAL_7,
//         fontSize: 12,
//         fontWeight: FontWeight.w800,
//         height: 1.333,
//       ),
//       this.userNameTextStyle = const TextStyle(
//         color: Colors.black87,
//         fontSize: 12,
//         fontWeight: FontWeight.w800,
//         height: 1.333,
//       )})
//       : super(
//           attachmentButtonIcon: attachmentButtonIcon,
//           backgroundColor: backgroundColor,
//           dateDividerTextStyle: dateDividerTextStyle,
//           deliveredIcon: deliveredIcon,
//           documentIcon: documentIcon,
//           emptyChatPlaceholderTextStyle: emptyChatPlaceholderTextStyle,
//           errorColor: errorColor,
//           errorIcon: errorIcon,
//           inputBackgroundColor: inputBackgroundColor,
//           inputBorderRadius: inputBorderRadius,
//           inputTextColor: inputTextColor,
//           inputTextStyle: inputTextStyle,
//           messageBorderRadius: messageBorderRadius,
//           primaryColor: primaryColor,
//           receivedMessageBodyTextStyle: receivedMessageBodyTextStyle,
//           receivedMessageCaptionTextStyle: receivedMessageCaptionTextStyle,
//           receivedMessageDocumentIconColor: receivedMessageDocumentIconColor,
//           receivedMessageLinkDescriptionTextStyle: receivedMessageLinkDescriptionTextStyle,
//           receivedMessageLinkTitleTextStyle: receivedMessageLinkTitleTextStyle,
//           secondaryColor: secondaryColor,
//           seenIcon: seenIcon,
//           sendButtonIcon: sendButtonIcon,
//           sendingIcon: sendingIcon,
//           sentMessageBodyTextStyle: sentMessageBodyTextStyle,
//           sentMessageCaptionTextStyle: sentMessageCaptionTextStyle,
//           sentMessageDocumentIconColor: sentMessageDocumentIconColor,
//           sentMessageLinkDescriptionTextStyle: sentMessageLinkDescriptionTextStyle,
//           sentMessageLinkTitleTextStyle: sentMessageLinkTitleTextStyle,
//           userAvatarNameColors: userAvatarNameColors,
//           userAvatarTextStyle: userAvatarTextStyle,
//           userNameTextStyle: userNameTextStyle,
//         );
// }
