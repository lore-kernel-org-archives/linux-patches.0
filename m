Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057211;
	b=uKUR8FQkx7hv3X1/qfN/gPBUX1iTBthFnALHkoHCh+x0uDu6PBNy7ivxj2uM/HT0YnDM
	 Vl3cbpEiLj7o5kE9OyQ0aPqcspy9sO82YVn39hgVMABQ6bwn/zOG6yRfblD6NEpzGotm0
	 BHvIxUnfRcTB1vi5ASjNLre5a2OEVAj8AhKv7UXs4HQ0/0bev+oyNa94aOsmMq8HCI6KB
	 ry2T7PPn36M+NsWCEjcHIyRkSqIQlINQm5ur7J3LIFkVx9U3wwqjaddhACWwvSGRnbUtD
	 xDv+fEYBWPSp0ryjFPzdaNVgOhWvHgLsmy5Gkqyn+YzWrKimwcK7yvoL98P8UifCD6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kmsJo85I7k4yLFqgmOSZNYg+suzTKY3fyln0DDuyVwc=;
	b=jBN08AJzO/ECGqC2t3qzOhgNDKbRYqe/9LuT7B42HCDQWEgFhrcn4CNxuuhkk1QBAoJl
	 RC07E6stKlK53MOXeAqlhUC2Pg4lbVBmIk5O35jw1YL5exrWVOgV5GP4wt42pxEoJzQe4
	 BUod4zJOspLdG+ZCQSo7Fsedq9CYbLCxbiMBiT3J+KuM4NJmQOmnJWXh82K7brheGNagj
	 l2dPiycOrOimabu/nv9OrHa3iDuFoVt2neCLqO7I7dZiFXxFvPkW46rjE0rKtCAk0BkPx
	 VHupz7rhT843/d35SHuqaMVXtt3c0xGlu0fH8z0ydv/3Lp8nFfbaz5tqnmIWVC8sPNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dURD8RZ8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78A060A2617;
	Thu, 19 Nov 2026 03:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dURD8RZ8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203B21F000C4;
	Thu, 19 Nov 2026 03:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057211;
	bh=kmsJo85I7k4yLFqgmOSZNYg+suzTKY3fyln0DDuyVwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dURD8RZ8kLmXcmKtJ/hkPtuhiJzU6e6YGC1ESbJF48KUrsw4k8d3tR4s518Iqphi5
	 iav3MygRHfVArdHwu5QtfrYYsDuNa3LXwN56mscVJ/HqaW5AFeV5AaEqb9xMBZjzIS
	 vCkZnM4FDvPEJ/rudTJ6yNmIT/ft7eYVtHtv7/xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Zhou <yun.zhou@windriver.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0048/1848] net: mvneta_bm: add suspend/resume support to prevent crash after resume
Date: Wed, 18 Nov 2026 15:34:46 +0100
Message-ID: <20261118145913.102893516@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit 140be217df577961bea1ca36240439a463026cbd ]

The mvneta driver uses the hardware Buffer Manager (BM) for RX buffer
allocation. During suspend, mvneta disables its clock, causing BM to
lose all buffer address state. On resume, mvneta_bm_port_init() re-
attaches the BM pool to the NIC, but BM hardware returns stale/garbage
buffer addresses. When NAPI poll processes these buffers, DMA cache
sync hits an invalid virtual address causing a kernel panic:

 Unable to handle kernel paging request at virtual address b0000080
 PC is at v7_dma_inv_range
 Call trace:
  v7_dma_inv_range from arch_sync_dma_for_cpu+0x94/0x158
  arch_sync_dma_for_cpu from __dma_sync_single_for_cpu+0xc4/0x15c
  __dma_sync_single_for_cpu from mvneta_rx_swbm+0x6c8/0xf48
  mvneta_rx_swbm from mvneta_poll+0x6fc/0x70c
  mvneta_poll from __napi_poll.constprop.0+0x2c/0x1e0
  __napi_poll.constprop.0 from net_rx_action+0x160/0x2c4
  net_rx_action from handle_softirqs+0xd8/0x2b8
  handle_softirqs from run_ksoftirqd+0x30/0x94
  run_ksoftirqd from smpboot_thread_fn+0x100/0x204
  smpboot_thread_fn from kthread+0xf4/0x110
  kthread from ret_from_fork+0x14/0x28

Fix by adding suspend/resume callbacks to the BM driver:

- suspend: drain all buffers (with DMA unmapping), free the BPPE
  regions, and reset pool state to FREE before stopping BM and gating
  the clock.

- resume: enable the clock, reinitialize BM defaults, and restore pool
  read/write pointers and size registers. Pool allocation and buffer
  refill are handled by mvneta_resume() through the normal
  mvneta_bm_port_init() path, which sees pools as FREE and performs
  full initialization identical to probe.

Add a device_link (DL_FLAG_AUTOREMOVE_CONSUMER) in mvneta_probe to
guarantee BM resumes before mvneta and suspends after mvneta. If the
link cannot be created, fall back to SW buffer management to avoid a
potential crash on resume due to unordered PM transitions.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Link: https://patch.msgid.link/20260630060311.4072140-1-yun.zhou@windriver.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c    | 18 ++++++
 drivers/net/ethernet/marvell/mvneta_bm.c | 72 ++++++++++++++++++++++++
 2 files changed, 90 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 6394b52216b52..2e28cc98cd336 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5216,6 +5216,24 @@ static int mvneta_probe(struct platform_device *pdev)
 					 "use SW buffer management\n");
 				mvneta_bm_put(pp->bm_priv);
 				pp->bm_priv = NULL;
+			} else if (!device_link_add(&pdev->dev,
+						    &pp->bm_priv->pdev->dev,
+						    DL_FLAG_AUTOREMOVE_CONSUMER)) {
+				/*
+				 * Link guarantees BM resumes before mvneta.
+				 * Without it, BM may not be ready when
+				 * mvneta_bm_port_init() runs on resume,
+				 * causing stale buffer addresses and a crash.
+				 * Fall back to SW management to be safe.
+				 */
+				dev_warn(&pdev->dev,
+					 "failed to link to BM, use SW buffer management\n");
+				mvneta_bm_pool_destroy(pp->bm_priv,
+						       pp->pool_long, 1 << pp->id);
+				mvneta_bm_pool_destroy(pp->bm_priv,
+						       pp->pool_short, 1 << pp->id);
+				mvneta_bm_put(pp->bm_priv);
+				pp->bm_priv = NULL;
 			}
 		}
 		/* Set RX packet offset correction for platforms, whose
diff --git a/drivers/net/ethernet/marvell/mvneta_bm.c b/drivers/net/ethernet/marvell/mvneta_bm.c
index 46c942ef2287f..e6489f5772493 100644
--- a/drivers/net/ethernet/marvell/mvneta_bm.c
+++ b/drivers/net/ethernet/marvell/mvneta_bm.c
@@ -129,6 +129,7 @@ static int mvneta_bm_pool_create(struct mvneta_bm *priv,
 	if (!IS_ALIGNED((u32)bm_pool->virt_addr, MVNETA_BM_POOL_PTR_ALIGN)) {
 		dma_free_coherent(&pdev->dev, size_bytes, bm_pool->virt_addr,
 				  bm_pool->phys_addr);
+		bm_pool->virt_addr = NULL;
 		dev_err(&pdev->dev, "BM pool %d is not %d bytes aligned\n",
 			bm_pool->id, MVNETA_BM_POOL_PTR_ALIGN);
 		return -ENOMEM;
@@ -139,6 +140,7 @@ static int mvneta_bm_pool_create(struct mvneta_bm *priv,
 	if (err < 0) {
 		dma_free_coherent(&pdev->dev, size_bytes, bm_pool->virt_addr,
 				  bm_pool->phys_addr);
+		bm_pool->virt_addr = NULL;
 		return err;
 	}
 
@@ -479,6 +481,75 @@ static int mvneta_bm_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static int mvneta_bm_suspend(struct device *dev)
+{
+	struct mvneta_bm *priv = dev_get_drvdata(dev);
+	int i;
+
+	/* Drain buffers and free pool resources while BM is still clocked */
+	for (i = 0; i < MVNETA_BM_POOLS_NUM; i++) {
+		struct mvneta_bm_pool *bm_pool = &priv->bm_pools[i];
+		int size_bytes;
+
+		if (bm_pool->type == MVNETA_BM_FREE)
+			continue;
+
+		mvneta_bm_bufs_free(priv, bm_pool, bm_pool->port_map);
+		if (bm_pool->hwbm_pool.buf_num)
+			dev_warn(&priv->pdev->dev,
+				 "pool %d: %d buffers not freed\n",
+				 bm_pool->id, bm_pool->hwbm_pool.buf_num);
+
+		mvneta_bm_pool_disable(priv, bm_pool->id);
+
+		if (bm_pool->virt_addr) {
+			size_bytes = sizeof(u32) * bm_pool->hwbm_pool.size;
+			dma_free_coherent(&priv->pdev->dev, size_bytes,
+					  bm_pool->virt_addr,
+					  bm_pool->phys_addr);
+			bm_pool->virt_addr = NULL;
+		}
+		/*
+		 * Safe to destroy: device_link guarantees all mvneta ports
+		 * have already suspended, so no hwbm_pool_add() can be in
+		 * progress holding buf_lock.  Pairs with mutex_init() in
+		 * mvneta_bm_pool_use() on resume.
+		 */
+		mutex_destroy(&bm_pool->hwbm_pool.buf_lock);
+		bm_pool->type = MVNETA_BM_FREE;
+	}
+
+	mvneta_bm_write(priv, MVNETA_BM_COMMAND_REG, MVNETA_BM_STOP_MASK);
+	clk_disable_unprepare(priv->clk);
+	return 0;
+}
+
+static int mvneta_bm_resume(struct device *dev)
+{
+	struct mvneta_bm *priv = dev_get_drvdata(dev);
+	int i, err;
+
+	err = clk_prepare_enable(priv->clk);
+	if (err)
+		return err;
+
+	/* Reinitialize BM hardware; pools are refilled by mvneta_resume() */
+	mvneta_bm_default_set(priv);
+
+	/* Restore pool registers lost during clock gating */
+	for (i = 0; i < MVNETA_BM_POOLS_NUM; i++) {
+		mvneta_bm_write(priv, MVNETA_BM_POOL_READ_PTR_REG(i), 0);
+		mvneta_bm_write(priv, MVNETA_BM_POOL_WRITE_PTR_REG(i), 0);
+		mvneta_bm_write(priv, MVNETA_BM_POOL_SIZE_REG(i),
+				priv->bm_pools[i].hwbm_pool.size);
+	}
+
+	mvneta_bm_write(priv, MVNETA_BM_COMMAND_REG, MVNETA_BM_START_MASK);
+	return 0;
+}
+
+static DEFINE_SIMPLE_DEV_PM_OPS(mvneta_bm_pm_ops, mvneta_bm_suspend, mvneta_bm_resume);
+
 static const struct of_device_id mvneta_bm_match[] = {
 	{ .compatible = "marvell,armada-380-neta-bm" },
 	{ }
@@ -491,6 +562,7 @@ static struct platform_driver mvneta_bm_driver = {
 	.driver = {
 		.name = MVNETA_BM_DRIVER_NAME,
 		.of_match_table = mvneta_bm_match,
+		.pm = pm_sleep_ptr(&mvneta_bm_pm_ops),
 	},
 };
 
-- 
2.53.0



