Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323AA77636;
	Tue, 23 Jan 2024 02:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975540; cv=none; b=rsxuqc7EwJDSMxLX7nQOeaBp55YprNP21tXy5THbdzKPfCwiqTS9kcSQlvvALStxTKJaKoAv9aTncKNwmoopjcEisweZR7uVdpBMUCsxJCRdHQpK8LUhM+vxrw2mEcglmb0r5C+QQTldytLpji19LPXGTQL5VlfpdQ+YoVz6tEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975540; c=relaxed/simple;
	bh=p73vhZquEu+p0sCxiIMF7eJu8aw5D7uRR0ffZhK4ZNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fG7jPukQ9Q7MSbaOL5tMl9SXXZ2I923ESE4+0Mb2PjtLrG+o15aL/v92IPdI0fniPhgL3uK9KMq2usbaKxrW/xamzvXx8PLIn/Fzp9eirmKKOdxhEdLcN2K373UGH+zGZZGDGPSHJXFrgwjaFkpC3Z6Wat0V9YVpdxQ+VEZxHRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFYfpqu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFYfpqu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB35C43390;
	Tue, 23 Jan 2024 02:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975540;
	bh=p73vhZquEu+p0sCxiIMF7eJu8aw5D7uRR0ffZhK4ZNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFYfpqu8yWNiHejJtgE83glnxMRSM8qEVHtqQyNjhHNnWwhSoH8WExtbL0Ew34/cu
	 nOQZImOeOjPLjeC96dXsvUkC3M8b7PJkgN3F/iDIViLmJxztr9HDJvIbwiul8O6Nrg
	 CkccXs0huXvF+ddf3gSNt27kNGKZ6KqyF/Ibqr9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Leo Yan <leo.yan@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Will Deacon <will@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 468/583] perf vendor events arm64 AmpereOne: Rename BPU_FLUSH_MEM_FAULT to GPC_FLUSH_MEM_FAULT
Date: Mon, 22 Jan 2024 15:58:39 -0800
Message-ID: <20240122235826.319793695@linuxfoundation.org>
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

From: Ilkka Koskinen <ilkka@os.amperecomputing.com>

[ Upstream commit 10a149e4b4a9187940adbfff0f216ccb5a15aa41 ]

The documentation wrongly called the event as BPU_FLUSH_MEM_FAULT and now
has been fixed. Correct the name in the perf tool as well.

Fixes: a9650b7f6fc09d16 ("perf vendor events arm64: Add AmpereOne core PMU events")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20231201021550.1109196-3-ilkka@os.amperecomputing.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pmu-events/arch/arm64/ampere/ampereone/core-imp-def.json    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/pmu-events/arch/arm64/ampere/ampereone/core-imp-def.json b/tools/perf/pmu-events/arch/arm64/ampere/ampereone/core-imp-def.json
index 88b23b85e33c..879ff21e0b17 100644
--- a/tools/perf/pmu-events/arch/arm64/ampere/ampereone/core-imp-def.json
+++ b/tools/perf/pmu-events/arch/arm64/ampere/ampereone/core-imp-def.json
@@ -110,7 +110,7 @@
     {
         "PublicDescription": "Flushes due to memory hazards",
         "EventCode": "0x121",
-        "EventName": "BPU_FLUSH_MEM_FAULT",
+        "EventName": "GPC_FLUSH_MEM_FAULT",
         "BriefDescription": "Flushes due to memory hazards"
     },
     {
-- 
2.43.0



