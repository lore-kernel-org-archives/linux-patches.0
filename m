Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030753;
	b=EeAL/zJVL0M7pfk0kw15A8UXyPwmMG+iN/doRK/VsPEHfmz3HOMy11LxEwIRjqQdA4py
	 J+glTjbmzlUyLlIny+0KNf1E1vdx8D7WrFYIpaMAQ1a0Ht82opsmNYlJnca1gXSmjTw5A
	 iBPPn+JrBjNCfthkT4OgLC27iDyvtHxAGhj71YiRU6MsPE4G+RTAnDs7m2Cj1frYP7G4g
	 WEqDgAse5iI+JjDpJRME2ekBjbNPpxRmg2C0NlJii2ZeRSlU6+1dEY/pPmR5PsJ7yQXzH
	 p2Y0HawaD816C3n6GjinUY3Tz/llz/xCSkjENfZa/vjqsonK7ZehgHH70jhmrTL//Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030753;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lN/Cs/nwyFOGHGnFlwUJ1Tr2vXWrjeZnU76F819aiI8=;
	b=k3WU3cz5uaAStJgEeOfHj/QbQ6qa77QLk2e3Z0dA2NvDnfe1bifJte/ZOXyRLsx8eNdK
	 pvc/dhgahtSLiflPrKaQLJu536pMtG/6PSV7DlGIUNOVOKDJ8MujabBbap7q48a96I+8/
	 BR9XPtfufww54Czlhyb1IOrxbtb/6751gM2aytdBko6Mpa+vO/9ouO5bizOxpXsM1vndG
	 dme6To+WBE69MX4lGNCMEoTeVUamiscybg+KOI5IvsAnXaXmLe9TEXh+D02z7HToitquq
	 J7fFuvFy1c0L4l0GBZErhKP6XApkhNFt5ciT20nBUKAq3gCOZdyrQ/1zVal7diMbPVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2rr4kv8q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B97B606A918;
	Wed, 18 Nov 2026 19:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2rr4kv8q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1341F000C6;
	Wed, 18 Nov 2026 19:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030753;
	bh=lN/Cs/nwyFOGHGnFlwUJ1Tr2vXWrjeZnU76F819aiI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2rr4kv8qh9xY1EMcYAtV3kAk+IoPKieVOIQVGZwWYE/jVQIeB4P6Y3OhX3hjdPbYk
	 5F1W2ODWqh+ZIxVFBMp6FujYsV6iuxvwLr0xO1fAMWMyTuhvRx8/OyI45CglW/B+fk
	 XY1skTKENoE8uCdzbggincfjxf6SJoZDnCZKEW+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0816/1756] perf/cxl: Clear stale event fields before reprogramming a counter
Date: Wed, 18 Nov 2026 15:49:03 +0100
Message-ID: <20261118150042.072862194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 7406d6cf76b1dad53084f3988dc65ab967209344 ]

cxl_pmu_event_start() ORs the event group id, event mask, edge and invert
selections into a configurable counter's config register without clearing
them first, and cxl_pmu_event_stop() leaves them set. Reuse the counter for
another event and the new selection lands on top of the old one, so the
counter counts the wrong events with stale edge and invert behaviour.

Use FIELD_MODIFY() so each field is replaced rather than accumulated.

Fixes: 5d7107c72796 ("perf: CXL Performance Monitoring Unit driver")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260715191454.459673-1-dave@stgolabs.net?part=1
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Link: https://sashiko.dev/#/patchset/20260715191454.459673-1-dave@stgolabs.net?part=1
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index 968b72dba88a0..401c7ba3efbd9 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -643,17 +643,17 @@ static void cxl_pmu_event_start(struct perf_event *event, int flags)
 	cfg |= FIELD_PREP(CXL_PMU_COUNTER_CFG_INT_ON_OVRFLW, 1);
 	cfg |= FIELD_PREP(CXL_PMU_COUNTER_CFG_FREEZE_ON_OVRFLW, 1);
 	cfg |= FIELD_PREP(CXL_PMU_COUNTER_CFG_ENABLE, 1);
-	cfg |= FIELD_PREP(CXL_PMU_COUNTER_CFG_EDGE,
-			  cxl_pmu_config1_get_edge(event) ? 1 : 0);
-	cfg |= FIELD_PREP(CXL_PMU_COUNTER_CFG_INVERT,
-			  cxl_pmu_config1_get_invert(event) ? 1 : 0);
+	FIELD_MODIFY(CXL_PMU_COUNTER_CFG_EDGE, &cfg,
+		     cxl_pmu_config1_get_edge(event) ? 1 : 0);
+	FIELD_MODIFY(CXL_PMU_COUNTER_CFG_INVERT, &cfg,
+		     cxl_pmu_config1_get_invert(event) ? 1 : 0);
 
 	/* Fixed purpose counters have next two fields RO */
 	if (test_bit(hwc->idx, info->conf_counter_bm)) {
-		cfg |= FIELD_PREP(CXL_PMU_COUNTER_CFG_EVENT_GRP_ID_IDX_MSK,
-				  hwc->event_base);
-		cfg |= FIELD_PREP(CXL_PMU_COUNTER_CFG_EVENTS_MSK,
-				  cxl_pmu_config_get_mask(event));
+		FIELD_MODIFY(CXL_PMU_COUNTER_CFG_EVENT_GRP_ID_IDX_MSK, &cfg,
+			     hwc->event_base);
+		FIELD_MODIFY(CXL_PMU_COUNTER_CFG_EVENTS_MSK, &cfg,
+			     cxl_pmu_config_get_mask(event));
 	}
 	cfg &= ~CXL_PMU_COUNTER_CFG_THRESHOLD_MSK;
 	/*
-- 
2.53.0



