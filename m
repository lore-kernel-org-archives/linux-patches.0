Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9155E3AE43
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C810FC433D2;
	Wed,  7 Jun 2023 20:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169332;
	bh=lb6GY8I5rJ/0H5nYRF4g7oGPazNt2/mSaebjWyws2c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5GJ3AdGxgM6yb/epcJIa1W0OX3NyAXeNOTPZ5fQzB69yF8C2VetndMqhMIkjg6yo
	 r0x0hdQqKQYBghWRe70lU89brMIg085q57SOXYn2ugMI578UILFwaYic1y4G3ATqs2
	 YtVSNMVlpk1XzKDc6zCZjQp+FK4Yi1Bov8SjRCX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Changbin Du <changbin.du@huawei.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 041/286] perf ftrace latency: Remove unnecessary "--" from --use-nsec option
Date: Wed,  7 Jun 2023 22:12:20 +0200
Message-ID: <20230607200924.372348776@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 8d73259ef23f449329294dc187932f7470268126 ]

The option name should not have the dashes.  Current version shows four
dashes for the option.

  $ perf ftrace latency -h

   Usage: perf ftrace [<options>] [<command>]
      or: perf ftrace [<options>] -- [<command>] [<options>]
      or: perf ftrace {trace|latency} [<options>] [<command>]
      or: perf ftrace {trace|latency} [<options>] -- [<command>] [<options>]

      -b, --use-bpf         Use BPF to measure function latency
      -n, ----use-nsec      Use nano-second histogram
      -T, --trace-funcs <func>
                            Show latency of given function

Fixes: 84005bb6148618cc ("perf ftrace latency: Add -n/--use-nsec option")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Changbin Du <changbin.du@huawei.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20230525212038.3535851-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index fb1b66ef2e167..ce482ef58e6f2 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -1175,7 +1175,7 @@ int cmd_ftrace(int argc, const char **argv)
 	OPT_BOOLEAN('b', "use-bpf", &ftrace.target.use_bpf,
 		    "Use BPF to measure function latency"),
 #endif
-	OPT_BOOLEAN('n', "--use-nsec", &ftrace.use_nsec,
+	OPT_BOOLEAN('n', "use-nsec", &ftrace.use_nsec,
 		    "Use nano-second histogram"),
 	OPT_PARENT(common_options),
 	};
-- 
2.39.2



