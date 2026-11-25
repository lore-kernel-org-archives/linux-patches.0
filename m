Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625107;
	b=jyZPUimOWU9Co9oK5WJPYOh9WhYJIK7GtOVKLVZB2zUp+kvnDWW7FQfvPeOaiinab2dw
	 dKoktkXhcmR3sACbXCr9bj3bAcmQHL+E/ZMsVRo2w+JvxGdyb8Nec/xAHMcKTlbO9SEzB
	 KeMQcTQ1nXobLppSrpQH9iyTWcFjNNu0oi4Xdm9vjuPx7IPEx2H20rY9CXwZ/2sEXHdXC
	 52nJ37opRaY8smit3+pdeKonlGAw0yaJ/gDzibLAjiVLFXnc+Cl8S9uRrL2GIfbtrS6+9
	 /iznySqrxv1z0+eSYe6I4Jr0vF8V8Dyhjr4zvWuBovQ4sT4sUisRZiJmD+h4FB3dnjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G64em8swZnh6M3FM0kAHBwtNk1Qook0azJUl7ueK1oI=;
	b=4Dhl+l4y92KiQzAPtzNbRdNy883jLPDmvNHF13Rn9VrHZMdNrfD/Je+AON6Tas15Wr/t
	 GVK+QhJvH2lYSdiDf2z+Plho2OfYe63AXnGA8OtM3oYQVENPdpOPtA2e2FjXyX3grI49j
	 VKlXvnFrqCDGloTbJtokGniOoa92OrxghPP+BLYfVhhvldn3pFRnK/5Jm7krmpBGiIU2B
	 E6qe9Ls94+GpGiY2qjCdlCIroiB8c8jyiAo11Z92gN/5bGVHTuz7Z/ujyJk6sydCm7kHj
	 /9Jbrl4DsswScK6kUCPdzV4Q1zLjez3ZSCs1t8BjMsFl1Avcv9OHLdchxK/6UgbpaZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vb59bjyy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD584606A323;
	Wed, 25 Nov 2026 16:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vb59bjyy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A86E1F000C0;
	Wed, 25 Nov 2026 16:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625107;
	bh=G64em8swZnh6M3FM0kAHBwtNk1Qook0azJUl7ueK1oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vb59bjyy8u0xRZPZrHAb8GHsNAfO1JQlEsr2ZXzzaIM/QMH6ZDDDdLzMGD6qsChWr
	 0C7hnitIqswSSroi9SLR27pLz2Y9rKRMBVMr73eCUW3z4AVD9GbAL72rAuNqrn/m8W
	 6TIDTp6otA21z0BjZQOOl7IR+Q1fLO0pdUmeR29U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 407/816] ASoC: rt1015: make control calibration failures observable
Date: Wed, 25 Nov 2026 15:32:35 +0100
Message-ID: <20261125143858.616052464@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 98fe8aab04cec6fcadeb10a757235225d550be36 ]

The bypass-boost control runs a hardware calibration while bypassing the
register cache. It ignores every register access and cache restore
failure, then publishes both the requested mode and calibration
completion.

Return failures from the complete calibration sequence, always restore
normal cache operation and unlock DAPM, and only publish the control
state after the calibration and final mode write both succeed. The mixer
control callback is an effective error consumer, independent of deferred
component resume.

Fixes: da145172b236 ("ASoC: rt1015: Fix DC calibration on bypass boost mode")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260830142118.36668-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
[ sashal: Replaced the snd_soc_component_to_dapm() local dapm with &component->dapm in the DAPM mutex lock/unlock calls, since that helper is missing here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1015.c | 81 +++++++++++++++++++++++++++++++--------
 1 file changed, 65 insertions(+), 16 deletions(-)

diff --git a/sound/soc/codecs/rt1015.c b/sound/soc/codecs/rt1015.c
index 0f806dde9c39c..02052bdbf5aec 100644
--- a/sound/soc/codecs/rt1015.c
+++ b/sound/soc/codecs/rt1015.c
@@ -491,34 +491,71 @@ static int rt1015_bypass_boost_get(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
-static void rt1015_calibrate(struct rt1015_priv *rt1015)
+static int rt1015_calibrate(struct rt1015_priv *rt1015)
 {
 	struct snd_soc_component *component = rt1015->component;
 	struct regmap *regmap = rt1015->regmap;
+	int ret, sync_ret;
 
 	snd_soc_dapm_mutex_lock(&component->dapm);
 	regcache_cache_bypass(regmap, true);
 
-	regmap_write(regmap, RT1015_CLK_DET, 0x0000);
-	regmap_write(regmap, RT1015_PWR4, 0x00B2);
-	regmap_write(regmap, RT1015_PWR_STATE_CTRL, 0x0009);
+	ret = regmap_write(regmap, RT1015_CLK_DET, 0x0000);
+	if (ret)
+		goto restore_cache;
+
+	ret = regmap_write(regmap, RT1015_PWR4, 0x00B2);
+	if (ret)
+		goto restore_cache;
+
+	ret = regmap_write(regmap, RT1015_PWR_STATE_CTRL, 0x0009);
+	if (ret)
+		goto restore_cache;
+
 	msleep(100);
-	regmap_write(regmap, RT1015_PWR_STATE_CTRL, 0x000A);
+	ret = regmap_write(regmap, RT1015_PWR_STATE_CTRL, 0x000A);
+	if (ret)
+		goto restore_cache;
+
 	msleep(100);
-	regmap_write(regmap, RT1015_PWR_STATE_CTRL, 0x000C);
+	ret = regmap_write(regmap, RT1015_PWR_STATE_CTRL, 0x000C);
+	if (ret)
+		goto restore_cache;
+
 	msleep(100);
-	regmap_write(regmap, RT1015_CLSD_INTERNAL8, 0x2028);
-	regmap_write(regmap, RT1015_CLSD_INTERNAL9, 0x0140);
-	regmap_write(regmap, RT1015_PWR_STATE_CTRL, 0x000D);
+	ret = regmap_write(regmap, RT1015_CLSD_INTERNAL8, 0x2028);
+	if (ret)
+		goto restore_cache;
+
+	ret = regmap_write(regmap, RT1015_CLSD_INTERNAL9, 0x0140);
+	if (ret)
+		goto restore_cache;
+
+	ret = regmap_write(regmap, RT1015_PWR_STATE_CTRL, 0x000D);
+	if (ret)
+		goto restore_cache;
+
 	msleep(300);
-	regmap_write(regmap, RT1015_PWR_STATE_CTRL, 0x0008);
-	regmap_write(regmap, RT1015_SYS_RST1, 0x05F5);
-	regmap_write(regmap, RT1015_CLK_DET, 0x8000);
+	ret = regmap_write(regmap, RT1015_PWR_STATE_CTRL, 0x0008);
+	if (ret)
+		goto restore_cache;
+
+	ret = regmap_write(regmap, RT1015_SYS_RST1, 0x05F5);
+	if (ret)
+		goto restore_cache;
+
+	ret = regmap_write(regmap, RT1015_CLK_DET, 0x8000);
+
+restore_cache:
 
 	regcache_cache_bypass(regmap, false);
 	regcache_mark_dirty(regmap);
-	regcache_sync(regmap);
+	sync_ret = regcache_sync(regmap);
+	if (!ret)
+		ret = sync_ret;
 	snd_soc_dapm_mutex_unlock(&component->dapm);
+
+	return ret;
 }
 
 static int rt1015_bypass_boost_put(struct snd_kcontrol *kcontrol,
@@ -528,6 +565,8 @@ static int rt1015_bypass_boost_put(struct snd_kcontrol *kcontrol,
 		snd_soc_kcontrol_component(kcontrol);
 	struct rt1015_priv *rt1015 =
 		snd_soc_component_get_drvdata(component);
+	int bypass_boost = rt1015->bypass_boost;
+	int ret;
 
 	if (rt1015->dac_is_used) {
 		dev_err(component->dev, "DAC is being used!\n");
@@ -537,13 +576,23 @@ static int rt1015_bypass_boost_put(struct snd_kcontrol *kcontrol,
 	rt1015->bypass_boost = ucontrol->value.integer.value[0];
 	if (rt1015->bypass_boost == RT1015_Bypass_Boost &&
 			!rt1015->cali_done) {
-		rt1015_calibrate(rt1015);
-		rt1015->cali_done = 1;
+		ret = rt1015_calibrate(rt1015);
+		if (ret)
+			goto restore_boost;
+
+		ret = regmap_write(rt1015->regmap, RT1015_MONO_DYNA_CTRL,
+				   0x0010);
+		if (ret)
+			goto restore_boost;
 
-		regmap_write(rt1015->regmap, RT1015_MONO_DYNA_CTRL, 0x0010);
+		rt1015->cali_done = 1;
 	}
 
 	return 0;
+
+restore_boost:
+	rt1015->bypass_boost = bypass_boost;
+	return ret;
 }
 
 static const char * const rt1015_dac_output_vol_select[] = {
-- 
2.53.0



