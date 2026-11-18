Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029226;
	b=GxdTKnZ5afaqOV6e+2tMmZfNVKGKWXBhCcKhf0zcW3CLdcHoiw/ava4aPfo+G5BzeYZE
	 aOA0aT7/bMetfnc/XPyR0svlCegDh0yQnkJ4M5qdy2ZgJFNd7MaHYXPtxMZCBXhKOGGeg
	 JEiGaL7UfSzkbRGKHiAHUIny/tt22hlhBwF88ac+31ds7QH+9f6zEbwYum4Q3XMfPx+he
	 MXi7uBYDryuLrLgzfe5Ag43kcPcX3mqiypwL7CzXmEmLzkmxgqZ/N5aYDBRtCElOBc2j8
	 7f1RVtdyjlSRqoCRzMOiWYwyYy/CEhl7kZW5U3nrHgytkU5rpal/9EIJc2a5Q+cE9mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029226;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DJqqbiP70CXB0OxwrW5JPzDsn6dQIEAL7ilv7cRA4u4=;
	b=mtPmteuM7wMYZQxuelJnkXJchXqaa8V9g8c94Wpibbv1DGw39g9AYFUPnlHU749ykuTt
	 1/IT1CQGml+TBY9eG52dAk3Cm7AgxlhUUqGoQvB6kd3ZcxcCFJHRHol5QSBKN2VeW8qUK
	 ImAYTvDkRGTUc3BUYy5kWjePBKNC1hgnOSESySi4u4UvXX3JhdVANouWxSqQdVOYKsjL2
	 vc+E05cZUqwDe7F6RnjbCXyaxwe5EiFB7p/7Zj7UgjDwC1qptKA5u70piY1l7z5xcS006
	 nVUhNs1wizAD/bVg+Cf+zPCW37dMKe3VqoiBgWfJ+noaJHKMVIhK6NsoqIRDrpVu+OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XtNTpuYJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D41606A31C;
	Wed, 18 Nov 2026 19:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XtNTpuYJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352271F000C4;
	Wed, 18 Nov 2026 19:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029226;
	bh=DJqqbiP70CXB0OxwrW5JPzDsn6dQIEAL7ilv7cRA4u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XtNTpuYJt5H9BPJ0brm/CHfe3ebDoIPoqDWnLqebjBS3r+kjQjwqlkHBb0yLuCNqQ
	 FTac/5FoISVShNA5yNvc+GYJHV7UzbOcR9cuFdeGqsUyIh0Eel38Ee5fUgtb7fRVPy
	 KDEdJYWYc8bMxWFBS088F7C07ou9ogtA7ND8tHc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Golla Nagendra <nagendra.golla@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0276/1756] dmaengine: zynqmp_dma: Fix chan probe/remove error handling
Date: Wed, 18 Nov 2026 15:40:03 +0100
Message-ID: <20261118150019.413954885@linuxfoundation.org>
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

From: Golla Nagendra <nagendra.golla@amd.com>

[ Upstream commit 0266dac57019201a14a81245d22750ab221d6c66 ]

Keep the real platform_get_irq() error by returning ret directly, stage
IRQ setup via a local ret variable, and assign chan->irq only after
devm_request_irq() succeeds.

Initialize chan->irq to -1 and initialize chan->common.device_node
before it may be touched by teardown. In channel remove, free IRQ only
for valid IRQ numbers and delete the channel node only when it is linked.

Register the channel node only after successful IRQ setup. On channel
probe failure in zynqmp_dma_probe(), route cleanup through the existing
free_chan_resources teardown path.

Fixes: b0cc417c1637 ("dmaengine: Add Xilinx zynqmp dma engine driver support")
Signed-off-by: Golla Nagendra <nagendra.golla@amd.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260814045616.1661199-4-nagendra.golla@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/zynqmp_dma.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/xilinx/zynqmp_dma.c b/drivers/dma/xilinx/zynqmp_dma.c
index 9ae46f1198fe6..e8661f7b755a4 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -205,7 +205,7 @@ struct zynqmp_dma_desc_sw {
  * @desc_pool_p: Physical allocated descriptor base
  * @desc_free_cnt: Descriptor available count
  * @dev: The dma device
- * @irq: Channel IRQ
+ * @irq: Linux IRQ number, or -1 when not registered
  * @is_dmacoherent: Tells whether dma operations are coherent or not
  * @tasklet: Cleanup work after irq
  * @idle : Channel status;
@@ -887,10 +887,11 @@ static void zynqmp_dma_chan_remove(struct zynqmp_dma_chan *chan)
 	if (!chan)
 		return;
 
-	if (chan->irq)
+	if (chan->irq >= 0)
 		devm_free_irq(chan->zdev->dev, chan->irq, chan);
 	tasklet_kill(&chan->tasklet);
-	list_del(&chan->common.device_node);
+	if (!list_empty(&chan->common.device_node))
+		list_del(&chan->common.device_node);
 }
 
 /**
@@ -906,13 +907,14 @@ static int zynqmp_dma_chan_probe(struct zynqmp_dma_device *zdev,
 	struct zynqmp_dma_chan *chan;
 	struct device_node *node = pdev->dev.of_node;
 	const struct zynqmp_dma_config *match_data;
-	int err;
+	int err, ret;
 
 	chan = devm_kzalloc(zdev->dev, sizeof(*chan), GFP_KERNEL);
 	if (!chan)
 		return -ENOMEM;
 	chan->dev = zdev->dev;
 	chan->zdev = zdev;
+	chan->irq = -1;
 
 	chan->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(chan->regs))
@@ -945,22 +947,26 @@ static int zynqmp_dma_chan_probe(struct zynqmp_dma_device *zdev,
 	INIT_LIST_HEAD(&chan->pending_list);
 	INIT_LIST_HEAD(&chan->done_list);
 	INIT_LIST_HEAD(&chan->free_list);
+	INIT_LIST_HEAD(&chan->common.device_node);
 
 	dma_cookie_init(&chan->common);
 	chan->common.device = &zdev->common;
-	list_add_tail(&chan->common.device_node, &zdev->common.channels);
-
 	zynqmp_dma_init(chan);
-	chan->irq = platform_get_irq(pdev, 0);
-	if (chan->irq < 0)
-		return -ENXIO;
-	err = devm_request_irq(&pdev->dev, chan->irq, zynqmp_dma_irq_handler, 0,
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		return ret;
+
+	err = devm_request_irq(&pdev->dev, ret, zynqmp_dma_irq_handler, 0,
 			       "zynqmp-dma", chan);
 	if (err)
 		return err;
 
+	chan->irq = ret;
+
 	chan->desc_size = sizeof(struct zynqmp_dma_desc_ll);
 	chan->idle = true;
+	list_add_tail(&chan->common.device_node, &zdev->common.channels);
+
 	return 0;
 }
 
@@ -1125,7 +1131,7 @@ static int zynqmp_dma_probe(struct platform_device *pdev)
 	ret = zynqmp_dma_chan_probe(zdev, pdev);
 	if (ret) {
 		dev_err_probe(&pdev->dev, ret, "Probing channel failed\n");
-		goto err_disable_pm;
+		goto free_chan_resources;
 	}
 
 	p->dst_addr_widths = BIT(zdev->chan->bus_width / 8);
-- 
2.53.0



