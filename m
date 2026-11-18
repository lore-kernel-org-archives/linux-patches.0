Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023159;
	b=PHwjA6KN7A6Mn0wUYjaiIktf0X2TVCGNiAKJcMgSxCZ/X9aMwDY7GgbMwj6B0/zCzxbO
	 YQbuDKsUZD4Y8TOgb1RjpUUOPq7vjetptuR8ZKRf3o3YvO6QsvVPQNfrs3mVV/DeZW2Zn
	 gKGPeVlAR7UqCHbnr9HJIr+U85ykEG5kPxvn8PycPzxKklmdJ1p6luV5Ud5zuYqHWJAAY
	 Iw0u/ej9I+OBBxahTpZBI9UGp+02FEroKPS2Kz3qmeYsotgnK1t2aMeI6j2ptR7gFqBzy
	 GmchRBEZJT7d/n78P4issit5ph9hqcvyDy2m6ZWxkcptUg+3QkwNi1Lq95hoEIyvsIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=53ZLl14unfdOa7m1hQL8OfgEUSKL41J5gnEVkqfcmdI=;
	b=pP5Q4fkuR0qWMBz9s1IrpfSxiTB7iifLjQ7TB3CnNhxCWofJ6nIyTINKw/XXOIG8CxO7
	 73KiqqLJYnE0/PZpq0I0QhFGY7qHpNJ7oPPvZtNztfzOVKqzWE9mPpwXIeuqjQmPrCXQ4
	 RCtid5XkcKNe5luPe9w650J3nfQQFmCG9iclzmCZwr0ipU6p4pdwA1PQxwVtxGcg0hnOY
	 AZuqZPAwmfDQRybIt5EYPsnu64c5iMiYRtwYOVpVbsgI9KEStHdU7kd/bYtiA9LQYEqSI
	 91rBxeiVFUpLz4P1CdSORKc/zC+uL+o+CkSb1wN9ttKashfFxxwuhsHgG5aAtGaaZZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fVMK42UH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFFF606A336;
	Wed, 18 Nov 2026 17:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fVMK42UH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58B71F000C4;
	Wed, 18 Nov 2026 17:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023159;
	bh=53ZLl14unfdOa7m1hQL8OfgEUSKL41J5gnEVkqfcmdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fVMK42UH+bAgqxHDVRTpYa1QOlnXp+FmIwOyIRd9pbxV01HWaEdklM9qYQJ4VtSTh
	 nYb59bBXPaJXAxSWcYpvZpXXeTBWYNEfUaCoYL27fPiBSINUF78WNDpRNpsHj5MU4+
	 GUAQSpoU+gSAT0FmvVLJAOBiB2x1pYy0PAw0M4vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <zhangyi@everest-semi.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0269/2151] ASoC: codecs: ES8389: Modify volatile_register
Date: Wed, 18 Nov 2026 15:33:24 +0100
Message-ID: <20261118150131.644226823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <zhangyi@everest-semi.com>

[ Upstream commit 882e55031187791a2b87810d4a93f866a2da6d47 ]

Mark some registers that are not volatile as false
And modified the logic for `cache_bypass` during `8389_resume`.

Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
Link: https://patch.msgid.link/20260630072311.8427-2-zhangyi@everest-semi.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 8f7d23eb8ffb ("ASoC: es8389: report resume restore errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8389.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/es8389.c b/sound/soc/codecs/es8389.c
index 8960969cfbaa1..20ba0042cb0b0 100644
--- a/sound/soc/codecs/es8389.c
+++ b/sound/soc/codecs/es8389.c
@@ -41,10 +41,29 @@ struct	es8389_private {
 static bool es8389_volatile_register(struct device *dev,
 			unsigned int reg)
 {
-	if ((reg  <= 0xff))
-		return true;
-	else
+	switch (reg) {
+	case ES8389_ADCL_VOL:
+	case ES8389_ADCR_VOL:
+	case ES8389_MIC1_GAIN:
+	case ES8389_MIC2_GAIN:
+	case ES8389_DACL_VOL:
+	case ES8389_DACR_VOL:
+	case ES8389_ALC_ON:
+	case ES8389_ALC_CTL:
+	case ES8389_ALC_TARGET:
+	case ES8389_ALC_GAIN:
+	case ES8389_ADC_MUTE:
+	case ES8389_OSR_VOL:
+	case ES8389_DAC_INV:
+	case ES8389_MIX_VOL:
+	case ES8389_DAC_MIX:
+	case ES8389_ADC_RESET:
+	case ES8389_ADC_MODE:
+	case ES8389_DMIC_EN:
 		return false;
+	default:
+		return true;
+	}
 }
 
 static const DECLARE_TLV_DB_SCALE(dac_vol_tlv, -9550, 50, 0);
@@ -804,13 +823,13 @@ static int es8389_resume(struct snd_soc_component *component)
 	regcache_cache_only(es8389->regmap, false);
 	regcache_cache_bypass(es8389->regmap, true);
 	regmap_read(es8389->regmap, ES8389_RESET, &regv);
-	regcache_cache_bypass(es8389->regmap, false);
 
 	if (regv == 0xff)
 		es8389_init(component);
 	else
 		es8389_set_bias_level(component, SND_SOC_BIAS_ON);
 
+	regcache_cache_bypass(es8389->regmap, false);
 	regcache_sync(es8389->regmap);
 
 	return 0;
-- 
2.53.0



