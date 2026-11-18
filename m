Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027753;
	b=bHGz9Sbjkn3f2DzVIi6VUF9V+EQ2miAEXiOmi+uiJAaQ4c3zRQu0UBR2+l84Ay4Lv2HX
	 Sa80TnX5qodSxvd+J9v+1NwmMontedsyvdRpfpQe8O6rXIHh5hh8cpY0Ka4VB1lEQA8Mq
	 06ZeNa51KcjjECKMYdY5OiFz7I4QtXuBsCWlq9nJmDPKGyvjQl/ui/Lu4mb864ngzGB5m
	 hubET7Th4YjOE6NqdSFsyOIxVmz5/yhk14xWgu8nOvHpYQrfPFjCCXihGnpAWmIMTBIwm
	 xFf5KXSNglwOlsGIz2mKswE1T+OR23yiPcq/QtP88VNahXtTreILEKxqOJPM2AxXcdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027753;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D+OC2Jo6XydlCBloHC6QBUYDJ4lmVnbTPCbjCf9yuQc=;
	b=I6x/oPGfbeLb2SNKaFe8nU2rQywJlBh8ppxlF15ggLdn3EdZqKU1LpY5d0s5DJStbbU8
	 y6aOAS51WMMkanxThveGUxBUm1nZmEl9ccIGAL4LIiuqxaHlB08ETua2D0EGlmLqSEnQ6
	 +bkpU8ONcFzi9n0JP3qEuBlmCkL6YcGZlNXF2cPE5HCrURrAQL9rI6mpEkPrzyU4UmPog
	 8gXN9g6kNLuWa8+F9fYNaJSJJJXS/ObmNZxVIN48ZAdeuFUejoaYUkzfQzoO9ZfZrzeDZ
	 HUtnCXH0l97kDT+Cw3h24rWze0dAdbXLydWWr6odkc/bc6h4sApBDMsIEyz58pDd8mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qKhPuF8b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B961606A33D;
	Wed, 18 Nov 2026 18:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qKhPuF8b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820A41F000C6;
	Wed, 18 Nov 2026 18:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027753;
	bh=D+OC2Jo6XydlCBloHC6QBUYDJ4lmVnbTPCbjCf9yuQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qKhPuF8bkdYp0DsQOcXDrh+MJjWq1ygWLAt+zsEZKg7P1Zx0VP7LXrRwPX7/wvEvX
	 d/nK4Kob8kjxC9UBQ+vmnegNGORprgS0YYml9P5KdXzOfhAYOu4oa441LDs719j9zf
	 IXllsYBK+0YB+NTRgBCRNr+qqs54pDpLozqCqAig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1900/2151] ASoC: wm8994: follow AIF clock source changes in MCLK gating
Date: Wed, 18 Nov 2026 16:00:35 +0100
Message-ID: <20261118150231.006051249@linuxfoundation.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 8731e33a3b98ea1ccade059b3a1ce06b7dd66b17 ]

The AIF clock source can be changed by configure_aif_clock() while the
AIF clock is running, for example the Midas machine driver switches
AIF1 between MCLK2 and FLL1 while AIF1CLK is kept enabled for jack
detection. aif_mclk_set() only enables the MCLK selected at the time
the AIF clock is turned on, so an MCLK selected later this way is never
enabled, and the codec may run from a stopped clock.

Track whether the AIF clock is running and, if so, enable the newly
selected MCLK in configure_aif_clock() before switching to it, then
release the previously enabled one.

Fixes: 001b83d395ab ("ASoC: wm8994: Add support for MCLKn clock gating")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://patch.msgid.link/20261022101531.775891-1-m.szyprowski@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8994.c | 27 +++++++++++++++++++++++++++
 sound/soc/codecs/wm8994.h |  1 +
 2 files changed, 28 insertions(+)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index c9d683596d9c5..68f7d7a962e9f 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -162,9 +162,12 @@ static void wm8958_micd_set_rate(struct snd_soc_component *component)
 static int configure_aif_clock(struct snd_soc_component *component, int aif)
 {
 	struct wm8994_priv *wm8994 = snd_soc_component_get_drvdata(component);
+	struct clk *mclk = NULL;
+	bool switch_mclk;
 	int rate;
 	int reg1 = 0;
 	int offset;
+	int ret;
 
 	if (aif)
 		offset = 4;
@@ -173,11 +176,13 @@ static int configure_aif_clock(struct snd_soc_component *component, int aif)
 
 	switch (wm8994->sysclk[aif]) {
 	case WM8994_SYSCLK_MCLK1:
+		mclk = wm8994->mclk[WM8994_MCLK1].clk;
 		rate = wm8994->mclk_rate[0];
 		break;
 
 	case WM8994_SYSCLK_MCLK2:
 		reg1 |= 0x8;
+		mclk = wm8994->mclk[WM8994_MCLK2].clk;
 		rate = wm8994->mclk_rate[1];
 		break;
 
@@ -195,6 +200,20 @@ static int configure_aif_clock(struct snd_soc_component *component, int aif)
 		return -EINVAL;
 	}
 
+	/*
+	 * If the AIF clock is running, enable the new MCLK before switching
+	 * to it and release the previous one afterwards.
+	 */
+	switch_mclk = wm8994->aif_clk_on[aif] && mclk != wm8994->aif_mclk[aif];
+	if (switch_mclk) {
+		ret = clk_prepare_enable(mclk);
+		if (ret < 0) {
+			dev_err(component->dev,
+				"Failed to enable MCLK for AIF%d\n", aif + 1);
+			return ret;
+		}
+	}
+
 	if (rate >= 13500000) {
 		rate /= 2;
 		reg1 |= WM8994_AIF1CLK_DIV;
@@ -209,6 +228,11 @@ static int configure_aif_clock(struct snd_soc_component *component, int aif)
 			    WM8994_AIF1CLK_SRC_MASK | WM8994_AIF1CLK_DIV,
 			    reg1);
 
+	if (switch_mclk) {
+		clk_disable_unprepare(wm8994->aif_mclk[aif]);
+		wm8994->aif_mclk[aif] = mclk;
+	}
+
 	return 0;
 }
 
@@ -1070,6 +1094,7 @@ static int aif_mclk_set(struct snd_soc_component *component, int aif, bool enabl
 	if (!enable) {
 		clk_disable_unprepare(wm8994->aif_mclk[aif]);
 		wm8994->aif_mclk[aif] = NULL;
+		wm8994->aif_clk_on[aif] = false;
 		return 0;
 	}
 
@@ -1089,6 +1114,7 @@ static int aif_mclk_set(struct snd_soc_component *component, int aif, bool enabl
 		clk_idx = WM8994_MCLK2;
 		break;
 	default:
+		wm8994->aif_clk_on[aif] = true;
 		return 0;
 	}
 
@@ -1099,6 +1125,7 @@ static int aif_mclk_set(struct snd_soc_component *component, int aif, bool enabl
 		return ret;
 	}
 	wm8994->aif_mclk[aif] = wm8994->mclk[clk_idx].clk;
+	wm8994->aif_clk_on[aif] = true;
 
 	return 0;
 }
diff --git a/sound/soc/codecs/wm8994.h b/sound/soc/codecs/wm8994.h
index 5b22cfab317e1..e7df0a1a2314c 100644
--- a/sound/soc/codecs/wm8994.h
+++ b/sound/soc/codecs/wm8994.h
@@ -82,6 +82,7 @@ struct wm8994_priv {
 	struct wm8994 *wm8994;
 	struct clk_bulk_data mclk[WM8994_NUM_MCLK];
 	struct clk *aif_mclk[2];
+	bool aif_clk_on[2];
 	int sysclk[2];
 	int sysclk_rate[2];
 	int mclk_rate[2];
-- 
2.53.0



