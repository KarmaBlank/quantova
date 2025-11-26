import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/database/database_service.dart';
import 'core/providers/theme_provider.dart';
import 'core/services/default_categories_service.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/domain/repositories/transaction_repository.dart';
import 'features/dashboard/presentation/bloc/transaction_bloc.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'i18n/strings.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize localization with device locale
  LocaleSettings.useDeviceLocale();

  final databaseService = await DatabaseService.create();

  // Initialize default categories
  await DefaultCategoriesService.initializeDefaultCategories(databaseService);

  final transactionRepository = TransactionRepositoryImpl(databaseService);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: TranslationProvider(
        child: MyApp(
          databaseService: databaseService,
          transactionRepository: transactionRepository,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final DatabaseService databaseService;
  final TransactionRepository transactionRepository;

  const MyApp({
    super.key,
    required this.databaseService,
    required this.transactionRepository,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MultiProvider(
      providers: [
        Provider<DatabaseService>.value(value: databaseService),
        RepositoryProvider<TransactionRepository>.value(value: transactionRepository),
      ],
      child: BlocProvider(
        create: (context) => TransactionBloc(transactionRepository)..add(LoadTransactions()),
        child: MaterialApp(
          title: 'Gastos Mensuales',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          locale: TranslationProvider.of(context).flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const DashboardPage(),
        ),
      ),
    );
  }
}
