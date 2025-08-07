import 'package:flutter/material.dart';

class HorseSelectionWidget extends StatefulWidget {
  // 選択グループのラベル (例: ['軸', '相手'])
  final List<String> groupLabels;
  // 現在選択されている馬番のデータ
  final Map<int, Set<int>> selectedHorses;
  // チェックボックスが変更されたときに親に通知する関数
  final Function(int groupIndex, int horseNumber) onSelectionChanged;
  // 単一選択モードかどうか (単勝・複勝用)
  final bool isSingleSelection;

  const HorseSelectionWidget({
    super.key,
    required this.groupLabels,
    required this.selectedHorses,
    required this.onSelectionChanged,
    this.isSingleSelection = false,
  });

  @override
  State<HorseSelectionWidget> createState() => _HorseSelectionWidgetState();
}

class _HorseSelectionWidgetState extends State<HorseSelectionWidget> {
  int _currentGroupIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 複数グループがある場合のみ、グループ選択ボタンを表示
        if (widget.groupLabels.length > 1)
          ToggleButtons(
            isSelected: List.generate(
              widget.groupLabels.length,
              (index) => index == _currentGroupIndex,
            ),
            onPressed: (index) {
              setState(() {
                _currentGroupIndex = index;
              });
            },
            borderRadius: BorderRadius.circular(8),
            children: widget.groupLabels
                .map(
                  (label) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(label),
                  ),
                )
                .toList(),
          ),

        const SizedBox(height: 16),

        // 1〜18番の馬番チェックボックスをグリッド表示
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6, // 1行に6個表示
            childAspectRatio: 2.0,
          ),
          itemCount: 18,
          shrinkWrap: true, // 他のウィジェットの中で使うため
          physics: const NeverScrollableScrollPhysics(), // スクロールを無効化
          itemBuilder: (context, index) {
            final horseNumber = index + 1;
            final isSelected =
                widget.selectedHorses[_currentGroupIndex]?.contains(
                  horseNumber,
                ) ??
                false;

            return InkWell(
              onTap: () {
                widget.onSelectionChanged(_currentGroupIndex, horseNumber);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      widget.onSelectionChanged(
                        _currentGroupIndex,
                        horseNumber,
                      );
                    },
                  ),
                  Text('$horseNumber'),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
