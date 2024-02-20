import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/Layout/newsapp/cubit/States.dart';
import 'package:newsapp/Modules/business/Business_Screen.dart';
import 'package:newsapp/Modules/science/Science_Screen.dart';
import 'package:newsapp/Modules/sports/Sports_Screen.dart';
import 'package:newsapp/network/local/cache_helper.dart';

import '../../../Modules/settings/Settings_Screen.dart';
import '../../../network/remote/dio_helper.dart';
import '../../../shared/as.dart';

class NewsCubit extends Cubit<NewsState>{

  NewsCubit():super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex=0;



  List <BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.business_center,
      ),
      label: "Business",
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.sports_basketball_rounded,
      ),
      label: "Sports",
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.science,

      ),

      label: "Science",
    ),
    //
  ];

  List<Widget> screens=[
    Business_Screen(),
    Sports_Screen(),
    Science_Screen(),


  ];

  void changeBottomNavBar(int index)
  {
    currentIndex=index;
    if(index==1)
      getSports();

    else if(index==2)
      getScience();

    else if(index==0)
      getBusiness();

    emit(NewsBottomNavState());
  }

  List<dynamic> business=[];

  void getBusiness()
  {
    emit(NewsLoadingState());
    DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country':'us',
          'category':'business',
          'apiKey':'d828d260096949f68d4be00b4b7c490e',
        }).then((value)
    {
    //  print(value.data['articles'][0]['author']);
      business=value.data['articles'];
      print(business[0]['title']);

      emit(NewsGetBusinessSuccessState());

    }).catchError((error){
      print(error.toString());
      emit(NewsGetBusinessErrorState(error.toString()));
    });
  }

  List<dynamic> sports=[];

  void getSports()
  {

    emit(NewsLoadingSportsState());
    if(sports.length==0)
    {
      DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country':'us',
            'category':'sports',
            'apiKey':'d828d260096949f68d4be00b4b7c490e',
          }).then((value)
      {
        //  print(value.data['articles'][0]['author']);
        sports=value.data['articles'];
        print(business[0]['title']);

        emit(NewsGetSportsSuccessState());

      }).catchError((error){
        print(error.toString());
        emit(NewsGetSportsErrorState(error.toString()));
      });
    } else
      {
        emit(NewsGetSportsSuccessState());

      }

  }

  List<dynamic> science=[];

  void getScience()
  {
    emit(NewsLoadingScienceState());
    if(science.length==0)
      {
        DioHelper.getData(
            url: 'v2/top-headlines',
            query: {
              'country':'us',
              'category':'science',
              'apiKey':'d828d260096949f68d4be00b4b7c490e',
            }).then((value)
        {
          //  print(value.data['articles'][0]['author']);
          science=value.data['articles'];
          print(business[0]['title']);

          emit(NewsGetScienceSuccessState());

        }).catchError((error){
          print(error.toString());
          emit(NewsGetScienceErrorState(error.toString()));
        });
      } else
        {
          emit(NewsGetScienceSuccessState());

        }

  }
  bool isDark=false;

  ThemeMode appMode = ThemeMode.dark;

  void changeAppMode ({bool? shared})
  {
    if(shared!=null) {
      isDark = shared;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.putData(key: 'isDark', value: isDark)
          .then((value) => {emit(AppChangeModeState())});
    }
  }
  List <dynamic> search =[];

  void getSearch (String value) {
    search = [];

    DioHelper.getData(
        url: 'v2/everything',
        query: {
          'q': '$value',
          'apiKey': 'd828d260096949f68d4be00b4b7c490e',
        }).then((value) {
      //  print(value.data['articles'][0]['author']);
      search = value.data['articles'];
      print(search[0]['title']);

      emit(NewsGetSearchSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(NewsGetSearchErrorState(error.toString()));
    });


  }
}