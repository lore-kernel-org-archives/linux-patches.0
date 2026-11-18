Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027448;
	b=ez8nu49frVWZfltRmAr1fe1LwgkWW2fiT4DfsLBgKD9MGuZLymlT25zQOI8gmFfOxN78
	 ePpOsUjKtrek56/+Zy+dChJVZGL72+4948iruQTgcadLrHBBvn6i2oclBFa/s8d9bduWO
	 EjajfIyXSYmvLtpuDNf1TTV+CP9hPJw90gIwNdStpziKPhxk6oFE4iEjlWs+Oe6onwxDr
	 cOdmh5eYWTaNRraOYsPlfBpsd9jgsSbZ6P4MJtG6D9antJ5XCj3ttNWv+Y2BDhxZnRGJ8
	 p5gB+JcYSa3iRyIsYkb/xzdCqDObkNKFaiD9qVZQ/G1mU//v6NCFtCTdLWTdjmxfiEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LMVgxKsS8y2FOHwZQZSy9rDBsQwTLU7M5x4Thrwg7h4=;
	b=Nf9JYY1OMj5Oc8rnGYAss78GojB17M2gr8QCGDPxqjgtgAUV8ke2wYr8w0h4HUuakJsR
	 Eebg43R+Z3vG0VLg27OCDxFkNp1dMYf/FBQmrJuOY+Oej659NdydZqjfIOEsHWSnhuIgY
	 kv5RPlrafqdWvpQLMCvPI0q9FqjkAA7Z+kYogOT/VS6PF0sgS0o8tvoSioewWb65SPXOp
	 ZlNRm6B5FpXZMheM9HnkGDKj1WlncyiDNHRaqdSTcsWva8BTKR82+J4ZqHaVOXLpi3EEh
	 wvB12J1m3lHH2Gg59tUTcY5PgrAw9v0/rCKQF/OWdqqIT8kfP46acqnWnUkC9Uf/ysA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iHfDz36N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C3D60A261E;
	Wed, 18 Nov 2026 18:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iHfDz36N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4901F000C4;
	Wed, 18 Nov 2026 18:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027448;
	bh=LMVgxKsS8y2FOHwZQZSy9rDBsQwTLU7M5x4Thrwg7h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iHfDz36N8qqFpTmRCR55NulWnNJKZ57HFHSJkYB+VxMrg5P/kLE2tRLg3Ngrj34Rl
	 /XklYBSBCNZYhtrQ9ZXl8HvJvxKkrluaCHDzY9hgHSS9reI51neV6JngCOB+wmQsjI
	 tK+2qftfGJ4K2O8jE3VCU5ljO22OqlU393jHXuaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Zhang <zhangfeionline@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1794/2151] net: stmmac: xgmac: do not treat TBU as a TX event
Date: Wed, 18 Nov 2026 15:58:49 +0100
Message-ID: <20261118150227.165158640@linuxfoundation.org>
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
index 964ce2d733169..513de90c89dc0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -357,7 +357,7 @@ static int dwxgmac2_dma_interrupt(struct stmmac_priv *priv,
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



