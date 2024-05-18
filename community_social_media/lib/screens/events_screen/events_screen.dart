import 'package:community_social_media/const/context_extension.dart';
import 'package:community_social_media/models/Event_model.dart';
import 'package:community_social_media/screens/events_screen/add_event_screen.dart';
import 'package:community_social_media/widgets/event_item_widget.dart';
import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF007dc4),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddEventScreen()));
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          'Etkinlikler',
          style: context.textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.dynamicHeight(.01)),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return EventItemWidget(
              event: EventModel(
                eventImageUrl: "lib/assets/images/kedi.jpg",
                description:
                    ' mkcmsdmcmdkcmkmc kmckmkmc kmckmckmc mckdm mkcmdkmcdcmdm mmdcdcm mmmcmcm cdcmdcmd c  dcm dcm',
              ),
            );
          },
        ),
      ),
    );
  }
}
