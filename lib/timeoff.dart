// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:Shrine/services/fetch_location.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:Shrine/services/gethome.dart';
import 'package:Shrine/services/saveimage.dart';
import 'package:Shrine/model/timeinout.dart';
import 'attendance_summary.dart';
import 'punchlocation.dart';
import 'drawer.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:datetime_picker_formfield/time_picker_formfield.dart';
import 'package:Shrine/model/model.dart' as TimeOffModal;
import 'package:Shrine/services/newservices.dart';
import 'timeoff_summary.dart';
import 'settings.dart';
import 'home.dart';
import 'reports.dart';
import 'profile.dart';

// This app is a stateful, it tracks the user's current choice.
class TimeOffPage extends StatefulWidget {
  @override
  _TimeOffPageState createState() => _TimeOffPageState();
}

class _TimeOffPageState extends State<TimeOffPage> {
  bool isloading = false;
  final _dateController = TextEditingController();
  final _starttimeController = TextEditingController();
  final _endtimeController = TextEditingController();
  final _reasonController = TextEditingController();
  TimeOfDay starttime;
  TimeOfDay endtime;
  FocusNode textSecondFocusNode = new FocusNode();
  FocusNode textthirdFocusNode = new FocusNode();
  FocusNode textfourthFocusNode = new FocusNode();
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy");
  final timeFormat = DateFormat("H:mm");
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _defaultimage = new NetworkImage(
      "http://ubiattendance.ubihrm.com/assets/img/avatar.png");
  var profileimage;
  bool _checkLoaded = true;
  bool _isButtonDisabled=false;
  int _currentIndex = 1;
  bool _visible = true;
  String location_addr="";
  String location_addr1="";
  String admin_sts='0';
  String act="";
  String act1="";
  int response;
  String fname="", lname="", empid="", email="", status="", orgid="", orgdir="", sstatus="", org_name="", desination="", profile,latit="",longi="";
  String aid="";
  String shiftId="";
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    empid = prefs.getString('empid') ?? '';
    orgdir = prefs.getString('orgdir') ?? '';
    admin_sts = prefs.getString('sstatus') ?? '0';
    response = prefs.getInt('response') ?? 0;
    if(response==1) {
      Loc lock = new Loc();
      location_addr = await lock.initPlatformState();

      Home ho = new Home();
      act = await ho.checkTimeIn(empid, orgdir);

      print("this is main "+location_addr);
      setState(() {
        location_addr1 = location_addr;
        response = prefs.getInt('response') ?? 0;
        fname = prefs.getString('fname') ?? '';
        lname = prefs.getString('lname') ?? '';
        empid = prefs.getString('empid') ?? '';
        email = prefs.getString('email') ?? '';
        status = prefs.getString('status') ?? '';
        orgid = prefs.getString('orgid') ?? '';
        orgdir = prefs.getString('orgdir') ?? '';
        sstatus = prefs.getString('sstatus') ?? '';
        org_name = prefs.getString('org_name') ?? '';
        desination = prefs.getString('desination') ?? '';
        profile = prefs.getString('profile') ?? '';

        profileimage = new NetworkImage(profile);
        print("1-"+profile);
        profileimage.resolve(new ImageConfiguration()).addListener((_, __) {
          if (mounted) {
            setState(() {
              _checkLoaded = false;
            });
          }
        });
        print("2-"+_checkLoaded.toString());
        latit = prefs.getString('latit') ?? '';
        longi = prefs.getString('longi') ?? '';
        aid = prefs.getString('aid') ?? "";
        shiftId = prefs.getString('shiftId') ?? "";
        print("this is set state "+location_addr1);
        act1=act;
        print(act1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (response==0) ? new LoginPage() : getmainhomewidget();
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(value,textAlign: TextAlign.center,));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
  Future<bool> sendToHome() async{
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );*/
    print("-------> back button pressed");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => TimeoffSummary()), (Route<dynamic> route) => false,
    );
    return false;
  }

  getmainhomewidget(){
    return new WillPopScope(
        onWillPop: ()=> sendToHome(),
    child: Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(org_name, style: new TextStyle(fontSize: 20.0)),
          ],
        ),
        leading: IconButton(icon:Icon(Icons.arrow_back),onPressed:(){
          Navigator.of(context).pop();
        },),
        backgroundColor: Colors.teal,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (newIndex) {
          if(newIndex==2){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
            );
            return;
          }
          if(newIndex==1){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            return;
          }else if (newIndex == 0) {
            (admin_sts == '1')
                ? Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Reports()),
            )
                : Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
            return;
          }
          setState((){_currentIndex = newIndex;});
        }, // this will be set when a new tab is tapped
        items: [
          (admin_sts == '1')
              ? BottomNavigationBarItem(
            icon: new Icon(
              Icons.library_books,
            ),
            title: new Text('Reports'),
          )
              : BottomNavigationBarItem(
            icon: new Icon(
              Icons.person,
            ),
            title: new Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.home,color: Colors.black54,),
            title: new Text('Home',style: TextStyle(color: Colors.black54),),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings')
          )
        ],
      ),
      endDrawer: new AppDrawer(),
      body: (act1=='') ? Center(child : loader()) : checkalreadylogin(),
    ),
    );
  }
  checkalreadylogin(){
    if(response==1) {
      return new IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          underdevelopment(),
          mainbodyWidget(),
          underdevelopment()
        ],
      );
    }else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }
  loader(){
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset(
                  'assets/spinner.gif', height: 50.0, width: 50.0),
            ]),
      ),
    );
  }
  underdevelopment(){
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.android,color: Colors.teal,),Text("Under development",style: new TextStyle(fontSize: 30.0,color: Colors.teal),)
            ]),
      ),
    );
  }

  mainbodyWidget(){
    return Center(
      child: Form(
        key: _formKey,
        child: SafeArea(
          child: Column( children: <Widget>[
            SizedBox(height: 20.0),
            Text('Mark Time Off',
                style: new TextStyle(fontSize: 22.0, color: Colors.teal)),
            new Divider(color: Colors.black54,height: 1.5,),
          new Expanded(child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  DateTimePickerFormField(
                    firstDate: new DateTime.now(),
                    initialDate: new DateTime.now(),
                    dateOnly: true,
                    format: dateFormat,
                    controller: _dateController,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.date_range,
                          color: Colors.grey,
                        ), // icon is 48px widget.
                      ), // icon is 48px widget.

                      labelText: 'Date',
                    ),
                    validator: (date) {
                      if (date==null){
                        return 'Please enter the date for Time off';
                      }
                    },
                  ), //Enter date
                  Row(
                    children: <Widget>[
                      Expanded(
                        child:TimePickerFormField(
                          initialTime: new TimeOfDay.now(),
                          format: timeFormat,
                          controller: _starttimeController,
                          decoration: InputDecoration(
                            labelText: 'From',
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Icon(
                                Icons.alarm,
                                color: Colors.grey,
                              ), // icon is 48px widget.
                            ),
                          ),
                          validator: (time) {
                            if (time==null) {
                              return 'Please enter the Start Time';
                            }
                          },
                            onChanged: (dt) {
                              setState(() {
                                starttime = dt;
                              });
                              print("----->Changed Time------> "+starttime.toString());
                            }
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child:TimePickerFormField(
                          initialTime: new TimeOfDay.now(),
                          format: timeFormat,
                          controller: _endtimeController,
                          decoration: InputDecoration(
                            labelText: 'To',
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Icon(
                                Icons.alarm,
                                color: Colors.grey,
                              ), // icon is 48px widget.
                            ),
                          ),
                          onChanged: (dt) {
                            setState(() {
                              endtime = dt;
                            });

                            print("------> End Time"+_endtimeController.text);
                          },
                          validator: (time) {
                            if (time==null) {
                              return 'Please enter the End Time';
                            }

                            var arr=_starttimeController.text.split(':');
                            var arr1=_endtimeController.text.split(':');
                            final startTime = DateTime(2018, 6, 23,int.parse(arr[0]),int.parse(arr[1]),00,00);
                            final endTime = DateTime(2018, 6, 23,int.parse(arr1[0]),int.parse(arr1[1]),00,00);
                            if(endTime.isBefore(startTime)){
                              return '\"End Time\" can\'t be earlier then the Start Time.';
                            }



                          },
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _reasonController,
                    decoration: InputDecoration(
                        labelText: 'Reason',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Icon(
                            Icons.event_note,
                            color: Colors.grey,
                          ), // icon is 48px widget.
                        )
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the reason';
                      }
                    },
                    onFieldSubmitted: (String value) {
                      if (_formKey.currentState.validate()) {
                        requesttimeoff(_dateController.text ,_starttimeController.text,_endtimeController.text,_reasonController.text, context);
                      }
                    },
                    maxLines: 3,
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        shape: Border.all(color: Colors.black54),
                        child: Text('CANCEL'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TimeoffSummary()),
                          );
                        },
                      ),
                      RaisedButton(
                       /* child: _isButtonDisabled?Row(children: <Widget>[Text('Processing ',style: TextStyle(color: Colors.white),),SizedBox(width: 10.0,), SizedBox(child:CircularProgressIndicator(),height: 20.0,width: 20.0,),],):Text('SAVE',style: TextStyle(color: Colors.white),),*/
                        child: _isButtonDisabled?Text('Processing..',style: TextStyle(color: Colors.white),):Text('SAVE',style: TextStyle(color: Colors.white),),
                        color: Colors.orangeAccent,
                        onPressed: () {

                          if (_formKey.currentState.validate()) {
                            if(_isButtonDisabled)
                              return null;
                            setState(() {
                              _isButtonDisabled=true;
                            });
                            requesttimeoff(_dateController.text ,_starttimeController.text,_endtimeController.text,_reasonController.text, context);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),

            ],
          ),
          )
      ]
          )
        ),
      ),
    );
  }

  requesttimeoff(var timeoffdate,var starttime,var endtime,var reason, BuildContext context) async{
    final prefs = await SharedPreferences.getInstance();
    String empid = prefs.getString("empid");
    String orgid = prefs.getString("orgid");
    //var timeoff = TimeOffModal.TimeOff(Time timeoffdate, starttime, endtime, reason, empid, orgid);
    var timeoff = TimeOffModal.TimeOff(TimeofDate: timeoffdate,TimeFrom: starttime, TimeTo: endtime, Reason: reason, EmpId: empid, OrgId: orgid);
    RequestTimeOffService request =new RequestTimeOffService();
    var islogin = await request.requestTimeOff(timeoff);
    print("--->"+islogin);
    if(islogin=="success"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TimeoffSummary()),
      );
      setState(() {
        _isButtonDisabled=false;
      });
    }else if(islogin=="No Connection"){
      showInSnackBar("Poor Network Connection");
      setState(() {
        _isButtonDisabled=false;
      });
    }else {
      showInSnackBar(islogin);
      setState(() {
        _isButtonDisabled=false;
      });
    }
  }
}