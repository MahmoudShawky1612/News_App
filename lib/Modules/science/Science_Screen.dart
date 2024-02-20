
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Layout/newsapp/cubit/States.dart';
import '../../Layout/newsapp/cubit/cubit.dart';
import '../../shared/components.dart';

class Science_Screen extends StatelessWidget {
  const Science_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsState>(
      listener: (context, state) {},
      builder: (context, state) {

        var list= NewsCubit.get(context).science;
        return articleBuilder(list);
      },
    );

  }
}












