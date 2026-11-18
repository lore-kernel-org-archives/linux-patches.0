Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023255;
	b=toeQPzXef5x8QAUH761goNyBbm09QQgZVsxfqLPdvOOOjVCvU679+lHmv04E8/vQ6EhX
	 13SVqmcWHWinuhr8vpzb681zCR/2FoJAb6neQdfLAthBnBsCl5kijIOq3VCXNJ2YtPICJ
	 Fwuwi2xl4AbyrL0EY3raNViP506r9XlPZeJkDVOvWVl41ueaqmbr61T79tZ6ZWCX0lplW
	 S80xydrKZZYIsk97/CYcEZddl0gDCoiAcTUsXdxsjyT8MC3C1lKaybYU/JFMNyQLiclCD
	 HmHhBaogo8Fxf+Q2DzbXB2utyQDPTp1vA8GcVEfmIoWCRX+8GP0vuOzsGjMsdy9KAPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KTxlH5DnBwOhzdGvo5hCImGI0BB1y8wbHCyeby+TbGM=;
	b=vyL8SP5RoSySPSUzO0QFsjY9EwG/tXiesE2Y1hjgEXKVETG7GodW5Q6eN3mK/D0vlvmz
	 Nclrha9uDEjuhJKmwpv6LQGR6Z8VfM51Zliq7eohKD/42BLVRKxjlQ0y/mo2wAOI084yF
	 TPdv/qjrKhPAllHbAzuSHvUIBSUZOv+Dmupc1Qg7AfkvQegkefcMVB49/SIlZ+67etpOW
	 qYZV1Bl2GuE3NF3VZMEmKnwc0JPK+p5caAyMggX/MwoZensxkVynJMVGruFPUDHgE+N2f
	 Eze9QnNhMqtcyXy3zKSaR2lpLFmpZg6XrjgT5RE8gTMs/BVvMWp6bymoa37XaLJ+T9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lWeng26N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B04606A320;
	Wed, 18 Nov 2026 17:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lWeng26N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224C01F000C4;
	Wed, 18 Nov 2026 17:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023255;
	bh=KTxlH5DnBwOhzdGvo5hCImGI0BB1y8wbHCyeby+TbGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lWeng26N9yfUnbdqCzK0Nx6mZCoE4xHcMWScdnWBF+WLNfmTOPOiSXxc9IOUySxZa
	 fVwOsTjuTb8IKNgSuy1P3WLHyWvuvtSjlkqh1Hgq6ey+UEKPyl1CaG/qZhBF7BJlUQ
	 6Yn64mo3IQ+9gwx0BV6hgI0/B2XSmOi5eYoN7GAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0305/2151] ASoC: codecs: nau8822: convert to snd_soc_dapm_xxx()
Date: Wed, 18 Nov 2026 15:34:00 +0100
Message-ID: <20261118150133.021862353@linuxfoundation.org>
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

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 8000e233e920062dc08222fc6911e13c193d7719 ]

This patch converts below functions.

dapm->dev					-> snd_soc_dapm_to_dev()
dapm->card					-> snd_soc_dapm_to_card()
dapm->component					-> snd_soc_dapm_to_component()

dapm_kcontrol_get_value()			-> snd_soc_dapm_kcontrol_get_value()

snd_soc_component_enable_pin()			-> snd_soc_dapm_enable_pin()
snd_soc_component_enable_pin_unlocked()		-> snd_soc_dapm_enable_pin_unlocked()
snd_soc_component_disable_pin()			-> snd_soc_dapm_disable_pin()
snd_soc_component_disable_pin_unlocked()	-> snd_soc_dapm_disable_pin_unlocked()
snd_soc_component_nc_pin()			-> snd_soc_dapm_nc_pin()
snd_soc_component_nc_pin_unlocked()		-> snd_soc_dapm_nc_pin_unlocked()
snd_soc_component_get_pin_status()		-> snd_soc_dapm_get_pin_status()
snd_soc_component_force_enable_pin()		-> snd_soc_dapm_force_enable_pin()
snd_soc_component_force_enable_pin_unlocked()	-> snd_soc_dapm_force_enable_pin_unlocked()
snd_soc_component_force_bias_level()		-> snd_soc_dapm_force_bias_level()
snd_soc_component_get_bias_level()		-> snd_soc_dapm_get_bias_level()
snd_soc_component_init_bias_level()		-> snd_soc_dapm_init_bias_level()
snd_soc_component_get_dapm()			-> snd_soc_component_to_dapm()

snd_soc_dapm_kcontrol_component()		-> snd_soc_dapm_kcontrol_to_component()
snd_soc_dapm_kcontrol_widget()			-> snd_soc_dapm_kcontrol_to_widget()
snd_soc_dapm_kcontrol_dapm()			-> snd_soc_dapm_kcontrol_to_dapm()
snd_soc_dapm_np_pin()				-> snd_soc_dapm_disable_pin()

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/87ldkd4dsp.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 9c343445b349 ("ASoC: nau8822: keep regcache offline while supplies are off")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8822.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/nau8822.c b/sound/soc/codecs/nau8822.c
index 1386ba6041998..7c84e9e4b8b3c 100644
--- a/sound/soc/codecs/nau8822.c
+++ b/sound/soc/codecs/nau8822.c
@@ -959,6 +959,7 @@ static int nau8822_set_bias_level(struct snd_soc_component *component,
 				 enum snd_soc_bias_level level)
 {
 	struct nau8822 *nau8822 = snd_soc_component_get_drvdata(component);
+	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
 
 	switch (level) {
 	case SND_SOC_BIAS_ON:
@@ -966,7 +967,7 @@ static int nau8822_set_bias_level(struct snd_soc_component *component,
 
 	case SND_SOC_BIAS_PREPARE:
 		if (nau8822->mclk &&
-			snd_soc_component_get_bias_level(component) != SND_SOC_BIAS_ON) {
+			snd_soc_dapm_get_bias_level(dapm) != SND_SOC_BIAS_ON) {
 			int ret = clk_prepare_enable(nau8822->mclk);
 
 			if (ret) {
@@ -983,7 +984,7 @@ static int nau8822_set_bias_level(struct snd_soc_component *component,
 
 	case SND_SOC_BIAS_STANDBY:
 		if (nau8822->mclk &&
-			snd_soc_component_get_bias_level(component) != SND_SOC_BIAS_OFF)
+			snd_soc_dapm_get_bias_level(dapm) != SND_SOC_BIAS_OFF)
 			clk_disable_unprepare(nau8822->mclk);
 
 		snd_soc_component_update_bits(component,
@@ -991,8 +992,7 @@ static int nau8822_set_bias_level(struct snd_soc_component *component,
 			NAU8822_IOBUF_EN | NAU8822_ABIAS_EN,
 			NAU8822_IOBUF_EN | NAU8822_ABIAS_EN);
 
-		if (snd_soc_component_get_bias_level(component) ==
-			SND_SOC_BIAS_OFF) {
+		if (snd_soc_dapm_get_bias_level(dapm) == SND_SOC_BIAS_OFF) {
 			snd_soc_component_update_bits(component,
 				NAU8822_REG_POWER_MANAGEMENT_1,
 				NAU8822_REFIMP_MASK, NAU8822_REFIMP_3K);
@@ -1055,8 +1055,9 @@ static struct snd_soc_dai_driver nau8822_dai = {
 static int nau8822_suspend(struct snd_soc_component *component)
 {
 	struct nau8822 *nau8822 = snd_soc_component_get_drvdata(component);
+	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
 
-	snd_soc_component_force_bias_level(component, SND_SOC_BIAS_OFF);
+	snd_soc_dapm_force_bias_level(dapm, SND_SOC_BIAS_OFF);
 
 	regcache_mark_dirty(nau8822->regmap);
 
@@ -1066,10 +1067,11 @@ static int nau8822_suspend(struct snd_soc_component *component)
 static int nau8822_resume(struct snd_soc_component *component)
 {
 	struct nau8822 *nau8822 = snd_soc_component_get_drvdata(component);
+	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
 
 	regcache_sync(nau8822->regmap);
 
-	snd_soc_component_force_bias_level(component, SND_SOC_BIAS_STANDBY);
+	snd_soc_dapm_force_bias_level(dapm, SND_SOC_BIAS_STANDBY);
 
 	return 0;
 }
-- 
2.53.0



