Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4156A22A7E4;
	Fri, 17 Oct 2025 15:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714940; cv=none; b=Jvt3og4eIRD2URQYv1th/gEzGLT3L50+lmMBp1LfP8uRFC1O/vfOwwD6ZyKKaAz33XQ0nk5+O9ySwyJeqy/wRGxbhjBw0AUJLBJjbIEMmHups06fc8A1Nx4841ndUFe/L6f6zvy8ZFOFiP013YWJXnHqtm0Rk0DqTcVFv27ade4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714940; c=relaxed/simple;
	bh=D/lfiUlAzKmfw12UlGMiuSxy97z8EmONry7X9AehNFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YduQ2CrbygkgP02SRDelXDGx/9WVtgryf2L7yBJOxUqpZtH7WG6gDB6it9hJgfyrg3jya3oxy5LB/iB4o5Q8agO/4I2vS/uNknL32fjLHx6X2WhJnpLpIJr3Krtz31QDQlf8EFE4+bwMpyNi8gM2DkqPMEo+hPK5XYUx6Aaa9Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCe4xWaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCe4xWaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97516C4CEFE;
	Fri, 17 Oct 2025 15:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714940;
	bh=D/lfiUlAzKmfw12UlGMiuSxy97z8EmONry7X9AehNFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FCe4xWaCi3RhlQnUxVDA557YGND6+WT/cpFla7EeEcUGQjCQmHGvIRfKn/nL8bkRC
	 h5CgSI3AdP5gvkj6TNgSGffx+vGGpyRx6sQ639gqu8ExCsdVkEBUZhJJKU+6qW1EV3
	 sn12TguJInu20qL9cgrkE80EF60QmV6C7o3wKGz4=
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
Subject: [PATCH 6.17 041/371] perf vendor events arm64 AmpereOneX: Fix typo - should be l1d_cache_access_prefetches
Date: Fri, 17 Oct 2025 16:50:16 +0200
Message-ID: <20251017145203.286627071@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



