Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29ADE46D54F;
	Tue, 21 Jul 2026 15:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648629; cv=none; b=g6yQv49d5budamYmR8Fbz2uM6H1FzTXiib/NH9AV1deSCpV614FLOG67H/EyCZEmy6lPbCtgUrHWoakpYicQtMODNJSIJpNfn35jcnnx/6f8RdiW7YkRuzI+bmNjzmm+9YNUbl7MEzRqCbwqUtLytcaDfcVa3Mg2uPNMldD/fAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648629; c=relaxed/simple;
	bh=4zrUpSnoVtLG63mdbciPx06wCcitUqzh3zeLGNwiMiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MS5ZrWsY4+AZ5GPLnoXCTOaMeQrff3OztMx82vneRqh2tQiRPq7qPWDL59hFpaQ1mN9iXh1JUmwCoqOvdSi7CaIHqZdfacgMADj10N+enD9osr9qLhmLQJ8tETNaoxxdrMY71Lp6jhyvAf+shi9eyGxvpeZavlUhBv99WSTTBgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qnn09p/h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qnn09p/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9E01F000E9;
	Tue, 21 Jul 2026 15:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648627;
	bh=r2ZDy1HhEnsGRN+vh+ci4IbAaOw2lz2dGf2czBygX54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qnn09p/hzXbRPq78OOVgLCDxM95yFRNxFsUScZUk60Gc8/cT3E3xrQ/7Zrko8TUtL
	 7AiojwHNlXwFZWbCdj6P41ncbafAapr/uc7L9r1eETIU8zL7gxjohaLZJSn+8pLI5D
	 5snzscNcUDAyDsP2l3imZYHQJucl5IKD5UJi7dSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Costa Shulyupin <costa.shul@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0227/2077] tools/rtla: Fix --dump-tasks usage in timerlat
Date: Tue, 21 Jul 2026 16:58:20 +0200
Message-ID: <20260721152558.033452337@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Costa Shulyupin <costa.shul@redhat.com>

[ Upstream commit 704fe8f3d97bba842f5f357e317116f1b88169e8 ]

Fix --dump-task to --dump-tasks in timerlat_hist usage string
and getopt_long table for consistency with timerlat_top.

Add missing --dump-tasks to timerlat_top usage synopsis.

Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Costa Shulyupin <costa.shul@redhat.com>
Fixes: 2091336b9a8b ("rtla/timerlat_hist: Add auto-analysis support")
Link: https://lore.kernel.org/r/20260414185223.65353-1-costa.shul@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/timerlat_hist.c | 4 ++--
 tools/tracing/rtla/src/timerlat_top.c  | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/tracing/rtla/src/timerlat_hist.c b/tools/tracing/rtla/src/timerlat_hist.c
index 4b6708e333b8f4..d52fd59195cd1f 100644
--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -694,7 +694,7 @@ static void timerlat_hist_usage(void)
 		"[-d s] [-D] [-n] [-a us] [-p us] [-i us] [-T us] [-s us] \\",
 		"         [-t [file]] [-e sys[:event]] [--filter <filter>] [--trigger <trigger>] [-c cpu-list] [-H cpu-list]\\",
 		"	  [-P priority] [-E N] [-b N] [--no-irq] [--no-thread] [--no-header] [--no-summary] \\",
-		"	  [--no-index] [--with-zeros] [--dma-latency us] [-C [cgroup_name]] [--no-aa] [--dump-task] [-u|-k]",
+		"	  [--no-index] [--with-zeros] [--dma-latency us] [-C [cgroup_name]] [--no-aa] [--dump-tasks] [-u|-k]",
 		"	  [--warm-up s] [--deepest-idle-state n]",
 		NULL,
 	};
@@ -809,7 +809,7 @@ static struct common_params
 			{"filter",		required_argument,	0, '7'},
 			{"dma-latency",		required_argument,	0, '8'},
 			{"no-aa",		no_argument,		0, '9'},
-			{"dump-task",		no_argument,		0, '\1'},
+			{"dump-tasks",		no_argument,		0, '\1'},
 			{"warm-up",		required_argument,	0, '\2'},
 			{"trace-buffer-size",	required_argument,	0, '\3'},
 			{"deepest-idle-state",	required_argument,	0, '\4'},
diff --git a/tools/tracing/rtla/src/timerlat_top.c b/tools/tracing/rtla/src/timerlat_top.c
index 91f88bbebad9eb..035abf01dbe631 100644
--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -467,7 +467,8 @@ static void timerlat_top_usage(void)
 	static const char *const msg_start[] = {
 		"[-q] [-a us] [-d s] [-D] [-n] [-p us] [-i us] [-T us] [-s us] \\",
 		"	  [[-t [file]] [-e sys[:event]] [--filter <filter>] [--trigger <trigger>] [-c cpu-list] [-H cpu-list]\\",
-		"	  [-P priority] [--dma-latency us] [--aa-only us] [-C [cgroup_name]] [-u|-k] [--warm-up s] [--deepest-idle-state n]",
+		"	  [-P priority] [--dma-latency us] [--aa-only us] [-C [cgroup_name]] [--dump-tasks] [-u|-k] [--warm-up s]\\",
+		"	  [--deepest-idle-state n]",
 		NULL,
 	};
 
-- 
2.53.0



