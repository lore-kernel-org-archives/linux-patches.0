Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3DA2EE611;
	Tue, 16 Jun 2026 18:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632894; cv=none; b=qqhCy3mwEnQ/lUIKic8lHOJ94iN34J0+ovFsw5gw0Ip2+xIID11n9x6PhfVmoCH91UppROMWYNqgKeseo7e5GAVt7YYLzY52xZgsbge5JYvcj42MBs/Sd1ERyV8peSQ7Gj3q7bzTlfqJB1HUTGjBfDQAtVMgkW39bfOLRQ65rJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632894; c=relaxed/simple;
	bh=Rh8nKcgdnwf9t3DsidtN0bAyWENvMiSUFEEcHHTukbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtoZx4kXrtvoE2fEcig31FApKGeSqFliOpNkonQ7pPJ6+f26Eb7lObIQFsl5FQuScpv28qBsTSb0DZKleFRX3l7O40kn9otjk/ccn0IKMGZvwXyffMLQy6K2oObYwldb6KN7spVk8FaURhJqYMNzVbgwO1cznCdAUdpUKWPfJ80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpMw7hEu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpMw7hEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2691F000E9;
	Tue, 16 Jun 2026 18:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632893;
	bh=sUn2R5LRQvaL9lVGtiTUVPir0w6SZIZxrCr0UsYyKgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kpMw7hEuD1MINp/wPuSnzXCr76iJ7ZjN9E8saiGHvFerZSZ9nBXRvtBp+2Fi+0LrZ
	 39qlUlZTEcMK10VyzUepts9m0Ym+nnT0WQ4Y6C2CLcJ0NNGDiLny40vEouxko6+hR/
	 XXXxcUiMjNvQWzDQO+hdbwC41TeKJEx6PvX/lTcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Rob Herring <robh@kernel.org>,
	Tom Rix <trix@redhat.com>,
	bpf@vger.kernel.org,
	llvm@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 6.1 497/522] perf build: Disable fewer bison warnings
Date: Tue, 16 Jun 2026 20:30:44 +0530
Message-ID: <20260616145149.028589020@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

commit ddc8e4c966923ad1137790817157c8a5f0301aec upstream

If bison is version 3.8.2, reduce the number of bison C warnings
disabled. Earlier bison versions have all C warnings disabled. Avoid
implicit declarations of yylex by adding the declaration in the C
file. A header can't be included as a circular dependency would occur
due to the lexer using the bison defined tokens.

Committer notes:

Some recent versions of gcc and clang (noticed on Alpine Linux 3.17,
edge, clearlinux, fedora 37, etc.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Gaosheng Cui <cuigaosheng1@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Tom Rix <trix@redhat.com>
Cc: bpf@vger.kernel.org
Cc: llvm@lists.linux.dev
Link: https://lore.kernel.org/r/20230728064917.767761-6-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[florian: Remove non-existent tools/perf/util/bpf-filter.y in 6.1.y]
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Change-Id: I62327ddbe816008197053a9234a92d9c253a2c5d
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/Build          |   12 ++++++++----
 tools/perf/util/expr.y         |    4 +++-
 tools/perf/util/parse-events.y |    1 +
 tools/perf/util/pmu.y          |    3 +++
 4 files changed, 15 insertions(+), 5 deletions(-)

--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -269,10 +269,14 @@ CFLAGS_parse-events-flex.o  += $(flex_fl
 CFLAGS_pmu-flex.o           += $(flex_flags)
 CFLAGS_expr-flex.o          += $(flex_flags)
 
-bison_flags := -DYYENABLE_NLS=0
-BISON_GE_35 := $(shell expr $(shell $(BISON) --version | grep bison | sed -e 's/.\+ \([0-9]\+\).\([0-9]\+\)/\1\2/g') \>\= 35)
-ifeq ($(BISON_GE_35),1)
-  bison_flags += -Wno-unused-parameter -Wno-nested-externs -Wno-implicit-function-declaration -Wno-switch-enum -Wno-unused-but-set-variable -Wno-unknown-warning-option
+# Some newer clang and gcc version complain about this
+# util/parse-events-bison.c:1317:9: error: variable 'parse_events_nerrs' set but not used [-Werror,-Wunused-but-set-variable]
+#  int yynerrs = 0;
+
+bison_flags := -DYYENABLE_NLS=0 -Wno-unused-but-set-variable
+BISON_GE_382 := $(shell expr $(shell $(BISON) --version | grep bison | sed -e 's/.\+ \([0-9]\+\).\([0-9]\+\).\([0-9]\+\)/\1\2\3/g') \>\= 382)
+ifeq ($(BISON_GE_382),1)
+  bison_flags += -Wno-switch-enum
 else
   bison_flags += -w
 endif
--- a/tools/perf/util/expr.y
+++ b/tools/perf/util/expr.y
@@ -7,6 +7,8 @@
 #include "util/debug.h"
 #define IN_EXPR_Y 1
 #include "expr.h"
+#include "expr-bison.h"
+int expr_lex(YYSTYPE * yylval_param , void *yyscanner);
 %}
 
 %define api.pure full
@@ -56,7 +58,7 @@
 static void expr_error(double *final_val __maybe_unused,
 		       struct expr_parse_ctx *ctx __maybe_unused,
 		       bool compute_ids __maybe_unused,
-		       void *scanner,
+		       void *scanner __maybe_unused,
 		       const char *s)
 {
 	pr_debug("%s\n", s);
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -20,6 +20,7 @@
 #include "parse-events.h"
 #include "parse-events-bison.h"
 
+int parse_events_lex(YYSTYPE * yylval_param, YYLTYPE * yylloc_param , void *yyscanner);
 void parse_events_error(YYLTYPE *loc, void *parse_state, void *scanner, char const *msg);
 
 #define ABORT_ON(val) \
--- a/tools/perf/util/pmu.y
+++ b/tools/perf/util/pmu.y
@@ -9,6 +9,9 @@
 #include <linux/bitmap.h>
 #include <string.h>
 #include "pmu.h"
+#include "pmu-bison.h"
+
+int perf_pmu_lex(void);
 
 #define ABORT_ON(val) \
 do { \


