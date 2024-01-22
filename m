Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EF17A720;
	Tue, 23 Jan 2024 02:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975555; cv=none; b=cMiw5vrPLvKGyKWwWrBhx+cxddbCWG0+YkTxPZuWwHFvNTixek3QbhzwRMhOUromZzpgFKspeeyH2Wx/UYWzzM1wyiOiw1bKRqDDTi0Uu+OnAyEmVyNTuzNBVdLeK80zonM1660FXCcO/UYopC2CAjMKBhDFqajkhIUsTFmCobY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975555; c=relaxed/simple;
	bh=QcGblcRyhlsvfGz0O2rWRdfQAYaT+F5oeTyXxQkXDAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=im3KdrLhRvgj6k36qwAdiv6YOh2kULgaiWIzuhYETo0A2cdJqq08ivlbK/GrL/e0uuNIJnX+MiowutV3Om9R/pj6bSgk7nkXetR4umn3sGiModo8MKqQehO1B4uzwYA6jwniZsZsCW87/rqc2slYvFBwkd5dODqjlx/MeKsr4B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aRzviFeH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRzviFeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21CEC43330;
	Tue, 23 Jan 2024 02:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975554;
	bh=QcGblcRyhlsvfGz0O2rWRdfQAYaT+F5oeTyXxQkXDAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRzviFeHbAe4RC2SEac4DTZ/OOC32kKyn/Q0wMhzySMsppgjnl5oUW+44a6EcTikw
	 XYHeoTx61EnbFyZ1cW7iulEaP7EjAzbL/sjKiHpsTKF5Gyn7ot42zmfGfYGtC8dVRD
	 pJYUVmsfcC7a/cfxGttFqSilJbvTL9t4va3oCDmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Endignoux <guillaumee@google.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 506/583] perf stat: Fix hard coded LL miss units
Date: Mon, 22 Jan 2024 15:59:17 -0800
Message-ID: <20240122235827.530393690@linuxfoundation.org>
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

[ Upstream commit f2567e12a090f0eb22553a4468d4c4fe04aad906 ]

Copy-paste error where LL cache misses are reported as l1i.

Fixes: 0a57b910807ad163 ("perf stat: Use counts rather than saved_value")
Suggested-by: Guillaume Endignoux <guillaumee@google.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20231211181242.1721059-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/stat-shadow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/stat-shadow.c b/tools/perf/util/stat-shadow.c
index 1c5c3eeba4cf..e31426167852 100644
--- a/tools/perf/util/stat-shadow.c
+++ b/tools/perf/util/stat-shadow.c
@@ -264,7 +264,7 @@ static void print_ll_miss(struct perf_stat_config *config,
 	static const double color_ratios[3] = {20.0, 10.0, 5.0};
 
 	print_ratio(config, evsel, aggr_idx, misses, out, STAT_LL_CACHE, color_ratios,
-		    "of all L1-icache accesses");
+		    "of all LL-cache accesses");
 }
 
 static void print_dtlb_miss(struct perf_stat_config *config,
-- 
2.43.0



