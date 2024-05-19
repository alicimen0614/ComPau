import 'package:community_social_media/const/context_extension.dart';
import 'package:community_social_media/models/event_model.dart';
import 'package:community_social_media/screens/events_screen/add_event_screen.dart';
import 'package:community_social_media/services/firestore_service.dart';
import 'package:community_social_media/widgets/event_item_widget.dart';
import 'package:flutter/material.dart';

final firestoreService = FirestoreService();

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF007dc4),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddEventScreen()));
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          toolbarHeight: 25,
          bottom: const TabBar(
              tabAlignment: TabAlignment.center,
              unselectedLabelColor: const Color(0xFF004485),
              indicatorColor: const Color(0xFF004485),
              labelColor: const Color(0xFF004485),
              isScrollable: false,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: TextStyle(
                fontSize: 15,
                fontFamily: "Nunito Sans",
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                Tab(
                  text: "Yaklaşan Etkinlikler",
                ),
                Tab(
                  text: "Geçmiş Etkinlikler",
                ),
              ]),
        ),
        body: TabBarView(
          children: [loadData(context, false), loadData(context, true)],
        ),
      ),
    );
  }

  Padding loadData(BuildContext context, bool bringHistory) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: context.dynamicHeight(.01)),
        child: FutureBuilder(
          future: firestoreService.getEvent(),
          builder: (context, snapshot) {
            List<EventModel>? events = [];
            if (snapshot.hasData) {
              if (bringHistory == false) {
                events = snapshot.data
                    ?.where(
                        (element) => element.eventDate!.isAfter(DateTime.now()))
                    .toList();
              } else {
                events = snapshot.data
                    ?.where((element) =>
                        element.eventDate!.isBefore(DateTime.now()))
                    .toList();
              }

              return ListView.builder(
                itemCount: events?.length,
                itemBuilder: (context, index) {
                  return EventItemWidget(
                    event: events![index],
                  );
                },
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text("Error"));
            }
          },
        ));
  }
}
