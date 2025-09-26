import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/dto/FilmDto.dart';
import '../models/dto/RoomDto.dart';
import '../services/FilmService.dart';
import '../services/ProjectionService.dart';
import '../services/room_service.dart';

class AddProjectionScreen extends StatefulWidget {
  const AddProjectionScreen({super.key});

  @override
  State<AddProjectionScreen> createState() => _AddProjectionScreenState();
}

class _AddProjectionScreenState extends State<AddProjectionScreen> {
  List<Film> films = [];
  List<Room> rooms = [];

  Film? selectedFilm;
  Room? selectedRoom;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    final fetchedFilms = await FilmService.fetchAllFilms(size: 20);
    final fetchedRooms = await RoomService.fetchAllRooms();
    setState(() {
      films = fetchedFilms;
      rooms = fetchedRooms;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 18, minute: 0),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (selectedFilm == null || selectedRoom == null || selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    setState(() => isLoading = true);

    final success = await ProjectionService.addProjection(
      filmId: selectedFilm!.filmId,
      roomId: selectedRoom!.roomId,
      date: selectedDate!,
      time: selectedTime!,
    );

    setState(() => isLoading = false);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Projection added successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add projection')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Projection'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: DropdownButtonFormField<Film>(
                    isExpanded: true,
                    dropdownColor: Colors.grey[900],
                    value: selectedFilm,
                    hint: const Text("Select Film", style: TextStyle(color: Colors.white)),
                    items: films.map((film) {
                      return DropdownMenuItem<Film>(
                        value: film,
                        child: Text(
                          film.title,
                          style: const TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => selectedFilm = val),
                    decoration: const InputDecoration(
                      labelText: 'Film',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                    ),
                    iconEnabledColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: DropdownButtonFormField<Room>(
                    isExpanded: true,
                    dropdownColor: Colors.grey[900],
                    value: selectedRoom,
                    hint: const Text("Select Room", style: TextStyle(color: Colors.white)),
                    items: rooms.map((room) {
                      return DropdownMenuItem<Room>(
                        value: room,
                        child: Text(
                          room.name,
                          style: const TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => selectedRoom = val),
                    decoration: const InputDecoration(
                      labelText: 'Room',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                    ),
                    iconEnabledColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Date picker
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white70),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          selectedDate == null
                              ? 'Select Date'
                              : DateFormat('EEE, dd MMM yyyy').format(selectedDate!),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectTime(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.white70),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          selectedTime == null
                              ? 'Select Time'
                              : selectedTime!.format(context),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
