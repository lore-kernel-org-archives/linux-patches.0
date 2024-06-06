Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C2D198E66;
	Thu,  6 Jun 2024 14:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683417; cv=none; b=or2oYbUafKkFRmRTw7QNr/K6H8vtWAYlKoOjbsojfMsq8fA7YqoIV1d6oADul6P9gN9HwTiaYOCQ7rEN95F16k/qbzSjZV8iJlwUtIYXUCigbwbGOglx6gUTANTjne7umj/Cre9VNQaBC7m7WU5p5MyV2T5sN16P+EqaogOCGKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683417; c=relaxed/simple;
	bh=5YEfUUYN2ULVg1tl1Ya4pkZaNCKiVoVA6u4YD9TaR+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+vMYtqm0uhe2WyTMkOtpXez3Ib2FxwK7ilEC4/BAG8s8rFfL/o2Ud8gJiGdGz9R0Q8We1IXD9SbsD6XesvBc/sKXa7cp6Z2gnKLHh185pCLKYfYMJVIZw32WkDhsOWjuYacdCDi4lfqQUHHo9ogksxbLff5P5MDQpJZMBcg4Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UD+VQDWK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UD+VQDWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCDEC4AF08;
	Thu,  6 Jun 2024 14:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683417;
	bh=5YEfUUYN2ULVg1tl1Ya4pkZaNCKiVoVA6u4YD9TaR+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UD+VQDWK+tffHsvky9ZCLn+bBfvlu63m+LG+lokycpEqvDoDO9417aryp2sbF7pcL
	 LcT+nM1YMxIVYgkmGajN/4URE5ldlONA+Bo8vtMzrEfvtX40RYPI/h8RvYv6UgL5nZ
	 6NYTHdZLwlBzH8nMa4QONjM4Y3FuJFZcL3c/Wymk=
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
Subject: [PATCH 6.1 300/473] perf test: Add leafloop test workload
Date: Thu,  6 Jun 2024 16:03:49 +0200
Message-ID: <20240606131709.839849773@linuxfoundation.org>
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

[ Upstream commit 41522f7442905814c654dbe2ca7b8d3605c7e0cc ]

The leafloop workload is to run an infinite loop in the test_leaf
function.  This is needed for the ARM fp callgraph test to verify if it
gets the correct callchains.

  $ perf test -w leafloop

Committer notes:

Add a:

  -U_FORTIFY_SOURCE

to the leafloop CFLAGS as the main perf flags set it and it requires
building with optimization, and this new test has a -O0.

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
Link: https://lore.kernel.org/r/20221116233854.1596378-6-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 256ef072b384 ("perf tests: Make "test data symbol" more robust on Neoverse N1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/builtin-test.c       |  1 +
 tools/perf/tests/tests.h              |  1 +
 tools/perf/tests/workloads/Build      |  3 +++
 tools/perf/tests/workloads/leafloop.c | 34 +++++++++++++++++++++++++++
 4 files changed, 39 insertions(+)
 create mode 100644 tools/perf/tests/workloads/leafloop.c

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 161f38476e77b..0ed5ac452f6ee 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -121,6 +121,7 @@ static struct test_suite **tests[] = {
 static struct test_workload *workloads[] = {
 	&workload__noploop,
 	&workload__thloop,
+	&workload__leafloop,
 };
 
 static int num_subtests(const struct test_suite *t)
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index e6edfeeadaeba..86804dd6452b7 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -202,5 +202,6 @@ struct test_workload workload__##work = {	\
 /* The list of test workloads */
 DECLARE_WORKLOAD(noploop);
 DECLARE_WORKLOAD(thloop);
+DECLARE_WORKLOAD(leafloop);
 
 #endif /* TESTS_H */
diff --git a/tools/perf/tests/workloads/Build b/tools/perf/tests/workloads/Build
index b8964b1099c0e..03dc675a4a7c8 100644
--- a/tools/perf/tests/workloads/Build
+++ b/tools/perf/tests/workloads/Build
@@ -2,3 +2,6 @@
 
 perf-y += noploop.o
 perf-y += thloop.o
+perf-y += leafloop.o
+
+CFLAGS_leafloop.o         = -g -O0 -fno-inline -fno-omit-frame-pointer -U_FORTIFY_SOURCE
diff --git a/tools/perf/tests/workloads/leafloop.c b/tools/perf/tests/workloads/leafloop.c
new file mode 100644
index 0000000000000..1bf5cc97649b0
--- /dev/null
+++ b/tools/perf/tests/workloads/leafloop.c
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <stdlib.h>
+#include <linux/compiler.h>
+#include "../tests.h"
+
+/* We want to check these symbols in perf script */
+noinline void leaf(volatile int b);
+noinline void parent(volatile int b);
+
+static volatile int a;
+
+noinline void leaf(volatile int b)
+{
+	for (;;)
+		a += b;
+}
+
+noinline void parent(volatile int b)
+{
+	leaf(b);
+}
+
+static int leafloop(int argc, const char **argv)
+{
+	int c = 1;
+
+	if (argc > 0)
+		c = atoi(argv[0]);
+
+	parent(c);
+	return 0;
+}
+
+DEFINE_WORKLOAD(leafloop);
-- 
2.43.0



