Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFFE7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5449FC433D6;
	Wed,  2 Nov 2022 03:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358631;
	bh=uKckqtqEkawReT+CfM7Tj5I1qAQ95pOrLwPpMkLuwsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YrC0hb6RDsgm7NASf4yh6NYmEu5g0OddCrT9zUpUjEHnJCGfClxcuvB0nrajgQ5x+
	 Rt/+WwzxB5QVJJvn250qyhPbd3btE40z7kVCjJCoNgc4lgmfa5vd5kLgbF7PcEwtly
	 vTagezwAXicoiBiToQGZg7F/Um0igCFxc1wTWICY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.garry@huawei.com>,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	James Clark <james.clark@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kajol Jain <kjain@linux.ibm.com>,
	Leo Yan <leo.yan@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Will Deacon <will@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/132] perf vendor events arm64: Fix incorrect Hisi hip08 L3 metrics
Date: Wed,  2 Nov 2022 03:33:31 +0100
Message-Id: <20221102022102.416456953@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit e9229d5b6254a75291536f582652c599957344d2 ]

Commit 0cc177cfc95d565e ("perf vendor events arm64: Add Hisi hip08 L3
metrics") add L3 metrics of hip08, but some metrics (IF_BP_MISP_BR_RET,
IF_BP_MISP_BR_RET, IF_BP_MISP_BR_BL) have incorrect event number due to
the mistakes in document, which caused incorrect result. Fix the
incorrect metrics.

Before:

  65,811,214,308	armv8_pmuv3_0/event=0x1014/	# 18.87 push_branch
  							# -40.19 other_branch
  3,564,316,780	BR_MIS_PRED				# 0.51 indirect_branch
  							# 21.81 pop_branch

After:

  6,537,146,245	BR_MIS_PRED			# 0.48 indirect_branch
  						# 0.47 pop_branch
  						# 0.00 push_branch
  						# 0.05 other_branch

Fixes: 0cc177cfc95d565e ("perf vendor events arm64: Add Hisi hip08 L3 metrics")
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Acked-by: James Clark <james.clark@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.garry@huawei.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20221021105035.10000-2-shangxiaojing@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../perf/pmu-events/arch/arm64/hisilicon/hip08/metrics.json | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/pmu-events/arch/arm64/hisilicon/hip08/metrics.json b/tools/perf/pmu-events/arch/arm64/hisilicon/hip08/metrics.json
index dda8e59149d2..be23d3c89a79 100644
--- a/tools/perf/pmu-events/arch/arm64/hisilicon/hip08/metrics.json
+++ b/tools/perf/pmu-events/arch/arm64/hisilicon/hip08/metrics.json
@@ -112,21 +112,21 @@
         "MetricName": "indirect_branch"
     },
     {
-        "MetricExpr": "(armv8_pmuv3_0@event\\=0x1014@ + armv8_pmuv3_0@event\\=0x1018@) / BR_MIS_PRED",
+        "MetricExpr": "(armv8_pmuv3_0@event\\=0x1013@ + armv8_pmuv3_0@event\\=0x1016@) / BR_MIS_PRED",
         "PublicDescription": "Push branch L3 topdown metric",
         "BriefDescription": "Push branch L3 topdown metric",
         "MetricGroup": "TopDownL3",
         "MetricName": "push_branch"
     },
     {
-        "MetricExpr": "armv8_pmuv3_0@event\\=0x100c@ / BR_MIS_PRED",
+        "MetricExpr": "armv8_pmuv3_0@event\\=0x100d@ / BR_MIS_PRED",
         "PublicDescription": "Pop branch L3 topdown metric",
         "BriefDescription": "Pop branch L3 topdown metric",
         "MetricGroup": "TopDownL3",
         "MetricName": "pop_branch"
     },
     {
-        "MetricExpr": "(BR_MIS_PRED - armv8_pmuv3_0@event\\=0x1010@ - armv8_pmuv3_0@event\\=0x1014@ - armv8_pmuv3_0@event\\=0x1018@ - armv8_pmuv3_0@event\\=0x100c@) / BR_MIS_PRED",
+        "MetricExpr": "(BR_MIS_PRED - armv8_pmuv3_0@event\\=0x1010@ - armv8_pmuv3_0@event\\=0x1013@ - armv8_pmuv3_0@event\\=0x1016@ - armv8_pmuv3_0@event\\=0x100d@) / BR_MIS_PRED",
         "PublicDescription": "Other branch L3 topdown metric",
         "BriefDescription": "Other branch L3 topdown metric",
         "MetricGroup": "TopDownL3",
-- 
2.35.1



