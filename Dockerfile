FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev \
    libjpeg-dev libimlib2-dev libx11-dev libxft-dev libwebp-dev
RUN git clone https://github.com/nsxiv/nsxiv.git
WORKDIR /nsxiv
RUN make CC=afl-clang
RUN mkdir /nsxivCorpus
RUN wget https://download.samplelib.com/jpeg/sample-clouds-400x300.jpg
RUN wget https://download.samplelib.com/jpeg/sample-red-400x300.jpg
RUN wget https://download.samplelib.com/jpeg/sample-green-200x200.jpg
RUN wget https://download.samplelib.com/jpeg/sample-green-100x75.jpg
RUN mv *.jpg /nsxivCorpus
#ENV LD_LIBRARY_PATH=/usr/local/lib/

ENTRYPOINT ["afl-fuzz", "-i", "/nsxivCorpus", "-o", "/nsxivOut"]
CMD ["/nsxiv/nsxiv", "@@"]
