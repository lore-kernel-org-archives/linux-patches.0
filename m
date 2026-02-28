Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566C435B654
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300897; cv=none; b=NnHvwSr1bEhTtPFcgTS4ZoNRfoKnKMHddfpwv41GD1ilxSntcfbMxbyikGoi7El5yA10vbjyCh1h3nqhJ3oESQPAwIG+bSV/cRYPZerjK/wGXTRCH1CsGfzXdNMyTf8LheGVjRLKRNlIw5LsWcTEHXxKFJx4s+uCCsu+XBesnkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300897; c=relaxed/simple;
	bh=b6+1gnxBezrGNZf3K8NI12Al8ckqgqSf2o1BUGhHJOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfxTUdDTK91E9rzdhN09mKkhz+ddlK1vCEcAt1CGiPIgJVoO92USpo7ScSdX8epq4Zizcr2ZDAMtbnWAYpfRuBtMTuEAHi/IAcq1id/HYfpd2EsoiK6BSv7NZ6jqBuKp0ULFLu2gDXRhFr8I4ssC7jQmFCNOw48FWhJEYgLvDM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q+xooBuL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q+xooBuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC74C19423;
	Sat, 28 Feb 2026 17:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300896;
	bh=b6+1gnxBezrGNZf3K8NI12Al8ckqgqSf2o1BUGhHJOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+xooBuLYGbQZNBAV1yBEeVLnEx+yI9pgoui4mPPxG+Gcpe30qCtTCDDDalfH1Vr/
	 aAuPWnxcgCLQ1bVp+s2RU1p5VOFj98Ec+XEzd9zvYEdwSsJ/USHZJA80ZdNtnyh+wK
	 4JyEE6x9bNGzS4vktyMjjZF1OruopzNJrVd7bmpbNsHMYYK6djIhsh8+xry4T8yHKN
	 g9ZrMncKSFuiJDsDdty7t5zQ9uGEjPosaaDAPFM5n4sDGaebEB3CE+Zw3lUHh9zGmJ
	 9tNptMkZbBnprP7Y+W7QOvBrZh0nzrAfbGu55S0Md9hieJjkc5964fieqa1sa/x2mv
	 pfX6bxEbCeE0Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 013/752] perf tests sched: Avoid error in cleanup on loaded machines
Date: Sat, 28 Feb 2026 12:35:24 -0500
Message-ID: <20260228174750.1542406-13-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ian Rogers <irogers@google.com>

[ Upstream commit c5e47e4d00fbc15f2390bb6ed8d9c21836363291 ]

The stop_noploops function will kill the noploop processes that are
running for 10 seconds.

On a loaded machine they may have already terminated meaning the kill
will return an error of no such process.

This doesn't matter and so ignore the error to avoid the test
terminating in the cleanup.

Fixes: 0e22c5ca44e68798 ("perf test: Add sched latency and script shell tests")
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/sched.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/sched.sh b/tools/perf/tests/shell/sched.sh
index b9b81eaf856e6..b9637069adb1f 100755
--- a/tools/perf/tests/shell/sched.sh
+++ b/tools/perf/tests/shell/sched.sh
@@ -53,7 +53,7 @@ start_noploops() {
 }
 
 cleanup_noploops() {
-  kill "$PID1" "$PID2"
+  kill "$PID1" "$PID2" || true
 }
 
 test_sched_record() {
-- 
2.51.0

