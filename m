Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431BA2CA1
	for <patches@lists.linux.dev>; Tue, 11 Jan 2022 17:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F083C36AE3
	for <patches@lists.linux.dev>; Tue, 11 Jan 2022 17:35:05 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KCK+d3b/"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 11 Jan 2022 17:35:02 +0000
Resent-Message-ID: <Yd2/xvhVq1CGbr/e@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 11 Jan 2022 11:06:06 +0000
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=xbrW=R3=linux.intel.com=amadeuszx.slawinski@kernel.org>)
	id 1n7EyZ-00ER1a-8N
	for broonie@sirena.co.uk; Tue, 11 Jan 2022 11:06:06 +0000
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 3BF55614DE
	for <broonie@sirena.co.uk>; Tue, 11 Jan 2022 11:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id BA560C36AE9; Tue, 11 Jan 2022 11:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4191C36AF2
	for <broonie@kernel.org>; Tue, 11 Jan 2022 11:06:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org B4191C36AF2
Authentication-Results: smtp.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641899161; x=1673435161;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dzaI2YF/XRe2vlWB2oO0pnL2x9Sn2151aMsVfg+9vpU=;
  b=KCK+d3b/kHhL3VWfJub2or1m5HW0yHqf/encsvuF2PG9TmWDDMsKJ/bR
   UFQpPjNYix4I1LFUH744B6s0KXC/1nfi/N1PVmlOOlgHI/76WBqEDHUl+
   L2AEJJUtInPWqKz0lYDUqxgOIl2qEiomjoFGFv+PFSzYrPiTVbn841pQr
   UWnpj5w5711rHcXMg9tVu64hZp1zkFFy5/6puncB0/ZAKgvQ2p4lORBRb
   XRTWJOpfVKI/wKL/nPnjGpyC4kd4V4+f3oeN2HvHznqQH2f7iHo8iNy4T
   UlZpyKN7EgQmTIVY5m2T+PcVx4ZJbcBj8rxtoQjEnD9c+tOpPeecSU1fb
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="304197147"
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="304197147"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 03:06:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="528700976"
Received: from dev2 (HELO DEV2.igk.intel.com) ([10.237.148.94])
  by orsmga008.jf.intel.com with ESMTP; 11 Jan 2022 03:05:59 -0800
From: =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>
To: Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Takashi Iwai <tiwai@suse.com>
Cc: Cezary Rojewski <cezary.rojewski@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Jaroslav Kysela <perex@perex.cz>,
	alsa-devel@alsa-project.org,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>
Date: Tue, 11 Jan 2022 20:05:28 +0100
Message-Id: <20220111190528.445248-4-amadeuszx.slawinski@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220111190528.445248-1-amadeuszx.slawinski@linux.intel.com>
References: <20220111190528.445248-1-amadeuszx.slawinski@linux.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=xbrW=R3=linux.intel.com=amadeuszx.slawinski@kernel.org
Subject: [PATCH 3/3] ASoC: topology: Optimize soc_tplg_dapm_graph_elems_load behavior
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: pIPucbcl9xty

Before commit "ASoC: topology: Change allocations to resource managed"
soc_tplg_dapm_graph_elems_load() used to free routes on error. During
migration to managed allocations the routes table was left as is, but
looking at it again it is unnecessary, so remove routes table and just
keep pointer to DAPM route currently being set up. Also remove outdated
comments which keep describing old behavior of remove_route() freeing
memory. While it still does some cleanup, it leaves freeing memory to
framework.

Fixes: ff9226224437 ("ASoC: topology: Change allocations to resource managed")
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
---
 sound/soc/soc-topology.c | 56 ++++++++++------------------------------
 1 file changed, 14 insertions(+), 42 deletions(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index 9d24184f85f9..6c7dc571c006 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1094,7 +1094,7 @@ static int soc_tplg_dapm_graph_elems_load(struct soc_tplg *tplg,
 {
 	struct snd_soc_dapm_context *dapm = &tplg->comp->dapm;
 	struct snd_soc_tplg_dapm_graph_elem *elem;
-	struct snd_soc_dapm_route **routes;
+	struct snd_soc_dapm_route *route;
 	int count, i;
 	int ret = 0;
 
@@ -1108,24 +1108,10 @@ static int soc_tplg_dapm_graph_elems_load(struct soc_tplg *tplg,
 	dev_dbg(tplg->dev, "ASoC: adding %d DAPM routes for index %d\n", count,
 		hdr->index);
 
-	/* allocate memory for pointer to array of dapm routes */
-	routes = kcalloc(count, sizeof(struct snd_soc_dapm_route *),
-			 GFP_KERNEL);
-	if (!routes)
-		return -ENOMEM;
-
-	/*
-	 * allocate memory for each dapm route in the array.
-	 * This needs to be done individually so that
-	 * each route can be freed when it is removed in remove_route().
-	 */
 	for (i = 0; i < count; i++) {
-		routes[i] = devm_kzalloc(tplg->dev, sizeof(*routes[i]), GFP_KERNEL);
-		if (!routes[i])
+		route = devm_kzalloc(tplg->dev, sizeof(*route), GFP_KERNEL);
+		if (!route)
 			return -ENOMEM;
-	}
-
-	for (i = 0; i < count; i++) {
 		elem = (struct snd_soc_tplg_dapm_graph_elem *)tplg->pos;
 		tplg->pos += sizeof(struct snd_soc_tplg_dapm_graph_elem);
 
@@ -1146,46 +1132,32 @@ static int soc_tplg_dapm_graph_elems_load(struct soc_tplg *tplg,
 			break;
 		}
 
-		routes[i]->source = elem->source;
-		routes[i]->sink = elem->sink;
+		route->source = elem->source;
+		route->sink = elem->sink;
 
 		/* set to NULL atm for tplg users */
-		routes[i]->connected = NULL;
+		route->connected = NULL;
 		if (strnlen(elem->control, SNDRV_CTL_ELEM_ID_NAME_MAXLEN) == 0)
-			routes[i]->control = NULL;
+			route->control = NULL;
 		else
-			routes[i]->control = elem->control;
+			route->control = elem->control;
 
 		/* add route dobj to dobj_list */
-		routes[i]->dobj.type = SND_SOC_DOBJ_GRAPH;
-		routes[i]->dobj.ops = tplg->ops;
-		routes[i]->dobj.index = tplg->index;
-		list_add(&routes[i]->dobj.list, &tplg->comp->dobj_list);
+		route->dobj.type = SND_SOC_DOBJ_GRAPH;
+		route->dobj.ops = tplg->ops;
+		route->dobj.index = tplg->index;
+		list_add(&route->dobj.list, &tplg->comp->dobj_list);
 
-		ret = soc_tplg_add_route(tplg, routes[i]);
+		ret = soc_tplg_add_route(tplg, route);
 		if (ret < 0) {
 			dev_err(tplg->dev, "ASoC: topology: add_route failed: %d\n", ret);
-			/*
-			 * this route was added to the list, it will
-			 * be freed in remove_route() so increment the
-			 * counter to skip it in the error handling
-			 * below.
-			 */
-			i++;
 			break;
 		}
 
 		/* add route, but keep going if some fail */
-		snd_soc_dapm_add_routes(dapm, routes[i], 1);
+		snd_soc_dapm_add_routes(dapm, route, 1);
 	}
 
-	/*
-	 * free pointer to array of dapm routes as this is no longer needed.
-	 * The memory allocated for each dapm route will be freed
-	 * when it is removed in remove_route().
-	 */
-	kfree(routes);
-
 	return ret;
 }
 
-- 
2.25.1

