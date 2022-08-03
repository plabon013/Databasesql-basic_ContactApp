import 'package:contact_app/db/db_helper.dart';
import 'package:contact_app/model/contact_model.dart';
import 'package:flutter/material.dart';

class ContactProvider extends ChangeNotifier{
  List<ContactModel>contactList=[];

  getAllContacts(){
    DBHelper.getAllContacts().then((value) {
      contactList=value;
      notifyListeners();
    });
  }

  Future<ContactModel> getContactById(int id)=> DBHelper.getContactById(id);


  addNewContact(ContactModel contactModel) async {
    final rowid=await DBHelper.insertContact(contactModel);
    if(rowid>0) {
      contactModel.id = rowid;
      contactList.add(contactModel);
      notifyListeners();

      return true;
    }
    return false;
  }
  updateFavorite(int id,int value,int index){
    DBHelper.updateFavoirte(id, value).then((_){
      contactList[index].favourite=!contactList[index].favourite;
      notifyListeners();
    });
  }
  deleteContact(int id) async{
    final rowId = await DBHelper.deleteContact(id);
    if(rowId>0){
      contactList.removeWhere((element) => element.id==id);
      notifyListeners();
    }
  }
}