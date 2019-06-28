import 'package:flutter/material.dart';
import 'drawer.dart';
import 'package:Shrine/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'profile.dart';
import 'reports.dart';
import 'settings.dart';
import 'home.dart';

class TimeOffList extends StatefulWidget {
  @override
  _TimeOffList createState() => _TimeOffList();
}
TextEditingController today;

//FocusNode f_dept ;
class _TimeOffList extends State<TimeOffList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 1;
  String _orgName;
  String emp='0';
  bool res = true;
  String admin_sts='0';
  var formatter = new DateFormat('dd-MMM-yyyy');
  @override
  void initState() {
    super.initState();
    today = new TextEditingController();
    today.text = formatter.format(DateTime.now());
    // f_dept = FocusNode();
    getOrgName();
  }

  getOrgName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _orgName = prefs.getString('org_name') ?? '';
      admin_sts = prefs.getString('sstatus') ?? '0';
    });
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
        content: Text(
          value,
          textAlign: TextAlign.center,
        ));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return getmainhomewidget();
  }

  getmainhomewidget() {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(_orgName, style: new TextStyle(fontSize: 20.0)),

            /*  Image.asset(
                    'assets/logo.png', height: 40.0, width: 40.0),*/
          ],
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
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
          },
          // this will be set when a new tab is tapped
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
            title: new Text('Home',style: TextStyle(color: Colors.black54)),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('Settings'))
        ],
      ),
      endDrawer: new AppDrawer(),
      body: Container(
        //   padding: EdgeInsets.only(left: 2.0, right: 2.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8.0),
            Center(
              child: Text(
                'Time Off History',
                style: new TextStyle(
                  fontSize: 22.0,
                  color: Colors.black54,
                ),
              ),
            ),
            Divider(
              height: 10.0,
            ),
            getEmployee_DD(),
            SizedBox(height: 2.0),
            Container(
              child: DateTimePickerFormField(
                dateOnly: true,
                format: formatter,
                controller: today,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Icon(
                      Icons.date_range,
                      color: Colors.grey,
                    ), // icon is 48px widget.
                  ), // icon is 48px widget.
                  labelText: 'Select Date',
                ),
                onChanged: (date) {
                  setState(() {
                    if (date != null && date.toString()!='')
                      res = true; //showInSnackBar(date.toString());
                    else
                      res = false;
                  });
                },
                validator: (date) {
                  if (date == null) {
                    return 'Please select a date';
                  }
                },
              ),
            ),
            SizedBox(height: 12.0),
            Container(
              //  padding: EdgeInsets.only(bottom:10.0,top: 10.0),
              width: MediaQuery.of(context).size.width * .9,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.37,
                    child: Text(
                      'Name',
                      style: TextStyle(color: Colors.orange),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      'From',
                      style: TextStyle(color: Colors.orange),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text('To',
                        style: TextStyle(color: Colors.orange),
                        textAlign: TextAlign.left),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.12,
                    child: Text('Total Time',
                        style: TextStyle(color: Colors.orange),
                        textAlign: TextAlign.left),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0),
            Divider(
              height: 5.2,
            ),
            new Expanded(
              child: res == true ? getEmpDataList(today.text) : Center(),
            ),
          ],
        ),
      ),
    );
  }

  loader() {
    return new Container(
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset('assets/spinner.gif', height: 50.0, width: 50.0),
            ]),
      ),
    );
  }

  Widget getEmployee_DD() {
    String dc = "0";
    return new FutureBuilder<List<Map>>(
        future: getEmployeesList(0),// with -select- label
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            try {
              return new Container(
                //    width: MediaQuery.of(context).size.width*.45,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Select an Employee',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ), // icon is 48px widget.
                    ),
                  ),

                  child: new DropdownButton<String>(
                    isDense: true,
                    style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.black
                    ),
                    value: emp,
                    onChanged: (String newValue) {
                      setState(() {
                        //  res = false;
                        ///   getEmpDataList(today.text);

                        res = true;
                        emp = newValue;

                        print("Ubiattendance");

                      });


                    },
                    items: snapshot.data.map((Map map) {
                      return new DropdownMenuItem<String>(
                        value: map["Id"].toString(),
                        child: new SizedBox(
                            width: 200.0,
                            child: map["Code"]!=''?new Text(map["Name"]+' ('+map["Code"]+')'):
                            new Text(map["Name"],)),
                      );
                    }).toList(),

                  ),
                ),
              );
            }
            catch(e){
              return Text("EX: Unable to fetch employees");

            }
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return new Text("ER: Unable to fetch employees");
          }
          // return loader();
          return new Center(child: SizedBox(
            child: CircularProgressIndicator(strokeWidth: 2.2,),
            height: 20.0,
            width: 20.0,
          ),);
        });
  }


  getEmpDataList(date) {
    return new FutureBuilder<List<EmpListTimeOff>>(
        future: getTimeOFfDataList(date,emp),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return new ListView.builder(
                  itemCount: snapshot.data.length,
                  //    padding: EdgeInsets.only(left: 15.0,right: 15.0),
                  itemBuilder: (BuildContext context, int index) {
                    return new Column(children: <Widget>[
                      new FlatButton(
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Container(
                                width: MediaQuery.of(context).size.width * 0.37,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text(
                                        snapshot.data[index].name.toString()),

                                  ],
                                )),
                            new Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: new Text(
                                snapshot.data[index].from.toString(),
                              ),
                            ),
                            new Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: new Text(
                                snapshot.data[index].to.toString(),
                              ),
                            ),
                            new Container(
                              width: MediaQuery.of(context).size.width * 0.12,
                              child: new Text(
                                snapshot.data[index].diff.toString(),
                                style: TextStyle(
                                    color:Colors.deepOrange),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          null;
                          //    editDept(context,snapshot.data[index].dept.toString(),snapshot.data[index].status.toString(),snapshot.data[index].id.toString());
                        },
                      ),
                      Divider(
                        color: Colors.blueGrey.withOpacity(0.25),
                        height: 0.2,
                      ),
                    ]);
                  });
            } else {
              return new Center(
                child: Container(
                  width: MediaQuery.of(context).size.width*1,
                  color: Colors.teal.withOpacity(0.1),
                  padding:EdgeInsets.only(top:5.0,bottom: 5.0),
                  child:Text("No one is on Time Off ",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                ),
              );
            }
          } else if (snapshot.hasError) {
             return new Text("Unable to connect to server");
          }
          // return loader();
          return new Center(child: CircularProgressIndicator());
        });
  }
} /////////mail class close
