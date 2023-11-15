Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303053A8F2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcRQ6RTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE9AC433C8;
	Wed, 15 Nov 2023 19:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077729;
	bh=1JFlgi9U8gs70iDNsYG+NG2bt3isV0t7/lLJutKWdlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcRQ6RTFhiR4/9R1TAQpVwugNC+zIls157MBVvPl2l5w4ZJF/T8qaZx7n6F4jtvpr
	 0ulV3gLSGGRksdmYMowWpQ3VWsC/uaHlVzlmmArCy1pufsAeMo824wc4CicYyZUT2r
	 bqIi0bVAg006Q9oDJX/Y+8JOu/ER3iYItbWrqGrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Caleb Biggers <caleb.biggers@intel.com>,
	Perry Taylor <perry.taylor@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 483/603] perf vendor events intel: Add broadwellde two metrics
Date: Wed, 15 Nov 2023 14:17:08 -0500
Message-ID: <20231115191645.802273698@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

[ Upstream commit 19a214bffdf7abb8d472895bb944d9c269ab1699 ]

Add tma_info_system_socket_clks and uncore_freq metrics that require a
broadwellx style uncore event for UNC_CLOCK.

The associated converter script fix is in:
https://github.com/intel/perfmon/pull/112

Fixes: 7d124303d620 ("perf vendor events intel: Update broadwell variant events/metrics")
Signed-off-by: Ian Rogers <irogers@google.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Cc: Caleb Biggers <caleb.biggers@intel.com>
Cc: Perry Taylor <perry.taylor@intel.com>
Link: https://lore.kernel.org/r/20230926205948.1399594-2-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arch/x86/broadwellde/bdwde-metrics.json          | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/perf/pmu-events/arch/x86/broadwellde/bdwde-metrics.json b/tools/perf/pmu-events/arch/x86/broadwellde/bdwde-metrics.json
index d0ef46c9bb612..e1f55fcfa0d02 100644
--- a/tools/perf/pmu-events/arch/x86/broadwellde/bdwde-metrics.json
+++ b/tools/perf/pmu-events/arch/x86/broadwellde/bdwde-metrics.json
@@ -48,6 +48,12 @@
         "MetricName": "C7_Pkg_Residency",
         "ScaleUnit": "100%"
     },
+    {
+        "BriefDescription": "Uncore frequency per die [GHZ]",
+        "MetricExpr": "tma_info_system_socket_clks / #num_dies / duration_time / 1e9",
+        "MetricGroup": "SoC",
+        "MetricName": "UNCORE_FREQ"
+    },
     {
         "BriefDescription": "Percentage of cycles spent in System Management Interrupts.",
         "MetricExpr": "((msr@aperf@ - cycles) / msr@aperf@ if msr@smi@ > 0 else 0)",
@@ -690,6 +696,12 @@
         "MetricGroup": "SMT",
         "MetricName": "tma_info_system_smt_2t_utilization"
     },
+    {
+        "BriefDescription": "Socket actual clocks when any core is active on that socket",
+        "MetricExpr": "cbox_0@event\\=0x0@",
+        "MetricGroup": "SoC",
+        "MetricName": "tma_info_system_socket_clks"
+    },
     {
         "BriefDescription": "Average Frequency Utilization relative nominal frequency",
         "MetricExpr": "tma_info_thread_clks / CPU_CLK_UNHALTED.REF_TSC",
-- 
2.42.0



