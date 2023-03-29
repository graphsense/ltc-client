install:
	git clone --depth=1 -b v0.21.2.2 https://github.com/litecoin-project/litecoin.git src && \
	cd src && \
	./autogen.sh && \
	./configure --without-gui --disable-zmq --disable-upnp-default --disable-tests --disable-wallet; \
	make install
