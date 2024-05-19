import 'dart:io';

import 'package:community_social_media/const/context_extension.dart';
import 'package:community_social_media/models/event_model.dart';
import 'package:community_social_media/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../widgets/elevated_button_widget.dart';

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
  final _fireStoreService = FirestoreService();

  File? pickedImage;
  Uint8List? imageAsByte;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: context.height,
          child: Padding(
            padding: context.paddingAllDefault,
            child: Column(
              children: [
                _buildAspectRatio(context),
                SizedBox(
                  height: context.dynamicHeight(.05),
                ),
                TextField(
                  maxLines: null,
                  controller: titleController,
                  decoration: const InputDecoration(
                      filled: true,
                      counterStyle: TextStyle(color: Colors.white),
                      hintText: 'Etkinlik Başlık..',
                      fillColor: Colors.white,
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: context.dynamicHeight(.05),
                ),
                TextField(
                  maxLines: null,
                  controller:
                      descriptionController, // Attach the controller to the TextField
                  decoration: const InputDecoration(
                      filled: true,
                      counterStyle: TextStyle(color: Colors.white),
                      hintText: 'Etkinlik Açıklaması..',
                      fillColor: Colors.white,
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: context.dynamicHeight(.05),
                ),
                TextField(
                  maxLines: null,
                  controller:
                      locationController, // Attach the controller to the TextField
                  decoration: const InputDecoration(
                      filled: true,
                      counterStyle: TextStyle(color: Colors.white),
                      hintText: 'Etkinlik konum..',
                      fillColor: Colors.white,
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: context.dynamicHeight(.05),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null
                          ? 'No date selected!'
                          : 'Tarih: ${DateFormat('dd.MM.yyyy').format(selectedDate!)}',
                      style: context.textTheme.headlineMedium,
                    ),
                    IconButton(
                      onPressed: () {
                        _selectDate(context);
                        debugPrint(
                            'Tarih : ${DateFormat('dd.MM.yyyy').format(selectedDate!)}');
                      },
                      icon: const Icon(
                        Icons.calendar_month_rounded,
                        size: 30,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: context.dynamicHeight(.05),
                ),
                CustomElevatedButton(
                  btnTitle: 'Paylaş',
                  onPressed: () async {
                    debugPrint('event submit');
                    final navigator = Navigator.of(context);
                    EventModel newEvent = EventModel(
                      eventTitle: titleController.text,
                      description: descriptionController.text == ""
                          ? null
                          : descriptionController.text,
                      
                      eventDate: selectedDate,
                      location: locationController.text
                    );
                    String imageUrl =
                        await _fireStoreService.uploadImage(pickedImage!);
                    newEvent.eventImageUrl = imageUrl;
                    await _fireStoreService.createEvent(newEvent);
                    navigator.pop();
                  },
                  btnColor: Colors.blue,
                  textColor: Colors.white,
                ),
              ],
            ),
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
      // ignore: empty_catches
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
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
