Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510152D321B;
	Wed,  4 Feb 2026 15:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217477; cv=none; b=b6Ubcm4amh7V0MPCTYxNWYzBUGAPnsrONPKaGIxnOcENRe14wrJmV4k/4lIGE7cAyyUmTTezUSovCV7Lav/ZqlvCzECHFBJuDFSvoxWXUu7a5hXR2DaH+ndkMLIpmaTwHuknRGPDWtfyQbAg7lSP3H0GaCdpVhlnGzSMIi2xOeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217477; c=relaxed/simple;
	bh=hw9jDZuFIRmePriqY9lnfBDyRfJRvjVMTw5T6PJGYq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGuHjRBFa4IBtPzm2q++OzdoNmEJZ3efBGMEOeo0WsS4zweqrg09ys2iI3IsY6fVPWewaWs76hY2uqpwE55tV+E8e2uJw82s4dGTg1GTIh5HeHUQpA3W8RC6pXxrXxqZdhADcIBYaTtKSL3At/zDl94ldhXnQ2FUc+YHOgirDwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cda5foIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cda5foIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B18C4CEF7;
	Wed,  4 Feb 2026 15:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217477;
	bh=hw9jDZuFIRmePriqY9lnfBDyRfJRvjVMTw5T6PJGYq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cda5foIvrFiT9ww8TJPyYFrzJB92fhOLbQmN9Ro7hpFUVQCHmQcyPaKmHofxnIUeb
	 ajiNasqGdgLiedZj5/XpEaYm8AO4rKyw8WP/6HtxHEN/XywfCBLiKzcnrPAOYKGQbe
	 uSTNx3pUzCf6oJg0PTDzFi5aMSpBGOK9t4pgZIq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Svendsen <emas@bang-olufsen.dk>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/280] ASoC: tlv320adcx140: fix null pointer
Date: Wed,  4 Feb 2026 15:36:41 +0100
Message-ID: <20260204143910.612382463@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 530f321d08e9c..4405934120e51 100644
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



