import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

final financeRepositoryProvider = Provider<FinanceRepository>(
  (ref) => throw UnimplementedError(),
);

final transactionsProvider = FutureProvider<List<FinanceTransaction>>(
  (ref) => ref.watch(financeRepositoryProvider).transactions(),
);
final goalsProvider = FutureProvider<List<SavingsGoal>>(
  (ref) => ref.watch(financeRepositoryProvider).goals(),
);

class SavingsGoal {
  const SavingsGoal({
    required this.id,
    required this.name,
    required this.target,
    required this.saved,
    this.dueDate,
  });
  final int? id;
  final String name;
  final double target;
  final double saved;
  final DateTime? dueDate;
  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'target': target,
    'saved': saved,
    'due_date': dueDate?.toIso8601String(),
  };
  factory SavingsGoal.fromMap(Map<String, Object?> row) => SavingsGoal(
    id: row['id'] as int,
    name: row['name'] as String,
    target: (row['target'] as num).toDouble(),
    saved: (row['saved'] as num).toDouble(),
    dueDate:
        row['due_date'] == null
            ? null
            : DateTime.parse(row['due_date'] as String),
  );
}

class FinanceTransaction {
  const FinanceTransaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.note,
    required this.date,
    required this.isIncome,
    this.wallet = 'Cash',
  });

  final int? id;
  final double amount;
  final String category;
  final String note;
  final DateTime date;
  final bool isIncome;
  final String wallet;

  Map<String, Object?> toMap() => {
    'id': id,
    'amount': amount,
    'category': category,
    'note': note,
    'date': date.toIso8601String(),
    'is_income': isIncome ? 1 : 0,
    'wallet': wallet,
  };

  factory FinanceTransaction.fromMap(Map<String, Object?> row) =>
      FinanceTransaction(
        id: row['id'] as int,
        amount: (row['amount'] as num).toDouble(),
        category: row['category'] as String,
        note: row['note'] as String,
        date: DateTime.parse(row['date'] as String),
        isIncome: (row['is_income'] as int) == 1,
        wallet: row['wallet'] as String? ?? 'Cash',
      );
}

class FinanceRepository {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final root = await getDatabasesPath();
    _database = await openDatabase(
      p.join(root, 'masar_finance.db'),
      version: 3,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''CREATE TABLE goals (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            target REAL NOT NULL CHECK(target > 0),
            saved REAL NOT NULL DEFAULT 0 CHECK(saved >= 0),
            due_date TEXT
          )''');
        }
        if (oldVersion < 3) {
          await db.execute(
            "ALTER TABLE transactions ADD COLUMN wallet TEXT NOT NULL DEFAULT 'Cash'",
          );
        }
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL NOT NULL CHECK(amount > 0),
            category TEXT NOT NULL,
            note TEXT NOT NULL DEFAULT '',
            date TEXT NOT NULL,
            is_income INTEGER NOT NULL DEFAULT 0,
            wallet TEXT NOT NULL DEFAULT 'Cash'
          )
        ''');
        await db.execute(
          'CREATE INDEX transactions_date ON transactions(date)',
        );
        await db.execute('''CREATE TABLE goals (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          target REAL NOT NULL CHECK(target > 0),
          saved REAL NOT NULL DEFAULT 0 CHECK(saved >= 0),
          due_date TEXT
        )''');
      },
    );
    return _database!;
  }

  Future<List<FinanceTransaction>> transactions() async {
    final db = await database;
    final rows = await db.query('transactions', orderBy: 'date DESC, id DESC');
    return rows.map(FinanceTransaction.fromMap).toList(growable: false);
  }

  Future<void> add(FinanceTransaction transaction) async {
    final db = await database;
    await db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<SavingsGoal>> goals() async {
    final rows = await (await database).query('goals', orderBy: 'id DESC');
    return rows.map(SavingsGoal.fromMap).toList(growable: false);
  }

  Future<void> addGoal(SavingsGoal goal) async {
    await (await database).insert('goals', goal.toMap());
  }

  Future<void> contribute(SavingsGoal goal, double amount) async {
    await (await database).update(
      'goals',
      {'saved': goal.saved + amount},
      where: 'id = ?',
      whereArgs: [goal.id],
    );
  }

  Future<void> renameCategory(String oldName, String newName) async {
    final db = await database;
    await db.update(
      'transactions',
      {'category': newName},
      where: 'category = ? AND is_income = 0',
      whereArgs: [oldName],
    );
  }

  Future<void> renameWallet(String oldName, String newName) async {
    final db = await database;
    await db.update(
      'transactions',
      {'wallet': newName},
      where: 'wallet = ?',
      whereArgs: [oldName],
    );
  }

  Future<void> clearTransactions() async {
    await (await database).delete('transactions');
  }

  Future<void> resetFinancialData() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('transactions');
      await txn.delete('goals');
    });
  }

  Future<Map<String, Object?>> snapshot() async {
    final db = await database;
    return {
      'format': 'gaddash-backup',
      'version': 1,
      'transactions': await db.query('transactions', orderBy: 'id'),
      'goals': await db.query('goals', orderBy: 'id'),
    };
  }

  Future<void> restore(Map<String, dynamic> data) async {
    if (data['format'] != 'gaddash-backup' || data['version'] != 1) {
      throw const FormatException('Unsupported backup format');
    }
    final rawTransactions = data['transactions'];
    final rawGoals = data['goals'];
    if (rawTransactions is! List || rawGoals is! List) {
      throw const FormatException('Missing financial records');
    }
    final transactions = <Map<String, Object?>>[];
    final goals = <Map<String, Object?>>[];
    for (final raw in rawTransactions) {
      if (raw is! Map) throw const FormatException('Invalid transaction');
      final row = Map<String, Object?>.from(raw);
      if (row['id'] is! int ||
          row['amount'] is! num ||
          (row['amount'] as num) <= 0 ||
          row['category'] is! String ||
          row['note'] is! String ||
          row['date'] is! String ||
          DateTime.tryParse(row['date'] as String) == null ||
          (row['is_income'] != 0 && row['is_income'] != 1)) {
        throw const FormatException('Invalid transaction');
      }
      transactions.add(row);
    }
    for (final raw in rawGoals) {
      if (raw is! Map) throw const FormatException('Invalid goal');
      final row = Map<String, Object?>.from(raw);
      if (row['id'] is! int ||
          row['name'] is! String ||
          row['target'] is! num ||
          (row['target'] as num) <= 0 ||
          row['saved'] is! num ||
          (row['saved'] as num) < 0 ||
          (row['due_date'] != null &&
              (row['due_date'] is! String ||
                  DateTime.tryParse(row['due_date'] as String) == null))) {
        throw const FormatException('Invalid goal');
      }
      goals.add(row);
    }
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('transactions');
      await txn.delete('goals');
      for (final row in transactions) {
        await txn.insert('transactions', {
          'id': row['id'],
          'amount': row['amount'],
          'category': row['category'],
          'note': row['note'],
          'date': row['date'],
          'is_income': row['is_income'],
          'wallet': row['wallet'] is String ? row['wallet'] : 'Cash',
        });
      }
      for (final row in goals) {
        await txn.insert('goals', {
          'id': row['id'],
          'name': row['name'],
          'target': row['target'],
          'saved': row['saved'],
          'due_date': row['due_date'],
        });
      }
    });
  }
}
