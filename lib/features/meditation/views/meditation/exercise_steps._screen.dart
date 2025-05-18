import 'package:flutter/material.dart';
import '/common/widgets/meditation_step_details.dart';
import '/features/meditation/models/meditation_exercise_model.dart';
import '/utils/constants/color_extension.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';

class MeditationExerciseStepsScreen extends StatefulWidget {
  final MeditationExerciseModel exercise;
  const MeditationExerciseStepsScreen({super.key, required this.exercise});

  @override
  State<MeditationExerciseStepsScreen> createState() =>
      _MeditationExerciseStepsScreenState();
}

class _MeditationExerciseStepsScreenState
    extends State<MeditationExerciseStepsScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    print("Video URL: ${widget.exercise.videoUrl}");
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.exercise.videoUrl),
    );
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      await _videoPlayerController.initialize();
      _videoPlayerController.addListener(() {
        if (mounted) setState(() {});
      });

      if (mounted) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            autoPlay: false,
            looping: false,
            allowFullScreen: true,
            materialProgressColors: ChewieProgressColors(
              playedColor: FColor.primaryColor1.withAlpha(
                178,
              ), // Active progress color
              handleColor: FColor.primaryColor2, // Drag handle color
              bufferedColor: FColor.gray, // Buffered part
              backgroundColor: Colors.black26, // Background track
            ),
          );
        });
      }
    } catch (e) {
      debugPrint("Error initializing video player: $e");
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  String getFormattedDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double videoHeight = media.width * 0.43;
    final MeditationExerciseModel currentExercise = widget.exercise;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: FColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: FColor.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              "assets/images/closed_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          currentExercise.title,
          style: TextStyle(
            color: FColor.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:
                            FColor.primaryG
                                .map((color) => color.withAlpha(180))
                                .toList(),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child:
                        _chewieController != null &&
                                _chewieController!
                                    .videoPlayerController
                                    .value
                                    .isInitialized
                            ? Chewie(controller: _chewieController!)
                            : const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFF8F6FF),
                              ),
                            ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Description',
                style: TextStyle(
                  color: FColor.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              ReadMoreText(
                currentExercise.description,
                trimLines: 2,
                style: TextStyle(color: FColor.gray, fontSize: 12),
                colorClickableText: FColor.secondaryColor1,
                trimMode: TrimMode.Line,
                trimCollapsedText: "Show more",
                trimExpandedText: "Show less",
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "How To Do It",
                    style: TextStyle(
                      color: FColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "${currentExercise.steps.length} Steps",
                      style: TextStyle(color: FColor.gray, fontSize: 12),
                    ),
                  ),
                ],
              ),
              MeditationStepDetails(stepArr: currentExercise.steps),
            ],
          ),
        ),
      ),
    );
  }
}
