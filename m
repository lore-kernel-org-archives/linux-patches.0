Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050230;
	b=NP9wX8JNXBc1inJCWtx8GyL4DR1/GePK9I0mbMaUx5tqzxdfK9Erl2fDW4r8wQ8+uvk2
	 8Lg0olGp/r5Ua/VXcgbxea9CmbGmigU6TidRfFGarEHkxM1VLwLLyL2ibX4AKvUbzsGvN
	 ren58q0rlDOh0fERn48MjwOyY5K1ZgBWiYI+OYxSC5May4MTmzgtb87PnzU0FgBDGbtWM
	 7YaxxZXzVkdgkIDQLFMeydLA3C/wAs/XkWh5MFLWDT6ohW9UPIC7qlV03UCXtGi+S8zoe
	 TyjS999HY8N49J4p/NfQ5qwcquKvcM0hmPZWoAai6YhRSPzOoEWStkM9ROscrvU7cLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xhJUV7IeprYw8NI74WYToN9g89dUcFUjkMoeE1QC1QA=;
	b=S7N2xHJk+d+scgT+IX6KDk+v3s8DfXbbN3Ae2VWy60W6S9BYhTr22RmDx/+w80XUPhmp
	 8GqTjSN4VeZi6pVLRH9oeVRi1vNwnBy27Ey/yJeMlUd2K8wjrlfnmbMhsHwJxQmUnOsrc
	 Jt0Ry5Qo8SQBwgpbzQ6aPh8e4iK7ZwU7cKSdTXC0BBtdpPobXmGBaAONOM5qIDwIk/Lqf
	 8qQ1eCSgRTAC+jYYl1KPoMXpdzKPhhIQgbBC9GTDwHEFhDU8fHlGkQQYqNdMBziHTnlRF
	 qLNqskBkp32SM1OGuZ3ZXZXaIjgBROhLIvXiviX9AgQZdESn7KIfisTK2rHW8wBfZ0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P01L2rWS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FB9606A32A;
	Thu, 19 Nov 2026 01:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P01L2rWS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2A71F000C4;
	Thu, 19 Nov 2026 01:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050230;
	bh=xhJUV7IeprYw8NI74WYToN9g89dUcFUjkMoeE1QC1QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P01L2rWSJteADYZoTj9iGg5vsJMUTfTEoKirAaxaadcyKxvYyOJfwVGBmkORboFkS
	 BHYIncyDYDbwkeFCd8t6v7RToV//jiFU65EFFabc/BLUw7H4k+B2iDdtRCxzjSC8QO
	 jVeDH4UlzvqUoqMLkyYZINQIKgUZnCT4RtlDZsO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	EricChan <chenchuangyu@xiaomi.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2635/2857] net: stmmac: Fix interrupt handling for level-triggered mode in DWC_XGMAC2
Date: Wed, 18 Nov 2026 16:01:09 +0100
Message-ID: <20261118150336.465441222@linuxfoundation.org>
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

From: EricChan <chenchuangyu@xiaomi.com>

[ Upstream commit 78b7920a03351a8402de2f81914c1d2e2bdf24b7 ]

According to the Synopsys Controller IP XGMAC-10G Ethernet MAC Databook
v3.30a (section 2.7.2), when the INTM bit in the DMA_Mode register is set
to 2, the sbd_perch_tx_intr_o[] and sbd_perch_rx_intr_o[] signals operate
in level-triggered mode. However, in this configuration, the DMA does not
assert the XGMAC_NIS status bit for Rx or Tx interrupt events.

This creates a functional regression where the condition
if (likely(intr_status & XGMAC_NIS)) in dwxgmac2_dma_interrupt() will
never evaluate to true, preventing proper interrupt handling for
level-triggered mode. The hardware specification explicitly states that
"The DMA does not assert the NIS status bit for the Rx or Tx interrupt
events" (Synopsys DWC_XGMAC2 Databook v3.30a, sec. 2.7.2).

The fix ensures correct handling of both edge and level-triggered
interrupts while maintaining backward compatibility with existing
configurations. It has been tested on the hardware device (not publicly
available), and it can properly trigger the RX and TX interrupt handling
in both the INTM=0 and INTM=2 configurations.

Fixes: d6ddfacd95c7 ("net: stmmac: Add DMA related callbacks for XGMAC2")
Tested-by: EricChan <chenchuangyu@xiaomi.com>
Signed-off-by: EricChan <chenchuangyu@xiaomi.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250703020449.105730-1-chenchuangyu@xiaomi.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 305deb54c6c2 ("net: stmmac: xgmac: do not treat TBU as a TX event")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/stmicro/stmmac/dwxgmac2_dma.c    | 24 +++++++++----------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 8d11c6472d8da..38cdf24372a01 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -360,19 +360,17 @@ static int dwxgmac2_dma_interrupt(struct stmmac_priv *priv,
 	}
 
 	/* TX/RX NORMAL interrupts */
-	if (likely(intr_status & XGMAC_NIS)) {
-		if (likely(intr_status & XGMAC_RI)) {
-			u64_stats_update_begin(&stats->syncp);
-			u64_stats_inc(&stats->rx_normal_irq_n[chan]);
-			u64_stats_update_end(&stats->syncp);
-			ret |= handle_rx;
-		}
-		if (likely(intr_status & (XGMAC_TI | XGMAC_TBU))) {
-			u64_stats_update_begin(&stats->syncp);
-			u64_stats_inc(&stats->tx_normal_irq_n[chan]);
-			u64_stats_update_end(&stats->syncp);
-			ret |= handle_tx;
-		}
+	if (likely(intr_status & XGMAC_RI)) {
+		u64_stats_update_begin(&stats->syncp);
+		u64_stats_inc(&stats->rx_normal_irq_n[chan]);
+		u64_stats_update_end(&stats->syncp);
+		ret |= handle_rx;
+	}
+	if (likely(intr_status & (XGMAC_TI | XGMAC_TBU))) {
+		u64_stats_update_begin(&stats->syncp);
+		u64_stats_inc(&stats->tx_normal_irq_n[chan]);
+		u64_stats_update_end(&stats->syncp);
+		ret |= handle_tx;
 	}
 
 	/* Clear interrupts */
-- 
2.53.0



