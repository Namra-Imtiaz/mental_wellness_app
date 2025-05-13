String generateExerciseUrl(String category, String title) {
  final sanitizedTitle = title
      .replaceAll('(', '%28')
      .replaceAll(')', '%29')
      .replaceAll(' ', '%20'); // Ensure spaces are encoded too

  return 'https://meditation-app-videos.s3.eu-north-1.amazonaws.com/$category/$sanitizedTitle.mp4';
}
