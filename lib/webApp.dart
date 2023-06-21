import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VlcPlayerController _videoPlayerController;

  Future<void> initializePlayer() async {}

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VlcPlayerController.network(
      'https://b-35e552df.kinesisvideo.us-west-2.amazonaws.com/hls/v1/getHLSMasterPlaylist.m3u8?SessionToken=CiCSvcInz_RTpfiKI_QLhplvC6Hc5_PTNAYlzCXGoiawVhIQE6Zqee2YLbXh1llb8ZlGJBoZbt3DWZajmlxLdGrcsXcHaMJ4hDhSV615YSIg0bwSJYzcqMyuByMXoPc2vn7amrEMzJP4_QHuBujWqlc~',
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.clockJitter(300),
          VlcAdvancedOptions.clockSynchronization(0),
          VlcAdvancedOptions.fileCaching(300),
          VlcAdvancedOptions.liveCaching(130),
          VlcAdvancedOptions.networkCaching(300),
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(false),
        ]),
        sout: VlcStreamOutputOptions([
          VlcStreamOutputOptions.soutMuxCaching(300),
        ]),
        video: VlcVideoOptions([
          VlcVideoOptions.dropLateFrames(true),
          VlcVideoOptions.skipFrames(true),
        ]),
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController.stopRendererScanning();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ignacio"),
        ),
        body: Center(
          child: VlcPlayer(
            controller: _videoPlayerController,
            aspectRatio: 16 / 9,
            placeholder: Center(child: CircularProgressIndicator()),
          ),
        ));
  }
}
