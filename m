Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050255;
	b=HN8us8igoQiW72/Kbm/1JTbJ82Sh0n1L69DQ9VzzbeOuRxqt99rrk8P6aTgfzipwEYml
	 +5RYxXZxz6uooyIj+2HAQS6mowUUWPmldX+9j557++EenAM2rmm0nxGeiZKPMuesx5AyK
	 J73tL0H+pWE7RXxeoGZcuA1YyR0DfS3zhAc2upUO7gdl9DUHe0z3f8qQFgZ3W19VPyoXi
	 KR6uDPiSM5dWT4jAokxDOFA7999nlColzwdXt/HlX3ATgKfWBnIGCaocOwtL/kz5vyiB0
	 ENoomZak1xd1MD2fcmdJTooalsLWUGfZWAWeezaYuIpmlI3SfBfOmbOK7j8apEHtzrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EpmX4f9nedgEzlazF4UN4Vg/9wPsMrT6kbdGGG9bHNU=;
	b=l5Vhk/v+VJFSLoT+ZwrIM1PvtE2UJfo+cdcV/f/1OGCswNge7IFsdOzipsEFGlQBWZVP
	 +xFyl+8IhScccjQQ11VoHzuEMHN/RIIW7s0Z10exxMICoo7wWkthY+M95LrednkZ9O+mr
	 WCfQFL7HXC5aaoMf9nV/IVM5MIoFRaF6ie6pODVs+bCMCTod3NBRZx/rwRM0umdREH2Is
	 lyy/suiZq8HvaDzhzfX40URPBD9Op7kMk8ea+zFgUYqLexLv3XrHSlyGgyQR2fnQeMrCQ
	 hrx+MSeFj09IRqyCjS1hizM3dLkDc3HinDvS6Zj/nLFxurvPxPv17LrTOIaiB0SjJQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XFKimkp+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1959606A320;
	Thu, 19 Nov 2026 01:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XFKimkp+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52E11F000C4;
	Thu, 19 Nov 2026 01:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050255;
	bh=EpmX4f9nedgEzlazF4UN4Vg/9wPsMrT6kbdGGG9bHNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XFKimkp+2BheW4iNXLVv1LoiMOhAL1GLP2ILnb0GeY3iAmwMDiy1LT9n28gDfWFfb
	 95hC9SvkIqLje0Z2txeRdzlHT7FcpHChS1UKEbEQhm2g1h/OekuY0x5fQSjXTcLu3s
	 zqioh8E9OEQ1/g5mZDJVSiptn9vTOEsK+caQ3KWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2643/2857] ASoC: cs42l56: Remove the ADC Mute Switch control
Date: Wed, 18 Nov 2026 16:01:17 +0100
Message-ID: <20261118150336.750830256@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit ff404ef11b975baf38c4472c51a6674c239e8021 ]

The ADC Mute Switch control writes bits 2 and 3 of the Misc ADC Control
register. These are the ADCA Invert and ADCB Invert bits, which have
their own controls. The ADC mute bits are bits 0 and 1, and the DAI mute
callback already sets them.

So the control has never muted the ADCs, and nobody can be relying on
it. Remove it rather than point it at the mute bits, so the ADCs are
muted in one place only.

Fixes: 272b5edd3b8f ("ASoC: Add support for CS42L56 CODEC")
Suggested-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/all/atXh3Br+fuH83S0q@opensource.cirrus.com/
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20261019124022.3410793-1-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l56.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l56.c b/sound/soc/codecs/cs42l56.c
index 206c45318ad4c..94e5742cacc26 100644
--- a/sound/soc/codecs/cs42l56.c
+++ b/sound/soc/codecs/cs42l56.c
@@ -387,7 +387,6 @@ static const struct snd_kcontrol_new cs42l56_snd_controls[] = {
 			      CS42L56_PGAB_MUX_VOLUME, 0, 0x34, 0x24, pga_tlv),
 	SOC_DOUBLE_R_TLV("ADC Volume", CS42L56_ADCA_ATTENUATOR,
 			      CS42L56_ADCB_ATTENUATOR, 0, 0x00, 1, adc_tlv),
-	SOC_DOUBLE("ADC Mute Switch", CS42L56_MISC_ADC_CTL, 2, 3, 1, 1),
 	SOC_DOUBLE("ADC Boost Switch", CS42L56_GAIN_BIAS_CTL, 3, 2, 1, 1),
 
 	SOC_DOUBLE_R_SX_TLV("Headphone Volume", CS42L56_HPA_VOLUME,
-- 
2.53.0



