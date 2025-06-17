Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB83D188006;
	Tue, 17 Jun 2025 16:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178652; cv=none; b=aQhCeccxlNfsg4upzWDulB3PwCu8pa/fp1dk0pV9fhMuPM7eEms8HIxzxtBcbNPOGFres4W8XHboTgzi6FUUGzwbSS01xwCTzSF/RhvqjoeThmG/8Ps5XMvnXsYktoiQU/UPkFw2xNuuwgH7zQIt/Gvv2oyKjXVN9GyAbq4qY2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178652; c=relaxed/simple;
	bh=fV1qrBg0mL6AKUOfeAh8M1Ot2JuI5knKyQ6ptVZobgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OGliEJH5mDaqkZtBEEMaOtYAkB0qCw3RMTrgQmb1Rf+DyJERjL4X6vAxJIqMI8Cli/6DxirMAH75h4ScpkgbbNGcjnhc/wdy5tqrD0dguk7IPJwktdntGFPQqR9f4XsCm4yfipaR2JuSwWlPrEsFnx/PN+onpXEoDD3BA6V3zlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDl4hk/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDl4hk/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E78FC4CEE3;
	Tue, 17 Jun 2025 16:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178652;
	bh=fV1qrBg0mL6AKUOfeAh8M1Ot2JuI5knKyQ6ptVZobgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDl4hk/RJbCIcxBUDfqOV+Wn+LG20H0wHwLFMbG7scIfBkNL9+bwbIB9+B/JLKvXG
	 xWKmh7KPLtcVlDCmQWrRzLYS/iCU4zIJTAG0d87H6Y0O4JwKYp9zmhTL05gjttvO+w
	 AkJ1dOu9DfLLk2Oq4gbQCyyYvZit7BwBLUiRcNG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anubhav Shelat <ashelat@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Michael Petlan <mpetlan@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 483/780] perf trace: Set errpid to false for rseq and set_robust_list
Date: Tue, 17 Jun 2025 17:23:11 +0200
Message-ID: <20250617152511.157016451@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anubhav Shelat <ashelat@redhat.com>

[ Upstream commit 8c56bfe53bd881c7b598c54a3a06216743c57bbc ]

The 'rseq' and 'set_robust_list' syscalls don't return a pid, so set
errpid for both to false.

Fixes: 0c1019e3463b263a ("perf trace: Mark the 'rseq' arg in the rseq syscall as coming from user space")
Fixes: 1de5b5dcb8353f36 ("perf trace: Mark the 'head' arg in the set_robust_list syscall as coming from user space")
Signed-off-by: Anubhav Shelat <ashelat@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250529143334.1469669-2-ashelat@redhat.com
[ Remove explicit .errpid = false, omitting its initialization zeroes it, as noted by Namhyung ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 7304e62b69fee..33cce59bdfbdb 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1352,7 +1352,7 @@ static const struct syscall_fmt syscall_fmts[] = {
 	  .arg = { [0] = { .scnprintf = SCA_FDAT, /* olddirfd */ },
 		   [2] = { .scnprintf = SCA_FDAT, /* newdirfd */ },
 		   [4] = { .scnprintf = SCA_RENAMEAT2_FLAGS, /* flags */ }, }, },
-	{ .name	    = "rseq",	    .errpid = true,
+	{ .name	    = "rseq",
 	  .arg = { [0] = { .from_user = true /* rseq */, }, }, },
 	{ .name	    = "rt_sigaction",
 	  .arg = { [0] = { .scnprintf = SCA_SIGNUM, /* sig */ }, }, },
@@ -1376,7 +1376,7 @@ static const struct syscall_fmt syscall_fmts[] = {
 	{ .name	    = "sendto",
 	  .arg = { [3] = { .scnprintf = SCA_MSG_FLAGS, /* flags */ },
 		   [4] = SCA_SOCKADDR_FROM_USER(addr), }, },
-	{ .name	    = "set_robust_list",	    .errpid = true,
+	{ .name	    = "set_robust_list",
 	  .arg = { [0] = { .from_user = true /* head */, }, }, },
 	{ .name	    = "set_tid_address", .errpid = true, },
 	{ .name	    = "setitimer",
-- 
2.39.5



