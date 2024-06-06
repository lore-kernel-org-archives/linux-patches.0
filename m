Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F20197537;
	Thu,  6 Jun 2024 14:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682918; cv=none; b=PZF5eCk1A980Zg05vScjwX6MTPdpJJomkqPevwjPe+uVsVWLoKljeDGYALStOjINLsuU4sZ4DXPRUrCis9ObGaeGoTLpA15M4fazV8xxBKJvMxJDEhqX+0Z9MoSz1wCyBnIEhNU6EMyXDudCh4r6KkB+bMasys+J8DyNxk0mBMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682918; c=relaxed/simple;
	bh=hPXss89NplCrkd5XxUcTYpyjJAddbH4zXqCRYk3lJM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0K1PheeMK16PuH706EVkHIgA+a22WS9cwkFYbvzE2Dlnju6jI2l8fF8X9FdgC4eoBlZoBvrUfKmz/niaRJD3XoZyjmMEBR0esd9sgD2Jvq7F7+UOfJffn1ySTtbiD0P1Et9v4U7VUefzkxhGM/gyRKqUc9QEdJJkiGDZZ/WCws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hn44DH/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hn44DH/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F09C32781;
	Thu,  6 Jun 2024 14:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682918;
	bh=hPXss89NplCrkd5XxUcTYpyjJAddbH4zXqCRYk3lJM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hn44DH/AXpIe7LtjJpdtzQdMbDLK88aSSdv/3EtE0liGJW0Rni9optVmwoODZSQ0q
	 mt3glAqJ47T12BoAUKayGEnncrldDEW3116Byd/zvW3miJstsH3kz5VvNPO6ImBLcJ
	 rD2l6Aj4E1H6bPpkZ6BTTusHZ8c4Gajrwgdqcad8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jin Yao <yao.jin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 013/374] perf annotate: Get rid of duplicate --group option item
Date: Thu,  6 Jun 2024 15:59:52 +0200
Message-ID: <20240606131652.207979047@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 374af9f1f06b5e991c810d2e4983d6f58df32136 ]

The options array in cmd_annotate() has duplicate --group options.  It
only needs one and let's get rid of the other.

  $ perf annotate -h 2>&1 | grep group
        --group           Show event group information together
        --group           Show event group information together

Fixes: 7ebaf4890f63eb90 ("perf annotate: Support '--group' option")
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240322224313.423181-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-annotate.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 6c1cc797692d9..9cd97fd76bb5e 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -809,8 +809,6 @@ int cmd_annotate(int argc, const char **argv)
 		    "Enable symbol demangling"),
 	OPT_BOOLEAN(0, "demangle-kernel", &symbol_conf.demangle_kernel,
 		    "Enable kernel symbol demangling"),
-	OPT_BOOLEAN(0, "group", &symbol_conf.event_group,
-		    "Show event group information together"),
 	OPT_BOOLEAN(0, "show-total-period", &symbol_conf.show_total_period,
 		    "Show a column with the sum of periods"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
-- 
2.43.0



