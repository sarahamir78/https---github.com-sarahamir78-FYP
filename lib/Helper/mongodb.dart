import 'package:fyp_sports_v3/Models/pdfmodel.dart';
import 'package:mongo_dart/mongo_dart.dart';

final String mongoDbUrl =
    'mongodb+srv://sportswebfyp:Sportsfyp_007@sportsfypdb.ynkpwrv.mongodb.net/';
final String dbName = 'SportsDB';
final String collectionName = 'col_Player';
final String organizationColName = 'col_Organization';

class MongoDatabase {
  static connectdb() async {
    var db = await Db.create(mongoDbUrl);
    await db.open();
    // inspect(db);
    var status = db.serverStatus();
    print(status);
    var collection = db.collection(collectionName);
    print(await collection.find().toList());
  }

  static Future<bool> registerUser(
    String name,
    String email,
    String password,
    String cnic,
    String contact,
    String address,
    String organization,
    String? category,
    String? gender,
  ) async {
    try {
      var db = await Db.create(mongoDbUrl);
      await db.open();
      var collection = db.collection(collectionName);
      await collection.insert({
        'name': name,
        'email': email,
        'password': password,
        'cnic': cnic,
        'contact': contact,
        'address': address,
        'organization': organization,
        'category': category,
        'gender': gender,
      });
      await db.close();
      return true;
    } catch (e) {
      print('Error saving to MongoDB: $e');
      return false;
    }
  }

  static Future<bool> registerOrganization(
    String name,
    String email,
    String password,
    String location,
    String contact,
    String address,
    String organization,
    String? category,
    PdfFile? pdfFile,
  ) async {
    try {
      var db = await Db.create(mongoDbUrl);
      await db.open();
      var collection = db.collection(organizationColName);
      var pdfBytes = pdfFile != null ? await pdfFile.file.readAsBytes() : null;
      await collection.insert({
        'orgname': name,
        'orgemail': email,
        'orgpassword': password,
        'location': location,
        'contact': contact,
        'address': address,
        'organization': organization,
        'category': category,
        'pdf': pdfBytes, // Store PDF file as bytes in the database
      });
      await db.close();
      return true;
    } catch (e) {
      print('Error saving to MongoDB: $e');
      return false;
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      var db = await Db.create(mongoDbUrl);
      await db.open();

      var collection = db.collection(collectionName);
      var result = await collection.findOne({
        'email': email,
        'password': password,
      });

      await db.close();

      // If result is not null, login successful
      return result != null;
    } catch (e) {
      print('Error logging in: $e');
      return false;
    }
  }
}
