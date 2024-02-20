import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/Layout/newsapp/cubit/States.dart';
import 'package:newsapp/Layout/newsapp/cubit/cubit.dart';
import 'package:newsapp/Modules/Search_Screen/Search_Screen.dart';
import 'package:newsapp/network/remote/dio_helper.dart';
import 'package:newsapp/shared/components.dart';
import 'package:newsapp/shared/ggg.dart';

class Home_Layout extends StatelessWidget {
  const Home_Layout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit,NewsState>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = NewsCubit.get(context);
        return  Scaffold(
          appBar: AppBar(
            title:Text(
              "News App",
            ),
            actions: [
              IconButton(
                onPressed: ()
                {
                  navigateTo(context, Search_Screen());
                },
                icon: Icon(
                  Icons.search,
                ),
              ),
              IconButton(
                  onPressed: ()
                  {
                    NewsCubit.get(context)..changeAppMode();
                  },
                  icon: Icon(
                    Icons.brightness_4_outlined,
                  ),
              ),
            ],

          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: cubit.bottomItems,
            currentIndex: cubit.currentIndex,
            onTap: (index){
              cubit.changeBottomNavBar(index);

            },
            selectedItemColor: Colors.pink,
            elevation: 30,
          ),
        );
      },

    );
  }
}
