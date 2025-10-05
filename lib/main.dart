import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/network/api_service.dart';
import 'core/constants/app_colors.dart';
import 'data/repositories/diesel_repository.dart';
import 'presentation/providers/dashboard_provider.dart';
import 'presentation/providers/consumption_provider.dart';
import 'presentation/providers/control_provider.dart';
import 'presentation/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  final prefs = await SharedPreferences.getInstance();
  final apiService = ApiService();

  final savedIp = prefs.getString('esp32_ip');
  if (savedIp != null && savedIp.isNotEmpty) {
    apiService.initialize(savedIp);
  }

  runApp(MyApp(
    prefs: prefs,
    apiService: apiService,
  ));
}

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;
  final ApiService apiService;

  const MyApp({
    Key? key,
    required this.prefs,
    required this.apiService,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late DieselRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = DieselRepository(widget.apiService, widget.prefs);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>.value(value: widget.apiService),
        Provider<DieselRepository>.value(value: _repository),
        ChangeNotifierProvider(
          create: (context) => DashboardProvider(_repository),
        ),
        ChangeNotifierProvider(
          create: (context) => ConsumptionProvider(_repository),
        ),
        ChangeNotifierProvider(
          create: (context) => ControlProvider(_repository),
        ),
      ],
      child: Consumer<DieselRepository>(
        builder: (context, repository, child) {
          final isDarkMode = repository.isDarkMode();
          final language = repository.getLanguage();

          return MaterialApp(
            title: 'Diesel Monitor',
            debugShowCheckedModeBanner: false,
            theme: _buildTheme(isDarkMode),
            locale: Locale(language),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar', 'SA'),
              Locale('en', 'US'),
            ],
            home: const HomeScreen(),
          );
        },
      ),
    );
  }

  ThemeData _buildTheme(bool isDark) {
    final baseTheme = isDark ? ThemeData.dark() : ThemeData.light();

    return baseTheme.copyWith(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      cardTheme: CardTheme(
        color: isDark ? AppColors.darkCardBackground : AppColors.cardBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textTheme: GoogleFonts.cairoTextTheme(
        isDark
            ? ThemeData.dark().textTheme
            : ThemeData.light().textTheme,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        error: AppColors.danger,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? AppColors.darkCardBackground
            : Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: Colors.grey.shade300,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withOpacity(0.2),
      ),
    );
  }
}
