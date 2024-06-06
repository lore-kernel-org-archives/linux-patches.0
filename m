Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C997198E92;
	Thu,  6 Jun 2024 14:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683488; cv=none; b=AzEvbW2kYS+RNxxTjL1aSiTqJm4TMeDcvLcpP5H2HjIjCbDYAcS2o/gUkrmkfOi3jBNEBOkF8nb5JHqOqN0BlRlBBqUfPvzni2nMPuJLW0EKxoDhd4KjWeR/3uaqRZx0+AKGkAxCV7sED16Vmw8tWHupQYvEpJsShKQrteCdCAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683488; c=relaxed/simple;
	bh=9gUXLYPIfX2i1FXnLQ3YLUX9R/VLBpC/QWXmaGCq7sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlQ1/waS48AzieYJKs8lru2YDy8qvzA1/R5GeszU1J3h/Ka5oKnho3sWqS9O9uTe4ni5kJ/iEGU4xtkb+UjWPED2jUa9LIv26BZZLDD8vp/Cv98SzDdSzBofrH+WM4bN39o5opNy84nB4OhcgZKgMqzRAy1RqWW2o6C84Yv5y3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oaYaeZLr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oaYaeZLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F51DC2BD10;
	Thu,  6 Jun 2024 14:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683488;
	bh=9gUXLYPIfX2i1FXnLQ3YLUX9R/VLBpC/QWXmaGCq7sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oaYaeZLrVDHFKRxViL7Yp2dCLZhPc+hyqUq49NY7hTTTej6RD21bmaF78xvRC1DrE
	 Z6BcpurQa/qoovVvHhyBnpONUyEC5T+U6iiSozlrPACwBKYxEODVNAA6rEHiY00r8n
	 SwbXlwo19rYp0CsbpTLASILe39mc8fIGP9wuyo+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andrei Vagin <avagin@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Kees Kook <keescook@chromium.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 431/744] perf bench uprobe: Remove lib64 from libc.so.6 binary path
Date: Thu,  6 Jun 2024 16:01:43 +0200
Message-ID: <20240606131746.291336842@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 459fee7b508231cd4622b3bd94aaa85e8e16b888 ]

bpf_program__attach_uprobe_opts will search LD_LIBRARY_PATH and so
specifying `/lib64` is unnecessary and causes failures for libc.so.6
paths like `/lib/x86_64-linux-gnu/libc.so.6`.

Fixes: 7b47623b8cae8149 ("perf bench uprobe trace_printk: Add entry attaching an BPF program that does a trace_printk")
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Kees Kook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240406040911.1603801-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/bench/uprobe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/bench/uprobe.c b/tools/perf/bench/uprobe.c
index 914c0817fe8ad..e8e0afa13f049 100644
--- a/tools/perf/bench/uprobe.c
+++ b/tools/perf/bench/uprobe.c
@@ -47,7 +47,7 @@ static const char * const bench_uprobe_usage[] = {
 #define bench_uprobe__attach_uprobe(prog) \
 	skel->links.prog = bpf_program__attach_uprobe_opts(/*prog=*/skel->progs.prog, \
 							   /*pid=*/-1, \
-							   /*binary_path=*/"/lib64/libc.so.6", \
+							   /*binary_path=*/"libc.so.6", \
 							   /*func_offset=*/0, \
 							   /*opts=*/&uprobe_opts); \
 	if (!skel->links.prog) { \
-- 
2.43.0



