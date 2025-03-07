import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';



class VideoScreen extends StatefulWidget {
  final String videoUrl;

  const VideoScreen({super.key, required this.videoUrl});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _isFullscreen = false;
  bool _showControls = true;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  late Future<void> _initializeVideoPlayerFuture;
  Timer? _hideControlsTimer;
  bool _isVerticalVideo = false;

  // Holds the current drag progress (0.0 to 1.0) during scrubbing.
  double? _dragProgress;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {
        _totalDuration = _controller.value.duration;
        _isVerticalVideo = _controller.value.size.aspectRatio < 1;
        _updateScreenMode();
      });
    });

    _controller.addListener(() {
      setState(() {
        _currentPosition = _controller.value.position;
        _isPlaying = _controller.value.isPlaying;
      });
    });

    _startHideControlsTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _resetOrientation();
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying ? _controller.pause() : _controller.play();
      _startHideControlsTimer();
    });
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
      _updateScreenMode();
    });
    _startHideControlsTimer();
  }

  void _updateScreenMode() {
    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      _resetOrientation();
    }
  }

  void _resetOrientation() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
    _startHideControlsTimer();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showControls = false);
      }
    });
  }

  // Builds a YouTube-like interactive seek bar.
  Widget _buildYoutubeSeekBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Use _dragProgress when dragging; otherwise use the actual video progress.
        final progress = _dragProgress ??
            ((_totalDuration.inMilliseconds > 0)
                ? _currentPosition.inMilliseconds / _totalDuration.inMilliseconds
                : 0.0);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (details) {
            final dx = details.localPosition.dx;
            final newProgress = dx.clamp(0, width) / width;
            setState(() {
              _dragProgress = newProgress;
            });
          },
          onHorizontalDragUpdate: (details) {
            final dx = details.localPosition.dx;
            final newProgress = dx.clamp(0, width) / width;
            setState(() {
              _dragProgress = newProgress;
            });
            // Continuously update the video position as the user scrubs.
            final newPosition = Duration(
                milliseconds: (newProgress * _totalDuration.inMilliseconds).toInt());
            _controller.seekTo(newPosition);
          },
          onHorizontalDragEnd: (details) {
            setState(() {
              _dragProgress = null;
            });
          },
          onTapDown: (details) {
            final dx = details.localPosition.dx;
            final newProgress = dx.clamp(0, width) / width;
            final newPosition = Duration(
                milliseconds: (newProgress * _totalDuration.inMilliseconds).toInt());
            _controller.seekTo(newPosition);
          },
          child: Stack(
            children: [
              // Background bar
              Container(
                height: 5,
                color: Colors.white30,
              ),
              // Red progress indicator
              Container(
                height: 5,
                width: width * progress,
                color: Colors.red,
              ),
              // Floating label above the seek bar when scrubbing
              if (_dragProgress != null)
                Positioned(
                  left: (_dragProgress! * width) - 30,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${_formatDuration(Duration(milliseconds: (_dragProgress! * _totalDuration.inMilliseconds).toInt()))} / ${_formatDuration(_totalDuration)}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // Builds a top bar similar to YouTube with a back button and video title.
  Widget _buildTopBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Video Title',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds the complete controls overlay.
  Widget _buildControlsOverlay() {
    return AnimatedOpacity(
      opacity: _showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black54,
              Colors.transparent,
              Colors.black54,
            ],
          ),
        ),
        child: Column(
          children: [
            // Top bar (header)
            _buildTopBar(),
            const Spacer(),
            // Center play/pause button
            Center(
              child: IconButton(
                iconSize: 64,
                icon: Icon(
                  _isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: Colors.white,
                ),
                onPressed: _togglePlayPause,
              ),
            ),
            const Spacer(),
            // Interactive timeline with red progress indicator and floating label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _buildYoutubeSeekBar(),
            ),
            // Time labels (elapsed / total)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(_currentPosition),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    _formatDuration(_totalDuration),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            // Bottom control row: Mute and Fullscreen buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      _isMuted ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: _toggleMute,
                  ),
                  IconButton(
                    icon: Icon(
                      _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: _toggleFullScreen,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Utility method to format a Duration as a string (e.g., "03:45").
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours > 0 ? '${twoDigits(duration.inHours)}:' : ''}$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
            if (_showControls) _startHideControlsTimer();
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(
                    child: AspectRatio(
                      aspectRatio: _isVerticalVideo
                          ? 9 / 16
                          : _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
              },
            ),
            // Display the controls overlay when needed.
            if (_showControls) _buildControlsOverlay(),
          ],
        ),
      ),
    );
  }
}
