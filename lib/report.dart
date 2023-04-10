import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _controller = TextEditingController();

  void _sendEmail() async {
    final String subject = 'Feedback for MyApp';
    final String body = _controller.text;
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'feedback@myapp.com',
      query: 'subject=$subject&body=$body',
    );
    final String email = params.toString();
    if (await canLaunch(email)) {
      await launch(email);
    } else {
      throw 'Could not launch $email';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Describe your problem...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          TextButton(
            child: Text('Send'),
            onPressed: _sendEmail,
          ),
        ],
      ),
    );
  }
}
