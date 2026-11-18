Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050233;
	b=AfY0MioU9drEE/ygd9fAEJ9DmvB8jyfcn19v9nfCx3xUk/6sg5JRZcw8TxjmfNXq04+f
	 3osVR6ycdd6dlEiKo122SyyBw4fLx4xAA0ZpvBXRSC1ozOOBm1CKRbDQXnbwYJeRoCpD5
	 nqdCjV9bJ1AYVKiMYzpjqT9sH37AIoVqMjmMYbUwyBWNbiivzMgVF4o3gOQBBAe7ADHAU
	 UVa2pbv4ZCDZL/oYiyRIVaBAagoW5ZHM/7Q388lN+iv4RSpfmtgdqKHDwY7QKKNexumJZ
	 b+ecC3T42d/vQWg0szHpmC5caA8O5Ju8yKs/ZNCfJ7YIYqP7EliddyjPLzJsRVzQ1gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2LspjyufAFicDsd1cp89B06B8OdsvelvYf5LFsmYFlA=;
	b=t2oGvlnynXRh1N6SWu5pe2M3Lxrc5U5Y322vDMcfkZ6ehU9ND+EYnK/4/ziSF77tL3ir
	 1jcCdTCdik+I3AwcWS+ri4wCz1PwoloknKsI/qysd721gdtyS9Ke3woJTRLelLdQiV0Lp
	 41wNMmQyQAsHhatk4ClkTyAGNRi8eDuS4VEVqkD9oFn37HHg39X2BqM4MrrS/Mh0bDpYG
	 9CAtjXtChZI8NIwxaZja/3CLvLIkuXKlr6hmE223WXikSDJGIfLhkAxUcVCVB/sPTQpW2
	 HzJRi7Zhx16p8YreRaXD5bq1g6HYMsJSP0iX7rnmE6sCOqDxMmEx7vF+u1AQG06fdOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c0XhCEVc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABA9606A330;
	Thu, 19 Nov 2026 01:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c0XhCEVc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F291F000C4;
	Thu, 19 Nov 2026 01:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050232;
	bh=2LspjyufAFicDsd1cp89B06B8OdsvelvYf5LFsmYFlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c0XhCEVcZz70FjhXWi7SeewncVPSKp8mBEZyQ+dAr3+HNIg6RYM/5u170TfNFR0eL
	 L4TTxsSO/DFCgEHbQ2Y/nDft1MVlKag5Gx0CnR+RzUqywKk0IhK5xuSJZ9hQzko3Cp
	 VOWeTRkGhS9NhW/ogwgupw+DlhmSrFhVz3tmeV8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Zhang <zhangfeionline@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2636/2857] net: stmmac: xgmac: do not treat TBU as a TX event
Date: Wed, 18 Nov 2026 16:01:10 +0100
Message-ID: <20261118150336.505022519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 38cdf24372a01..7729a2ddfc1b5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -366,7 +366,7 @@ static int dwxgmac2_dma_interrupt(struct stmmac_priv *priv,
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



