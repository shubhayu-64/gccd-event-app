import 'package:ccdeventapp/blocs/auth_bloc.dart';
import 'package:ccdeventapp/blocs/referral_bloc.dart';
import 'package:ccdeventapp/blocs/ticket_status_bloc.dart';
import 'package:ccdeventapp/entrypoint/navigation_screen.dart';
import 'package:ccdeventapp/models/ticket_form_model.dart';
import 'package:ccdeventapp/utils/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// {@category Blocs}
class TicketFormBloc extends ChangeNotifier {
  ///State variable used to check if registrant data upload is in progress
  bool _entryCreationInProgress = false;

  bool get entryCreationInProgress => _entryCreationInProgress;

  ///Function to create new registration for CCD 2022
  Future createNewRegistration(
    String uid,
    TicketFormModel model,
    TicketStatusBloc tsb,
    AuthBloc ab,
    ReferralBloc rb,
    BuildContext context,
  ) async {
    _entryCreationInProgress = true;
    notifyListeners();

    await FirebaseFirestore.instance
        .collection(Config.fscTicketFormRegistrations)
        .doc(uid)
        .set(model.toMap());

    if (ab.referralCode != "") {
      await rb.changeOngoingReferralToCompletedReferral(uid, ab.referralCode);
    }

    _entryCreationInProgress = false;
    goToNavigationScreen(context);
    notifyListeners();

    ///Call to check Ticket Status made to update ui to under review status
    tsb.checkTicketStatus();
  }

  ///Function to give control back to the main navigation component
  void goToNavigationScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        return const NavigationScreen();
      }),
    );
  }
}
