Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023242;
	b=1dk0KYK4SiGSgyFIgLwSw+1lsd2PARufMavwcMRahoj5TnwOFaxSYAguBT4BtmvFt1hY
	 sS5mI/X1KuTPQY3RzXl3Ztw1TGbnQt2pUQP8EdtOS9YRUBajGJ7mcALNTazpjE4vgC5H/
	 +9x6Ul1drv0GsvIvuHYwsYb8U5gaD1O+Q3lNgPM96y8vbv/HMDnx01RdaIn1KgIzbBFRY
	 0K34aCZbSWYSXo4bQSBn/0MK49sBQaX7F1EHNlIDU9SkzENqdAkLNf3japdVccMfJzsEJ
	 V7qQ9Dp4vOpTSVyUykgzMWagP/ZSB4+bKNlsFxelnO8vUaQTGSzR8EYaUlgGalCAOJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023242;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v3JO4etWAPJQXzhPPM1MgaPNCGUN8KEsoI9Oj1Oyop4=;
	b=gEdlS+uLnjaAS2V88nOp4gF3YBerHGO8CmTzLmrF/5vZ88Gy6uFxce/Fe7wdxE77cZxT
	 TrLIg+ozBpEZ0wmj6v29xRg1YFamTFRbdrrjMIGt+TVhQ/kspe6CVahMcUEYdSa3WnzHM
	 8OxeoF5M0FRq11RecKuH1BUS8ZYUTYaTgFl5Gtl4bfrHmnpxo0NneEWvmo9WE22bNbXcb
	 8nWtOzLSN9L8PWbrIOPstfmVPRzVdYTJvA2qNiOvYkU5CRPXjer2O08wrs856mIqWvQKj
	 kwmioPjHK/rvilB3g2YNyfGMze1nXDD2EcQ9RKZTOhp3MhigUCZXBB10PIQgphlAMSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BfzglLv/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4A7606A32F;
	Wed, 18 Nov 2026 17:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BfzglLv/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EDE1F000C4;
	Wed, 18 Nov 2026 17:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023242;
	bh=v3JO4etWAPJQXzhPPM1MgaPNCGUN8KEsoI9Oj1Oyop4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BfzglLv/srbIZwrBcWzHKuw0eBrwlb7Mbkmu+Ii2Wd1Yi/ut0omem4oYpv3qOpmUt
	 WXJc9gOyVU7PSzwhCHLShSH/zEzrc0TppS0huncKXl2IQ2w5mQ+92721oSiXqwc1Xh
	 edLX5N4fwm0aKuYMfxwHHmXQhJCWKuEiFv29njzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0293/2151] ASoC: codecs: sta32x: convert to snd_soc_dapm_xxx()
Date: Wed, 18 Nov 2026 15:33:48 +0100
Message-ID: <20261118150132.581457509@linuxfoundation.org>
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

[ Upstream commit 8454435315e5a6e2f8e531b5ec038c6db4d6ebfe ]

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
Link: https://patch.msgid.link/87zf8t1kjp.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 3e71dc4508bc ("ASoC: sta32x: make power restoration transactional")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sta32x.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/sta32x.c b/sound/soc/codecs/sta32x.c
index 24d4b643917da..bba45c813d4cb 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -799,6 +799,7 @@ static int sta32x_set_bias_level(struct snd_soc_component *component,
 {
 	int ret;
 	struct sta32x_priv *sta32x = snd_soc_component_get_drvdata(component);
+	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
 
 	dev_dbg(component->dev, "level = %d\n", level);
 	switch (level) {
@@ -813,7 +814,7 @@ static int sta32x_set_bias_level(struct snd_soc_component *component,
 		break;
 
 	case SND_SOC_BIAS_STANDBY:
-		if (snd_soc_component_get_bias_level(component) == SND_SOC_BIAS_OFF) {
+		if (snd_soc_dapm_get_bias_level(dapm) == SND_SOC_BIAS_OFF) {
 			ret = regulator_bulk_enable(ARRAY_SIZE(sta32x->supplies),
 						    sta32x->supplies);
 			if (ret != 0) {
@@ -870,6 +871,7 @@ static struct snd_soc_dai_driver sta32x_dai = {
 
 static int sta32x_probe(struct snd_soc_component *component)
 {
+	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
 	struct sta32x_priv *sta32x = snd_soc_component_get_drvdata(component);
 	struct sta32x_platform_data *pdata = sta32x->pdata;
 	int i, ret = 0, thermal = 0;
@@ -974,7 +976,7 @@ static int sta32x_probe(struct snd_soc_component *component)
 	if (sta32x->pdata->needs_esd_watchdog)
 		INIT_DELAYED_WORK(&sta32x->watchdog_work, sta32x_watchdog);
 
-	snd_soc_component_force_bias_level(component, SND_SOC_BIAS_STANDBY);
+	snd_soc_dapm_force_bias_level(dapm, SND_SOC_BIAS_STANDBY);
 	/* Bias level configuration will have done an extra enable */
 	regulator_bulk_disable(ARRAY_SIZE(sta32x->supplies), sta32x->supplies);
 
-- 
2.53.0



