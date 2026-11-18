Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015825;
	b=l8rO8fK4D8Kexukr761mX881rxZvDRv1PeqW9DeqaRyvG8pKSF0ZOABHmbpffZ2vQIhc
	 RExr0bZGMMG4s0Z7KmW2W6lf4DASM6mfEDNUh4VAI5vuFwvUZSX7azwAeMLB/meXPJlBO
	 CyMfWRXVMc+NXDUXuEWsznPu8hmycR9jlQI2Ktn7/ZeRX6RObdyHd8QoskImvMnBsNMCH
	 DWXTUq6PMd4BVQiHg9e2SsqkZSKvq+IJpUWjWb6277FijapOKVwneojIFtJWFe4azEEqW
	 NbmOYuJMNvGD7ASG1sTW3NF9ZLVlpNpd73zg8TUZWhLz2bhe59yM7R/2w80aY9a2WHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v0hNhA9tpst+KkeR9Xg5wXUq3YrtqzFU8vQao17co9M=;
	b=LoEsZzAassBssqZh+njGw3+hzoewUsyY4FncamNS7Xq1pxEyxSqRt76hn9QqbmXvRTET
	 wDKqZU2qQLWtZNCE/uUBSBh2SeFk+RxCou9lKt6WbLPtrxLvrRuJIjqGTRkyouI92W8OG
	 D7eh5uYHE71NCCouvuw7MG/DVEFZQN0UaNYyI9jKIwkhEXi5kszfPVPsFZCr8yDPnGW0c
	 4pi7lIcN7/f0z2x+ZeV99AyEed5kUVN8x5b9y/eACtfTEQ8vSvx6v1ZjviVsvtQgbrOhh
	 LajT9fDAiLwA5NqSiOxir8FRtfYl4ChjeipA+O4k+ufVQ3xM4Grxxc2O05A9tXk92tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K3UOMwlY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE30D60A2603;
	Wed, 18 Nov 2026 15:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K3UOMwlY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1281F000C4;
	Wed, 18 Nov 2026 15:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015825;
	bh=v0hNhA9tpst+KkeR9Xg5wXUq3YrtqzFU8vQao17co9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K3UOMwlYoukPmJVDAPWNuu+Y5c7dYsmZH0XVWacS0Dy4QlGU0pDsfGjkwhVd4Hhld
	 YrG0S61PIyMyLKhD1tLv0Jk+2YjUCDAN8RsoS4F3ZxYO9+Q83ejNa1MJ7uxYEP2n4W
	 MkciL87Xqryg5+PYfe7VHz+67YaqdZY/cfTHcKv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0294/2651] dmaengine: sun6i-dma: Fix use-after-free in error handling paths
Date: Wed, 18 Nov 2026 15:25:34 +0100
Message-ID: <20261118150258.490641658@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit f472919f4c0650d7fb22bb230eacaada0c6ee951 ]

In error handling paths, the for loop frees v_lli in the loop body,
then accesses v_lli->v_lli_next and v_lli->p_lli_next in the
increment expression, which is use-after-free.

Fix by refactoring the cleanup into a helper function sun6i_dma_free_desc()
that saves both the next virtual and physical pointers before freeing the
current node, preventing the use-after-free.

Fixes: 555859308723 ("dmaengine: sun6i: Add driver for the Allwinner A31 DMA controller")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Suggested-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260727061142.44195-1-zenghongling@kylinos.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sun6i-dma.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/sun6i-dma.c b/drivers/dma/sun6i-dma.c
index 7704b016aed8c..738f2547a1b95 100644
--- a/drivers/dma/sun6i-dma.c
+++ b/drivers/dma/sun6i-dma.c
@@ -408,16 +408,12 @@ static inline void sun6i_dma_dump_lli(struct sun6i_vchan *vchan,
 		v_lli->len, v_lli->para, v_lli->p_lli_next);
 }
 
-static void sun6i_dma_free_desc(struct virt_dma_desc *vd)
+static void sun6i_dma_free_desc(struct sun6i_dma_dev *sdev,
+				struct sun6i_desc *txd)
 {
-	struct sun6i_desc *txd = to_sun6i_desc(&vd->tx);
-	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(vd->tx.chan->device);
 	struct sun6i_dma_lli *v_lli, *v_next;
 	dma_addr_t p_lli, p_next;
 
-	if (unlikely(!txd))
-		return;
-
 	p_lli = txd->p_lli;
 	v_lli = txd->v_lli;
 
@@ -434,6 +430,17 @@ static void sun6i_dma_free_desc(struct virt_dma_desc *vd)
 	kfree(txd);
 }
 
+static void sun6i_dma_free_desc_virt(struct virt_dma_desc *vd)
+{
+	struct sun6i_desc *txd = to_sun6i_desc(&vd->tx);
+	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(vd->tx.chan->device);
+
+	if (unlikely(!txd))
+		return;
+
+	sun6i_dma_free_desc(sdev, txd);
+}
+
 static int sun6i_dma_start_desc(struct sun6i_vchan *vchan)
 {
 	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(vchan->vc.chan.device);
@@ -790,10 +797,7 @@ static struct dma_async_tx_descriptor *sun6i_dma_prep_slave_sg(
 	return vchan_tx_prep(&vchan->vc, &txd->vd, flags);
 
 err_lli_free:
-	for (p_lli = txd->p_lli, v_lli = txd->v_lli; v_lli;
-	     p_lli = v_lli->p_lli_next, v_lli = v_lli->v_lli_next)
-		dma_pool_free(sdev->pool, v_lli, p_lli);
-	kfree(txd);
+	sun6i_dma_free_desc(sdev, txd);
 	return NULL;
 }
 
@@ -871,10 +875,7 @@ static struct dma_async_tx_descriptor *sun6i_dma_prep_dma_cyclic(
 	return vchan_tx_prep(&vchan->vc, &txd->vd, flags);
 
 err_lli_free:
-	for (p_lli = txd->p_lli, v_lli = txd->v_lli; v_lli;
-	     p_lli = v_lli->p_lli_next, v_lli = v_lli->v_lli_next)
-		dma_pool_free(sdev->pool, v_lli, p_lli);
-	kfree(txd);
+	sun6i_dma_free_desc(sdev, txd);
 	return NULL;
 }
 
@@ -1429,7 +1430,7 @@ static int sun6i_dma_probe(struct platform_device *pdev)
 		struct sun6i_vchan *vchan = &sdc->vchans[i];
 
 		INIT_LIST_HEAD(&vchan->node);
-		vchan->vc.desc_free = sun6i_dma_free_desc;
+		vchan->vc.desc_free = sun6i_dma_free_desc_virt;
 		vchan_init(&vchan->vc, &sdc->slave);
 	}
 
-- 
2.53.0



