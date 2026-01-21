Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0A1322B77;
	Wed, 21 Jan 2026 18:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019546; cv=none; b=qRgzhPm7OHLHG32gHCWSU9Arkff1Ii6zhiylNnhYEnj1p6c7YfnQF1AwJpKWMXSG1iZPDPx7aZGotQi8h2gVogyAJzgSo6sjG/ORKmImjDrL8lYys2AodBblzjf2UgB0FG8PN6KtEQqvFbZj1sw2kS9tEnNyWxZTm7b6Zf18vyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019546; c=relaxed/simple;
	bh=9nMJp7qnwskoAHqp/6RmHWuDOLAjJpwL7sM+7odRO2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ybkcc7sPpXw0DpsGNRJ1au0/fQqoB14Ntmq5K5A+vmytRxWKWzeNZ2YydRQOw4kwULpvlV0XTv7QoCiYHQVWG8C+dKRnabUdjuVhnPugkzoEw9MtXb5xMLKcEvHJnBb1+SmGA1BgvW+E/3vcbB8wWcdWATuhel3wnxkPvs9JvjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wwvy0dOl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wwvy0dOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E805FC4CEF1;
	Wed, 21 Jan 2026 18:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019546;
	bh=9nMJp7qnwskoAHqp/6RmHWuDOLAjJpwL7sM+7odRO2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wwvy0dOl3UrUCz7b/+7jiW51LUiPar6sKVbbq99Vn2nq1eJQmLKL8V28W7+5f4zQ8
	 AX3neW6e6/AMza2HacPnQbn5URtYhKDnEYMEVxQhQEv1gWWs2cLo4EvL37u5A23nLe
	 xKCDC73g1JoWe3gu6woLoJjUKzFL0VkQYhOTSshM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Svendsen <emas@bang-olufsen.dk>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/139] ASoC: tlv320adcx140: fix null pointer
Date: Wed, 21 Jan 2026 19:14:46 +0100
Message-ID: <20260121181412.826249860@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Svendsen <emas@bang-olufsen.dk>

[ Upstream commit be7664c81d3129fc313ef62ff275fd3d33cfecd4 ]

The "snd_soc_component" in "adcx140_priv" was only used once but never
set. It was only used for reaching "dev" which is already present in
"adcx140_priv".

Fixes: 4e82971f7b55 ("ASoC: tlv320adcx140: Add a new kcontrol")
Signed-off-by: Emil Svendsen <emas@bang-olufsen.dk>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://patch.msgid.link/20260113-sound-soc-codecs-tvl320adcx140-v4-2-8f7ecec525c8@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320adcx140.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/tlv320adcx140.c b/sound/soc/codecs/tlv320adcx140.c
index d594bf166c0e7..ccfec4c0c159a 100644
--- a/sound/soc/codecs/tlv320adcx140.c
+++ b/sound/soc/codecs/tlv320adcx140.c
@@ -23,7 +23,6 @@
 #include "tlv320adcx140.h"
 
 struct adcx140_priv {
-	struct snd_soc_component *component;
 	struct regulator *supply_areg;
 	struct gpio_desc *gpio_reset;
 	struct regmap *regmap;
@@ -701,7 +700,6 @@ static void adcx140_pwr_ctrl(struct adcx140_priv *adcx140, bool power_state)
 {
 	int pwr_ctrl = 0;
 	int ret = 0;
-	struct snd_soc_component *component = adcx140->component;
 
 	if (power_state)
 		pwr_ctrl = ADCX140_PWR_CFG_ADC_PDZ | ADCX140_PWR_CFG_PLL_PDZ;
@@ -713,7 +711,7 @@ static void adcx140_pwr_ctrl(struct adcx140_priv *adcx140, bool power_state)
 		ret = regmap_write(adcx140->regmap, ADCX140_PHASE_CALIB,
 			adcx140->phase_calib_on ? 0x00 : 0x40);
 		if (ret)
-			dev_err(component->dev, "%s: register write error %d\n",
+			dev_err(adcx140->dev, "%s: register write error %d\n",
 				__func__, ret);
 	}
 
-- 
2.51.0



