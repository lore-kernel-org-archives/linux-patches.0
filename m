Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041824;
	b=TXbKUqpKkGOETuC9lNpwp8pRDK4CvRdvA+QSbHRwnZT2niaPWDd5bLqPnLTqMECoOBkm
	 DdIxKp7HmD2Ob03FQhPAw8icNjeIl7MfpbDvIh5GPFtKgsSm6zt1wtaJOEX+8cn357VUa
	 tY0Pm5tk8IsKH16x6tQ1Wjww8DzeDXcG95A4l3QGrWUkpR/LR/pBloyLE33RNAHRasph6
	 Xb69GqdPeiYvHOMiKkoB1JPBHVpk/8Kg6sg39RqCYcHIG1eC/GKZ6wdlecD7LZnmUnhYN
	 Q3UK3DgzsknhPpN4TD/Z+gaQ5seqvYW3kGRtW7g0c40TFjFzOla9q8qyxDMHX6HeSVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jJXmEXGzfoWPivSvYXoCERYlqyZk9lZItjg6Cdr+rVs=;
	b=PjwhWp2eSRHUbhvmXWTwW/+67sjgNX0Q0UHZEoESfTOcC48mpMz+RAgp9FgAawAO+3P6
	 JvmbNiAnJft7tcSzYQBZZaWnIE1AdA/yh+NbXAA2edhKvC3Y6DAZ3cJAARdJoZleo7ZH6
	 ML21FAu6q3oaV9++LSvuzx9A8yTH77W3V1YNby4jxGrT7JVOqajw007NAiOoNK83PFJAo
	 XRi8jDkTseTlzrdPHDj2jkhCkZln8+FT5iINtdgB9seVho7gYvwMzD57L1SEFp8rYj97h
	 mRrByDE7MJ9PO0ZkqwpZQ99Nf7rv6hra+KaBbNrP8fqaGgsvcUBMF5seiXVjW96NUlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dynjr6Ue;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD34606A31C;
	Wed, 18 Nov 2026 22:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dynjr6Ue
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0851F000C4;
	Wed, 18 Nov 2026 22:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041824;
	bh=jJXmEXGzfoWPivSvYXoCERYlqyZk9lZItjg6Cdr+rVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dynjr6UezMenpWE4JInVMMRLMqfzkRDib5aM5umgsVuAjc9h/BP1lLdGjI9u/hmFs
	 EoapqsRykIJs1D+oGToABYBZnss49ltHQgixsnpIsNTfHIKt4//IQphZyoq/DvOKyv
	 g0DXLHGQgRteI3hXG6poxiXqexTEI/7yNB/qKPhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2952/3318] ASoC: mediatek: mt8195: Fix timing system clock error handling
Date: Wed, 18 Nov 2026 15:59:34 +0100
Message-ID: <20261118150448.877452100@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit f18c0a8e528eb8844ee362324220ab8df3664afe ]

Check the return value of mt8195_afe_enable_clk() when enabling the
timing system clocks.

If enabling a clock fails, disable the clocks that were already
enabled and propagate the error to the caller. In
mt8195_afe_enable_main_clock(), return the error instead of continuing
with AFE clock enable.

Fixes: 6746cc858259 ("ASoC: mediatek: mt8195: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-clk.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
index 9940e95b1dcd3..57c72f8407720 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
@@ -671,7 +671,7 @@ static int mt8195_afe_disable_afe_on(struct mtk_base_afe *afe)
 static int mt8195_afe_enable_timing_sys(struct mtk_base_afe *afe)
 {
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
-	int i;
+	int i, ret;
 	static const unsigned int clk_array[] = {
 		MT8195_CLK_AUD_A1SYS,
 		MT8195_CLK_AUD_A2SYS,
@@ -682,13 +682,22 @@ static int mt8195_afe_enable_timing_sys(struct mtk_base_afe *afe)
 		MT8195_TOP_CG_26M_TIMING,
 	};
 
-	for (i = 0; i < ARRAY_SIZE(clk_array); i++)
-		mt8195_afe_enable_clk(afe, afe_priv->clk[clk_array[i]]);
+	for (i = 0; i < ARRAY_SIZE(clk_array); i++) {
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[clk_array[i]]);
+		if (ret)
+			goto err_disable_clk;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(cg_array); i++)
 		mt8195_afe_enable_top_cg(afe, cg_array[i]);
 
 	return 0;
+
+err_disable_clk:
+	while (--i >= 0)
+		mt8195_afe_disable_clk(afe, afe_priv->clk[clk_array[i]]);
+
+	return ret;
 }
 
 static int mt8195_afe_disable_timing_sys(struct mtk_base_afe *afe)
-- 
2.53.0



