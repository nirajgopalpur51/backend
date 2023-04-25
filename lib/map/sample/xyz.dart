import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class xyz extends StatefulWidget {
  const xyz({super.key});

  @override
  State<xyz> createState() => _xyzState();
}

class _xyzState extends State<xyz> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _date = TextEditingController();
    return Scaffold(
        body: ElevatedButton(
      child: Text("Prees"),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Column(
              children: [
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.call),
                  title: Text("Contact"),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: TextField(
                    keyboardType: TextInputType.none,
                    controller: _date,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today_rounded),
                      labelText: "Select Date",
                    ),
                    onTap: () async {
                      DateTime? pickDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));

                      if (pickDate != null) {
                        setState(() {
                          _date.text =
                              DateFormat('dd-MM-yyyy').format(pickDate);
                        });
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Wrap(children: [
                            AlertDialog(
                              title: Text("Order Done Successfully 🎉"),
                            ),
                          ]);
                        },
                      );
                    },
                    child: Text("Order Now")),
              ],
            );
          },
        );
      },
    ));
  }
}
