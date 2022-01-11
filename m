Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBCE2CA1
	for <patches@lists.linux.dev>; Tue, 11 Jan 2022 17:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95CFC36AE3
	for <patches@lists.linux.dev>; Tue, 11 Jan 2022 17:34:57 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F61Sr/pN"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 11 Jan 2022 17:34:54 +0000
Resent-Message-ID: <Yd2/vrcj9e/bNRtb@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 11 Jan 2022 11:06:02 +0000
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=xbrW=R3=linux.intel.com=amadeuszx.slawinski@kernel.org>)
	id 1n7EyV-00ER1M-2w
	for broonie@sirena.co.uk; Tue, 11 Jan 2022 11:06:02 +0000
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id F10A06159D
	for <broonie@sirena.co.uk>; Tue, 11 Jan 2022 11:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 74EE9C36AE9; Tue, 11 Jan 2022 11:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 587DAC36AE3
	for <broonie@kernel.org>; Tue, 11 Jan 2022 11:05:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 587DAC36AE3
Authentication-Results: smtp.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641899157; x=1673435157;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OtbOL6czH+V9UwzRDcJLW274jPXhpIq7QfZpEbgwKCE=;
  b=F61Sr/pNg4zwDvOUO94Q69QmVZN1ubRVGH9MxWE1YfDzQ0O8+cztpxNb
   92wcX2x5fMqX1RJPzVoKCKBhjQJSyWs1ZoNDh4WzlGDBUL8YPsHuO2pw0
   vdVen7vCmaFq4mNR2vnnIv6iqjT+VXcaMDtz6dhzbOHsTX/nAzm9H8wsE
   TPjwEVSJZ7TvxmHF3Lysvn1gXTIJiyM85xMCL+LCcpaCBjkRhBwoaYTIK
   KfDNjDMWFv+ILXgO5Q8qTA/GznJzTV4dZeg3dYmt9Uh6p74rOIUJmy7sw
   zN7f2YqShM0+CN1wAElHQ4Fk7S23fAQFDaiDtFmhzlN+vBxZ54npn4NF5
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="304197131"
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="304197131"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 03:05:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="528700936"
Received: from dev2 (HELO DEV2.igk.intel.com) ([10.237.148.94])
  by orsmga008.jf.intel.com with ESMTP; 11 Jan 2022 03:05:55 -0800
From: =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>
To: Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Takashi Iwai <tiwai@suse.com>
Cc: Cezary Rojewski <cezary.rojewski@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Jaroslav Kysela <perex@perex.cz>,
	alsa-devel@alsa-project.org,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>
Date: Tue, 11 Jan 2022 20:05:26 +0100
Message-Id: <20220111190528.445248-2-amadeuszx.slawinski@linux.intel.com>
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
Subject: [PATCH 1/3] ASoC: topology: Remove superfluous error prints
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: gz5fMfxszCN3

soc_tplg_check_elem_count(), already prints an error when applicable, so
there is no need to print another one.

Also clean up alignment of arguments in if, so there is no confusion
about what is checked and what is executed if condition is true.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
---
 sound/soc/soc-topology.c | 44 ++++++++++------------------------------
 1 file changed, 11 insertions(+), 33 deletions(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index 078e1dc19ca6..e0f72ddd72c1 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -685,12 +685,9 @@ static int soc_tplg_dbytes_create(struct soc_tplg *tplg, unsigned int count,
 	int err = 0;
 
 	if (soc_tplg_check_elem_count(tplg,
-		sizeof(struct snd_soc_tplg_bytes_control), count,
-			size, "mixer bytes")) {
-		dev_err(tplg->dev, "ASoC: Invalid count %d for byte control\n",
-			count);
+				      sizeof(struct snd_soc_tplg_bytes_control),
+				      count, size, "mixer bytes"))
 		return -EINVAL;
-	}
 
 	for (i = 0; i < count; i++) {
 		be = (struct snd_soc_tplg_bytes_control *)tplg->pos;
@@ -763,13 +760,9 @@ static int soc_tplg_dmixer_create(struct soc_tplg *tplg, unsigned int count,
 	int err = 0;
 
 	if (soc_tplg_check_elem_count(tplg,
-		sizeof(struct snd_soc_tplg_mixer_control),
-		count, size, "mixers")) {
-
-		dev_err(tplg->dev, "ASoC: invalid count %d for controls\n",
-			count);
+				      sizeof(struct snd_soc_tplg_mixer_control),
+				      count, size, "mixers"))
 		return -EINVAL;
-	}
 
 	for (i = 0; i < count; i++) {
 		mc = (struct snd_soc_tplg_mixer_control *)tplg->pos;
@@ -927,13 +920,9 @@ static int soc_tplg_denum_create(struct soc_tplg *tplg, unsigned int count,
 	int err = 0;
 
 	if (soc_tplg_check_elem_count(tplg,
-		sizeof(struct snd_soc_tplg_enum_control),
-		count, size, "enums")) {
-
-		dev_err(tplg->dev, "ASoC: invalid count %d for enum controls\n",
-			count);
+				      sizeof(struct snd_soc_tplg_enum_control),
+				      count, size, "enums"))
 		return -EINVAL;
-	}
 
 	for (i = 0; i < count; i++) {
 		ec = (struct snd_soc_tplg_enum_control *)tplg->pos;
@@ -1111,13 +1100,9 @@ static int soc_tplg_dapm_graph_elems_load(struct soc_tplg *tplg,
 	count = le32_to_cpu(hdr->count);
 
 	if (soc_tplg_check_elem_count(tplg,
-		sizeof(struct snd_soc_tplg_dapm_graph_elem),
-		count, le32_to_cpu(hdr->payload_size), "graph")) {
-
-		dev_err(tplg->dev, "ASoC: invalid count %d for DAPM routes\n",
-			count);
+				      sizeof(struct snd_soc_tplg_dapm_graph_elem),
+				      count, le32_to_cpu(hdr->payload_size), "graph"))
 		return -EINVAL;
-	}
 
 	dev_dbg(tplg->dev, "ASoC: adding %d DAPM routes for index %d\n", count,
 		hdr->index);
@@ -1965,11 +1950,8 @@ static int soc_tplg_pcm_elems_load(struct soc_tplg *tplg,
 	if (soc_tplg_check_elem_count(tplg,
 				      size, count,
 				      le32_to_cpu(hdr->payload_size),
-				      "PCM DAI")) {
-		dev_err(tplg->dev, "ASoC: invalid count %d for PCM DAI elems\n",
-			count);
+				      "PCM DAI"))
 		return -EINVAL;
-	}
 
 	for (i = 0; i < count; i++) {
 		pcm = (struct snd_soc_tplg_pcm *)tplg->pos;
@@ -2243,14 +2225,10 @@ static int soc_tplg_link_elems_load(struct soc_tplg *tplg,
 		return -EINVAL;
 	}
 
-	if (soc_tplg_check_elem_count(tplg,
-				      size, count,
+	if (soc_tplg_check_elem_count(tplg, size, count,
 				      le32_to_cpu(hdr->payload_size),
-				      "physical link config")) {
-		dev_err(tplg->dev, "ASoC: invalid count %d for physical link elems\n",
-			count);
+				      "physical link config"))
 		return -EINVAL;
-	}
 
 	/* config physical DAI links */
 	for (i = 0; i < count; i++) {
-- 
2.25.1

