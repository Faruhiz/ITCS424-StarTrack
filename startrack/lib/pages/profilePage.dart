// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String _formatRemainingTime(int remainingTimeInSeconds) {
  Duration duration = Duration(seconds: remainingTimeInSeconds);
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);

  if (hours == 0 && minutes == 0 && seconds == 0) {
    return 'Finished';
  }
  return '$hours hours $minutes minutes';
}

Map<String, dynamic> userData =
    {}; // Default value to avoid errors when fetching data

class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key? key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late SharedPreferences prefs;
  // List<dynamic> expeditions = []; // Initial expeditions list

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data when the page is initialized
  }

  void fetchUserData() async {
    prefs = await SharedPreferences.getInstance();
    var reqBody = {"uid": prefs.getString('uid')};

    var responseInfo = await http.post(
      Uri.parse('http://34.87.22.134:3000/fetchInfo'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    var responseActInfo = await http.post(
      Uri.parse('http://34.87.22.134:3000/fetchAct'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    var resInfo = jsonDecode(responseInfo.body);
    var resActInfo = jsonDecode(responseActInfo.body);

    // Update the user data state with the response data
    setState(() {
      userData = {...resActInfo, ...resInfo};
      // print(userData['expeditions']);
      // expeditions = userData['expeditions'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), // Logout icon
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: userData.isNotEmpty &&
                  userData['phone_background_image_url'] != null
              ? DecorationImage(
                  image: NetworkImage(userData['phone_background_image_url']),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: userData.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Info Section

                    UserProfileBlock(
                      nickname: userData['nickname'],
                      level: userData['level'],
                      gameData: [
                        {
                          'name': 'Trailblaze Power',
                          'value':
                              '${userData['current_stamina']}/${userData['max_stamina']}'
                        },
                        {
                          'name': 'Reserved Trailblaze Power',
                          'value':
                              '${userData['current_reserve_stamina']}/24000'
                        },
                        {
                          'name': 'Remaining Recovery Time',
                          'value': _formatRemainingTime(
                              userData['stamina_recover_time'])
                        },
                        {
                          'name': 'Daily Training',
                          'value':
                              '${userData['current_train_score']}/${userData['max_train_score']}'
                        },
                        {
                          'name': 'Echo of War',
                          'value':
                              '${userData['weekly_cocoon_cnt']}/${userData['weekly_cocoon_limit']}'
                        },
                        {
                          'name': 'Simulated Universe',
                          'value':
                              '${userData['current_rogue_score']}/${userData['max_rogue_score']}'
                        }
                      ],
                    ),

                    // Expeditions Section
                    SizedBox(height: 24.0),

                    ExpeditionGroup(
                      expeditions: List<Map<String, dynamic>>.from(
                          userData['expeditions'] ?? []),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class UserProfileBlock extends StatelessWidget {
  final String nickname;
  final int level;
  final List<Map<String, dynamic>> gameData;

  UserProfileBlock({
    required this.nickname,
    required this.level,
    required this.gameData,
  });

  @override
  Widget build(BuildContext context) {
    String backgroundImageUrl =
        'https://upload-os-bbs.hoyolab.com/game_record/rpg_card.png'
        '?nickname=$nickname&level=$level';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(backgroundImageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.darken,
            ),
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Info',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.0),
            UserInfoCard(
              nickname: nickname,
              level: level,
              profileUrl: userData['cur_head_icon_url'],
            ),
            SizedBox(height: 24.0),
            Text(
              'Real-Time Notes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.0),
            GameDataGroup(gameData: gameData),
          ],
        ),
      ),
    );
  }
}

class UserInfoCard extends StatelessWidget {
  final String nickname;
  final int level;
  final String profileUrl;

  UserInfoCard({
    required this.nickname,
    required this.level,
    required this.profileUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(profileUrl),
        ),
        title: Text(nickname),
        subtitle: Text('Trailblaze Level $level'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserChars(userData: userData),
            ),
          );
        },
      ),
    );
  }
}

class UserChars extends StatelessWidget {
  final Map<String, dynamic> userData;

  UserChars({required this.userData});

  @override
  Widget build(BuildContext context) {
    final stats = userData['stats'];
    final avatarList = userData['avatar_list'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Account Info'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), // Logout icon
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(userData['phone_background_image_url']),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBlockWithTitle(
                title: 'Statistics',
                content: _buildStatsContent(stats),
              ),
              SizedBox(height: 24),
              _buildBlockWithTitle(
                title: 'Characters List',
                content: _buildAvatarListContent(avatarList),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlockWithTitle(
      {required String title, required Widget content}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  Widget _buildStatsContent(Map<String, dynamic> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatItem('Active Days', stats['active_days'].toString()),
        _buildStatItem('Characters Owned', stats['avatar_num'].toString()),
        _buildStatItem(
          'Achievements Unlocked',
          stats['achievement_num'].toString(),
        ),
        _buildStatItem('Treasure Opened', stats['chest_num'].toString()),
        _buildStatItem('Memory of Chaos', userData['moc'].toString()),
        _buildStatItem('Pure Fiction', stats['abyss_process']),
      ],
    );
  }

  Widget _buildAvatarListContent(List<dynamic> avatarList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: avatarList.length,
      itemBuilder: (context, index) {
        final avatar = avatarList[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(avatar['icon']),
          ),
          title: Text(avatar['name']),
          subtitle: Row(
            children: [
              Image.asset(
                'assets/images/${avatar['element']}.png',
                width: 24,
                height: 24,
              ),
              SizedBox(width: 8),
              Text('Level ${avatar['level']}'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ExpeditionGroup extends StatelessWidget {
  final List<Map<String, dynamic>> expeditions;

  ExpeditionGroup({required this.expeditions});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assignments',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: expeditions.map((dynamic expedition) {
                if (expedition is Map<String, dynamic>) {
                  String name = expedition['name'];
                  int remainingTime = expedition['remaining_time'];
                  String imageUrl = expedition['item_url'];

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: ExpeditionCard(
                      name: name,
                      remainingTime: remainingTime,
                      imageUrl: imageUrl,
                    ),
                  );
                } else {
                  // Handle unexpected item type
                  return Container(); // or alternative widget
                }
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpeditionCard extends StatefulWidget {
  final String name;
  final int remainingTime;
  final String imageUrl;

  ExpeditionCard({
    required this.name,
    required this.remainingTime,
    required this.imageUrl,
  });

  @override
  _ExpeditionCardState createState() => _ExpeditionCardState();
}

class _ExpeditionCardState extends State<ExpeditionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    String formattedRemainingTime = _formatRemainingTime(widget.remainingTime);

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.imageUrl),
              ),
            ),
          ),
          title: Text(
            widget.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            'Remaining Time: $formattedRemainingTime',
          ),
          trailing:
              _expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
          onTap: () {
            setState(() {
              _expanded = !_expanded; // Toggle expanded state
            });
          },
        ),
        if (_expanded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  'Assigned to',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: (userData['expeditions'] as List<dynamic>)
                      .where((exp) => exp['name'] == widget.name)
                      .map<Widget>((expeditions) {
                    return Row(
                      children: (expeditions['avatars'] as List<dynamic>)
                          .map<Widget>((avatarUrl) {
                        return CircleAvatar(
                          backgroundImage: NetworkImage(avatarUrl),
                          radius: 24,
                        );
                      }).toList(),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class GameDataGroup extends StatelessWidget {
  final List<Map<String, dynamic>> gameData;

  GameDataGroup({required this.gameData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: gameData.length,
        itemBuilder: (context, index) {
          String name = gameData[index]['name'].toString();
          String value = gameData[index]['value'].toString();

          return ListTile(
            title: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              value,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          );
        },
      ),
    );
  }
}
