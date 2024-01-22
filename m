Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B0777638;
	Tue, 23 Jan 2024 02:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975509; cv=none; b=VaOTWcXb7EMREJ/I4rwNn1bcxWx3BZnKmypvE1lMA2GiY1xfBXvJikW74REmg3t8UJAIi3v4RLE9Ffl+M3UBFM2QA0MN+nJkEAlkGt7GkjFNLe+9z45H/bm/I5uLXHS358vP0M2twmGXK3s9DdAuvsMmZGv4aG1MJ0b8LRkM/0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975509; c=relaxed/simple;
	bh=h5Mh53tUsD/Z5D97V5FuaSeFpOzVnzYTuxAYa4pZxg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCdEQ6iHuSQtSnbHip8a1OWjqZJ+0zMS+Dk+4uIJQmf483+qnWOjvnbevkCw2I+pv3e+NjP2HliqxUXLtwtTQaYfaVJZRjLQ2StvCWY9uIcJp3LSSuLqIgRkrFJTexIi6W1INf0sOW6Cg+oBTg+DBSPB2B4ye7ZNF44C81Pmu24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=djDASYkM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="djDASYkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E63C433A6;
	Tue, 23 Jan 2024 02:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975509;
	bh=h5Mh53tUsD/Z5D97V5FuaSeFpOzVnzYTuxAYa4pZxg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=djDASYkMferUGs8as9RQy+/E227oRqMu8ZqCv677tF0sL2W8wkA0pLsF/Swh9oC5X
	 aklBNT6diRPm+K39VKlgO4KA2X34Hike2rfl5QDdMfKOqbVolbTVAhQ8NTPlPDlk8I
	 VBJl7FqvKjo6fefaC7Gfue/zvDXNxVBcPLViLA+o=
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
Subject: [PATCH 6.6 461/583] perf test: Remove atomics from test_loop to avoid test failures
Date: Mon, 22 Jan 2024 15:58:32 -0800
Message-ID: <20240122235826.086107854@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



