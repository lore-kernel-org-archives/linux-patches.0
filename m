Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51ADC6F073
	for <patches@lists.linux.dev>; Wed, 15 May 2024 12:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715775268; cv=none; b=t2awf2AmVzTjRC8uxtd17BXm1rFCyGGBAExpfKLkaTKxBIWLD+GiwDimVh9KcvjXkVkv+Qhnp+tVo0KyMkiCkWi/hXDTG3zMbR38doC9mnIulmY55c6R9qeG651oH2HrX4Zg4m3eO7dWPMTuGO2CLTq+1vXyK6UXzkk14tG67rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715775268; c=relaxed/simple;
	bh=5vvTdF84HZ5Xj8N79djUvlGKFH96u+9TgIV5IIPavf8=;
	h=From:To:Cc:Date:Message-Id:Subject; b=QvYnWmzEyrn33FA2gnbgi7ofhXH3yL2ND+9gzmJWhPVdlo7fECVLTS7Sj4MtXe1I6jB4Ccovx4FdjCFTKtZFYjmFOU4/peMvewUIGBwSFcGzUTt17ObojV88aVIDOMIHBcY6Snx0s4Comsr1QPItHPorU/VO8ElVYTbO+w4VANI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662D4C116B1
	for <patches@lists.linux.dev>; Wed, 15 May 2024 12:14:27 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Wed, 15 May 2024 13:14:24 +0100
Resent-Message-ID: <ZkSnIOEBcPkT5f5m@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 15 May 2024 07:26:09 +0100
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=oSZY=MS=everest-semi.com=zhangyi@kernel.org>)
	id 1s785W-002hQg-VZ
	for broonie@sirena.co.uk; Wed, 15 May 2024 07:26:09 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id CFF9F6134E
	for <broonie@sirena.co.uk>; Wed, 15 May 2024 06:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 9496CC116B1; Wed, 15 May 2024 06:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6CC4FC2BD11
	for <broonie@kernel.org>; Wed, 15 May 2024 06:25:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 6CC4FC2BD11
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=everest-semi.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=everest-semi.com
Received: from unknown (HELO zy-virtual-machine.localdomain)([116.233.72.63])
	by sina.net (10.75.30.239) with ESMTP
	id 6644554E00027164; Wed, 15 May 2024 14:25:19 +0800 (CST)
X-Sender: zhangyi@everest-semi.com
X-Auth-ID: zhangyi@everest-semi.com
Authentication-Results: sina.net;
	 spf=none smtp.mailfrom=zhangyi@everest-semi.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=zhangyi@everest-semi.com
X-SMAIL-MID: AB69DCD971BE4D3EB51851EB3211F295
X-SMAIL-UIID: AB69DCD971BE4D3EB51851EB3211F295-20240515-142519
From: Zhang Yi <zhangyi@everest-semi.com>
To: alsa-devel@alsa-project.org,
	broonie@kernel.org
Cc: tiwai@suse.com,
	amadeuszx.slawinski@linux.intel.com,
	yangxiaohua@everest-semi.com,
	zhuning@everest-semi.com,
	zhangyi@everest-semi.com
Date: Wed, 15 May 2024 14:25:17 +0800
Message-Id: <20240515062517.23661-1-zhangyi@everest-semi.com>
X-Mailer: git-send-email 2.17.1
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=oSZY=MS=everest-semi.com=zhangyi@kernel.org
Subject: [PATCH] ASoC: codecs: ES8326: solve hp and button detect issue
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: eqcYAfXzGMbz
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

We got an error report about headphone type detection and button detection.
We fixed the headphone type detection error by adjusting the condition
of setting es8326->hp to 0.And we fixed the button detection error by
adjusting micbias and vref.

Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
---
 sound/soc/codecs/es8326.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index 93385f181d2c..3031699a14c4 100755
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -829,8 +829,8 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 			/* mute adc when mic path switch */
 			regmap_write(es8326->regmap, ES8326_ADC1_SRC, 0x44);
 			regmap_write(es8326->regmap, ES8326_ADC2_SRC, 0x66);
-			es8326->hp = 0;
 		}
+		es8326->hp = 0;
 		regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x01);
 		regmap_write(es8326->regmap, ES8326_SYS_BIAS, 0x0a);
 		regmap_update_bits(es8326->regmap, ES8326_HP_DRIVER_REF, 0x0f, 0x03);
@@ -981,7 +981,7 @@ static int es8326_resume(struct snd_soc_component *component)
 	regmap_write(es8326->regmap, ES8326_ANA_LP, 0xf0);
 	usleep_range(10000, 15000);
 	regmap_write(es8326->regmap, ES8326_HPJACK_TIMER, 0xd9);
-	regmap_write(es8326->regmap, ES8326_ANA_MICBIAS, 0xcb);
+	regmap_write(es8326->regmap, ES8326_ANA_MICBIAS, 0xd8);
 	/* set headphone default type and detect pin */
 	regmap_write(es8326->regmap, ES8326_HPDET_TYPE, 0x83);
 	regmap_write(es8326->regmap, ES8326_CLK_RESAMPLE, 0x05);
@@ -1018,7 +1018,7 @@ static int es8326_resume(struct snd_soc_component *component)
 
 	regmap_write(es8326->regmap, ES8326_ANA_VSEL, 0x7F);
 	/* select vdda as micbias source */
-	regmap_write(es8326->regmap, ES8326_VMIDLOW, 0x23);
+	regmap_write(es8326->regmap, ES8326_VMIDLOW, 0x03);
 	/* set dac dsmclip = 1 */
 	regmap_write(es8326->regmap, ES8326_DAC_DSM, 0x08);
 	regmap_write(es8326->regmap, ES8326_DAC_VPPSCALE, 0x15);
-- 
2.17.1

