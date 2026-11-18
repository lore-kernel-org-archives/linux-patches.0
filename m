Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021592;
	b=aOEdbmrGfRsoVCbulrBOTz+ijUqVLDJ6pypBIh5d7UxxxGjrNh+BcKiFBvzZVjHGjt6u
	 7YquJtjG6NvZnAeLLpC/kylxrq8K3VlQiT8IvUEQz3RNkB0PG+HoQWJeUUtszhODuQ6CL
	 d/qCz+z+p7jucAfBGcD1jCAt/HxOUEzoFagWqJRba80LszLEfJLT9YJMP1qduHH4OCgCY
	 5c+jB8pbQauoyBrIm2gg+WBvyRMfo70ia5xw8AXSTnGKnG9tsNDtt3Lu9JkB3aL61uU8d
	 +VMHZkZggOBOagCd2e+qakfhsFqDyZIiq7+lcbHOPoNIm//7+2Fnp6B51LsacOgGGCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/GUxbC3IggVFOS8snztYJ8yyukFvNDqUTLyNSUP6SPk=;
	b=llw/XTBPGpN3zfv0RWGPb7eIQeWIsIf2GpALuQhcL7Y6ipcQLab3dYHoml9riPn3DWDr
	 8j6vqVVDzmQVsSkZnc07RukpxMdYZfExiCqd+A2+0IMUsQhQrcKqUBtGVYvrbRdBKGZ4G
	 xQ3ojnuJSdkEYvE7QxkifR9cuci0NK9TStN+1jcQb3JS8oGXZGCyjTFKWWRGaOuw6BGBq
	 DumQ3uI/me0lwg1n7cfAMqKS3C+vFZ8FHrVJ3vuFYagtV21PSHMBj2IFURVn+O63a3kiO
	 737KEzG37Ubv13dk43GKpBhFjpHwZwH22AbMKu9uAmL9IgiAn3b8kY0Zuf9nTZT5HAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJ8mF0Jr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B58F606A33B;
	Wed, 18 Nov 2026 17:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJ8mF0Jr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F4A1F000C8;
	Wed, 18 Nov 2026 17:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021592;
	bh=/GUxbC3IggVFOS8snztYJ8yyukFvNDqUTLyNSUP6SPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJ8mF0JrCLipV0a+GBCpp/VY11pBbpS10QzvVDLiT4vqauQcbrFQj2LngaZ0GtZ8s
	 scrIx/Q/GMtq0NJz/9DF31zz9rr430qMp9e8Rh7qpsES/IB/9J7ayNruiK5U2wpEHo
	 5c4+3ckd3OvFGl8bwbgWQ/0Yu57bWRFKEYj07taM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2321/2651] ASoC: wm8994: fix MCLK index used for setting MCLK rate
Date: Wed, 18 Nov 2026 15:59:21 +0100
Message-ID: <20261118150408.733016751@linuxfoundation.org>
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
index eb2ff1e27be72..dd6a9a3c73610 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -2539,7 +2539,7 @@ static int wm8994_set_dai_sysclk(struct snd_soc_dai *dai,
 	case WM8994_SYSCLK_MCLK1:
 		wm8994->sysclk[dai->id - 1] = WM8994_SYSCLK_MCLK1;
 
-		ret = wm8994_set_mclk_rate(wm8994, dai->id - 1, &freq);
+		ret = wm8994_set_mclk_rate(wm8994, WM8994_MCLK1, &freq);
 		if (ret < 0)
 			return ret;
 
@@ -2552,7 +2552,7 @@ static int wm8994_set_dai_sysclk(struct snd_soc_dai *dai,
 		/* TODO: Set GPIO AF */
 		wm8994->sysclk[dai->id - 1] = WM8994_SYSCLK_MCLK2;
 
-		ret = wm8994_set_mclk_rate(wm8994, dai->id - 1, &freq);
+		ret = wm8994_set_mclk_rate(wm8994, WM8994_MCLK2, &freq);
 		if (ret < 0)
 			return ret;
 
-- 
2.53.0



