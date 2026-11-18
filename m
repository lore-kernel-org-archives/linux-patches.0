Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047962;
	b=Qwxf4Uj8JtbXEBdR6gWoQXvpPDGVgHwhVyafbBxpLbPCR+aqYiKkj6AqkR12Ig63wmYf
	 z/D5F7LQoysGVJ7TffO+zWUbQ2qkGJ/WoY8P7h+4UpHO/VYhdMzW1aJAdi3UpXCOht+bm
	 EYDcpEbd4/542H+X4Qxezhh3/S8IatFLZpdfuXOTCGk1/LCibR7uOrLfsTpKwChOeQ9XV
	 2wJ5Viw/VEiTBI6mVD8pLd5qszcPL7hHjZ7lzemFTTklKd0zHYk39aMKgvnlJaMVO1TuP
	 sEG4sjIUWMgcV5d2wHWog/htBU3igg7YWJ4ay75QBGaBuGft2lHA6enAkxgQ+YcNzjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RJ4n4DZvCEVnZozHzreYuN1mRqMjS7J3oLSkSF6GCY8=;
	b=jk5hc0gzTpuVKs3XejjyDDgKKabfUJ/5CNuBoL53kotge2drc71idXmFnXEU49JywUnL
	 2DQIJmoaoOV5AzOKMfgAmxq7C9cS2b8ftzz/gXMdPuzSdgoPbxbdeetKXGclPCleVUqWc
	 0eZb69rshxq1KnQ1PEaZgIaSI4/EqHUNIzDXpeBDQ+qMSCaJv+HzomJZ7pxJofP+Af2c5
	 vc1B+dVbOnlTiN2CImn/CUOf2/k0BykdF2vrtX6qqTQ8u44RZyXQRhE3gVO8C4q87lz/I
	 4sbKdTdKqnN+s7G8rxXU3kf+OPz4DfEYoepvMCxb+n6yknZx+biFQ7k+mUDUhzNVgvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VnFA4N7k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E666B606A31C;
	Thu, 19 Nov 2026 00:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VnFA4N7k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D7D1F000C5;
	Thu, 19 Nov 2026 00:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047961;
	bh=RJ4n4DZvCEVnZozHzreYuN1mRqMjS7J3oLSkSF6GCY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VnFA4N7kllNN+lJtxib1QixliXDyZKyO2TAYLPJ86z2lEG3g67TsH/6Z8ovpGzILh
	 8ArTIvg2SRuRUPbP3Q6CX4fDdushjo5jMHcL5x3+OgD6akORb8UozwV5MEOjFqa1eW
	 h6YE5PQ+v6HpWpwfN/rA6TOivAgfucnDV1nXPzKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Golla Nagendra <nagendra.golla@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1826/2857] dmaengine: zynqmp_dma: Fix chan probe/remove error handling
Date: Wed, 18 Nov 2026 15:47:40 +0100
Message-ID: <20261118150307.007839174@linuxfoundation.org>
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
index da97237726355..b1dbfc9beda0b 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -204,7 +204,7 @@ struct zynqmp_dma_desc_sw {
  * @desc_pool_p: Physical allocated descriptor base
  * @desc_free_cnt: Descriptor available count
  * @dev: The dma device
- * @irq: Channel IRQ
+ * @irq: Linux IRQ number, or -1 when not registered
  * @is_dmacoherent: Tells whether dma operations are coherent or not
  * @tasklet: Cleanup work after irq
  * @idle : Channel status;
@@ -886,10 +886,11 @@ static void zynqmp_dma_chan_remove(struct zynqmp_dma_chan *chan)
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
 	struct resource *res;
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
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	chan->regs = devm_ioremap_resource(&pdev->dev, res);
@@ -946,22 +948,26 @@ static int zynqmp_dma_chan_probe(struct zynqmp_dma_device *zdev,
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
 
@@ -1122,7 +1128,7 @@ static int zynqmp_dma_probe(struct platform_device *pdev)
 	ret = zynqmp_dma_chan_probe(zdev, pdev);
 	if (ret) {
 		dev_err_probe(&pdev->dev, ret, "Probing channel failed\n");
-		goto err_disable_pm;
+		goto free_chan_resources;
 	}
 
 	p->dst_addr_widths = BIT(zdev->chan->bus_width / 8);
-- 
2.53.0



