Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCC652F7C;
	Tue, 23 Jan 2024 00:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969902; cv=none; b=N8ZaTS/JGYb8vpgbMcmyGGegwYkGI29UYNpIMkZAs+IAxs0A1b0U5Cg4jv2ReGYUilCI77Z8jhot7tsoa348HXbDAc6oeOx55Z8fZXhiLT4TGravhipYozwtmf25UIHIf7ehwquYzX1X5NnKt+3QdQFE2MyIVkwk/f0NOyECHA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969902; c=relaxed/simple;
	bh=vGL3tgXdhEl8W/3Ty/2WqYnu4Y2zg/Gwx+hhq/LKHOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUnn1m6uGdELCI817/RuPNMjvKAtxGiI3L23REOOrGPUSiaKCXLVwtinol1ZriqVoEANSaGQ9+JnzaWC66jUJUFp0OIgWgMQtTScY0n6iN9FFYYFJ7x6uVve4r3W40AmXbybCMq1xbjqI6z+2MV7jk+jdtK041m+qpItZZWrJ50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwsKsWj5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwsKsWj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B290C433F1;
	Tue, 23 Jan 2024 00:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969902;
	bh=vGL3tgXdhEl8W/3Ty/2WqYnu4Y2zg/Gwx+hhq/LKHOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwsKsWj5/FNtuoinwK5QcViIlziiZ2I+stdDzli04tEe3uII3JnhZlCaqedqDRqQy
	 WcacKFinrhymmCCcQtaVr3S6wCM84H5/8sOFNipyZMQu+2OgLVK0QKrZYk+gBya5EN
	 mq9P47XqTKoLNfRiinehhNeguqLQo+54r3xKKYA0=
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
Subject: [PATCH 6.7 516/641] perf vendor events arm64 AmpereOne: Rename BPU_FLUSH_MEM_FAULT to GPC_FLUSH_MEM_FAULT
Date: Mon, 22 Jan 2024 15:57:00 -0800
Message-ID: <20240122235834.234900034@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



