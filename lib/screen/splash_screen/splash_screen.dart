import 'package:flutter/material.dart';
import 'package:map_app/screen/map_screen/map_screen.dart';
import 'package:map_app/screen/splash_screen/user_name_page.dart';
import 'package:map_app/view_model/splash_view_model.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
       create: (context) => SplashViewModel(),
       builder: (context,child) {
        return Scaffold(
          body: Consumer<SplashViewModel>(
            builder: ((context, splashViewModel, child) {
               WidgetsBinding.instance.addPostFrameCallback(
                (timeStamp) { 
                  if(splashViewModel.latlong != null){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => 
                    UserNamePage(latLong: splashViewModel.latlong!,),
                    ));
                  }
                });
              return  Center(
                child: Image.asset("assets/images/images5.png",width: 400,));
            })),
        );
       
         
       },
    );
  }
}