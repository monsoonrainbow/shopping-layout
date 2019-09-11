import 'dart:convert';

import 'package:flutter/material.dart';

import 'helpers/dbHelper.dart';
import 'models/item.dart';
import 'selectedItemView.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      //theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: MyHomePage('Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(this.title) : super();
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Item> data = [];
  List<String> itemCategoryList = ["bags", "shoes", "jackets"];
  ItemsDataBaseHelper dataBaseHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData("bags");
  }

  Future<String> getData(itemName) async {
    dataBaseHelper = new ItemsDataBaseHelper();
    print("get data");
    dataBaseHelper.getItemsofCategory(itemName).then((value) => setState(() {
          if (value.length == 0) {
            addToDB(itemName);
            getData(itemName);
          } else {
            data = value;
          }
        }));
    return "success";
  }

  void addToDB(itemName) async {
    print("add to db");
    String jsonData = await DefaultAssetBundle.of(context)
        .loadString("assets/jsonFiles/" + itemName + ".json");
    final jsonResult = json.decode(jsonData);

    Item dbItem;
    for (var item in jsonResult) {
      dbItem = new Item(
          title: item["title"],
          description: item["description"],
          price: item["price"],
          //colors: item["colors"],
          category: item["category"],
          image: item["image"]);
      await dataBaseHelper.saveItemsDetails(dbItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(
              title: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              body1: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          title: Container(
            child: Row(
              children: <Widget>[Text("Popular"), Icon(Icons.arrow_drop_down)],
            ),
          ),
          actions: <Widget>[
            Icon(Icons.shopping_cart),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Icon(Icons.search),
            )
          ],
          bottom: TabBar(
              onTap: (index) {
                getData(itemCategoryList[index]);
              },
              labelColor: Colors.black,
              indicatorColor: Colors.purple,
              tabs: [
                Tab(child: Text("Bags",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),)),
                Tab(child: Text("Shoes",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),)),
                Tab(child: Text("Jackets",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),)),
              ]),
        ),
        body: TabBarView(
          children: <Widget>[
            ItemsDisplayWidget(data),
            ItemsDisplayWidget(data),
            ItemsDisplayWidget(data),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.deepPurple,
          selectedIconTheme: IconThemeData(color: Colors.white),
          currentIndex: 0, // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home',style: TextStyle(color: Colors.white),),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.favorite),
              title: new Text('Favourite'),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text('Profile'))
          ],
        ),
      ),
    );
  }
}

class ItemsDisplayWidget extends StatelessWidget {
  const ItemsDisplayWidget(this.data) : super();

  final data;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        //padding: EdgeInsets.fromLTRB(5, 5, 5, 55),
        itemCount: data.length == null ? 0 : data.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return new Card(
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: GestureDetector(
                onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectedItemView(data[index])),
                    );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 15),
                        alignment: Alignment.center,
                        child: Image.network(data[index].image),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        data[index].title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 2, 0, 15),
                      child: Text(
                        data[index].price,
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}
