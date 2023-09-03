import 'package:flutter/material.dart';

class Patients extends StatefulWidget {
  final String? name;
  final bool isDicharged;
  const Patients({
    super.key,
    this.name,
    required this.isDicharged
  });

  @override
  State<Patients> createState() => _PatientsState();
}

class _PatientsState extends State<Patients> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
          title: Text(
              widget.name == null ? "Null" : widget.name.toString()
          ),
          trailing: Icon(
              Icons.circle,
            color:
            widget.isDicharged
                ? Colors.green
                : Colors.red,
          ),
      ),
    );
  }
}
