Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021124;
	b=0n3JzSt1ZjNvRsE0PHWZVlgYIE9ToNFB7upQmNv54k5WBrA56Ws+dPeeVTYMaQYd5ZxO
	 z140oL2oVKfFvTaMpMMNA4mBvH+Ek5V/xBEi5bkOCxU5MP4wpoJe7nG2GzsPChMrG9WXH
	 6mwvet67LfHhY+NK1ZbrT5pcYh9fqNKNRvGAipTPOk781niXeYVd3XaLcMWxjB56bIjWp
	 BeKRR4H4RTEghV4ooNRSN15pY5WTkz8g4R9DP+TnMvVOXNB0PbrHNQ3tgmg1raFi3W8Yn
	 lRjomcPcgq0D7O2sVLDZ9CW/ihDPTnAaBMF1Tui8nErnoKxf0QDzvVfU5DcwlwIPx/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PlDvhQmvbLyLl/IQ9mEsEiMQrOucbJsxghKnUb4qLjw=;
	b=sInbmLzvlplWmv64ZFZ+LmZ14rcSIUqDPJvRwkzsnK7/J+Qouyyx8c6O/amgyExT7PI5
	 9pu6GQLwproeRFmPz5zcX0t6gD3KVHp5OOLRRex7z8c7e7gfQVNy+xWeMZ5VKR4rEGemf
	 0wp+CapS/tRXhjjiRrE1ZVbb2C+olYGJN7Eq5JSVeWfoTOgb+6xzWSr3J/t922/3fpA33
	 993vQaxZh8lMP39drhnBJcUKYkkfi5scYl/4GZeu1gqsf3R5M87k2fcwNH/XBZN2gzIox
	 gFVu2mOcnRpzqGIxmrxr85Uzk53I1atDBuYy6ZXS042DLbPHAThKY+2fuVx/A8TM9Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L8RYoOuV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9C5606A31C;
	Wed, 18 Nov 2026 16:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L8RYoOuV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825871F000C4;
	Wed, 18 Nov 2026 16:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021124;
	bh=PlDvhQmvbLyLl/IQ9mEsEiMQrOucbJsxghKnUb4qLjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L8RYoOuVt/oBiZV1kr0BgstBhQ77mxpbnQrzc3H3apAxAhOUOugc4r2EEk2n1JBxa
	 bvJ4rW7VRR/iXGvyP2jfK21kor6k+BSLA4XJ/mKqRl/oWiXEKSYODGjk5uTCmnz5CA
	 QL8/mR5yG/Q7KOrpdbJSU99c8SlilRrzhH3G2xIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Zhang <zhangfeionline@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2196/2651] net: stmmac: xgmac: do not treat TBU as a TX event
Date: Wed, 18 Nov 2026 15:57:16 +0100
Message-ID: <20261118150404.783691520@linuxfoundation.org>
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

From: Pengfei Zhang <zhangfeionline@gmail.com>

[ Upstream commit 305deb54c6c287e586bed92da2375ae1220e8dde ]

Commit 8d07a7930434 ("net: stmmac: xgmac: Do not enable TBU interrupt")
removed TBUE from the default DMA interrupt mask, but did not remove the
TBU check from dwxgmac2_dma_interrupt().

TBU is set whenever a TX channel runs out of descriptors. Since TBUE is
not enabled and only enabled bits are cleared, the TBU status bit is
never cleared. As a result, TBU stays set on every idle TX channel,
regardless of whether there is any TX traffic.

With a shared interrupt, stmmac_dma_interrupt() checks all channels,
so every interrupt from any source schedules TX NAPI on every idle TX
channel.

Only use TI to trigger TX processing.

Fixes: 8d07a7930434 ("net: stmmac: xgmac: Do not enable TBU interrupt")
Signed-off-by: Pengfei Zhang <zhangfeionline@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20261013024747.2688984-1-zhangfeionline@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index ff83858ebc1f3..0a6e82a155c0e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -346,7 +346,7 @@ static int dwxgmac2_dma_interrupt(struct stmmac_priv *priv,
 		u64_stats_update_end(&stats->syncp);
 		ret |= handle_rx;
 	}
-	if (likely(intr_status & (XGMAC_TI | XGMAC_TBU))) {
+	if (likely(intr_status & XGMAC_TI)) {
 		u64_stats_update_begin(&stats->syncp);
 		u64_stats_inc(&stats->tx_normal_irq_n[chan]);
 		u64_stats_update_end(&stats->syncp);
-- 
2.53.0



