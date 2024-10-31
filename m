Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6356714E2C0
	for <patches@lists.linux.dev>; Thu, 31 Oct 2024 12:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730377282; cv=none; b=ppWGjkaUmblImf4vGKBQYS9+KFZx0ojx+M8v9dQXcEloyQOLIs0CVYS/KZUeAwNPatMusNpBUbx1WBk+FLqshUWT7y5rtG97U6R8JykuqQIC78uIRMkYTMsS9E2OhqQ5G3lDlX4cFKfKYRGwEc/kwfG7nnJm4or9W8acH1x7Xi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730377282; c=relaxed/simple;
	bh=KrpQz6dN8/lgtmMHr38hk5Pp+VCcqiPeVUyW8CaqxM4=;
	h=From:To:Cc:Date:Message-Id:Subject; b=swq7nd76t9cWAGNxUOm5srPNeCfoiZLQCHEecaMwzfx39gIIepIDJKIhu61O/RbXvGfDfWkL/dVbZ/RQFw0GxTfoU6n2mQZXHRSZ0vXGEs4oPF6DPcvcKJQYWzVAonrmWr/MMv84tk69dPrYBYLPZ0XlkC4Tkkxnlyl5916HnWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77751C4DE1A
	for <patches@lists.linux.dev>; Thu, 31 Oct 2024 12:21:21 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Thu, 31 Oct 2024 12:21:15 +0000
Resent-Message-ID: <ZyN2O6KJj7u6an-D@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Thu, 31 Oct 2024 06:12:46 +0000
Received: from nyc.source.kernel.org ([147.75.193.91])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=lz/L=R3=everest-semi.com=zhangyi@kernel.org>)
	id 1t6OQG-001Jl1-CV
	for broonie@sirena.co.uk; Thu, 31 Oct 2024 06:12:46 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id D5690A429F2
	for <broonie@sirena.co.uk>; Thu, 31 Oct 2024 06:10:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 503BAC4CED0; Thu, 31 Oct 2024 06:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA941C4CEC3
	for <broonie@kernel.org>; Thu, 31 Oct 2024 06:12:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org CA941C4CEC3
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=everest-semi.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=everest-semi.com
Received: from unknown (HELO zy-virtual-machine.localdomain)([180.172.39.131])
	by sina.net (10.185.250.31) with ESMTP
	id 67231D8E00002C26; Thu, 31 Oct 2024 14:02:55 +0800 (CST)
X-Sender: zhangyi@everest-semi.com
X-Auth-ID: zhangyi@everest-semi.com
Authentication-Results: sina.net;
	 spf=none smtp.mailfrom=zhangyi@everest-semi.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=zhangyi@everest-semi.com
X-SMAIL-MID: 6A4A267646FD443AB05D231171843B91
X-SMAIL-UIID: 6A4A267646FD443AB05D231171843B91-20241031-140255
From: Zhang Yi <zhangyi@everest-semi.com>
To: alsa-devel@alsa-project.org,
	broonie@kernel.org
Cc: tiwai@suse.com,
	amadeuszx.slawinski@linux.intel.com,
	yangxiaohua@everest-semi.com,
	zhuning@everest-semi.com,
	zhangyi@everest-semi.com
Date: Thu, 31 Oct 2024 14:02:53 +0800
Message-Id: <20241031060253.21001-1-zhangyi@everest-semi.com>
X-Mailer: git-send-email 2.17.1
X-SA-Exim-Connect-IP: 147.75.193.91
X-SA-Exim-Mail-From: SRS0=lz/L=R3=everest-semi.com=zhangyi@kernel.org
Subject: [PATCH] ASoC: codecs: ES8326: Reduce pop noise
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: +JrZ2MODbtqg
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

We modify the value of ES8326_ANA_MICBIAS to reduce the pop noise

Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
---
 sound/soc/codecs/es8326.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index aa3e364827c8..a5603b617688 100755
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -616,7 +616,7 @@ static int es8326_mute(struct snd_soc_dai *dai, int mute, int direction)
 					0x0F, 0x0F);
 			if (es8326->version > ES8326_VERSION_B) {
 				regmap_update_bits(es8326->regmap, ES8326_VMIDSEL, 0x40, 0x40);
-				regmap_update_bits(es8326->regmap, ES8326_ANA_MICBIAS, 0x70, 0x00);
+				regmap_update_bits(es8326->regmap, ES8326_ANA_MICBIAS, 0x70, 0x10);
 			}
 		}
 	} else {
@@ -1082,7 +1082,7 @@ static void es8326_init(struct snd_soc_component *component)
 	regmap_write(es8326->regmap, ES8326_ADC2_SRC, 0x66);
 	es8326_disable_micbias(es8326->component);
 	if (es8326->version > ES8326_VERSION_B) {
-		regmap_update_bits(es8326->regmap, ES8326_ANA_MICBIAS, 0x73, 0x03);
+		regmap_update_bits(es8326->regmap, ES8326_ANA_MICBIAS, 0x73, 0x13);
 		regmap_update_bits(es8326->regmap, ES8326_VMIDSEL, 0x40, 0x40);
 	}
 
-- 
2.17.1

