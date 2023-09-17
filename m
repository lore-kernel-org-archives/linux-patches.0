Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A90746E
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:58:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3733FC433C8;
	Sun, 17 Sep 2023 19:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980683;
	bh=3bPN4zzq1NNkyvAeaPF3oSmnaftj5DWe4UYoPAz0Eeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCXLVFOndMcUAn1wNGZOnY0koMItJYhd3PwhFtvdUlRlRc5swBrEWIzsKynEP5JaT
	 eLXlLQRAIuFbhe+xhWjdiPacSW8qSo3yVetEupMDDLiA257u8Rd75+b85qlEAwdwDm
	 SfJpdbnPdPCAVJaG6oCMZNoLn+FAUViIzIB1njPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Anup Sharma <anupnewsmail@gmail.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.5 236/285] perf build: Include generated header files properly
Date: Sun, 17 Sep 2023 21:13:56 +0200
Message-ID: <20230917191059.573361717@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

commit c7e97f215a4ad634b746804679f5937d25f77e29 upstream.

The flex and bison generate header files from the source.  When user
specified a build directory with O= option, it'd generate files under
the directory.  The build command has -I option to specify the header
include directory.

But the -I option only affects the files included like <...>.  Let's
change the flex and bison headers to use it instead of "...".

Fixes: 80eeb67fe577aa76 ("perf jevents: Program to convert JSON file")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anup Sharma <anupnewsmail@gmail.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230728022447.1323563-2-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/pmu-events/jevents.py |    2 +-
 tools/perf/util/bpf-filter.c     |    4 ++--
 tools/perf/util/expr.c           |    4 ++--
 tools/perf/util/parse-events.c   |    4 ++--
 tools/perf/util/pmu.c            |    4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

--- a/tools/perf/pmu-events/jevents.py
+++ b/tools/perf/pmu-events/jevents.py
@@ -999,7 +999,7 @@ such as "arm/cortex-a34".''',
   _args = ap.parse_args()
 
   _args.output_file.write("""
-#include "pmu-events/pmu-events.h"
+#include <pmu-events/pmu-events.h>
 #include "util/header.h"
 #include "util/pmu.h"
 #include <string.h>
--- a/tools/perf/util/bpf-filter.c
+++ b/tools/perf/util/bpf-filter.c
@@ -9,8 +9,8 @@
 #include "util/evsel.h"
 
 #include "util/bpf-filter.h"
-#include "util/bpf-filter-flex.h"
-#include "util/bpf-filter-bison.h"
+#include <util/bpf-filter-flex.h>
+#include <util/bpf-filter-bison.h>
 
 #include "bpf_skel/sample-filter.h"
 #include "bpf_skel/sample_filter.skel.h"
--- a/tools/perf/util/expr.c
+++ b/tools/perf/util/expr.c
@@ -10,8 +10,8 @@
 #include "debug.h"
 #include "evlist.h"
 #include "expr.h"
-#include "expr-bison.h"
-#include "expr-flex.h"
+#include <util/expr-bison.h>
+#include <util/expr-flex.h>
 #include "util/hashmap.h"
 #include "smt.h"
 #include "tsc.h"
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -18,8 +18,8 @@
 #include "debug.h"
 #include <api/fs/tracing_path.h>
 #include <perf/cpumap.h>
-#include "parse-events-bison.h"
-#include "parse-events-flex.h"
+#include <util/parse-events-bison.h>
+#include <util/parse-events-flex.h>
 #include "pmu.h"
 #include "pmus.h"
 #include "asm/bug.h"
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -19,8 +19,8 @@
 #include "evsel.h"
 #include "pmu.h"
 #include "pmus.h"
-#include "pmu-bison.h"
-#include "pmu-flex.h"
+#include <util/pmu-bison.h>
+#include <util/pmu-flex.h>
 #include "parse-events.h"
 #include "print-events.h"
 #include "header.h"


