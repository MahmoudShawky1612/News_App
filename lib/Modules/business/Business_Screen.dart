import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/Layout/newsapp/cubit/States.dart';
import 'package:newsapp/Layout/newsapp/cubit/cubit.dart';
import 'package:newsapp/shared/components.dart';

class Business_Screen extends StatelessWidget {
  const Business_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsState>(
      listener: (context, state) {},
      builder: (context, state) {

        var list= NewsCubit.get(context).business;
        return articleBuilder(list);
      },
    );
  }
}
