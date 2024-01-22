Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0686177636;
	Tue, 23 Jan 2024 02:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975542; cv=none; b=ZwzFH+mb8znNRCNdzlu+BR53Tpvqss3hwz7gUwhhHkLWYrxnfT/z3m/XmlhaAQhSxfXa1c8DvVxTgkuD9B53Nqy4WV0dL39kjdzbMfhnEMRr0t69cgx8w1IzHqcXzxfDaxbVkxv16PBxp6L4QbQqEkPKCmszznNP+HbR29lfW+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975542; c=relaxed/simple;
	bh=xWoi+k8gPXN7cxDjgknw9yTOsgQ8bp/7mJ8MBnNzV+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrxuNKye+vCMoHVH7qQGxPnbIX19p8NtW1zLkHu5Kbt3+lvPRP/s4bH+89+p1370/K8EMgLUSSJFouD1E8QJVmkFGhKVm7aHYJZYc1ywiX15ox7nRlDLqoBAjwGqWfS1OCBwhbhxaHtLie356fHlxQOnwYFJ9k0RQp2H+RTIUxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b2Hu3o+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2Hu3o+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61AEC43399;
	Tue, 23 Jan 2024 02:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975541;
	bh=xWoi+k8gPXN7cxDjgknw9yTOsgQ8bp/7mJ8MBnNzV+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b2Hu3o+tSFFYaIcVP4L8dm1XyEFWCqHyAntRSTjkMpYHImguuBTU+l1G16pwNn8cP
	 lOtetswlQA5zXeKpahbPqo/ObPplqUMSaFjciT3JRvWgyEGQaRkeguECQ+aZ20L+Vm
	 DINNaFNc/FMzwa893oWkkr/0WuENIYv7jvM0gmks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 470/583] perf stat: Exit perf stat if parse groups fails
Date: Mon, 22 Jan 2024 15:58:41 -0800
Message-ID: <20240122235826.374185151@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 0713ab3bd169da82c35eefd012b07b715e4ebcf7 ]

Metrics were added by a callback but commit a4b8cfcabb1d90ec ("perf
stat: Delay metric parsing") postponed this to allow optimizations based
on the CPU configuration.

In doing so it stopped errors in metric parsing from causing 'perf stat'
termination.

This change adds the termination for bad metric names back in.

Fixes: a4b8cfcabb1d90ec ("perf stat: Delay metric parsing")
Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Closes: https://lore.kernel.org/lkml/ZXByT1K6enTh2EHT@kernel.org/
Link: https://lore.kernel.org/r/20231206183533.972028-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index a3af805a1d57..78c104922181 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -2695,15 +2695,19 @@ int cmd_stat(int argc, const char **argv)
 	 */
 	if (metrics) {
 		const char *pmu = parse_events_option_args.pmu_filter ?: "all";
+		int ret = metricgroup__parse_groups(evsel_list, pmu, metrics,
+						stat_config.metric_no_group,
+						stat_config.metric_no_merge,
+						stat_config.metric_no_threshold,
+						stat_config.user_requested_cpu_list,
+						stat_config.system_wide,
+						&stat_config.metric_events);
 
-		metricgroup__parse_groups(evsel_list, pmu, metrics,
-					stat_config.metric_no_group,
-					stat_config.metric_no_merge,
-					stat_config.metric_no_threshold,
-					stat_config.user_requested_cpu_list,
-					stat_config.system_wide,
-					&stat_config.metric_events);
 		zfree(&metrics);
+		if (ret) {
+			status = ret;
+			goto out;
+		}
 	}
 
 	if (add_default_attributes())
-- 
2.43.0



