Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039359;
	b=Lul+t6sN+3hPRNPs3Rf/knsdUZ0dUJ9XNjmPZ1wxqU3Tbc8D9iJ1CcYJalKQSz5oD3iK
	 efD5Ss3VtVVgqO+xVj+hgSa5PcBJJezxb/KC50JMn3Y38ZqRQ/c6EcidUdzOYwwAAhbqb
	 fhD3gWSO1GEp4x999eSJh743Tqappmh6ntMO+Qj/V7jlY5TsC0MQ/RR+y1ZwHXLvHhHbj
	 FeqSp9YXK1o0ic9C12tu6EiA9JbjkhPo2z33cm0f3G/0aK59YyZQ7BKyX9mF+eHVQNNeq
	 uoL13GmdcMT4oqDY6nVqeOBOY51qvd7FjXrrVjXKeQuJXRa36B8c5kMqncsuk89Mpjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039359;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ne4E7vjK3gfinO+OnhkQjCUrfurxyLXaYZ7Nrl/I/x8=;
	b=Pp9RAK7srDWDHSKkYWLVNzFNLoLGSRl+kTN+9BdivjUq/Iexn6UGY4ZnB2GvK/qW0InU
	 m06B9QKaJ//u/uyH/hRMZiB7mZNT2z2YqrsOHwX9ZIN9m4KRlrZpjYWSHgSnOXhENMGdT
	 oZRFGGEQjITyenOZ4lmE1N2KbMY2JMU1rJeB+VtrX+975LIqhXvn6rFpNJ2BzVD0mhHAl
	 FqtQx2k6UPtTt0XXzgokO63yHScOybY/CiWZluYLacpXlQzY9d6mc+X6EgtcU+M7Kr5fi
	 sEeewL3FA6glrTjoAIeAtESXWlgZAOEFziNG1Eq+KqCE9JCUPBQbimIAcMBF2rG39rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vkdAMpq0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21E4606A31C;
	Wed, 18 Nov 2026 22:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vkdAMpq0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB371F000C4;
	Wed, 18 Nov 2026 22:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039359;
	bh=ne4E7vjK3gfinO+OnhkQjCUrfurxyLXaYZ7Nrl/I/x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vkdAMpq0nwYduoGetXwED4QEhG/xQaNEvrQ1opR8PFOVN6EdUFyKWNX/1gNaEhjy+
	 tZi2V2EZKBOejwlNyGbbd/gbhQxHLjj+jD4IXtqNsfv6NMhBSA4IsM/A8ZzYn9VyCv
	 J+WYBV7N6VdqW/qu0e/KsyYmrJ8g1OLIYQ4PkHw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Ning <zhuning0077@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2072/3318] ASoC: codecs: ES8326: fix the capture noise issue
Date: Wed, 18 Nov 2026 15:44:54 +0100
Message-ID: <20261118150424.244765358@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Ning <zhuning0077@gmail.com>

[ Upstream commit 8c99a0a607b5e0cf6b79b283d7bb2c2b84e01da5 ]

We get a noise issue during the startup of recording. We update the
register setting and dapm widgets to fix this issue.
we change callback type of es8326_mute function to mute_stream.
ES8326_ADC_MUTE is moved to es8326_mute function so it can
be turned on at last and turned off at first.

Signed-off-by: Zhu Ning <zhuning0077@gmail.com>
Link: https://msgid.link/r/20240120101240.12496-6-zhuning0077@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 349e94679968 ("ASoC: es8326: report resume restore errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8326.c | 63 ++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index 68ff30156bad9..b8c67b703b71a 100644
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -117,12 +117,6 @@ static const struct snd_soc_dapm_widget es8326_dapm_widgets[] = {
 	SND_SOC_DAPM_AIF_OUT("I2S OUT", "I2S1 Capture", 0, SND_SOC_NOPM, 0, 0),
 	SND_SOC_DAPM_AIF_IN("I2S IN", "I2S1 Playback", 0, SND_SOC_NOPM, 0, 0),
 
-	/* ADC Digital Mute */
-	SND_SOC_DAPM_PGA("ADC L1", ES8326_ADC_MUTE, 0, 1, NULL, 0),
-	SND_SOC_DAPM_PGA("ADC R1", ES8326_ADC_MUTE, 1, 1, NULL, 0),
-	SND_SOC_DAPM_PGA("ADC L2", ES8326_ADC_MUTE, 2, 1, NULL, 0),
-	SND_SOC_DAPM_PGA("ADC R2", ES8326_ADC_MUTE, 3, 1, NULL, 0),
-
 	/* Analog Power Supply*/
 	SND_SOC_DAPM_DAC("Right DAC", NULL, ES8326_ANA_PDN, 0, 1),
 	SND_SOC_DAPM_DAC("Left DAC", NULL, ES8326_ANA_PDN, 1, 1),
@@ -142,15 +136,10 @@ static const struct snd_soc_dapm_widget es8326_dapm_widgets[] = {
 };
 
 static const struct snd_soc_dapm_route es8326_dapm_routes[] = {
-	{"ADC L1", NULL, "MIC1"},
-	{"ADC R1", NULL, "MIC2"},
-	{"ADC L2", NULL, "MIC3"},
-	{"ADC R2", NULL, "MIC4"},
-
-	{"ADC L", NULL, "ADC L1"},
-	{"ADC R", NULL, "ADC R1"},
-	{"ADC L", NULL, "ADC L2"},
-	{"ADC R", NULL, "ADC R2"},
+	{"ADC L", NULL, "MIC1"},
+	{"ADC R", NULL, "MIC2"},
+	{"ADC L", NULL, "MIC3"},
+	{"ADC R", NULL, "MIC4"},
 
 	{"I2S OUT", NULL, "ADC L"},
 	{"I2S OUT", NULL, "ADC R"},
@@ -401,11 +390,16 @@ static int es8326_mute(struct snd_soc_dai *dai, int mute, int direction)
 	unsigned int offset_l, offset_r;
 
 	if (mute) {
-		regmap_write(es8326->regmap, ES8326_HP_CAL, ES8326_HP_OFF);
-		regmap_update_bits(es8326->regmap, ES8326_DAC_MUTE,
-				ES8326_MUTE_MASK, ES8326_MUTE);
-		regmap_update_bits(es8326->regmap, ES8326_HP_DRIVER_REF,
-				0x30, 0x00);
+		if (direction == SNDRV_PCM_STREAM_PLAYBACK) {
+			regmap_write(es8326->regmap, ES8326_HP_CAL, ES8326_HP_OFF);
+			regmap_update_bits(es8326->regmap, ES8326_DAC_MUTE,
+					ES8326_MUTE_MASK, ES8326_MUTE);
+			regmap_update_bits(es8326->regmap, ES8326_HP_DRIVER_REF,
+					0x30, 0x00);
+		} else {
+			regmap_update_bits(es8326->regmap,  ES8326_ADC_MUTE,
+					0x0F, 0x0F);
+		}
 	} else {
 		if (!es8326->calibrated) {
 			regmap_write(es8326->regmap, ES8326_HP_CAL, ES8326_HP_FORCE_CAL);
@@ -418,16 +412,22 @@ static int es8326_mute(struct snd_soc_dai *dai, int mute, int direction)
 			regmap_write(es8326->regmap, ES8326_HPR_OFFSET_INI, offset_r);
 			es8326->calibrated = true;
 		}
-		regmap_update_bits(es8326->regmap, ES8326_DAC_DSM, 0x01, 0x01);
-		usleep_range(1000, 5000);
-		regmap_update_bits(es8326->regmap, ES8326_DAC_DSM, 0x01, 0x00);
-		usleep_range(1000, 5000);
-		regmap_update_bits(es8326->regmap, ES8326_HP_DRIVER_REF, 0x30, 0x20);
-		regmap_update_bits(es8326->regmap, ES8326_HP_DRIVER_REF, 0x30, 0x30);
-		regmap_write(es8326->regmap, ES8326_HP_DRIVER, 0xa1);
-		regmap_write(es8326->regmap, ES8326_HP_CAL, ES8326_HP_ON);
-		regmap_update_bits(es8326->regmap, ES8326_DAC_MUTE,
-				ES8326_MUTE_MASK, ~(ES8326_MUTE));
+		if (direction == SNDRV_PCM_STREAM_PLAYBACK) {
+			regmap_update_bits(es8326->regmap, ES8326_DAC_DSM, 0x01, 0x01);
+			usleep_range(1000, 5000);
+			regmap_update_bits(es8326->regmap, ES8326_DAC_DSM, 0x01, 0x00);
+			usleep_range(1000, 5000);
+			regmap_update_bits(es8326->regmap, ES8326_HP_DRIVER_REF, 0x30, 0x20);
+			regmap_update_bits(es8326->regmap, ES8326_HP_DRIVER_REF, 0x30, 0x30);
+			regmap_write(es8326->regmap, ES8326_HP_DRIVER, 0xa1);
+			regmap_write(es8326->regmap, ES8326_HP_CAL, ES8326_HP_ON);
+			regmap_update_bits(es8326->regmap, ES8326_DAC_MUTE,
+					ES8326_MUTE_MASK, ~(ES8326_MUTE));
+		} else {
+			msleep(300);
+			regmap_update_bits(es8326->regmap,  ES8326_ADC_MUTE,
+					0x0F, 0x00);
+		}
 	}
 	return 0;
 }
@@ -477,7 +477,7 @@ static const struct snd_soc_dai_ops es8326_ops = {
 	.set_fmt = es8326_set_dai_fmt,
 	.set_sysclk = es8326_set_dai_sysclk,
 	.mute_stream = es8326_mute,
-	.no_capture_mute = 1,
+	.no_capture_mute = 0,
 };
 
 static struct snd_soc_dai_driver es8326_dai = {
@@ -849,6 +849,7 @@ static int es8326_resume(struct snd_soc_component *component)
 	regmap_update_bits(es8326->regmap, ES8326_DAC_MUTE, ES8326_MUTE_MASK,
 			   ES8326_MUTE);
 
+	regmap_write(es8326->regmap, ES8326_ADC_MUTE, 0x0f);
 
 	es8326->jack_remove_retry = 0;
 	es8326->hp = 0;
-- 
2.53.0



