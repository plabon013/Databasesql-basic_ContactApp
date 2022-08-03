import 'package:contact_app/pages/contact_details_page.dart';
import 'package:contact_app/pages/new_contact_page.dart';
import 'package:contact_app/provider/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactListPage extends StatefulWidget {
  static const String routeName='/contact_list';
  // const ContactListPage({Key? key}) : super(key: key);

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact list'),
      ),
      body: Consumer<ContactProvider>(
        builder: (context,provider,_)=>ListView.builder(
            itemCount: provider.contactList.length,
            itemBuilder: (context,index){
              final contact=provider.contactList[index];
              return Dismissible(
                //key:uniquekey();
                key: ValueKey(contact.id),
                direction:  DismissDirection.endToStart,
                confirmDismiss: _showConfirmationDialog,
                onDismissed: (direction){
                  provider.deleteContact(contact.id!);
                },
                background:  Container(
                  alignment: Alignment.centerRight,
                  color: Colors.red,
                  child: const Icon(Icons.delete,color: Colors.white,),
                ),
                child: ListTile(
                  onTap:()=>Navigator.pushNamed(context, ContactDetailsPage.routeName,arguments: contact.id),
                  title: Text(contact.name),
                  subtitle: Text(contact.number),
                  trailing: IconButton(
                    icon: Icon(contact.favourite?Icons.favorite:Icons.favorite_border),
                    onPressed: (){
                      final value=contact.favourite?0:1;
                      provider.updateFavorite(contact.id!,value , index);
                    },
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, NewContactPage.routeName);
              },
              child: Icon(Icons.add),
              tooltip: 'Add new contact',
    ),
    );
  }


  Future<bool?> _showConfirmationDialog(DismissDirection direction) {
    return showDialog(context: context,
        builder: (context)=>AlertDialog(
          title: const Text('Delete Contact') ,
          content:  const Text('Are you sure to delete this contact?'),
          actions: [
            TextButton(onPressed: ()=>Navigator.pop(context,false),
                child: const Text('No')),
            TextButton(onPressed: ()=>Navigator.pop(), child: child)

          ],
        ));
  }
  }

