Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11026FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8BFC433C8;
	Sun, 17 Sep 2023 20:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981123;
	bh=0K3ETDvIpwxJ4t5USA8VHYGCrOE6KfAYQpW2wy0CmXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+UChdxhMTRUJV6/hAXug3kZk5v8snblxBvn6kyPy4XmlGHasMPhUOeqbxTFVJbz8
	 Xh2xFACjcJobqpJ7/sDv2ckGKlGoDtjOW0+83MPMgbPNHKdcCbMYmCcAdyZAEBF2Ac
	 n2OOiK2t455yAMY25EHPOJ9jVR27zXbbxbiZNwxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kajol Jain <kjain@linux.ibm.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Disha Goel <disgoel@linux.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/219] perf vendor events: Drop STORES_PER_INST metric event for power10 platform
Date: Sun, 17 Sep 2023 21:13:23 +0200
Message-ID: <20230917191043.728390910@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kajol Jain <kjain@linux.ibm.com>

[ Upstream commit 4836b9a85ef148c7c9779b66fab3f7279e488d90 ]

Drop STORES_PER_INST metric event for the power10 platform, as the
metric expression of STORES_PER_INST metric event using dropped event
PM_ST_FIN.

Fixes: 3ca3af7d1f230d1f ("perf vendor events power10: Add metric events JSON file for power10 platform")
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Disha Goel <disgoel@linux.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org
Link: https://lore.kernel.org/r/20230814112803.1508296-3-kjain@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/arch/powerpc/power10/metrics.json | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/perf/pmu-events/arch/powerpc/power10/metrics.json b/tools/perf/pmu-events/arch/powerpc/power10/metrics.json
index b57526fa44f2d..6e76f65c314ce 100644
--- a/tools/perf/pmu-events/arch/powerpc/power10/metrics.json
+++ b/tools/perf/pmu-events/arch/powerpc/power10/metrics.json
@@ -453,12 +453,6 @@
         "MetricGroup": "General",
         "MetricName": "LOADS_PER_INST"
     },
-    {
-        "BriefDescription": "Average number of finished stores per completed instruction",
-        "MetricExpr": "PM_ST_FIN / PM_RUN_INST_CMPL",
-        "MetricGroup": "General",
-        "MetricName": "STORES_PER_INST"
-    },
     {
         "BriefDescription": "Percentage of demand loads that reloaded from beyond the L2 per completed instruction",
         "MetricExpr": "PM_DATA_FROM_L2MISS / PM_RUN_INST_CMPL * 100",
-- 
2.40.1



