Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C791B3721;
	Thu,  6 Jun 2024 14:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683416; cv=none; b=nKcxZnaZ3s0Z3x5ZB0uASTn6MEoVIxRwLVNs8jZ4uDCxtScslxf4ZPVdTeZbx94jNPIun5pwJsTcB/siJG160HzuLpE1QGFNZGIip5cgf+M0/tg7aURae/HK5EVdl+JFput57K9UehiLB8zeVtis7BnNaOWW67nqT4kZcdClFKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683416; c=relaxed/simple;
	bh=YP+HriUesQzXRckLBcH9b7xYLXmtq8kxSYQiOsI8cSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOpjcRmnb+Ik+MPq+oEfvatHy71g5380HvmqjBIYavhu/lZcg4XEw0bhcupYih45UGyJhUmjzCFaHYKhfEwHv+Dr03ZpVs8qf5GoTcS0hxvTrd3poyzHdxTfEVvOPS20aWD4pWc/y/PGBf5znNE4Vruwz/Ikr86rEzhVkE5oVqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cNMlYmNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cNMlYmNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CBAC32781;
	Thu,  6 Jun 2024 14:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683416;
	bh=YP+HriUesQzXRckLBcH9b7xYLXmtq8kxSYQiOsI8cSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cNMlYmNSajMEgsRzynMiNPmVrzq9bA9AfWxlGsRqiBzWezKvXSr9f+Oz6l9Kp+Ppf
	 g7bV/SbgHXbJ3WvvxeiWG6ww6lh7qwHvB+r47cwo+OxCqvtdIEMkohqWVVwIRRxdlb
	 fSzi99FhP1y2VfdcEZ91EX2okxR6O4F6DyhGg/5w=
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
Subject: [PATCH 6.1 299/473] perf test: Add thloop test workload
Date: Thu,  6 Jun 2024 16:03:48 +0200
Message-ID: <20240606131709.798839939@linuxfoundation.org>
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

[ Upstream commit 69b352927885b17f03d3ee4ee38f580699af107a ]

The thloop is similar to noploop but runs in two threads.  This is
needed to verify perf record --per-thread to handle multi-threaded
programs properly.

  $ perf test -w thloop

It also takes an optional argument to specify runtime in seconds
(default: 1).

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
Link: https://lore.kernel.org/r/20221116233854.1596378-4-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 256ef072b384 ("perf tests: Make "test data symbol" more robust on Neoverse N1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/builtin-test.c     |  1 +
 tools/perf/tests/tests.h            |  1 +
 tools/perf/tests/workloads/Build    |  1 +
 tools/perf/tests/workloads/thloop.c | 53 +++++++++++++++++++++++++++++
 4 files changed, 56 insertions(+)
 create mode 100644 tools/perf/tests/workloads/thloop.c

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index ce641ccfcf814..161f38476e77b 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -120,6 +120,7 @@ static struct test_suite **tests[] = {
 
 static struct test_workload *workloads[] = {
 	&workload__noploop,
+	&workload__thloop,
 };
 
 static int num_subtests(const struct test_suite *t)
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index d315d0d6fc977..e6edfeeadaeba 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -201,5 +201,6 @@ struct test_workload workload__##work = {	\
 
 /* The list of test workloads */
 DECLARE_WORKLOAD(noploop);
+DECLARE_WORKLOAD(thloop);
 
 #endif /* TESTS_H */
diff --git a/tools/perf/tests/workloads/Build b/tools/perf/tests/workloads/Build
index f98e968d4633a..b8964b1099c0e 100644
--- a/tools/perf/tests/workloads/Build
+++ b/tools/perf/tests/workloads/Build
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 
 perf-y += noploop.o
+perf-y += thloop.o
diff --git a/tools/perf/tests/workloads/thloop.c b/tools/perf/tests/workloads/thloop.c
new file mode 100644
index 0000000000000..29193b75717ef
--- /dev/null
+++ b/tools/perf/tests/workloads/thloop.c
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <pthread.h>
+#include <stdlib.h>
+#include <signal.h>
+#include <unistd.h>
+#include <linux/compiler.h>
+#include "../tests.h"
+
+static volatile sig_atomic_t done;
+static volatile unsigned count;
+
+/* We want to check this symbol in perf report */
+noinline void test_loop(void);
+
+static void sighandler(int sig __maybe_unused)
+{
+	done = 1;
+}
+
+noinline void test_loop(void)
+{
+	while (!done)
+		count++;
+}
+
+static void *thfunc(void *arg)
+{
+	void (*loop_fn)(void) = arg;
+
+	loop_fn();
+	return NULL;
+}
+
+static int thloop(int argc, const char **argv)
+{
+	int sec = 1;
+	pthread_t th;
+
+	if (argc > 0)
+		sec = atoi(argv[0]);
+
+	signal(SIGINT, sighandler);
+	signal(SIGALRM, sighandler);
+	alarm(sec);
+
+	pthread_create(&th, NULL, thfunc, test_loop);
+	test_loop();
+	pthread_join(th, NULL);
+
+	return 0;
+}
+
+DEFINE_WORKLOAD(thloop);
-- 
2.43.0



