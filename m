Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F2812FF7B
	for <patches@lists.linux.dev>; Wed,  7 Aug 2024 22:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723068970; cv=none; b=pJCnAEu6GaWAOdUyesxnspjwEQE4NXWSba861XxZlXy1JLYdXjgWHhGCWOf8gsvqeo4bR/xtJXBdkcWlJs0jUdiZwKUU0Zi/lJJIoB5W+JNLNqpsrO+tEABL0CByNW3Ihy8S8JgGQR5GjDUFRNOhMgHjHU9HYmmfiq2KNKuES68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723068970; c=relaxed/simple;
	bh=32W4A5Lw9Ssds0txqJb5PjKZKXEXUOdMbL3wPuOoxHI=;
	h=From:To:Cc:Date:Message-Id:In-Reply-To:References:Subject; b=l+AbXnie81KEEflkC4/ftKRdb4LHFyjkIknxjkSMaBt0Msd73thankRvbFOB8B1lmUXTdpzHG8zJMNpU79W/dFF8PBtVDqxlR2tGmkbt2FgjMwfMVdER4Qtn6qwrlmUrGWNE7Kjn5NKCO/2SOc8bwndbTw1ycsfrdQgdFPZaV5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43179C4AF0D
	for <patches@lists.linux.dev>; Wed,  7 Aug 2024 22:16:08 +0000 (UTC)
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Wed, 7 Aug 2024 23:16:04 +0100
Resent-Message-ID: <ZrPyJKh9ZTAYdNfE@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 07 Aug 2024 03:54:55 +0100
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=Nwo7=PG=everest-semi.com=zhangyi@kernel.org>)
	id 1sbWpA-00AaN7-R1
	for broonie@sirena.co.uk; Wed, 07 Aug 2024 03:54:55 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id B60C861118
	for <broonie@sirena.co.uk>; Wed,  7 Aug 2024 02:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 7E799C4AF10; Wed,  7 Aug 2024 02:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E1861C32786
	for <broonie@kernel.org>; Wed,  7 Aug 2024 02:54:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org E1861C32786
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=everest-semi.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=everest-semi.com
Received: from unknown (HELO zy-virtual-machine.localdomain)([180.172.39.131])
	by sina.net (10.185.250.31) with ESMTP
	id 66B2E1C800005724; Wed, 7 Aug 2024 10:54:04 +0800 (CST)
X-Sender: zhangyi@everest-semi.com
X-Auth-ID: zhangyi@everest-semi.com
Authentication-Results: sina.net;
	 spf=none smtp.mailfrom=zhangyi@everest-semi.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=zhangyi@everest-semi.com
X-SMAIL-MID: E89D1ABF27A34DDC913154FD24B6656F
X-SMAIL-UIID: E89D1ABF27A34DDC913154FD24B6656F-20240807-105404
From: Zhang Yi <zhangyi@everest-semi.com>
To: alsa-devel@alsa-project.org,
	broonie@kernel.org
Cc: tiwai@suse.com,
	amadeuszx.slawinski@linux.intel.com,
	yangxiaohua@everest-semi.com,
	zhuning@everest-semi.com,
	zhangyi@everest-semi.com
Date: Wed,  7 Aug 2024 10:53:55 +0800
Message-Id: <20240807025356.24904-2-zhangyi@everest-semi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240807025356.24904-1-zhangyi@everest-semi.com>
References: <20240807025356.24904-1-zhangyi@everest-semi.com>
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=Nwo7=PG=everest-semi.com=zhangyi@kernel.org
Subject: [PATCH 1/2] ASoC: codecs: ES8326: button detect issue
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: 7DZdhn2TNlo5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

We find that we need to set snd_jack_types to 0. If not,
there will be a probability of button detection errors

Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
---
 sound/soc/codecs/es8326.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index 60877116c0ef..519bcd2ed00e 100755
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -844,6 +844,8 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 		es8326_disable_micbias(es8326->component);
 		if (es8326->jack->status & SND_JACK_HEADPHONE) {
 			dev_dbg(comp->dev, "Report hp remove event\n");
+			snd_soc_jack_report(es8326->jack, 0,
+				    SND_JACK_BTN_0 | SND_JACK_BTN_1 | SND_JACK_BTN_2);
 			snd_soc_jack_report(es8326->jack, 0, SND_JACK_HEADSET);
 			/* mute adc when mic path switch */
 			regmap_write(es8326->regmap, ES8326_ADC1_SRC, 0x44);
-- 
2.17.1

