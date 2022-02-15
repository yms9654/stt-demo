if [ -z "$1" ]
    then
        echo "Please port number."
        exit 1
fi

docker run --mount type=bind,source="$(pwd)"/scripts,target=/app/scripts -it -p $1:8888 yms9654/stt-demo /bin/bash
# docker run --mount type=bind,source="$(pwd)"/app,target=/app -it -p $1:8888 pororo:0.1 /bin/bash
# docker run -it -p $1:8888 yms9654/stt-demo /bin/bash


