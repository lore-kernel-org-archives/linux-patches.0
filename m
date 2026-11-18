Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027022;
	b=BF+9UHi8wa2JNAqOZOhw0nxGxbenH3IxUptA9GUHsaIEs7rI42g3qGaBX4ADxVCVTJXV
	 dL5VhEZTYdHUXOquPYzayfawFnq1lhlKNKHVOy4scDQdQuM7rrwWWeI/eMQJwAdj0GHb9
	 qXYHeuYTb1qffXL04qvetyIBJ2j+yYlWSaTkCsciMgEeeByNKWX4y16Porgto9WBU8BF8
	 fRMu+3vqxyfh/26GQhUSBCSTw9vAJlD+2TNsXDNZNjoOWbaAj8xY5emEBMzhjEwAWMKh5
	 i7R/qkcQv6U/wPaAnDpMMnQZtKSWldnvJpvChvBFIwjAIUMKQ8yWkeFiR7BWR/FVGKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rZgahQxDwai98YE4xmPCsVBOgS6hlDenVDjqxQzUxss=;
	b=Ml3xnATtfTpVRaOWtadihNGev8L5L8ehe0RJShfrG8RxU2HvdOiyzPprJRktqNDhsVc3
	 QLAhcHB36F3g/Vxa3o0MbGQgANYZsd7cWyXCqDnhqAz2KtxL9913TM9luoxKJF6o6QW9W
	 DH3Jfq0snUcfX6sOhEzJsk7xRq8pUzAXlY/P5UrtHaW+s0NcLXNNAq2CEihqZUBVSEtYg
	 bCHl6Ev1iDDtI6SwRsKas/wo9znxDyYmBnVjqOO/ZdKmvXj77DU++DREPH3mX6Q9WlnOB
	 fd3Bgo1fGKbIm9Mjf3HNNi8qr8cXcfcII0BG1BEYt9IR1pq5ckgoJAmMOIsSlJIvfbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=InigPjJc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18811606A320;
	Wed, 18 Nov 2026 18:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=InigPjJc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678171F000C5;
	Wed, 18 Nov 2026 18:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027022;
	bh=rZgahQxDwai98YE4xmPCsVBOgS6hlDenVDjqxQzUxss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=InigPjJcQ8YDltqR/CB1ymizIj4lO7FNg+VO8eW6bMZG0toY7nXhxIgZ/MLjKBtw8
	 IEooZmQEcC1mfheTKaZbHdQeIpzCbQqlNszFL/lPeau/9xvHpxXXI87pdq/APhZcX4
	 3FJCuJq1ptLwLjSsAnoLAB0D1Fn3/9euSSl58rvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1640/2151] ASoC: mediatek: mt8195: Fix ETDM MCLK error handling
Date: Wed, 18 Nov 2026 15:56:15 +0100
Message-ID: <20261118150221.603944594@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 91dce9c7eec25e95b5ca32e17e60e2c27333d411 ]

Propagate errors from mt8195_afe_enable_clk() when enabling the
ETDM MCLK instead of always returning success.

This allows callers to properly handle failures when enabling the
MCLK.

Fixes: 1de9a54acafb ("ASoC: mediatek: mt8195: support etdm in platform driver")
Reviewed-by: Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-13-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-dai-etdm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
index fd4f9f8f032de..db84f9e34114c 100644
--- a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
@@ -1554,9 +1554,7 @@ static int mtk_dai_etdm_enable_mclk(struct mtk_base_afe *afe, int dai_id)
 	if (clkdiv_id < 0)
 		return -EINVAL;
 
-	mt8195_afe_enable_clk(afe, afe_priv->clk[clkdiv_id]);
-
-	return 0;
+	return mt8195_afe_enable_clk(afe, afe_priv->clk[clkdiv_id]);
 }
 
 static int mtk_dai_etdm_disable_mclk(struct mtk_base_afe *afe, int dai_id)
-- 
2.53.0



