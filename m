Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039440;
	b=Iv0gGtfPWT67r0gE9u5J2Mvzc57cTHbgsy6mqQf9S2gnpdzrV4NdJ5PxuaggsxaHoLSs
	 fmynRlgL45bLNWXQKZPXhyjbUpsRTGUM9iLb6m43kMWljKyk8Ru6SdwWA29wD8ROOY5Co
	 4RuCGLetfQZE8bDpyOZiY6G7U7Ra53t6eVawlgaWQ2V3Pp+p958msfEzcK90BlIjI6/jQ
	 3Ye1oQG8MWjeMtQs3bYddSOYHaGmcZXjuPgyGK1FIzupPMKkpfJ0u7QNt4YIeI1elfBNU
	 u9B6Q4T9KdfQy/xs4TpjLZ0Zx0ZGXdvYI68F8itNQCWjMndfruzcfT5BJznMkmB471w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039440;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E4YwuYvDQFeLY3QKYAE96BeMMpiCEjJ5ucf+RGK9iPY=;
	b=CFdFs0Bmw5VgIh7fyIzJ1GFQ7pohRf74XBnmKYrbCXng7rDsSGSbsl3D0D5KciwNIuNB
	 GPLRfzAbWiVZOs08dE+3BFpOCSpHNfXt0tlW6l0ldKWZgJXoh9rC8JQ3V9LoJzXY2s/US
	 kCn+RRe85tO+yILhRmEPLEMyh5N2xEiBhIcCBNXwwszD9C5dGukNMYJNeVjiZu+EBqIGx
	 +X+Vp4DlwZob0wjjQgFVEGfvSFM5johXUoD9PGCNzSp6TFEZZmobDiCtYuxpAhpgVGxwb
	 ZyYiuGynCyLYxrJ7YSwgdX2nRqfv4Lqa+FLvBEJZtFgvoYPvnU2+lk+NYMDePv5zfGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ne9jPBw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C63606A31C;
	Wed, 18 Nov 2026 22:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ne9jPBw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C301F000C4;
	Wed, 18 Nov 2026 22:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039440;
	bh=E4YwuYvDQFeLY3QKYAE96BeMMpiCEjJ5ucf+RGK9iPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ne9jPBwdzkCBVKxJigG2eoHkll8r+TvN5Aund/N5ioEyquY+wjU8T82YfDFYvYd8
	 dpsJsCd7B1VnaIa5D50L/5VP6ezqome1uuVvL+Bc/CaMh8f5Yl/NE8HPU27DZM3bPu
	 AjeEyo7U1QS0Y4xpwkTpyH1dr1nQ8oQTmMkEpwsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abin Joseph <abin.joseph@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2094/3318] dmaengine: zynqmp_dma: Add support for AMD Versal Gen 2 DMA IP
Date: Wed, 18 Nov 2026 15:45:16 +0100
Message-ID: <20261118150424.912970202@linuxfoundation.org>
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

From: Abin Joseph <abin.joseph@amd.com>

[ Upstream commit 13113f750a4ae0b1770fa25dc94852977ebfb942 ]

ZynqMP DMA IP and AMD Versal Gen 2 DMA IP are similar but have different
interrupt register offset. Create a dedicated compatible string to
support Versal Gen 2 DMA IP with Irq register offset for interrupt
Enable/Disable/Status/Mask functionality.

Signed-off-by: Abin Joseph <abin.joseph@amd.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://lore.kernel.org/r/20240808100024.317497-3-abin.joseph@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 0266dac57019 ("dmaengine: zynqmp_dma: Fix chan probe/remove error handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/zynqmp_dma.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/xilinx/zynqmp_dma.c b/drivers/dma/xilinx/zynqmp_dma.c
index bd8c3cc2eaab6..e8068cf62613b 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -22,10 +22,10 @@
 #include "../dmaengine.h"
 
 /* Register Offsets */
-#define ZYNQMP_DMA_ISR			0x100
-#define ZYNQMP_DMA_IMR			0x104
-#define ZYNQMP_DMA_IER			0x108
-#define ZYNQMP_DMA_IDS			0x10C
+#define ZYNQMP_DMA_ISR			(chan->irq_offset + 0x100)
+#define ZYNQMP_DMA_IMR			(chan->irq_offset + 0x104)
+#define ZYNQMP_DMA_IER			(chan->irq_offset + 0x108)
+#define ZYNQMP_DMA_IDS			(chan->irq_offset + 0x10c)
 #define ZYNQMP_DMA_CTRL0		0x110
 #define ZYNQMP_DMA_CTRL1		0x114
 #define ZYNQMP_DMA_DATA_ATTR		0x120
@@ -145,6 +145,9 @@
 #define tx_to_desc(tx)		container_of(tx, struct zynqmp_dma_desc_sw, \
 					     async_tx)
 
+/* IRQ Register offset for Versal Gen 2 */
+#define IRQ_REG_OFFSET			0x308
+
 /**
  * struct zynqmp_dma_desc_ll - Hw linked list descriptor
  * @addr: Buffer address
@@ -211,6 +214,7 @@ struct zynqmp_dma_desc_sw {
  * @bus_width: Bus width
  * @src_burst_len: Source burst length
  * @dst_burst_len: Dest burst length
+ * @irq_offset: Irq register offset
  */
 struct zynqmp_dma_chan {
 	struct zynqmp_dma_device *zdev;
@@ -235,6 +239,7 @@ struct zynqmp_dma_chan {
 	u32 bus_width;
 	u32 src_burst_len;
 	u32 dst_burst_len;
+	u32 irq_offset;
 };
 
 /**
@@ -253,6 +258,14 @@ struct zynqmp_dma_device {
 	struct clk *clk_apb;
 };
 
+struct zynqmp_dma_config {
+	u32 offset;
+};
+
+static const struct zynqmp_dma_config versal2_dma_config = {
+	.offset = IRQ_REG_OFFSET,
+};
+
 static inline void zynqmp_dma_writeq(struct zynqmp_dma_chan *chan, u32 reg,
 				     u64 value)
 {
@@ -892,6 +905,7 @@ static int zynqmp_dma_chan_probe(struct zynqmp_dma_device *zdev,
 {
 	struct zynqmp_dma_chan *chan;
 	struct device_node *node = pdev->dev.of_node;
+	const struct zynqmp_dma_config *match_data;
 	int err;
 
 	chan = devm_kzalloc(zdev->dev, sizeof(*chan), GFP_KERNEL);
@@ -919,6 +933,10 @@ static int zynqmp_dma_chan_probe(struct zynqmp_dma_device *zdev,
 		return -EINVAL;
 	}
 
+	match_data = of_device_get_match_data(&pdev->dev);
+	if (match_data)
+		chan->irq_offset = match_data->offset;
+
 	chan->is_dmacoherent =  of_property_read_bool(node, "dma-coherent");
 	zdev->chan = chan;
 	tasklet_setup(&chan->tasklet, zynqmp_dma_do_tasklet);
@@ -1163,6 +1181,7 @@ static int zynqmp_dma_remove(struct platform_device *pdev)
 }
 
 static const struct of_device_id zynqmp_dma_of_match[] = {
+	{ .compatible = "amd,versal2-dma-1.0", .data = &versal2_dma_config },
 	{ .compatible = "xlnx,zynqmp-dma-1.0", },
 	{}
 };
-- 
2.53.0



