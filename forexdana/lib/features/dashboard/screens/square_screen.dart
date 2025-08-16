import 'package:flutter/material.dart';

class SquareScreen extends StatefulWidget {
  final int initialIndex;
  const SquareScreen({Key? key, this.initialIndex = 1}) : super(key: key);

  @override
  State<SquareScreen> createState() => _SquareScreenState();
}

class _SquareScreenState extends State<SquareScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
  }

  @override
  void didUpdateWidget(SquareScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      _tabController.animateTo(widget.initialIndex);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Tab navigation bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TabBar(
                controller: _tabController,
                isScrollable: false,
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey.shade600,
                labelStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                tabs: const [
                  Tab(
                    child: Text('Live Stream', overflow: TextOverflow.visible),
                  ),
                  Tab(child: Text('Chat Room', overflow: TextOverflow.visible)),
                  Tab(
                    child: Text('My Message', overflow: TextOverflow.visible),
                  ),
                  Tab(child: Text('Subscribe', overflow: TextOverflow.visible)),
                ],
              ),
            ),

            // Content area
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLiveStreamTab(),
                  _buildChatRoomTab(),
                  _buildMyMessageTab(),
                  _buildSubscribeTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveStreamTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'Live Stream History',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        // Live stream cards grid
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: 16,
                itemBuilder: (context, index) {
                  return _LiveStreamCard(
                    imageUrl: '', // Placeholder
                    title: 'Unlock Profit Potential\nWith Expert LEO',
                    date: '07/${30 - (index % 15)} 14:45',
                    views: (45323 ~/ (index + 1)).toString(),
                    host: 'BtcDana',
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildChatRoomTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _NoDataIllustration(),
          SizedBox(height: 24),
          Text('No data', style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildMyMessageTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _NoDataIllustration(),
          SizedBox(height: 24),
          Text('No data', style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildSubscribeTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _NoDataIllustration(),
          SizedBox(height: 24),
          Text('No data', style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}

class _LiveStreamCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String date;
  final String views;
  final String host;

  const _LiveStreamCard({
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.views,
    required this.host,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and view count
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue.shade100,
                    ),
                    child: const Center(
                      child: Icon(Icons.lock, size: 40, color: Colors.blue),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.visibility,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            views,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Title section
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            // Date
            Text(
              date,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Host and replay section
            Row(
              children: [
                const Icon(Icons.account_circle, color: Colors.blue, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    host,
                    style: const TextStyle(color: Colors.blue, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Replay',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NoDataIllustration extends StatelessWidget {
  const _NoDataIllustration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background cards
        Positioned(
          top: 20,
          child: Transform.rotate(
            angle: -0.1,
            child: Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        // Middle card
        Positioned(
          top: 10,
          child: Transform.rotate(
            angle: 0.05,
            child: Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        // Front card with orange header
        Container(
          width: 120,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Column(
            children: [
              // Orange header
              Container(
                width: double.infinity,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
              ),
              // Content lines
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 2,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 80,
                        height: 2,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 40,
                        height: 2,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Pen/pencil
        Positioned(
          top: 5,
          right: 15,
          child: Transform.rotate(
            angle: 0.3,
            child: Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),

        // Pen tip
        Positioned(
          top: 3,
          right: 10,
          child: Transform.rotate(
            angle: 0.3,
            child: Container(
              width: 0,
              height: 0,
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.black, width: 8),
                  top: BorderSide(color: Colors.transparent, width: 4),
                  bottom: BorderSide(color: Colors.transparent, width: 4),
                ),
              ),
            ),
          ),
        ),

        // Dashed lines (activity indicator)
        Positioned(
          top: 0,
          right: 25,
          child: Row(
            children: [
              for (int i = 0; i < 3; i++) ...[
                Container(
                  width: 2,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                if (i < 2) const SizedBox(width: 2),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
