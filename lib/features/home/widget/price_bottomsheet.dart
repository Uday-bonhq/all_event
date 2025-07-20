import 'package:all_event/core/app_colors.dart';
import 'package:all_event/features/home/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showPriceRangeBottomSheet(BuildContext context,WidgetRef ref, ) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      RangeValues _range = ref.watch(eventStateProvider).range;
      const double min = 0, max = 2000;

      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Top Indicator
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),

                /// Title
                const Text.rich(
                  TextSpan(
                    text: "Price ",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: "Range",
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                /// Range Slider
                RangeSlider(
                  values: _range,
                  min: min,
                  max: max,

                  // divisions: 40,
                  activeColor: primaryColor,
                  labels: RangeLabels(
                    "₹${_range.start.toInt()}",
                    "₹${_range.end.toInt()}",
                  ),
                  onChanged: (RangeValues values) {
                    setState(() => _range = values);
                  },
                ),

                /// Price Labels
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _priceBox("From", _range.start.toInt(), Colors.black, true),
                    _priceBox("To", _range.end.toInt(), Colors.black, true),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _priceBox(String label, int amount, Color primaryColor, bool isSelected) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.white : Colors.grey.shade100,
        ),
        child: Text(
          "₹$amount",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? primaryColor : Colors.grey.shade500,
          ),
        ),
      ),
    ],
  );
}




void showDateBottomSheet({
  required BuildContext context,
  required DateTime selectedDate,
  required Function(DateTime) onDateSelected,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      DateTime tempDate = selectedDate;

      return StatefulBuilder(builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Drag handle
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),

              /// Title
              const Text(
                'Select Date',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              /// Date Picker
              SizedBox(
                height: 250,
                child: CalendarDatePicker(
                  initialDate: tempDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  onDateChanged: (date) {
                    setState(() => tempDate = date);
                  },
                ),
              ),

              const SizedBox(height: 16),

              /// Confirm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    onDateSelected(tempDate);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      });
    },
  );
}
