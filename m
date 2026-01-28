Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C5E364E92;
	Wed, 28 Jan 2026 15:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614075; cv=none; b=Va76SdM/4ogTqm2QZyNTMYq4iXUaEkK6yiWVX6Of1VUmmy8+ail9HmeBeLA/a30GmwVA0O7AYq+vRoTPwVr1JjUi80kYJf+7Av2zulzfpYUqQQn8O3KCRT/e1qyD47XoB+QpcimICSBdOPsetaeFx8OwQYBl3Ur+PWVsdzXA3W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614075; c=relaxed/simple;
	bh=3pU8FQgzHG+319nLBEEjVPjhE/nnsqVrR7Wfu9duua4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jnv/kgaee6ZLXlXWCT8dXtloKHmpbYPFekHoHILjpSBqu9eBEVoSbYjTzCJQYgqiKROOA+uVXfZEIBx+XJVZ/4SXtTyZWKZn8iUeqUorrFVXxrzXTg2t+mrX1zqFpVRiK7cZIgtDLEgHiIP8NJWI0t3rq/35zqdZ8nqB7CmfyXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ho9Xzitq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ho9Xzitq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EC4C4CEF1;
	Wed, 28 Jan 2026 15:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614075;
	bh=3pU8FQgzHG+319nLBEEjVPjhE/nnsqVrR7Wfu9duua4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ho9XzitqIsoZyX5L57JolJIhr37Kh9j/WGZOJj6jXoCxKIkwKS85EEkDhUWggkS7/
	 XZDg6jKQDx000hgJlo6pq1QWCZ86FdTPy0NVqkDxW/FXh9b7a2QxPEioV+EiqrYm31
	 in2uahKYbkRR3jZZdDg0xBm9NvcD+Z4cxS9Nw7sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Svendsen <emas@bang-olufsen.dk>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/254] ASoC: tlv320adcx140: fix null pointer
Date: Wed, 28 Jan 2026 16:20:04 +0100
Message-ID: <20260128145345.717375319@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 41342b3406803..d366c1c51f07a 100644
--- a/sound/soc/codecs/tlv320adcx140.c
+++ b/sound/soc/codecs/tlv320adcx140.c
@@ -24,7 +24,6 @@
 #include "tlv320adcx140.h"
 
 struct adcx140_priv {
-	struct snd_soc_component *component;
 	struct regulator *supply_areg;
 	struct gpio_desc *gpio_reset;
 	struct regmap *regmap;
@@ -702,7 +701,6 @@ static void adcx140_pwr_ctrl(struct adcx140_priv *adcx140, bool power_state)
 {
 	int pwr_ctrl = 0;
 	int ret = 0;
-	struct snd_soc_component *component = adcx140->component;
 
 	if (power_state)
 		pwr_ctrl = ADCX140_PWR_CFG_ADC_PDZ | ADCX140_PWR_CFG_PLL_PDZ;
@@ -714,7 +712,7 @@ static void adcx140_pwr_ctrl(struct adcx140_priv *adcx140, bool power_state)
 		ret = regmap_write(adcx140->regmap, ADCX140_PHASE_CALIB,
 			adcx140->phase_calib_on ? 0x00 : 0x40);
 		if (ret)
-			dev_err(component->dev, "%s: register write error %d\n",
+			dev_err(adcx140->dev, "%s: register write error %d\n",
 				__func__, ret);
 	}
 
-- 
2.51.0



