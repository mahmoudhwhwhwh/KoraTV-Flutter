import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/channel.dart';
import 'player_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLightMode = false;
  String? selectedSection;
  
  final Map<String, List<Channel>> data = {
    'bein': [
      Channel(name: "beIN 1", url: "go:b1"),
      Channel(name: "beIN 2", url: "go:b2"),
      Channel(name: "beIN 3", url: "go:b3"),
      Channel(name: "beIN 4", url: "go:b4"),
      Channel(name: "beIN 5", url: "go:b5"),
      Channel(name: "beIN 6", url: "go:b6"),
    ],
    'sport': [
      Channel(name: "Sport 1", url: "go:s1"),
      Channel(name: "Sport 2", url: "go:s2"),
      Channel(name: "Sport 3", url: "go:s3"),
      Channel(name: "Sport 4", url: "go:s4"),
      Channel(name: "Sport 5", url: "go:s5"),
      Channel(name: "Sport 6", url: "go:s6"),
    ],
    'mbc': [
      Channel(name: "MBC 1", url: "go:m1"),
      Channel(name: "MBC 2", url: "go:m2"),
      Channel(name: "MBC 3", url: "go:m3"),
      Channel(name: "MBC 4", url: "go:m4"),
      Channel(name: "MBC Action", url: "go:m5"),
      Channel(name: "MBC Max", url: "go:m6"),
    ],
    'movies': [
      Channel(name: "Movie 1", url: "go:mv1"),
      Channel(name: "Movie 2", url: "go:mv2"),
      Channel(name: "Movie 3", url: "go:mv3"),
      Channel(name: "Movie 4", url: "go:mv4"),
      Channel(name: "Movie 5", url: "go:mv5"),
      Channel(name: "Movie 6", url: "go:mv6"),
    ],
    'kids': [
      Channel(name: "Kids 1", url: "go:k1"),
      Channel(name: "Kids 2", url: "go:k2"),
      Channel(name: "Kids 3", url: "go:k3"),
      Channel(name: "Kids 4", url: "go:k4"),
      Channel(name: "Kids 5", url: "go:k5"),
      Channel(name: "Kids 6", url: "go:k6"),
    ],
    'news': [
      Channel(name: "News 1", url: "go:n1"),
      Channel(name: "News 2", url: "go:n2"),
      Channel(name: "News 3", url: "go:n3"),
      Channel(name: "News 4", url: "go:n4"),
      Channel(name: "News 5", url: "go:n5"),
      Channel(name: "News 6", url: "go:n6"),
    ],
    'religion': [
      Channel(name: "Islamic 1", url: "go:r1"),
      Channel(name: "Islamic 2", url: "go:r2"),
      Channel(name: "Islamic 3", url: "go:r3"),
      Channel(name: "Islamic 4", url: "go:r4"),
      Channel(name: "Islamic 5", url: "go:r5"),
      Channel(name: "Islamic 6", url: "go:r6"),
    ],
    'kass': [
      Channel(name: "Alkass 1", url: "go:k1"),
      Channel(name: "Alkass 2", url: "go:k2"),
      Channel(name: "Alkass 3", url: "go:k3"),
      Channel(name: "Alkass 4", url: "go:k4"),
      Channel(name: "Alkass 5", url: "go:k5"),
      Channel(name: "Alkass 6", url: "go:k6"),
    ],
    'ssc': [
      Channel(name: "SSC 1", url: "go:s1"),
      Channel(name: "SSC 2", url: "go:s2"),
      Channel(name: "SSC 3", url: "go:s3"),
      Channel(name: "SSC 4", url: "go:s4"),
      Channel(name: "SSC 5", url: "go:s5"),
      Channel(name: "SSC 6", url: "go:s6"),
    ],
    'arabicSport': [
      Channel(name: "Arab 1", url: "go:a1"),
      Channel(name: "Arab 2", url: "go:a2"),
      Channel(name: "Arab 3", url: "go:a3"),
      Channel(name: "Arab 4", url: "go:a4"),
      Channel(name: "Arab 5", url: "go:a5"),
      Channel(name: "Arab 6", url: "go:a6"),
    ],
    'abuDhabi': [
      Channel(name: "AD 1", url: "go:ad1"),
      Channel(name: "AD 2", url: "go:ad2"),
      Channel(name: "AD 3", url: "go:ad3"),
      Channel(name: "AD 4", url: "go:ad4"),
      Channel(name: "AD 5", url: "go:ad5"),
      Channel(name: "AD 6", url: "go:ad6"),
    ],
    'tod': [
      Channel(name: "TOD 1", url: "go:t1"),
      Channel(name: "TOD 2", url: "go:t2"),
      Channel(name: "TOD 3", url: "go:t3"),
      Channel(name: "TOD 4", url: "go:t4"),
      Channel(name: "TOD 5", url: "go:t5"),
      Channel(name: "TOD 6", url: "go:t6"),
    ],
  };

  final List<String> sliderImages = [
    "https://iili.io/KHsnsyJ.jpg",
    "https://iili.io/BsK4nlp.png",
    "https://iili.io/BsK6ahg.png",
    "https://iili.io/BsKPVPj.png",
    "https://iili.io/BsKiSm7.png",
    "https://iili.io/BsKsXyB.png",
  ];

  @override
  void initState() {
    super.initState();
    _checkSubscription();
  }

  void _checkSubscription() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? startDate = prefs.getInt('startDate');
    if (startDate != null) {
      int now = DateTime.now().millisecondsSinceEpoch;
      int expiry = startDate + (7 * 24 * 60 * 60 * 1000);
      if (now > expiry) {
        _showExpiredDialog();
      }
    }
  }

  void _showExpiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          backgroundColor: Color(0xFF121212),
          title: Text('⏰ انتهى اشتراكك', style: TextStyle(color: Color(0xFFFFD700)), textAlign: TextAlign.center),
          content: Text('يرجى تجديد الاشتراك للمتابعة', style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = isLightMode ? Color(0xFFF4F4F4) : Color(0xFF121212);
    Color textColor = isLightMode ? Colors.black : Colors.white;
    Color boxColor = isLightMode ? Colors.white : Color(0xFF1E1E1E);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('⚽ KORA TV PRO'),
        centerTitle: true,
        backgroundColor: Color(0xFF6A0DAD),
        actions: [
          IconButton(
            icon: Icon(isLightMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => setState(() => isLightMode = !isLightMode),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (selectedSection == null) ...[
              SizedBox(height: 10),
              CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                ),
                items: sliderImages.map((url) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: url,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.transparent, Colors.black87],
                                    ),
                                  ),
                                  child: Text(
                                    '▶ شاهد الآن',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: data.keys.length,
                  itemBuilder: (context, index) {
                    String key = data.keys.elementAt(index);
                    String title = _getSectionTitle(key);
                    return GestureDetector(
                      onTap: () => setState(() => selectedSection = key),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0xFF1F1F1F), Color(0xFF141414)]),
                          border: Border.all(color: Color(0xFFD4AF37)),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Color(0xFFD4AF37).withOpacity(0.15), blurRadius: 8)],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          title,
                          style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => selectedSection = null),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Color(0xFF6A0DAD), borderRadius: BorderRadius.circular(8)),
                        child: Text('⬅ رجوع', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: data[selectedSection]!.length,
                      itemBuilder: (context, index) {
                        Channel channel = data[selectedSection]![index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlayerScreen(name: channel.name, url: channel.url),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: boxColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.withOpacity(0.3)),
                            ),
                            child: Text(
                              channel.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getSectionTitle(String key) {
    switch (key) {
      case 'bein': return 'beIN SPORT';
      case 'sport': return 'قنوات رياضية';
      case 'mbc': return 'MBC';
      case 'movies': return 'أفلام';
      case 'kids': return 'أطفال';
      case 'news': return 'إخبارية';
      case 'religion': return 'دينية';
      case 'kass': return 'قنوات الكأس';
      case 'ssc': return 'SSC SPORTS';
      case 'arabicSport': return 'رياضة عربية';
      case 'abuDhabi': return 'أبوظبي الرياضية';
      case 'tod': return 'TOD';
      default: return key;
    }
  }
}
