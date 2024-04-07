
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
class AHomePage extends StatefulWidget {
  const AHomePage({super.key});

  @override
  State<AHomePage> createState() => _AHomePageState();
}


class _AHomePageState extends State<AHomePage> {
  final Gemini gemini=Gemini.instance;
  List<ChatMessage> messages=[

  ];

  ChatUser  currentUser= ChatUser(id: "0", firstName: "User",
  profileImage: "assets/images/user.png",
  );
  ChatUser geminiUser= ChatUser(id: "1", firstName: "JARVIS",
  profileImage:"https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/i/21841d70-8503-49cc-aa77-b90f08b29294/d65jisv-8885be37-78d5-4704-ad4c-ad184d38c0a0.png/v1/fit/w_828,h_466,q_70,strp/j_a_r_v_i_s____s_h_i_e_ld__os___yash1331_by_yash1331_d65jisv-414w-2x.jpg",

  );
  @override

  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blueGrey,

        title: const Text('Doraemon Ai'
          ,

        ),
        titleTextStyle: const TextStyle(
          fontWeight:FontWeight.bold,
          color: Colors.white,

        ),
        centerTitle: true,
      ),
      body: _buildUI(),
      backgroundColor: Colors.black,

    );

  }
  Widget _buildUI(){
  return DashChat(
    inputOptions:InputOptions(trailing: [
      IconButton(onPressed: (){}, icon: const Icon(Icons.image,),)
    ]
  ) ,
      currentUser: currentUser,
      onSend:_sendMessage,
      messages:messages
   );
  }
  void _sendMessage(ChatMessage chatMessage){
      setState(() {
        messages= [chatMessage, ...messages];
      });

      try{
        String question=chatMessage.text;
        List<Uint8List>? images;
        if(chatMessage.medias?.isNotEmpty?? false){
         images=[
           File(chatMessage.medias!.first.url).readAsBytesSync(),];
        }
        gemini.streamGenerateContent(question).listen((event) {
          ChatMessage? lastMessage= messages.firstOrNull;
          if(lastMessage!=null && lastMessage.user==geminiUser){
            lastMessage=messages.removeAt(0);
            String response= event.content?.parts?.fold("", (previous, current) => "$previous ${current.text}")??"";
            lastMessage.text+= response;
            setState(() {
              messages=[lastMessage!,...messages];
            });
          }
          else{
            String response= event.content?.parts?.fold("", (previous, current) => "$previous ${current.text}")??"";
            ChatMessage message=ChatMessage(
                user: geminiUser,
                createdAt: DateTime.now(),text: response);
              setState(() {
                messages=[message,...messages];
              });
          }
        });
      }
      catch(e){
        print(e);
      }

  }
  void sendMediaMessage() async {
    ImagePicker picker= ImagePicker();
    XFile? file= await picker.pickImage(source: ImageSource.gallery);
    if(file!=null){
      ChatMessage chatMessage= ChatMessage(
          user: currentUser,
          createdAt: DateTime.now(),text:"Describe This?",medias:[
            ChatMedia(url: file.path, fileName:"", type: MediaType.image,)
      ],
      );
      _sendMessage(chatMessage);
    }
  }
}
