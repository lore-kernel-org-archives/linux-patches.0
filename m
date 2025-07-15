Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B722E49B3;
	Tue, 15 Jul 2025 13:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585846; cv=none; b=JnTKp3At4YhSsvc53JYXZ4qUrHR5WFFlSRBJnIjej2HoK0PW2+RSjnkdYu7j0DsWGW9UgfdcVb16T3igYjmeMuSBXxlF2H9KAFIA4JvctQJYhokFZ6wD8Ryk0rFOZq3xiwsGgo6TSFvZAva7orFvqgCfk3H9ueSU1KnmKTVJWt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585846; c=relaxed/simple;
	bh=Bnz3mERIuVhvUcIAiN6LhvDIneBmeXeacaBMKJscMR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=isjTKAN49xLaKoHwsaq4HEaCPRizTLZGzwh6D9ZAsUHGfNc5VhGbeJhOTinEEca9lj1Ey8oXy+StDNQhU7FFk81RlJoABFgfM/crILzE+Obk6+xoIow4jRdgGIsbOu9vqepaPegXHak7QDdepw3slNGZynJMTUJ6TD4QSD8Adqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6nNLaS2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6nNLaS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A14C4CEF8;
	Tue, 15 Jul 2025 13:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585846;
	bh=Bnz3mERIuVhvUcIAiN6LhvDIneBmeXeacaBMKJscMR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6nNLaS28VoTNySIK1czAQ0x6FP5zTRCOWaz7xX3BycS+HKf+0Ji31VDIBLk3Lw2A
	 Q8SvjkPaEhqa9Kv+dwuKpW3/KfYSbD+j7hlWZwjHJaXsJKhDVKrfQIAzrt31UpNI0g
	 7OqYQYiJFr17Xwv4Eer8A6iqGShY4fa2mkz20gXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Ian Rogers <irogers@google.com>,
	amadio@gentoo.org,
	Thomas Richter <tmricht@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: [PATCH 6.6 029/109] perf: build: Setup PKG_CONFIG_LIBDIR for cross compilation
Date: Tue, 15 Jul 2025 15:12:45 +0200
Message-ID: <20250715130800.050584569@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

commit 440cf77625e300e683ca0edc39fbc4b6f3175feb upstream.

On recent Linux distros like Ubuntu Noble and Debian Bookworm, the
'pkg-config-aarch64-linux-gnu' package is missing. As a result, the
aarch64-linux-gnu-pkg-config command is not available, which causes
build failures.

When a build passes the environment variables PKG_CONFIG_LIBDIR or
PKG_CONFIG_PATH, like a user uses make command or a build system
(like Yocto, Buildroot, etc) prepares the variables and passes to the
Perf's Makefile, the commit keeps these variables for package
configuration. Otherwise, this commit sets the PKG_CONFIG_LIBDIR
variable to use the Multiarch libs for the cross compilation.

Signed-off-by: Leo Yan <leo.yan@arm.com>
Tested-by: Ian Rogers <irogers@google.com>
Cc: amadio@gentoo.org
Cc: Thomas Richter <tmricht@linux.ibm.com>
Link: https://lore.kernel.org/r/20240717082211.524826-2-leo.yan@arm.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexis Lothoré <alexis.lothore@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/build/feature/Makefile |   25 ++++++++++++++++++++++++-
 tools/perf/Makefile.perf     |   27 ++++++++++++++++++++++++++-
 2 files changed, 50 insertions(+), 2 deletions(-)

--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -80,7 +80,30 @@ FILES=
 
 FILES := $(addprefix $(OUTPUT),$(FILES))
 
-PKG_CONFIG ?= $(CROSS_COMPILE)pkg-config
+# Some distros provide the command $(CROSS_COMPILE)pkg-config for
+# searching packges installed with Multiarch. Use it for cross
+# compilation if it is existed.
+ifneq (, $(shell which $(CROSS_COMPILE)pkg-config))
+  PKG_CONFIG ?= $(CROSS_COMPILE)pkg-config
+else
+  PKG_CONFIG ?= pkg-config
+
+  # PKG_CONFIG_PATH or PKG_CONFIG_LIBDIR, alongside PKG_CONFIG_SYSROOT_DIR
+  # for modified system root, are required for the cross compilation.
+  # If these PKG_CONFIG environment variables are not set, Multiarch library
+  # paths are used instead.
+  ifdef CROSS_COMPILE
+    ifeq ($(PKG_CONFIG_LIBDIR)$(PKG_CONFIG_PATH)$(PKG_CONFIG_SYSROOT_DIR),)
+      CROSS_ARCH = $(shell $(CC) -dumpmachine)
+      PKG_CONFIG_LIBDIR := /usr/local/$(CROSS_ARCH)/lib/pkgconfig/
+      PKG_CONFIG_LIBDIR := $(PKG_CONFIG_LIBDIR):/usr/local/lib/$(CROSS_ARCH)/pkgconfig/
+      PKG_CONFIG_LIBDIR := $(PKG_CONFIG_LIBDIR):/usr/lib/$(CROSS_ARCH)/pkgconfig/
+      PKG_CONFIG_LIBDIR := $(PKG_CONFIG_LIBDIR):/usr/local/share/pkgconfig/
+      PKG_CONFIG_LIBDIR := $(PKG_CONFIG_LIBDIR):/usr/share/pkgconfig/
+      export PKG_CONFIG_LIBDIR
+    endif
+  endif
+endif
 
 all: $(FILES)
 
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -188,7 +188,32 @@ HOSTLD  ?= ld
 HOSTAR  ?= ar
 CLANG   ?= clang
 
-PKG_CONFIG = $(CROSS_COMPILE)pkg-config
+# Some distros provide the command $(CROSS_COMPILE)pkg-config for
+# searching packges installed with Multiarch. Use it for cross
+# compilation if it is existed.
+ifneq (, $(shell which $(CROSS_COMPILE)pkg-config))
+  PKG_CONFIG ?= $(CROSS_COMPILE)pkg-config
+else
+  PKG_CONFIG ?= pkg-config
+
+  # PKG_CONFIG_PATH or PKG_CONFIG_LIBDIR, alongside PKG_CONFIG_SYSROOT_DIR
+  # for modified system root, is required for the cross compilation.
+  # If these PKG_CONFIG environment variables are not set, Multiarch library
+  # paths are used instead.
+  ifdef CROSS_COMPILE
+    ifeq ($(PKG_CONFIG_LIBDIR)$(PKG_CONFIG_PATH)$(PKG_CONFIG_SYSROOT_DIR),)
+      CROSS_ARCH = $(shell $(CC) -dumpmachine)
+      PKG_CONFIG_LIBDIR := /usr/local/$(CROSS_ARCH)/lib/pkgconfig/
+      PKG_CONFIG_LIBDIR := $(PKG_CONFIG_LIBDIR):/usr/local/lib/$(CROSS_ARCH)/pkgconfig/
+      PKG_CONFIG_LIBDIR := $(PKG_CONFIG_LIBDIR):/usr/lib/$(CROSS_ARCH)/pkgconfig/
+      PKG_CONFIG_LIBDIR := $(PKG_CONFIG_LIBDIR):/usr/local/share/pkgconfig/
+      PKG_CONFIG_LIBDIR := $(PKG_CONFIG_LIBDIR):/usr/share/pkgconfig/
+      export PKG_CONFIG_LIBDIR
+      $(warning Missing PKG_CONFIG_LIBDIR, PKG_CONFIG_PATH and PKG_CONFIG_SYSROOT_DIR for cross compilation,)
+      $(warning set PKG_CONFIG_LIBDIR for using Multiarch libs.)
+    endif
+  endif
+endif
 
 RM      = rm -f
 LN      = ln -f


