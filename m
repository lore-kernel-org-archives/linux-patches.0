Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483B61DC9BA;
	Wed,  5 Feb 2025 14:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766714; cv=none; b=OZfHMT+oiYj4AT5VqCr3lROT1JqFn2cRUJwW1nmPDzdQuaB9Mw0KJYzUfrfOgZP7G2SFWByT7Pp1tNzLQt7UQvnMwVxphBmQmg0eGCsTzBnqh0trT7DfT+aCERMQhIXiamzER5u0BPhaAZJ/XmJ4jA7vY4thplGhv4NGIyz10NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766714; c=relaxed/simple;
	bh=OVANB5oSbIzWE3R7SuUp4Y2V5jeCDjyNcHx2FLxSVaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lc1yOXcuGngCPj1lbH2FcLNFFptSxw+3xN4VPH8PDOmrrvQKPnl6dwLw8TXwLs9+h8ZyEoMO7EWcLcBZMAqBeSBHMkvPUM5ZYQ3ngORtLH6Qphyf9yC2J6lMVqUqltZMPAxup/lLcNIKuXQCUg/5Bfn5iWHLeZWg83NnWnOLscY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lEW7WU+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lEW7WU+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B49C4CED1;
	Wed,  5 Feb 2025 14:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766714;
	bh=OVANB5oSbIzWE3R7SuUp4Y2V5jeCDjyNcHx2FLxSVaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lEW7WU+5JvfWuALihSmkqwdQDoMxXvWydHKOSeKyGj16PYelc9NpjWc/cXKFivTqf
	 +1be0/MiNyc50u+YPfl8+jnzK1kphCXy6h/GtbXZtPOux/sNxMr8hwaI6xS7SGzRoP
	 v154Xb/8JU0qs6hffTR+nT2fGTVbq1wXjHfzYdRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Jiachen Zhang <me@jcix.top>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung.kim@lge.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 300/623] perf report: Fix misleading help message about --demangle
Date: Wed,  5 Feb 2025 14:40:42 +0100
Message-ID: <20250205134507.705613916@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiachen Zhang <me@jcix.top>

[ Upstream commit ac0ac75189a4d6a29a2765a7adbb62bc6cc650c7 ]

The wrong help message may mislead users. This commit fixes it.

Fixes: 328ccdace8855289 ("perf report: Add --no-demangle option")
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiachen Zhang <me@jcix.top>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250109152220.1869581-1-me@jcix.top
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-report.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 048c91960ba91..a5672749f7819 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1422,7 +1422,7 @@ int cmd_report(int argc, const char **argv)
 	OPT_STRING(0, "addr2line", &addr2line_path, "path",
 		   "addr2line binary to use for line numbers"),
 	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
-		    "Disable symbol demangling"),
+		    "Symbol demangling. Enabled by default, use --no-demangle to disable."),
 	OPT_BOOLEAN(0, "demangle-kernel", &symbol_conf.demangle_kernel,
 		    "Enable kernel symbol demangling"),
 	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
-- 
2.39.5



