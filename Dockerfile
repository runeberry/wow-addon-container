FROM woahbase/alpine-lua:x86_64
RUN mkdir /addon
WORKDIR /addon
ENTRYPOINT [ "/bin/bash" ]

RUN apk add --no-cache \
    make \
    curl \
    unzip \
    lua-md5 \
    build-base

# The lcov package for Alpine only lives in the edge repository at time of writing
RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
    lcov

RUN luarocks install busted && \
    luarocks install luacov && \
    luarocks install luacov-reporter-lcov && \
    luarocks install luacov-console && \
    luarocks install luabitop
