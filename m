Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C441B372F;
	Thu,  6 Jun 2024 14:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683419; cv=none; b=XT3bgIfqGMn5Nd6HNS2fJfYNxRB9P57V18bknCuSkTGQhsD7Edslo4l1S0Ze7U7TkR0i4o5IPNF+Ieeq7uOnDg/SXyrsuBFIxpzbwNIaEzFNwAuLPpyOMnMqkSuCNNe+DnakmQ5232tBQadzXAnyw+KQyCsKnNoiNQrm05QO0jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683419; c=relaxed/simple;
	bh=RFfKoTrviFOB8K3SdNiG0Q4IaW7yNO+5HNf2n1IQ+g0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbwO7027x/HBsjrUDrFMDhnAcFhHt8yeGb3OwQwUOWMHGGzNULXy7vyGTAmz4buX1e+jNuKJSBbjsMGvPjfc9l7i1PpMiiwJg780OsRYwzGrJempe9SkbzBXapBHwvAKrlaGzmxGTwz/nxFnKwuyvwwXKV5460mCQGfRayBAOW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xT+///D3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xT+///D3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AABF9C32781;
	Thu,  6 Jun 2024 14:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683419;
	bh=RFfKoTrviFOB8K3SdNiG0Q4IaW7yNO+5HNf2n1IQ+g0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xT+///D3SA+fkLF9CYF2PjzwYI58B6div/8zvpOpgP/88gcLEsbIoSb3uSJWTwpfx
	 +hN+4WXVM3cHArckH1oSq5rpa3/dm1kPnXNIH+fsifYiJRHcUzL97VrY/TU1SfPPQU
	 N3aYzesfZuAYGykgPvXEj8Kfn5jpAhExYQXHen8g=
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
Subject: [PATCH 6.1 302/473] perf test: Add brstack test workload
Date: Thu,  6 Jun 2024 16:03:51 +0200
Message-ID: <20240606131709.917855252@linuxfoundation.org>
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

[ Upstream commit a104f0ea99d846df19aad8a5476eb9bc39fa42ca ]

The brstack is to run different kinds of branches repeatedly.  This is
necessary for brstack test case to verify if it has correct branch info.

  $ perf test -w brstack

I renamed the internal functions to have brstack_ prefix as it's too
generic name.

Add a -U_FORTIFY_SOURCE to the brstack CFLAGS, as the main perf flags
set it and it requires building with optimization, and this new test has
a -O0.

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
Link: https://lore.kernel.org/r/20221116233854.1596378-10-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 256ef072b384 ("perf tests: Make "test data symbol" more robust on Neoverse N1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/builtin-test.c      |  1 +
 tools/perf/tests/tests.h             |  1 +
 tools/perf/tests/workloads/Build     |  2 ++
 tools/perf/tests/workloads/brstack.c | 40 ++++++++++++++++++++++++++++
 4 files changed, 44 insertions(+)
 create mode 100644 tools/perf/tests/workloads/brstack.c

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 9acb7a93eeb97..69fa56939309b 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -123,6 +123,7 @@ static struct test_workload *workloads[] = {
 	&workload__thloop,
 	&workload__leafloop,
 	&workload__sqrtloop,
+	&workload__brstack,
 };
 
 static int num_subtests(const struct test_suite *t)
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 18c40319e67c7..dc96f59cac2ef 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -204,5 +204,6 @@ DECLARE_WORKLOAD(noploop);
 DECLARE_WORKLOAD(thloop);
 DECLARE_WORKLOAD(leafloop);
 DECLARE_WORKLOAD(sqrtloop);
+DECLARE_WORKLOAD(brstack);
 
 #endif /* TESTS_H */
diff --git a/tools/perf/tests/workloads/Build b/tools/perf/tests/workloads/Build
index 2312a338f01c0..ae06a5538b171 100644
--- a/tools/perf/tests/workloads/Build
+++ b/tools/perf/tests/workloads/Build
@@ -4,6 +4,8 @@ perf-y += noploop.o
 perf-y += thloop.o
 perf-y += leafloop.o
 perf-y += sqrtloop.o
+perf-y += brstack.o
 
 CFLAGS_sqrtloop.o         = -g -O0 -fno-inline -U_FORTIFY_SOURCE
 CFLAGS_leafloop.o         = -g -O0 -fno-inline -fno-omit-frame-pointer -U_FORTIFY_SOURCE
+CFLAGS_brstack.o          = -g -O0 -fno-inline -U_FORTIFY_SOURCE
diff --git a/tools/perf/tests/workloads/brstack.c b/tools/perf/tests/workloads/brstack.c
new file mode 100644
index 0000000000000..0b60bd37b9d1a
--- /dev/null
+++ b/tools/perf/tests/workloads/brstack.c
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <stdlib.h>
+#include "../tests.h"
+
+#define BENCH_RUNS 999999
+
+static volatile int cnt;
+
+static void brstack_bar(void) {
+}				/* return */
+
+static void brstack_foo(void) {
+	brstack_bar();		/* call */
+}				/* return */
+
+static void brstack_bench(void) {
+	void (*brstack_foo_ind)(void) = brstack_foo;
+
+	if ((cnt++) % 3)	/* branch (cond) */
+		brstack_foo();	/* call */
+	brstack_bar();		/* call */
+	brstack_foo_ind();	/* call (ind) */
+}
+
+static int brstack(int argc, const char **argv)
+{
+	int num_loops = BENCH_RUNS;
+
+	if (argc > 0)
+		num_loops = atoi(argv[0]);
+
+	while (1) {
+		if ((cnt++) > num_loops)
+			break;
+		brstack_bench();/* call */
+	}			/* branch (uncond) */
+	return 0;
+}
+
+DEFINE_WORKLOAD(brstack);
-- 
2.43.0



