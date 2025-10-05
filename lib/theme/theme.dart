import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

// Create a MaterialTheme instance with Montserrat adn Lustria as the font
final MaterialTheme materialTheme = MaterialTheme(
  createTextThemeWithGoogleFonts('Montserrat', 'Lustria'),
);

// Define global theme variables for the app
final ThemeData lightTheme = materialTheme.light();
final ThemeData darkTheme = materialTheme.dark();



TextTheme createTextThemeWithGoogleFonts(String bodyFont, String displayFont) {
  final base = Typography.material2021().black;

  // Body = Montserrat, Display (titles/headlines) = Lustria
  final bodyTextTheme = GoogleFonts.getTextTheme(bodyFont, base);
  final displayTextTheme = GoogleFonts.getTextTheme(displayFont, base);

  return displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
}

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff6c584b),
      surfaceTint: Color(0xff6f5a4d),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff867063),
      onPrimaryContainer: Color(0xfffffbff),
      secondary: Color(0xff675c56),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffefdfd7),
      onSecondaryContainer: Color(0xff6d625c),
      tertiary: Color(0xff5f5d49),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff787561),
      onTertiaryContainer: Color(0xfffffbff),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff8f5),
      onSurface: Color(0xff1d1b1a),
      onSurfaceVariant: Color(0xff4e453f),
      outline: Color(0xff80756e),
      outlineVariant: Color(0xffd2c4bc),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff33302e),
      inversePrimary: Color(0xffdcc1b1),
      primaryFixed: Color(0xfff9ddcd),
      onPrimaryFixed: Color(0xff27180f),
      primaryFixedDim: Color(0xffdcc1b1),
      onPrimaryFixedVariant: Color(0xff564337),
      secondaryFixed: Color(0xffefdfd7),
      onSecondaryFixed: Color(0xff221a15),
      secondaryFixedDim: Color(0xffd2c4bc),
      onSecondaryFixedVariant: Color(0xff4f453f),
      tertiaryFixed: Color(0xffe8e3ca),
      onTertiaryFixed: Color(0xff1d1c0d),
      tertiaryFixedDim: Color(0xffcbc7af),
      onTertiaryFixedVariant: Color(0xff494735),
      surfaceDim: Color(0xffdfd9d6),
      surfaceBright: Color(0xfffff8f5),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff9f2f0),
      surfaceContainer: Color(0xfff3ecea),
      surfaceContainerHigh: Color(0xffede7e4),
      surfaceContainerHighest: Color(0xffe8e1df),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff443327),
      surfaceTint: Color(0xff6f5a4d),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff7e695b),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff3d342f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff766b64),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff383726),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff706e5a),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f5),
      onSurface: Color(0xff131110),
      onSurfaceVariant: Color(0xff3d342f),
      outline: Color(0xff5b504b),
      outlineVariant: Color(0xff766b65),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff33302e),
      inversePrimary: Color(0xffdcc1b1),
      primaryFixed: Color(0xff7e695b),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff655144),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff766b64),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff5d534d),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff706e5a),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff585543),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffcbc5c3),
      surfaceBright: Color(0xfffff8f5),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff9f2f0),
      surfaceContainer: Color(0xffede7e4),
      surfaceContainerHigh: Color(0xffe2dbd9),
      surfaceContainerHighest: Color(0xffd6d0ce),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff39291e),
      surfaceTint: Color(0xff6f5a4d),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff584539),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff332a25),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff514741),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff2e2d1c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4c4a38),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f5),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff332a25),
      outlineVariant: Color(0xff514742),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff33302e),
      inversePrimary: Color(0xffdcc1b1),
      primaryFixed: Color(0xff584539),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff402f24),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff514741),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff3a312b),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff4c4a38),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff353322),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbdb8b5),
      surfaceBright: Color(0xfffff8f5),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6efed),
      surfaceContainer: Color(0xffe8e1df),
      surfaceContainerHigh: Color(0xffd9d3d1),
      surfaceContainerHighest: Color(0xffcbc5c3),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffdcc1b1),
      surfaceTint: Color(0xffdcc1b1),
      onPrimary: Color(0xff3e2d22),
      primaryContainer: Color(0xffa48c7e),
      onPrimaryContainer: Color(0xff27190f),
      secondary: Color(0xffd2c4bc),
      onSecondary: Color(0xff372f29),
      secondaryContainer: Color(0xff4f453f),
      onSecondaryContainer: Color(0xffc0b2ab),
      tertiary: Color(0xffcbc7af),
      onTertiary: Color(0xff333120),
      tertiaryContainer: Color(0xff94917c),
      onTertiaryContainer: Color(0xff1d1c0d),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff151312),
      onSurface: Color(0xffe8e1df),
      onSurfaceVariant: Color(0xffd2c4bc),
      outline: Color(0xff9b8e87),
      outlineVariant: Color(0xff4e453f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe8e1df),
      inversePrimary: Color(0xff6f5a4d),
      primaryFixed: Color(0xfff9ddcd),
      onPrimaryFixed: Color(0xff27180f),
      primaryFixedDim: Color(0xffdcc1b1),
      onPrimaryFixedVariant: Color(0xff564337),
      secondaryFixed: Color(0xffefdfd7),
      onSecondaryFixed: Color(0xff221a15),
      secondaryFixedDim: Color(0xffd2c4bc),
      onSecondaryFixedVariant: Color(0xff4f453f),
      tertiaryFixed: Color(0xffe8e3ca),
      onTertiaryFixed: Color(0xff1d1c0d),
      tertiaryFixedDim: Color(0xffcbc7af),
      onTertiaryFixedVariant: Color(0xff494735),
      surfaceDim: Color(0xff151312),
      surfaceBright: Color(0xff3c3937),
      surfaceContainerLowest: Color(0xff100e0d),
      surfaceContainerLow: Color(0xff1d1b1a),
      surfaceContainer: Color(0xff211f1e),
      surfaceContainerHigh: Color(0xff2c2928),
      surfaceContainerHighest: Color(0xff373433),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff3d7c7),
      surfaceTint: Color(0xffdcc1b1),
      onPrimary: Color(0xff322218),
      primaryContainer: Color(0xffa48c7e),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffe9d9d1),
      onSecondary: Color(0xff2c241f),
      secondaryContainer: Color(0xff9b8e87),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffe1ddc4),
      onTertiary: Color(0xff282616),
      tertiaryContainer: Color(0xff94917c),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff151312),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffe8d9d2),
      outline: Color(0xffbdafa8),
      outlineVariant: Color(0xff9a8e87),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe8e1df),
      inversePrimary: Color(0xff574438),
      primaryFixed: Color(0xfff9ddcd),
      onPrimaryFixed: Color(0xff1b0e06),
      primaryFixedDim: Color(0xffdcc1b1),
      onPrimaryFixedVariant: Color(0xff443327),
      secondaryFixed: Color(0xffefdfd7),
      onSecondaryFixed: Color(0xff17100b),
      secondaryFixedDim: Color(0xffd2c4bc),
      onSecondaryFixedVariant: Color(0xff3d342f),
      tertiaryFixed: Color(0xffe8e3ca),
      onTertiaryFixed: Color(0xff131205),
      tertiaryFixedDim: Color(0xffcbc7af),
      onTertiaryFixedVariant: Color(0xff383726),
      surfaceDim: Color(0xff151312),
      surfaceBright: Color(0xff474442),
      surfaceContainerLowest: Color(0xff090706),
      surfaceContainerLow: Color(0xff1f1d1c),
      surfaceContainer: Color(0xff2a2726),
      surfaceContainerHigh: Color(0xff353231),
      surfaceContainerHighest: Color(0xff403d3c),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffece2),
      surfaceTint: Color(0xffdcc1b1),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffd8bdae),
      onPrimaryContainer: Color(0xff140802),
      secondary: Color(0xfffdede5),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffcec0b8),
      onSecondaryContainer: Color(0xff100a06),
      tertiary: Color(0xfff5f0d7),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffc7c3ac),
      onTertiaryContainer: Color(0xff0d0c02),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff151312),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfffdede5),
      outlineVariant: Color(0xffcec0b8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe8e1df),
      inversePrimary: Color(0xff574438),
      primaryFixed: Color(0xfff9ddcd),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffdcc1b1),
      onPrimaryFixedVariant: Color(0xff1b0e06),
      secondaryFixed: Color(0xffefdfd7),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffd2c4bc),
      onSecondaryFixedVariant: Color(0xff17100b),
      tertiaryFixed: Color(0xffe8e3ca),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffcbc7af),
      onTertiaryFixedVariant: Color(0xff131205),
      surfaceDim: Color(0xff151312),
      surfaceBright: Color(0xff534f4e),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff211f1e),
      surfaceContainer: Color(0xff33302e),
      surfaceContainerHigh: Color(0xff3e3b39),
      surfaceContainerHighest: Color(0xff494645),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.background,
    canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}



