import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
// Make sure this matches your pubspec.yaml name
import 'package:expense_manager_api/database.dart';
import 'package:expense_manager_api/api_router.dart';

// 1. A robust CORS Middleware
Middleware corsMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      // Intercept OPTIONS preflight requests before they hit the router
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Origin, Content-Type',
        });
      }

      // Let the router handle normal requests (GET, POST, etc.)
      final response = await innerHandler(request);

      // Append CORS headers to the router's response
      return response.change(headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type',
      });
    };
  };
}

void main(List<String> args) async {
  // Initialize Database
  final dbHelper = DatabaseHelper();
  dbHelper.initDb();

  // Setup Router
  final api = ApiRouter(dbHelper);
  final router = api.router;

  // Configure Pipeline (Notice we use corsMiddleware() now)
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsMiddleware())
      .addHandler(router.call);

  // Start Server
  final server = await io.serve(handler, 'localhost', 8080);
  print('Backend running on http://localhost:${server.port}');
}
