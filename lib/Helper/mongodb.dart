import 'package:fyp_sports_v3/Models/pdfmodel.dart';
import 'package:fyp_sports_v3/main.dart';
import 'package:mongo_dart/mongo_dart.dart';

final String mongoDbUrl =
    'mongodb+srv://sportswebfyp:Sportsfyp_007@sportsfypdb.ynkpwrv.mongodb.net/';
final String dbName = 'SportsDB';
final String collectionName = 'col_Player';
final String organizationColName = 'col_Organization';
final String trialcollection = 'col_Trials';

class MongoDatabase {
  static connectdb() async {
    var db = await Db.create(mongoDbUrl);
    await db.open();
    // inspect(db);
    // var status = db.serverStatus();
    // print(status);
    // var collection = db.collection(collectionName);
    // print(await collection.find().toList());
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
        'isapproved': 0
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

  static Future<Map<String, dynamic>?> loginorg(
      String email, String password) async {
    try {
      var db = await Db.create(mongoDbUrl);
      await db.open();

      var collection = db.collection(organizationColName);
      var result = await collection.findOne({
        'orgemail': email,
        'orgpassword': password,
      });

      await db.close();

      // If result is not null, login successful
      return result;
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  static Future<bool> deleteAllData() async {
    try {
      var db = await Db.create(mongoDbUrl);
      await db.open();

      var playerCollection = db.collection(collectionName);
      var organizationCollection = db.collection(organizationColName);

      await playerCollection.remove({});
      await organizationCollection.remove({});

      await db.close();
      return true;
    } catch (e) {
      print('Error deleting data from MongoDB: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchOrganizations() async {
    try {
      var db = await Db.create(mongoDbUrl);
      await db.open();

      var collection = db.collection(organizationColName);
      var organizations = await collection.find().toList();

      await db.close();
      return organizations;
    } catch (e) {
      print('Error fetching organizations: $e');
      return [];
    }
  }

  static Future<bool> updateOrganizationApprovalStatus(
      String id, int status) async {
    try {
      var db = await Db.create(mongoDbUrl);
      await db.open();

      var collection = db.collection(organizationColName);
      var result = await collection.update(
        where.id(ObjectId.fromHexString(id)),
        modify.set('isapproved', status),
      );

      await db.close();
      return result['nModified'] > 0;
    } catch (e) {
      print('Error updating organization status: $e');
      return false;
    }
  }

  static Future<bool> addTrial(
    String trialName,
    String trialCategory,
    DateTime trialDate,
    String trialTime,
    String location,
    String description,
    String organizer,
  ) async {
    try {
      var db = await Db.create(mongoDbUrl);
      await db.open();
      var collection = db.collection(trialcollection);
      await collection.insert({
        'trialName': trialName,
        'trialCategory': trialCategory,
        'trialDate': trialDate.toIso8601String(),
        'trialTime': trialTime,
        'location': location,
        'description': description,
        'organizer': organizer,
        'organizeremail': prefs.getString('orgemail'),
      });
      await db.close();
      return true;
    } catch (e) {
      print('Error adding trial to MongoDB: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchTrialsByOrganizationEmail(
      String email) async {
    try {
      var db = await Db.create(mongoDbUrl);
      await db.open();

      var collection = db.collection(trialcollection);
      var trials = await collection.find({'organizeremail': email}).toList();

      await db.close();
      return trials;
    } catch (e) {
      print('Error fetching trials: $e');
      return [];
    }
  }
}
