import 'package:flutter/material.dart';
import 'package:furniscapemobileapp/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'package:furniscapemobileapp/screens/auth/login_screen.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:furniscapemobileapp/screens/auth/login_screen.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Container(
        // Optional static background color or image
        decoration: const BoxDecoration(
          color: Colors.deepPurple, // Or any fallback color
          image: DecorationImage(
            image: AssetImage('assets/images/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to \nFurniScape',
                textAlign: TextAlign.center,
                // style: TextStyle(
                //   fontSize: 36,
                //   fontWeight: FontWeight.bold,
                //   color: Colors.white,
                // ),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.black, 
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'WHERE COMFORT MEETS ELEGANCE',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary, // or any custom color
                  foregroundColor: Theme.of(context).colorScheme.onPrimary, // text color
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    // MaterialPageRoute(builder: (_) => const LoginScreen()),
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),

                      ),
                  );
                },
                child: Text(
                  'GET STARTED',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
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


//
// // Used stateful widget as using video [for initializing playing and disposing the video]
// class GetStartedScreen extends StatefulWidget {
//   const GetStartedScreen({super.key});
//
//   @override
//   State<GetStartedScreen> createState() => _GetStartedScreenState();
// }
//
// class _GetStartedScreenState extends State<GetStartedScreen> {
//   late VideoPlayerController _controller;  // Manages the video [play, pause, looping, volume and video file reference]
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.asset('assets/videos/welcome.mp4')
//       ..initialize().then((_) {
//         setState(() {}); // Rebuild UI when video is ready
//         _controller.setLooping(true);  //Loop the video
//         _controller.setVolume(0);  //Mute
//         _controller.play();  //Autoplay
//       });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();   //Remove the video when the screen is changed
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(       //Stack allows placing the widget [text] on top of the video
//         fit: StackFit.expand,
//         children: [
//           // Background Video
//           _controller.value.isInitialized
//               ? SizedBox.expand(
//             child: FittedBox(
//               fit: BoxFit.cover,
//               child: SizedBox(
//                 width: _controller.value.size.width,
//                 height: _controller.value.size.height,
//                 child: VideoPlayer(_controller),
//               ),
//             ),
//           )
//               : const Center(child: CircularProgressIndicator()),
//
//
//           // Overlay with content
//           Container(
//             // color: Colors.black.withOpacity(0.5), // Optional dark overlay
//             padding: const EdgeInsets.all(24.0),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     'Welcome to \nFurniScape',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 36,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   const Text(
//                     'WHERE COMFORT MEETS ELEGANCE',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white70,
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Navigate to Login Screen here
//                       // Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
//                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
//
//                     },
//                     child: const Text('Get Started'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
