import 'dart:io';
import 'package:community_social_media/const/context_extension.dart';
import 'package:community_social_media/models/event_model.dart';
import 'package:community_social_media/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/elevated_button_widget.dart';
import 'package:intl/intl.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({
    super.key,
  });

  @override
  State<AddEventScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<AddEventScreen> {
  DateTime? selectedDate;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();

  final _fireStoreService = FirestoreService();

  File? pickedImage;
  Uint8List? imageAsByte;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Etkinlik oluştur"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: context.paddingAllDefault,
          child: Column(
            children: [
              _buildAspectRatio(context),
              SizedBox(
                height: context.dynamicHeight(.03),
              ),
              TextField(
                maxLines: null,
                controller: titleController,
                decoration: InputDecoration(
                    filled: true,
                    counterStyle: const TextStyle(color: Colors.white),
                    hintText: 'Başlık',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
              SizedBox(
                height: context.dynamicHeight(.03),
              ),
              TextField(
                maxLines: null,
                controller:
                    descriptionController, // Attach the controller to the TextField
                decoration: InputDecoration(
                    filled: true,
                    counterStyle: const TextStyle(color: Colors.white),
                    hintText: 'Açıklama',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
              SizedBox(
                height: context.dynamicHeight(.03),
              ),
              TextField(
                maxLines: null,
                controller:
                    locationController, // Attach the controller to the TextField
                decoration: InputDecoration(
                    filled: true,
                    counterStyle: const TextStyle(color: Colors.white),
                    hintText: 'Konum',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
              SizedBox(
                height: context.dynamicHeight(.03),
              ),
              TextField(
                canRequestFocus: false,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  _selectDate(context);
                },
                maxLines: null,
                controller: dateController,
                decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.calendar_month_rounded,
                      size: 30,
                      color: Colors.black,
                    ),
                    filled: true,
                    counterStyle: const TextStyle(color: Colors.white),
                    hintText: 'Tarih',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
              SizedBox(
                height: context.dynamicHeight(.03),
              ),
              CustomElevatedButton(
                borderRadius: 25,
                btnTitle: 'Paylaş',
                onPressed: () async {
                  if (titleController.text.isEmpty ||
                      descriptionController.text.isEmpty ||
                      locationController.text.isEmpty ||
                      dateController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Lütfen tüm alanları doldurun")));
                  } else if (pickedImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Lütfen bir fotoğraf ekleyin")));
                  } else {
                    debugPrint('event submit');
                    final navigator = Navigator.of(context);
                    EventModel newEvent = EventModel(
                        eventTitle: titleController.text,
                        description: descriptionController.text == ""
                            ? null
                            : descriptionController.text,
                        eventDate: selectedDate,
                        location: locationController.text,
                        organizer: await _fireStoreService.getUserName(),
                        organizerId: FirebaseAuth.instance.currentUser!.uid,
                        organizerImage:
                            FirebaseAuth.instance.currentUser!.photoURL ?? "");

                    String imageUrl =
                        await _fireStoreService.uploadImage(pickedImage!);
                    newEvent.eventImageUrl = imageUrl;
                    await _fireStoreService.createEvent(newEvent);
                    navigator.pop();
                  }
                },
                btnColor: const Color(0xFF004485),
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AspectRatio _buildAspectRatio(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: pickedImage != null
          ? Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(
                    pickedImage!,
                  ),
                ),
              ),
            )
          : Container(
              color: Colors.grey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        size: 50,
                      ),
                      onPressed: () {
                        modalBottomSheetBuilderForPopUpMenu(context);
                      },
                    ),
                    const Text(
                      "Bir fotoğraf ekle",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )
                  ]),
            ),
    );
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
          source: source,
          preferredCameraDevice: CameraDevice.rear,
          maxHeight: 1000,
          maxWidth: 600,
          imageQuality: 100);
      if (image == null) {
        return;
      } else {
        final CroppedFile? croppedFile =
            await cropImage(file: image).whenComplete(() {
          Navigator.pop(context);
        });

        if (croppedFile != null) {
          imageAsByte = await croppedFile.readAsBytes();

          setState(() {
            pickedImage = File(croppedFile.path);
          });
        }
      }
    } on PlatformException {}
  }

  Future<CroppedFile?> cropImage({required XFile file}) async {
    return await ImageCropper().cropImage(
      sourcePath: file.path,
      uiSettings: [AndroidUiSettings(lockAspectRatio: false)],
    );
  }

  void modalBottomSheetBuilderForPopUpMenu(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.grey.shade300,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      context: context,
      builder: (context) {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            visualDensity: const VisualDensity(vertical: 3),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            onTap: () {
              pickImage(ImageSource.camera);
            },
            leading: const Icon(
              color: Colors.black,
              Icons.photo_camera_outlined,
              size: 30,
            ),
            title: const Text("Kamera", style: TextStyle(fontSize: 20)),
          ),
          const Divider(
            height: 0,
          ),
          ListTile(
            visualDensity: const VisualDensity(vertical: 3),
            onTap: () => pickImage(ImageSource.gallery),
            leading: const Icon(
              Icons.image_outlined,
              color: Colors.black,
              size: 30,
            ),
            title: const Text("Galeri", style: TextStyle(fontSize: 20)),
          ),
        ]);
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: "Bir saat seçin",
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? Container(),
        );
      },
    );
    if (picked != null && selectedTime != null) {
      DateTime dateTime = DateTime(picked!.year, picked.month, picked.day,
          selectedTime!.hour, selectedTime.minute);
      String formattedDateTime =
          DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
      print(formattedDateTime);

      setState(() {
        dateController.text = formattedDateTime;
        selectedDate = dateTime;
      });
    } else {}
  }
}
