// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:Shrine/services/services.dart';
import 'outside_label.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';
import 'Image_view.dart';
// This app is a stateful, it tracks the user's current choice.
class YesAttendance extends StatefulWidget {
  @override
  _YesAttendance createState() => _YesAttendance();
}
String _orgName;
class _YesAttendance extends State<YesAttendance> with SingleTickerProviderStateMixin {
  TabController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Map<String,String>> chartData;
  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value,textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
  getOrgName() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _orgName= prefs.getString('org_name') ?? '';
    });
  }
  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 4, vsync: this);
    getOrgName();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(_orgName, style: new TextStyle(fontSize: 20.0)),
        backgroundColor: Colors.teal,
      ),
      endDrawer: new AppDrawer(),
      body: new ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          new Container(
            child: Center(child:Text("Yesterday's Attendance",style: TextStyle(fontSize: 22.0,color: Colors.black54,),),),
          ),
          new Container(
            padding: EdgeInsets.all(0.1),
            margin: EdgeInsets.all(0.1),
            child: new ListTile(
              title: new SizedBox(height: MediaQuery.of(context).size.height*0.30,

                child: new FutureBuilder<List<Map<String,String>>>(
                    future: getChartDataYes(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.length > 0) {
                          return new PieOutsideLabelChart.withRandomData(snapshot.data);
                        }
                      }
                      return new Center( child: CircularProgressIndicator());
                    }
                ),

                //  child: new PieOutsideLabelChart.withRandomData(),

                width: MediaQuery.of(context).size.width*1.0,),
            ),
          ),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Early Leavers(EL)',style: TextStyle(color:Colors.black87,fontSize: 12.0),),
              Text('Late Comers(LC)',style: TextStyle(color:Colors.black87,fontSize: 12.0),),
              Text('Absent(A)',style: TextStyle(color:Colors.black87,fontSize: 12.0),),
              Text('Present(P)',style: TextStyle(color:Colors.black87,fontSize: 12.0),),
            ],
          ),
          Divider(),
          new Container(
            decoration: new BoxDecoration(color: Colors.black54),
            child: new TabBar(
              indicator: BoxDecoration(color: Colors.orangeAccent,),
              controller: _controller,
              tabs: [
                new Tab(
                  text: 'Present',
                ),
                new Tab(
                  text: 'Absent',
                ),
                new Tab(
                  text: 'Late \nComers',
                ),
                new Tab(
                  text: 'Early \nLeavers',
                ),
              ],
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 50.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.46,
                child:Text('Name',style: TextStyle(color: Colors.teal,fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
              SizedBox(height: 50.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.22,
                child:Text('Time In',style: TextStyle(color: Colors.teal,fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
              SizedBox(height: 50.0,),
              Container(
                width: MediaQuery.of(context).size.width*0.22,
                child:Text('Time Out',style: TextStyle(color: Colors.teal,fontWeight:FontWeight.bold,fontSize: 16.0),),
              ),
            ],
          ),
          new Divider(height: 1.0,),
          new Container(
            height: MediaQuery.of(context).size.height*0.30,
            child: new TabBarView(
              controller: _controller,
              children: <Widget>[
                new Container(
                  height: MediaQuery.of(context).size.height*0.3,
                  //   shape: Border.all(color: Colors.deepOrange),
                  child: new ListTile(
                    title:
                    Container( height: MediaQuery.of(context).size.height*.30,
                      //width: MediaQuery.of(context).size.width*.99,
                      color: Colors.white,
                      //////////////////////////////////////////////////////////////////////---------------------------------
                      child: new FutureBuilder<List<Attn>>(
                        future: getYesAttn('present'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: <Widget>[
                                              SizedBox(height: 40.0,),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.46,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    Text(snapshot.data[index].Name
                                                        .toString(), style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16.0),),

                                                    InkWell(
                                                      child: Text('Time In: ' +
                                                          snapshot.data[index]
                                                              .CheckInLoc.toString(),
                                                          style: TextStyle(
                                                              color: Colors.black54,
                                                              fontSize: 12.0)),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitIn ,
                                                            snapshot.data[index]
                                                                .LongiIn);
                                                      },
                                                    ),
                                                    SizedBox(height:2.0),
                                                    InkWell(
                                                      child: Text('Time Out: ' +
                                                          snapshot.data[index]
                                                              .CheckOutLoc.toString(),
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                            fontSize: 12.0),),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitOut,
                                                            snapshot.data[index]
                                                                .LongiOut);
                                                      },
                                                    ),
                                                    SizedBox(height: 15.0,),


                                                  ],
                                                ),
                                              ),

                                              Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.22,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      Text(snapshot.data[index].TimeIn
                                                          .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Container(
                                                        width: 62.0,
                                                        height: 62.0,
                                                        child:InkWell(
                                                          child: Container(
                                                            decoration: new BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image: new DecorationImage(
                                                                    fit: BoxFit.fill,
                                                                    image: new NetworkImage(
                                                                        snapshot
                                                                            .data[index]
                                                                            .EntryImage)
                                                                )
                                                            )),
                                                          onTap: (){
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].EntryImage,org_name: _orgName)),
                                                            );
                                                          },
                                    ),
                                    ),

                                                    ],
                                                  )

                                              ),
                                              Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.22,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      Text(snapshot.data[index].TimeOut
                                                          .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Container(
                                                        width: 62.0,
                                                        height: 62.0,
                                                        child:InkWell(
                                                        child: Container(
                                                            decoration: new BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image: new DecorationImage(
                                                                    fit: BoxFit.fill,
                                                                    image: new NetworkImage(
                                                                        snapshot
                                                                            .data[index]
                                                                            .ExitImage)
                                                                )
                                                            )),
                                                          onTap: (){
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(builder: (context) => ImageView(myimage: snapshot.data[index].ExitImage,org_name: _orgName)),
                                                            );
                                                          },
                                    ),
                                    ),

                                                    ],
                                                  )

                                              ),
                                            ],

                                          ),
                                          Divider(color: Colors.black26,),
                                        ]); }
                              );
                            }else{
                              return new Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width*1,
                                  color: Colors.teal.withOpacity(0.1),
                                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                  child:Text("No one was present yesterday ",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                                ),
                              );
                            }
                          }
                          else if (snapshot.hasError) {
                             return new Text("Unable to connect server");
                          }

                          // By default, show a loading spinner
                          return new Center( child: CircularProgressIndicator());
                        },
                      ),
                      //////////////////////////////////////////////////////////////////////---------------------------------
                    ),
                  ),
                ),
                //////////////TABB 2 Start
                new Container(

                  height: MediaQuery.of(context).size.height*0.3,
                  //   shape: Border.all(color: Colors.deepOrange),
                  child: new ListTile(
                    title:
                    Container( height: MediaQuery.of(context).size.height*.3,
                      //width: MediaQuery.of(context).size.width*.99,
                      color: Colors.white,
                      //////////////////////////////////////////////////////////////////////---------------------------------
                      child: new FutureBuilder<List<Attn>>(
                        future: getYesAttn('absent'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceAround,
                                      children: <Widget>[
                                        SizedBox(height: 40.0,),
                                        Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.46,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              Text(snapshot.data[index].Name
                                                  .toString(), style: TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0),),
                                            ],
                                          ),
                                        ),

                                        Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.22,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              children: <Widget>[
                                                Text(snapshot.data[index].TimeIn
                                                    .toString()),
                                              ],
                                            )

                                        ),
                                        Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.22,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              children: <Widget>[
                                                Text(snapshot.data[index].TimeOut
                                                    .toString()),
                                              ],
                                            )

                                        ),
                                      ],

                                    );
                                  }
                              );
                            }else{
                              return new Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width*1,
                                  color: Colors.teal.withOpacity(0.1),
                                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                  child:Text("No one was absent yesterday",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                                ),
                              );
                            }
                          }
                          else if (snapshot.hasError) {
                             return new Text("Unable to connect to server");
                          }

                          // By default, show a loading spinner
                          return new Center( child: CircularProgressIndicator());
                        },
                      ),
                      //////////////////////////////////////////////////////////////////////---------------------------------
                    ),
                  ),

                ),

                /////////////TAB 2 Ends



                /////////////TAB 3 STARTS

                new Container(

                  height: MediaQuery.of(context).size.height*0.3,
                  //   shape: Border.all(color: Colors.deepOrange),
                  child: new ListTile(
                    title:
                    Container( height: MediaQuery.of(context).size.height*.3,
                      //width: MediaQuery.of(context).size.width*.99,
                      color: Colors.white,
                      //////////////////////////////////////////////////////////////////////---------------------------------
                      child: new FutureBuilder<List<Attn>>(
                        future: getYesAttn('latecomings'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: <Widget>[
                                              SizedBox(height: 40.0,),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.46,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    Text(snapshot.data[index].Name
                                                        .toString(), style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16.0),),

                                                    InkWell(
                                                      child: Text('Time In: ' +
                                                          snapshot.data[index]
                                                              .CheckInLoc.toString(),
                                                          style: TextStyle(
                                                              color: Colors.black54,
                                                              fontSize: 12.0)),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitIn ,
                                                            snapshot.data[index]
                                                                .LongiIn);
                                                      },
                                                    ),
                                                    SizedBox(height:2.0),
                                                    InkWell(
                                                      child: Text('Time Out: ' +
                                                          snapshot.data[index]
                                                              .CheckOutLoc.toString(),
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                            fontSize: 12.0),),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitOut,
                                                            snapshot.data[index]
                                                                .LongiOut);
                                                      },
                                                    ),
                                                    SizedBox(height: 15.0,),


                                                  ],
                                                ),
                                              ),

                                              Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.22,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      Text(snapshot.data[index].TimeIn
                                                          .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Container(
                                                        width: 62.0,
                                                        height: 62.0,
                                                        child: Container(
                                                            decoration: new BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image: new DecorationImage(
                                                                    fit: BoxFit.fill,
                                                                    image: new NetworkImage(
                                                                        snapshot
                                                                            .data[index]
                                                                            .EntryImage)
                                                                )
                                                            )),),

                                                    ],
                                                  )

                                              ),
                                              Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.22,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      Text(snapshot.data[index].TimeOut
                                                          .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Container(
                                                        width: 62.0,
                                                        height: 62.0,
                                                        child: Container(
                                                            decoration: new BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image: new DecorationImage(
                                                                    fit: BoxFit.fill,
                                                                    image: new NetworkImage(
                                                                        snapshot
                                                                            .data[index]
                                                                            .ExitImage)
                                                                )
                                                            )),),

                                                    ],
                                                  )

                                              ),
                                            ],

                                          ),
                                          Divider(color: Colors.black26,),
                                        ]);
                                  }
                              );
                            }else{
                              return new Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width*1,
                                  color: Colors.teal.withOpacity(0.1),
                                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                  child:Text("No late comers yesterday ",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                                ),
                              );
                            }
                          }
                          else if (snapshot.hasError) {
                             return new Text("Unable to connect to server");
                          }

                          // By default, show a loading spinner
                          return new Center( child: CircularProgressIndicator());
                        },
                      ),
                      //////////////////////////////////////////////////////////////////////---------------------------------
                    ),
                  ),

                ),
                /////////TAB 3 ENDS


                /////////TAB 4 STARTS
                new Container(


                  height: MediaQuery.of(context).size.height*0.3,
                  //   shape: Border.all(color: Colors.deepOrange),
                  child: new ListTile(
                    title:
                    Container( height: MediaQuery.of(context).size.height*.3,
                      //width: MediaQuery.of(context).size.width*.99,
                      color: Colors.white,
                      //////////////////////////////////////////////////////////////////////---------------------------------
                      child: new FutureBuilder<List<Attn>>(
                        future: getYesAttn('earlyleavings'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data.length>0) {
                              return new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return new Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: <Widget>[
                                              SizedBox(height: 40.0,),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.46,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    Text(snapshot.data[index].Name
                                                        .toString(), style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16.0),),

                                                    InkWell(
                                                      child: Text('Time In: ' +
                                                          snapshot.data[index]
                                                              .CheckInLoc.toString(),
                                                          style: TextStyle(
                                                              color: Colors.black54,
                                                              fontSize: 12.0)),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitIn ,
                                                            snapshot.data[index]
                                                                .LongiIn);
                                                      },
                                                    ),
                                                    SizedBox(height:2.0),
                                                    InkWell(
                                                      child: Text('Time Out: ' +
                                                          snapshot.data[index]
                                                              .CheckOutLoc.toString(),
                                                        style: TextStyle(
                                                            color: Colors.black54,
                                                            fontSize: 12.0),),
                                                      onTap: () {
                                                        goToMap(
                                                            snapshot.data[index]
                                                                .LatitOut,
                                                            snapshot.data[index]
                                                                .LongiOut);
                                                      },
                                                    ),
                                                    SizedBox(height: 15.0,),


                                                  ],
                                                ),
                                              ),

                                              Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.22,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      Text(snapshot.data[index].TimeIn
                                                          .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Container(
                                                        width: 62.0,
                                                        height: 62.0,
                                                        child: Container(
                                                            decoration: new BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image: new DecorationImage(
                                                                    fit: BoxFit.fill,
                                                                    image: new NetworkImage(
                                                                        snapshot
                                                                            .data[index]
                                                                            .EntryImage)
                                                                )
                                                            )),),

                                                    ],
                                                  )

                                              ),
                                              Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.22,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      Text(snapshot.data[index].TimeOut
                                                          .toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Container(
                                                        width: 62.0,
                                                        height: 62.0,
                                                        child: Container(
                                                            decoration: new BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image: new DecorationImage(
                                                                    fit: BoxFit.fill,
                                                                    image: new NetworkImage(
                                                                        snapshot
                                                                            .data[index]
                                                                            .ExitImage)
                                                                )
                                                            )),),

                                                    ],
                                                  )

                                              ),
                                            ],

                                          ),
                                          Divider(color: Colors.black26,),
                                        ]);
                                  }
                              );
                            }else{
                              return new Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width*1,
                                  color: Colors.teal.withOpacity(0.1),
                                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                                  child:Text("No early leavers yesterday ",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                                ),
                              );
                            }
                          }
                          else if (snapshot.hasError) {
                            return new Text("Unable to connect server");
                          }

                          // By default, show a loading spinner
                          return new Center( child: CircularProgressIndicator());
                        },
                      ),
                      //////////////////////////////////////////////////////////////////////---------------------------------
                    ),
                  ),
                ),
                ///////////////////TAB 4 Ends
              ],
            ),
          ),
        ],
      ),
    );
  }
}
