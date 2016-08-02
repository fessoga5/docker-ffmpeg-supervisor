========================
docker-ffmpeg-supervisor

Based images for start ffmpeg in docker

=========
Templates

	1. Transkoding mpeg2 to mpeg4 for translate on web site
	ffmpeg -threads 1 -loglevel warning -i udp://238.0.1.2:1234 -vcodec h264 -vsync passthrough -r 25 -vb 2000k -preset fast -acodec aac -strict experimental -threads 1 -f mpegts "udp://127.0.0.1:1051?pkt_size=1316&ttl=50"
	env: TYPE=mp2tomp4

	2. Transkoding mpeg4 to mpeg4 for translate on site
	ffmpeg -threads 1 -loglevel warning -i udp://238.0.1.2:1234 -vcodec copy -vsync passthrough -acodec aac -strict experimental -threads 1 -f mpegts "udp://127.0.0.1:1051?pkt_size=1316&ttl=50"
	env: TYPE=mp4tomp4

	3. Load stream from RTSP and translate
	ffmpeg -stimeout 5000000 -rtsp_transport tcp -i rtsp://test:cameratest@172.16.17.116:554 -map 0:1 -vcodec copy - a codec aac -strict experimental -ab 32k  -f mpegts "udp://127.0.0.1:1051?pkt_size=1316&ttl=50"
	env: TYPE=rtsptranslate

	4. Load stream from RTSP and copy to local path
	ffmpeg -r 10 -stimeout 5000000 -rtsp_transport tcp -i rtsp://test:cameratest@172.16.17.116:554 -map 0:1 -vcodec copy -y -f segment -segment_time 300 -segment_atclocktime 1 -reset_timestamps 1 -strftime 1 /share/car/%Y%m%d%H%M%S.mp4	
	env: TYPE=rtspsave

===========
ENVIRONMENT

1. Templates=mp2tomp4 (see top)

2. URL="udp://238.0.1.1:1234"

3. DESTURL="udp://127.0.0.1:1051?pkt_size=1316&ttl=50"

4. PASSWORD=pass set password for root user ubuntu
