Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6E018AEA
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 17:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722016280; cv=none; b=aq3PzwHuTLl0s+lTnT5EtXPAeI+wOXijWigmctsq9FyyE+ShXqCU6IN9h2XhxB3wuRClYIgZH6JgWRe/cTv7MJsmTOoPiztUAnIQu/NQl9PM4hdiwPs2JkR0nh0Ex3zLwU5WF80j3Cfr4U5pVx5rK6VwmBm0aYQHC+TXOhorRRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722016280; c=relaxed/simple;
	bh=swHYojslKRZrYvYSpfXsgW3+8SF1RW/G017862frP0k=;
	h=From:To:Cc:Date:Message-Id:Subject; b=H9fYbBdUph8mP/W0dTMnMII2WU1p7+ewkFcVl3uj76Q1s1+LyNSFCvv3BUES+6zB2yamboa4y8XnheNi5Cd2QUIvwK444oal4XSLEIzighbW112r3pyes5gNlwBmgVyL+8hC0dew2aG8OTcp36FAciwVIzyZDTB0e7yipLawFj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35399C32782
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 17:51:18 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Fri, 26 Jul 2024 18:51:15 +0100
Resent-Message-ID: <ZqPiE7vsP5z1Gs_3@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Fri, 26 Jul 2024 04:12:49 +0100
Received: from sin.source.kernel.org ([145.40.73.55])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=xwDg=O2=everest-semi.com=zhangyi@kernel.org>)
	id 1sXBNu-009So7-TW
	for broonie@sirena.co.uk; Fri, 26 Jul 2024 04:12:49 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sin.source.kernel.org (Postfix) with ESMTP id EC3D1CE14E4
	for <broonie@sirena.co.uk>; Fri, 26 Jul 2024 03:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id D937BC32782; Fri, 26 Jul 2024 03:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B31F3C116B1
	for <broonie@kernel.org>; Fri, 26 Jul 2024 03:12:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org B31F3C116B1
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=everest-semi.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=everest-semi.com
Received: from unknown (HELO zy-virtual-machine.localdomain)([180.158.30.43])
	by sina.net (10.185.250.29) with ESMTP
	id 66A3138700005ABC; Fri, 26 Jul 2024 11:10:01 +0800 (CST)
X-Sender: zhangyi@everest-semi.com
X-Auth-ID: zhangyi@everest-semi.com
Authentication-Results: sina.net;
	 spf=none smtp.mailfrom=zhangyi@everest-semi.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=zhangyi@everest-semi.com
X-SMAIL-MID: 67593C547E44403DAA068D793FFD423A
X-SMAIL-UIID: 67593C547E44403DAA068D793FFD423A-20240726-111001
From: Zhang Yi <zhangyi@everest-semi.com>
To: alsa-devel@alsa-project.org,
	broonie@kernel.org
Cc: tiwai@suse.com,
	amadeuszx.slawinski@linux.intel.com,
	yangxiaohua@everest-semi.com,
	zhuning@everest-semi.com,
	zhangyi@everest-semi.com
Date: Fri, 26 Jul 2024 11:10:02 +0800
Message-Id: <20240726031002.35055-1-zhangyi@everest-semi.com>
X-Mailer: git-send-email 2.17.1
X-SA-Exim-Connect-IP: 145.40.73.55
X-SA-Exim-Mail-From: SRS0=xwDg=O2=everest-semi.com=zhangyi@kernel.org
Subject: [RESEND] ASoC: codecs: ES8326: suspend issue
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: UUsAK/MAMdKm
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

We find that we need to disable micbias for the codec to enter suspend
So We modify the trigger conditions for enable_micbias and disable_micbias

Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
---
 sound/soc/codecs/es8326.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index b246694ebb4f..60877116c0ef 100755
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -805,6 +805,7 @@ static void es8326_jack_button_handler(struct work_struct *work)
 				    SND_JACK_BTN_0 | SND_JACK_BTN_1 | SND_JACK_BTN_2);
 			button_to_report = 0;
 		}
+		es8326_disable_micbias(es8326->component);
 	}
 	mutex_unlock(&es8326->lock);
 }
@@ -878,7 +879,6 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 			regmap_write(es8326->regmap, ES8326_INT_SOURCE, 0x00);
 			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x01);
 			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x10, 0x00);
-			es8326_enable_micbias(es8326->component);
 			usleep_range(50000, 70000);
 			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x00);
 			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x10, 0x10);
@@ -897,6 +897,7 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 			dev_dbg(comp->dev, "button pressed\n");
 			regmap_write(es8326->regmap, ES8326_INT_SOURCE,
 					(ES8326_INT_SRC_PIN9 | ES8326_INT_SRC_BUTTON));
+			es8326_enable_micbias(es8326->component);
 			queue_delayed_work(system_wq, &es8326->button_press_work, 10);
 			goto exit;
 		}
@@ -1067,6 +1068,7 @@ static void es8326_init(struct snd_soc_component *component)
 
 	regmap_write(es8326->regmap, ES8326_ADC_MUTE, 0x0f);
 	regmap_write(es8326->regmap, ES8326_CLK_DIV_LRCK, 0xff);
+	es8326_disable_micbias(es8326->component);
 
 	msleep(200);
 	regmap_write(es8326->regmap, ES8326_INT_SOURCE, ES8326_INT_SRC_PIN9);
-- 
2.17.1

