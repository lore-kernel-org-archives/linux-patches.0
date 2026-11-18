Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023804;
	b=GL/DGofg6jq9FVvOjT59M+GPALpJHgCHd9MqqQYlF/Dvgvt9P2nJjpE+kift85rGjw8G
	 zlNAU+87G8KxjPAEHWtfqgCo/jZySqc26Akl3h6lgZRqzIgJ5ZuHVjgHqnmjCe29AAjB1
	 VYim+LVlGuD2jMVjfeJP9bEFfL+AVIOuOZA0QiUf70KWPhYajG0q/8z4ODB/8VzLG5f+s
	 4CsP6QrpQjqHMDbV/E7FzCS9JE/a/vBYNLWDoPQXVHImyAylg3dwiUz4UpxGj88G+YKuT
	 e7SgsiDSwTz3JKDIY4/p710XqvfQobkuRefL6taVTm5ksRVQ0hmrWxCZeWdsrRF1KPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nDCXmPEwp25KwEB843tB+fFFdLFMPOPVJS09+Rlsb8M=;
	b=ksWUVI6W6gtIQU8kH2M3yBAk2Cpu8/u8HVtxMI4vd4iLVcqBGYeaRWc/1d3zgWURh6nX
	 t2zpwmMfDbYrMmj4a6QHkoEbnxRdYssVizJu9dUyu4pkSVYBBXmkOiUuBW6MNrNjexPHz
	 KKSR/4IKU09bZgduIIWKYpRskSbzG6KpxN6qlL1uG9LByS7UA9VFiRb7uhh3DdF2qTn8m
	 HvWrFvTbJD5uHOQMLPEFqfdnwuHn60EXoxg4zeIjfyiibRt2cVuhgFmQ4+NlMSs4SagCO
	 YnoaHjS6UgKnPFQ4hV3QJcZTIxhl91K9e4xdaJSGrW0Ju+IH2I4G7zbAR2605lOv44w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l84oZTKh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4E0606A32A;
	Wed, 18 Nov 2026 17:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l84oZTKh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1434C1F000C4;
	Wed, 18 Nov 2026 17:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023804;
	bh=nDCXmPEwp25KwEB843tB+fFFdLFMPOPVJS09+Rlsb8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l84oZTKhKWaV84VlVysH5wOH07n9BMTcjA8A0znk60Lnv28Qv1BV3g1Fdjvmfpu/Y
	 DuXDoJQy1iYEOwv171tE58r9LavQ9l/toY20zwT/HycCzlYqavrqKW4ITTlSlGjNnL
	 FL0QT57RfmFYpHQ2rArBnleOxL855I62069N7BoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0473/2151] ASoC: rt1015: make control calibration failures observable
Date: Wed, 18 Nov 2026 15:36:48 +0100
Message-ID: <20261118150139.245892297@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1015.c | 81 +++++++++++++++++++++++++++++++--------
 1 file changed, 65 insertions(+), 16 deletions(-)

diff --git a/sound/soc/codecs/rt1015.c b/sound/soc/codecs/rt1015.c
index bd0b1d3c829dd..5b120cfa87642 100644
--- a/sound/soc/codecs/rt1015.c
+++ b/sound/soc/codecs/rt1015.c
@@ -491,35 +491,72 @@ static int rt1015_bypass_boost_get(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
-static void rt1015_calibrate(struct rt1015_priv *rt1015)
+static int rt1015_calibrate(struct rt1015_priv *rt1015)
 {
 	struct snd_soc_component *component = rt1015->component;
 	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
 	struct regmap *regmap = rt1015->regmap;
+	int ret, sync_ret;
 
 	snd_soc_dapm_mutex_lock(dapm);
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
 	snd_soc_dapm_mutex_unlock(dapm);
+
+	return ret;
 }
 
 static int rt1015_bypass_boost_put(struct snd_kcontrol *kcontrol,
@@ -529,6 +566,8 @@ static int rt1015_bypass_boost_put(struct snd_kcontrol *kcontrol,
 		snd_soc_kcontrol_component(kcontrol);
 	struct rt1015_priv *rt1015 =
 		snd_soc_component_get_drvdata(component);
+	int bypass_boost = rt1015->bypass_boost;
+	int ret;
 
 	if (rt1015->dac_is_used) {
 		dev_err(component->dev, "DAC is being used!\n");
@@ -538,13 +577,23 @@ static int rt1015_bypass_boost_put(struct snd_kcontrol *kcontrol,
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



