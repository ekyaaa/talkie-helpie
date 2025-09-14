import 'package:talkie_helpie/core/models/word.dart';
import 'package:flutter/material.dart';
import 'package:talkie_helpie/core/style/app_colors.dart';

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
  }
}