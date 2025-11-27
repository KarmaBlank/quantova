///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsEs with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEs({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.es,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <es>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsEs _root = this; // ignore: unused_field

	@override 
	TranslationsEs $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEs(meta: meta ?? this.$meta);

	// Translations
	@override String get appName => 'Gastos Mensuales';
	@override late final _TranslationsCommonEs common = _TranslationsCommonEs._(_root);
	@override late final _TranslationsFiltersEs filters = _TranslationsFiltersEs._(_root);
	@override late final _TranslationsDashboardEs dashboard = _TranslationsDashboardEs._(_root);
	@override late final _TranslationsTransactionsEs transactions = _TranslationsTransactionsEs._(_root);
	@override late final _TranslationsCategoriesEs categories = _TranslationsCategoriesEs._(_root);
	@override late final _TranslationsReportsEs reports = _TranslationsReportsEs._(_root);
	@override late final _TranslationsSettingsEs settings = _TranslationsSettingsEs._(_root);
	@override late final _TranslationsExpensesEs expenses = _TranslationsExpensesEs._(_root);
}

// Path: common
class _TranslationsCommonEs implements TranslationsCommonEn {
	_TranslationsCommonEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Cancelar';
	@override String get save => 'Guardar';
	@override String get delete => 'Eliminar';
	@override String get edit => 'Editar';
	@override String get add => 'Agregar';
	@override String get search => 'Buscar';
	@override String get filter => 'Filtrar';
	@override String get all => 'Todos';
	@override String get loading => 'Cargando...';
	@override String get error => 'Error';
	@override String get errorLoadingData => 'Error cargando datos';
	@override String get success => 'Éxito';
	@override String get noData => 'No hay datos disponibles';
	@override String get none => 'Ninguna';
	@override String get uncategorized => 'Sin categoría';
	@override String get noDescription => 'Sin descripción';
	@override String get noExpenseData => 'No hay datos de gastos';
	@override String get expensesByCategory => 'Gastos por Categoría';
	@override String get monthlyTrend => 'Tendencia Mensual';
	@override String get expenseDistribution => 'Distribución de Gastos';
}

// Path: filters
class _TranslationsFiltersEs implements TranslationsFiltersEn {
	_TranslationsFiltersEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get currentMonth => 'Mes Actual';
	@override String get lastMonth => 'Mes Pasado';
	@override String get last3Months => 'Últimos 3 Meses';
	@override String get last6Months => 'Últimos 6 Meses';
	@override String get lastYear => 'Último Año';
	@override String get allTime => 'Todo el Tiempo';
	@override String get custom => 'Personalizado';
	@override String get filterTransactions => 'Filtrar Transacciones';
	@override String get byType => 'Por Tipo';
	@override String get byCategory => 'Por Categoría';
	@override String get byDateRange => 'Por Rango de Fechas';
	@override String get apply => 'Aplicar';
	@override String get clear => 'Limpiar';
}

// Path: dashboard
class _TranslationsDashboardEs implements TranslationsDashboardEn {
	_TranslationsDashboardEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Finanzas';
	@override String get totalBalance => 'Balance total';
	@override String get income => 'Ingresos';
	@override String get expenses => 'Gastos';
	@override String get recentTransactions => 'Transacciones recientes';
	@override String get seeAll => 'Ver todo';
	@override String get youAreOnTop => 'Estás al día';
	@override String get ofYourFinances => 'con tus finanzas';
	@override String get noTransactions => 'No hay transacciones aún';
	@override String get globalSavings => 'Ahorro global';
	@override String get monthlySavings => 'Ahorro mensual';
	@override String get addIncome => 'Agregar';
	@override String get addExpense => 'Agregar';
	@override String get dailyTrend => 'Tendencia Diaria';
	@override String get seeMoreCharts => 'Ver más gráficos';
	@override String get chartsAndAnalytics => 'Gráficos y Análisis';
	@override String get reportSaved => 'Reporte guardado en';
	@override String get exportToPdf => 'Exportar a PDF';
	@override String get exportToExcel => 'Exportar a Excel';
	@override String get noDataForPeriod => 'No hay datos para este período';
}

// Path: transactions
class _TranslationsTransactionsEs implements TranslationsTransactionsEn {
	_TranslationsTransactionsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get income => 'Ingreso';
	@override String get expense => 'Gasto';
	@override String get amount => 'Monto';
	@override String get description => 'Descripción';
	@override String get category => 'Categoría';
	@override String get date => 'Fecha';
	@override String get receipt => 'Recibo';
	@override String get addIncome => 'Agregar Ingreso';
	@override String get addExpense => 'Agregar Gasto';
	@override String get editTransaction => 'Editar Transacción';
	@override String get deleteTransaction => 'Eliminar Transacción';
	@override String get scanReceipt => 'Escanear Recibo';
	@override String get takePhoto => 'Tomar Foto';
	@override String get chooseFromGallery => 'Elegir de Galería';
	@override String get saveIncome => 'Guardar Ingreso';
}

// Path: categories
class _TranslationsCategoriesEs implements TranslationsCategoriesEn {
	_TranslationsCategoriesEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Categorías';
	@override String get addCategory => 'Agregar Categoría';
	@override String get editCategory => 'Editar Categoría';
	@override String get deleteCategory => 'Eliminar Categoría';
	@override String get selectCategory => 'Seleccionar Categoría';
	@override String get customCategories => 'Categorías Personalizadas';
	@override late final _TranslationsCategoriesDefaultCategoriesEs defaultCategories = _TranslationsCategoriesDefaultCategoriesEs._(_root);
}

// Path: reports
class _TranslationsReportsEs implements TranslationsReportsEn {
	_TranslationsReportsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Reportes';
	@override String get byCategory => 'Por Categoría';
	@override String get byDate => 'Por Fecha';
	@override String get exportPDF => 'Exportar PDF';
	@override String get exportExcel => 'Exportar Excel';
	@override String get totalSpent => 'Total Gastado';
	@override String get averagePerDay => 'Promedio por Día';
	@override String get topCategories => 'Principales Categorías';
}

// Path: settings
class _TranslationsSettingsEs implements TranslationsSettingsEn {
	_TranslationsSettingsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Configuración';
	@override String get language => 'Idioma';
	@override String get theme => 'Tema';
	@override String get currency => 'Moneda';
	@override String get notifications => 'Notificaciones';
}

// Path: expenses
class _TranslationsExpensesEs implements TranslationsExpensesEn {
	_TranslationsExpensesEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get addExpense => 'Agregar Gasto';
	@override String get selectImageSource => 'Seleccionar Fuente de Imagen';
	@override String get camera => 'Cámara';
	@override String get gallery => 'Galería';
	@override String get detected => 'Detectado';
	@override String get detectedAmount => 'Monto detectado';
	@override String get detectedMerchant => 'Comercio detectado';
	@override String get noInfoDetected => 'No se pudo detectar información. Por favor ingrese manualmente.';
	@override String get scanError => 'Error al escanear recibo';
	@override String get receiptScanned => 'Recibo escaneado';
	@override String get amount => 'Monto';
	@override String get enterAmount => 'Por favor ingrese un monto';
	@override String get validNumber => 'Por favor ingrese un número válido';
	@override String get description => 'Descripción';
	@override String get categoryOptional => 'Categoría (Opcional)';
	@override String get date => 'Fecha';
	@override String get saveExpense => 'Guardar Gasto';
	@override String get scanReceipt => 'Escanear Recibo';
}

// Path: categories.defaultCategories
class _TranslationsCategoriesDefaultCategoriesEs implements TranslationsCategoriesDefaultCategoriesEn {
	_TranslationsCategoriesDefaultCategoriesEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get home => 'Casa';
	@override String get subscriptions => 'Suscripciones';
	@override String get groceries => 'Super';
	@override String get fastFood => 'Comida Rápida';
	@override String get restaurant => 'Restaurante';
	@override String get entertainment => 'Entretenimiento';
	@override String get salary => 'Sueldo';
}

/// The flat map containing all translations for locale <es>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEs {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => 'Gastos Mensuales',
			'common.cancel' => 'Cancelar',
			'common.save' => 'Guardar',
			'common.delete' => 'Eliminar',
			'common.edit' => 'Editar',
			'common.add' => 'Agregar',
			'common.search' => 'Buscar',
			'common.filter' => 'Filtrar',
			'common.all' => 'Todos',
			'common.loading' => 'Cargando...',
			'common.error' => 'Error',
			'common.errorLoadingData' => 'Error cargando datos',
			'common.success' => 'Éxito',
			'common.noData' => 'No hay datos disponibles',
			'common.none' => 'Ninguna',
			'common.uncategorized' => 'Sin categoría',
			'common.noDescription' => 'Sin descripción',
			'common.noExpenseData' => 'No hay datos de gastos',
			'common.expensesByCategory' => 'Gastos por Categoría',
			'common.monthlyTrend' => 'Tendencia Mensual',
			'common.expenseDistribution' => 'Distribución de Gastos',
			'filters.currentMonth' => 'Mes Actual',
			'filters.lastMonth' => 'Mes Pasado',
			'filters.last3Months' => 'Últimos 3 Meses',
			'filters.last6Months' => 'Últimos 6 Meses',
			'filters.lastYear' => 'Último Año',
			'filters.allTime' => 'Todo el Tiempo',
			'filters.custom' => 'Personalizado',
			'filters.filterTransactions' => 'Filtrar Transacciones',
			'filters.byType' => 'Por Tipo',
			'filters.byCategory' => 'Por Categoría',
			'filters.byDateRange' => 'Por Rango de Fechas',
			'filters.apply' => 'Aplicar',
			'filters.clear' => 'Limpiar',
			'dashboard.title' => 'Finanzas',
			'dashboard.totalBalance' => 'Balance total',
			'dashboard.income' => 'Ingresos',
			'dashboard.expenses' => 'Gastos',
			'dashboard.recentTransactions' => 'Transacciones recientes',
			'dashboard.seeAll' => 'Ver todo',
			'dashboard.youAreOnTop' => 'Estás al día',
			'dashboard.ofYourFinances' => 'con tus finanzas',
			'dashboard.noTransactions' => 'No hay transacciones aún',
			'dashboard.globalSavings' => 'Ahorro global',
			'dashboard.monthlySavings' => 'Ahorro mensual',
			'dashboard.addIncome' => 'Agregar',
			'dashboard.addExpense' => 'Agregar',
			'dashboard.dailyTrend' => 'Tendencia Diaria',
			'dashboard.seeMoreCharts' => 'Ver más gráficos',
			'dashboard.chartsAndAnalytics' => 'Gráficos y Análisis',
			'dashboard.reportSaved' => 'Reporte guardado en',
			'dashboard.exportToPdf' => 'Exportar a PDF',
			'dashboard.exportToExcel' => 'Exportar a Excel',
			'dashboard.noDataForPeriod' => 'No hay datos para este período',
			'transactions.income' => 'Ingreso',
			'transactions.expense' => 'Gasto',
			'transactions.amount' => 'Monto',
			'transactions.description' => 'Descripción',
			'transactions.category' => 'Categoría',
			'transactions.date' => 'Fecha',
			'transactions.receipt' => 'Recibo',
			'transactions.addIncome' => 'Agregar Ingreso',
			'transactions.addExpense' => 'Agregar Gasto',
			'transactions.editTransaction' => 'Editar Transacción',
			'transactions.deleteTransaction' => 'Eliminar Transacción',
			'transactions.scanReceipt' => 'Escanear Recibo',
			'transactions.takePhoto' => 'Tomar Foto',
			'transactions.chooseFromGallery' => 'Elegir de Galería',
			'transactions.saveIncome' => 'Guardar Ingreso',
			'categories.title' => 'Categorías',
			'categories.addCategory' => 'Agregar Categoría',
			'categories.editCategory' => 'Editar Categoría',
			'categories.deleteCategory' => 'Eliminar Categoría',
			'categories.selectCategory' => 'Seleccionar Categoría',
			'categories.customCategories' => 'Categorías Personalizadas',
			'categories.defaultCategories.home' => 'Casa',
			'categories.defaultCategories.subscriptions' => 'Suscripciones',
			'categories.defaultCategories.groceries' => 'Super',
			'categories.defaultCategories.fastFood' => 'Comida Rápida',
			'categories.defaultCategories.restaurant' => 'Restaurante',
			'categories.defaultCategories.entertainment' => 'Entretenimiento',
			'categories.defaultCategories.salary' => 'Sueldo',
			'reports.title' => 'Reportes',
			'reports.byCategory' => 'Por Categoría',
			'reports.byDate' => 'Por Fecha',
			'reports.exportPDF' => 'Exportar PDF',
			'reports.exportExcel' => 'Exportar Excel',
			'reports.totalSpent' => 'Total Gastado',
			'reports.averagePerDay' => 'Promedio por Día',
			'reports.topCategories' => 'Principales Categorías',
			'settings.title' => 'Configuración',
			'settings.language' => 'Idioma',
			'settings.theme' => 'Tema',
			'settings.currency' => 'Moneda',
			'settings.notifications' => 'Notificaciones',
			'expenses.addExpense' => 'Agregar Gasto',
			'expenses.selectImageSource' => 'Seleccionar Fuente de Imagen',
			'expenses.camera' => 'Cámara',
			'expenses.gallery' => 'Galería',
			'expenses.detected' => 'Detectado',
			'expenses.detectedAmount' => 'Monto detectado',
			'expenses.detectedMerchant' => 'Comercio detectado',
			'expenses.noInfoDetected' => 'No se pudo detectar información. Por favor ingrese manualmente.',
			'expenses.scanError' => 'Error al escanear recibo',
			'expenses.receiptScanned' => 'Recibo escaneado',
			'expenses.amount' => 'Monto',
			'expenses.enterAmount' => 'Por favor ingrese un monto',
			'expenses.validNumber' => 'Por favor ingrese un número válido',
			'expenses.description' => 'Descripción',
			'expenses.categoryOptional' => 'Categoría (Opcional)',
			'expenses.date' => 'Fecha',
			'expenses.saveExpense' => 'Guardar Gasto',
			'expenses.scanReceipt' => 'Escanear Recibo',
			_ => null,
		};
	}
}
