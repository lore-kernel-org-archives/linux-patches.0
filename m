Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4398E274B46;
	Sat, 12 Sep 2026 19:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239931; cv=none; b=Sn5xITWeA1BA6OdTsjtEZszVtPaGP+JA9dGLrTRYyTqHDgxjWV9dO8HDmkMoat84jFI61kww0j2g52WiKNo7ZWBE/WBFIDvCSzEGci6zWzEg9RgGPO9r9YlNDGri6r4E2w1DdzJP2oC2Jc6gLthWfPakwryjIkwyaX5jY8BUO/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239931; c=relaxed/simple;
	bh=yRFeqJ6ey5xlRflNjjdQmt2kDgFhkrhhjQvkC0Fd4q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P765GSEK/xYgngZWkuuCRKLcYNeX+zkL0U3txg+GVxQZYSiH+l5hLJ3uCKGbO7SGwOzNbtK0DktDVmSdzqu+MOdkpYk7iLeTWMC5mtqa5sOZ3zxJM+rse82l1gvlsDbSd3YSdQhV8V8Lm7E1SGOyqNgQtvXqHbWDjdm5yil2gKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSqMj2Wu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSqMj2Wu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE1D1F000FF;
	Sat, 12 Sep 2026 19:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239928;
	bh=HrsPU5Dqk5jt/hmPtczCGeW/A73c5PJYt3H6qFvRm4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NSqMj2WuvwhqcJUbiRHiF2vbJgPnTEkXC+aPcfXvt3hg4JGrXLQmUeoet6+47CVxN
	 VkA3VCXqyRch+gMPFbQJZigrH94rmU7U8Ba8h7bdT/+bnBD9+Cakue41HI1txSEcBH
	 ewAGeEkLDBVY9MIKWjLpDOpaGjX0b3eZ7Na1l3D4=
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
Subject: [PATCH 5.15 762/935] perf stat: Clear screen only if output file is a tty
Date: Sat, 12 Sep 2026 09:03:12 +0200
Message-ID: <20260912065544.311056963@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index efae2998a472f..12fc5ef1ab84f 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -2303,6 +2303,14 @@ int cmd_stat(int argc, const char **argv)
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



