import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:telephony/telephony.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmergencyService {
  final int intervalMinutes;
  final String emergencyPhone;
  final void Function()? onEmergencyTriggered;

  final Telephony telephony = Telephony.instance;
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _player = AudioPlayer();

  Timer? _intervalTimer;
  Timer? _responseTimer;
  bool _waitingForReply = false;

  EmergencyService({
    required this.intervalMinutes,
    required this.emergencyPhone,
    this.onEmergencyTriggered,
  });

  void startMonitoring() {
    _startCheckCycle();
  }

  void _startCheckCycle() {
    _intervalTimer?.cancel();
    _intervalTimer = Timer.periodic(
      Duration(minutes: intervalMinutes),
      (_) => _askIfOkay(),
    );
    _askIfOkay(); // First check
  }

  void _askIfOkay() async {
    if (_waitingForReply) return;
    _waitingForReply = true;

    await _tts.speak("Are you okay?");
    _responseTimer = Timer(const Duration(seconds: 30), () async {
      if (_waitingForReply) {
        await _tts.speak("Are you okay? Please respond.");
        _responseTimer = Timer(const Duration(seconds: 30), () {
          if (_waitingForReply) {
            triggerEmergency();
          }
        });
      }
    });
  }

  void userResponded() {
    _waitingForReply = false;
    _responseTimer?.cancel();
    _tts.speak("Thank you. Stay safe.");
  }

  void triggerEmergency() async {
    _waitingForReply = false;
    _responseTimer?.cancel();

    onEmergencyTriggered?.call();

    await _tts.speak("Emergency detected! Notifying help.");
    await _player.setAsset('assets/alarm.mp3');
    _player.play();

    await Future.delayed(const Duration(seconds: 10));

    await sendEmergencySMS(
      emergencyPhone,
      "🚨 Emergency Alert!\nThe elder is not responding.\nAmbulance has been notified.\nPlease call/check immediately.",
    );

    await FlutterPhoneDirectCaller.callNumber(emergencyPhone);
  }

  Future<void> sendEmergencySMS(String number, String message) async {
    final canSendSms = await telephony.requestSmsPermissions;
    if (canSendSms ?? false) {
      telephony.sendSms(
        to: number,
        message: message,
        statusListener: (SendStatus status) {
          print("📤 SMS Status: $status");
          if (status == SendStatus.SENT) {
            Fluttertoast.showToast(msg: "📤 SMS sent to $number");
          } else if (status == SendStatus.DELIVERED) {
            Fluttertoast.showToast(msg: "✅ SMS delivered to $number");
          } else {
            Fluttertoast.showToast(msg: "❌ SMS failed");
          }
        },
      );
    } else {
      Fluttertoast.showToast(msg: "❌ SMS permission not granted");
    }
  }

  void dispose() {
    _intervalTimer?.cancel();
    _responseTimer?.cancel();
    _tts.stop();
    _player.dispose();
  }
}