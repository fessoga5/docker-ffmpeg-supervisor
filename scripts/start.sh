#!/bin/bash
# ENV
# TYPE, URL, DESTURL


if [ ! -z "$PASSWORD" ] ; then
    # Change password for user ubuntu
    echo "ubuntu:${PASSWD}" | /usr/sbin/chpasswd
fi

#   1. transkoding mpeg2 to mpeg4 for translate on web site
#   ffmpeg -threads 1 -loglevel warning -i udp://238.0.1.2:1234 -vcodec h264 -vsync passthrough -r 25 -vb 2000k -preset fast -acodec aac -strict experimental -threads 1 -f mpegts "udp://127.0.0.1:1051?pkt_size=1316&ttl=50"
#   env: type=mp2tomp4
#
#   2. transkoding mpeg4 to mpeg4 for translate on site
#   ffmpeg -threads 1 -loglevel warning -i udp://238.0.1.2:1234 -vcodec copy -vsync passthrough -acodec aac -strict experimental -threads 1 -f mpegts "udp://127.0.0.1:1051?pkt_size=1316&ttl=50"
#   env: type=mp4tomp4
#
#   3. load stream from rtsp and translate
#   ffmpeg -stimeout 5000000 -rtsp_transport tcp -i rtsp://test:cameratest@172.16.17.116:554 -map 0:1 -vcodec copy - a codec aac -strict experimental -ab 32k  -f mpegts "udp://127.0.0.1:1051?pkt_size=1316&ttl=50"
#   env: type=rtsptranslate
#
#   4. load stream from rtsp and copy to local path
#   ffmpeg -r 10 -stimeout 5000000 -rtsp_transport tcp -i rtsp://test:cameratest@172.16.17.116:554 -map 0:1 -vcodec copy -y -f segment -segment_time 300 -segment_atclocktime 1 -reset_timestamps 1 -strftime 1 /share/car/%y%m%d%h%m%s.mp4 
#   env: type=rtspsave
TYPEE=${TYPE:="mp2tomp4"}
URLE=${URL:="udp://127.0.0.1:1234"}
DESTURLE=${DESTURL:="udp://127.0.0.1:1234"}

case ${TYPEE} in
mp2tomp4)
    TEMPLATE_LIST="ffmpeg -threads 1 -loglevel warning -i ${URLE} -vcodec h264 -vsync passthrough -r 25 -vb 2000k -preset fast -acodec aac -strict experimental -threads 1 -f mpegts ${DESTURLE}"
    ;;
mp4tomp4)
    TEMPLATE_LIST="ffmpeg -threads 1 -loglevel warning -i ${URLE} -vcodec copy -acodec aac -strict experimental -threads 1 -f mpegts ${DESTURLE}"
    ;;
rtsptranslate)
    TEMPLATE_LIST="ffmpeg -stimeout 5000000 -rtsp_transport tcp -i ${URLE} -vcodec copy - a codec aac -strict experimental -ab 32k -f mpegts ${DESTURLE}"
    ;;
rtspsave)
    TEMPLATE_LIST="ffmpeg -stimeout 5000000 -rtsp_transport tcp -i ${URLE} -vcodec copy - a codec aac -strict experimental -ab 32k -y -f segment -segment_time 300 -segment_atclocktime 1 -reset_timestamps 1 -strftime 1 /share/%y%m%d%h%m%s.mp4"
    ;;
esac

echo $TEMPLATE_LIST

#sed -i.bak 's/template_ffmpeg/'"$TEMPLATE_LIST"'/g' 
echo "command=$TEMPLATE_LIST" >> /etc/supervisor/supervisord.conf

# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
