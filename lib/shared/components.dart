import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/Modules/Web%20View/Web_View.dart';

import '../Layout/newsapp/cubit/States.dart';



Widget buildArticleItem(article,context) => InkWell(
  onTap: (){
    navigateTo(context, Web_View(article['url']),);
  },
  child: Padding(
    padding: const EdgeInsets.all(15),
    child: Row(
      children: [
        Container(
          width: 120,
          height: 120,
  
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(
              image: NetworkImage('${article['urlToImage']}'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 10,),
        Expanded(
          child: Container(
            height: 120,
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
  
                Expanded(
                  child: Text(
                    '${article['title']}',
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
  
                Text(
                  '${article['publishedAt']}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
);

Widget myDivider() =>  Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20,
  ),
  child: Container(
    height: 2,
    color: Colors.white,
    width: double.infinity,
  ),
);


Widget articleBuilder(list) =>ConditionalBuilder(
  condition:list.length>0,
  builder: (context) => ListView.separated(
    physics: BouncingScrollPhysics(),
    itemBuilder: (context, index) => buildArticleItem(list[index],context),
    separatorBuilder: (context, index) => myDivider(),
    itemCount: 10,
  ),
  fallback: (context) => Center(child: CircularProgressIndicator()),
);

Widget defaultFormFiel({
  required TextEditingController controller,
  required TextInputType type,
  bool isPassword=false,
  Function(String)? onSubmit,
  Function(String)? onChange,
  required Function validate,
  required String label,
  required IconData prefix,
  bool isClickable=true,
  Function()? onTap,

}) => TextFormField(
  controller: controller,
  keyboardType: type,
  obscureText: isPassword,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  enabled: isClickable,
  validator: (value) => validate(value),
  decoration:  InputDecoration(
    labelText: label,
    prefixIcon: Icon(
      prefix,
    ),
    border: OutlineInputBorder(),
  ),
  onTap: onTap,

);


void navigateTo (context,widget)=>Navigator.push(context,
    MaterialPageRoute(builder: (context)=>widget)

);



