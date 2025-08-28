import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:split_app_user/src/models/member.dart';

class AddMembersScreen extends StatefulWidget {
  static const routeName = '/add-members';
  final Member defaultMember; 

  const AddMembersScreen({super.key, required this.defaultMember});

  @override
  State<AddMembersScreen> createState() => _AddMembersScreenState();
}

class _AddMembersScreenState extends State<AddMembersScreen> {
  List<Member> _all = [];
  final Set<String> _picked = {}; 
  bool _loading = true;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _picked.add(widget.defaultMember.id); 
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts(
        withProperties: true,
      );

      if (!mounted) return;

      setState(() {
        _all = contacts
            .where((c) => c.displayName != widget.defaultMember.name)
            .map((c) => Member(id: c.id, name: c.displayName))
            .toList();
        _loading = false;
      });
    } else {
      if (!mounted) return;

      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contacts permission denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _all
        .where((m) => m.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Add Members')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                    ),
                    onChanged: (v) => setState(() => _search = v),
                  ),
                ),
                
                ListTile(
                  title: Text(widget.defaultMember.name),
                  leading: const Icon(Icons.person),
                  trailing: const Text('Required'), 
                ),
                const Divider(),
                Expanded(
                  child: ListView(
                    children: filtered.map((m) {
                      final selected = _picked.contains(m.id);
                      return CheckboxListTile(
                        value: selected,
                        onChanged: (v) => setState(() {
                          if (v == true) {
                            _picked.add(m.id);
                          } else {
                            _picked.remove(m.id);
                          }
                        }),
                        title: Text(m.name),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton(
                    onPressed: () {
                      final chosen = [
                        widget.defaultMember,
                        ..._all.where((m) => _picked.contains(m.id)),
                      ];
                      Navigator.pop(context, chosen);
                    },
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
    );
  }
}
