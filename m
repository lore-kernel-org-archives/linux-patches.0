Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042401;
	b=Bml4v1i8KfHlw671zELE2Zm4NKIbUd6c2paNSPQl6mnPa8m1o4zsGzzfo7BCOVh5q3tT
	 QvrH8VIl5qlL5DE/B/OniTk8uNNUU4xr5rkN2faots1b48qAkwUy4q0COs0NV/Ip305sl
	 BOURCKzC7XnUVqzGjvpmdFHxChEl91anBM+ajgEWEvn8WRoJgkf3WovQm1F/DkWlg2aWt
	 w0pxtgldjTieFSfvrE96aXp2Jcok5iC1qCyR1m7lrUgxUYBeJmxyJLYlnrRQrxj0oUcor
	 WeJbm/oUe9RsG0xdk+veYhe62jHgEJFn9+Zw2+0jgKwdZxaQb0mS2eQS/5P2OPXJ2fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2ikBslj24PbTxSELKeNcK05f8I0QKPuzvcGcpD0D6HM=;
	b=gAgCWsHzOYaqA72ZQtlNDjnPtAwB+BLaDadP/jjGXkZt+Dgrpi8YEV+jMYZ1Y1e0tLY2
	 KDdZIYBwQm9RSt85bsIdykbp/0hXof43BkYFjGP9MNHTS+LHTKP20UcVYe4VEa90KpRKA
	 21ZMhx7sBffN9hkTX7CsId9U3obci1vu3CtZqFZEBFFDMfO22GC5ozrS0e9tgvgstH7Na
	 m4gfkOreE1EQ9WEJ8k5VA9UgfN4THCk4Mw/c9cP2l/XVRJusUX+An3h8cRJdREFVD11r7
	 qi6f6Y/8VhOtDqVNL0ejQHDz0xMTJ3+2vEB5O236vVlCFX6tXn3OI88wFkhYs4fndlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZY6OoQGQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CA0606A325;
	Wed, 18 Nov 2026 22:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZY6OoQGQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6509F1F000C4;
	Wed, 18 Nov 2026 22:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042400;
	bh=2ikBslj24PbTxSELKeNcK05f8I0QKPuzvcGcpD0D6HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZY6OoQGQmJQpiazviyYXdc4CBYcSHNNIlr1QmKgiJvYfNlIj9pBls9jemJZjmqiRw
	 3J/QfXtTWclMba7SgeQSZVESY1HrbtBRIDgxxD2ZWNQ2Uj9OKDaR+v8+yDBU8/HYJr
	 sh3tUbQHgYvuLNlBL+DC2Rw5y/uULwaKRfQ/IKTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3116/3318] ASoC: samsung: midas_wm1811: run FLL1 at the AIF1 configured rate when idle
Date: Wed, 18 Nov 2026 16:02:18 +0100
Message-ID: <20261118150453.429360642@linuxfoundation.org>
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
index 9ac5452b537e8..32e8f3e91cdf3 100644
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



