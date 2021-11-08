import 'package:comic_app/functions/get.dart';
import 'package:comic_app/models/issue_model.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DetailPage extends StatefulWidget {
  const DetailPage(
      {Key? key,
      required this.title,
      required this.image,
      // ignore: non_constant_identifier_names
      required this.api_detail_url})
      : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final title;
  // ignore: prefer_typing_uninitialized_variables
  final image;
  // ignore: non_constant_identifier_names, prefer_typing_uninitialized_variables
  final api_detail_url;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<Issue> data = [];
  // ignore: non_constant_identifier_names
  var character_credits = [];
  // ignore: non_constant_identifier_names
  var team_credits = [];
  // ignore: non_constant_identifier_names
  var location_credits = [];
  int numOfData = 0;
  @override
  void initState() {
    super.initState();
    getIssue(widget.api_detail_url,
            'character_credits,team_credits,location_credits')
        .then((value) {
      setState(() {
        data = value;

        character_credits = data[0].character_credits;
        team_credits = data[0].team_credits;
        location_credits = data[0].location_credits;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: SlideInUp(child: Center(child: Text(widget.title))),
        ),
        extendBody: true,
        body: Column(
          children: [
            SlideInDown(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Image.network(
                    widget.image,
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                character_credits.isNotEmpty ? 'Characters' : '',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            createDescription(character_credits),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                team_credits.isNotEmpty ? 'Teams' : '',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            createDescription(team_credits),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                location_credits.isNotEmpty ? 'Locations' : '',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            createDescription(location_credits)
          ],
        ));
  }

  Widget createDescription(List value) {
    if (value.isNotEmpty) {
      return Expanded(
        child: Center(
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: value.length,
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
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Image.network(
                                value[index]['image'] ??
                                    'https://th.bing.com/th/id/R.440b9b231a84584c31de471bd31d0985?rik=h2wp8%2bvELm10DQ&pid=ImgRaw&r=0',
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context, child,
                                    loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                      child: CircularProgressIndicator());
                                },
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: AutoSizeText(
                                value[index]['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      );
    } else {
      return Container();
    }
  }
}
