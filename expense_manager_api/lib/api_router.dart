import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'database.dart';

class ApiRouter {
  final DatabaseHelper dbHelper;

  ApiRouter(this.dbHelper);

  Router get router {
    final router = Router();

    router.post('/expenses', _createExpense);
    router.get('/expenses', _listExpenses);
    router.delete('/expenses/<id>', _deleteExpense);
    router.get('/summary', _getSummary);

    return router;
  }

  // Controller Methods
  Future<Response> _createExpense(Request req) async {
    try {
      final payload = await req.readAsString();
      final data = json.decode(payload);

      final amount = data['amount'];
      final category = data['category'];
      final date =
          data['date'] ?? DateTime.now().toIso8601String().split('T')[0];
      final description = data['description'] ?? '';

      // Validation
      if (amount == null ||
          amount <= 0 ||
          category == null ||
          category.toString().trim().isEmpty) {
        return Response.badRequest(
            body: json.encode({'error': 'Invalid amount or missing category'}));
      }

      dbHelper.database.execute(
          'INSERT INTO expenses (amount, category, date, description) VALUES (?, ?, ?, ?)',
          [amount, category, date, description]);
      return Response.ok(json.encode({'status': 'success'}));
    } catch (e) {
      return Response.internalServerError(
          body: json.encode({'error': 'Malformed request'}));
    }
  }

  Response _listExpenses(Request req) {
    final resultSet = dbHelper.database
        .select('SELECT * FROM expenses ORDER BY date DESC, id DESC');
    final expenses = resultSet
        .map((row) => {
              'id': row['id'],
              'amount': row['amount'],
              'category': row['category'],
              'date': row['date'],
              'description': row['description'],
            })
        .toList();

    return Response.ok(json.encode(expenses));
  }

  Response _deleteExpense(Request req, String id) {
    dbHelper.database.execute('DELETE FROM expenses WHERE id = ?', [id]);
    return Response.ok(json.encode({'status': 'deleted'}));
  }

  Response _getSummary(Request req) {
    final resultSet =
        dbHelper.database.select('SELECT SUM(amount) as total FROM expenses');
    final total = resultSet.first['total'] ?? 0.0;
    return Response.ok(json.encode({'total': total}));
  }
}
