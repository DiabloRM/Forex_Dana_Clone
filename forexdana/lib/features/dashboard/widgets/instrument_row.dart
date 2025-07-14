import 'package:flutter/material.dart';

class InstrumentRow extends StatelessWidget {
  final String name;
  final String change;
  final String percent;
  final bool isUp;
  final String buyPrice;
  final String buyDiff;
  final String sellPrice;
  final bool showFire;

  const InstrumentRow({
    required this.name,
    required this.change,
    required this.percent,
    required this.isUp,
    required this.buyPrice,
    required this.buyDiff,
    required this.sellPrice,
    this.showFire = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Name and change
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      change,
                      style: TextStyle(
                        color: isUp ? Colors.green : Colors.red,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      isUp ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isUp ? Colors.green : Colors.red,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      percent,
                      style: TextStyle(
                        color: isUp ? Colors.green : Colors.red,
                        fontSize: 14,
                      ),
                    ),
                    if (showFire) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.local_fire_department,
                        color: Colors.red,
                        size: 16,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Buy price
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      buyPrice,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    buyDiff,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          // Sell price
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  sellPrice,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
