import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReplyCard extends StatefulWidget {
  final snap;
  const ReplyCard({Key? key, this.snap}) : super(key: key);

  @override
  State<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.snap.data()['profilePic'].toString(),
            ),
            radius: 14,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: widget.snap.data()['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black)
                        ),
                        TextSpan(
                            text: ' ${widget.snap.data()['text']}',
                            style: TextStyle(color: Colors.black)
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        Text(
                          DateFormat.yMMMd().format(
                            widget.snap.data()['datePublished'].toDate()!,
                          ),
                          style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400,),
                        ),
                        SizedBox(width: 20,),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.all(8),
          //   child: const Icon(
          //     Icons.favorite,
          //     size: 16,
          //   ),
          // )
        ],
      ),
    );
  }
}
