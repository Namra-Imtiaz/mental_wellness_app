import '../../../utils/constants/url_helper.dart';

import '../models/meditation_category_model.dart';
import '../models/meditation_exercise_model.dart';
import '../models/meditation_step_model.dart';

final relaxMeditationCategory = MeditationCategoryModel(
  title: "Relax Meditation",
  image: "assets/images/relax.png",
  items: [
    {'title': 'Harp', 'image': 'assets/images/meditation/relax/items/harp.png'},
    {
      'title': 'Kalimba',
      'image': 'assets/images/meditation/relax/items/kalimba.png',
    },
    {
      'title': 'Piano',
      'image': 'assets/images/meditation/relax/items/piano.png',
    },
  ],
  exercises: [
    MeditationExerciseModel(
      title: "Progressive Muscle Relaxation (PMR)",
      description:
          "This practice helps relieve tension by tensing and relaxing different muscle groups, promoting full-body relaxation.",
      videoUrl: generateExerciseUrl(
        'relax',
        'Progressive Muscle Relaxation (PMR)',
      ),
      videothumbnail:
          'assets/images/meditation/relax/video_thumbnails/Progressive Muscle Relaxation (PMR).png',
      duration: "21:12",
      steps: [
        MeditationStepModel(
          title: "Find a Comfortable Position",
          description:
              "Lie down or sit in a comfortable position in a quiet space. Close your eyes and take a few deep breaths.",
        ),
        MeditationStepModel(
          title: "Focus on Your Breathing",
          description:
              "Begin by taking slow, deep breaths in through your nose and out through your mouth. Allow your body to relax with each exhale.",
        ),
        MeditationStepModel(
          title: "Start with Your Feet",
          description:
              "Tense the muscles in your feet by curling your toes tightly. Hold the tension for 5-10 seconds, then release the tension and feel the relaxation.",
        ),
        MeditationStepModel(
          title: "Move Up to Your Legs",
          description:
              "Tense the muscles in your calves and thighs by tightening them. Hold for a few seconds and then release.",
        ),
        MeditationStepModel(
          title: "Continue Up Your Body",
          description:
              "Gradually move up your body, tensing and relaxing each muscle group: abdomen, chest, arms, shoulders, neck, and face.",
        ),
        MeditationStepModel(
          title: "Focus on the Relaxation",
          description:
              "As you release each muscle group, focus on the sensation of relaxation and warmth spreading through your body.",
        ),
        MeditationStepModel(
          title: "End with Deep Breaths",
          description:
              "After scanning your entire body, take a few deep breaths and allow yourself to feel fully relaxed.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Guided Imagery",
      description:
          "This relaxation technique uses vivid mental images to calm the mind and reduce stress by visualizing peaceful and serene settings.",
      videoUrl: generateExerciseUrl('relax', 'Guided Imagery (Relaxation)'),
      videothumbnail: 'assets/images/meditation/relax/video_thumbnails/gi.png',
      duration: "10:15",
      steps: [
        MeditationStepModel(
          title: "Find a Comfortable Position",
          description:
              "Sit or lie down in a comfortable spot. Close your eyes and begin to relax your body.",
        ),
        MeditationStepModel(
          title: "Focus on Your Breath",
          description:
              "Take deep, slow breaths. With each exhale, feel your body relax more deeply.",
        ),
        MeditationStepModel(
          title: "Imagine a Peaceful Scene",
          description:
              "Visualize a calm and peaceful place, like a beach, forest, or garden. Imagine the sights, sounds, and smells around you.",
        ),
        MeditationStepModel(
          title: "Engage All Your Senses",
          description:
              "Picture the colors, textures, sounds, and smells in great detail. Engage all your senses to make the experience feel as real as possible.",
        ),
        MeditationStepModel(
          title: "Immerse Yourself Fully",
          description:
              "Allow yourself to feel immersed in this peaceful place. Let go of any stressful thoughts and just be in the moment.",
        ),
        MeditationStepModel(
          title: "Stay in the Imagery for 10-15 Minutes",
          description:
              "Continue to enjoy the imagery for at least 10-15 minutes, focusing on the relaxation it brings.",
        ),
        MeditationStepModel(
          title: "Gradually Return to the Present",
          description:
              "When you're ready, slowly bring your attention back to the present, taking a few deep breaths before opening your eyes.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Deep Breathing (Abdominal Breathing)",
      description:
          "This relaxation technique focuses on deep, slow breathing to activate the body's relaxation response and reduce stress.",
      videoUrl: generateExerciseUrl(
        'relax',
        'Deep Breathing (Abdominal Breathing)',
      ),
      videothumbnail:
          'assets/images/meditation/relax/video_thumbnails/Deep Breathing (Abdominal Breathing).png',
      duration: "7:27",
      steps: [
        MeditationStepModel(
          title: "Sit Comfortably",
          description:
              "Sit in a chair or lie on your back in a comfortable position. Close your eyes and relax your body.",
        ),
        MeditationStepModel(
          title: "Breathe in Slowly",
          description:
              "Inhale deeply through your nose, allowing your abdomen to rise as you fill your lungs with air. Count to four as you breathe in.",
        ),
        MeditationStepModel(
          title: "Hold Your Breath",
          description: "Hold your breath for a moment, counting to four.",
        ),
        MeditationStepModel(
          title: "Exhale Slowly",
          description:
              "Slowly exhale through your mouth, letting your abdomen fall. Count to four as you release the air.",
        ),
        MeditationStepModel(
          title: "Continue the Cycle",
          description:
              "Repeat this breathing cycle for 10-15 minutes, focusing on the rise and fall of your abdomen with each breath.",
        ),
        MeditationStepModel(
          title: "Stay Calm and Focused",
          description:
              "Keep your mind focused on your breath, letting go of any distractions. Let the breath guide you into a deep state of relaxation.",
        ),
        MeditationStepModel(
          title: "End with Reflection",
          description:
              "Take a few normal breaths and reflect on the calming effect the deep breathing has had on your body.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Body Scan Meditation",
      description:
          "This practice involves mentally scanning your body for tension, then consciously relaxing each muscle group to promote relaxation.",
      videoUrl: generateExerciseUrl('relax', 'Body Scan Meditation'),
      videothumbnail:
          'assets/images/meditation/relax/video_thumbnails/Body Scan Meditation.png',
      duration: "11:38",
      steps: [
        MeditationStepModel(
          title: "Get Comfortable",
          description:
              "Lie down in a comfortable position, close your eyes, and relax your body.",
        ),
        MeditationStepModel(
          title: "Start with Your Breath",
          description:
              "Take a few deep breaths, letting your body relax with each exhale.",
        ),
        MeditationStepModel(
          title: "Focus on Your Feet",
          description:
              "Begin with your feet and mentally scan for any tension. If you find any, consciously relax that area.",
        ),
        MeditationStepModel(
          title: "Work Your Way Up",
          description:
              "Move your focus up through your legs, torso, arms, neck, and face. Tense each area for a few seconds, then release.",
        ),
        MeditationStepModel(
          title: "Notice the Relaxation",
          description:
              "As you release tension, notice how the area feels lighter and more relaxed.",
        ),
        MeditationStepModel(
          title: "Continue for 10-15 Minutes",
          description:
              "Complete the body scan for the entire body, making sure to focus on each muscle group.",
        ),
        MeditationStepModel(
          title: "Conclude with Deep Breaths",
          description:
              "Once you’ve scanned your entire body, take a few deep breaths, appreciating the relaxation you’ve cultivated.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Mindfulness for Relaxation",
      description:
          "Mindfulness meditation involves focusing on the present moment, accepting feelings and sensations without judgment, to reduce stress and promote relaxation.",
      videoUrl: generateExerciseUrl('relax', 'Mindfulness for Relaxation'),
      videothumbnail:
          'assets/images/meditation/relax/video_thumbnails/Mindfulness for Relaxation.png',
      duration: "5:14",
      steps: [
        MeditationStepModel(
          title: "Find a Quiet Space",
          description:
              "Sit or lie down in a quiet, comfortable space where you won’t be disturbed.",
        ),
        MeditationStepModel(
          title: "Close Your Eyes and Focus on Your Breath",
          description:
              "Take a few deep breaths, focusing on the air entering and leaving your body.",
        ),
        MeditationStepModel(
          title: "Observe Your Thoughts and Feelings",
          description:
              "Allow any thoughts or feelings to come and go naturally without engaging with them. Just observe them as they arise.",
        ),
        MeditationStepModel(
          title: "Bring Your Focus Back to the Present",
          description:
              "If you start thinking about something else, gently bring your attention back to your breath or the present moment.",
        ),
        MeditationStepModel(
          title: "Stay in the Moment for 10-15 Minutes",
          description:
              "Continue observing without judgment, letting your mind settle into the present moment.",
        ),
        MeditationStepModel(
          title: "End with Deep Breaths",
          description:
              "Finish by taking a few deep breaths, bringing your awareness back to the present.",
        ),
        MeditationStepModel(
          title: "Reflect on the Calmness",
          description:
              "Take a moment to notice the relaxation and clarity you’ve cultivated.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Self-Hypnosis Relaxation",
      description:
          "This practice involves guiding yourself into a deeply relaxed state through suggestions, helping to reduce stress and promote calm.",
      videoUrl: generateExerciseUrl('relax', 'Self-Hypnosis Relaxation'),
      videothumbnail:
          'assets/images/meditation/relax/video_thumbnails/Self Hypnosis Relaxation.png',
      duration: "10:03",
      steps: [
        MeditationStepModel(
          title: "Sit or Lie Down Comfortably",
          description:
              "Choose a quiet spot and sit or lie down in a relaxed position.",
        ),
        MeditationStepModel(
          title: "Focus on Your Breathing",
          description:
              "Take several deep, slow breaths, allowing your body to relax with each exhale.",
        ),
        MeditationStepModel(
          title: "Begin Progressive Relaxation",
          description:
              "Start with your feet and slowly work your way up the body, mentally relaxing each part.",
        ),
        MeditationStepModel(
          title: "Use Positive Suggestions",
          description:
              "As you relax, gently suggest to yourself that you are becoming calm, relaxed, and at peace.",
        ),
        MeditationStepModel(
          title: "Deepen the Relaxation",
          description:
              "As you feel more relaxed, deepen the trance by suggesting that with each breath, you become more and more relaxed.",
        ),
        MeditationStepModel(
          title: "Maintain the Calm State",
          description:
              "Stay in this relaxed state for 10-15 minutes, focusing on relaxation and positive suggestions.",
        ),
        MeditationStepModel(
          title: "Slowly Return to Alertness",
          description:
              "Gradually bring yourself back to full awareness by slowly deepening your breath and becoming more alert.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Sound Healing Meditation",
      description:
          "This practice uses soothing sounds, such as gentle music or nature sounds, to promote relaxation and reduce stress.",
      videoUrl: generateExerciseUrl('relax', 'Sound Healing Meditation'),
      videothumbnail:
          'assets/images/meditation/relax/video_thumbnails/Sound Healing Meditation.png',
      duration: "10:15",
      steps: [
        MeditationStepModel(
          title: "Find a Comfortable Position",
          description:
              "Sit or lie down in a comfortable position in a quiet room.",
        ),
        MeditationStepModel(
          title: "Choose Soothing Sounds",
          description:
              "Play calming sounds, such as soft instrumental music, nature sounds, or binaural beats.",
        ),
        MeditationStepModel(
          title: "Focus on the Sound",
          description:
              "Close your eyes and focus on the sound, allowing it to wash over you and fill your mind.",
        ),
        MeditationStepModel(
          title: "Relax Your Body",
          description:
              "With each sound, allow your body to relax further. Feel the vibrations of the sound affecting your body and mind.",
        ),
        MeditationStepModel(
          title: "Stay Present",
          description:
              "Keep your attention focused on the sounds. Let go of any thoughts or distractions.",
        ),
        MeditationStepModel(
          title: "Meditate for 10-15 Minutes",
          description:
              "Stay immersed in the sound for the duration of the session, allowing it to deepen your relaxation.",
        ),
        MeditationStepModel(
          title: "Reflect as You End the Session",
          description:
              "When the session ends, take a few moments to reflect on how the sound has affected your body and mind.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Yoga Nidra Mini Session",
      description:
          "This practice involves guiding yourself into a deeply relaxed state through suggestions, helping to reduce stress and promote calm.", //Made up description
      videoUrl: generateExerciseUrl('relax', 'Yoga Nidra Mini Session'),
      videothumbnail:
          'assets/images/meditation/relax/video_thumbnails/Yoga Nidra Mini Session.png',
      duration: "6:41",
      steps: [
        MeditationStepModel(
          title: "Lie Down Comfortably",
          description:
              "Lie on your back with your arms at your sides and legs extended.",
        ),
        MeditationStepModel(
          title: "Set an Intention",
          description:
              "Set a positive intention for the practice, such as relaxation.",
        ),
        MeditationStepModel(
          title: "Body Awareness",
          description:
              "Bring your attention to different body parts, relaxing each one.",
        ),
        MeditationStepModel(
          title: "Breath Awareness",
          description:
              "Focus on your natural breathing rhythm without controlling it.",
        ),
        MeditationStepModel(
          title: "Guided Imagery",
          description: "Follow a guided visualization to enhance relaxation.",
        ),
        MeditationStepModel(
          title: "Deepen Relaxation",
          description:
              "Allow yourself to sink deeper into a state of calm and relaxation.",
        ),
        MeditationStepModel(
          title: "Return to Awareness",
          description:
              "Gently bring your awareness back to the present moment.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Nature Walk Meditation",
      description:
          "This meditation uses the natural environment to promote relaxation and mindfulness through walking and engaging with the surroundings.",
      videoUrl: generateExerciseUrl('relax', 'Nature Walk Meditation'),
      videothumbnail:
          'assets/images/meditation/relax/video_thumbnails/Nature Walk Meditation.png',
      duration: "31:12",
      steps: [
        MeditationStepModel(
          title: "Find a Peaceful Outdoor Space",
          description:
              "Choose a natural setting, like a park, beach, or forest, where you can walk quietly without distractions.",
        ),
        MeditationStepModel(
          title: "Walk Slowly and Mindfully",
          description:
              "Begin walking slowly, paying attention to the sensation of your feet touching the ground.",
        ),
        MeditationStepModel(
          title: "Observe Your Surroundings",
          description:
              "Engage all of your senses by noticing the sounds, sights, and smells around you. Pay attention to the trees, flowers, and wildlife.",
        ),
        MeditationStepModel(
          title: "Focus on Your Breath",
          description:
              "Breathe slowly and deeply as you walk, staying present in each breath and step.",
        ),
        MeditationStepModel(
          title: "Let Go of Distractions",
          description:
              "If your mind drifts, gently bring it back to the sounds and sensations of nature.",
        ),
        MeditationStepModel(
          title: "Continue for 10-15 Minutes",
          description:
              "Walk mindfully for at least 10 minutes, soaking in the environment and feeling the calmness of nature.",
        ),
        MeditationStepModel(
          title: "End with Reflection",
          description:
              "Once you finish your walk, take a moment to reflect on how nature has relaxed and grounded you.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Tratak Meditation",
      description:
          "Tratak Meditation, or candle gazing, is a powerful concentration technique that calms the mind, improves focus, and enhances inner vision. By steadily gazing at a candle flame, you train your mind to become more present and reduce mental clutter.",
      videoUrl: generateExerciseUrl('relax', 'Tratak Meditation'),
      videothumbnail:
          'assets/images/meditation/relax/video_thumbnails/Tratak Meditation.png',
      duration: "8:57",
      steps: [
        MeditationStepModel(
          title: "Prepare Your Space",
          description:
              "Choose a quiet, dimly lit room where you can sit comfortably without distractions. Ensure good ventilation.",
        ),
        MeditationStepModel(
          title: "Light the Candle",
          description:
              "Place a candle on a stable surface about an arm's length away from you, at eye level. The flame should be steady and not flickering excessively.",
        ),
        MeditationStepModel(
          title: "Assume a Comfortable Posture",
          description:
              "Sit in a relaxed yet upright posture, either on a chair with your feet flat on the floor or cross-legged on a cushion. Keep your spine straight and your shoulders relaxed.",
        ),
        MeditationStepModel(
          title: "Focus Your Gaze",
          description:
              "Gently fix your gaze on the tip of the candle flame. Try to keep your eyes open and avoid blinking as much as is comfortable. If your eyes feel strained, blink gently and then refocus.",
        ),
        MeditationStepModel(
          title: "Maintain Steady Attention",
          description:
              "Keep your attention solely on the flame. Notice its color, shape, and the subtle movements. If your mind wanders, gently bring your focus back to the flame without judgment.",
        ),
        MeditationStepModel(
          title: "Breathe Naturally",
          description:
              "Continue to breathe slowly and deeply throughout the practice. Allow your breath to flow naturally without any force or control.",
        ),
        MeditationStepModel(
          title: "Visualize the Afterimage",
          description:
              "After a few minutes of gazing (start with 2-3 minutes and gradually increase), close your eyes. Observe the afterimage of the flame in your mind's eye. Try to keep this image steady and focused.",
        ),
        MeditationStepModel(
          title: "Return to the Present",
          description:
              "When the afterimage fades, gently open your eyes and refocus on the candle flame. You can repeat the gazing and visualization cycles for a total duration of 5-10 minutes.",
        ),
        MeditationStepModel(
          title: "Concluding the Practice",
          description:
              "When you are ready to finish, gently lower your gaze, then close your eyes for a few moments. Take a few deep breaths and allow yourself to feel the stillness and calm.",
        ),
      ],
    ),
  ],
);
