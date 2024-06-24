Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E463129A7B
	for <patches@lists.linux.dev>; Mon, 24 Jun 2024 11:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719228871; cv=none; b=Atk21yUNScUDxvCHI+BxKQWEiBzAEXvAvfTnTA/bZZaLPc4t5+YH2SZAP5WQoOy3X+oifx3lSv0oVXIqewqUgW8qShE/ezFPM7RUFYcT7C5hHRlD57eLaZVp1FoQIlJog+/4gcStN9HiUNOmfwkbN3Ubs/yWIcgtCTc1Fl5AT6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719228871; c=relaxed/simple;
	bh=5J5ZNAAJbWkqzsag62Y82/cg4YZqgDN0MGp8CKzv1Bo=;
	h=From:To:Cc:Date:Message-Id:In-Reply-To:References:Subject; b=ZUajvRCtfeVg8POGFOiodPA4CLVi3lHI1WdPJ6o4ZFHXNNs3PB9qYglCNrYLqX+6hVSl2t9RiafBcJDVoBvwpyNiwFG5eGKTbveUKFKq4rVaFoYrOh+IY79Lb6z3UKVyHW+nKC4uyZRmkkPI3XYonGE7arDdZfzltWFoxCPh7Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E18C2BBFC
	for <patches@lists.linux.dev>; Mon, 24 Jun 2024 11:34:30 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Mon, 24 Jun 2024 12:34:27 +0100
Resent-Message-ID: <ZnlZwxCXW_a9-yGR@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Mon, 24 Jun 2024 04:07:01 +0100
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=Gyrm=N2=everest-semi.com=zhangyi@kernel.org>)
	id 1sLa2l-006Y53-5p
	for broonie@sirena.co.uk; Mon, 24 Jun 2024 04:07:01 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 146AA60A29
	for <broonie@sirena.co.uk>; Mon, 24 Jun 2024 03:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id D277DC2BD10; Mon, 24 Jun 2024 03:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F068C32786
	for <broonie@kernel.org>; Mon, 24 Jun 2024 03:06:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 3F068C32786
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=everest-semi.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=everest-semi.com
Received: from unknown (HELO zy-virtual-machine.localdomain)([116.227.101.59])
	by sina.net (10.75.30.239) with ESMTP
	id 6678E2A10002B8DA; Mon, 24 Jun 2024 11:06:13 +0800 (CST)
X-Sender: zhangyi@everest-semi.com
X-Auth-ID: zhangyi@everest-semi.com
Authentication-Results: sina.net;
	 spf=none smtp.mailfrom=zhangyi@everest-semi.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=zhangyi@everest-semi.com
X-SMAIL-MID: 395BF61A51784BC0B22DCD28835C84F8
X-SMAIL-UIID: 395BF61A51784BC0B22DCD28835C84F8-20240624-110613
From: Zhang Yi <zhangyi@everest-semi.com>
To: alsa-devel@alsa-project.org,
	broonie@kernel.org
Cc: tiwai@suse.com,
	amadeuszx.slawinski@linux.intel.com,
	yangxiaohua@everest-semi.com,
	zhuning@everest-semi.com,
	zhangyi@everest-semi.com
Date: Mon, 24 Jun 2024 11:06:04 +0800
Message-Id: <20240624030607.4307-2-zhangyi@everest-semi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240624030607.4307-1-zhangyi@everest-semi.com>
References: <20240624030607.4307-1-zhangyi@everest-semi.com>
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=Gyrm=N2=everest-semi.com=zhangyi@kernel.org
Subject: [PATCH 1/4] ASoC: codecs: ES8326: Slove headphone detection issue
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: Hceb5LyWWzLb
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

We modified the headphone detection setting to avoid an error button state
after codec resume from suspend state

Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
---
 sound/soc/codecs/es8326.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index 4d87bebca5c1..8c9d79686185 100755
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -877,6 +877,8 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 		if (es8326->jack->status & SND_JACK_HEADSET) {
 			/* detect button */
 			dev_dbg(comp->dev, "button pressed\n");
+			regmap_write(es8326->regmap, ES8326_INT_SOURCE,
+					(ES8326_INT_SRC_PIN9 | ES8326_INT_SRC_BUTTON));
 			queue_delayed_work(system_wq, &es8326->button_press_work, 10);
 			goto exit;
 		}
@@ -1052,11 +1054,6 @@ static int es8326_resume(struct snd_soc_component *component)
 
 	regmap_write(es8326->regmap, ES8326_ADC_MUTE, 0x0f);
 
-	es8326->jack_remove_retry = 0;
-	es8326->hp = 0;
-	es8326->hpl_vol = 0x03;
-	es8326->hpr_vol = 0x03;
-
 	es8326_irq(es8326->irq, es8326);
 	return 0;
 }
@@ -1211,6 +1208,10 @@ static int es8326_i2c_probe(struct i2c_client *i2c)
 	}
 
 	es8326->irq = i2c->irq;
+	es8326->jack_remove_retry = 0;
+	es8326->hp = 0;
+	es8326->hpl_vol = 0x03;
+	es8326->hpr_vol = 0x03;
 	INIT_DELAYED_WORK(&es8326->jack_detect_work,
 			  es8326_jack_detect_handler);
 	INIT_DELAYED_WORK(&es8326->button_press_work,
-- 
2.17.1

