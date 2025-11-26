///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'Gastos Mensuales'
	String get appName => 'Gastos Mensuales';

	late final TranslationsCommonEn common = TranslationsCommonEn._(_root);
	late final TranslationsDashboardEn dashboard = TranslationsDashboardEn._(_root);
	late final TranslationsTransactionsEn transactions = TranslationsTransactionsEn._(_root);
	late final TranslationsCategoriesEn categories = TranslationsCategoriesEn._(_root);
	late final TranslationsReportsEn reports = TranslationsReportsEn._(_root);
	late final TranslationsSettingsEn settings = TranslationsSettingsEn._(_root);
	late final TranslationsFiltersEn filters = TranslationsFiltersEn._(_root);
	late final TranslationsExpensesEn expenses = TranslationsExpensesEn._(_root);
}

// Path: common
class TranslationsCommonEn {
	TranslationsCommonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Add'
	String get add => 'Add';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'Filter'
	String get filter => 'Filter';

	/// en: 'All'
	String get all => 'All';

	/// en: 'Loading...'
	String get loading => 'Loading...';

	/// en: 'Error'
	String get error => 'Error';

	/// en: 'Success'
	String get success => 'Success';

	/// en: 'No data available'
	String get noData => 'No data available';
}

// Path: dashboard
class TranslationsDashboardEn {
	TranslationsDashboardEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Finance'
	String get title => 'Finance';

	/// en: 'Total Balance'
	String get totalBalance => 'Total Balance';

	/// en: 'Income'
	String get income => 'Income';

	/// en: 'Expenses'
	String get expenses => 'Expenses';

	/// en: 'Recent Transactions'
	String get recentTransactions => 'Recent Transactions';

	/// en: 'See all'
	String get seeAll => 'See all';

	/// en: 'You are on Top'
	String get youAreOnTop => 'You are on Top';

	/// en: 'of your Finances'
	String get ofYourFinances => 'of your Finances';

	/// en: 'No transactions yet'
	String get noTransactions => 'No transactions yet';
}

// Path: transactions
class TranslationsTransactionsEn {
	TranslationsTransactionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Income'
	String get income => 'Income';

	/// en: 'Expense'
	String get expense => 'Expense';

	/// en: 'Amount'
	String get amount => 'Amount';

	/// en: 'Description'
	String get description => 'Description';

	/// en: 'Category'
	String get category => 'Category';

	/// en: 'Date'
	String get date => 'Date';

	/// en: 'Receipt'
	String get receipt => 'Receipt';

	/// en: 'Add Income'
	String get addIncome => 'Add Income';

	/// en: 'Add Expense'
	String get addExpense => 'Add Expense';

	/// en: 'Edit Transaction'
	String get editTransaction => 'Edit Transaction';

	/// en: 'Delete Transaction'
	String get deleteTransaction => 'Delete Transaction';

	/// en: 'Scan Receipt'
	String get scanReceipt => 'Scan Receipt';

	/// en: 'Take Photo'
	String get takePhoto => 'Take Photo';

	/// en: 'Choose from Gallery'
	String get chooseFromGallery => 'Choose from Gallery';

	/// en: 'Save Income'
	String get saveIncome => 'Save Income';
}

// Path: categories
class TranslationsCategoriesEn {
	TranslationsCategoriesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Categories'
	String get title => 'Categories';

	/// en: 'Add Category'
	String get addCategory => 'Add Category';

	/// en: 'Edit Category'
	String get editCategory => 'Edit Category';

	/// en: 'Delete Category'
	String get deleteCategory => 'Delete Category';

	/// en: 'Select Category'
	String get selectCategory => 'Select Category';

	/// en: 'Custom Categories'
	String get customCategories => 'Custom Categories';

	late final TranslationsCategoriesDefaultCategoriesEn defaultCategories = TranslationsCategoriesDefaultCategoriesEn._(_root);
}

// Path: reports
class TranslationsReportsEn {
	TranslationsReportsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Reports'
	String get title => 'Reports';

	/// en: 'By Category'
	String get byCategory => 'By Category';

	/// en: 'By Date'
	String get byDate => 'By Date';

	/// en: 'Export PDF'
	String get exportPDF => 'Export PDF';

	/// en: 'Export Excel'
	String get exportExcel => 'Export Excel';

	/// en: 'Total Spent'
	String get totalSpent => 'Total Spent';

	/// en: 'Average per Day'
	String get averagePerDay => 'Average per Day';

	/// en: 'Top Categories'
	String get topCategories => 'Top Categories';
}

// Path: settings
class TranslationsSettingsEn {
	TranslationsSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Theme'
	String get theme => 'Theme';

	/// en: 'Currency'
	String get currency => 'Currency';

	/// en: 'Notifications'
	String get notifications => 'Notifications';
}

// Path: filters
class TranslationsFiltersEn {
	TranslationsFiltersEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Filter Transactions'
	String get filterTransactions => 'Filter Transactions';

	/// en: 'By Type'
	String get byType => 'By Type';

	/// en: 'By Category'
	String get byCategory => 'By Category';

	/// en: 'By Date Range'
	String get byDateRange => 'By Date Range';

	/// en: 'Apply'
	String get apply => 'Apply';

	/// en: 'Clear'
	String get clear => 'Clear';
}

// Path: expenses
class TranslationsExpensesEn {
	TranslationsExpensesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add Expense'
	String get addExpense => 'Add Expense';

	/// en: 'Select Image Source'
	String get selectImageSource => 'Select Image Source';

	/// en: 'Camera'
	String get camera => 'Camera';

	/// en: 'Gallery'
	String get gallery => 'Gallery';

	/// en: 'Detected'
	String get detected => 'Detected';

	/// en: 'Detected amount'
	String get detectedAmount => 'Detected amount';

	/// en: 'Detected merchant'
	String get detectedMerchant => 'Detected merchant';

	/// en: 'Could not detect info. Please enter manually.'
	String get noInfoDetected => 'Could not detect info. Please enter manually.';

	/// en: 'Error scanning receipt'
	String get scanError => 'Error scanning receipt';

	/// en: 'Receipt scanned'
	String get receiptScanned => 'Receipt scanned';

	/// en: 'Amount'
	String get amount => 'Amount';

	/// en: 'Please enter an amount'
	String get enterAmount => 'Please enter an amount';

	/// en: 'Please enter a valid number'
	String get validNumber => 'Please enter a valid number';

	/// en: 'Description'
	String get description => 'Description';

	/// en: 'Category (Optional)'
	String get categoryOptional => 'Category (Optional)';

	/// en: 'Date'
	String get date => 'Date';

	/// en: 'Save Expense'
	String get saveExpense => 'Save Expense';

	/// en: 'Scan Receipt'
	String get scanReceipt => 'Scan Receipt';
}

// Path: categories.defaultCategories
class TranslationsCategoriesDefaultCategoriesEn {
	TranslationsCategoriesDefaultCategoriesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Subscriptions'
	String get subscriptions => 'Subscriptions';

	/// en: 'Groceries'
	String get groceries => 'Groceries';

	/// en: 'Fast Food'
	String get fastFood => 'Fast Food';

	/// en: 'Restaurant'
	String get restaurant => 'Restaurant';

	/// en: 'Entertainment'
	String get entertainment => 'Entertainment';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => 'Gastos Mensuales',
			'common.cancel' => 'Cancel',
			'common.save' => 'Save',
			'common.delete' => 'Delete',
			'common.edit' => 'Edit',
			'common.add' => 'Add',
			'common.search' => 'Search',
			'common.filter' => 'Filter',
			'common.all' => 'All',
			'common.loading' => 'Loading...',
			'common.error' => 'Error',
			'common.success' => 'Success',
			'common.noData' => 'No data available',
			'dashboard.title' => 'Finance',
			'dashboard.totalBalance' => 'Total Balance',
			'dashboard.income' => 'Income',
			'dashboard.expenses' => 'Expenses',
			'dashboard.recentTransactions' => 'Recent Transactions',
			'dashboard.seeAll' => 'See all',
			'dashboard.youAreOnTop' => 'You are on Top',
			'dashboard.ofYourFinances' => 'of your Finances',
			'dashboard.noTransactions' => 'No transactions yet',
			'transactions.income' => 'Income',
			'transactions.expense' => 'Expense',
			'transactions.amount' => 'Amount',
			'transactions.description' => 'Description',
			'transactions.category' => 'Category',
			'transactions.date' => 'Date',
			'transactions.receipt' => 'Receipt',
			'transactions.addIncome' => 'Add Income',
			'transactions.addExpense' => 'Add Expense',
			'transactions.editTransaction' => 'Edit Transaction',
			'transactions.deleteTransaction' => 'Delete Transaction',
			'transactions.scanReceipt' => 'Scan Receipt',
			'transactions.takePhoto' => 'Take Photo',
			'transactions.chooseFromGallery' => 'Choose from Gallery',
			'transactions.saveIncome' => 'Save Income',
			'categories.title' => 'Categories',
			'categories.addCategory' => 'Add Category',
			'categories.editCategory' => 'Edit Category',
			'categories.deleteCategory' => 'Delete Category',
			'categories.selectCategory' => 'Select Category',
			'categories.customCategories' => 'Custom Categories',
			'categories.defaultCategories.home' => 'Home',
			'categories.defaultCategories.subscriptions' => 'Subscriptions',
			'categories.defaultCategories.groceries' => 'Groceries',
			'categories.defaultCategories.fastFood' => 'Fast Food',
			'categories.defaultCategories.restaurant' => 'Restaurant',
			'categories.defaultCategories.entertainment' => 'Entertainment',
			'reports.title' => 'Reports',
			'reports.byCategory' => 'By Category',
			'reports.byDate' => 'By Date',
			'reports.exportPDF' => 'Export PDF',
			'reports.exportExcel' => 'Export Excel',
			'reports.totalSpent' => 'Total Spent',
			'reports.averagePerDay' => 'Average per Day',
			'reports.topCategories' => 'Top Categories',
			'settings.title' => 'Settings',
			'settings.language' => 'Language',
			'settings.theme' => 'Theme',
			'settings.currency' => 'Currency',
			'settings.notifications' => 'Notifications',
			'filters.filterTransactions' => 'Filter Transactions',
			'filters.byType' => 'By Type',
			'filters.byCategory' => 'By Category',
			'filters.byDateRange' => 'By Date Range',
			'filters.apply' => 'Apply',
			'filters.clear' => 'Clear',
			'expenses.addExpense' => 'Add Expense',
			'expenses.selectImageSource' => 'Select Image Source',
			'expenses.camera' => 'Camera',
			'expenses.gallery' => 'Gallery',
			'expenses.detected' => 'Detected',
			'expenses.detectedAmount' => 'Detected amount',
			'expenses.detectedMerchant' => 'Detected merchant',
			'expenses.noInfoDetected' => 'Could not detect info. Please enter manually.',
			'expenses.scanError' => 'Error scanning receipt',
			'expenses.receiptScanned' => 'Receipt scanned',
			'expenses.amount' => 'Amount',
			'expenses.enterAmount' => 'Please enter an amount',
			'expenses.validNumber' => 'Please enter a valid number',
			'expenses.description' => 'Description',
			'expenses.categoryOptional' => 'Category (Optional)',
			'expenses.date' => 'Date',
			'expenses.saveExpense' => 'Save Expense',
			'expenses.scanReceipt' => 'Scan Receipt',
			_ => null,
		};
	}
}
