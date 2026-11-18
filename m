Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039354;
	b=BGQ5sfANr3rCw2YEKu2PX3qcDirQt6DR74fGRe3UFMMeMgTHhkMi4t5ZRqXuLMbxDVPy
	 2KHCdkaqTJH7b02sHSOufbUQtOJxzEVPN5HRtaQnmwOv1nSNtORjNl7U307FVoFnDt6Kc
	 yo2AWNtth2zOJZQrUWl/wi26sOaTylBDNwbMD3fC8ZfLm9kTSU69Kqbx2rgLq+XyowHEA
	 5kd4L9QWsNEd3RYwafE7m154LvuO6yqV1uE5sK1sEUs0OzqwAt14PJjamUNW9vSugSEDh
	 4SkQOZtTIPsR0f6R3O4jRpocA7tnKYPwynfUX4pfbEMVb3gVtiHLWLpUJuYO3Y7y71g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AQRjus4klodVtk4xaT1GTOS9UnoRAO/A5mdkRqr5QK8=;
	b=fbXzM3y29vKLFdlSVlt1vez57ynGaUuLcbytVS4Z8Avt2NDywVrWQAxQwC3Egpd1GqZH
	 M3dBqHxtd9XMw/qZeldxDP9mkH1jipLWK8m/pwPMuhUVewGAC7iG6G0vmoS2sFseVWDQk
	 yz5mTs6F6sz1HHPscw0vg4+TVDy6HNDp8H5ofvTbc8lb4XjacsipsO6mC8y83H1JuFCJJ
	 4oBIxNaIVxlSEZT3uoA4THzUhOkN+GSPUpvB/mwTGBfqUC8cSIM4DW356hCEg+rI2D/40
	 uC7ZJVClmpnBCDMKprQeOJ/1W5qrpOWaY5zmk1iwGdKq9nYy11Jpf7kk2YhTwis+FUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cxsMqVuw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A54D606A31C;
	Wed, 18 Nov 2026 22:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cxsMqVuw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4000D1F000C5;
	Wed, 18 Nov 2026 22:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039353;
	bh=AQRjus4klodVtk4xaT1GTOS9UnoRAO/A5mdkRqr5QK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cxsMqVuwOZ663voQWM2d2qxnucr7eaPIcqOEYz7vNcImnAwej1lFZfgYqOzIT0NBr
	 F9wQvbszWxwBxEx0WxgIvpvnRCwPsUKoPl3dII9o6KOre2sf97Wvo6voRfkYQZARNE
	 2qHthAR6ZTr9lu2pfzqVxKPbbNm0gyClQdRS3JiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Ning <zhuning0077@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2070/3318] ASoC: codecs: ES8326: Improving the THD+N performance
Date: Wed, 18 Nov 2026 15:44:52 +0100
Message-ID: <20261118150424.181972170@linuxfoundation.org>
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

[ Upstream commit 14a0a1ec3335ac3945a96437c35465e4a9616b88 ]

We update the values of some registers in the initialization
sequence in es8326_resume function to improve THD+N performance.
THD+N performance decreases if the output level on headphone is
close to full scale. So we change the register setting in
es8326_jack_detect_handler function to improve THD+N performance
if headphone pulgged. Also, the register setting should be restored
when the headset is unplugged

Signed-off-by: Zhu Ning <zhuning0077@gmail.com>
Link: https://msgid.link/r/20240120101240.12496-3-zhuning0077@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 349e94679968 ("ASoC: es8326: report resume restore errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8326.c | 21 +++++++++++++--------
 sound/soc/codecs/es8326.h |  2 +-
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index 5cdd0974e4ae3..ca2165f4ad46b 100644
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -635,6 +635,8 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 			es8326->hp = 0;
 		}
 		regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x01);
+		regmap_write(es8326->regmap, ES8326_SYS_BIAS, 0x0a);
+		regmap_update_bits(es8326->regmap, ES8326_HP_DRIVER_REF, 0x0f, 0x03);
 		/*
 		 * Inverted HPJACK_POL bit to trigger one IRQ to double check HP Removal event
 		 */
@@ -660,6 +662,8 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x01);
 			usleep_range(50000, 70000);
 			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x00);
+			regmap_write(es8326->regmap, ES8326_SYS_BIAS, 0x1f);
+			regmap_update_bits(es8326->regmap, ES8326_HP_DRIVER_REF, 0x0f, 0x08);
 			queue_delayed_work(system_wq, &es8326->jack_detect_work,
 					msecs_to_jiffies(100));
 			es8326->hp = 1;
@@ -729,14 +733,14 @@ static int es8326_calibrate(struct snd_soc_component *component)
 	if ((es8326->version == ES8326_VERSION_B) && (es8326->calibrated == false)) {
 		dev_dbg(component->dev, "ES8326_VERSION_B, calibrating\n");
 		regmap_write(es8326->regmap, ES8326_CLK_INV, 0xc0);
-		regmap_write(es8326->regmap, ES8326_CLK_DIV1, 0x01);
+		regmap_write(es8326->regmap, ES8326_CLK_DIV1, 0x03);
 		regmap_write(es8326->regmap, ES8326_CLK_DLL, 0x30);
 		regmap_write(es8326->regmap, ES8326_CLK_MUX, 0xed);
 		regmap_write(es8326->regmap, ES8326_CLK_DAC_SEL, 0x08);
 		regmap_write(es8326->regmap, ES8326_CLK_TRI, 0xc1);
 		regmap_write(es8326->regmap, ES8326_DAC_MUTE, 0x03);
 		regmap_write(es8326->regmap, ES8326_ANA_VSEL, 0x7f);
-		regmap_write(es8326->regmap, ES8326_VMIDLOW, 0x03);
+		regmap_write(es8326->regmap, ES8326_VMIDLOW, 0x23);
 		regmap_write(es8326->regmap, ES8326_DAC2HPMIX, 0x88);
 		usleep_range(15000, 20000);
 		regmap_write(es8326->regmap, ES8326_HP_OFFSET_CAL, 0x8c);
@@ -777,13 +781,13 @@ static int es8326_resume(struct snd_soc_component *component)
 	/* reset internal clock state */
 	regmap_write(es8326->regmap, ES8326_RESET, 0x1f);
 	regmap_write(es8326->regmap, ES8326_VMIDSEL, 0x0E);
+	regmap_write(es8326->regmap, ES8326_ANA_LP, 0xf0);
 	usleep_range(10000, 15000);
 	regmap_write(es8326->regmap, ES8326_HPJACK_TIMER, 0xe9);
-	regmap_write(es8326->regmap, ES8326_ANA_MICBIAS, 0x4b);
+	regmap_write(es8326->regmap, ES8326_ANA_MICBIAS, 0xcb);
 	/* set headphone default type and detect pin */
 	regmap_write(es8326->regmap, ES8326_HPDET_TYPE, 0x83);
 	regmap_write(es8326->regmap, ES8326_CLK_RESAMPLE, 0x05);
-	regmap_write(es8326->regmap, ES8326_HP_MISC, 0x30);
 
 	/* set internal oscillator as clock source of headpone cp */
 	regmap_write(es8326->regmap, ES8326_CLK_DIV_CPC, 0x89);
@@ -791,14 +795,15 @@ static int es8326_resume(struct snd_soc_component *component)
 	/* clock manager reset release */
 	regmap_write(es8326->regmap, ES8326_RESET, 0x17);
 	/* set headphone detection as half scan mode */
-	regmap_write(es8326->regmap, ES8326_HP_MISC, 0x30);
+	regmap_write(es8326->regmap, ES8326_HP_MISC, 0x3d);
 	regmap_write(es8326->regmap, ES8326_PULLUP_CTL, 0x00);
 
 	/* enable headphone driver */
+	regmap_write(es8326->regmap, ES8326_HP_VOL, 0xc4);
 	regmap_write(es8326->regmap, ES8326_HP_DRIVER, 0xa7);
 	usleep_range(2000, 5000);
-	regmap_write(es8326->regmap, ES8326_HP_DRIVER_REF, 0xa3);
-	regmap_write(es8326->regmap, ES8326_HP_DRIVER_REF, 0xb3);
+	regmap_write(es8326->regmap, ES8326_HP_DRIVER_REF, 0x23);
+	regmap_write(es8326->regmap, ES8326_HP_DRIVER_REF, 0x33);
 	regmap_write(es8326->regmap, ES8326_HP_DRIVER, 0xa1);
 
 	regmap_write(es8326->regmap, ES8326_CLK_INV, 0x00);
@@ -827,7 +832,7 @@ static int es8326_resume(struct snd_soc_component *component)
 		    (ES8326_IO_DMIC_CLK << ES8326_SDINOUT1_SHIFT));
 	regmap_write(es8326->regmap, ES8326_SDINOUT23_IO, ES8326_IO_INPUT);
 
-	regmap_write(es8326->regmap, ES8326_ANA_PDN, 0x3b);
+	regmap_write(es8326->regmap, ES8326_ANA_PDN, 0x00);
 	regmap_write(es8326->regmap, ES8326_RESET, ES8326_CSM_ON);
 	regmap_update_bits(es8326->regmap, ES8326_PGAGAIN, ES8326_MIC_SEL_MASK,
 			   ES8326_MIC1_SEL);
diff --git a/sound/soc/codecs/es8326.h b/sound/soc/codecs/es8326.h
index 90a08351d6acd..0f491db6d8322 100644
--- a/sound/soc/codecs/es8326.h
+++ b/sound/soc/codecs/es8326.h
@@ -100,7 +100,7 @@
 #define ES8326_MUTE (3 << 0)
 
 /* ES8326_CLK_CTL */
-#define ES8326_CLK_ON (0x7f << 0)
+#define ES8326_CLK_ON (0x7e << 0)
 #define ES8326_CLK_OFF (0 << 0)
 
 /* ES8326_CLK_INV */
-- 
2.53.0



