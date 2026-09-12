Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C362DBF75;
	Sat, 12 Sep 2026 12:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214632; cv=none; b=qzd1XbCzgGSwPbpR2f1NgvUfbFstOsWH65t8uaTSJ6taVwX7DwlpJmkXvPHD10iRDmDci/5tXDcb8mR4xnJ2XeNyyYANWLFFx4vcWvSD2TDF+mx2xI7+GuokjjEB8rZbAdw1BITvtNRYS41U/9f31uv7Z7tnNkgK6/FUuyIGqgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214632; c=relaxed/simple;
	bh=G/Xs9a2x0nYlbJ7ua03fhjcRVwZ2rJEz1Ms0R8++XGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoshlqjoooLN8N3uMZSk+JpJwi+gZci3Ywf0WbDfzFGushxU0oxzS43JOkPIj7vCfopKQQUrOi3Fiqzeec1nECnezOqMd5Hiahbta9KJMz844DUifF0eSpnoB+C344o7WuRcDg/RYqJUaWNxNZZYhgFEwqSugNq3ozbPC2w3/Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ceZ2Ttce; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ceZ2Ttce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F39D1F000FF;
	Sat, 12 Sep 2026 12:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214631;
	bh=5LhnkvAh89M62aPlB4w/VL1WsMZ0LRjR8GsC3h0dbGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ceZ2TtceA4UOr5WMkflWItDUInOWk6eliYnJCYNjFpB/+X4Fe4Cx8a6uoj7SjbamN
	 FAMV0+477yDRNTJ+ZSTU6Ze74/Z8oOYAEjm2g9x0XhJ66g8BtCcEyWJpkiD069uuqJ
	 T1hI9uk1gF88DAFQBNV5AKOp0LSPErSYLD3VTJaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	German Gomez <german.gomez@arm.com>,
	James Clark <james.clark@linaro.org>,
	Adam Young <admiyo@os.amperecomputing.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Rob Herring <robh@kernel.org>,
	Will Deacon <will@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0365/1376] perf test: Extend branch stack sampling test for Arm64 BRBE
Date: Sat, 12 Sep 2026 08:46:31 +0200
Message-ID: <20260912065615.685593516@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@linaro.org>

[ Upstream commit 9f0fa213790e3633d37e981386da99149573135b ]

BRBE emits IRQ and ERET branches for branching and returning from
trapped instructions. Add a test that loops on a trapped instruction
(MRS - Read special register) for this.

Extend the expected 'any_call' branches to include FAULT_DATA and
FAULT_INST as these are emitted by BRBE.

Reviewed-by: Ian Rogers <irogers@google.com>
Co-developed-by: German Gomez <german.gomez@arm.com>
Signed-off-by: German Gomez <german.gomez@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Cc: Adam Young <admiyo@os.amperecomputing.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 344d3aec164d ("perf tests: Fix flakiness in branch stack sampling tests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/builtin-test.c        |  1 +
 tools/perf/tests/shell/test_brstack.sh | 26 ++++++++++++++++++++-
 tools/perf/tests/tests.h               |  1 +
 tools/perf/tests/workloads/Build       |  2 ++
 tools/perf/tests/workloads/traploop.c  | 31 ++++++++++++++++++++++++++
 5 files changed, 60 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/tests/workloads/traploop.c

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 470a9709427dd..3aa4ab160947d 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -153,6 +153,7 @@ static struct test_workload *workloads[] = {
 	&workload__brstack,
 	&workload__datasym,
 	&workload__landlock,
+	&workload__traploop,
 };
 
 static int num_subtests(const struct test_suite *t)
diff --git a/tools/perf/tests/shell/test_brstack.sh b/tools/perf/tests/shell/test_brstack.sh
index 252d22d39c7b0..85233d435be63 100755
--- a/tools/perf/tests/shell/test_brstack.sh
+++ b/tools/perf/tests/shell/test_brstack.sh
@@ -34,6 +34,10 @@ trap_cleanup() {
 }
 trap trap_cleanup EXIT TERM INT
 
+is_arm64() {
+	[ "$(uname -m)" = "aarch64" ];
+}
+
 check_branches() {
 	if ! tr -s ' ' '\n' < "$TMPDIR/perf.script" | grep -E -m1 -q "$1"; then
 		echo "Branches missing $1"
@@ -76,9 +80,24 @@ test_user_branches() {
 		err=1
 	fi
 	# some branch types are still not being tested:
-	# IND COND_CALL COND_RET SYSRET IRQ SERROR NO_TX
+	# IND COND_CALL COND_RET SYSRET SERROR NO_TX
 }
 
+test_trap_eret_branches() {
+	echo "Testing trap & eret branches"
+	if ! is_arm64; then
+		echo "skip: not arm64"
+	else
+		perf record -o $TMPDIR/perf.data --branch-filter any,save_type,u,k -- \
+			perf test -w traploop 1000
+		perf script -i $TMPDIR/perf.data --fields brstacksym | \
+			tr ' ' '\n' > $TMPDIR/perf.script
+
+		# BRBINF<n>.TYPE == TRAP are mapped to PERF_BR_IRQ by the BRBE driver
+		check_branches "^trap_bench\+[^ ]+/[^ ]/IRQ/"
+		check_branches "^[^ ]+/trap_bench\+[^ ]+/ERET/"
+	fi
+}
 
 test_kernel_branches() {
 	echo "Testing that k option only includes kernel source addresses"
@@ -162,9 +181,14 @@ set -e
 test_user_branches
 test_syscall
 test_kernel_branches
+test_trap_eret_branches
 
 any_call="CALL|IND_CALL|COND_CALL|SYSCALL|IRQ"
 
+if is_arm64; then
+	any_call="$any_call|FAULT_DATA|FAULT_INST"
+fi
+
 test_filter "any_call" "$any_call"
 test_filter "call"	"CALL|SYSCALL"
 test_filter "cond"	"COND"
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 6ea2be86b7bf8..6d8e46ab82335 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -206,6 +206,7 @@ DECLARE_WORKLOAD(sqrtloop);
 DECLARE_WORKLOAD(brstack);
 DECLARE_WORKLOAD(datasym);
 DECLARE_WORKLOAD(landlock);
+DECLARE_WORKLOAD(traploop);
 
 extern const char *dso_to_test;
 extern const char *test_objdump_path;
diff --git a/tools/perf/tests/workloads/Build b/tools/perf/tests/workloads/Build
index 5af17206f04d1..fb1012cc4fc31 100644
--- a/tools/perf/tests/workloads/Build
+++ b/tools/perf/tests/workloads/Build
@@ -7,8 +7,10 @@ perf-test-y += sqrtloop.o
 perf-test-y += brstack.o
 perf-test-y += datasym.o
 perf-test-y += landlock.o
+perf-test-y += traploop.o
 
 CFLAGS_sqrtloop.o         = -g -O0 -fno-inline -U_FORTIFY_SOURCE
 CFLAGS_leafloop.o         = -g -O0 -fno-inline -fno-omit-frame-pointer -U_FORTIFY_SOURCE
 CFLAGS_brstack.o          = -g -O0 -fno-inline -U_FORTIFY_SOURCE
 CFLAGS_datasym.o          = -g -O0 -fno-inline -U_FORTIFY_SOURCE
+CFLAGS_traploop.o         = -g -O0 -fno-inline -U_FORTIFY_SOURCE
diff --git a/tools/perf/tests/workloads/traploop.c b/tools/perf/tests/workloads/traploop.c
new file mode 100644
index 0000000000000..68dec399a7350
--- /dev/null
+++ b/tools/perf/tests/workloads/traploop.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdlib.h>
+#include "../tests.h"
+
+#define BENCH_RUNS 999999
+
+#ifdef __aarch64__
+static void trap_bench(void)
+{
+	unsigned long val;
+
+	asm("mrs %0, ID_AA64ISAR0_EL1" : "=r" (val));   /* TRAP + ERET */
+}
+#else
+static void trap_bench(void) { }
+#endif
+
+static int traploop(int argc, const char **argv)
+{
+	int num_loops = BENCH_RUNS;
+
+	if (argc > 0)
+		num_loops = atoi(argv[0]);
+
+	for (int i = 0; i < num_loops; i++)
+		trap_bench();
+
+	return 0;
+}
+
+DEFINE_WORKLOAD(traploop);
-- 
2.53.0



