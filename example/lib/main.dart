import 'package:flutter/material.dart';
import 'package:flutter_plugin_example/application_constants.dart';
import 'package:flutter_plugin_example/diet_plan.dart';
import 'package:parse_server_sdk/parse.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initParse();
    runTestQueries();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: new Text('Running Parse init'),
        ),
        floatingActionButton:
            new FloatingActionButton(onPressed: runTestQueries),
      ),
    );
  }

  initParse() async {
    // Initialize parse
    Parse().initialize(ApplicationConstants.PARSE_APPLICATION_ID,
        ApplicationConstants.PARSE_SERVER_URL,
        masterKey: ApplicationConstants.PARSE_MASTER_KEY,
        appName: ApplicationConstants.APP_NAME,
        debug: true);
  }

  runTestQueries() {
    getAllItems();
    getAllItemsByName();
    getSingleItem();
    query();
    function();
    initUser();
  }

  void getAllItemsByName() async {
    var apiResponse = await ParseObject('ParseTableName').getAll();

    if (apiResponse.success) {
      for (var testObject in apiResponse.result) {
        print(ApplicationConstants.APP_NAME + ": " + testObject.toString());
      }
    }
  }

  void getAllItems() async {
    var response = await DietPlan().getAll();

    if (response.success) {
      for (var plan in response.result) {
        print(ApplicationConstants.APP_NAME + ": " + (plan as DietPlan).name);
      }
    } else {
      print(ApplicationConstants.APP_NAME + ": " + response.error.message);
    }
  }

  void getSingleItem() async {
    var response = await DietPlan().getObject('R5EonpUDWy');

    if (response.success) {
      print(ApplicationConstants.APP_NAME + ": " + (response.result as DietPlan).toString());
    } else {
      print(ApplicationConstants.APP_NAME + ": " + response.error.message);
    }
  }

  void query() async {
    var queryBuilder = QueryBuilder<DietPlan>(DietPlan())
      ..greaterThan(DietPlan.FAT, 20)
      ..descending(DietPlan.FAT);

    var response = await queryBuilder.query();

    if (response.success) {
      print("Result: ${((response.result as List<dynamic>).first as DietPlan).toString()}");
    } else {
      print("Result: ${response.error.message}");
    }
  }

  initUser() async {
    var user = ParseUser("TestFlutter", "TestPassword123", "TestFlutterSDK@gmail.com");
    user = await user.signUp();
    user = await user.login();
    user = null;

    // Best practice for starting the app. This will check for a
    user = ParseUser.currentUser();
    user = await user.getCurrentUserFromServer();
    user = await user.requestPasswordReset();
    user = await user.verificationEmailRequest();
    user = await user.all();
    user = await user.save();
    //await user.destroy();
  }

  function() {
    var function = ParseCloudFunction('testFunction');
    function.execute();
  }
}
