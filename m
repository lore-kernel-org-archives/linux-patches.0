Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027680;
	b=wMSmbgSFqIHw6F9mdNQcS47EcOVGjNOVXCZfw9pSpsctHdVYM3HsK43UHuHqnncNofrK
	 T6G/SuQNshDiYmdyvFxCRVaC9eV1AcoaAu5FJFd+vTYisFMQRwUwBEOlBDEoihVDsHvt3
	 517PC/A1aTy9+2fAA3Ut1rkSCL5swTPNo2W3sumO7W1yUo8plVuUPYn5o5DEIKm4vXtT4
	 VNZtHAd6NdwYAWwgZl41nmlbv0CuOMZ07tTzPF9M9fuKm+HHahBi0cj7NGjoioZbTD5Be
	 lmrJXq2r3j7BalRxSmau27MnHBHE5lAAVpTushxgyKfaFY9qevZ+uYlKHj9bRKU3waA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0nWinj1nDUD3GKI0Vh42gIttGU/bowyfVtKjW7LAiGk=;
	b=kP+wu2SyaaVJMbuTwBTb+68wNStVV1egIm3/CpAjjroFG94UQ3KPxxytbfVCX65jY6IN
	 fBA/Sp4syNol/bcgMT/m/vUiR8nN1rlorT+v8/46hpF5ntjbZKB4zFHNEJPx5v4n5udoF
	 Uyl4saetjgZuVkcYcEtjLiLQ3yVHfY+PwecqzNq0ogZ0Z9iNE4ZJ6pbthxZBucYsMvRFb
	 2vzMcmQu6noX6BxBGNfKDymm0lIdiEjlow2lMH+RzxrdbrcZA0Wj4RQrFYh8s5VX6nMYa
	 u+7ekh5ynL2m8KeRRcYfQpsq8GG2b7OthoP8ZVtRG0Ux2pTTDCnOAgQhgef4cGmrT5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XfvLVP9+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999E3606A32A;
	Wed, 18 Nov 2026 18:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XfvLVP9+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB501F000C7;
	Wed, 18 Nov 2026 18:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027680;
	bh=0nWinj1nDUD3GKI0Vh42gIttGU/bowyfVtKjW7LAiGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XfvLVP9+KCXLXIFTUSo5SxcG8hWyV351qchs9BY7g6dt30pm89Bl/WgtXimiyKxww
	 /gvNH9GV60qRoPNksnDyXHyAdC1tKw+SInG68jB23fiXcGD0QMTg85u/J9IbTowN2I
	 dS3s4Ic9RVUPgjj97+s3iDmd2LTP69vShJX488mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1876/2151] ASoC: wm8994: fix MCLK index used for setting MCLK rate
Date: Wed, 18 Nov 2026 16:00:11 +0100
Message-ID: <20261118150230.132788940@linuxfoundation.org>
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
index e851fc5521eb5..c9d683596d9c5 100644
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



