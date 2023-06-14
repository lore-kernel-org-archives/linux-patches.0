Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970381428F
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 12:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E21C433C0
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 12:28:09 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="cjMutuKW"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Fri, 16 Jun 2023 13:28:06 +0100
Resent-Message-ID: <ZIxVVjLGGJPkavb1@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 14 Jun 2023 13:15:35 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=MwGt=CC=microchip.com=Claudiu.Beznea@kernel.org>)
	id 1q9PPR-002AVu-13
	for broonie@sirena.co.uk; Wed, 14 Jun 2023 13:15:35 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 2094F60EB7
	for <broonie@sirena.co.uk>; Wed, 14 Jun 2023 12:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 972DBC433CA; Wed, 14 Jun 2023 12:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 692D5C433C8;
	Wed, 14 Jun 2023 12:15:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 692D5C433C8
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=microchip.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=microchip.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686744929; x=1718280929;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=P+MmFBvDwsbGKAJINRgeRSJGf75kuY7a6+YGCSbxmxY=;
  b=cjMutuKWSnzXfzWqlpMYjkO4mFIqdxQ76SvXXpcWB3cxv/JMcu3AGpHB
   s9QUUw836Hi0g862B++0B66D1LM/e5cgY2TK5roLu+0GOjPW2BEsduOnd
   Y5MrHRg3H2CgkvE9RZXMH0UYARsRLygD0tr61D4YMK2ldlxdTtMBWEDJ0
   9i1f6AKaaEr5doDSQCV+N9WK3VbXlGZV0rA61xcMQxHqywwZExW4m7yzr
   8D2O+nHLW70PTAWNYFwShgGXtiv91qVcu/wCc1vxMQTyBKXp0d34dlhPg
   I93fCDQGYpjXG9vtRGT/GNQnezfDClL6XZHHxhZRg7ZPxfM85ek/GZA3D
   g==;
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="217804545"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jun 2023 05:15:27 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 14 Jun 2023 05:15:27 -0700
Received: from m18063-ThinkPad-T460p.mchp-main.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Wed, 14 Jun 2023 05:15:18 -0700
From: Claudiu Beznea <claudiu.beznea@microchip.com>
To: <shengjiu.wang@gmail.com>, <Xiubo.Lee@gmail.com>, <festevam@gmail.com>,
	<nicoleotsuka@gmail.com>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
	<perex@perex.cz>, <tiwai@suse.com>, <shawnguo@kernel.org>,
	<s.hauer@pengutronix.de>, <kernel@pengutronix.de>, <linux-imx@nxp.com>,
	<viorel.suman@nxp.com>
CC: <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	Claudiu Beznea <claudiu.beznea@microchip.com>
Date: Wed, 14 Jun 2023 15:15:09 +0300
Message-ID: <20230614121509.443926-1-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=MwGt=CC=microchip.com=Claudiu.Beznea@kernel.org
Subject: [PATCH] ASoC: imx-audmix: check return value of devm_kasprintf()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: VSrYIPoBATOr

devm_kasprintf() returns a pointer to dynamically allocated memory.
Pointer could be NULL in case allocation fails. Check pointer validity.
Identified with coccinelle (kmerr.cocci script).

Fixes: b86ef5367761 ("ASoC: fsl: Add Audio Mixer machine driver")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---

Hi,

This has been addressed using kmerr.cocci script proposed for update
at [1].

Thank you,
Claudiu Beznea

[1] https://lore.kernel.org/all/20230530074044.1603426-1-claudiu.beznea@microchip.com/

 sound/soc/fsl/imx-audmix.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/fsl/imx-audmix.c b/sound/soc/fsl/imx-audmix.c
index 2c57fe9d2d08..af06268ee57b 100644
--- a/sound/soc/fsl/imx-audmix.c
+++ b/sound/soc/fsl/imx-audmix.c
@@ -228,6 +228,8 @@ static int imx_audmix_probe(struct platform_device *pdev)
 
 		dai_name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s%s",
 					  fe_name_pref, args.np->full_name + 1);
+		if (!dai_name)
+			return -ENOMEM;
 
 		dev_info(pdev->dev.parent, "DAI FE name:%s\n", dai_name);
 
@@ -236,6 +238,8 @@ static int imx_audmix_probe(struct platform_device *pdev)
 			capture_dai_name =
 				devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s %s",
 					       dai_name, "CPU-Capture");
+			if (!capture_dai_name)
+				return -ENOMEM;
 		}
 
 		priv->dai[i].cpus = &dlc[0];
@@ -263,6 +267,8 @@ static int imx_audmix_probe(struct platform_device *pdev)
 				       "AUDMIX-Playback-%d", i);
 		be_cp = devm_kasprintf(&pdev->dev, GFP_KERNEL,
 				       "AUDMIX-Capture-%d", i);
+		if (!be_name || !be_pb || !be_cp)
+			return -ENOMEM;
 
 		priv->dai[num_dai + i].cpus = &dlc[2];
 		priv->dai[num_dai + i].codecs = &dlc[3];
@@ -287,6 +293,9 @@ static int imx_audmix_probe(struct platform_device *pdev)
 		priv->dapm_routes[i].source =
 			devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s %s",
 				       dai_name, "CPU-Playback");
+		if (!priv->dapm_routes[i].source)
+			return -ENOMEM;
+
 		priv->dapm_routes[i].sink = be_pb;
 		priv->dapm_routes[num_dai + i].source   = be_pb;
 		priv->dapm_routes[num_dai + i].sink     = be_cp;
-- 
2.34.1

