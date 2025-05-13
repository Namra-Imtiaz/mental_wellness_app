
import '../../../utils/constants/url_helper.dart';
import '../models/meditation_category_model.dart';
import '../models/meditation_exercise_model.dart';
import '../models/meditation_step_model.dart';


final focusMeditationCategory = MeditationCategoryModel(
  title: "Focus Meditation",
  image: "assets/images/focus.png",
  items: [
    {
      'title': 'Chair',
      'image': 'assets/images/meditation/focus/items/chair.png',
    },
    {
      'title': 'Gongs',
      'image': 'assets/images/meditation/focus/items/gongs.png',
    },
    {
      'title': 'Tuning Forks',
      'image': 'assets/images/meditation/focus/items/tuning_forks.png',
    },
  ],
  exercises: [
    MeditationExerciseModel(
      title: "Focused Attention Meditation",
      description:
          "This meditation enhances concentration by focusing attention on one specific object or thought, allowing the mind to clear.",
      videoUrl: generateExerciseUrl('focus', 'Focused Attention Meditation'),
      videothumbnail:
          'assets/images/meditation/focus/video_thumbnails/Focused Attention Meditation.png',
      duration: "0:00",
      steps: [
        MeditationStepModel(
          title: "Find a Quiet Space",
          description:
              "Choose a peaceful location where you won’t be disturbed during your session.",
        ),
        MeditationStepModel(
          title: "Sit Comfortably",
          description:
              "Sit in a comfortable position with your back straight. Close your eyes gently and relax your body.",
        ),
        MeditationStepModel(
          title: "Choose Your Focus Point",
          description:
              "Pick an object, sound, or thought to focus on. It could be your breath, a word (mantra), or an image in your mind.",
        ),
        MeditationStepModel(
          title: "Concentrate on the Chosen Object",
          description:
              "Direct your full attention to the focus point. Gently push aside any other thoughts that arise.",
        ),
        MeditationStepModel(
          title: "Observe Thoughts Without Judgment",
          description:
              "As other thoughts pop up, acknowledge them without engaging. Return your focus to your chosen point.",
        ),
        MeditationStepModel(
          title: "Gradually Increase Focus Duration",
          description:
              "Try maintaining your focus for 10-15 minutes, gradually increasing as you become more comfortable.",
        ),
        MeditationStepModel(
          title: "End with Reflection",
          description:
              "After the session, reflect on the experience. Notice any improvements in your concentration.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Candle Gazing Meditation",
      description:
          "This practice uses the steady gaze at a candle flame to help improve mental clarity and concentration.",
      videoUrl: generateExerciseUrl('focus', 'Candle Gazing Meditation'),
      videothumbnail:
          'assets/images/meditation/focus/video_thumbnails/Candle Gazing Meditation.png',
      duration: "2:00",
      steps: [
        MeditationStepModel(
          title: "Set Up Your Space",
          description:
              "Light a candle and place it at eye level, about 3 feet away from you in a dark room.",
        ),
        MeditationStepModel(
          title: "Sit Comfortably and Relax",
          description:
              "Sit in a relaxed position, ensuring your back is straight and your body is calm.",
        ),
        MeditationStepModel(
          title: "Focus on the Flame",
          description:
              "Gaze gently at the candle flame, keeping your eyes focused on it without blinking too often.",
        ),
        MeditationStepModel(
          title: "Keep Your Attention on the Flame",
          description:
              "If your mind starts to wander, guide it back to the flame. Observe the movement of the flame and its colors.",
        ),
        MeditationStepModel(
          title: "Notice Sensations in Your Body",
          description:
              "Pay attention to any sensations you feel as you focus on the flame, such as relaxation or focus.",
        ),
        MeditationStepModel(
          title: "Gradually Close Your Eyes",
          description:
              "After 10-15 minutes, close your eyes and visualize the image of the flame in your mind’s eye.",
        ),
        MeditationStepModel(
          title: "End Slowly Open your Eyes",
          description:
              "Slowly open your eyes, noticing how your focus has sharpened. Reflect on the session.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Counting Breaths Meditation",
      description:
          "This exercise enhances focus by using the counting of breaths to maintain attention on the present moment.",
      videoUrl: generateExerciseUrl('focus', 'Counting Breaths Meditation'),
      videothumbnail:
          'assets/images/meditation/focus/video_thumbnails/Counting Breaths Meditation.png',
      duration: "2:00",
      steps: [
        MeditationStepModel(
          title: "Get Comfortable",
          description:
              "Sit in a quiet, comfortable place where you won’t be interrupted. Close your eyes to eliminate visual distractions.",
        ),
        MeditationStepModel(
          title: "Take Deep Breaths",
          description:
              "Begin by taking a few deep breaths, inhaling deeply through your nose and exhaling through your mouth.",
        ),
        MeditationStepModel(
          title: "Begin Counting Your Breaths",
          description:
              "As you inhale, count “one,” and as you exhale, count “two.” Continue until you reach ten, then start over.",
        ),
        MeditationStepModel(
          title: "Focus Only on the Counting",
          description:
              "Keep your mind focused solely on the count. If your mind wanders, gently bring it back to the breath and the counting.",
        ),
        MeditationStepModel(
          title: "Increase Focus as You Progress",
          description:
              "Try to make the counting steady and rhythmic, allowing your mind to become more centered with each cycle.",
        ),
        MeditationStepModel(
          title: "Practice for 10-15 Minutes",
          description:
              "Continue the exercise for at least 10 minutes. Focus should gradually deepen as you become more absorbed.",
        ),
        MeditationStepModel(
          title: "End the Session Gently",
          description:
              "Slowly bring your awareness back to the present, appreciating the calm focus you've cultivated.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Object Focus Meditation",
      description:
          "In this meditation, you focus on a single object to train your concentration and awareness.",
      videoUrl: generateExerciseUrl('focus', 'Object Focus Meditation'),
      videothumbnail:
          'assets/images/meditation/focus/video_thumbnails/Object Focus Meditation.png',
      duration: "2:00",
      steps: [
        MeditationStepModel(
          title: "Choose an Object to Focus On",
          description:
              "Select a simple object like a flower, a stone, or a figurine. Place it in front of you.",
        ),
        MeditationStepModel(
          title: "Set Up Your Space",
          description:
              "Sit comfortably in a quiet place. Ensure you are not disturbed during the session.",
        ),
        MeditationStepModel(
          title: "Focus All Attention on the Object",
          description:
              "Gaze at the object carefully. Notice its details, color, texture, and shape. Let your awareness be completely immersed in it.",
        ),
        MeditationStepModel(
          title: "Gently Refocus if Your Mind Wanders",
          description:
              "If your thoughts stray, gently bring your focus back to the object. Let your attention rest on its smallest details.",
        ),
        MeditationStepModel(
          title: "Engage Your Senses",
          description:
              "Try to engage all of your senses, even imagining how the object might feel to the touch or smell if possible.",
        ),
        MeditationStepModel(
          title: "Keep the Focus for 10-15 Minutes",
          description:
              "Continue focusing on the object without distraction. If your attention fades, return to the object.",
        ),
        MeditationStepModel(
          title: "Close the Meditation with Reflection",
          description:
              "Slowly open your eyes and reflect on the level of concentration you achieved during the session.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Sensory Awareness Meditation",
      description:
          "This exercise uses mindfulness of the senses to improve attention and sharpen focus on the present moment.",
      videoUrl: generateExerciseUrl('focus', 'Sensory Awareness Meditation'),
      videothumbnail:
          'assets/images/meditation/focus/video_thumbnails/Sensory Awareness Meditation.png',
      duration: "2:00",
      steps: [
        MeditationStepModel(
          title: "Find a Quiet Spot",
          description:
              "Sit in a comfortable position in a calm, quiet space where you can focus on your senses without distractions.",
        ),
        MeditationStepModel(
          title: "Close Your Eyes and Breathe Deeply",
          description:
              "Begin with deep, calming breaths to relax your body and center your mind.",
        ),
        MeditationStepModel(
          title: "Focus on Your Sense of Touch",
          description:
              "Pay attention to the sensations in your body – the feel of the air on your skin, the pressure of your feet on the floor.",
        ),
        MeditationStepModel(
          title: "Shift to Your Sense of Hearing",
          description:
              "Now, focus on the sounds around you. Be aware of distant or subtle sounds like birds, traffic, or your own breath.",
        ),
        MeditationStepModel(
          title: "Move to Your Sense of Smell",
          description:
              "Focus on the scents around you. It could be fresh air, a nearby plant, or even your own breath.",
        ),
        MeditationStepModel(
          title: "Notice the Sense of Sight (Without Opening Your Eyes)",
          description:
              "While keeping your eyes closed, try to sense the images or shapes in the dark. Let your mind sharpen your awareness.",
        ),
        MeditationStepModel(
          title: "End with a Deep Breath and Reflection",
          description:
              "Take a final deep breath and reflect on your enhanced awareness of your senses.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Dynamic Focus Meditation",
      description:
          "This meditation uses movement combined with focus to help improve concentration and mindfulness in action.",
      videoUrl: generateExerciseUrl('focus', 'Dynamic Focus Meditation'),
      videothumbnail:
          'assets/images/meditation/focus/video_thumbnails/Dynamic Focus Meditation.png',
      duration: "2:00",
      steps: [
        MeditationStepModel(
          title: "Choose Your Movement",
          description:
              "Pick a simple movement, such as walking, gentle stretching, or even hand movements.",
        ),
        MeditationStepModel(
          title: "Get Comfortable",
          description:
              "Begin by finding a quiet space where you can move freely without distractions.",
        ),
        MeditationStepModel(
          title: "Focus on the Movement",
          description:
              "As you perform the movement, keep your full attention on how your body feels as it moves.",
        ),
        MeditationStepModel(
          title: "Synchronize with Your Breath",
          description:
              "Coordinate your breathing with the movement. For example, inhale as you extend, exhale as you return.",
        ),
        MeditationStepModel(
          title: "Avoid Mental Distractions",
          description:
              "Focus only on the movement and breathing. If your mind wanders, gently guide it back to the motion.",
        ),
        MeditationStepModel(
          title: "Continue for 10-15 Minutes",
          description:
              "Maintain the movement and focus for at least 10 minutes, aiming to deepen your concentration over time.",
        ),
        MeditationStepModel(
          title: "Gradually Slow Down",
          description:
              "Slowly bring the movement to a stop, focusing on the calm and clarity you’ve cultivated during the exercise.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Mantra Repetition Meditation",
      description:
          "In this meditation, repeating a mantra enhances concentration and helps quiet the mind.",
      videoUrl: generateExerciseUrl('focus', 'Mantra Repetition Meditation'),
      videothumbnail:
          'assets/images/meditation/focus/video_thumbnails/Mantra Repetition Meditation.png',
      duration: "2:00",
      steps: [
        MeditationStepModel(
          title: "Choose a Mantra",
          description:
              "Select a simple word or phrase that resonates with you, such as “Om” or “Peace.”",
        ),
        MeditationStepModel(
          title: "Sit in a Comfortable Position",
          description:
              "Find a peaceful location and sit comfortably, closing your eyes to block distractions.",
        ),
        MeditationStepModel(
          title: "Begin Repeating the Mantra",
          description:
              "Silently repeat the mantra in your mind, focusing on the sound and vibration of the words.",
        ),
        MeditationStepModel(
          title: "Keep Your Attention on the Mantra",
          description:
              "If your mind drifts, gently guide it back to the mantra. Feel the calming effects of the repetition.",
        ),
        MeditationStepModel(
          title: "Synchronize with Your Breathing",
          description:
              "If possible, align your breath with the mantra, inhaling and exhaling as you repeat the words.",
        ),
        MeditationStepModel(
          title: "Continue for 10-15 Minutes",
          description:
              "Keep repeating the mantra for the duration of the meditation. Try not to rush the process.",
        ),
        MeditationStepModel(
          title: "End with Stillness",
          description:
              "Slowly stop repeating the mantra and sit in silence, appreciating the calm and focus you’ve developed.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Visualization for Focus",
      description: "Use mental imagery to enhance focus and concentration.",
      videoUrl: generateExerciseUrl('focus', 'Visualization for Focus'),
      videothumbnail:
          'assets/images/meditation/focus/video_thumbnails/Visualization for Focus.png',
      duration: "2:00",
      steps: [
        MeditationStepModel(
          title: "Sit Comfortably",
          description: "Sit in a relaxed and upright position.",
        ),
        MeditationStepModel(
          title: "Choose a Visualization",
          description:
              "Imagine a scene or image that promotes focus (e.g., a steady flame).",
        ),
        MeditationStepModel(
          title: "Visualize the Image",
          description: "Create a clear and detailed mental image.",
        ),
        MeditationStepModel(
          title: "Maintain the Image",
          description: "Keep the image steady and clear in your mind.",
        ),
        MeditationStepModel(
          title: "Focus on Details",
          description: "Pay attention to the details of the image.",
        ),
        MeditationStepModel(
          title: "Acknowledge Wandering",
          description:
              "If your mind wanders, gently bring it back to the image.",
        ),
        MeditationStepModel(
          title: "End Meditation",
          description:
              "Gradually release the visualization and conclude the session.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Eye Focus Meditation",
      description:
          "Practice focusing your gaze to improve concentration and eye muscle control.",
      videoUrl: generateExerciseUrl('focus', 'Eye Focus Meditation'),
      videothumbnail:
          'assets/images/meditation/focus/video_thumbnails/Eye Focus Meditation.png',
      duration: "2:00",
      steps: [
        MeditationStepModel(
          title: "Sit Comfortably",
          description: "Sit in a relaxed and upright position.",
        ),
        MeditationStepModel(
          title: "Choose a Point",
          description: "Select a point in front of you to focus on.",
        ),
        MeditationStepModel(
          title: "Focus Your Gaze",
          description: "Direct your gaze at the chosen point.",
        ),
        MeditationStepModel(
          title: "Maintain Stillness",
          description: "Keep your eyes as still as possible.",
        ),
        MeditationStepModel(
          title: "Breathe Steadily",
          description: "Breathe slowly and deeply while maintaining focus.",
        ),
        MeditationStepModel(
          title: "Acknowledge Blinking",
          description: "Blink naturally without losing focus.",
        ),
        MeditationStepModel(
          title: "End Meditation",
          description:
              "Gently release your gaze and close your eyes for a moment.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Breath Retention Meditation",
      description:
          "This meditation involves holding your breath to improve concentration, patience, and mental clarity.",
      videoUrl: generateExerciseUrl('focus', 'Breath Retention Meditation'),
      videothumbnail:
          'assets/images/meditation/focus/video_thumbnails/Breath Retention Meditation.png',
      duration: "2:00",
      steps: [
        MeditationStepModel(
          title: "Find a Quiet Space",
          description:
              "Choose a peaceful, comfortable place to sit where you can focus on your breath without distractions.",
        ),
        MeditationStepModel(
          title: "Take a Deep Inhalation",
          description:
              "Inhale deeply through your nose, filling your lungs completely with air.",
        ),
        MeditationStepModel(
          title: "Hold Your Breath",
          description:
              "Once you’ve inhaled, hold your breath for a few seconds, noticing any sensations in your body.",
        ),
        MeditationStepModel(
          title: "Exhale Slowly",
          description:
              "Release the air slowly and gently, focusing on the rhythm of your breathing.",
        ),
        MeditationStepModel(
          title: "Repeat the Process",
          description:
              "Inhale again, hold for a moment, and exhale slowly. Try to increase the duration of the hold gradually.",
        ),
        MeditationStepModel(
          title: "Focus on Your Breath",
          description:
              "Let your focus be completely on your breath, eliminating any mental distractions.",
        ),
        MeditationStepModel(
          title: "End the Meditation Slowly",
          description:
              "Conclude by taking a few natural breaths and reflecting on the increased clarity and focus you feel.",
        ),
      ],
    ),
  ],
);




