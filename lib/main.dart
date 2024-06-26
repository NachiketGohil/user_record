import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_record/config/analytics_mixin.dart';
import 'package:user_record/config/app_route.dart';
import 'package:user_record/config/injection_container.dart' as di;
import 'package:user_record/presentation/bloc/auth_cubit.dart';
import 'package:user_record/presentation/view/auth_checker_page.dart';

import 'config/firebase_options.dart';
import 'domain/usecase/fetch_user_details_usecase.dart';
import 'presentation/bloc/user_detail_cubit.dart';
import 'presentation/bloc/user_list_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => di.sl<AuthCubit>()),
        BlocProvider(create: (_) => di.sl<UserListCubit>()),
        BlocProvider(create: (context) => UserDetailCubit(di.sl<FetchUserDetailUseCase>())),
      ],
      child: MaterialApp(
        title: 'User Record',
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: GoogleAnalyticsMixin.firebaseAnalytics),
        ],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        onGenerateRoute: AppRoute.generateRoute,
        home: const AuthChecker(),
      ),
    );
  }
}
