Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F134313CF98
	for <patches@lists.linux.dev>; Tue,  4 Jun 2024 12:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717502663; cv=none; b=ts/BdoHB6A4786BeU0dasH/sTblv/CRwaWB95ljnoncZsVrQ11oR2VqwpuGwZJ95Ak6hHC4qhSIkntxo0LJjptiCkYdVUz1bORgLoENPNWFxBWa/Ke/u8q1KSaJd11qMhGZJzv8qf/arG53631eJF9yAFARaaMlQ3t9Yf+gasik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717502663; c=relaxed/simple;
	bh=7CCd+ELQS0Pw7I+mbe5/2yK4WvO7RYXmFWE2193Egq4=;
	h=From:To:Cc:Date:Message-Id:Subject; b=gBNXzs0BGUC7Y0luIARimzJZYdlwrSpshq0fyGWwjZHuCVKjO+z5l2Y7PseSpXBDYKmlq6sCiNnWxZCZNwoxAjlpdDyG/fdv0EiX0KqWN62IFaSeI0M5N31Mf5xQnaU/OQx4NAY/8oOjvxDYo5Rxv+FPo3cYXQZdI9ksRNv4rwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05ECDC3277B
	for <patches@lists.linux.dev>; Tue,  4 Jun 2024 12:04:21 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 4 Jun 2024 13:04:19 +0100
Resent-Message-ID: <Zl8Cw-XKkpu-DmeX@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 04 Jun 2024 03:22:26 +0100
Received: from sin.source.kernel.org ([2604:1380:40e1:4800::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=h71I=NG=everest-semi.com=zhangyi@kernel.org>)
	id 1sEJod-004USf-T4
	for broonie@sirena.co.uk; Tue, 04 Jun 2024 03:22:26 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sin.source.kernel.org (Postfix) with ESMTP id DA24BCE0F02
	for <broonie@sirena.co.uk>; Tue,  4 Jun 2024 02:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 28BCBC32781; Tue,  4 Jun 2024 02:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D84DC2BD10
	for <broonie@kernel.org>; Tue,  4 Jun 2024 02:22:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 5D84DC2BD10
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=everest-semi.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=everest-semi.com
Received: from unknown (HELO zy-virtual-machine.localdomain)([116.233.72.63])
	by sina.net (10.75.30.235) with ESMTP
	id 665E79C30002F642; Tue, 4 Jun 2024 10:19:49 +0800 (CST)
X-Sender: zhangyi@everest-semi.com
X-Auth-ID: zhangyi@everest-semi.com
Authentication-Results: sina.net;
	 spf=none smtp.mailfrom=zhangyi@everest-semi.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=zhangyi@everest-semi.com
X-SMAIL-MID: F5FA6652DF9A444D9A15FF87BE51FAD7
X-SMAIL-UIID: F5FA6652DF9A444D9A15FF87BE51FAD7-20240604-101949
From: Zhang Yi <zhangyi@everest-semi.com>
To: alsa-devel@alsa-project.org,
	broonie@kernel.org
Cc: tiwai@suse.com,
	amadeuszx.slawinski@linux.intel.com,
	yangxiaohua@everest-semi.com,
	zhuning@everest-semi.com,
	zhangyi@everest-semi.com
Date: Tue,  4 Jun 2024 10:19:46 +0800
Message-Id: <20240604021946.2911-1-zhangyi@everest-semi.com>
X-Mailer: git-send-email 2.17.1
X-SA-Exim-Connect-IP: 2604:1380:40e1:4800::1
X-SA-Exim-Mail-From: SRS0=h71I=NG=everest-semi.com=zhangyi@kernel.org
Subject: [PATCH] ASoC: codecs: ES8326: Slove headphone detection issue
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: OnnQZG6c4Qn7
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

When switching between OMTP and CTIA headset, we can hear pop noise.
To solve this issue, We modified the configuration for headphone detection

Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
---
 sound/soc/codecs/es8326.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index 3031699a14c4..4d87bebca5c1 100755
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -857,12 +857,16 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 			 * set auto-check mode, then restart jack_detect_work after 400ms.
 			 * Don't report jack status.
 			 */
-			regmap_write(es8326->regmap, ES8326_INT_SOURCE,
-					(ES8326_INT_SRC_PIN9 | ES8326_INT_SRC_BUTTON));
+			regmap_write(es8326->regmap, ES8326_INT_SOURCE, 0x00);
 			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x01);
+			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x10, 0x00);
 			es8326_enable_micbias(es8326->component);
 			usleep_range(50000, 70000);
 			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x00);
+			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x10, 0x10);
+			usleep_range(50000, 70000);
+			regmap_write(es8326->regmap, ES8326_INT_SOURCE,
+					(ES8326_INT_SRC_PIN9 | ES8326_INT_SRC_BUTTON));
 			regmap_write(es8326->regmap, ES8326_SYS_BIAS, 0x1f);
 			regmap_update_bits(es8326->regmap, ES8326_HP_DRIVER_REF, 0x0f, 0x08);
 			queue_delayed_work(system_wq, &es8326->jack_detect_work,
-- 
2.17.1

