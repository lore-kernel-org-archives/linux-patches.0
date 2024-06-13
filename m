Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149D4143C4B;
	Thu, 13 Jun 2024 11:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279962; cv=none; b=rZOFFdgX0BW/Pn0ZFwKdETsGjFGfGvuBoT1JF0POMITZTdJkx/+i37VlTxQdliTGwFarOgi3ekSJehTehCrhpA7yoBN3wziAzGKWlkd6HBHGZnT9UcTDCaWk8GEKZD8vTp+6Z4bmJrrlAwxp/rrPXvzM3rkWm9hymqxKl9kuBQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279962; c=relaxed/simple;
	bh=TaXGWHWZVSgLd97LcznUVzqOIbJjswMcz589wjfBjkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMT9GW5eBWkwkR/4gKpniYMHYNfngeumRWuBkta8xxK9CWkoJ//w3hDG4chQCOufU6MWTpBT9z/eJIJXjlPCUKMW8HpeetDlHzFWVdRWS9hBIDpEJDFzAULa/CT31kc3MS3bY0uiUCy5Ri3VA6vM0JsnDqCi+jy4D/QTAiYub4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JwRD67PK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JwRD67PK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E19AC4AF1A;
	Thu, 13 Jun 2024 11:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279962;
	bh=TaXGWHWZVSgLd97LcznUVzqOIbJjswMcz589wjfBjkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JwRD67PKs9TEiJZHJkd7WO5W08XVMRXySVHmxzybs8qaDvDcvkmxO1HGgRIGXV1b4
	 oVLIT2GcewvUVNaq7lHU3UMwbZXKGKjQEE10v5DtlpXMnebIC3WlzeESntreJzc4Ux
	 MiM3eg10u7chiPHfhwxFD5wBXWWtKfNV+Abvw3XI=
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
Subject: [PATCH 5.4 096/202] perf annotate: Get rid of duplicate --group option item
Date: Thu, 13 Jun 2024 13:33:14 +0200
Message-ID: <20240613113231.474436149@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a6fea0be3a5d6..31ddb128b2841 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -541,8 +541,6 @@ int cmd_annotate(int argc, const char **argv)
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



