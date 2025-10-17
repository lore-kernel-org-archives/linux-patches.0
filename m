Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA97023EA9E;
	Fri, 17 Oct 2025 15:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714948; cv=none; b=OlPWkkbSBJ9fCijjy7LNDHFgGGvJOs8jxP/DYSeKBMm3M3Vz/ASTmpPX0kB10A3cbFCKIRriu91gAPousPzjaHM6OUDfIbYCcmrSKkejB4swTOiRL04xPV3pVgwX22RkBh0VO9RULAMloT4qYfyoBSY9JHXRcUHDeZp2aqS767E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714948; c=relaxed/simple;
	bh=2N74wxI9WmXplFrrfdHn3Dj7bujIQqO4Y3ptJOnYyAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ib/cPB69S3uwowzbDAj6rUDN7ew6mCWh0DNmVoe/kLI/DKKBMy1qcc4W1k23rvLtqbpzAUzjL0YxwGTIzbmeQPDQHZNSx3EQ4tpaVJTt/qtJPF00Cp5SMgZbJgfmn2Oj1GiQmX1s0dnbV+PMBfWiBP/xdH8un+dKL4xs3wBxdMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2rfwhKZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rfwhKZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E737C4CEE7;
	Fri, 17 Oct 2025 15:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714948;
	bh=2N74wxI9WmXplFrrfdHn3Dj7bujIQqO4Y3ptJOnYyAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2rfwhKZrgDA5X3f2WEjVZc0W/LmQNiuDho8SyV/ZTlZMb1m3DKFowhiVyF9ItoZb4
	 pKgkW0CnhOvScpFt3B9yFgo1mteQsXwfZRlVhsJcWx/V4R0jWtHTPDeJbfqQdOQSyH
	 3CuKgVGlEbkUZzUyDoAJciwRMoPi0NhxwsofK7ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Fushuai Wang <wangfushuai@baidu.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 044/371] perf trace: Fix IS_ERR() vs NULL check bug
Date: Fri, 17 Oct 2025 16:50:19 +0200
Message-ID: <20251017145203.394937633@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fushuai Wang <wangfushuai@baidu.com>

[ Upstream commit b0f4ade163e551d0c470ead7ac57eaf373eec71a ]

The alloc_syscall_stats() function always returns an error pointer
(ERR_PTR) on failure.

So replace NULL check with IS_ERR() check after calling
alloc_syscall_stats() function.

Fixes: fc00897c8a3f7f57 ("perf trace: Add --summary-mode option")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index fe737b3ac6e67..25c41b89f8abb 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -4440,7 +4440,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 
 	if (trace->summary_mode == SUMMARY__BY_TOTAL && !trace->summary_bpf) {
 		trace->syscall_stats = alloc_syscall_stats();
-		if (trace->syscall_stats == NULL)
+		if (IS_ERR(trace->syscall_stats))
 			goto out_delete_evlist;
 	}
 
@@ -4748,7 +4748,7 @@ static int trace__replay(struct trace *trace)
 
 	if (trace->summary_mode == SUMMARY__BY_TOTAL) {
 		trace->syscall_stats = alloc_syscall_stats();
-		if (trace->syscall_stats == NULL)
+		if (IS_ERR(trace->syscall_stats))
 			goto out;
 	}
 
-- 
2.51.0



