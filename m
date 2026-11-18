Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025324;
	b=lvgLUmDnDqqGbTPQqdfsg5UNZszWNdvk+2NznxWyyaQDF2Xgg+Oc24vlvTxGvSdzW7ZV
	 +d9f3KF1lOIiBW+qFCbkheoKb1XyH6iPUaQyd5nLF8jLx/wppLPhCrp79IUdLCsK2C0My
	 vTW8v/CaW3YKXJ62BcmMqS4shFfOMPkleztn+6BJvmPWd2GouXHhP57wOgs7O4e7Fodgs
	 5WP4f1DFplyD8M9lVayFQnA6Yxx2+JHpthQqTvV8xVnl2TFVqmhbOXKJFdOuyMurD8D0r
	 c272DtM6gt37SPmFuMQ36XSBi8hmEo9ys/7qF+UW7CuhZv23KwgzgjEjrhHS/1bUxdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025324;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F6cTc6fDrjjZmPRmWVsRcGcuNWZbmSmqceE2X08PgsY=;
	b=d9eIk5oAaMS6jEOOnYb5fukUJfCmw2fcTM01cSMqa+eiFnQG2+zllRUORPWNMAwsxLmc
	 /dU0yeinuNpRM5WyT4wZphWYMjkqcpnUUKPDjOxL9L0+VLcCCyPX4VWnhREHvZ3ApU1H6
	 +qT7NyrY/jETeFbNXVTaHKd2FqnewxOkzx5itM0ZaW1umSLByVKDXJpv9y9IAw3/eVVe/
	 6SSIsaU4AR95E6tOkRcvEbgvjf56Zn1a9WDR6SGv1S07nPmbNkTBHVKN/v43U+c1W1Ntf
	 H1KZWdp67EztE8UsDhh4ArOWK2h6Msm82ja1zuXE2pUR2K2698uFe3rc1KmGS6Hadow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cv+mw2Oy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C78606A337;
	Wed, 18 Nov 2026 18:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cv+mw2Oy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466DB1F000CA;
	Wed, 18 Nov 2026 18:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025323;
	bh=F6cTc6fDrjjZmPRmWVsRcGcuNWZbmSmqceE2X08PgsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cv+mw2OypV7Hx11Mb9B7zRPpEG5w6ieQ7H2p3IeGX/jXUIu1Wog4gTYuU52Wk65Dl
	 crj7TaoKgmyN5aEbH9quf6LGgj0LaU8O6lZIJnMGXNL+78leX8gTVs+eD4nrX9mB7M
	 N4nASNGLj4bUp3B6UJX9y51ftmPpOLFgQA8MSuZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1039/2151] perf/cxl: Clear stale event fields before reprogramming a counter
Date: Wed, 18 Nov 2026 15:46:14 +0100
Message-ID: <20261118150200.191053675@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index eedc94616531a..7a770278f6892 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -646,17 +646,17 @@ static void cxl_pmu_event_start(struct perf_event *event, int flags)
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



