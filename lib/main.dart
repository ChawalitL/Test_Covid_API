import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:basic_p/covid_today_result.dart';
import 'covid_province.dart';

void main() {
  runApp(const Firstapp1());
}

class Firstapp1 extends StatelessWidget {
  const Firstapp1({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const First1(),
      theme: ThemeData(primarySwatch: Colors.grey),
    );
  }
}

class First1 extends StatefulWidget {
  const First1({Key? key}) : super(key: key);

  @override
  _first1State createState() => _first1State();
}

class _first1State extends State<First1> {
  PageController? _pageController;
  CovidTodayResult? _dataAPI;
  List _proAPI = [];
  var _appbar;
  int _page = 0;
  Widget? _titleOn;
  String search = '';
  Color _bgcolor = Colors.blue.shade100;

  @override
  void dispose() {
    super.dispose();
    _pageController?.dispose();
  }

  @override
  void initState() {
    super.initState();
    getData();
    _pageController = PageController();
    _appbar = AppBar(
      title: Text('Today Covid-19'),
    );
  }

  //Covid API for today
  Future<void> getData() async {
    final response = await http.get(
        Uri.parse("https://covid19.ddc.moph.go.th/api/Cases/today-cases-all"));
    var b = json.decode((response.body)) as List;

    print(b[0]);

    final response1 = await http.get(Uri.parse(
        "https://covid19.ddc.moph.go.th/api/Cases/today-cases-by-provinces"));

    ///////////////////////////////////////////////
    var proJson2 = json.decode(response1.body).cast<Map<String, dynamic>>();
    List result = proJson2
        .map<CovidInProvince>((json) => CovidInProvince.fromJson(json))
        .toList();

    /*for (var i in proJson2) {
      if (i['new_case'] >= 0) {
        A.add(i['province']);
        B.add(i['new_case']);
      }
    }*/

    setState(() {
      _proAPI = result;
      _dataAPI = CovidTodayResult.fromJson(b[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    var O = _dataAPI?.totalCase;
    var P = _dataAPI?.totalCaseExcludeabroad;
    int? I;

    //print(_dataAPI!.newCase);

    _proAPI.sort((a, b) => b.newCase.compareTo(a.newCase));

    if (O != null && P != null) {
      setState(() {
        I = (int.parse('${_dataAPI?.totalCase}') -
            int.parse('${_dataAPI?.totalCaseExcludeabroad}'));
        //print(I);
      });
    }

    return Scaffold(
        backgroundColor: _bgcolor,
        appBar: _appbar,
        body: PageView(
          children: [
            Container(
              child: SafeArea(
                child: ListView(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Card(
                      elevation: 20,
                      shadowColor: Colors.green,
                      margin: const EdgeInsets.all(30.0),
                      color: Colors.white,
                      child: Container(
                        margin: const EdgeInsets.all(20.0),
                        child: Text(
                          "UPDATE.TIME\n${_dataAPI?.updateDate.toString().split(' ')[0] ?? "Loading"}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ]),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                    child: Wrap(
                      spacing: 30,
                      children: [
                        Card(
                          elevation: 20,
                          margin: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          shadowColor: Colors.green,
                          color: Colors.white,
                          child: ListTile(
                            minLeadingWidth: 20,
                            leading: const Icon(Icons.person_add_alt),
                            iconColor: Colors.blue,
                            title: Text('ผู้ติดเชื้อวันนี้',
                                style: TextStyle(color: Colors.teal.shade700)),
                            subtitle: Text(" ${_dataAPI?.newCase ?? "Loading"}",
                                style: const TextStyle(color: Colors.blue)),
                            trailing: const Icon(Icons.auto_graph_outlined),
                          ),
                        ),
                        Card(
                          elevation: 20,
                          margin: const EdgeInsets.all(20.0),
                          shadowColor: Colors.green,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: ListTile(
                            minLeadingWidth: 20,
                            leading:
                                const Icon(Icons.airplanemode_active_sharp),
                            iconColor: Colors.black,
                            title: Text(
                              'ไม่รวมจากต่างประเทศ',
                              style: TextStyle(color: Colors.teal.shade700),
                            ),
                            subtitle: Text(
                                " ${_dataAPI?.newCaseExcludeabroad ?? "Loading"}",
                                style: const TextStyle(color: Colors.blue)),
                            trailing: const Icon(Icons.location_city),
                          ),
                        ),
                        Card(
                          elevation: 20,
                          margin: const EdgeInsets.all(20.0),
                          shadowColor: Colors.green,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: ListTile(
                            minLeadingWidth: 20,
                            leading: const Icon(Icons.local_hospital_rounded),
                            iconColor: Colors.green,
                            title: Text('รักษาหายแล้ว',
                                style: TextStyle(color: Colors.teal.shade700)),
                            subtitle: Text(
                              " ${_dataAPI?.newRecovered ?? "Loading"}",
                              style: TextStyle(color: Colors.green.shade700),
                            ),
                            trailing: Icon(Icons.health_and_safety),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          margin: const EdgeInsets.all(20.0),
                          elevation: 20,
                          shadowColor: Colors.green,
                          color: Colors.white,
                          child: ListTile(
                            minLeadingWidth: 20,
                            leading:
                                const Icon(Icons.person_remove_alt_1_sharp),
                            iconColor: Colors.red.shade300,
                            title: Text('เสียชีวิตวันนี้',
                                style: TextStyle(color: Colors.teal.shade700)),
                            subtitle: Text(
                                " ${_dataAPI?.newDeath ?? "Loading"}",
                                style: TextStyle(color: Colors.red.shade400)),
                            trailing:
                                const Icon(Icons.disabled_by_default_sharp),
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ),
            Container(
              child: SafeArea(
                child: ListView(children: [
                  Container(
                    padding: const EdgeInsets.all(30.0),
                    child: Wrap(
                      spacing: 30,
                      children: [
                        Card(
                          elevation: 20,
                          margin: const EdgeInsets.all(20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadowColor: Colors.red.shade700,
                          color: Colors.white,
                          child: ListTile(
                            minLeadingWidth: 20,
                            leading: const Icon(Icons.person_add_alt),
                            iconColor: Colors.blue,
                            title: Text('ผู้ติดเชื้อสะสม',
                                style: TextStyle(color: Colors.teal.shade700)),
                            subtitle: Text(
                                "  ${_dataAPI?.totalCase ?? "Loading"}",
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Card(
                          elevation: 20,
                          margin: const EdgeInsets.all(20.0),
                          shadowColor: Colors.red.shade700,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            minLeadingWidth: 20,
                            leading: Icon(Icons.airplanemode_off_sharp),
                            iconColor: Colors.black,
                            title: Text(
                              'ไม่รวมจากต่างประเทศ',
                              style: TextStyle(color: Colors.teal.shade700),
                            ),
                            subtitle: Text(
                                "  ${_dataAPI?.totalCaseExcludeabroad ?? "Loading"}",
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Card(
                          elevation: 20,
                          margin: EdgeInsets.all(20.0),
                          shadowColor: Colors.red.shade700,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            minLeadingWidth: 20,
                            leading: const Icon(Icons.local_airport),
                            iconColor: Colors.blue,
                            title: Text('มาจากต่างปะเทศ',
                                style: TextStyle(color: Colors.teal.shade700)),
                            subtitle: Text(
                              "  ${I ?? "Loading"} ",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 20,
                          margin: EdgeInsets.all(20.0),
                          shadowColor: Colors.red.shade700,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            minLeadingWidth: 20,
                            leading: Icon(Icons.local_hospital_rounded),
                            iconColor: Colors.green,
                            title: Text('รักษาหาย',
                                style: TextStyle(color: Colors.teal.shade700)),
                            subtitle: Text(
                              "  ${_dataAPI?.totalRecovered ?? "Loading"}",
                              style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: EdgeInsets.all(20.0),
                          elevation: 20,
                          shadowColor: Colors.red.shade700,
                          color: Colors.white,
                          child: ListTile(
                            minLeadingWidth: 20,
                            leading: Icon(Icons.person_remove_alt_1_sharp),
                            iconColor: Colors.red.shade300,
                            title: Text('เสียชีวิตรวม',
                                style: TextStyle(color: Colors.teal.shade700)),
                            subtitle: Text(
                                "  ${_dataAPI?.totalDeath ?? "Loading"}",
                                style: TextStyle(
                                    color: Colors.red.shade400,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ),
            Container(
              child: ListView.builder(
                itemCount: _proAPI.length,
                itemBuilder: (BuildContext context, int index) {
                  if (_proAPI[index].newCase > 0) {
                    return Wrap(
                        direction: Axis.horizontal,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          Container(
                            padding:
                                EdgeInsets.only(left: 40, right: 40, top: 22),
                            child: Card(
                              child: ListTile(
                                title: Text(_proAPI[index].province,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    "จำนวนติดเชื้อ : " +
                                        _proAPI[index].newCase.toString(),
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(color: Colors.red.shade300)),
                              ),
                            ),
                          )
                        ]);
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
          controller: _pageController,
          onPageChanged: onPageChange,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: "Today",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.access_time_filled),
              label: 'ALL TIME',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.privacy_tip),
              label: 'Province',
            ),
          ],
          currentIndex: _page,
          onTap: navTopage,
        ));
  }

  void navTopage(int page) {
    _pageController?.animateToPage(page,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChange(int page) {
    Color? _tembgcolor;
    Widget? _temptitleOn;
    Widget? _tappbar;
    switch (page) {
      case 0:
        _temptitleOn = const Text("Today Covid-19");
        _tembgcolor = Colors.blue.shade100;
        _tappbar = AppBar(
          title: _temptitleOn,
        );
        break;
      case 1:
        _temptitleOn = const Text("All Time Covid-19");
        _tembgcolor = Colors.pink.shade50;
        _tappbar = AppBar(
          title: _temptitleOn,
        );
        break;
      case 2:
        _temptitleOn = const Text('Province');
        _tembgcolor = Colors.purple.shade100;
        _tappbar = AppBar(
          title: _temptitleOn,
        );
        break;
    }
    setState(() {
      _titleOn = _temptitleOn ?? Text('Covid-19');
      _page = page;
      _bgcolor = _tembgcolor ??= Colors.white;
      _appbar = _tappbar;
    });
  }
}
