import 'package:contact_app/model/contact_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const String createTableContact = '''create table $tableContact( 
  $tableContactColId integer primary key,
  $tableContactColName text,
  $tableContactColNumber text,
  $tableContactColEmail text,
  $tableContactColAddress text,
  $tableContactColDob text,
  $tableContactColGender text,
  $tableContactColImage text,
  $tableContactColFavourite integer)''';

  static Future<Database> open() async {
    final rootPath = await getDatabasesPath();
    final dbpath = join(rootPath, 'contact.db');

    return openDatabase(
      dbpath,
      version: 1,
      onCreate: (db, version) {
        db.execute(createTableContact);
      },
    );
  }

  static Future<int> insertContact(ContactModel contactModel) async {
    final db = await open();
    return db.insert(tableContact, contactModel.toMap());
  }

  static Future<List<ContactModel>> getAllContacts() async {
    final db = await open();
    final List<Map<String, dynamic>> mapList = await db.query(tableContact);
    return List.generate(
        mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }

  static Future<ContactModel> getContactById(int id) async {
    final db = await open();
    final mapList = await db
        .query(tableContact, where: '$tableContactColId=? ', whereArgs: [id]);
    return ContactModel.fromMap(mapList.first);
  }

  static Future<int> updateFavoirte(int id, int value) async {
    final db = await open();
    return db.update(tableContact, {tableContactColFavourite: value},
        where: '$tableContactColId=? ', whereArgs: [id]);
  }
  static Future<int> deleteContact(int id) async{
    final db=await open();
    return db.delete(tableContact,where: '$tableContactColId=?',whereArgs: [id]);
  }
}
