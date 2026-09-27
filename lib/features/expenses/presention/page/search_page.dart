import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textSearch = TextEditingController();
  final List<String> names = [
    "Sumit",
    "Rahul",
    "Amit",
    "Rohit",
    "Ankit",
    "Vikas",
  ];
  List<String> searchList = [];
  @override
  void initState() {
    super.initState();
    searchList = names;
    _textSearch.addListener(() {
      searchData(_textSearch.text);
    });
  }

  void searchData(String value) {
    setState(() {
      searchList = names
          .where((name) => name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _textSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: _textSearch,
              decoration: InputDecoration(
                hintText: "Search name",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _textSearch.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _textSearch.clear();
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(searchList[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
