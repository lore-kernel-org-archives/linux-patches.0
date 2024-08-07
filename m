Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22EA155316
	for <patches@lists.linux.dev>; Wed,  7 Aug 2024 22:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723068975; cv=none; b=OoGGfvPAmvaij4LJb7/ttXt68KE9yWjX+MPTgPq68P34eFDj+1HrYQMW4psY/CMrFFYdkZ5uBRDE6cODzT/xSDAatLiZQTaXJkUc9+Ng1dF4EhNSYWNver2QTzASrVmtYGmjliIee0IS0R4YT8j883AI97AkEK1OztfIX+SG5pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723068975; c=relaxed/simple;
	bh=b66dVZykwsuCkGN9NyBLLDhHTrDpJMPU+qf5oDqlRXo=;
	h=From:To:Cc:Date:Message-Id:In-Reply-To:References:Subject; b=qUVF9EOdOMZzvR4R1HDiXlx3M94eNjs2kWSULhGdSbz4yK9K+Fuj+U3/+tbUoRmBMPjUwRgHARrM3fv9rIWUycE3Tjgp+JeFbnY4diwCX3/ycZbPBKyAyFiEhZnNtmNCsXj80zEWGSKVKVKQejd9G+4of/nc5FlgriMMGikvnwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1423C32782
	for <patches@lists.linux.dev>; Wed,  7 Aug 2024 22:16:14 +0000 (UTC)
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Wed, 7 Aug 2024 23:16:09 +0100
Resent-Message-ID: <ZrPyKSbiZPuDg6tH@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 07 Aug 2024 03:54:56 +0100
Received: from sin.source.kernel.org ([2604:1380:40e1:4800::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=Nwo7=PG=everest-semi.com=zhangyi@kernel.org>)
	id 1sbWpC-00AaND-1Z
	for broonie@sirena.co.uk; Wed, 07 Aug 2024 03:54:56 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sin.source.kernel.org (Postfix) with ESMTP id 21E20CE0FB3
	for <broonie@sirena.co.uk>; Wed,  7 Aug 2024 02:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 7E6CFC4AF0D; Wed,  7 Aug 2024 02:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1621DC4AF0C
	for <broonie@kernel.org>; Wed,  7 Aug 2024 02:54:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 1621DC4AF0C
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=everest-semi.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=everest-semi.com
Received: from unknown (HELO zy-virtual-machine.localdomain)([180.172.39.131])
	by sina.net (10.185.250.31) with ESMTP
	id 66B2E1C800005724; Wed, 7 Aug 2024 10:54:05 +0800 (CST)
X-Sender: zhangyi@everest-semi.com
X-Auth-ID: zhangyi@everest-semi.com
Authentication-Results: sina.net;
	 spf=none smtp.mailfrom=zhangyi@everest-semi.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=zhangyi@everest-semi.com
X-SMAIL-MID: 54E9821BF84642488F2BAB2C178D9550
X-SMAIL-UIID: 54E9821BF84642488F2BAB2C178D9550-20240807-105405
From: Zhang Yi <zhangyi@everest-semi.com>
To: alsa-devel@alsa-project.org,
	broonie@kernel.org
Cc: tiwai@suse.com,
	amadeuszx.slawinski@linux.intel.com,
	yangxiaohua@everest-semi.com,
	zhuning@everest-semi.com,
	zhangyi@everest-semi.com
Date: Wed,  7 Aug 2024 10:53:56 +0800
Message-Id: <20240807025356.24904-3-zhangyi@everest-semi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240807025356.24904-1-zhangyi@everest-semi.com>
References: <20240807025356.24904-1-zhangyi@everest-semi.com>
X-SA-Exim-Connect-IP: 2604:1380:40e1:4800::1
X-SA-Exim-Mail-From: SRS0=Nwo7=PG=everest-semi.com=zhangyi@kernel.org
Subject: [PATCH 2/2] ASoC: codecs: ES8326: input issue after init
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: 1jVChyALwX3/
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

We found an input issue after initiation.So we added the default
input source at initiation.

Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
---
 sound/soc/codecs/es8326.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index 519bcd2ed00e..d5362b3be484 100755
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -1070,6 +1070,8 @@ static void es8326_init(struct snd_soc_component *component)
 
 	regmap_write(es8326->regmap, ES8326_ADC_MUTE, 0x0f);
 	regmap_write(es8326->regmap, ES8326_CLK_DIV_LRCK, 0xff);
+	regmap_write(es8326->regmap, ES8326_ADC1_SRC, 0x44);
+	regmap_write(es8326->regmap, ES8326_ADC2_SRC, 0x66);
 	es8326_disable_micbias(es8326->component);
 
 	msleep(200);
-- 
2.17.1

