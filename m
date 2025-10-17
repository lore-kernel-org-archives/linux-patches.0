Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2970F2F6932;
	Fri, 17 Oct 2025 15:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714099; cv=none; b=cUZsBpH7prSMH4TNawWoJ1tm5h4s237+bkIIlIcckB8JbBH0rz5eX0BOk29uPcrzeaS2oj2jxWuG7i0lKbfYj+SYFsEuHLsotmJLzg9E+dFGRWqMUPFrBQriUlKtoKuPDcgKzhlTi8DP2FwoO58VwTDDy/e/ec8mkV00io+hNE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714099; c=relaxed/simple;
	bh=MQ5YF/6XJ/EtezATtypRl/Qf9W9YPxl8gcSOrcJfbsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSjfM4cmZCz4dOq7moZKGBELMp+5ikhAq45CcQnFzQK2Ty+4Ky0ctgwqncunLhW5K5H0WYT5oBBTA82/ZIcGdlL4G9zAkN1cWKJkeKP+Z4jRK1xi8SpM2K1Uft0d+9fqWJs/5uP3yADj76XunQ1oOG4IAoNrT3735M0EVsuZFSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hEg3wW8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hEg3wW8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A481C4CEE7;
	Fri, 17 Oct 2025 15:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714099;
	bh=MQ5YF/6XJ/EtezATtypRl/Qf9W9YPxl8gcSOrcJfbsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEg3wW8mMEQeQ6vV4SCUUSlB4d9tx37j8Qa3//0/lprDH39EP/D+40oIL5KqZrKCj
	 dWDzytIy+chRVqNwiVBVfYL3FxoYdTnD+KWQ+V24n8/JRflqCKx0k+FQtOhT73u+np
	 OltaM9jEBErjvdDPH5F5iJHDwySKboXpzavYt6uQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linux.dev>,
	Mark Rutland <mark.rutland@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Will Deacon <will@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/277] perf vendor events arm64 AmpereOneX: Fix typo - should be l1d_cache_access_prefetches
Date: Fri, 17 Oct 2025 16:50:33 +0200
Message-ID: <20251017145148.103183374@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilkka Koskinen <ilkka@os.amperecomputing.com>

[ Upstream commit 97996580da08f06f8b09a86f3384ed9fa7a52e32 ]

Add missing 'h' to l1d_cache_access_prefetces

Also fix a couple of typos and use consistent term in brief descriptions

Fixes: 16438b652b464ef7 ("perf vendor events arm64 AmpereOneX: Add core PMU events and metrics")
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linux.dev>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arch/arm64/ampere/ampereonex/metrics.json          | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/pmu-events/arch/arm64/ampere/ampereonex/metrics.json b/tools/perf/pmu-events/arch/arm64/ampere/ampereonex/metrics.json
index 5228f94a793f9..6817cac149e0b 100644
--- a/tools/perf/pmu-events/arch/arm64/ampere/ampereonex/metrics.json
+++ b/tools/perf/pmu-events/arch/arm64/ampere/ampereonex/metrics.json
@@ -113,7 +113,7 @@
     {
         "MetricName": "load_store_spec_rate",
         "MetricExpr": "LDST_SPEC / INST_SPEC",
-        "BriefDescription": "The rate of load or store instructions speculatively executed to overall instructions speclatively executed",
+        "BriefDescription": "The rate of load or store instructions speculatively executed to overall instructions speculatively executed",
         "MetricGroup": "Operation_Mix",
         "ScaleUnit": "100percent of operations"
     },
@@ -132,7 +132,7 @@
     {
         "MetricName": "pc_write_spec_rate",
         "MetricExpr": "PC_WRITE_SPEC / INST_SPEC",
-        "BriefDescription": "The rate of software change of the PC speculatively executed to overall instructions speclatively executed",
+        "BriefDescription": "The rate of software change of the PC speculatively executed to overall instructions speculatively executed",
         "MetricGroup": "Operation_Mix",
         "ScaleUnit": "100percent of operations"
     },
@@ -195,14 +195,14 @@
     {
         "MetricName": "stall_frontend_cache_rate",
         "MetricExpr": "STALL_FRONTEND_CACHE / CPU_CYCLES",
-        "BriefDescription": "Proportion of cycles stalled and no ops delivered from frontend and cache miss",
+        "BriefDescription": "Proportion of cycles stalled and no operations delivered from frontend and cache miss",
         "MetricGroup": "Stall",
         "ScaleUnit": "100percent of cycles"
     },
     {
         "MetricName": "stall_frontend_tlb_rate",
         "MetricExpr": "STALL_FRONTEND_TLB / CPU_CYCLES",
-        "BriefDescription": "Proportion of cycles stalled and no ops delivered from frontend and TLB miss",
+        "BriefDescription": "Proportion of cycles stalled and no operations delivered from frontend and TLB miss",
         "MetricGroup": "Stall",
         "ScaleUnit": "100percent of cycles"
     },
@@ -391,7 +391,7 @@
         "ScaleUnit": "100percent of cache acceses"
     },
     {
-        "MetricName": "l1d_cache_access_prefetces",
+        "MetricName": "l1d_cache_access_prefetches",
         "MetricExpr": "L1D_CACHE_PRFM / L1D_CACHE",
         "BriefDescription": "L1D cache access - prefetch",
         "MetricGroup": "Cache",
-- 
2.51.0



