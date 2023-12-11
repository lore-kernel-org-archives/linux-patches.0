Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAB6524BC;
	Mon, 11 Dec 2023 18:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5izeg6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C414DC433CB;
	Mon, 11 Dec 2023 18:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319687;
	bh=EccqGt9ngvOByeP2yk3MKQyP7N89y7SKJRh5dBm4FNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5izeg6NWQZVDmf27YmB0JOZrfipBqgEgd1FHnAuSYAC4N8kksuvY3pO8Fovycpzt
	 dI7FDr4iR/3SJoyp0xNscnbH2L/mZfPF6EwgEuxQiwcqY+fqi3toCY30KmgcPKlfKi
	 H6LJMeqIG8yXPRxSjVHz45aOWxsi4CBwcO9TwbBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@arm.com>,
	Will Deacon <will@kernel.org>,
	Leo Yan <leo.yan@linaro.org>,
	Mike Leach <mike.leach@linaro.org>,
	John Garry <john.g.garry@oracle.com>,
	linux-arm-kernel@lists.infradead.org,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 197/244] perf vendor events arm64: AmpereOne: Add missing DefaultMetricgroupName fields
Date: Mon, 11 Dec 2023 19:21:30 +0100
Message-ID: <20231211182054.781810722@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Ilkka Koskinen <ilkka@os.amperecomputing.com>

[ Upstream commit 90fe70d4e23cb57253d2668a171d5695c332deb7 ]

AmpereOne metrics were missing DefaultMetricgroupName from metrics with
"Default" in group name resulting perf to segfault. Add the missing
field to address the issue.

Fixes: 59faeaf80d02 ("perf vendor events arm64: Fix for AmpereOne metrics")
Signed-off-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: linux-arm-kernel@lists.infradead.org
Link: https://lore.kernel.org/r/20231201021550.1109196-2-ilkka@os.amperecomputing.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/arch/arm64/ampere/ampereone/metrics.json | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/pmu-events/arch/arm64/ampere/ampereone/metrics.json b/tools/perf/pmu-events/arch/arm64/ampere/ampereone/metrics.json
index e2848a9d48487..afcdad58ef89c 100644
--- a/tools/perf/pmu-events/arch/arm64/ampere/ampereone/metrics.json
+++ b/tools/perf/pmu-events/arch/arm64/ampere/ampereone/metrics.json
@@ -231,6 +231,7 @@
         "MetricName": "slots_lost_misspeculation_fraction",
         "MetricExpr": "100 * ((OP_SPEC - OP_RETIRED) / (CPU_CYCLES * #slots))",
         "BriefDescription": "Fraction of slots lost due to misspeculation",
+        "DefaultMetricgroupName": "TopdownL1",
         "MetricGroup": "Default;TopdownL1",
         "ScaleUnit": "1percent of slots"
     },
@@ -238,6 +239,7 @@
         "MetricName": "retired_fraction",
         "MetricExpr": "100 * (OP_RETIRED / (CPU_CYCLES * #slots))",
         "BriefDescription": "Fraction of slots retiring, useful work",
+        "DefaultMetricgroupName": "TopdownL1",
         "MetricGroup": "Default;TopdownL1",
 	"ScaleUnit": "1percent of slots"
     },
-- 
2.42.0



