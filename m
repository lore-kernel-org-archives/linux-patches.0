Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042282;
	b=A1derLrixdchzx90BKFZkERzxCknVyXrMy6jd7I/m6vYTx36v3FXmCMX1m9YuNlGlJoQ
	 p4dWKt+jlFjXDr9W1sgL4L41dKT1k3ptICYQyM5pWHCUMmyGnCD5L0mwj6VkGBoKGoyDM
	 No5hw/m0XGv9McMs303J79bJIYREyQ/168J7EWRFZsrgyAh783SFhF959FDYKK+iFKyG5
	 M7cbgNm8cyLBh8j6UheDyXUF6576J0YsUEuSMVe54aqiM3siaImnxgFLBAyXiAVmkMO/s
	 VCLj1s8+QzhfyQg6owZnOjZxDtE+jufz36xgfHkUfAM7wL96puiTxxQdypP1h7Zvbsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042282;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YeaAfqepqHg/9JD01CICsaYgE8StgdvNEHZTe4I5Ljo=;
	b=AtrAJL6115BkPF7Oz06rJouB0SxeEXa6TNg5R0WiMJhkXQ8bv5GaT4CsY4VuQwuENyAT
	 qwpN3vINd7uzn7ZGoTaDRutTXJ46G1lT1s+lO716DbwudxOUAqkW+gfQLcz8cYCmLWw/D
	 aQPMxvwr74a4cwtqTtaNzvoGcjg5CtXSBsvparZNiC2WjPpf/9Xoa0e412h984z/GdE7S
	 t4sgczN2IfjSR/49CPmsB7qheJFJpDhyEygiE5DTGki3rcc7mermBdgZ+aHqmxdlshw66
	 HbFPxVzCB5XOOk9NBTeceg7dcvtE4GVcr99BEWl9Cz+8U99XIe9DJ84LWtnSBA1fmIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fNIMkzrh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D5A606A320;
	Wed, 18 Nov 2026 22:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fNIMkzrh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA3C1F000C4;
	Wed, 18 Nov 2026 22:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042282;
	bh=YeaAfqepqHg/9JD01CICsaYgE8StgdvNEHZTe4I5Ljo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNIMkzrhmaqrBsvmrTPvaoYfs1cat04TmkfIgDXIzVi10pvJKfCgi6QLUaEeEeKV9
	 SjD9xP3cameZGHoMBuTLryqjJDSMQO+N2iOPDPwIpWdS6UdfB4t4jZruEUJWYx+Tiz
	 Bw5NvhCKgHCk/FOij/GcKT6w/7I+RV6IZ9B+AhGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3074/3318] net: bcmasp: unmap previous DMA mappings on TX map failure
Date: Wed, 18 Nov 2026 16:01:36 +0100
Message-ID: <20261118150452.313678222@linuxfoundation.org>
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

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit a3cf9877558ab2c51182af558815dde64fc17cb9 ]

When mapping an skb with fragments for transmission in bcmasp_xmit(),
if mapping fails on fragment i > 0, the error handler calls
bcmasp_clean_txcb() for previous iterations j < i. However,
bcmasp_clean_txcb() only zeroes the control block fields without
unmapping the DMA buffers, leaking the DMA mappings allocated for the
head and earlier fragments.

Call dma_unmap_single() before calling bcmasp_clean_txcb() in the error
cleanup loop.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Justin Chen <justin.chen@broadcom.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20261013204439.3494046-3-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index 407585420f4b7..2b6b66ee63978 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -317,6 +317,11 @@ static netdev_tx_t bcmasp_xmit(struct sk_buff *skb, struct net_device *dev)
 			intf->mib.tx_dma_failed++;
 			spb_index = intf->tx_spb_index;
 			for (j = 0; j < i; j++) {
+				txcb = &intf->tx_cbs[spb_index];
+				dma_unmap_single(kdev,
+						 dma_unmap_addr(txcb, dma_addr),
+						 dma_unmap_len(txcb, dma_len),
+						 DMA_TO_DEVICE);
 				bcmasp_clean_txcb(intf, spb_index);
 				spb_index = incr_ring(spb_index,
 						      DESC_RING_COUNT);
-- 
2.53.0



