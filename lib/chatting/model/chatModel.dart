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
    name: "Stephen",
    message: "Hey Flutter, You are amazing !",
    time: DateTime.now().toString(),
    avatarUrl: "https://randomuser.me/portraits/men/88.jpg",
    seen: false,
    online: true,
  ),
  ChatModel(
    name: "Brian",
    message: "Hey Flutter, You are amazing !",
    time: "15:30",
    avatarUrl: "https://randomuser.me/portraits/women/51.jpg",
    seen: true,
    online: false,
  ),
  ChatModel(
    name: "Danial",
    message: "Hey Flutter, You are amazing !",
    time: "15:30",
    avatarUrl: "https://randomuser.me/portraits/men/42.jpg",
    seen: true,
    online: true,
  ),
  ChatModel(
    name: "Clone",
    message: "Hey Flutter, You are amazing !",
    time: "15:30",
    avatarUrl: "https://randomuser.me/portraits/women/43.jpg",
    seen: false,
    online: false,
  ),
  ChatModel(
    name: "Randal",
    message: "Hey Flutter, You are amazing !",
    time: "15:30",
    avatarUrl: "https://randomuser.me/portraits/women/15.jpg",
    seen: true,
    online: false,
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
    name: "Henley",
    message: "Hey Flutter, You are amazing !",
    time: "15:30",
    avatarUrl: "https://randomuser.me/portraits/women/2.jpg",
    seen: true,
    online: true,
  ),
  ChatModel(
    name: "Morgan",
    message: "Hey Flutter, You are amazing !",
    time: "15:30",
    avatarUrl: "https://randomuser.me/portraits/men/1.jpg",
    seen: true,
    online: false,
  ),
  ChatModel(
    name: "Jonathan",
    message: "Hey Flutter, You are amazing !",
    time: "15:30",
    avatarUrl: "https://randomuser.me/portraits/men/5.jpg",
    seen: true,
    online: true,
  ),
  ChatModel(
    name: "Jameson",
    message: "Hey Flutter, You are amazing !",
    time: "15:30",
    avatarUrl: "https://randomuser.me/portraits/men/6.jpg",
    seen: true,
    online: false,
  ),
  ChatModel(
    name: "Harry",
    message: "Hey Flutter, You are amazing !",
    time: "15:30",
    avatarUrl: "https://randomuser.me/portraits/men/11.jpg",
    seen: true,
    online: false,
  ),
];
