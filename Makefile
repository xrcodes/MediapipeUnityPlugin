BUILD := default
MODE := gpu

builddir := .build
sdkdir := Assets/Mediapipe/SDK
plugindir := $(sdkdir)/Plugins
modeldir := $(sdkdir)/Models

bazelflags.default := -c opt
bazelflags.debug := --compilation_mode=dbg
bazelflags.gpu := --copt -DMESA_EGL_NO_X11_HEADERS --copt -DEGL_NO_X11
bazelflags.cpu := --define MEDIAPIE_DISABLE_GPU=1
BAZELFLAGS := ${bazelflags.${BUILD}} ${bazelflags.${MODE}}

protobuf_version := 3.13.0
protobuf_root := $(builddir)/protobuf-$(protobuf_version)
protobuf_tarball := $(protobuf_root).tar.gz
protobuf_csharpdir := $(protobuf_root)/csharp
protobuf_bindir := $(protobuf_csharpdir)/src/Google.Protobuf/bin/Release/net45
protobuf_dll := $(protobuf_bindir)/Google.Protobuf.dll

.PHONY: all mediapipe_api clean

all: $(protobuf_dll) mediapipe_api

mediapipe_api:
	cd C && bazel build ${BAZELFLAGS} //mediapipe_api:mediapipe_c //mediapipe_api:mediapipe_models

$(plugindir)/Google.Protobuf.dll: Temp/$(protobuf_tarball)
	cd Temp/protobuf-$(protobuf_version)/csharp && ./buildall.sh && mv src/Google.Protobuf/bin/Release/net45/* ../../../$(plugindir)

$(protobuf_dll): | $(protobuf_root)
	./$(protobuf_csharpdir)/buildall.sh

$(protobuf_root): | $(protobuf_tarball)
	tar xf $(protobuf_tarball) -C $(builddir)

$(protobuf_tarball): | $(builddir)
	curl -L https://github.com/protocolbuffers/protobuf/archive/v$(protobuf_version).tar.gz -o $@

$(builddir):
	mkdir -p $@

install: install-protobuf install-mediapipe_c install-models

install-protobuf: | $(plugindir)/Protobuf
	cp $(protobuf_bindir)/* $(plugindir)/Protobuf

install-mediapipe_c:
	cp -f C/bazel-bin/mediapipe_api/libmediapipe_c.so $(plugindir)

install-models:
	unzip C/bazel-bin/mediapipe_api/mediapipe_models.zip -d $(modeldir)

$(plugindir)/Protobuf:
	mkdir -p $@

clean:
	rm -r $(plugindir)/Protobuf && \
	rm -f $(plugindir)/libmediapipe_c.so && \
	rm -r $(builddir) && \
	cd C && \
	bazel clean
