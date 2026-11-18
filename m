Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039351;
	b=hwyJxpvxEyrWYNu8TH8EQblHCjezzGviJ2iAFpi20rL7bnhB5iFf3BdfK0bM4Yp6XKkV
	 OIaf5HG3WFs0Up7/d7SC4gdCNUEHsgX848JV551FMQXlbbkcpUxXA3Az4U1J0SRAVwbO9
	 BT+coDLG9VTBQ4cocbZqKyAmzEyolhsEPKfY85jXjptXPabx/3v0xekepMyXuXZGCXzVt
	 v6ZD/xQdX3A2OCtCArjHxmu0WtXHl4LnRMd53QLE7FaF9j2T96Tf9YvsMDDV9mudPGen3
	 gj9jxX48vQOwW38Ge50v0yMB4iQSeH/3gNLSqRAaP1cZrOxpeUn/5Hc4D6TWaWA/wYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BBTJ6+NwFv6umgl52y3mxrINLpO2/SKy/HG2oHaMldI=;
	b=JvvqXRIjbYhz7ksMRgY77eikAKz7CTog1e07Y8FwFnAOdpal4PYpMxYHrBXQLpFFuz+X
	 0qKzIBqlc3HfTJCucK6OnvQK1s2uJj7ggugrS+TUr/ooQvy8SE1yNBT7UGvMOAmN6yB5B
	 9Nn3BhoAh7qKVr5Mvm8HhdPkf1CbGHegWSR+KJXar1MlxDEvppJtvL6gE7QtjCzBv/WWd
	 4OTl3U+5gNcvpTiFTPLQyxzczJtvoaUb6le2q+OEaCQ9zDzYkZ+XbbnLeu9fwXcAaIe5i
	 eQBtREgM/Fxzz655Sk466yQFa5ogyweANjTonLkNRnpJ8hFNcpkhWch61/804n+Bvcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XakVv4A6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CF3606A325;
	Wed, 18 Nov 2026 22:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XakVv4A6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BD41F000C5;
	Wed, 18 Nov 2026 22:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039350;
	bh=BBTJ6+NwFv6umgl52y3mxrINLpO2/SKy/HG2oHaMldI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XakVv4A6KXMU9daZhxSLTVE+RkbBxOpOrz3TTfOgiO3ecQYSZl/S2D+PebhDb2KXx
	 qqrdFwnUMBUEm9yfnCpNxusc9kYXha+ZelrtY9oEOmvDP/juNCSqoQyD8eh1J7aZW/
	 0/1veYsvLtfdg+/CoCepNAom0Qa/FBDbjkvtIpQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Ning <zhuning0077@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2069/3318] ASoC: codecs: ES8326: Changing initialisation and broadcasting
Date: Wed, 18 Nov 2026 15:44:51 +0100
Message-ID: <20261118150424.151819555@linuxfoundation.org>
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

[ Upstream commit fc702b2c04d778d7e3a4091ebe54a86c5d0a0d96 ]

New chip versions require new initialisation and playback processes.
Changing the initialisation and playback process for better results.
The old chip versions are going to work well with the new sequences.
We've tested this with version_v0 and version_v3 chips
under the new sequence and they both pass.

Signed-off-by: Zhu Ning <zhuning0077@gmail.com>
Link: https://lore.kernel.org/r/20231101072702.91316-3-zhuning0077@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 349e94679968 ("ASoC: es8326: report resume restore errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8326.c | 50 +++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index 32a9b26ee2c89..5cdd0974e4ae3 100644
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -132,6 +132,11 @@ static const struct snd_soc_dapm_widget es8326_dapm_widgets[] = {
 	SND_SOC_DAPM_PGA("LHPMIX", ES8326_DAC2HPMIX, 7, 0, NULL, 0),
 	SND_SOC_DAPM_PGA("RHPMIX", ES8326_DAC2HPMIX, 3, 0, NULL, 0),
 
+	SND_SOC_DAPM_REG(snd_soc_dapm_supply, "HPOR Supply", ES8326_HP_CAL,
+			 4, 7, 0, 0),
+	SND_SOC_DAPM_REG(snd_soc_dapm_supply, "HPOL Supply", ES8326_HP_CAL,
+			 0, 7, 0, 0),
+
 	SND_SOC_DAPM_OUTPUT("HPOL"),
 	SND_SOC_DAPM_OUTPUT("HPOR"),
 };
@@ -156,6 +161,9 @@ static const struct snd_soc_dapm_route es8326_dapm_routes[] = {
 	{"LHPMIX", NULL, "Left DAC"},
 	{"RHPMIX", NULL, "Right DAC"},
 
+	{"HPOR", NULL, "HPOR Supply"},
+	{"HPOL", NULL, "HPOL Supply"},
+
 	{"HPOL", NULL, "LHPMIX"},
 	{"HPOR", NULL, "RHPMIX"},
 };
@@ -409,8 +417,8 @@ static int es8326_mute(struct snd_soc_dai *dai, int mute, int direction)
 			regmap_write(es8326->regmap, ES8326_HPR_OFFSET_INI, offset_r);
 			es8326->calibrated = true;
 		}
-		regmap_write(es8326->regmap, ES8326_HP_DRIVER, 0xa0);
-		regmap_write(es8326->regmap, ES8326_HP_VOL, 0x80);
+		regmap_write(es8326->regmap, ES8326_HP_DRIVER, 0xa1);
+		regmap_write(es8326->regmap, ES8326_HP_VOL, 0x91);
 		regmap_write(es8326->regmap, ES8326_HP_CAL, ES8326_HP_ON);
 		regmap_update_bits(es8326->regmap, ES8326_DAC_MUTE,
 				ES8326_MUTE_MASK, ~(ES8326_MUTE));
@@ -430,8 +438,6 @@ static int es8326_set_bias_level(struct snd_soc_component *codec,
 		if (ret)
 			return ret;
 
-		regmap_write(es8326->regmap, ES8326_RESET, 0x9f);
-		msleep(20);
 		regmap_update_bits(es8326->regmap, ES8326_DAC_DSM, 0x01, 0x00);
 		regmap_write(es8326->regmap, ES8326_INTOUT_IO, es8326->interrupt_clk);
 		regmap_write(es8326->regmap, ES8326_SDINOUT1_IO,
@@ -440,19 +446,21 @@ static int es8326_set_bias_level(struct snd_soc_component *codec,
 		regmap_write(es8326->regmap, ES8326_PGA_PDN, 0x40);
 		regmap_write(es8326->regmap, ES8326_ANA_PDN, 0x00);
 		regmap_update_bits(es8326->regmap,  ES8326_CLK_CTL, 0x20, 0x20);
-		regmap_write(es8326->regmap, ES8326_RESET, ES8326_CSM_ON);
+
+		regmap_update_bits(es8326->regmap, ES8326_RESET,
+				ES8326_CSM_ON, ES8326_CSM_ON);
 		break;
 	case SND_SOC_BIAS_PREPARE:
 		break;
 	case SND_SOC_BIAS_STANDBY:
-		break;
-	case SND_SOC_BIAS_OFF:
-		clk_disable_unprepare(es8326->mclk);
 		regmap_write(es8326->regmap, ES8326_ANA_PDN, 0x3b);
 		regmap_write(es8326->regmap, ES8326_VMIDSEL, 0x00);
 		regmap_update_bits(es8326->regmap, ES8326_CLK_CTL, 0x20, 0x00);
 		regmap_write(es8326->regmap, ES8326_SDINOUT1_IO, ES8326_IO_INPUT);
 		break;
+	case SND_SOC_BIAS_OFF:
+		clk_disable_unprepare(es8326->mclk);
+		break;
 	}
 
 	return 0;
@@ -724,13 +732,15 @@ static int es8326_calibrate(struct snd_soc_component *component)
 		regmap_write(es8326->regmap, ES8326_CLK_DIV1, 0x01);
 		regmap_write(es8326->regmap, ES8326_CLK_DLL, 0x30);
 		regmap_write(es8326->regmap, ES8326_CLK_MUX, 0xed);
+		regmap_write(es8326->regmap, ES8326_CLK_DAC_SEL, 0x08);
 		regmap_write(es8326->regmap, ES8326_CLK_TRI, 0xc1);
 		regmap_write(es8326->regmap, ES8326_DAC_MUTE, 0x03);
 		regmap_write(es8326->regmap, ES8326_ANA_VSEL, 0x7f);
-		regmap_write(es8326->regmap, ES8326_VMIDLOW, 0x33);
+		regmap_write(es8326->regmap, ES8326_VMIDLOW, 0x03);
 		regmap_write(es8326->regmap, ES8326_DAC2HPMIX, 0x88);
-		regmap_write(es8326->regmap, ES8326_HP_VOL, 0x80);
+		usleep_range(15000, 20000);
 		regmap_write(es8326->regmap, ES8326_HP_OFFSET_CAL, 0x8c);
+		usleep_range(15000, 20000);
 		regmap_write(es8326->regmap, ES8326_RESET, 0xc0);
 		usleep_range(15000, 20000);
 
@@ -768,27 +778,27 @@ static int es8326_resume(struct snd_soc_component *component)
 	regmap_write(es8326->regmap, ES8326_RESET, 0x1f);
 	regmap_write(es8326->regmap, ES8326_VMIDSEL, 0x0E);
 	usleep_range(10000, 15000);
-	regmap_write(es8326->regmap, ES8326_HPJACK_TIMER, 0x88);
+	regmap_write(es8326->regmap, ES8326_HPJACK_TIMER, 0xe9);
+	regmap_write(es8326->regmap, ES8326_ANA_MICBIAS, 0x4b);
 	/* set headphone default type and detect pin */
-	regmap_write(es8326->regmap, ES8326_HPDET_TYPE, 0x81);
+	regmap_write(es8326->regmap, ES8326_HPDET_TYPE, 0x83);
 	regmap_write(es8326->regmap, ES8326_CLK_RESAMPLE, 0x05);
+	regmap_write(es8326->regmap, ES8326_HP_MISC, 0x30);
 
 	/* set internal oscillator as clock source of headpone cp */
-	regmap_write(es8326->regmap, ES8326_CLK_DIV_CPC, 0x84);
+	regmap_write(es8326->regmap, ES8326_CLK_DIV_CPC, 0x89);
 	regmap_write(es8326->regmap, ES8326_CLK_CTL, ES8326_CLK_ON);
 	/* clock manager reset release */
 	regmap_write(es8326->regmap, ES8326_RESET, 0x17);
 	/* set headphone detection as half scan mode */
-	regmap_write(es8326->regmap, ES8326_HP_MISC, 0x08);
+	regmap_write(es8326->regmap, ES8326_HP_MISC, 0x30);
 	regmap_write(es8326->regmap, ES8326_PULLUP_CTL, 0x00);
 
 	/* enable headphone driver */
 	regmap_write(es8326->regmap, ES8326_HP_DRIVER, 0xa7);
 	usleep_range(2000, 5000);
-	regmap_write(es8326->regmap, ES8326_HP_DRIVER_REF, 0xab);
-	usleep_range(2000, 5000);
-	regmap_write(es8326->regmap, ES8326_HP_DRIVER_REF, 0xbb);
-	usleep_range(2000, 5000);
+	regmap_write(es8326->regmap, ES8326_HP_DRIVER_REF, 0xa3);
+	regmap_write(es8326->regmap, ES8326_HP_DRIVER_REF, 0xb3);
 	regmap_write(es8326->regmap, ES8326_HP_DRIVER, 0xa1);
 
 	regmap_write(es8326->regmap, ES8326_CLK_INV, 0x00);
@@ -802,9 +812,6 @@ static int es8326_resume(struct snd_soc_component *component)
 	/* set ADC and DAC in low power mode */
 	regmap_write(es8326->regmap, ES8326_ANA_LP, 0xf0);
 
-	/* force micbias on */
-	regmap_write(es8326->regmap, ES8326_ANA_MICBIAS, 0x4f);
-	regmap_write(es8326->regmap, ES8326_SYS_BIAS, 0x08);
 	regmap_write(es8326->regmap, ES8326_ANA_VSEL, 0x7F);
 	/* select vdda as micbias source */
 	regmap_write(es8326->regmap, ES8326_VMIDLOW, 0x23);
@@ -832,6 +839,7 @@ static int es8326_resume(struct snd_soc_component *component)
 			((es8326->version == ES8326_VERSION_B) ?
 			(ES8326_HP_DET_SRC_PIN9 | es8326->jack_pol) :
 			(ES8326_HP_DET_SRC_PIN9 | es8326->jack_pol | 0x04)));
+	regmap_write(es8326->regmap, ES8326_HP_VOL, 0x11);
 
 	es8326->jack_remove_retry = 0;
 	es8326->hp = 0;
-- 
2.53.0



