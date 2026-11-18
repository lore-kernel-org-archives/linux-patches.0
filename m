Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023902;
	b=hsAwiLBM9Bo2JcEqn/ZSg55N6+K0VWHnQdCOfm/1+WQXNbnaV8H4K85HeY1MbLQiKRlW
	 F1VMDOgO3km7YgfpgtjgzRS9UFYXs7o1a9vrGiA8enYkwzFoKXOjgZxGHenCbmJScz++7
	 9BlgtjBpUUsuPttHDgtcjvhqFumqFmU+HFXYQ+sh1hdJ4U648/nZ+eqIT+VqCwOvADN5q
	 DgnTu2RWHaQP0cUHEvqzJY21Vs1veEUApM6FauM91EJKBP0ea7BadJ1+Mnnzl+xYP2pUv
	 GyeAssHuJgbu+M9u0gSGcrt8vadGr1VzmpUh9JbQUqk6nynACvLdUiVavvjP6/5Jtfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F8OywP8uvJ1Ot7SG0Cj2+KRvuyjvxZBGIsTyEK7K7qw=;
	b=Ia3W07w4vHqLIuSvcpwm+nCLswHMbNl6RLkSHeJlFpXgbph+5AR0b0KLgHjQHYqcOOtO
	 8Wji/xm4S4B3bNt+2cjdREQ7D7IEg03U8vUN4HLDqQJrafJmhlbVPkEPR/ZrgIP2UzSn+
	 bSBBVLNznDwZnkaYxbya781JxlDU+FCpjx1icSpGMVLECuxwLOTMl2xXnO5103+1oL/Hq
	 OEyDxxYxT29F8/meUv1Vt1IuUUW1ctBJe6yytg1ULCnaak6+sY8Y8rkrKcQA/f7w0jbqb
	 gjmJlWCID4rOYQRCp8g0CyY981WN2qwgR0ernE9KWSq8IjiuxXBcgo7WI81hBt/NkQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JeRT/KI6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EC2606A32C;
	Wed, 18 Nov 2026 17:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JeRT/KI6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405CB1F000C4;
	Wed, 18 Nov 2026 17:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023901;
	bh=F8OywP8uvJ1Ot7SG0Cj2+KRvuyjvxZBGIsTyEK7K7qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JeRT/KI6raCDSuAJl6VIrMzQkmL5eMTYVSNybyOiU7eYIgRRXGP3zt57OlMqWtLvn
	 y+MYArJFWrXh+m8KgvAsEgt1d4w/ylcdGfD6CeO8rPDLGAzMxg5LGTs+b9LjA0W++M
	 1prSUF0/sE7T4o1QB+MIEMxkgh4EbsXl/DEoFleY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0534/2151] ASoC: ab8500: Remove the nonfunctional sidetone apply control
Date: Wed, 18 Nov 2026 15:37:49 +0100
Message-ID: <20261118150141.461613319@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit ec75e653b70ce26ea68187c2069722baa80efadb ]

After the coefficient controls were removed, writing "Apply FIR"
programs 128 zero coefficients and reports that the sidetone filter is
configured. The associated ANC configuration DAPM pins are also now
unreachable dead infrastructure.

Remove the misleading status/apply control, its private state, and the
obsolete configuration-only DAPM pins. Keep the direct sidetone reset
and remaining hardware controls.

Fixes: e366ce8b22ec ("ASoC: codecs: ab8500: Remove suspicious code")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260831-ab8500-codec-fixes-v1-5-f85024e717e3@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0d46182a1be7 ("ASoC: ab8500: Skip digital microphone support on AB8505")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ab8500-codec.c | 114 --------------------------------
 1 file changed, 114 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index 167f021c7ecbc..11142d15df450 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -14,17 +14,14 @@
  *         for ST-Ericsson.
  */
 
-#include <linux/cleanup.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
-#include <linux/delay.h>
 #include <linux/pm.h>
 #include <linux/platform_device.h>
-#include <linux/mutex.h>
 #include <linux/mfd/abx500/ab8500.h>
 #include <linux/mfd/abx500.h>
 #include <linux/mfd/abx500/ab8500-sysctrl.h>
@@ -54,32 +51,9 @@
 /* Macrocell register definitions */
 #define AB8500_GPIO_DIR4_REG			0x13 /* Bank AB8500_MISC */
 
-/* Nr of FIR/IIR-coeff banks in ANC-block */
-#define AB8500_NR_OF_ANC_COEFF_BANKS		2
-
-/* Minimum duration to keep ANC IIR Init bit high or
-low before proceeding with the configuration sequence */
-#define AB8500_ANC_SM_DELAY			2000
-
-/* Sidetone states */
-static const char * const enum_sid_state[] = {
-	"Unconfigured",
-	"Apply FIR",
-	"FIR is configured",
-};
-enum sid_state {
-	SID_UNCONFIGURED = 0,
-	SID_APPLY_FIR = 1,
-	SID_FIR_CONFIGURED = 2,
-};
-
 /* Private data for AB8500 device-driver */
 struct ab8500_codec_drvdata {
 	struct regmap *regmap;
-	struct mutex ctrl_lock;
-
-	/* Sidetone */
-	enum sid_state sid_status;
 };
 
 static inline const char *amic_micbias_str(enum amic_micbias micbias)
@@ -642,9 +616,6 @@ static const struct snd_soc_dapm_widget ab8500_dapm_widgets[] = {
 			NULL, 0),
 	/* Acoustical Noise Cancellation path */
 
-	SND_SOC_DAPM_INPUT("ANC Configure Input"),
-	SND_SOC_DAPM_OUTPUT("ANC Configure Output"),
-
 	SND_SOC_DAPM_MUX("ANC Source",
 			SND_SOC_NOPM, 0, 0,
 			dapm_anc_in_select),
@@ -687,10 +658,6 @@ static const struct snd_soc_dapm_route ab8500_dapm_routes[] = {
 	{"Main Supply", NULL, "Audio Power"},
 	{"Main Supply", NULL, "Audio Analog Power"},
 
-	/* ANC Configure */
-	{"ANC Configure Input", NULL, "Main Supply"},
-	{"ANC Configure Output", NULL, "ANC Configure Input"},
-
 	/* Powerup charge pump if DA1/2 is in use */
 
 	{"DA_IN1", NULL, "ab8500_0p"},
@@ -972,75 +939,6 @@ static const struct snd_soc_dapm_route ab8500_dapm_routes_mic2_vamicx[] = {
 	{"MIC2 V-AMICx Enable", NULL, "V-AMIC2"},
 };
 
-/*
- * Control-events
- */
-
-static int sid_status_control_get(struct snd_kcontrol *kcontrol,
-		struct snd_ctl_elem_value *ucontrol)
-{
-	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
-	struct ab8500_codec_drvdata *drvdata = dev_get_drvdata(component->dev);
-
-	guard(mutex)(&drvdata->ctrl_lock);
-	ucontrol->value.enumerated.item[0] = drvdata->sid_status;
-
-	return 0;
-}
-
-/* Write sidetone FIR-coefficients configuration sequence */
-static int sid_status_control_put(struct snd_kcontrol *kcontrol,
-				struct snd_ctl_elem_value *ucontrol)
-{
-	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
-	struct ab8500_codec_drvdata *drvdata = dev_get_drvdata(component->dev);
-	unsigned int param, sidconf;
-	int status = 1;
-
-	dev_dbg(component->dev, "%s: Enter\n", __func__);
-
-	if (ucontrol->value.enumerated.item[0] != SID_APPLY_FIR) {
-		dev_err(component->dev,
-			"%s: ERROR: This control supports '%s' only!\n",
-			__func__, enum_sid_state[SID_APPLY_FIR]);
-		return -EIO;
-	}
-
-	guard(mutex)(&drvdata->ctrl_lock);
-
-	sidconf = snd_soc_component_read(component, AB8500_SIDFIRCONF);
-	if (((sidconf & BIT(AB8500_SIDFIRCONF_FIRSIDBUSY)) != 0)) {
-		if ((sidconf & BIT(AB8500_SIDFIRCONF_ENFIRSIDS)) == 0) {
-			dev_err(component->dev, "%s: Sidetone busy while off!\n",
-				__func__);
-			status = -EPERM;
-		} else {
-			status = -EBUSY;
-		}
-		dev_dbg(component->dev, "%s: Exit\n", __func__);
-		return status;
-	}
-
-	snd_soc_component_write(component, AB8500_SIDFIRADR, 0);
-
-	for (param = 0; param < AB8500_SID_FIR_COEFFS; param++) {
-		snd_soc_component_write(component, AB8500_SIDFIRCOEF1, 0);
-		snd_soc_component_write(component, AB8500_SIDFIRCOEF2, 0);
-	}
-
-	snd_soc_component_update_bits(component, AB8500_SIDFIRADR,
-		BIT(AB8500_SIDFIRADR_FIRSIDSET),
-		BIT(AB8500_SIDFIRADR_FIRSIDSET));
-	snd_soc_component_update_bits(component, AB8500_SIDFIRADR,
-		BIT(AB8500_SIDFIRADR_FIRSIDSET), 0);
-
-	drvdata->sid_status = SID_FIR_CONFIGURED;
-
-	dev_dbg(component->dev, "%s: Exit\n", __func__);
-
-	return status;
-}
-
 /*
  * Controls - Non-DAPM ASoC
  */
@@ -1324,9 +1222,6 @@ static SOC_ENUM_SINGLE_DECL(soc_enum_bfifomast,
 			AB8500_FIFOCONF3, AB8500_FIFOCONF3_BFIFOMAST_SHIFT,
 			enum_slavemaster);
 
-/* Sidetone */
-static SOC_ENUM_SINGLE_EXT_DECL(soc_enum_sidstate, enum_sid_state);
-
 /* ANC */
 
 static struct snd_kcontrol_new ab8500_ctrls[] = {
@@ -1617,8 +1512,6 @@ static struct snd_kcontrol_new ab8500_ctrls[] = {
 		AB8500_ANC_WARP_DELAY_MIN, AB8500_ANC_WARP_DELAY_MAX, 0),
 
 	/* Sidetone */
-	SOC_ENUM_EXT("Sidetone Status", soc_enum_sidstate,
-		sid_status_control_get, sid_status_control_put),
 	SOC_SINGLE_STROBE("Sidetone Reset",
 		AB8500_SIDFIRADR, AB8500_SIDFIRADR_FIRSIDSET, 0),
 };
@@ -2145,10 +2038,8 @@ static void ab8500_codec_of_probe(struct device *dev, struct device_node *np,
 
 static int ab8500_codec_probe(struct snd_soc_component *component)
 {
-	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
 	struct device *dev = component->dev;
 	struct device_node *np = dev->of_node;
-	struct ab8500_codec_drvdata *drvdata = dev_get_drvdata(dev);
 	struct ab8500_codec_platform_data codec_pdata;
 	int status;
 
@@ -2181,10 +2072,6 @@ static int ab8500_codec_probe(struct snd_soc_component *component)
 	snd_soc_component_write(component, AB8500_SHORTCIRCONF,
 		      BIT(AB8500_SHORTCIRCONF_HSZCDDIS));
 
-	snd_soc_dapm_disable_pin(dapm, "ANC Configure Input");
-
-	mutex_init(&drvdata->ctrl_lock);
-
 	return status;
 }
 
@@ -2213,7 +2100,6 @@ static int ab8500_codec_driver_probe(struct platform_device *pdev)
 			GFP_KERNEL);
 	if (!drvdata)
 		return -ENOMEM;
-	drvdata->sid_status = SID_UNCONFIGURED;
 	dev_set_drvdata(&pdev->dev, drvdata);
 
 	drvdata->regmap = devm_regmap_init(&pdev->dev, NULL, &pdev->dev,
-- 
2.53.0



