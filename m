Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027481;
	b=edKq3dVjaUY/sF6dskgE4i1ExCtbH+9N6uOr7rOymRC0T+mGodp9SidhDfJui93+z4d3
	 W2+hbWNovU3LteXMOa/zK+mn0EnddVSnn0xon40j+j+wm3+txn52OJu34Jq/9Km5crQRe
	 7bLKnpnDNy4VKEcG7a9SbXWkO9UWB6GR1y8MUCjMw0mliTM6tY7pp+pcws6FLrWMabvhx
	 AdQ9xWi5wK1nattmHtK6MUN8aoiEsEmNWT9TaDyKXWqyVGa8w4AN2czQsWzTxQHVC7FOP
	 ZFkvuAMSucm5CWETJ8bYUBakzsToT3VoXA0PdVrMbpBcwPff1QjOWawubX51gQuMtzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027481;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qq0IN19EzVWi1Thsbv34xhHhcVN7Hu/BIUVuHdkLuKI=;
	b=WSWdUYZaJC8YNGA6XLUyrseesho1Oy+wuWxJDeA3WQErYKt/rvO9l1pjaX329v+cdwN5
	 WkOvTTlPoKjZzE2Xnwq4mCWGB2aH7QtYGGNrn80JzmItahD8c2jJXY2MR9ZmuEOS7hc5m
	 PJnI0lTdXgIXvfkGFuAuZFISXx22S8FKXP+DOz/lEkBAuA61ws4H476jAEzZopE2a+vOm
	 BebqJggA+D07hSBoPq8bIp+quDqAhyCcUL5Q9KZUGTxbWXQdzvMFPL1AfM6yLf4vQUr+q
	 fE1aHR2tu2YyteUDUtmSVSJdElOq4jiGma1UezSq0iGWcjfr59RTp55U8a1/QkRA5Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncCQkMu5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D998160A260E;
	Wed, 18 Nov 2026 18:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncCQkMu5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332141F000C4;
	Wed, 18 Nov 2026 18:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027481;
	bh=Qq0IN19EzVWi1Thsbv34xhHhcVN7Hu/BIUVuHdkLuKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ncCQkMu5+kZG4KAyfEqNwRPA7WjTUYcO9qwsNsJeZdVr7aF0k8+hftyu5cCgiu/yB
	 fwokqYk/zzb7FXYrnn4R0wqZVbnwpnviWyR7i9e+VMeJd+0AD57a4sg6XY0wekrwKp
	 uYVo3l1jyMl0e7faGXJAzp0nWNWaVyoVlPiLqD+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1805/2151] ASoC: cs42l56: Remove the ADC Mute Switch control
Date: Wed, 18 Nov 2026 15:59:00 +0100
Message-ID: <20261118150227.557560681@linuxfoundation.org>
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
index 4e46b8ba92485..363b29977a3a8 100644
--- a/sound/soc/codecs/cs42l56.c
+++ b/sound/soc/codecs/cs42l56.c
@@ -419,7 +419,6 @@ static const struct snd_kcontrol_new cs42l56_snd_controls[] = {
 			      CS42L56_PGAB_MUX_VOLUME, 0, 0x34, 0x24, pga_tlv),
 	SOC_DOUBLE_R_TLV("ADC Volume", CS42L56_ADCA_ATTENUATOR,
 			      CS42L56_ADCB_ATTENUATOR, 0, 0x00, 1, adc_tlv),
-	SOC_DOUBLE("ADC Mute Switch", CS42L56_MISC_ADC_CTL, 2, 3, 1, 1),
 	SOC_DOUBLE("ADC Boost Switch", CS42L56_GAIN_BIAS_CTL, 3, 2, 1, 1),
 
 	SOC_DOUBLE_R_SX_TLV("Headphone Volume", CS42L56_HPA_VOLUME,
-- 
2.53.0



