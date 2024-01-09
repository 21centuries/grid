import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int m = 0;
  int n = 0;
  List<List<String>> grid = [];
  String searchText = '';
  List<int> searchedIndices = [];

  void createGrid() {
    grid = List.generate(m, (i) => List.generate(n, (j) => ''));
  }

  void updateGrid() {
    showDialog(
      context: context,
      builder: (context) => createGridDialog(),
    );
  }

  bool searchGrid() {
    List<String> diagonal = [];

    searchedIndices.clear();

    for (int i = 0; i < m; i++) {
      for (int j = 0; j <= n - searchText.length; j++) {
        if (grid[i].sublist(j, j + searchText.length).join() == searchText) {
          for (int k = 0; k < searchText.length; k++) {
            searchedIndices.add(i * n + (j + k));
          }
          return true;
        }
      }
    }

    for (int i = 0; i < n; i++) {
      for (int j = 0; j <= m - searchText.length; j++) {
        if (List.generate(searchText.length, (index) => grid[j + index][i])
                .join() ==
            searchText) {
          for (int k = 0; k < searchText.length; k++) {
            searchedIndices.add((j + k) * n + i);
          }
          return true;
        }
      }
    }

    for (int i = 0; i <= m - searchText.length; i++) {
      for (int j = 0; j <= n - searchText.length; j++) {
        diagonal.clear();
        for (int k = 0; k < searchText.length; k++) {
          diagonal.add(grid[i + k][j + k]);
        }
        if (diagonal.join() == searchText) {
          for (int k = 0; k < searchText.length; k++) {
            searchedIndices.add((i + k) * n + (j + k));
          }
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grid App'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Enter m (rows)'),
                      onChanged: (value) {
                        setState(() {
                          m = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Enter n (columns)'),
                      onChanged: (value) {
                        setState(() {
                          n = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (m == 0 || n == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enter no of Rows & Columns'),
                      ),
                    );
                    return;
                  }
                  createGrid();
                  showDialog(
                    context: context,
                    builder: (context) => createGridDialog(),
                  );
                },
                child: const Text('Create Grid'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (grid.isNotEmpty) {
                    updateGrid();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Create Grid First'),
                      ),
                    );
                  }
                },
                child: const Text('Update Grid'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Enter text to search',
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (!searchGrid()) {
                        showDialog(
                          context: context,
                          builder: (context) => searchResultDialog(),
                        );
                      }
                      setState(() {});
                    },
                    child: const Text('Search Grid'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              if (grid.isNotEmpty)
                const Text(
                  'Grid',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 16),
              if (grid.isNotEmpty)
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: n,
                  ),
                  itemCount: m * n,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int row = index ~/ n;
                    int col = index % n;
                    bool isSearched = searchedIndices.contains(index);

                    return Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: isSearched ? Colors.yellow : null,
                      ),
                      child: Text(
                        grid[row][col],
                        style: TextStyle(
                          fontSize: 20,
                          color: isSearched ? Colors.blue : Colors.black,
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createGridDialog() {
    return AlertDialog(
      title: const Text('Enter Alphabets for Grid'),
      content: Container(
        height: 200,
        width: 200,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: n,
          ),
          itemCount: m * n,
          itemBuilder: (context, index) {
            int row = index ~/ n;
            int col = index % n;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                maxLength: 1,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  setState(() {
                    grid[row][col] = value;
                  });
                },
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Done'),
        ),
      ],
    );
  }

  Widget searchResultDialog() {
    return AlertDialog(
      title: const Text('Search Result'),
      content: searchedIndices.isNotEmpty
          ? Text(
              'Search Result: ${searchedIndices.map((index) => grid[index ~/ n][index % n]).join()}')
          : const Text('Text not found in the grid.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
