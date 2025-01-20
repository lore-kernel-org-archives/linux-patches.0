Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93E41B5EBC
	for <patches@lists.linux.dev>; Mon, 20 Jan 2025 13:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737378088; cv=none; b=BIx2T9Nb8YwQM0b2AbVYSSwjYbj9IkPdTE0iBy6LQpbnrK7B33zOVIC3CWG1CUbeaW3UZ5g4S92lzfZ9uwHyvs81L83MjZV4m0PuKVNKCaXOKuazXzGMFz46AY3RcLGGN28t9krMC1WkkU9BO9ZY5vhiYW9CUQdRjs6qnKCW0/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737378088; c=relaxed/simple;
	bh=dyw6WxkcXRQ6kae7WtfQYP2kSXG9+SMOK/v2HnzNsno=;
	h=From:To:Cc:Date:Message-Id:Subject; b=NPrdcHwNUg0ioO7OWglnJnZ64yyvDAUM8EjxLGaiJN2CqRm+T/HDHlAjMP/48Q0buv0wu3GUY6GcURC54Tmv0LW8sPM5RUhfIGfx9TTJ7eytQRIdJK7ofEOAknCFII6gK+hXLtNHMtkHKl8iEqaG26Hom5DqFmFPxaBiU/DQWoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA682C4CEDD
	for <patches@lists.linux.dev>; Mon, 20 Jan 2025 13:01:27 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Mon, 20 Jan 2025 13:01:25 +0000
Resent-Message-ID: <Z45JJfAgzz6TOYZ9@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Mon, 20 Jan 2025 10:18:50 +0000
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=uoHi=UM=everest-semi.com=zhangyi@kernel.org>)
	id 1tZoro-00C8tL-4i
	for broonie@sirena.co.uk; Mon, 20 Jan 2025 10:18:50 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 400735C585B
	for <broonie@sirena.co.uk>; Mon, 20 Jan 2025 10:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 8FE5FC4CEE0; Mon, 20 Jan 2025 10:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9A854C4CEDD
	for <broonie@kernel.org>; Mon, 20 Jan 2025 10:18:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 9A854C4CEDD
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=everest-semi.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=everest-semi.com
Received: from unknown (HELO zy-virtual-machine.localdomain)([180.159.108.222])
	by sina.net (10.185.250.30) with ESMTP
	id 678E22D8000040B3; Mon, 20 Jan 2025 18:18:01 +0800 (CST)
X-Sender: zhangyi@everest-semi.com
X-Auth-ID: zhangyi@everest-semi.com
Authentication-Results: sina.net;
	 spf=none smtp.mailfrom=zhangyi@everest-semi.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=zhangyi@everest-semi.com
X-SMAIL-MID: 53ABA6FF2E194F8DAB339DDAE6BA8BFF
X-SMAIL-UIID: 53ABA6FF2E194F8DAB339DDAE6BA8BFF-20250120-181801
From: Zhang Yi <zhangyi@everest-semi.com>
To: alsa-devel@alsa-project.org,
	broonie@kernel.org
Cc: tiwai@suse.com,
	amadeuszx.slawinski@linux.intel.com,
	yangxiaohua@everest-semi.com,
	zhuning@everest-semi.com,
	zhangyi@everest-semi.com
Date: Mon, 20 Jan 2025 18:17:58 +0800
Message-Id: <20250120101758.13347-1-zhangyi@everest-semi.com>
X-Mailer: git-send-email 2.17.1
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=uoHi=UM=everest-semi.com=zhangyi@kernel.org
Subject: [PATCH] ASoC: codecs: ES8326: Improved PSRR
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: 7krhvtOxV47C
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

Modified configuration to improve PSSR when ES8326 is working

Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
---
 sound/soc/codecs/es8326.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index b06eead7e0f6..066d92b54312 100755
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -911,7 +911,7 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 			regmap_write(es8326->regmap, ES8326_INT_SOURCE,
 					(ES8326_INT_SRC_PIN9 | ES8326_INT_SRC_BUTTON));
 			regmap_write(es8326->regmap, ES8326_SYS_BIAS, 0x1f);
-			regmap_update_bits(es8326->regmap, ES8326_HP_DRIVER_REF, 0x0f, 0x08);
+			regmap_update_bits(es8326->regmap, ES8326_HP_DRIVER_REF, 0x0f, 0x0d);
 			queue_delayed_work(system_wq, &es8326->jack_detect_work,
 					msecs_to_jiffies(400));
 			es8326->hp = 1;
@@ -1023,7 +1023,7 @@ static void es8326_init(struct snd_soc_component *component)
 	struct es8326_priv *es8326 = snd_soc_component_get_drvdata(component);
 
 	regmap_write(es8326->regmap, ES8326_RESET, 0x1f);
-	regmap_write(es8326->regmap, ES8326_VMIDSEL, 0x0E);
+	regmap_write(es8326->regmap, ES8326_VMIDSEL, 0x3E);
 	regmap_write(es8326->regmap, ES8326_ANA_LP, 0xf0);
 	usleep_range(10000, 15000);
 	regmap_write(es8326->regmap, ES8326_HPJACK_TIMER, 0xd9);
-- 
2.17.1

