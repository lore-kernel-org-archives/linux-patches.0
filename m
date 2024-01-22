Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAAF52F7C;
	Tue, 23 Jan 2024 00:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969938; cv=none; b=qYMqsEP/FSL9bio155uNU/+i2p/Fx0H/bgkdYO+RYw5yEVpB+T9+BKVqy0bH7shv+G3RA8ednSLi6lM6tP+elufL8a7WD7hr0Pgta8/5aAXa1yiUxVrkHv/BgUDYpcY7ub3fja3A+89ydlC8WOcXwpUIJJhY2QpJzMsEKkJdEOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969938; c=relaxed/simple;
	bh=RGbJ14mPK3fOA56Ar21PRf3IwBEi9s84Vjit/FazBfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJ50tTehBsH/KDpfuY8HyN33iXwMO6tIxeLZtPxTd/N0dv8whxNRu0kSVidrbgqz2LrbReSJFMGfesRxL2r9D3Nk0gg8mx8fgC1xZDhMRbvssavchpOptOOS5jAgGw4RPDDfIcKI0RixQBiZGLhlI2vHb7/S4TzEso6PJG3Togo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WlNY1O1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WlNY1O1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2ECC433C7;
	Tue, 23 Jan 2024 00:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969938;
	bh=RGbJ14mPK3fOA56Ar21PRf3IwBEi9s84Vjit/FazBfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WlNY1O1Ybxcv5o/1YvDYYjHdZi1l6T3wXscTAv5YJNFdFfYzeEdpTNTGWhisRnf4Z
	 rd6v7FaDdmPd+hBP4YgJN67aoho419jVnO14GCIC5OVplIS4VxpvtmFwKxuBURMwvq
	 nLdGDg6jz2QXkhz4uoBmwfPHhk7A6pVoANrC85to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@arm.com>,
	Nick Forrington <nick.forrington@arm.com>,
	Leo Yan <leo.yan@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 507/641] perf test: Remove atomics from test_loop to avoid test failures
Date: Mon, 22 Jan 2024 15:56:51 -0800
Message-ID: <20240122235833.935898924@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Forrington <nick.forrington@arm.com>

[ Upstream commit 72b4ca7e993e94f09bcf6d19fc385a2e8060c71f ]

The current use of atomics can lead to test failures, as tests (such as
tests/shell/record.sh) search for samples with "test_loop" as the
top-most stack frame, but find frames related to the atomic operation
(e.g. __aarch64_ldadd4_relax).

This change simply removes the "count" variable, as it is not necessary.

Fixes: 1962ab6f6e0b39e4 ("perf test workload thloop: Make count increments atomic")
Reviewed-by: James Clark <james.clark@arm.com>
Signed-off-by: Nick Forrington <nick.forrington@arm.com>
Acked-by: Leo Yan <leo.yan@linaro.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20231102162225.50028-1-nick.forrington@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/workloads/thloop.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/perf/tests/workloads/thloop.c b/tools/perf/tests/workloads/thloop.c
index af05269c2eb8..457b29f91c3e 100644
--- a/tools/perf/tests/workloads/thloop.c
+++ b/tools/perf/tests/workloads/thloop.c
@@ -7,7 +7,6 @@
 #include "../tests.h"
 
 static volatile sig_atomic_t done;
-static volatile unsigned count;
 
 /* We want to check this symbol in perf report */
 noinline void test_loop(void);
@@ -19,8 +18,7 @@ static void sighandler(int sig __maybe_unused)
 
 noinline void test_loop(void)
 {
-	while (!done)
-		__atomic_fetch_add(&count, 1, __ATOMIC_RELAXED);
+	while (!done);
 }
 
 static void *thfunc(void *arg)
-- 
2.43.0



