install:
	git clone https://github.com/litecoin-project/litecoin.git src && \
	cd src && \
	git checkout tags/v0.16.3 -b local && \
	./autogen.sh && \
	./configure --without-gui --disable-upnp-default --disable-tests --disable-wallet; \
	make install
