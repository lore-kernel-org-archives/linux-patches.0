Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056716;
	b=MkrOi7BhXvcssC7wJl23a6KVOUNEqB800YQ8nSigQyy2Cn+58XadYs/6N9k+vNah8CcL
	 5naWGJodu1QCglokZ1V75IYj90rcmleQEznKN5Bh1XAoxUPLl5i+3GhN7NaUv53j+1Exg
	 H7i6yc6Sk85+S55seUV+rhE1smy++H1mvKFmtAm45oZ0y8U14svm6EWvmWUC62xc7Q3RU
	 RDLZhqrs3jIiWucj13sE2Tb4Vulm3y5ZVFb4Bqn8l84KF3/gUmdOFd/vCYlo4gMPJOiJH
	 TyG2W3tolDZ+F7FvUFVnOsUBrJQcA1xdxYOFfriwegbyON4liu7f3SruBkyy2b/4eLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GtYu0gSyVN2hIe9hyfB7CUi3HBULI1chkYeR4X17cyQ=;
	b=DsuyyuyhSfMoUHb5z8Mn7/FL4W+PcgD9KNzJSrQFHdhYHEP9gbufhR5jG8PsxtrFh1Wq
	 7lZ/SeTMn3XC8Cc3g5fGAukdbQQyGB2F8BKz+WnnOnfcWkYAw/1YcUvaJe2E8j1ESqf0L
	 Z0UD7dAk8dT5J1DTmZTQEWrmM5dw8lQb4m3rKByy5+pjnvp1Yryvowz3WIvrbIoqjtDze
	 WbTahLjFiP9lO2Fd8cy+R9ZMIdQN+syUYRkZu3qZp8XlId/5zrY1hpqRyMxRTu1V5U/31
	 B/r1KuLQtVK7Ps4TkTwIrizzEN/b1k9GAfpP3BitImEqeBjQj9LexbxUtx6DERGNvNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IGIbdp8F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7726606A320;
	Thu, 19 Nov 2026 02:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IGIbdp8F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327031F000C5;
	Thu, 19 Nov 2026 02:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056716;
	bh=GtYu0gSyVN2hIe9hyfB7CUi3HBULI1chkYeR4X17cyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IGIbdp8FIVSqEKXETIVC7LRx4Nl1C4sOcBFIZWfkdLpd4QBtsk0IbGeLADXcqmU0O
	 p9qDp8/RPUvb75pLAw2df139s3eKxzApaAKJYcB85cQUqD6G8yJlTULbJgU9BRabxR
	 LDNuVvzhKgPlzcjP26lnKbwNDxZM78rRHysi1Nmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2088/2214] ASoC: wm8994: fix MCLK index used for setting MCLK rate
Date: Wed, 18 Nov 2026 16:02:44 +0100
Message-ID: <20261118150134.154899590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 01809e8b0dbd9..ef62c26628e7c 100644
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



