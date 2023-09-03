import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:material_3_demo/patients_widget.dart';


const uri = 'dummyjson.com';


void main() {
  runApp(
    const App(),
  );
}


class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NavScreen(),
    );
  }
}

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int currentIndex = 2;
  List<Widget> screen = [
    HomeScreen(),
    PersonsScreen(),
    FormScreen()
  ];
  List<String> titles = [
    'HomeScreen',
    'PersonsScreen',
    'FormScreen'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
      ),
      body: screen[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: "Home",
              icon: Icon(Icons.home)
          ),
          BottomNavigationBarItem(
              label: "Person",
              icon: Icon(Icons.person)
          ),
          BottomNavigationBarItem(
              label: "Form",
              icon: Icon(Icons.format_align_center)
          ),
        ],
      ),
    );
  }
}


/// first screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var result;
  bool isInt = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      setState(() {
        isInt = true;
      });
      var url = Uri.https(uri,'/products') ;
      var response = await http.get(url);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      // log(decodedResponse.toString());
      result = decodedResponse;
      setState(() {
        isInt = false;
      });
    } catch (e){
      setState(() {
        isInt = false;
      });
      log(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if(isInt)
            Center(child: CircularProgressIndicator(),)
          else
            ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text(result['products'][index]['title']),
                      subtitle: Text(result['products'][index]['category']),
                    ),
                  );
                }
            )
        ],
      ),
    );
  }
}


/// second screen
class PersonsScreen extends StatefulWidget {
  const PersonsScreen({super.key});

  @override
  State<PersonsScreen> createState() => _PersonsScreenState();
}

class _PersonsScreenState extends State<PersonsScreen> {

  List data = [
    {
      'name':'Patient1',
      'isDicharged': false
    },
    {
      'name':'Patient2',
      'isDicharged': true
    },
    {
      'name':'Patient3',
      'isDicharged': true
    },
    {
      'name':'Patient4',
      'isDicharged': false
    },
    {
      'name':'Patient5',
      'isDicharged': true
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Patients(
                    name: data[index]['name'],
                    isDicharged: data[index]['isDicharged'],
                  );
                }
            )
        ],
      ),
    );
  }
}


/// third screen
class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  TextEditingController commission = TextEditingController();
  TextEditingController pricing = TextEditingController();
  String vendor = "";
  String product = "";

  Future postData() async {
    try {
      var url = Uri.https("no url",'end point') ;
      await http.post(url,
          body: {
            'vendor':vendor,
            'product':product,
            'commission':commission.text,
            'pricing':pricing.text,
          }
      );
    } catch (e){
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 500,
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownMenu(
                  onSelected : (res) {
                    setState(() {
                      vendor = res.toString();
                    });
                  },
                  label: Text('Select Vendor'),
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: 'vendor1', label: 'vendor1'),
                    DropdownMenuEntry(value: 'vendor2', label: 'vendor2'),
                    DropdownMenuEntry(value: 'vendor3', label: 'vendor3'),
                    DropdownMenuEntry(value: 'vendor4', label: 'vendor4'),
                  ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownMenu(
                  onSelected : (res) {
                    setState(() {
                      product = res.toString();
                    });
                  },
                  label: Text('Select Product'),
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: 'product1', label: 'product1'),
                    DropdownMenuEntry(value: 'product2', label: 'product2'),
                    DropdownMenuEntry(value: 'product3', label: 'product3'),
                    DropdownMenuEntry(value: 'product4', label: 'product4'),
                  ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: commission,
                decoration: InputDecoration(
                    icon: Icon(Icons.percent),
                  label: Text("Enter Commission"),
                  border: OutlineInputBorder()
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: pricing,
                decoration: InputDecoration(
                  icon: Icon(Icons.currency_rupee),
                    label: Text("Transfer Pricing"),
                    border: OutlineInputBorder()
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  log(vendor);
                  log(product);
                  log(commission.text);
                  log(pricing.text);
                  // await postData();
                },
                child: Text("Save")
            )
          ],
        ),
      ),
    );
  }
}



