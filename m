Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933FA13A884
	for <patches@lists.linux.dev>; Mon, 24 Jun 2024 11:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719228882; cv=none; b=sQlqoTHTGilRnUMixtND3AO4tnIvWRs1eUTXocI2uAX6bXTI0dxP8DoWccGdtQI2tFC1D0uNN2iv5eVllGgXlzO6hFnHkGN1YC6mu32M06WlNEqZcCUTPD6mYA/ieVqRL+3p26qEamiX/g052AbspYr/XDpJsTxrIVwWDXL8Xgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719228882; c=relaxed/simple;
	bh=aKjfunUPatqAejqdZtGwl92h5nzm1QwzOHxT5bISx3M=;
	h=From:To:Cc:Date:Message-Id:In-Reply-To:References:Subject; b=YLlBloQ2G+XSQ3N72XtXT3GEPdpLI4HA7HEoFlRs0S44nYYHd+7/06d5Vqsj80/MxymtbZCrjbeC1XLzz5F/uxRjwCuerHmOKyBMGF3Lfmvz9kxH9qqzMf1VZ7onogAUUdQV+2e50hb4+HFs5jAFmu2j5sJIZOPV1FgpwfcrI7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B031EC2BBFC
	for <patches@lists.linux.dev>; Mon, 24 Jun 2024 11:34:40 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Mon, 24 Jun 2024 12:34:38 +0100
Resent-Message-ID: <ZnlZzi5_0HdOasE1@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Mon, 24 Jun 2024 04:07:03 +0100
Received: from sin.source.kernel.org ([2604:1380:40e1:4800::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=Gyrm=N2=everest-semi.com=zhangyi@kernel.org>)
	id 1sLa2n-006Y5C-JI
	for broonie@sirena.co.uk; Mon, 24 Jun 2024 04:07:03 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sin.source.kernel.org (Postfix) with ESMTP id 6376CCE1018
	for <broonie@sirena.co.uk>; Mon, 24 Jun 2024 03:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 9ABD4C4AF0A; Mon, 24 Jun 2024 03:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1AE3BC4AF09
	for <broonie@kernel.org>; Mon, 24 Jun 2024 03:06:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 1AE3BC4AF09
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=everest-semi.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=everest-semi.com
Received: from unknown (HELO zy-virtual-machine.localdomain)([116.227.101.59])
	by sina.net (10.75.30.239) with ESMTP
	id 6678E2A10002B8DA; Mon, 24 Jun 2024 11:06:16 +0800 (CST)
X-Sender: zhangyi@everest-semi.com
X-Auth-ID: zhangyi@everest-semi.com
Authentication-Results: sina.net;
	 spf=none smtp.mailfrom=zhangyi@everest-semi.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=zhangyi@everest-semi.com
X-SMAIL-MID: C96BF33DB7C74C91AC49603CE80D6180
X-SMAIL-UIID: C96BF33DB7C74C91AC49603CE80D6180-20240624-110616
From: Zhang Yi <zhangyi@everest-semi.com>
To: alsa-devel@alsa-project.org,
	broonie@kernel.org
Cc: tiwai@suse.com,
	amadeuszx.slawinski@linux.intel.com,
	yangxiaohua@everest-semi.com,
	zhuning@everest-semi.com,
	zhangyi@everest-semi.com
Date: Mon, 24 Jun 2024 11:06:07 +0800
Message-Id: <20240624030607.4307-5-zhangyi@everest-semi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240624030607.4307-1-zhangyi@everest-semi.com>
References: <20240624030607.4307-1-zhangyi@everest-semi.com>
X-SA-Exim-Connect-IP: 2604:1380:40e1:4800::1
X-SA-Exim-Mail-From: SRS0=Gyrm=N2=everest-semi.com=zhangyi@kernel.org
Subject: [PATCH 4/4] ASoC: codecs: ES8326: regcache_sync error issue
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: paoYwioiCH7F
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

We modified the regmap_config members to fix cach sync error.
There are several registers that should be read-only registers.
If these registers are written while synchronizing the register values,
the codec will enter an error state.So we create es8326_writeable_register,
and set these registers to false

Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
---
 sound/soc/codecs/es8326.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index 4f10ab5394ec..d209865be9e1 100755
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -327,11 +327,29 @@ static bool es8326_volatile_register(struct device *dev, unsigned int reg)
 	}
 }
 
+static bool es8326_writeable_register(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case ES8326_BIAS_SW1:
+	case ES8326_BIAS_SW2:
+	case ES8326_BIAS_SW3:
+	case ES8326_BIAS_SW4:
+	case ES8326_ADC_HPFS1:
+	case ES8326_ADC_HPFS2:
+		return false;
+	default:
+		return true;
+	}
+}
+
 static const struct regmap_config es8326_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 	.max_register = 0xff,
+	.use_single_read = true,
+	.use_single_write = true,
 	.volatile_reg = es8326_volatile_register,
+	.writeable_reg = es8326_writeable_register,
 	.cache_type = REGCACHE_RBTREE,
 };
 
-- 
2.17.1

