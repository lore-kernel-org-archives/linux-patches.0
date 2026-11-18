Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021594;
	b=X2KEMCdQXxAcHnqzkqIIydUChAOyAGCQefI0SkJaieDL/65SIDcIsyiKzYFrIZY/q30x
	 S6mIpuOGVqPb+It9phkUmMEXhsvHji0aD8zUtLjtvm8BB7LscornlyLgi6+CKprMl5XGw
	 HFgHJIkHN++EYbqpgjs4rhCvhOumfZtBwnpTe+eBCjuEY/SQSGIW56UAHdKc32RQfg0mE
	 wlYFhNPJzIQj0pXjXfDN8IBLWfvTW9HzqJ9UnlwLgb0FCdZhFsEiOJ2Da4hN6ahQFetU0
	 8JRzqNh/xERxwv9Zl60aVvgOlHWznwbQIS5o5wq6nnT177nmOYFBw88GwvS8M19o5sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2Wf+SaKoa0A4uScVlqotQCCyLgM4T2ejZ92KIj7cgPw=;
	b=YTLKvvmxgRb5x/8OqbES+vtJHkzqevGl7m7p+/6mrHlZBWGWMxv+VqNUZYVlKmYRu2RP
	 mPi45R7ng8dxO6dIj5aFQU4/on1uksYUmLqYzc/PBYAN0Uvc0VO7r/gxswt1I4Dea1s21
	 sxq6g8xxwNN2SLKS1+LPBHPVuCdj5q4xJJU96/CLY0KP6gUlspzF0K9LM1XF56NWnMW09
	 9LeIFJcmp/B0cK9/LdFHVWDVC6EbWXIMh3Y7sQLlhziBNgKAShw/TpxSDhrMZewZGNDzy
	 dZauWvGBYtnl9VYjl1psk0v4ZJHLPBtKyDoMBRgye0gRexU1E0udpu4tx4vzObTtbMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ImiNspca;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAFF60A263E;
	Wed, 18 Nov 2026 17:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ImiNspca
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310571F000C8;
	Wed, 18 Nov 2026 17:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021594;
	bh=2Wf+SaKoa0A4uScVlqotQCCyLgM4T2ejZ92KIj7cgPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ImiNspcaIHOlcoQBRzpAuuuvPXxZOnxXhQ4aEjgxYpOyz64MiCW9TUp2eUBaurNig
	 3vpU1Fb6xG8kk7CpwdYXZQMIzPFHBdND48/HDcLz7gzdleSxa36jPgfjk7QCX+4fxw
	 Ev0Q8IySyGB7x6x2LsBN4hUDfDbVholfkqOaP820=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2322/2651] ASoC: samsung: midas_wm1811: run FLL1 at the AIF1 configured rate when idle
Date: Wed, 18 Nov 2026 15:59:22 +0100
Message-ID: <20261118150408.763196426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit d9c23ac1217ab094e6bd9ab95e159ec72c8baca5 ]

When the codec is brought up without an active stream, for example
because the mixer state restored by alsactl powers up a digital path,
midas_start_fll1() sets FLL1 to the default 11.2896MHz rate. The
codec's AIF1 however keeps the configuration of the last stream, or its
reset default of 48kHz at 256fs before the first stream, which needs
a 12.288MHz AIF1 clock. The digital paths then run with AIF1 clocked
at a rate not matching its configuration.

Remember the FLL1 rate requested by the last hw_params() call, which
matches the AIF1 configuration kept in the codec, and use it when no
specific rate is requested. Change the default rate used before the
first stream to 12.288MHz, matching the codec's default AIF1
configuration.

Fixes: fd0ea9cd9698 ("ASoC: samsung: Add sound support for Midas boards")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://patch.msgid.link/20261021101750.3297770-5-m.szyprowski@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/samsung/midas_wm1811.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/sound/soc/samsung/midas_wm1811.c b/sound/soc/samsung/midas_wm1811.c
index d43af5069baf9..11466dd3539e8 100644
--- a/sound/soc/samsung/midas_wm1811.c
+++ b/sound/soc/samsung/midas_wm1811.c
@@ -25,7 +25,8 @@
  */
 #define MCLK1_RATE 24000000U
 #define MCLK2_RATE 32768U
-#define DEFAULT_FLL1_RATE 11289600U
+/* Matches the codec's default AIF1 configuration: 48kHz, 256fs */
+#define DEFAULT_FLL1_RATE 12288000U
 
 struct midas_priv {
 	struct gpio_desc *gpio_fm_sel;
@@ -34,6 +35,7 @@ struct midas_priv {
 	struct gpio_desc *gpio_headset_key;
 	struct iio_channel *adc_headset_detect;
 	unsigned int fll1_rate;
+	unsigned int aif1clk_rate;
 
 	struct snd_soc_jack headset_jack;
 };
@@ -171,11 +173,12 @@ static int midas_start_fll1(struct snd_soc_pcm_runtime *rtd, unsigned int rate)
 	if (!rate)
 		rate = priv->fll1_rate;
 	/*
-	 * If no new rate is requested, set FLL1 to a sane default for jack
-	 * detection.
+	 * If no new rate is requested, set FLL1 to the rate the codec's AIF1
+	 * is currently configured for, as its digital paths can be powered
+	 * up without an active stream.
 	 */
 	if (!rate)
-		rate = DEFAULT_FLL1_RATE;
+		rate = priv->aif1clk_rate ?: DEFAULT_FLL1_RATE;
 
 	if (rate != priv->fll1_rate && priv->fll1_rate) {
 		/* while reconfiguring, switch to MCLK2 for SYSCLK */
@@ -241,6 +244,7 @@ static int midas_aif1_hw_params(struct snd_pcm_substream *substream,
 				struct snd_pcm_hw_params *params)
 {
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
+	struct midas_priv *priv = snd_soc_card_get_drvdata(rtd->card);
 	unsigned int pll_out;
 
 	/* AIF1CLK should be at least 3MHz for "optimal performance" */
@@ -249,6 +253,8 @@ static int midas_aif1_hw_params(struct snd_pcm_substream *substream,
 	else
 		pll_out = params_rate(params) * 256;
 
+	priv->aif1clk_rate = pll_out;
+
 	return midas_start_fll1(rtd, pll_out);
 }
 
-- 
2.53.0



