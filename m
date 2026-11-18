Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054821;
	b=y77jx0/vxtLY2zYpydF0BhB2BCrf5swb45YI9O9Tkx4yY7iCgr+9LD+ji2CDYkEkBvFj
	 0Ury7wU6h1KHajjckQGQSgUz/IVpazCqxWSjO1qeMK9cKme57ghJaMC+T4eFKKeXi4O0V
	 BcufW6a+ON7nws7YJOQNxQdtmV6nXBAbOI8g9h0qbVPucMRWyOM4ludWwkZ4Tz70eUhu2
	 Hp7+BIKZ34T8Cr/kTPMOthvQeAOjzLdLg8K5YkgXrehfTrDPumGy+ZtEATHxEtMmLnOZN
	 /53p3ONrXdKIOjl9NyJUAY/CWtr5uAXaBfaWKyiJTGMaIDqvi/9VV8G+iB+6aHNFpNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IPr7KjsUZsL5DW7RqpMSQ5EE75B/eHWMZFY/jkWATuY=;
	b=tU1ut+gqLYbuwOFoNNzOrP2QtD+7ZI1QMVX1MyXA1ZSx63a62SozaYr68uDLWesjs5ld
	 fnI3kuGdkvCvOgu/rvT/JBEA9gBRmRXR24BHm5meyjET1riVWCtj1NkTdq6A0FWINHUgg
	 8p3sy4qh5iz2Cylta37OUvmhoHaixNS0FdJNoujZXgmVrWjXDn3/5gsihPJXkF83rXodB
	 ee1kHqrxHKsaj9CD4e2E4fMEc7XbP5AaWeZO5oeRUdwyOMv94lhhXDWG13OW5QwTBQVHG
	 7ykguBvitj5VJ7duSyM2gka/7mAxn+G5yAc380JGQlzbkO151zQtwFfaaiiqjynMB/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oYl1n5ue;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B30606A320;
	Thu, 19 Nov 2026 02:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oYl1n5ue
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3272F1F000C4;
	Thu, 19 Nov 2026 02:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054820;
	bh=IPr7KjsUZsL5DW7RqpMSQ5EE75B/eHWMZFY/jkWATuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oYl1n5ueGRq55L0gMecRxig34FsurRM+jDXepXpErhwI2/wPXCJqvDeM4IuI1GkLF
	 QXMrXqnjspN28Hlx9sgfNaemV+GFv3hfcdBGXhzSWL/uw7H1rozuEayziERt7jqxQD
	 aTkvvzV7FiOZnIaIubDNgE/JYz6evAmUEeTix3Lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Golla Nagendra <nagendra.golla@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1410/2214] dmaengine: zynqmp_dma: Fix chan probe/remove error handling
Date: Wed, 18 Nov 2026 15:51:26 +0100
Message-ID: <20261118150107.660185121@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 15289537bb429..efaef1d7e37dc 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -207,7 +207,7 @@ struct zynqmp_dma_desc_sw {
  * @desc_pool_p: Physical allocated descriptor base
  * @desc_free_cnt: Descriptor available count
  * @dev: The dma device
- * @irq: Channel IRQ
+ * @irq: Linux IRQ number, or -1 when not registered
  * @is_dmacoherent: Tells whether dma operations are coherent or not
  * @tasklet: Cleanup work after irq
  * @idle : Channel status;
@@ -872,10 +872,11 @@ static void zynqmp_dma_chan_remove(struct zynqmp_dma_chan *chan)
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
@@ -892,13 +893,14 @@ static int zynqmp_dma_chan_probe(struct zynqmp_dma_device *zdev,
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
@@ -932,22 +934,26 @@ static int zynqmp_dma_chan_probe(struct zynqmp_dma_device *zdev,
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
 
@@ -1103,7 +1109,7 @@ static int zynqmp_dma_probe(struct platform_device *pdev)
 	ret = zynqmp_dma_chan_probe(zdev, pdev);
 	if (ret) {
 		dev_err_probe(&pdev->dev, ret, "Probing channel failed\n");
-		goto err_disable_pm;
+		goto free_chan_resources;
 	}
 
 	p->dst_addr_widths = BIT(zdev->chan->bus_width / 8);
-- 
2.53.0



