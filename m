Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023336;
	b=kFGdQmDrwZxb2JPsHcWQCW57yiOCREVovyAe6NcQjFR61f1D6MpUZQwdHYSe/CKvhAml
	 KQ9jq9lGEr6/V8Gj4y5OCJjAqG3uvuYanMiq3XFbmF8O3Z0s5T1k+if1u6B84gY9bwbvC
	 Hk/lHcxTZtg5lYc8RxlrPy45GIcWSuUA60YsWi1n0U26e27Rk5zZdU6D0bFnNrchf3F4b
	 +PIODfkxYmTzzhK4bNuu2PJSDZDZH1WhbLfPcqpMuF/c6hdZGMT0r3ZJRszhdlbwVi6eK
	 byGR6aDeG+HY8dYbAQsiCFF5bpFcGItg0l+yfmWSqKVC7Pql/FHNH4UxJZAedZkAZcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MiTB25yq5/62HHDLs9+Lr+dEiruq3DFy17+D7muYKJM=;
	b=uLxUVhsEmIHQnLnlvSoKCx+DvlLz0SAN2j/27NBIl3g9AiQpXeBBrLUu63E3rsZT19W+
	 fXcfaQLdshfMXnJrRhgxBKKyKjy4mq6gH5ZGN8Aq4YQXtCzluq0uYz64/vRlQ4bfgIlHq
	 d9fO+0c6/8wiLJDSPYpCEOBtkBOhNC7qgB/9/wuH83DudWAXQ9HtcOjLzFDur3+Fbhxlr
	 TI8LxUAcxyIBdsqbqBbGz05mJseuZPYr96u8MWz/wTtB/ej0FJ5OZb0vpNoTs2VvoIskh
	 WZvPd8/MVZtaZmPpfyl4RFg283FMAuShaVq1zfoRO/3O+sKxemN4BIVW0odhlt02c2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ONs/ItSP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A54E606A320;
	Wed, 18 Nov 2026 17:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ONs/ItSP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF13C1F000C4;
	Wed, 18 Nov 2026 17:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023336;
	bh=MiTB25yq5/62HHDLs9+Lr+dEiruq3DFy17+D7muYKJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ONs/ItSPp4ae+Wy05QPy2CoxAvhIsE2fnhue0ZQRDbYLOgKAi3FIiRgcCZsk42l5p
	 fpr+T5MvIpCDBQIEpAg6J1pMHsxsOhnkKBkFdIP3v/hCk6pMqIyN+rI/AWMpDljgVa
	 kRSnyP/MZpEiwNEfUsk+jt6RynEj/3m9xZH+WwUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0296/2151] dmaengine: sun6i-dma: Fix use-after-free in error handling paths
Date: Wed, 18 Nov 2026 15:33:51 +0100
Message-ID: <20261118150132.695580163@linuxfoundation.org>
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
index 69f4d27247a7c..a9a4d7df248f1 100644
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
 
@@ -861,10 +865,7 @@ static struct dma_async_tx_descriptor *sun6i_dma_prep_dma_cyclic(
 	return vchan_tx_prep(&vchan->vc, &txd->vd, flags);
 
 err_lli_free:
-	for (p_lli = txd->p_lli, v_lli = txd->v_lli; v_lli;
-	     p_lli = v_lli->p_lli_next, v_lli = v_lli->v_lli_next)
-		dma_pool_free(sdev->pool, v_lli, p_lli);
-	kfree(txd);
+	sun6i_dma_free_desc(sdev, txd);
 	return NULL;
 }
 
@@ -1419,7 +1420,7 @@ static int sun6i_dma_probe(struct platform_device *pdev)
 		struct sun6i_vchan *vchan = &sdc->vchans[i];
 
 		INIT_LIST_HEAD(&vchan->node);
-		vchan->vc.desc_free = sun6i_dma_free_desc;
+		vchan->vc.desc_free = sun6i_dma_free_desc_virt;
 		vchan_init(&vchan->vc, &sdc->slave);
 	}
 
-- 
2.53.0



