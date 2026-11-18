Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025220;
	b=um3aj0Ea7wZGyrC/G/7ocE/TN1oc9XFDfcuj47MyVDVSVVttp9r/1BPVBhfHOP0wIBE7
	 8WpwYSpLRwKlO9htNN7FQBj3aq0QBGjPHHgUUmE1B/B5/Jk8fEn4kPee0OXESkm52mr6P
	 4Eb4D24a0/dX+ZrY7GNm0hl88NaiDyn41nahRj0Lp7RgF3jr2th6CimqxcsLhGiAH0Qoi
	 VrVpMg6CC9As654NMmQjKBRe0kz0Pfxi6ADba55qVx0umcb/RfgzyZy+8PjUEXEqcQluq
	 BcD6zfoPFXCDA3VtwtS/s+THmjO9flQjAR9cwbOpTrzJPQPvTO9fLI+A6Df4pOmXtWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025220;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ckDc9Kk97eI7Ega2ntviEBIEHYKZJfLK99n7RjFWAsQ=;
	b=nbvQWe4UoJDu6RLwaYlHxi/gICO1KTQuQmalNYjmpPkt4oiyd6KwsoGU6KszSnpYrGwV
	 V+BX57XvxRAiJbBzFpBDPwXre2y0vZVpZT4/lWd5BowTN+KR/w4DI1mROGqvF2wvRZ7fx
	 Xg5gKgkNESbjrfnsQ2a0v5ShVmWKYdVW7JsJY63goqoBv2/DZ1Bp9CLizrS41d6oWXTCD
	 oHPhaUp3W/r+pvUolxzPKaAMLy5pjYyUVkeCddpAZgTK6u5EZxM8BjpqlXqFWFucgjZ/j
	 UKldy0fesxuU8Zw/vbAsBQAZFwrGHUi3UHn+7KqB5nsQMr7Lx/nhGtPiARGtkXtCu2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XTTrGgvK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01255606A331;
	Wed, 18 Nov 2026 18:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XTTrGgvK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9DA1F000C4;
	Wed, 18 Nov 2026 18:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025219;
	bh=ckDc9Kk97eI7Ega2ntviEBIEHYKZJfLK99n7RjFWAsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XTTrGgvKdECharqfwUZ0UtW+Ku5ZOI6LhenQSfOfRTMKMKRIv0Oy0+3gHgbyBxUTY
	 KboPbwoDlNVIqNTalt1azcbSYzQyLCfhsKuaVdrge3UIeE1MKWLYAQsFL3Fo11Av1p
	 4vRWTHSplbOfRNMuiHpYOs7km8pqHgkEjfDI14DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Jens Remus <jremus@linux.ibm.com>,
	Jan Polensky <japo@linux.ibm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0975/2151] perf build: Respect V=1 for Python extension builds
Date: Wed, 18 Nov 2026 15:45:10 +0100
Message-ID: <20261118150158.012630759@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Remus <jremus@linux.ibm.com>

[ Upstream commit 41c1ce28bbc1d4f7a1b1b711b86448480d2838d2 ]

Make util/setup.py respect the verbose build flag (V=1) by conditionally
passing --quiet only when not in verbose mode.

This eases debugging of Python extension compilation issues and aligns
with the existing perf build system behavior.

Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
Tested-by: Jan Polensky <japo@linux.ibm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 2ed38aa8a52d ("perf python: Track linked libraries as extension dependencies")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.perf | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 841c00c847b0a..5e87527c3d13a 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -396,6 +396,10 @@ export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
 
 python-clean := $(call QUIET_CLEAN, python) $(RM) -r $(PYTHON_EXTBUILD) $(OUTPUT)python/perf*.so
 
+ifneq ($(quiet),)
+python_setup_quiet=--quiet
+endif
+
 # Use the detected configuration
 -include $(OUTPUT).config-detected
 
@@ -741,7 +745,7 @@ $(OUTPUT)python/perf$(PYTHON_EXTENSION_SUFFIX): util/python.c util/setup.py $(PE
 	$(QUIET_GEN)LDSHARED="$(CC) -pthread -shared" \
         CFLAGS='$(CFLAGS)' LDFLAGS='$(LDFLAGS) $(LIBS_PY)' \
 	  $(PYTHON_WORD) util/setup.py \
-	  --quiet build_ext; \
+	  $(python_setup_quiet) build_ext; \
 	cp $(PYTHON_EXTBUILD_LIB)perf*.so $(OUTPUT)python/
 
 python_perf_target:
@@ -1166,7 +1170,7 @@ install-bin: install-tools install-tests
 install: install-bin try-install-man
 
 install-python_ext:
-	$(PYTHON_WORD) util/setup.py --quiet install --root='/$(DESTDIR_SQ)'
+	$(PYTHON_WORD) util/setup.py $(python_setup_quiet) install --root='/$(DESTDIR_SQ)'
 
 # 'make install-doc' should call 'make -C Documentation install'
 $(INSTALL_DOC_TARGETS):
-- 
2.53.0



