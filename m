Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49F735505A;
	Tue, 16 Dec 2025 12:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887707; cv=none; b=mfPdRY/KaoIhWafUDMuR9fleZwUF0r1XugYQecu4NCpINe32fAvck3nfqTy9q659uhuOeG5AdrB53JtonoxCEZ65Nxg2o/EO25NsvbsZa2hCeQURofHluKU9t1DiC1Ooyei5DVpQ5aGhevrt0tKeK76dSrJbWdjp+7lv6gNul2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887707; c=relaxed/simple;
	bh=WJL80oa9Sos26e96UI3OALJZqtHjlWatO1D3kkMq6DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGIa/WO1ytCp+OMhFul/AhjMUE/kt+PeMwiguhmh8yjxDGlvqVTWyUK6lV5hg+2O2ceAWMfi+Mq6CXHv5BVgF9ZNQb5YncAT2yN5PGu1fx9jkY/PO9LXb7KZqZfbzMLvsxyBeQGjGfUHuUd3KaNc9oeSFSi4fxA7R+HOvh2Od0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jBM5QgZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jBM5QgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21774C4CEF1;
	Tue, 16 Dec 2025 12:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887707;
	bh=WJL80oa9Sos26e96UI3OALJZqtHjlWatO1D3kkMq6DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1jBM5QgZJ+mqhX4o5h1rc1nxT73tt2KtyDsV8o257/lSo/wgdePCepnTcdAzwMprJ
	 deXgVaheg669N2LBRG3eGAErwmWXoIPheGIfxdmKv+khz/apjyqjhM7bufo7mZNhew
	 dVVpabbrwJsGQsW/ryukqrNyY9YPX5u5xidd2PlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 280/614] perf vendor metrics s390: Avoid has_event(INSTRUCTIONS)
Date: Tue, 16 Dec 2025 12:10:47 +0100
Message-ID: <20251216111411.519418812@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit c1932fb85af8e51ac9f6bd9947145b06c716106e ]

The instructions event is now provided in json meaning the has_event
test always succeeds. Switch to using non-legacy event names in the
affected metrics.

Reported-by: Thomas Richter <tmricht@linux.ibm.com>
Closes: https://lore.kernel.org/linux-perf-users/3e80f453-f015-4f4f-93d3-8df6bb6b3c95@linux.ibm.com/
Fixes: 0012e0fa221b ("perf jevents: Add legacy-hardware and legacy-cache json")
Signed-off-by: Ian Rogers <irogers@google.com>
Reviewed-by: Thomas Richter <tmricht@linux.ibm.com>
Tested-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/arch/s390/cf_z16/transaction.json | 8 ++++----
 tools/perf/pmu-events/arch/s390/cf_z17/transaction.json | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/pmu-events/arch/s390/cf_z16/transaction.json b/tools/perf/pmu-events/arch/s390/cf_z16/transaction.json
index 3ab1d3a6638c4..57b785307a85f 100644
--- a/tools/perf/pmu-events/arch/s390/cf_z16/transaction.json
+++ b/tools/perf/pmu-events/arch/s390/cf_z16/transaction.json
@@ -7,17 +7,17 @@
   {
     "BriefDescription": "Cycles per Instruction",
     "MetricName": "cpi",
-    "MetricExpr": "CPU_CYCLES / INSTRUCTIONS if has_event(INSTRUCTIONS) else 0"
+    "MetricExpr": "CPU_CYCLES / INSTRUCTIONS if has_event(CPU_CYCLES) else 0"
   },
   {
     "BriefDescription": "Problem State Instruction Ratio",
     "MetricName": "prbstate",
-    "MetricExpr": "(PROBLEM_STATE_INSTRUCTIONS / INSTRUCTIONS) * 100 if has_event(INSTRUCTIONS) else 0"
+    "MetricExpr": "(PROBLEM_STATE_INSTRUCTIONS / INSTRUCTIONS) * 100 if has_event(PROBLEM_STATE_INSTRUCTIONS) else 0"
   },
   {
     "BriefDescription": "Level One Miss per 100 Instructions",
     "MetricName": "l1mp",
-    "MetricExpr": "((L1I_DIR_WRITES + L1D_DIR_WRITES) / INSTRUCTIONS) * 100 if has_event(INSTRUCTIONS) else 0"
+    "MetricExpr": "((L1I_DIR_WRITES + L1D_DIR_WRITES) / INSTRUCTIONS) * 100 if has_event(L1I_DIR_WRITES) else 0"
   },
   {
     "BriefDescription": "Percentage sourced from Level 2 cache",
@@ -52,7 +52,7 @@
   {
     "BriefDescription": "Estimated Instruction Complexity CPI infinite Level 1",
     "MetricName": "est_cpi",
-    "MetricExpr": "(CPU_CYCLES / INSTRUCTIONS) - (L1C_TLB2_MISSES / INSTRUCTIONS) if has_event(INSTRUCTIONS) else 0"
+    "MetricExpr": "(CPU_CYCLES / INSTRUCTIONS) - (L1C_TLB2_MISSES / INSTRUCTIONS) if has_event(CPU_CYCLES) else 0"
   },
   {
     "BriefDescription": "Estimated Sourcing Cycles per Level 1 Miss",
diff --git a/tools/perf/pmu-events/arch/s390/cf_z17/transaction.json b/tools/perf/pmu-events/arch/s390/cf_z17/transaction.json
index 74df533c8b6fa..7ded6a5a76c0f 100644
--- a/tools/perf/pmu-events/arch/s390/cf_z17/transaction.json
+++ b/tools/perf/pmu-events/arch/s390/cf_z17/transaction.json
@@ -7,17 +7,17 @@
   {
     "BriefDescription": "Cycles per Instruction",
     "MetricName": "cpi",
-    "MetricExpr": "CPU_CYCLES / INSTRUCTIONS if has_event(INSTRUCTIONS) else 0"
+    "MetricExpr": "CPU_CYCLES / INSTRUCTIONS if has_event(CPU_CYCLES) else 0"
   },
   {
     "BriefDescription": "Problem State Instruction Ratio",
     "MetricName": "prbstate",
-    "MetricExpr": "(PROBLEM_STATE_INSTRUCTIONS / INSTRUCTIONS) * 100 if has_event(INSTRUCTIONS) else 0"
+    "MetricExpr": "(PROBLEM_STATE_INSTRUCTIONS / INSTRUCTIONS) * 100 if has_event(PROBLEM_STATE_INSTRUCTIONS) else 0"
   },
   {
     "BriefDescription": "Level One Miss per 100 Instructions",
     "MetricName": "l1mp",
-    "MetricExpr": "((L1I_DIR_WRITES + L1D_DIR_WRITES) / INSTRUCTIONS) * 100 if has_event(INSTRUCTIONS) else 0"
+    "MetricExpr": "((L1I_DIR_WRITES + L1D_DIR_WRITES) / INSTRUCTIONS) * 100 if has_event(L1I_DIR_WRITES) else 0"
   },
   {
     "BriefDescription": "Percentage sourced from Level 2 cache",
@@ -52,7 +52,7 @@
   {
     "BriefDescription": "Estimated Instruction Complexity CPI infinite Level 1",
     "MetricName": "est_cpi",
-    "MetricExpr": "(CPU_CYCLES / INSTRUCTIONS) - (L1C_TLB2_MISSES / INSTRUCTIONS) if has_event(INSTRUCTIONS) else 0"
+    "MetricExpr": "(CPU_CYCLES / INSTRUCTIONS) - (L1C_TLB2_MISSES / INSTRUCTIONS) if has_event(L1C_TLB2_MISSES) else 0"
   },
   {
     "BriefDescription": "Estimated Sourcing Cycles per Level 1 Miss",
-- 
2.51.0



