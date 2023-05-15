Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202DFFBF0;
	Mon, 15 May 2023 16:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C56CC433EF;
	Mon, 15 May 2023 16:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169571;
	bh=oGbSyybgHOiv+yB1HSOexqXpS711Yac1vMP33T06qQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kl8SwcAsHfNFr8WWeUaSPyte9sTxgdd12aXeQ2JoTY8Ji0kmUcoDyo7/5e2GI+pSl
	 LPZbwW+zxFW1bbhZSoz770AZ+915IoR5FIIOb9z+xCAEupiM/ieL2qbx3DJ+nC77GF
	 EahAo1OIIUCTNqBdfLu+3nI1Htw06McXwrPlo3rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andres Freund <andres@anarazel.de>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Leo Yan <leo.yan@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	=?UTF-8?q?Martin=20Li=C5=A1ka?= <mliska@suse.cz>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Pavithra Gurushankar <gpavithrasha@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Quentin Monnet <quentin@isovalent.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Stephane Eranian <eranian@google.com>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Tom Rix <trix@redhat.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	llvm@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 101/246] perf build: Support python/perf.so testing
Date: Mon, 15 May 2023 18:25:13 +0200
Message-Id: <20230515161725.613015792@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ian Rogers <irogers@google.com>

[ Upstream commit 7a9b223ca0761a7c7c72e569b86b84a907aa0f92 ]

Add a build target to echo the python/perf.so's name from
Makefile.perf. Use it in tests/make so the correct target is built and
tested for.

Fixes: caec54705adb73b0 ("perf build: Fix python/perf.so library's name")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andres Freund <andres@anarazel.de>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Martin Liška <mliska@suse.cz>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Pavithra Gurushankar <gpavithrasha@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Quentin Monnet <quentin@isovalent.com>
Cc: Roberto Sassu <roberto.sassu@huawei.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Tom Rix <trix@redhat.com>
Cc: Yang Jihong <yangjihong1@huawei.com>
Cc: llvm@lists.linux.dev
Link: https://lore.kernel.org/r/20230311065753.3012826-2-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.perf | 7 +++++--
 tools/perf/tests/make    | 5 +++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index bac9272682b75..2fcee585b225d 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -647,13 +647,16 @@ all: shell_compatibility_test $(ALL_PROGRAMS) $(LANG_BINDINGS) $(OTHER_PROGRAMS)
 # Create python binding output directory if not already present
 _dummy := $(shell [ -d '$(OUTPUT)python' ] || mkdir -p '$(OUTPUT)python')
 
-$(OUTPUT)python/perf$(PYTHON_EXTENSION_SUFFIX): $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS) $(LIBPERF)
+$(OUTPUT)python/perf$(PYTHON_EXTENSION_SUFFIX): $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS) $(LIBPERF) $(LIBSUBCMD)
 	$(QUIET_GEN)LDSHARED="$(CC) -pthread -shared" \
         CFLAGS='$(CFLAGS)' LDFLAGS='$(LDFLAGS)' \
 	  $(PYTHON_WORD) util/setup.py \
 	  --quiet build_ext; \
 	cp $(PYTHON_EXTBUILD_LIB)perf*.so $(OUTPUT)python/
 
+python_perf_target:
+	@echo "Target is: $(OUTPUT)python/perf$(PYTHON_EXTENSION_SUFFIX)"
+
 please_set_SHELL_PATH_to_a_more_modern_shell:
 	$(Q)$$(:)
 
@@ -1152,7 +1155,7 @@ FORCE:
 .PHONY: all install clean config-clean strip install-gtk
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
 .PHONY: .FORCE-PERF-VERSION-FILE TAGS tags cscope FORCE prepare
-.PHONY: archheaders
+.PHONY: archheaders python_perf_target
 
 endif # force_fixdep
 
diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 009d6efb673ce..deb37fb982e97 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -62,10 +62,11 @@ lib = lib
 endif
 
 has = $(shell which $1 2>/dev/null)
+python_perf_so := $(shell $(MAKE) python_perf_target|grep "Target is:"|awk '{print $$3}')
 
 # standard single make variable specified
 make_clean_all      := clean all
-make_python_perf_so := python/perf.so
+make_python_perf_so := $(python_perf_so)
 make_debug          := DEBUG=1
 make_no_libperl     := NO_LIBPERL=1
 make_no_libpython   := NO_LIBPYTHON=1
@@ -204,7 +205,7 @@ test_make_doc    := $(test_ok)
 test_make_help_O := $(test_ok)
 test_make_doc_O  := $(test_ok)
 
-test_make_python_perf_so := test -f $(PERF_O)/python/perf.so
+test_make_python_perf_so := test -f $(PERF_O)/$(python_perf_so)
 
 test_make_perf_o           := test -f $(PERF_O)/perf.o
 test_make_util_map_o       := test -f $(PERF_O)/util/map.o
-- 
2.39.2



