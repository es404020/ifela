import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ifela/screens/main.dart';
import 'package:ifela/screens/updateprofile.dart';
import 'package:ifela/settings/fencing.dart';
import 'package:ifela/settings/pendingcontact.dart';
import 'package:ifela/tabs/chat.dart';
import 'package:ifela/tabs/settings.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;


    switch (settings.name) {
      case AuthPage.id:
        return MaterialPageRoute(builder: (_) => AuthPage());

      case Settings.id:
        return MaterialPageRoute(builder: (_) => Settings());

//      case Contact.id:
//        return MaterialPageRoute(builder: (_) => Contact());

      case Fencings.id:
        return MaterialPageRoute(builder: (_) => Fencings());

      case PendingContact.id:
        if (args is String) {
          return MaterialPageRoute(builder: (_) => PendingContact(
            uid:args
          ));
        }
        return _errorPage();

      case HomePage.id:
        if (args is bool) {
          return MaterialPageRoute(

              builder: (_) => HomePage(
                    ids: args,
                  ));
        }
        return _errorPage();

      case Chats.id:
        final Chats arg = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => Chats(
                  peerId: arg.peerId,
                  peerAvatar: arg.peerAvatar,
                ));

      case EditProfile.id:
        if (args is bool) {
          return MaterialPageRoute(
              builder: (_) => EditProfile(
                    ids: args,
                  ));
        }
        return _errorPage();


      case UpdateProfile.id:
        final DocumentSnapshot arg2 = settings.arguments;
        if (arg2 is DocumentSnapshot) {
          return MaterialPageRoute(
              builder: (_) => UpdateProfile(
               val: arg2,
              ));
        }
        return _errorPage();

//      case  Registration.id:
//        return MaterialPageRoute(builder: (_)=>Registration(auth: new Auth(),));
//      case  ForgetPassword.id:
//        return MaterialPageRoute(builder: (_)=>ForgetPassword());
//      case HomePage.id:
//        return MaterialPageRoute(builder: (_)=>HomePage());
//
//      case Contact.id:
//        return MaterialPageRoute(builder: (_)=>Contact());
//      case LF.id:
//        return MaterialPageRoute(builder: (_)=>LF());
//      case Lawyer.id:
//        return MaterialPageRoute(builder: (_)=>Lawyer());
//      case Setting.id:
//        return MaterialPageRoute(builder: (_)=>Setting());
//
//      case PhoneAuth.id:
//        return MaterialPageRoute(builder: (_)=>PhoneAuth());
//
//      case DogPage.id:
//
//        if(args is String){
//          return MaterialPageRoute(builder: (_)=>DogPage(ids: args,));
//        }
//        return _errorPage();
//
//      case AddPost.id:
//        return MaterialPageRoute(builder: (_)=>AddPost());
      default:
        return _errorPage();
    }
  }



  static Route<dynamic> _errorPage() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Error"),
        ),
        body: Center(
          child: Text("ERRORs"),
        ),
      );
    });
  }

  static Route<T> fadeThrough<T>( page, [double duration = 2000]) {
    return PageRouteBuilder<T>(
      transitionDuration: Duration(milliseconds: (duration * 1000).round()),
      pageBuilder: (context, animation, secondaryAnimation) => page(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(animation: animation, secondaryAnimation: secondaryAnimation, child: child);
      },
    );
  }

  static Route<T> fadeScale<T>( page, [double duration = 1000]) {
    return PageRouteBuilder<T>(
      transitionDuration: Duration(milliseconds: (duration * 1000).round()),
      pageBuilder: (context, animation, secondaryAnimation) => page(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeScaleTransition(animation: animation, child: child);
      },
    );
  }

  static Route<T> sharedAxis<T>( page, [SharedAxisTransitionType type = SharedAxisTransitionType.scaled, double duration = 1000]) {
    return PageRouteBuilder<T>(
      transitionDuration: Duration(milliseconds: (duration * 1000).round()),
      pageBuilder: (context, animation, secondaryAnimation) => page(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          child: child,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: type,
        );
      },
    );
  }

}




