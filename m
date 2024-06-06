Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F9B19FA9F;
	Thu,  6 Jun 2024 14:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683415; cv=none; b=JIA3W1bL26bnhkUsU0aBvoGLwzlSPohDTvrNlxBJQnbTkfpy0IaYlgkbEQ9EAt9pCOuTwNFm6EyzeF2B4a+BgXPgaxay55M0XQMUEzOonEFJ8lIK8+yRkgHKUYOwLr4m82tRlVRvWDsCRwCIre2yBTa6BfeEIbKZQX+VH+0JrpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683415; c=relaxed/simple;
	bh=1nhihlHXM0w+5YPPKpFi3s81ft/auojFWxKo7+nVbDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpmI1jlcJdvUVReHA3UAFxBh3TZGgnfk9I26gcU7BCZLdUnJjsMmLsAFSW0ZEN1TQX3hnGqe9hRMlJBnlU0l2dPTXVBNI8QhNqlxGoB8lNUd0kpnSSV56V0Lo7ZSW7Sav78LE158pS637XKThLjrS/WKm30vLdoybPN4VxurAHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBY/mzAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBY/mzAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDC6C32782;
	Thu,  6 Jun 2024 14:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683415;
	bh=1nhihlHXM0w+5YPPKpFi3s81ft/auojFWxKo7+nVbDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBY/mzAaNcR7Q4SgJ/PFpPafmPf63w8h1HRnIfS1f9q8uEOJjRqd7YwVu26FG6NaX
	 PgsfBBzeDBj4HJSP5w77lEgH57Xzb4MiZZVxiIE8EhNjHrdxYjRIz0NIMfnQiIQ0z+
	 sbwVG4TtI/ILhGyxyqw7VBghC5ppkTgrYK/9mkxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
	German Gomez <german.gomez@arm.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Leo Yan <leo.yan@linaro.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Zhengjun Xing <zhengjun.xing@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 298/473] perf test: Add -w/--workload option
Date: Thu,  6 Jun 2024 16:03:47 +0200
Message-ID: <20240606131709.760199357@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit f215054d749b17c56e014fdca2fcc592dac4529c ]

The -w/--workload option is to run a simple workload used by testing.
This adds a basic framework to run the workloads and 'noploop' workload
as an example.

  $ perf test -w noploop

The noploop does a loop doing nothing (NOP) for a second by default.
It can have an optional argument to specify the time in seconds.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Cc: German Gomez <german.gomez@arm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Zhengjun Xing <zhengjun.xing@linux.intel.com>
Link: https://lore.kernel.org/r/20221116233854.1596378-2-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 256ef072b384 ("perf tests: Make "test data symbol" more robust on Neoverse N1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/Build               |  2 ++
 tools/perf/tests/builtin-test.c      | 24 +++++++++++++++++++++
 tools/perf/tests/tests.h             | 22 +++++++++++++++++++
 tools/perf/tests/workloads/Build     |  3 +++
 tools/perf/tests/workloads/noploop.c | 32 ++++++++++++++++++++++++++++
 5 files changed, 83 insertions(+)
 create mode 100644 tools/perf/tests/workloads/Build
 create mode 100644 tools/perf/tests/workloads/noploop.c

diff --git a/tools/perf/tests/Build b/tools/perf/tests/Build
index 2064a640facbe..11b69023011b0 100644
--- a/tools/perf/tests/Build
+++ b/tools/perf/tests/Build
@@ -103,3 +103,5 @@ endif
 CFLAGS_attr.o         += -DBINDIR="BUILD_STR($(bindir_SQ))" -DPYTHON="BUILD_STR($(PYTHON_WORD))"
 CFLAGS_python-use.o   += -DPYTHONPATH="BUILD_STR($(OUTPUT)python)" -DPYTHON="BUILD_STR($(PYTHON_WORD))"
 CFLAGS_dwarf-unwind.o += -fno-optimize-sibling-calls
+
+perf-y += workloads/
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 7122eae1d98d9..ce641ccfcf814 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -118,6 +118,10 @@ static struct test_suite **tests[] = {
 	arch_tests,
 };
 
+static struct test_workload *workloads[] = {
+	&workload__noploop,
+};
+
 static int num_subtests(const struct test_suite *t)
 {
 	int num;
@@ -475,6 +479,21 @@ static int perf_test__list(int argc, const char **argv)
 	return 0;
 }
 
+static int run_workload(const char *work, int argc, const char **argv)
+{
+	unsigned int i = 0;
+	struct test_workload *twl;
+
+	for (i = 0; i < ARRAY_SIZE(workloads); i++) {
+		twl = workloads[i];
+		if (!strcmp(twl->name, work))
+			return twl->func(argc, argv);
+	}
+
+	pr_info("No workload found: %s\n", work);
+	return -1;
+}
+
 int cmd_test(int argc, const char **argv)
 {
 	const char *test_usage[] = {
@@ -482,12 +501,14 @@ int cmd_test(int argc, const char **argv)
 	NULL,
 	};
 	const char *skip = NULL;
+	const char *workload = NULL;
 	const struct option test_options[] = {
 	OPT_STRING('s', "skip", &skip, "tests", "tests to skip"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('F', "dont-fork", &dont_fork,
 		    "Do not fork for testcase"),
+	OPT_STRING('w', "workload", &workload, "work", "workload to run for testing"),
 	OPT_END()
 	};
 	const char * const test_subcommands[] = { "list", NULL };
@@ -504,6 +525,9 @@ int cmd_test(int argc, const char **argv)
 	if (argc >= 1 && !strcmp(argv[0], "list"))
 		return perf_test__list(argc - 1, argv + 1);
 
+	if (workload)
+		return run_workload(workload, argc, argv);
+
 	symbol_conf.priv_size = sizeof(int);
 	symbol_conf.sort_by_name = true;
 	symbol_conf.try_vmlinux_path = true;
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 5bbb8f6a48fcb..d315d0d6fc977 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -180,4 +180,26 @@ int test__arch_unwind_sample(struct perf_sample *sample,
 DECLARE_SUITE(vectors_page);
 #endif
 
+/*
+ * Define test workloads to be used in test suites.
+ */
+typedef int (*workload_fnptr)(int argc, const char **argv);
+
+struct test_workload {
+	const char	*name;
+	workload_fnptr	func;
+};
+
+#define DECLARE_WORKLOAD(work) \
+	extern struct test_workload workload__##work
+
+#define DEFINE_WORKLOAD(work) \
+struct test_workload workload__##work = {	\
+	.name = #work,				\
+	.func = work,				\
+}
+
+/* The list of test workloads */
+DECLARE_WORKLOAD(noploop);
+
 #endif /* TESTS_H */
diff --git a/tools/perf/tests/workloads/Build b/tools/perf/tests/workloads/Build
new file mode 100644
index 0000000000000..f98e968d4633a
--- /dev/null
+++ b/tools/perf/tests/workloads/Build
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+perf-y += noploop.o
diff --git a/tools/perf/tests/workloads/noploop.c b/tools/perf/tests/workloads/noploop.c
new file mode 100644
index 0000000000000..940ea5910a84c
--- /dev/null
+++ b/tools/perf/tests/workloads/noploop.c
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <stdlib.h>
+#include <signal.h>
+#include <unistd.h>
+#include <linux/compiler.h>
+#include "../tests.h"
+
+static volatile sig_atomic_t done;
+
+static void sighandler(int sig __maybe_unused)
+{
+	done = 1;
+}
+
+static int noploop(int argc, const char **argv)
+{
+	int sec = 1;
+
+	if (argc > 0)
+		sec = atoi(argv[0]);
+
+	signal(SIGINT, sighandler);
+	signal(SIGALRM, sighandler);
+	alarm(sec);
+
+	while (!done)
+		continue;
+
+	return 0;
+}
+
+DEFINE_WORKLOAD(noploop);
-- 
2.43.0



