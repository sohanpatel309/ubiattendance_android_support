import 'model/timeinout.dart';
import 'package:flutter/material.dart';

Color color = Colors.teal.shade50;
Color splashcolor = Colors.teal.shade100;
Color textcolor = Colors.black54;



String path="http://192.168.0.200/ubiattendance/index.php/Att_services/";
String path_hrm_india="http://192.168.0.200/ubiattendance/index.php/Att_services/";


/*
String path="https://sandbox.ubiattendance.com/index.php/Att_services/";
String path_hrm_india="https://sandbox.ubiattendance.com/index.php/Att_services/";
*/
/*
String path="https://ubiattendance.ubihrm.com/index.php/Att_services/";
String path_hrm_india="https://ubiattendance.ubihrm.com/index.php/Att_services/";
*/
//String path_hrm_india="https://ubitech.ubihrm.com/services/";

MarkTime mk1;
List<Map<String, double>> list = new List();
String globalstreamlocationaddr="";
bool stopstreamingstatus = false;
int timeOff=0,bulkAttn = 0,geoFence=0,payroll=0,tracking=0,visitpunch=0,department_permission = 0, designation_permission = 0, leave_permission = 0, shift_permission = 0, timeoff_permission = 1,punchlocation_permission = 1, employee_permission = 0, permission_module_permission = 0, report_permission = 0,flexi_permission=0;
int globalalertcount = 0;
int visitImage = 0;
int attImage = 0;
int varCheckNet=0;
int areaId=0;
var assign_lat = 0.0;
var assign_long = 0.0;
var assign_radius = 0.0;

int tempvar = 0;