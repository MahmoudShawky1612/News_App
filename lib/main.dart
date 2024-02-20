import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/Layout/newsapp/Home_Layout.dart';
import 'package:newsapp/Layout/newsapp/cubit/States.dart';
import 'package:newsapp/Layout/newsapp/cubit/cubit.dart';
import 'package:newsapp/network/local/cache_helper.dart';
import 'package:newsapp/network/remote/dio_helper.dart';
import 'package:newsapp/shared/as.dart';
import 'package:newsapp/shared/bloc_observer.dart';
import 'package:newsapp/shared/ggg.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer=MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool? isDark =CacheHelper.getData(key: 'isDark');


  runApp(MyApp(isDark ?? false));
}

class MyApp extends StatelessWidget {
  final bool isDark;

   MyApp(this.isDark);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>NewsCubit()..getBusiness()..getSports()..getScience(),),
        BlocProvider(create: (BuildContext context)=>NewsCubit()..changeAppMode(
    shared:isDark,)),
      ],
      child: BlocConsumer<NewsCubit,NewsState>(
        listener: (context,state){},
        builder: (context,state)
        {
          return  MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.red,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                ),
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: IconThemeData(
                  color: Colors.red,
                ),
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.red,
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.pink,

              ),
              textTheme: TextTheme(
                bodyLarge: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.red,
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.black,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.black,
                  statusBarIconBrightness: Brightness.light,
                ),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: IconThemeData(
                  color: Colors.red,
                ),
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.red,
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.pink,
                backgroundColor: Colors.black,
                unselectedItemColor: Colors.grey,
              ),
              textTheme: TextTheme(
                bodyLarge: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            themeMode: NewsCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: Home_Layout() ,
          );
        },

      ),
    );
  }
}
