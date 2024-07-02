// Define the base URL for the local Django REST framework server
// const String baseUrl = 'http://10.0.2.2:8000/api/todos/';
const String baseUrl = 'https://crud-op-uy0p.onrender.com/api/todos/';
// Retrieve URL
var retrieveUrl = Uri.parse(baseUrl);

// Delete URL
Uri deleteUrl({int? id}) {
  final String url = '${baseUrl}${id}/';
  return Uri.parse(url);
}

// Create URL
var createURL = Uri.parse('${baseUrl}');

// Update URL
Uri updateUrl({int? id}) {
  final String url = '${baseUrl}${id}/';
  return Uri.parse(url);
}
