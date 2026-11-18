Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050353;
	b=oPjwFfauGh6+S3Drd/01tYxpTFYUD3c6QmVdI3TPVutPVbuJ9Bq7BE6yXMmiKZDu+0+w
	 CwC9xQkB/7n85MvJb6IouxrzdlPiuazT7sjzRtcP/qKzbUOKCQ/etoqt/7TazJm6+wums
	 Pco+zF68U2E2kAyVICMWWqFGV7KNOfCaIgM9fhkBj3baT+qhGETerhSdEW++4koX7of+F
	 ylqBFwPDUT8zKEibdWORqoH9ZNieWCkHDjvSPqkXpsI6FRSbVNttjLMSnvWWqIejGqERM
	 HNT1gpValLNobLikLRjvLK8MAcoN08uC41ljukzRCnaxQgSmvMF/71cTIKl7Lu/Zt0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7uPNNrRD/G+tmtoayCUOVeprmVBxPeMBGKQIVCuh3PE=;
	b=EsHbmoNVFmaw/np7lX08pqj19grvngd8bNTu9gLOJmnTHWigoNRKPp8yYQ8Hpm3pFhQr
	 HT+qORUEPppbtM95a6EQPRv2WurfMiuYFOZb30vnIBX8zcDpNTNq/PwMcxCNk4oNhJ7Im
	 23QH/nvng4Ur9gkef7K1bPl/UEAtSMBjEOQYB27+lQdIjRPqi4JYQasRCSYEZ/G4oxRfF
	 o9EIuFs1LVfOdEZxKinfctG/KPVAKDPsIxwhLYmx+Ketr2ZiV6/+BmvSREX+d+plIYbst
	 V2AZd4yjE4lUP2/Jk7S5yCJmwoFeAwWYjuvkYFJjtODceFfEhA4WcVq1Y1vFVMiIOaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P3l00fOd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D94F606A32F;
	Thu, 19 Nov 2026 01:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P3l00fOd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFBD1F000C5;
	Thu, 19 Nov 2026 01:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050353;
	bh=7uPNNrRD/G+tmtoayCUOVeprmVBxPeMBGKQIVCuh3PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P3l00fOdoch9g1SkaWPOHV53q8LewoXm8n7mvxsGMFyGw75LaWHqXRui40ftVASyj
	 shQhGi1MRSnBaqmIFMGtuP48sb0CyfDOgYf+l9DdH6KDT7p38MldFA0CK1GB8qkv03
	 bEj+BwnHmnH6V38wUpSVTjppbEDZ5QHxz3Kcvexg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2679/2857] ASoC: samsung: midas_wm1811: run FLL1 at the AIF1 configured rate when idle
Date: Wed, 18 Nov 2026 16:01:53 +0100
Message-ID: <20261118150338.035106756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fe1478bf63908..5b76ec618a91d 100644
--- a/sound/soc/samsung/midas_wm1811.c
+++ b/sound/soc/samsung/midas_wm1811.c
@@ -26,7 +26,8 @@
  */
 #define MCLK1_RATE 24000000U
 #define MCLK2_RATE 32768U
-#define DEFAULT_FLL1_RATE 11289600U
+/* Matches the codec's default AIF1 configuration: 48kHz, 256fs */
+#define DEFAULT_FLL1_RATE 12288000U
 
 struct midas_priv {
 	struct regulator *reg_mic_bias;
@@ -34,6 +35,7 @@ struct midas_priv {
 	struct gpio_desc *gpio_fm_sel;
 	struct gpio_desc *gpio_lineout_sel;
 	unsigned int fll1_rate;
+	unsigned int aif1clk_rate;
 
 	struct snd_soc_jack headset_jack;
 };
@@ -60,11 +62,12 @@ static int midas_start_fll1(struct snd_soc_pcm_runtime *rtd, unsigned int rate)
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
@@ -130,6 +133,7 @@ static int midas_aif1_hw_params(struct snd_pcm_substream *substream,
 				struct snd_pcm_hw_params *params)
 {
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
+	struct midas_priv *priv = snd_soc_card_get_drvdata(rtd->card);
 	unsigned int pll_out;
 
 	/* AIF1CLK should be at least 3MHz for "optimal performance" */
@@ -138,6 +142,8 @@ static int midas_aif1_hw_params(struct snd_pcm_substream *substream,
 	else
 		pll_out = params_rate(params) * 256;
 
+	priv->aif1clk_rate = pll_out;
+
 	return midas_start_fll1(rtd, pll_out);
 }
 
-- 
2.53.0



