import 'package:comic_app/functions/get.dart';
import 'package:comic_app/pages/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';

import 'models/issues_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ComicBook',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'ComicBook'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var scrollcontroller = ScrollController();
  bool listView = true;
  List<Issues> data = <Issues>[];
  var numOfData = 100;
  @override
  void initState() {
    getIssues('&field_list=image,date_added,name,issue_number,api_detail_url')
        .then((value) {
      setState(() {
        data = value;
        numOfData = value.length;
      });
    });
    scrollcontroller.addListener(pagination);
    super.initState();
  }

  void pagination() {
    if ((scrollcontroller.position.pixels ==
        scrollcontroller.position.maxScrollExtent)) {
      getIssues(
              '&field_list=image,date_added,name,api_detail_url,issue_number&offset=' +
                  data.length.toString())
          .then((value) {
        setState(() {
          data.addAll(value);
          numOfData = numOfData + value.length;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(widget.title)),
        ),
        extendBody: true,
        body: Column(
          children: [
            listOrGrid(context),
            Expanded(
              child: firstView(context),
            )
          ],
        ));
  }

  Widget listOrGrid(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            color: listView ? Colors.transparent : Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.list,
                    color: listView ? Colors.black : Colors.white,
                  ),
                  Text(
                    'List',
                    style: TextStyle(
                        color: listView ? Colors.black : Colors.white),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            setState(() {
              listView = true;
            });
          },
        ),
        GestureDetector(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            color: listView ? Colors.red : Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.grid_on,
                    color: listView ? Colors.white : Colors.black,
                  ),
                  Text(
                    'Grid',
                    style: TextStyle(
                        color: listView ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            setState(() {
              listView = false;
            });
          },
        )
      ],
    );
  }

  firstView(context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    double comicsPerColumn = 200;
    if (width > 700) {
      comicsPerColumn = 500;
    } else {
      comicsPerColumn = 200;
    }
    return view(comicsPerColumn, width, height);
  }

  Widget view(double comicsPerColumn, double width, double height) {
    Scrollbar body;

    if (listView) {
      body = Scrollbar(
        child: ListView.builder(
            controller: scrollcontroller,
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SlideInLeft(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            child: SizedBox(
                              width: width * 0.3,
                              child: Image.network(
                                data[index].image,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context, child,
                                    loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                      child: CircularProgressIndicator());
                                },
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                          title: data[index].name,
                                          image: data[index].image,
                                          api_detail_url:
                                              data[index].api_detail_url,
                                        )),
                              );
                            },
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width * 0.5,
                                child: AutoSizeText(
                                  data[index].name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Divider(),
                              SizedBox(
                                width: width * 0.5,
                                child: Text(
                                  data[index].date_added,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey[700],
                      )
                    ],
                  ),
                ),
              );
            }),
      );
    } else {
      body = Scrollbar(
        child: GridView.builder(
          controller: scrollcontroller,
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: comicsPerColumn,
              childAspectRatio: 1 / 1.4,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0),
          padding: const EdgeInsets.all(10),
          // Generate 100 widgets that display their index in the List.
          itemCount: data.length,
          itemBuilder: (BuildContext ctx, index) {
            return Center(
              child: SlideInRight(
                child: Column(
                  children: [
                    SizedBox(
                      width: width * 0.25,
                      child: GestureDetector(
                        child: Image.network(
                          data[index].image,
                          fit: BoxFit.cover,
                          loadingBuilder:
                              (BuildContext context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage(
                                      title: data[index].name,
                                      image: data[index].image,
                                      api_detail_url:
                                          data[index].api_detail_url,
                                    )),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: width * 0.25,
                      child: AutoSizeText(
                        data[index].name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.25,
                      child: Text(
                        data[index].date_added,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
    return body;
  }
}
