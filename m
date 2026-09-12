Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CC73921EC;
	Sat, 12 Sep 2026 19:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243158; cv=none; b=aM+iNVyc/ui359DRCvztnVLKIjWlTM8WaPeuFjEbZZSdML0l2g1dO33qYHsxWNc1IyNCBVXFb8KKORh+nJwYgprd0Mc2sXclxbUdNeyZOD1BA9d0FAuePiqLVWMtTeLJB5d/eQ3xRIGg3PaC7r9t3om0SC1ard1kRGCrRG01tFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243158; c=relaxed/simple;
	bh=97fPzvugjJWb4RqmwybTVqcR3JY5miptbY6bbvv59Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPWgkeJADie+L795Z/kYPpVhByRQFrpkM04bewk3rDL90tuL1OhesIuXmdPa+sA4sRz/I2aPQoDa1qMIA5SpO9Yqc4GhOjqw5Hvl07c+zzzsd9giH4U1s5xtJGdh1twYCWIiA7P01nyJJ9mgOzIuJ+gORE9DGxIGzzquaoDRDEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCZ3o7rR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCZ3o7rR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43CE1F000FF;
	Sat, 12 Sep 2026 19:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243157;
	bh=Sa0/hI5u5iGOPshJLWjntzPZ9TkBVH+lRPHICdJNbmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LCZ3o7rRbHj+BTUBsiNFOKwMRYwMS9BBq+YDMmkIe16maRk3M1EaiiyIoexeGLFNH
	 682K5tIxKAZr8vYeXbWBQ7wvg6c0WoZlNFZFs1AklqE+Q3OUe5A5/CkHtHdqA+iGio
	 nrtSHBnboxTZj7k7+i/BekkDAlU/ieIc2+pEYckg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Xing Zhengjun <zhengjun.xing@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 658/798] perf stat: Clear screen only if output file is a tty
Date: Sat, 12 Sep 2026 09:04:46 +0200
Message-ID: <20260912065532.192446133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 81a02c6577ecfee7056ccafbd028984d0d670c0c ]

The --interval-clear option makes perf stat to clear the terminal at
each interval.  But it doesn't need to clear the screen when it saves
to a file.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Link: https://lore.kernel.org/r/20221107213314.3239159-4-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

to a file.  Make it fail when it's enabled with the output options.

  $ perf stat -I 1 --interval-clear -o myfile true
  --interval-clear does not work with output

   Usage: perf stat [<options>] [<command>]

      -o, --output <file>   output file name
          --log-fd <n>      log output to fd, instead of stderr
          --interval-clear  clear screen in between new interval

Stable-dep-of: 340641a4b5ff ("perf stat: Fix evsel_list leak in cmd_stat")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index b01af171d94f5..dd819e8b33977 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -2152,6 +2152,14 @@ int cmd_stat(int argc, const char **argv)
 		}
 	}
 
+	if (stat_config.interval_clear && !isatty(fileno(output))) {
+		fprintf(stderr, "--interval-clear does not work with output\n");
+		parse_options_usage(stat_usage, stat_options, "o", 1);
+		parse_options_usage(NULL, stat_options, "log-fd", 0);
+		parse_options_usage(NULL, stat_options, "interval-clear", 0);
+		return -1;
+	}
+
 	stat_config.output = output;
 
 	/*
-- 
2.53.0



