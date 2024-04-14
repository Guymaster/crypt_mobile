import 'package:crypt_mobile/models/file.model.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:contextual_menu/contextual_menu.dart';

Menu FileItemMenu(void Function() onCopy, void Function() onEdit, void Function() onDelete,) => Menu(
  items: [
    MenuItem(
      label: 'Copy',
      onClick: (_) {
        onCopy();
      },
    ),
    MenuItem(
      label: 'Edit',
      onClick: (_) {
        onEdit();
      },
    ),
    MenuItem(
      label: 'Delete',
      onClick: (_) {
        onDelete();
      },
    ),
  ],
);