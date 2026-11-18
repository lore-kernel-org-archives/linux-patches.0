Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061989;
	b=NmMRx56KgYXAlev45KfzcE/fLlqISlZJWundTgNYhoyAT7p5Ima4wHjxMiO4pzlEJk+H
	 /nKZzt22zUclPr6TCIDKnMPB0VBTEO6SFwEOHDipLRhNokisxiwfkfWEw5YKO+LnlAa37
	 uLhu8z4l52dYBPVqr73nUv7xskivHfVQXAt0yevP0DV3hNoZckXSDhrfpXWJpvsRUus7l
	 sG+Jk3k/O9KAMXVdIOMBGpeyIhTJ4zb6vFuLuoQn/iqXpAIO/Im22Uf9l6qZYf0ZhzcEs
	 rR9XqEB3eC86ZOPfGGALuZgZMaKylJNWtpH/9cY5AzrPNByNvURwOsg/jA8t8pxMJcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6xjGarqZGaMq8AueJeN4JXnMdqhT1nStKBhmX3yMFrE=;
	b=aSIyoTNX5Fx3eG1zNHC6ptouCwOB9icjsZk/X+4FDcxLGCK6eu0Vt0RAmIKM8mKmNadz
	 1xrtVER6SQCVsOSiALkW5PfgsiD/q0IwZOrAv7HwGhQeHVyJUKGsyFJXyfhwfte+JIROW
	 Lc72miG8L6726IRKPabrs499GKgvT53o04YBQL8HDSyKwWJQ9DTb4Bf5hT5alZvVSBc/M
	 0Z3mny8NXbWomcTMfFCPcurj4S3CumgK8QzeX7WT43hzjbH0+1pTi1smC9lu7eckINf6h
	 rIHDxxbgwaHAt2bwRYFCcZkdNJWjFFEsUm2gm3Tj1h8hbMsL6uS+HM8fYCjALBrnasw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mnJsTeeS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CEF7606A325;
	Thu, 19 Nov 2026 04:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mnJsTeeS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE36C1F000C4;
	Thu, 19 Nov 2026 04:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061989;
	bh=6xjGarqZGaMq8AueJeN4JXnMdqhT1nStKBhmX3yMFrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mnJsTeeSb2wqBf59qxWEbbwnsh3JN0WyiZoWaHVDIBUbpFOd/SwYgbMavjel++KS9
	 +nsn2xFuaBu3SOjlWaJLW2GiWE99BsZJjxiwPHH+41iT9E/t8smgzn95aWzu0oSKyQ
	 7e/e4DE240B1VH5GFJOIZcTy48NNMCKjr6QpsKnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1750/1848] ASoC: wm8994: fix MCLK index used for setting MCLK rate
Date: Wed, 18 Nov 2026 16:03:08 +0100
Message-ID: <20261118150032.741218883@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index efc883a07e94b..3e27166192cd5 100644
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



