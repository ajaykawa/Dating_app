class ChatModel {
  final String? name;
  final String? message;
  final String? time;
  final String? avatarUrl;
  final bool? seen, online;

  ChatModel({
    this.name,
    this.message,
    this.time,
    this.avatarUrl,
    this.seen,
    this.online,
  });
}

List<ChatModel> dummyData = [
  ChatModel(
    name: "Clone",
    message: "Hey !!",
    time: "15:30",
    avatarUrl: "https://randomuser.me/portraits/women/43.jpg",
    seen: false,
    online: false,
  ),
  ChatModel(
    name: "Randal",
    message: "Helloo, You are amazing !",
    time: "15:30",
    avatarUrl: "https://randomuser.me/portraits/women/15.jpg",
    seen: true,
    online: true,
  ),
  ChatModel(
    name: "Monica",
    message: "Hey Flutter, You are amazing !",
    time: "15:30",
    avatarUrl: "https://randomuser.me/portraits/women/3.jpg",
    seen: true,
    online: false,
  ),
  ChatModel(
    name: "Randal",
    message: "Hey",
    time: "15:30",
    avatarUrl: "https://randomuser.me/portraits/women/15.jpg",
    seen: true,
    online: true,
  ),
  ChatModel(
    name: "Monica",
    message: "Hey Flutter, You are amazing !",
    time: "15:30",
    avatarUrl: "https://randomuser.me/portraits/women/3.jpg",
    seen: true,
    online: false,
  ),
];
