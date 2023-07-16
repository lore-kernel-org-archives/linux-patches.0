Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447F08F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93CF0C433C8;
	Sun, 16 Jul 2023 20:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538493;
	bh=531KIonvJdfc0DRqDAojvyWakR17Ajh0wyuLD6V0wXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SsXsJkNpHert3LKFFqIbHGeMP3H3MMv0jdOCRlzN5NrMVxL3OCEh+bLcVpbKYceK3
	 Ow16eqOFkCPlXaVh32oD7I+8273ep2cKACvamkiKvQQVjsq6hW89pI37CIC8VlvM4F
	 0ReH1KH0eJWeXWnCXG23wSXAtxPp9e6rgmS+83xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ahmad Yasin <ahmad.yasin@intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 471/800] perf metric: Fix no group check
Date: Sun, 16 Jul 2023 21:45:24 +0200
Message-ID: <20230716195000.021306290@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit e4c4e8a538a0db071d291bc2dca487e1882a7d4f ]

The no group check fails if there is more than one meticgroup in the
metricgroup_no_group.

The first parameter of the match_metric() should be the string, while
the substring should be the second parameter.

Fixes: ccc66c6092802d68 ("perf metric: JSON flag to not group events if gathering a metric group")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ahmad Yasin <ahmad.yasin@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: https://lore.kernel.org/r/20230607162700.3234712-2-kan.liang@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/metricgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index 5e9c657dd3f7a..b659b149e5b41 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -1146,7 +1146,7 @@ static int metricgroup__add_metric_callback(const struct pmu_metric *pm,
 
 	if (pm->metric_expr && match_pm_metric(pm, data->metric_name)) {
 		bool metric_no_group = data->metric_no_group ||
-			match_metric(data->metric_name, pm->metricgroup_no_group);
+			match_metric(pm->metricgroup_no_group, data->metric_name);
 
 		data->has_match = true;
 		ret = add_metric(data->list, pm, data->modifier, metric_no_group,
-- 
2.39.2



