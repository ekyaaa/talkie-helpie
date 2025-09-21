import 'package:talkie_helpie/core/models/word.dart';
import 'package:flutter/material.dart';
import 'package:talkie_helpie/core/style/app_colors.dart';

// Helper for getting card color based on WordType
Color getCardBgColor(WordType type) {
  switch (type) {
    case WordType.pronoun:
      return AppColors.bgPronoun;
    case WordType.urgent:
      return AppColors.bgUrgent;
    case WordType.response:
      return AppColors.bgResponse;
    case WordType.emotion:
      return AppColors.bgEmotion;
    case WordType.activity:
      return AppColors.bgActivity;
    case WordType.action:
      return AppColors.bgAction;
    case WordType.location:
      return AppColors.bgLocation;
    case WordType.placeholder:
      return AppColors.bgSecondary;
    }
}

Color getCardBorderColor(WordType type) {
  switch (type) {
    case WordType.pronoun:
      return AppColors.borderPronoun;
    case WordType.urgent:
      return AppColors.borderUrgent;
    case WordType.response:
      return AppColors.borderResponse;
    case WordType.emotion:
      return AppColors.borderEmotion;
    case WordType.activity:
      return AppColors.borderActivity;
    case WordType.action:
      return AppColors.borderAction;
    case WordType.location:
      return AppColors.borderLocation;
    case WordType.placeholder:
      return AppColors.borderSecondary;
  }
}

String getCardNameColor(WordType type) {
  switch (type) {
    case WordType.pronoun:
      return 'Oranye';
    case WordType.urgent:
      return 'Merah';
    case WordType.response:
      return 'Kuning';
    case WordType.emotion:
      return 'Ungu';
    case WordType.activity:
      return 'Hijau';
    case WordType.action:
      return 'Coklat';
    case WordType.location:
      return 'Biru';
    case WordType.placeholder:
      return 'Pilih Warna';
  }
}