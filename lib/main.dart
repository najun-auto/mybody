import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:mybody/data/data.dart';
import 'package:mybody/data/database.dart';
import 'package:mybody/utils.dart';
import 'package:mybody/view/body.dart';
import 'package:mybody/view/food.dart';
import 'package:mybody/view/workout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int currentIndex = 0;

  List<Food> todayFood = [];
  List<Workout> todayWorkout = [];
  List<EyeBody> todayEyeBody = [];

  final dbHelper = DatabaseHelper.instance;
  DateTime time = DateTime.now();

  @override
  void initState() {
    getHistories();
    super.initState();
  }

  void getHistories() async {
    int d = Utils.getFormatTime(time);
    todayFood = await dbHelper.queryFoodByDate(d);
    todayWorkout = await dbHelper.queryWorkoutByDate(d);
    todayEyeBody = await dbHelper.queryEyeBodyByDate(d);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

      ),
      body: getPage(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "오늘"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "기록"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "통계"),
          BottomNavigationBarItem(icon: Icon(Icons.photo_album_outlined), label: "갤러리"),
        ],
        currentIndex: currentIndex,
        onTap: (idx){
          setState(() {
            currentIndex = idx;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            builder: (ctx){
              return SizedBox(
                height: 200,
                child: Column(
                  children: [
                    TextButton(child: Text("식단"),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => FoodAddPage(
                                  food: Food(
                                      date: Utils.getFormatTime(DateTime.now()),
                                      kcal: 0,
                                      memo: "",
                                      type: 0,
                                      image: ""),
                                )));
                      },
                    ),
                    TextButton(child: Text("운동"),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => WorkoutAddPage(
                              workout: Workout(
                                  date: Utils.getFormatTime(DateTime.now()),
                                  time: 0,
                                  memo: "",
                                  name: "",
                                  image: ""),
                            )));
                      },),
                    TextButton(child: Text("눈바디"),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => EyeBodyAddPage(
                              eyeBody: EyeBody(
                                  date: Utils.getFormatTime(DateTime.now()),
                                  weight: 0,
                                  image: ""),
                            )));
                      },),
                  ],
                ),
              );
            },
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget getPage(){
    if(currentIndex == 0){
      return getMainPage();
    }else if(currentIndex == 1){
      return getHistoryPage();
    }else if(currentIndex == 2){
      return getChartPage();
    }else if(currentIndex == 3){
      return getGalleryPage();
    }
      return Container();
  }

  Widget getMainPage(){
    return Container(
      child: Column(
        children: [
          Container(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(todayFood.length, (idx) {
                return Container(
                  height: 140,
                  width: 140,
                  child: FoodCard(food: todayFood[idx]),
                );
              }),
            ),
          ),

          Container(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(todayWorkout.length, (idx) {
                return Container(
                  height: 140,
                  width: 140,
                  child: WorkoutCard(workout: todayWorkout[idx]),
                );
              }),
            ),
          ),

          Container(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(todayEyeBody.length, (idx) {
                return Container(
                  height: 140,
                  width: 140,
                  child: EyeBodyCard(eyebody: todayEyeBody[idx]),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
  Widget getHistoryPage(){
    return Container();
  }
  Widget getChartPage(){
    return Container();
  }
  Widget getGalleryPage(){
    return Container();
  }

}

class FoodCard extends StatelessWidget{
  final Food food;
  FoodCard({Key key, this.food}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: ClipRRect(
      child: Stack(
        children: [
          Positioned.fill(child: AssetThumb(asset: Asset(food.image, "food.png", 0, 0), width: 300, height: 300,)),
          Positioned.fill(child: Container(color: Colors.black38)),
          Container(child: Text("${["아침", "점심", "저녁", "간식"][food.type]}", style: TextStyle(color: Colors.white),),),
        ],
      ),
      borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class WorkoutCard extends StatelessWidget{
  final Workout workout;
  WorkoutCard({Key key, this.workout}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: ClipRRect(
        child: Stack(
          children: [
            Positioned.fill(child: AssetThumb(asset: Asset(workout.image, "food.png", 0, 0), width: 300, height: 300,)),
            Positioned.fill(child: Container(color: Colors.black38)),
            Container(child: Text("${workout.name}", style: TextStyle(color: Colors.white),),),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class EyeBodyCard extends StatelessWidget{
  final EyeBody eyebody;
  EyeBodyCard({Key key, this.eyebody}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: ClipRRect(
        child: Stack(
          children: [
            Positioned.fill(child: AssetThumb(asset: Asset(eyebody.image, "food.png", 0, 0), width: 300, height: 300,)),
            Positioned.fill(child: Container(color: Colors.black38)),
            Container(child: Text("${eyebody.weight}kg", style: TextStyle(color: Colors.white),),),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}