import 'package:flutter/material.dart';

// Pressing the popup menu button is possible to
// change the visualization of a page.

class PopupMenu extends StatelessWidget {
  final List<String> popupMenuItemsNames;
  final void Function(int itemIndex) popupMenuCallback;

  PopupMenu({
    super.key,
    required this.popupMenuItemsNames,
    required this.popupMenuCallback
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_vert),
          tooltip: 'Show menu',
        );
      },
      menuChildren: List<MenuItemButton>.generate(
        popupMenuItemsNames.length,
        (int index) => MenuItemButton(
          onPressed: () => popupMenuCallback(index),
          child: Text(popupMenuItemsNames.elementAt(index)),
        ),
      ),
    );
  }
}
