import '../../../utils/constants/url_helper.dart';

import '../models/meditation_category_model.dart';
import '../models/meditation_exercise_model.dart';
import '../models/meditation_step_model.dart';

final mindMeditationCategory = MeditationCategoryModel(
  title: "Mind Meditation",
  image: "assets/images/mind.png",
  items: [
    {
      'title': 'Chimes',
      'image': 'assets/images/meditation/mind/items/chimes.png',
    },
    {
      'title': 'Flute',
      'image': 'assets/images/meditation/mind/items/flute.png',
    },
    {
      'title': 'Singing Bowls',
      'image': 'assets/images/meditation/mind/items/singing_bowl.png',
    },
  ],
  exercises: [
    MeditationExerciseModel(
      title: "Deep Mindful Breathing",
      description:
          "This meditation helps you anchor yourself in the present moment by focusing on your breath, promoting calmness and emotional clarity.",
      videoUrl: generateExerciseUrl('mind', 'Deep Mindful Breathing'),
      videothumbnail:
          'assets/images/meditation/mind/video_thumbnails/Deep Mindful Breathing.png',
      duration: "6:07",
      steps: [
        MeditationStepModel(
          title: "Find a Quiet and Comfortable Place",
          description:
              "Sit comfortably on a cushion or chair where you won't be disturbed. Maintain a straight back without stiffness.",
        ),
        MeditationStepModel(
          title: "Close Your Eyes and Settle",
          description:
              "Gently close your eyes and relax your shoulders. Take a few natural breaths to settle into the position.",
        ),
        MeditationStepModel(
          title: "Focus on Natural Breathing",
          description:
              "Notice the feeling of air moving in and out of your nostrils or the rise and fall of your chest and abdomen.",
        ),
        MeditationStepModel(
          title: "Deepen Your Breathing",
          description:
              "Breathe in slowly for a count of four, hold for four, and breathe out for six. Repeat this cycle throughout.",
        ),
        MeditationStepModel(
          title: "Redirect Wandering Thoughts",
          description:
              "When thoughts arise, acknowledge them kindly and bring your attention back to your breath without frustration.",
        ),
        MeditationStepModel(
          title: "Expand Awareness",
          description:
              "Gradually expand your focus to notice your whole body breathing, not just your nose or chest.",
        ),
        MeditationStepModel(
          title: "Slowly End the Practice",
          description:
              "After 5–10 minutes, gently wiggle your fingers and toes, then open your eyes, carrying the sense of peace with you.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Thought Observation Meditation",
      description:
          "This meditation teaches you to observe your thoughts objectively, reducing mental clutter and promoting mindfulness.",
      videoUrl: generateExerciseUrl('mind', 'Thought Observation Meditation'),
      videothumbnail:
          'assets/images/meditation/mind/video_thumbnails/Thought Observation Meditation.png',
      duration: "6:43",
      steps: [
        MeditationStepModel(
          title: "Sit Comfortably in a Quiet Space",
          description:
              "Sit upright but relaxed, either cross-legged or in a chair, ensuring you're comfortable.",
        ),
        MeditationStepModel(
          title: "Close Your Eyes and Breathe Naturally",
          description:
              "Allow your breath to flow naturally as you begin to relax.",
        ),
        MeditationStepModel(
          title: "Watch Your Thoughts Like Clouds",
          description:
              "Imagine each thought as a cloud passing across the sky of your mind. Observe without engaging.",
        ),
        MeditationStepModel(
          title: "Avoid Judgment",
          description:
              "Whether a thought is positive or negative, simply acknowledge its presence and let it drift away.",
        ),
        MeditationStepModel(
          title: "Label the Thoughts Briefly",
          description:
              "Mentally label thoughts if helpful (e.g., 'planning,' 'worry,' 'memory') and return to observing.",
        ),
        MeditationStepModel(
          title: "Bring Focus Back to Breath",
          description:
              "If you get caught up in a thought, gently bring your attention back to the sensation of breathing.",
        ),
        MeditationStepModel(
          title: "Finish with Gratitude",
          description:
              "Conclude the session by appreciating your ability to observe your mind peacefully.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Guided Imagery Meditation",
      description:
          "This meditation uses the power of visualization to calm the mind, reduce stress, and foster creativity.",
      videoUrl: generateExerciseUrl('mind', 'Guided Imagery Meditation'),
      videothumbnail:
          'assets/images/meditation/mind/video_thumbnails/Guided Imagery Meditation.png',
      duration: "5:19",
      steps: [
        MeditationStepModel(
          title: "Find a Comfortable Position",
          description:
              "Sit or lie down in a quiet space where you can relax without interruptions.",
        ),
        MeditationStepModel(
          title: "Close Your Eyes and Take a Few Deep Breaths",
          description:
              "Breathe in deeply, hold for a moment, and then exhale fully, letting go of any tension in your body.",
        ),
        MeditationStepModel(
          title: "Picture a Peaceful Scene",
          description:
              "Imagine a peaceful natural place, like a beach, forest, or garden. Visualize the details – the colors, smells, and sounds.",
        ),
        MeditationStepModel(
          title: "Engage All Your Senses",
          description:
              "As you visualize, try to 'feel' the environment around you. What does the air feel like? What do you hear? Smell? See?",
        ),
        MeditationStepModel(
          title: "Stay Present in the Image",
          description:
              "Allow yourself to be immersed fully in this peaceful scene. Whenever your mind starts to wander, gently guide it back.",
        ),
        MeditationStepModel(
          title: "Let Go of Stress and Tension",
          description:
              "As you continue to visualize, imagine any stress or tension being washed away by the environment around you.",
        ),
        MeditationStepModel(
          title: "Gradually Transition Back",
          description:
              "After 10-15 minutes, slowly bring your awareness back to the present moment, bringing the calm energy from the visualization with you.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Loving Kindness Meditation",
      description:
          "This meditation focuses on cultivating feelings of compassion, kindness, and warmth towards yourself and others.",
      videoUrl: generateExerciseUrl('mind', 'Loving Kindness Meditation'),
      videothumbnail:
          'assets/images/meditation/mind/video_thumbnails/Loving Kindness Meditation.png',
      duration: "4:45",
      steps: [
        MeditationStepModel(
          title: "Sit in a Comfortable Position",
          description:
              "Find a peaceful place where you can sit comfortably with your back straight and your hands resting on your lap.",
        ),
        MeditationStepModel(
          title: "Close Your Eyes and Focus on Your Breath",
          description:
              "Breathe deeply and slowly to calm your body and mind, becoming present in the moment.",
        ),
        MeditationStepModel(
          title: "Begin with Yourself",
          description:
              "Silently repeat phrases of kindness towards yourself, such as, “May I be happy. May I be healthy. May I be at peace.”",
        ),
        MeditationStepModel(
          title: "Extend Compassion to Loved Ones",
          description:
              "Visualize someone you care about and repeat the same phrases for them: “May you be happy. May you be healthy. May you be at peace.”",
        ),
        MeditationStepModel(
          title: "Extend Compassion to Neutral People",
          description:
              "Visualize someone you don’t have a strong opinion about, and send them the same well wishes: “May you be happy…”",
        ),
        MeditationStepModel(
          title: "Extend Compassion to Difficult People",
          description:
              "Visualize someone you have difficulties with and send them kind thoughts: “May you be happy…” Try to genuinely wish them well.",
        ),
        MeditationStepModel(
          title: "Conclude with Universal Compassion",
          description:
              "Finally, send out loving kindness to all beings everywhere: “May all beings be happy. May all beings be healthy…”",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Breath Counting Meditation",
      description:
          "This simple technique helps to enhance concentration and reduce anxiety by focusing on counting breaths.",
      videoUrl: generateExerciseUrl('mind', 'Breath Counting Meditation'),
      videothumbnail:
          'assets/images/meditation/mind/video_thumbnails/Breath Counting Meditation.png',
      duration: "11:45",
      steps: [
        MeditationStepModel(
          title: "Sit in a Quiet, Comfortable Position",
          description:
              "Sit down comfortably with your back straight, hands resting on your lap, and feet flat on the floor.",
        ),
        MeditationStepModel(
          title: "Close Your Eyes and Take a Deep Breath",
          description:
              "Take a long, slow inhale through your nose, then exhale gently through your mouth, relaxing your body with each exhale.",
        ),
        MeditationStepModel(
          title: "Begin Counting Your Breaths",
          description:
              "Start by counting each inhale and exhale as one cycle. For example, “one” when you inhale, “two” when you exhale.",
        ),
        MeditationStepModel(
          title: "Focus Entirely on the Breath",
          description:
              "If your mind wanders, simply notice it and bring your attention back to your breathing and the counting.",
        ),
        MeditationStepModel(
          title: "Increase Your Focus as You Count",
          description:
              "Continue counting up to 10, and then start over. Aim to do this without interruption for at least 10 minutes.",
        ),
        MeditationStepModel(
          title: "Notice the Shift in Your Mind",
          description:
              "As you continue, you’ll likely notice a greater sense of calm and concentration. Enjoy this feeling.",
        ),
        MeditationStepModel(
          title: "Gradually End the Practice",
          description:
              "After a few minutes, slowly bring your attention back to the present moment, noticing how calm you feel.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Affirmation Meditation",
      description:
          "This meditation uses positive affirmations to rewire your subconscious mind and boost your self-esteem.",
      videoUrl: generateExerciseUrl('mind', 'Affirmation Meditation'),
      videothumbnail:
          'assets/images/meditation/mind/video_thumbnails/Affirmation Meditation.png',
      duration: "5:14",
      steps: [
        MeditationStepModel(
          title: "Sit Comfortably with Your Eyes Closed",
          description:
              "Choose a comfortable seat where you can sit upright but relaxed. Close your eyes to block out distractions.",
        ),
        MeditationStepModel(
          title: "Take Several Deep Breaths",
          description:
              "Breathe deeply into your abdomen, and let go of any physical tension with each exhale.",
        ),
        MeditationStepModel(
          title: "Choose Positive Affirmations",
          description:
              "Select a few affirmations that resonate with you, such as “I am worthy,” “I am capable,” or “I am at peace.”",
        ),
        MeditationStepModel(
          title: "Repeat Affirmations Silently",
          description:
              "Repeat each affirmation quietly in your mind, focusing on the words and allowing them to sink in.",
        ),
        MeditationStepModel(
          title: "Visualize Your Affirmations Coming True",
          description:
              "As you repeat the affirmations, visualize yourself embodying the positive qualities you are affirming.",
        ),
        MeditationStepModel(
          title: "Feel the Emotions of the Affirmations",
          description:
              "Allow yourself to feel the positive emotions these affirmations generate, whether it's love, confidence, or peace.",
        ),
        MeditationStepModel(
          title: "Close the Meditation with Gratitude",
          description:
              "Conclude by expressing gratitude for yourself, for the positive changes, and for the present moment.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Chakra Visualization Meditation",
      description:
          "This meditation involves focusing on the seven main energy centers (chakras) in your body to promote balance and well-being.",
      videoUrl: generateExerciseUrl('mind', 'Chakra Visualization Meditation'),
      videothumbnail:
          'assets/images/meditation/mind/video_thumbnails/Chakra Visualization Meditation.png',
      duration: "6:24",
      steps: [
        MeditationStepModel(
          title: "Find a Comfortable Position",
          description:
              "Sit with your spine straight and your body relaxed. Close your eyes and begin to breathe deeply.",
        ),
        MeditationStepModel(
          title: "Focus on the Root Chakra",
          description:
              "Visualize a red light at the base of your spine, growing stronger with each inhale.",
        ),
        MeditationStepModel(
          title: "Move Up Through the Chakras",
          description:
              "Progressively focus on each chakra: orange at the lower abdomen, yellow at the upper abdomen, green at the heart, blue at the throat, indigo at the forehead, and violet at the crown.",
        ),
        MeditationStepModel(
          title: "Visualize Each Color Radiating",
          description:
              "Imagine each color glowing brightly and expanding within its respective area.",
        ),
        MeditationStepModel(
          title: "Feel the Energy Balancing",
          description:
              "Sense the energy in each chakra becoming more balanced and harmonious.",
        ),
        MeditationStepModel(
          title: "Breathe Through Your Chakras",
          description:
              "Imagine your breath flowing in and out through all your chakras simultaneously.",
        ),
        MeditationStepModel(
          title: "Gently Return to Awareness",
          description:
              "Gradually release the visualizations and bring your awareness back to your body and your breath.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Gratitude Meditation",
      description:
          "This meditation cultivates feelings of thankfulness and appreciation for the good things in your life.",
      videoUrl: generateExerciseUrl('mind', 'Gratitude Meditation'),
      videothumbnail:
          'assets/images/meditation/mind/video_thumbnails/Gratitude Meditation.png',
      duration: "5:15",
      steps: [
        MeditationStepModel(
          title: "Find a Comfortable and Quiet Space",
          description:
              "Sit or lie down comfortably and close your eyes gently.",
        ),
        MeditationStepModel(
          title: "Bring to Mind Things You Are Grateful For",
          description:
              "Think of a few simple things you appreciate in your life.",
        ),
        MeditationStepModel(
          title: "Reflect on People You Appreciate",
          description:
              "Bring to mind individuals who have positively impacted you.",
        ),
        MeditationStepModel(
          title: "Consider Positive Experiences",
          description:
              "Reflect on enjoyable moments or opportunities you've had.",
        ),
        MeditationStepModel(
          title: "Feel the Emotion of Gratitude",
          description:
              "Allow yourself to truly feel the thankfulness associated with each thought.",
        ),
        MeditationStepModel(
          title: "Silently Express Your Gratitude",
          description:
              "Mentally say 'thank you' for each person, experience, or thing.",
        ),
        MeditationStepModel(
          title: "Rest in the Feeling",
          description:
              "Sit quietly for a few moments, savoring the feeling of gratitude.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Nature Visualization Meditation",
      description:
          "This meditation uses your imagination to connect with the peace and beauty of nature.",
      videoUrl: generateExerciseUrl('mind', "Nature Visualization Meditation"),
      videothumbnail:
          'assets/images/meditation/mind/video_thumbnails/Nature Visualization Meditation.png',
      duration: "6:24",
      steps: [
        MeditationStepModel(
          title: "Find a Comfortable Position",
          description:
              "Sit or lie down in a relaxed manner and close your eyes.",
        ),
        MeditationStepModel(
          title: "Choose Your Natural Scene",
          description:
              "Imagine a peaceful natural setting, like a forest or a beach.",
        ),
        MeditationStepModel(
          title: "Engage Your Senses in Your Mind",
          description:
              "Visualize the sights, sounds, and smells of this place.",
        ),
        MeditationStepModel(
          title: "Feel the Environment Around You",
          description:
              "Imagine the temperature, the feel of the ground, or a gentle breeze.",
        ),
        MeditationStepModel(
          title: "Immerse Yourself in the Scene",
          description:
              "Allow yourself to fully experience the tranquility of this natural space.",
        ),
        MeditationStepModel(
          title: "Breathe in the Peace of Nature",
          description:
              "Imagine inhaling the fresh air and the calming energy of nature.",
        ),
        MeditationStepModel(
          title: "Gently Return to the Present",
          description:
              "Slowly bring your awareness back to your body and your surroundings.",
        ),
      ],
    ),
    MeditationExerciseModel(
      title: "Zen Mindfulness Meditation",
      description:
          "This mindfulness meditation emphasizes direct experience of the present moment without judgment.",
      videoUrl: generateExerciseUrl('mind', 'Zen Mindfulness Meditation'),
      videothumbnail:
          'assets/images/meditation/mind/video_thumbnails/Zen Mindfulness Meditation.png',
      duration: "5:27",
      steps: [
        MeditationStepModel(
          title: "Find a Stable and Comfortable Posture",
          description:
              "Sit with a straight but relaxed spine. Your hands can rest gently on your lap.",
        ),
        MeditationStepModel(
          title: "Anchor Your Awareness to Your Breath",
          description:
              "Focus on the sensation of your breath as it enters and leaves your body.",
        ),
        MeditationStepModel(
          title: "Observe Sensations Without Judgment",
          description:
              "Notice any physical sensations, thoughts, or emotions that arise.",
        ),
        MeditationStepModel(
          title: "Acknowledge Thoughts and Let Them Go",
          description:
              "When thoughts occur, simply acknowledge them without engaging and return to your breath.",
        ),
        MeditationStepModel(
          title: "Observe Emotions Without Reacting",
          description:
              "Notice any feelings that arise without trying to change or suppress them.",
        ),
        MeditationStepModel(
          title: "Maintain Non-Judgmental Awareness",
          description:
              "Practice being present with your experience exactly as it is, without labeling it.",
        ),
        MeditationStepModel(
          title: "Gently Expand Awareness and Conclude",
          description:
              "Gradually expand your awareness to your surroundings before gently ending the meditation.",
        ),
      ],
    ),
  ],
);
