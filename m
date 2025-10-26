Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9701527B4;
	Sun, 26 Oct 2025 14:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490221; cv=none; b=UrnF9Y982/d+lndCOf+jQArk26P+TjMSC/9Vb0ZbfwsUXAm9XeuSWrnknziVQq5ixLWGTk3iXpDK34Om5LIZ+17e93oq3AZo9CuPofFMQPpGURbifCm4t4saOp7MvjyZ2dKF7nN/KLntlvrWayZfadxSdgsUfgql3kuMHOwY29w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490221; c=relaxed/simple;
	bh=jMTtq6Xo1XlrvYqcb4wROaYCZBEw5JdAq4ePIhysOLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q0m5MjLpGx9kYEmJDEpaXC0lkvhFu4iBm8D6cbRey0oRSn/59rsu1GF84vffk7TNpkn65jHKt2EQP2wsQb4xSrs51e+m50BWR8cTGzECfJynOsYbGKwXc/tHCjB3n3JTbTj7rdxdygO6LREDtB286DbkjlV6BMEjjkyQkhu3iTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G37DIfby; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G37DIfby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94EFC4CEF1;
	Sun, 26 Oct 2025 14:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490220;
	bh=jMTtq6Xo1XlrvYqcb4wROaYCZBEw5JdAq4ePIhysOLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G37DIfbyVj9pg2udsJc3AEnkoKA10XRbnPRlHhoFqW9GgI+TZklVde0cQBOzAShGW
	 rgWCpL5G2HsfPSk1rraanJh1i/f8jY3wz23PY3ASwFYgGaFFOglvn/zCUd+UNqPecG
	 hCE/1Pm223Q90HIdelf5OpwUugadxP4MwhTeDVJBy+WRo/UFnFUELMuB/WQmDpOJFO
	 7cyRHMgSxH6C+f6cEdylPoz/j6xRv/N4ZPtgn6CVWsoKTUPvgJ9Ij45k3UKjgY4wxt
	 skmdSKJJilfllhWtrmeY1r3BiZyEId3x8fpMMLF+dgdnLaoAF3nXcaYXsGw0R301gm
	 x0ApNbId5USnQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Valerio Setti <vsetti@baylibre.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	khilman@baylibre.com,
	linux-sound@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-5.10] ASoC: meson: aiu-encoder-i2s: fix bit clock polarity
Date: Sun, 26 Oct 2025 10:48:49 -0400
Message-ID: <20251026144958.26750-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Valerio Setti <vsetti@baylibre.com>

[ Upstream commit 4c4ed5e073a923fb3323022e1131cb51ad8df7a0 ]

According to I2S specs audio data is sampled on the rising edge of the
clock and it can change on the falling one. When operating in normal mode
this SoC behaves the opposite so a clock polarity inversion is required
in this case.

This was tested on an OdroidC2 (Amlogic S905 SoC) board.

Signed-off-by: Valerio Setti <vsetti@baylibre.com>
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Tested-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://patch.msgid.link/20251007-fix-i2s-polarity-v1-1-86704d9cda10@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – this change fixes a long-standing functional bug with the Meson
AIU I²S encoder and is low risk to backport.
- The updated `aiu_encoder_i2s_set_fmt()` now inverts the bit clock
  whenever the DAI format requests the normal (non-inverted) polarity
  (`SND_SOC_DAIFMT_NB_*`), matching the hardware quirk described in the
  new comment (`sound/soc/meson/aiu-encoder-i2s.c:239-245`). Without
  this inversion, the CPU-side master drives BCLK so that data toggles
  on the rising edge, which makes all mainline DT users (e.g. Odroid C2)
  sample on the wrong edge and yields audible corruption.
- Frames (`LRCLK`) are still handled exactly as before, and the fix only
  flips which `inv` combinations set `AIU_CLK_CTRL_AOCLK_INVERT`, so
  `IB_*` formats continue to work as they already matched the SoC’s
  “inverted” default.
- The change is tightly scoped to one helper in the Meson AIU encoder
  driver, leaves register programming and clock sequencing untouched,
  and has been validated on real hardware per the commit log.
- Mainline device trees for this DAI all rely on the default `NB_NF`
  format, so the bug is user-visible today; there are no dependency or
  API concerns blocking stable backporting.

Suggested follow-up: 1) Run a quick playback sanity test on an Odroid C2
(or any Meson GX board using the AIU encoder) after backporting to
confirm audio becomes clean.

 sound/soc/meson/aiu-encoder-i2s.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/soc/meson/aiu-encoder-i2s.c b/sound/soc/meson/aiu-encoder-i2s.c
index a0dd914c8ed13..3b4061508c180 100644
--- a/sound/soc/meson/aiu-encoder-i2s.c
+++ b/sound/soc/meson/aiu-encoder-i2s.c
@@ -236,8 +236,12 @@ static int aiu_encoder_i2s_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 	    inv == SND_SOC_DAIFMT_IB_IF)
 		val |= AIU_CLK_CTRL_LRCLK_INVERT;
 
-	if (inv == SND_SOC_DAIFMT_IB_NF ||
-	    inv == SND_SOC_DAIFMT_IB_IF)
+	/*
+	 * The SoC changes data on the rising edge of the bitclock
+	 * so an inversion of the bitclock is required in normal mode
+	 */
+	if (inv == SND_SOC_DAIFMT_NB_NF ||
+	    inv == SND_SOC_DAIFMT_NB_IF)
 		val |= AIU_CLK_CTRL_AOCLK_INVERT;
 
 	/* Signal skew */
@@ -328,4 +332,3 @@ const struct snd_soc_dai_ops aiu_encoder_i2s_dai_ops = {
 	.startup	= aiu_encoder_i2s_startup,
 	.shutdown	= aiu_encoder_i2s_shutdown,
 };
-
-- 
2.51.0

