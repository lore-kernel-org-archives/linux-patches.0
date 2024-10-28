Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979241D79B1
	for <patches@lists.linux.dev>; Mon, 28 Oct 2024 12:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730118034; cv=none; b=u1DAaIcSl1Oq6sxM/UZ/HcoV54zcUkrkAwSwxPQhEl80de+2vOKpKj0XQYq52Rd/6vIzyR0OOhpspOHbp7QhNw4iVnKeU2jEWP2rDRb2+GfVW0Fs8WZW0yEEfuUT2UH80mf71O6GphRTi+STjIPo/7ZetkMu0IDsjK7QklEIHqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730118034; c=relaxed/simple;
	bh=ZQpUc8rr8drZvAGg91DuY87mkamn5CvVszxJpLlQRhs=;
	h=From:To:Cc:Date:Message-Id:Subject; b=eYT+tq1/PHMRaLS+ANYKyf2JtL28ZkTqNaj1+G37EVN97uLY0EjffQzL1HTKOzHqLfXM/AC4L8A5Y6FRVlZqzwjmVSp4zj9IuXDvSdrFMNG9CKlVanYT1/6w62csAgDsnYQC/72UhsBYYQ7FgugSrzsmuWE/TQkge7hTqRVqbEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0826C4CEC3
	for <patches@lists.linux.dev>; Mon, 28 Oct 2024 12:20:33 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Mon, 28 Oct 2024 12:20:30 +0000
Resent-Message-ID: <Zx-Bjg0esy1lP1H0@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Mon, 28 Oct 2024 06:11:07 +0000
Received: from nyc.source.kernel.org ([147.75.193.91])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=ZuRb=RY=everest-semi.com=zhangyi@kernel.org>)
	id 1t5Iy1-000sO0-2R
	for broonie@sirena.co.uk; Mon, 28 Oct 2024 06:11:07 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 23B6FA417D4
	for <broonie@sirena.co.uk>; Mon, 28 Oct 2024 06:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id EFBCEC4CEE8; Mon, 28 Oct 2024 06:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86D17C4CECD
	for <broonie@kernel.org>; Mon, 28 Oct 2024 06:10:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 86D17C4CECD
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=everest-semi.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=everest-semi.com
Received: from unknown (HELO zy-virtual-machine.localdomain)([180.172.39.131])
	by sina.net (10.185.250.30) with ESMTP
	id 671F29A900006BE1; Mon, 28 Oct 2024 14:05:30 +0800 (CST)
X-Sender: zhangyi@everest-semi.com
X-Auth-ID: zhangyi@everest-semi.com
Authentication-Results: sina.net;
	 spf=none smtp.mailfrom=zhangyi@everest-semi.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=zhangyi@everest-semi.com
X-SMAIL-MID: AEF74285FCFE4222BA9CFBCC107CB715
X-SMAIL-UIID: AEF74285FCFE4222BA9CFBCC107CB715-20241028-140530
From: Zhang Yi <zhangyi@everest-semi.com>
To: alsa-devel@alsa-project.org,
	broonie@kernel.org
Cc: tiwai@suse.com,
	amadeuszx.slawinski@linux.intel.com,
	yangxiaohua@everest-semi.com,
	zhuning@everest-semi.com,
	zhangyi@everest-semi.com
Date: Mon, 28 Oct 2024 14:05:29 +0800
Message-Id: <20241028060529.3359-1-zhangyi@everest-semi.com>
X-Mailer: git-send-email 2.17.1
X-SA-Exim-Connect-IP: 147.75.193.91
X-SA-Exim-Mail-From: SRS0=ZuRb=RY=everest-semi.com=zhangyi@kernel.org
Subject: [PATCH] ASoC: codecs: ES8326: Modify the configuration of and micbias
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: PkUjUvNGvRKI
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

Because we designed a new version of ES8326, the configuration of
micbias needed to be modified.We tested the new driver,
on both the new version and the old one. It works well.

Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
---
 sound/soc/codecs/es8326.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index d5362b3be484..aa3e364827c8 100755
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -614,6 +614,10 @@ static int es8326_mute(struct snd_soc_dai *dai, int mute, int direction)
 		} else {
 			regmap_update_bits(es8326->regmap,  ES8326_ADC_MUTE,
 					0x0F, 0x0F);
+			if (es8326->version > ES8326_VERSION_B) {
+				regmap_update_bits(es8326->regmap, ES8326_VMIDSEL, 0x40, 0x40);
+				regmap_update_bits(es8326->regmap, ES8326_ANA_MICBIAS, 0x70, 0x00);
+			}
 		}
 	} else {
 		if (!es8326->calibrated) {
@@ -640,6 +644,10 @@ static int es8326_mute(struct snd_soc_dai *dai, int mute, int direction)
 					ES8326_MUTE_MASK, ~(ES8326_MUTE));
 		} else {
 			msleep(300);
+			if (es8326->version > ES8326_VERSION_B) {
+				regmap_update_bits(es8326->regmap, ES8326_ANA_MICBIAS, 0x70, 0x50);
+				regmap_update_bits(es8326->regmap, ES8326_VMIDSEL, 0x40, 0x00);
+			}
 			regmap_update_bits(es8326->regmap,  ES8326_ADC_MUTE,
 					0x0F, 0x00);
 		}
@@ -821,7 +829,7 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 	iface = snd_soc_component_read(comp, ES8326_HPDET_STA);
 	dev_dbg(comp->dev, "gpio flag %#04x", iface);
 
-	if ((es8326->jack_remove_retry == 1) && (es8326->version != ES8326_VERSION_B)) {
+	if ((es8326->jack_remove_retry == 1) && (es8326->version < ES8326_VERSION_B)) {
 		if (iface & ES8326_HPINSERT_FLAG)
 			es8326->jack_remove_retry = 2;
 		else
@@ -859,7 +867,7 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 		/*
 		 * Inverted HPJACK_POL bit to trigger one IRQ to double check HP Removal event
 		 */
-		if ((es8326->jack_remove_retry == 0) && (es8326->version != ES8326_VERSION_B)) {
+		if ((es8326->jack_remove_retry == 0) && (es8326->version < ES8326_VERSION_B)) {
 			es8326->jack_remove_retry = 1;
 			dev_dbg(comp->dev, "remove event check, invert HPJACK_POL, cnt = %d\n",
 					es8326->jack_remove_retry);
@@ -954,7 +962,7 @@ static int es8326_calibrate(struct snd_soc_component *component)
 	regmap_read(es8326->regmap, ES8326_CHIP_VERSION, &reg);
 	es8326->version = reg;
 
-	if ((es8326->version == ES8326_VERSION_B) && (es8326->calibrated == false)) {
+	if ((es8326->version >= ES8326_VERSION_B) && (es8326->calibrated == false)) {
 		dev_dbg(component->dev, "ES8326_VERSION_B, calibrating\n");
 		regmap_write(es8326->regmap, ES8326_CLK_INV, 0xc0);
 		regmap_write(es8326->regmap, ES8326_CLK_DIV1, 0x03);
@@ -1047,7 +1055,7 @@ static void es8326_init(struct snd_soc_component *component)
 	regmap_write(es8326->regmap, ES8326_DAC_VPPSCALE, 0x15);
 
 	regmap_write(es8326->regmap, ES8326_HPDET_TYPE, 0x80 |
-			((es8326->version == ES8326_VERSION_B) ?
+			((es8326->version >= ES8326_VERSION_B) ?
 			(ES8326_HP_DET_SRC_PIN9 | es8326->jack_pol) :
 			(ES8326_HP_DET_SRC_PIN9 | es8326->jack_pol | 0x04)));
 	usleep_range(5000, 10000);
@@ -1073,6 +1081,10 @@ static void es8326_init(struct snd_soc_component *component)
 	regmap_write(es8326->regmap, ES8326_ADC1_SRC, 0x44);
 	regmap_write(es8326->regmap, ES8326_ADC2_SRC, 0x66);
 	es8326_disable_micbias(es8326->component);
+	if (es8326->version > ES8326_VERSION_B) {
+		regmap_update_bits(es8326->regmap, ES8326_ANA_MICBIAS, 0x73, 0x03);
+		regmap_update_bits(es8326->regmap, ES8326_VMIDSEL, 0x40, 0x40);
+	}
 
 	msleep(200);
 	regmap_write(es8326->regmap, ES8326_INT_SOURCE, ES8326_INT_SRC_PIN9);
-- 
2.17.1

