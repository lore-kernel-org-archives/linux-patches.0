Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042355;
	b=vDsv3i3kW+OaMCRvmMyU5ht7ajdPM4tXtKRYlqc6OHThrreviaTXSONCWslH18yWI1/1
	 nVXrCMuZp9Z5SFA+6dEt6qk+0DJ23R4g7r69qpn+SOY6a/RbJQTA9N8ryELhPccMurxRR
	 fUlhEqXS+D183zaFwcrmto40CjYNz1H8QhfENExrUHAgF5DzOJPRbHhwzNxNJ4TqUirQ1
	 +S3RX+OIBe2083os9+H0X6WhP023oDOybt747XZIIqH0KT6wA4wsWz9KFn2n/b8e/e2r7
	 uHyxadKwI33BXGI8zpVN0GiGgnMOVNCiFoY5sgtoxW0weUy0PiwrEFw5B+lJPXxmj5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YWPRUzWXCBv3sxyRq7QM7P1RVg9TwP5H6vrjD+wn0Dw=;
	b=5RW5iHXug0A3Tkuj/GHpJz0o0FVOchEuXj29rOWGp5VJYEtdkDqO+suylgbn0zbSeC2j
	 jLIJz7eeeG+lnCECvk7Fewh/tQ89dXmcnzlTimGe2TV+/x4N9XW2UNzPsgD2DcD/UfNAn
	 nl9a8X88x27N3ssAshBC3iOgqPwXxYRzbFFULGGwlXcTAPNSMArwBog3VyWGo6BTRobSK
	 YYOS8tYc9LzD8huJLQxgLAYYFg9dOLM0KEepwBevHQvSF/X6OSu/U1nnGuJENKXmFScRL
	 udvRL+39Wc5XwFmx8xWwWVuzHQn4vFFp2Ha19DhrJVamUs9o3STX9vTbTWfVQaY0yIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vedCb90f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D17606A31C;
	Wed, 18 Nov 2026 22:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vedCb90f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B3B1F000C4;
	Wed, 18 Nov 2026 22:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042355;
	bh=YWPRUzWXCBv3sxyRq7QM7P1RVg9TwP5H6vrjD+wn0Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vedCb90fcewmZ8FSL18LjEMF7Rn8UlsOYhdRqyv0kynVT3SHQmJMURnDbdfSV+TsY
	 fv1VkYw5WWqVj9luTNhgNZuzmnXxrrc9yy3Dn4OPANdNke7DP7dbVgRl1VQsP6G8+g
	 rUzlYS8ikTeI1J1QzID8csbm2QYwOWSorMAM3MMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3114/3318] ASoC: wm8994: fix MCLK index used for setting MCLK rate
Date: Wed, 18 Nov 2026 16:02:16 +0100
Message-ID: <20261118150453.377054260@linuxfoundation.org>
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

[ Upstream commit 7916b55b100973b5fb5b974e8f7c8ae9f3ac1d2e ]

wm8994_set_dai_sysclk() passes the AIF index (dai->id - 1) to
wm8994_set_mclk_rate(), which uses it to index the MCLK clocks and
their cached rates. As a result, selecting MCLK2 as the AIF1 clock
source sets and reads back the rate of MCLK1 instead, and the rate
of MCLK1 is then stored as the MCLK2 rate.

On the Exynos4412 Trats2 board, where MCLK1 is a fixed 24MHz clock and
MCLK2 a 32768Hz clock used when the codec is idle, this gives:

 wm8994-codec wm8994-codec: AIF1 using MCLK2 at 24000000Hz

so the driver assumes a 12MHz SYSCLK while it actually runs at 32kHz.
This skips the 128fs AIF clock ratio setup for low SYSCLK rates and
makes the mic detection rate configuration use the wrong clock rate.

Pass the MCLK index matching the selected clock source instead.

Fixes: 419e2f508336 ("ASoC: wm8994: Add support for setting MCLK clock rate")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Link: https://patch.msgid.link/20261021101750.3297770-4-m.szyprowski@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8994.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 5a40294ad3fa2..4fc3525e546e6 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -2542,7 +2542,7 @@ static int wm8994_set_dai_sysclk(struct snd_soc_dai *dai,
 	case WM8994_SYSCLK_MCLK1:
 		wm8994->sysclk[dai->id - 1] = WM8994_SYSCLK_MCLK1;
 
-		ret = wm8994_set_mclk_rate(wm8994, dai->id - 1, &freq);
+		ret = wm8994_set_mclk_rate(wm8994, WM8994_MCLK1, &freq);
 		if (ret < 0)
 			return ret;
 
@@ -2555,7 +2555,7 @@ static int wm8994_set_dai_sysclk(struct snd_soc_dai *dai,
 		/* TODO: Set GPIO AF */
 		wm8994->sysclk[dai->id - 1] = WM8994_SYSCLK_MCLK2;
 
-		ret = wm8994_set_mclk_rate(wm8994, dai->id - 1, &freq);
+		ret = wm8994_set_mclk_rate(wm8994, WM8994_MCLK2, &freq);
 		if (ret < 0)
 			return ret;
 
-- 
2.53.0



