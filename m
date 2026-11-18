Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033144;
	b=e1hCROtcecUVz5ptvk/yDEg0MRlGzxqd09urCvCffZQnYvLSp0Jkg4MVnpPykz1gVrGt
	 OZpjpndME7ejnJPgC0jakc5nFsYhsCW7ZtfUxJpWEzZr0H2Th/Jd1DsgMVLoHugn1aYkl
	 Snr8revjzp5pPuqyTegH4Lu0ZZmvjy8bg6jADqNNa0fPvIZo/HxcguAcCY/exe0emKBIL
	 u78b6NEI3ycU6OiSkhqNvaDm2v3hXO2HPBtyT0Q3OeImN7YndUSt3tfEsdu43IBJuJXNG
	 yQuV8QvScBMBtRGRKsjKX2JbnPSNdN6nEgh+VN0gPpTBYFAdi6GF8jwVitWcZWMmzUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AtHAJpw3ZaeBNIViEI8tlF1KJcbhWkTnO6/I6D9XgoM=;
	b=Ux25pmabx28N7Oai4JT7ILlBYQSuy/lL8hnnJmn23iP4Ku9x6Qqi0VRMDdVJBr1RgDSd
	 dZS8gpwBKGloaEFyK9gN3/8lp+bGrX5gJygcSVhGXhU4ra4HVYf/5GrSokc43T8at3tN7
	 o50Z81f+wVLmR8sVyyVVJgn15/OHzGppqtPNRu1roGEsXDAJAY1sHBZijZx2eEs5PculE
	 ulFCJW4dFdB3o9EWl5GqGjkKPiIuF+byYiuD0BfzSf0tmIsqlEPdScBtcVq7ZOc/w6n2U
	 5t0nGHZzOwY6u3lpCXsD7+ioMkwWX+jeMSCQiERrFswH1aiOCt0xNXHBIN0iqaPYRuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iudRR+b3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70C3606A31C;
	Wed, 18 Nov 2026 20:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iudRR+b3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC481F000C4;
	Wed, 18 Nov 2026 20:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033143;
	bh=AtHAJpw3ZaeBNIViEI8tlF1KJcbhWkTnO6/I6D9XgoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iudRR+b3OzyWT7ziT3MxfVRrznWwejEIFhxmJ13LbNWriJ667V0gsJIsMgj78sbds
	 DfEfSJtRCoKF9AOsnQmPnktAtUOdDF9jo+9tq4wA2xiH/Bl8Mw7eFTDZlt07ujbUBa
	 PZ/+ct3GnMT7ZBZXU3Rvx88NREIfQbCh379gGONo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1646/1756] net: bcmgenet: remove dma_ctrl argument
Date: Wed, 18 Nov 2026 16:02:53 +0100
Message-ID: <20261118150115.277971301@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 8b031d4e9baaa33e1b0abd09b9a98a84576a21f0 ]

Since the individual queues manage their own DMA enables there
is no need to return dma_ctrl from bcmgenet_dma_disable() and
pass it back to bcmgenet_enable_dma().

Signed-off-by: Doug Berger <opendmb@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250306192643.2383632-9-opendmb@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1c1f51c3ee9c ("net: bcmgenet: recover from a failed resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 21 +++++++------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 0402e8f69c6fa..0b9c7deab10de 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3224,8 +3224,7 @@ static void bcmgenet_get_hw_addr(struct bcmgenet_priv *priv,
 	put_unaligned_be16(addr_tmp, &addr[4]);
 }
 
-/* Returns a reusable dma control register value */
-static u32 bcmgenet_dma_disable(struct bcmgenet_priv *priv, bool flush_rx)
+static void bcmgenet_dma_disable(struct bcmgenet_priv *priv, bool flush_rx)
 {
 	unsigned int i;
 	u32 reg;
@@ -3257,20 +3256,18 @@ static u32 bcmgenet_dma_disable(struct bcmgenet_priv *priv, bool flush_rx)
 		bcmgenet_rbuf_ctrl_set(priv, reg);
 		udelay(10);
 	}
-
-	return dma_ctrl;
 }
 
-static void bcmgenet_enable_dma(struct bcmgenet_priv *priv, u32 dma_ctrl)
+static void bcmgenet_enable_dma(struct bcmgenet_priv *priv)
 {
 	u32 reg;
 
 	reg = bcmgenet_rdma_readl(priv, DMA_CTRL);
-	reg |= dma_ctrl;
+	reg |= DMA_EN;
 	bcmgenet_rdma_writel(priv, reg, DMA_CTRL);
 
 	reg = bcmgenet_tdma_readl(priv, DMA_CTRL);
-	reg |= dma_ctrl;
+	reg |= DMA_EN;
 	bcmgenet_tdma_writel(priv, reg, DMA_CTRL);
 }
 
@@ -3297,7 +3294,6 @@ static void bcmgenet_netif_start(struct net_device *dev)
 static int bcmgenet_open(struct net_device *dev)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
-	unsigned long dma_ctrl;
 	int ret;
 
 	netif_dbg(priv, ifup, dev, "bcmgenet_open\n");
@@ -3327,7 +3323,7 @@ static int bcmgenet_open(struct net_device *dev)
 	bcmgenet_hfb_init(priv);
 
 	/* Disable RX/TX DMA and flush TX and RX queues */
-	dma_ctrl = bcmgenet_dma_disable(priv, true);
+	bcmgenet_dma_disable(priv, true);
 
 	/* Reinitialize TDMA and RDMA and SW housekeeping */
 	ret = bcmgenet_init_dma(priv);
@@ -3336,7 +3332,7 @@ static int bcmgenet_open(struct net_device *dev)
 		goto err_clk_disable;
 	}
 
-	bcmgenet_enable_dma(priv, dma_ctrl);
+	bcmgenet_enable_dma(priv);
 
 	ret = request_irq(priv->irq0, bcmgenet_isr0, IRQF_SHARED,
 			  dev->name, priv);
@@ -4183,7 +4179,6 @@ static int bcmgenet_resume(struct device *d)
 	struct net_device *dev = dev_get_drvdata(d);
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct bcmgenet_rxnfc_rule *rule;
-	unsigned long dma_ctrl;
 	int ret;
 
 	if (!netif_running(dev))
@@ -4209,7 +4204,7 @@ static int bcmgenet_resume(struct device *d)
 			bcmgenet_hfb_create_rxnfc_filter(priv, rule);
 
 	/* Disable RX/TX DMA and flush TX queues */
-	dma_ctrl = bcmgenet_dma_disable(priv, false);
+	bcmgenet_dma_disable(priv, false);
 
 	/* Reinitialize TDMA and RDMA and SW housekeeping */
 	ret = bcmgenet_init_dma(priv);
@@ -4218,7 +4213,7 @@ static int bcmgenet_resume(struct device *d)
 		goto out_clk_disable;
 	}
 
-	bcmgenet_enable_dma(priv, dma_ctrl);
+	bcmgenet_enable_dma(priv);
 
 	if (!device_may_wakeup(d))
 		phy_resume(dev->phydev);
-- 
2.53.0



