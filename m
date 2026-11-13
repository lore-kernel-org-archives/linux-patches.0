Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590699;
	b=iFLCf33pR7mmy7k+HkHDP6iNUfaqjtDZLMrAsjZiQSklc8c2+uL5XCqBTuHYidBt128U
	 /+WT9EoErc0XWleuNHGN9d3GZkTir72DMVqarmRJaykhyKBNRrBMD2MT2twZxe+IglJvp
	 xiMi86ccvyVQVMDvmu77AQZTt6ZOJBuwFNaZSK4P6Vbc0jVM+ODAJZHdNcw2NCjRbo9xs
	 5H1AYLgaBgQpGYkiyCtal6dRiLfNNZmpiU60ZQWhT9y5hset3xL5Ed2wucp1EqwmtkN9F
	 jAoX1N+0CdQ4wk/ZA5yxK5+PG9N5dUaF6DKsG7ZBy63ipdXXWYhttp8Uue8nV60d+Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CotvqG1zN7cHZbww7aTDOSURjUGewMGDHCZqk++QF2k=;
	b=rQDy2oKSkUip9l190Azsy+RFoydjh9uop2ho3aXyEc7syGovVr4xDRyL7bjAGQndFU/t
	 +EbY/c51r7K/G7z/97ssBM3nOU+K3YonwlFegVq8BafqHzpKiW2tvTPXpqBm3ZWvhzxUQ
	 RyEp95BKh2ti7qlGYB94jVBmlzvQQQwE1NXSPxSSa3kOqro4lrquQISYcaGMCuog2CwgD
	 nTkNs6Cb+J0LaeqtGOClCRy0PG/NJmFLKjgpVUVmB3Mrb7QEopGueDZ0vzxbZmOX4Zrnz
	 1Ci7GZv3RtbLsn0fYWVZGDlJ0M+Fz2Y8GpqZlxAZDXa59DPS7ovseVaBGRBt42dENrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xtPi9kCe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27241607A5C9;
	Fri, 13 Nov 2026 17:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xtPi9kCe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8507E1F000C4;
	Fri, 13 Nov 2026 17:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590698;
	bh=CotvqG1zN7cHZbww7aTDOSURjUGewMGDHCZqk++QF2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xtPi9kCeHUhHRquw9QT5pD8whogTr1KkK9na4G7MGYtz7pwbpBdxB9fmhhuK+A9zc
	 5aTtmaeNQZ2M/g1QddtkyL7OeWRhn+Zd/3GOY6soscqx0u8gcGdcGJ2gVYDmxGvFT3
	 uRADnoG876Ejk1zc+mDqMpvqyu0t6oRZpwc7ZH+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Hui Su <sh_def@163.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 610/686] perf evsel: Restrict incremental open error unwind
Date: Fri, 13 Nov 2026 10:52:23 -0500
Message-ID: <20261113153842.568642958@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Hui Su <sh_def@163.com>

[ Upstream commit d023b2110d0d7232ba952a486c497ba8817f6f66 ]

evsel__open_cpu(), evsel__tool_pmu_open() and
evsel__hwmon_pmu_open() support opening a subrange of a CPU map, bounded
by [start_cpu_map_idx, end_cpu_map_idx).

Their error paths, however, unwind using "while (--idx >= 0)" all the way
back to CPU index 0 regardless of start_cpu_map_idx. If lower CPU indices
were opened by an earlier invocation, a later incremental open failure
therefore closes those existing file descriptors and overwrites their
slots with -1.

Before this fix, running the new incremental open test demonstrates this
corruption:

  $ perf test -v "Tool PMU"
   12: Tool PMU:
   12.1: Tool PMU                                                      : Ok
   12.2: Tool PMU leader                                               : Ok
   12.3: Incremental open error unwind boundary:
     FAILED: CPU 0 FD overwritten: FD(evsel, 0, 0)=-1, expected 4
  FAILED!

Stop the unwind at start_cpu_map_idx so that only file descriptors
opened by the current invocation are rolled back.

After this fix:

  $ perf test -v "Tool PMU"
   12: Tool PMU:
   12.1: Tool PMU                                                      : Ok
   12.2: Tool PMU leader                                               : Ok
   12.3: Incremental open error unwind boundary                        : Ok

Fixes: 4804e0111662d7d8 ("perf stat: Use affinity for opening events")
Fixes: 240505b2d0adcdc8 ("perf tool_pmu: Factor tool events into their own PMU")
Fixes: 53cc0b351ec99278 ("perf hwmon_pmu: Add a tool PMU exposing events from hwmon in sysfs")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Hui Su <sh_def@163.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 16d1234793d4 ("perf evsel: Close the fds opened so far when disabling missing features")
[ sashal: used evlist__delete() in the new test because evlist__put() is unavailable ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/tool_pmu.c | 79 +++++++++++++++++++++++++++++++++++++
 tools/perf/util/evsel.c     |  2 +-
 tools/perf/util/hwmon_pmu.c |  2 +-
 tools/perf/util/tool_pmu.c  |  2 +-
 4 files changed, 82 insertions(+), 3 deletions(-)

diff --git a/tools/perf/tests/tool_pmu.c b/tools/perf/tests/tool_pmu.c
index 1e900ef92e378..5dcb747a6391c 100644
--- a/tools/perf/tests/tool_pmu.c
+++ b/tools/perf/tests/tool_pmu.c
@@ -1,8 +1,16 @@
 // SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+#include <errno.h>
+#include <fcntl.h>
+#include <string.h>
+#include <unistd.h>
+#include <internal/xyarray.h>
+#include "cpumap.h"
 #include "debug.h"
 #include "evlist.h"
+#include "evsel.h"
 #include "parse-events.h"
 #include "tests.h"
+#include "thread_map.h"
 #include "tool_pmu.h"
 
 static int do_test(enum tool_pmu_event ev, bool with_pmu)
@@ -99,9 +107,80 @@ static int test__tool_pmu_with_pmu(struct test_suite *test __maybe_unused,
 	return TEST_OK;
 }
 
+static int test__tool_pmu_incremental_open_unwind(struct test_suite *test __maybe_unused,
+						  int subtest __maybe_unused)
+{
+	struct evlist *evlist = evlist__new();
+	struct parse_events_error err;
+	struct perf_cpu_map *cpus = NULL;
+	struct perf_thread_map *threads = NULL;
+	struct evsel *evsel;
+	int ret = TEST_FAIL, fd0 = -1;
+
+	if (!evlist)
+		return TEST_FAIL;
+
+	parse_events_error__init(&err);
+	if (parse_events(evlist, "tool/user_time/", &err)) {
+		parse_events_error__exit(&err);
+		evlist__delete(evlist);
+		return TEST_FAIL;
+	}
+	parse_events_error__exit(&err);
+
+	evsel = evlist__first(evlist);
+	cpus = perf_cpu_map__new("0,1");
+	threads = thread_map__new_by_tid(getpid());
+	if (!cpus || !threads)
+		goto out;
+
+	/* Step 1: Open CPU index 0 successfully */
+	if (evsel__open_per_cpu_and_thread(evsel, cpus, 0, threads) < 0) {
+		pr_debug("Failed to open CPU index 0\n");
+		goto out;
+	}
+
+	fd0 = (*(int *)xyarray__entry(evsel->core.fd, 0, 0));
+	if (fd0 < 0 || fcntl(fd0, F_GETFD) < 0) {
+		pr_debug("CPU index 0 FD is invalid (%d)\n", fd0);
+		goto out;
+	}
+
+	/* Step 2: Intentionally trigger failure on CPU index 1 */
+	evsel->core.attr.sample_period = 1; /* Not supported for tool PMU -> -EINVAL */
+	if (evsel__open_per_cpu_and_thread(evsel, cpus, 1, threads) >= 0) {
+		pr_debug("Unexpected success opening CPU index 1 with sample_period=1\n");
+		goto out;
+	}
+
+	/*
+	 * Step 3: Check that CPU index 0's FD was NOT destroyed by CPU index 1's unwind.
+	 */
+	if ((*(int *)xyarray__entry(evsel->core.fd, 0, 0)) != fd0) {
+		pr_debug("FAILED: CPU 0 FD overwritten: FD(evsel, 0, 0)=%d, expected %d\n",
+			 (*(int *)xyarray__entry(evsel->core.fd, 0, 0)), fd0);
+		goto out;
+	}
+
+	if (fcntl(fd0, F_GETFD) < 0) {
+		pr_debug("FAILED: CPU 0 FD %d was closed by error unwind! errno=%d (%s)\n",
+			 fd0, errno, strerror(errno));
+		goto out;
+	}
+
+	ret = TEST_OK;
+out:
+	evsel__close(evsel);
+	perf_cpu_map__put(cpus);
+	perf_thread_map__put(threads);
+	evlist__delete(evlist);
+	return ret;
+}
+
 static struct test_case tests__tool_pmu[] = {
 	TEST_CASE("Parsing without PMU name", tool_pmu_without_pmu),
 	TEST_CASE("Parsing with PMU name", tool_pmu_with_pmu),
+	TEST_CASE("Incremental open error unwind boundary", tool_pmu_incremental_open_unwind),
 	{	.name = NULL, }
 };
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e01103443b23f..4fa7cbc51047c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2810,7 +2810,7 @@ static int evsel__open_cpu(struct evsel *evsel, struct perf_cpu_map *cpus,
 			FD(evsel, idx, thread) = -1;
 		}
 		thread = nthreads;
-	} while (--idx >= 0);
+	} while (--idx >= start_cpu_map_idx);
 	errno = old_errno;
 out:
 	if (err)
diff --git a/tools/perf/util/hwmon_pmu.c b/tools/perf/util/hwmon_pmu.c
index b24cdc3299447..7c1ac23e41324 100644
--- a/tools/perf/util/hwmon_pmu.c
+++ b/tools/perf/util/hwmon_pmu.c
@@ -803,7 +803,7 @@ int evsel__hwmon_pmu_open(struct evsel *evsel,
 			FD(evsel, idx, thread) = -1;
 		}
 		thread = nthreads;
-	} while (--idx >= 0);
+	} while (--idx >= start_cpu_map_idx);
 	close(dir);
 	return err;
 }
diff --git a/tools/perf/util/tool_pmu.c b/tools/perf/util/tool_pmu.c
index f075098488bad..601fbf6ae4098 100644
--- a/tools/perf/util/tool_pmu.c
+++ b/tools/perf/util/tool_pmu.c
@@ -296,7 +296,7 @@ int evsel__tool_pmu_open(struct evsel *evsel,
 			FD(evsel, idx, thread) = -1;
 		}
 		thread = nthreads;
-	} while (--idx >= 0);
+	} while (--idx >= start_cpu_map_idx);
 	errno = old_errno;
 	return err;
 }
-- 
2.53.0



