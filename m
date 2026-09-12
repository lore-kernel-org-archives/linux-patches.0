Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47857288B9;
	Sat, 12 Sep 2026 16:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231157; cv=none; b=ZQfwSmYcGn93CjwB8AweGJGSVCRIx7VzYKXAP7yZbpj3NLBQb73w8WZ7Oo2oo1mH6YfgJ8WqDgouFDLRgXz5Ju5g/mVFgztpRKwZTt24oVf7+d7dIs+dblddkqXNmATqX5lLYl3bjCPvomQgnN2iNqO24mTGbxGcUFwrV73SCgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231157; c=relaxed/simple;
	bh=3X8O9PEajrBzwY7rCF1WhysUB5RYDDdKe10tKHfm/pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYVa8VMJPPDx6wPIDOQFSdv215OmKAUjUvCv0hKulkY9RFgx5A2Eopx0leF12b3AtbSuPE7PPtCUb0Ho1/EV5laOTFwOpPER6rFnOehtiwum0VnnZjuaJ9Ji8Wtpnh0MzaT87dUqnaBe4NS+OyvMZ3VpmddLn4DFx1v3miFEFTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2G6GJwy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2G6GJwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C111F000FF;
	Sat, 12 Sep 2026 16:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231155;
	bh=/HcO9cpVdBHQSpLU2jY9IPJDnS2SujVwY0IC3UQTaxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t2G6GJwyL6K/iSOqnAwdukxsvWDDOOR8S3k1hjfClqzg9+C45TE8uGSyIsREtN8ae
	 ORyEzY+q9Ry/IcO3hztlp9WGpMC+3WzpYbaxtqy5KFzSz9lbB9hsBJFC+GlgbRkEQh
	 55IeySQYTY8xY2GE9rwaTNsCXMJmZnO080T/I0VI=
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
Subject: [PATCH 6.1 0941/1191] perf stat: Clear screen only if output file is a tty
Date: Sat, 12 Sep 2026 09:01:09 +0200
Message-ID: <20260912065609.361501802@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b243027bc22d8..59628fa170cac 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -2315,6 +2315,14 @@ int cmd_stat(int argc, const char **argv)
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



