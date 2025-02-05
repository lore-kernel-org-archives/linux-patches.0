Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7F9151988;
	Wed,  5 Feb 2025 14:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766220; cv=none; b=udbOfs0sWpJZoVuOGolNHrNkW+9MasUQp0UeZv0S/CFUBaZArhL505KFxiG+qfFM6fOOZZj/GwZrG/p4kM8k92co1+yhEkD/1+thoEHv+zrVJI2liMRVy/H5Z7JnRHKF5IkAAolTe/hGG1xRjAXvjLJZ+Pry7DvAnTtTqrZBQbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766220; c=relaxed/simple;
	bh=qGFjyhotWqOE1Uzf8Bwt7m734i009cyEBG2br9+rDX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghslq1jiBJvtbh3d6cS0BrPgVQkG3/lPJ/bfkks0hLT8Qp1+qQ1bgoAns6WXbypQMbZYW5SLsMIg8F83rxUis/LYRGTtSoZDv7zO2DGOBeKWlkUMkM/chmaH6XVNNlDSCxP0rUv5zRBmHVBn8OncLz1mjh8eFFD3vMF42h7waTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvibNuDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvibNuDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C8EC4CED1;
	Wed,  5 Feb 2025 14:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766220;
	bh=qGFjyhotWqOE1Uzf8Bwt7m734i009cyEBG2br9+rDX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvibNuDbIf0MRRS7YCINiLtEx1eVBACLvyNI5DoSglNkhbKlH6U9Lm9n7M0JV5OaE
	 mGeGXWdWMC94XSW5miScaF7kohd8zzcDbwQvx+4waLg81bJ/EoW0lgmrCP/ZylDfrP
	 x5GATqRCn4aBkUr2kxu1iZukrNuLWY/VGUp23xf8=
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
Subject: [PATCH 6.12 279/590] perf report: Fix misleading help message about --demangle
Date: Wed,  5 Feb 2025 14:40:34 +0100
Message-ID: <20250205134505.953831933@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5dc17ffee27a2..645deec294c84 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1418,7 +1418,7 @@ int cmd_report(int argc, const char **argv)
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



