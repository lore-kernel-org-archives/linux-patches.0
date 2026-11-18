Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047959;
	b=MLwSf81BsOFF6a7vNepdmqDP1Oc2GYxFBFnFbDwc9yIZ/w1oxXrUDSn7iR3bYWCzzoKp
	 uEDiw/ZRDV1+nofiGxnK3g8TXeE8C9JXDmmHyI/J9VsCaiaa8Eo3Sc9qx2Ty10I+BO/B4
	 eNQvYPfPKGSJOeZswyvuAOLp5HkPmKlrf06YWm1DPN8u9pNY9qO33Y8HBfHAPEpwkW3jN
	 oH99nMaqPvrT/plotqQvWurO6CSkN+5mnk+tw5ZecW0nQ/LKiQgdVFRHk3yjvbenmL0br
	 rMnYAQ6FlTbVTxxVtkHlyAXT8L44jAIF/W4UhfniC3aOEhpTi/npheApYYbPHFm0+9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=piZm/dHxMb0yzmC7Q2q7IJ2K960t2NC95gKoWQpG9tc=;
	b=OKIkC3/LTbrPJhmUv9al1oxpmx9UtkfQYl70cd/ydT6G7dhQcBaUy/DhCRR89WNEFr4W
	 /U4/AAxoLtAEHjgIFiekgn4ZK32bE8qKwNs1CWNEyWYJOxlElVY4vxvmBV3LDrLgV1ZIJ
	 4sH8eKppDREZkExBThJcjd6WWUf1HiyVS/FHRdzXVGrXbEW2HSaMxyN2m77c1kWensgpX
	 ciczWEeELvFnIKFRGsoHoZbZLgcUUe6YZ06tD1c/jNB+Z4HCLyDFtIFGOKm3CSed59/bh
	 zgekBojmvfeI6DmDRRgnfiPfpp5e4i6zksrfMFBx58oDVRIPdZDvbbriy91xJB2DGeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VcD0bp9M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31175606A330;
	Thu, 19 Nov 2026 00:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VcD0bp9M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878871F000C4;
	Thu, 19 Nov 2026 00:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047959;
	bh=piZm/dHxMb0yzmC7Q2q7IJ2K960t2NC95gKoWQpG9tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VcD0bp9MnpBkz5dho09ALiH2XrCLl6+HyVao7yGAMAU3owkgOBd+f+Tf3MsxRRUH9
	 moiLFBxFGmLc+uPrFxR5/PQOBF/csT3wcQZm3weUMhi62HZa0RmK6MenhB9/IBF8Gm
	 yw1WtseqfKjFoelf1ShemBo0QCaz6AcTN5+ZrsmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abin Joseph <abin.joseph@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1825/2857] dmaengine: zynqmp_dma: Add support for AMD Versal Gen 2 DMA IP
Date: Wed, 18 Nov 2026 15:47:39 +0100
Message-ID: <20261118150306.974001439@linuxfoundation.org>
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
index 21472a5d76368..da97237726355 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -21,10 +21,10 @@
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
@@ -144,6 +144,9 @@
 #define tx_to_desc(tx)		container_of(tx, struct zynqmp_dma_desc_sw, \
 					     async_tx)
 
+/* IRQ Register offset for Versal Gen 2 */
+#define IRQ_REG_OFFSET			0x308
+
 /**
  * struct zynqmp_dma_desc_ll - Hw linked list descriptor
  * @addr: Buffer address
@@ -210,6 +213,7 @@ struct zynqmp_dma_desc_sw {
  * @bus_width: Bus width
  * @src_burst_len: Source burst length
  * @dst_burst_len: Dest burst length
+ * @irq_offset: Irq register offset
  */
 struct zynqmp_dma_chan {
 	struct zynqmp_dma_device *zdev;
@@ -234,6 +238,7 @@ struct zynqmp_dma_chan {
 	u32 bus_width;
 	u32 src_burst_len;
 	u32 dst_burst_len;
+	u32 irq_offset;
 };
 
 /**
@@ -252,6 +257,14 @@ struct zynqmp_dma_device {
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
 	struct zynqmp_dma_chan *chan;
 	struct resource *res;
 	struct device_node *node = pdev->dev.of_node;
+	const struct zynqmp_dma_config *match_data;
 	int err;
 
 	chan = devm_kzalloc(zdev->dev, sizeof(*chan), GFP_KERNEL);
@@ -920,6 +934,10 @@ static int zynqmp_dma_chan_probe(struct zynqmp_dma_device *zdev,
 		return -EINVAL;
 	}
 
+	match_data = of_device_get_match_data(&pdev->dev);
+	if (match_data)
+		chan->irq_offset = match_data->offset;
+
 	chan->is_dmacoherent =  of_property_read_bool(node, "dma-coherent");
 	zdev->chan = chan;
 	tasklet_setup(&chan->tasklet, zynqmp_dma_do_tasklet);
@@ -1160,6 +1178,7 @@ static int zynqmp_dma_remove(struct platform_device *pdev)
 }
 
 static const struct of_device_id zynqmp_dma_of_match[] = {
+	{ .compatible = "amd,versal2-dma-1.0", .data = &versal2_dma_config },
 	{ .compatible = "xlnx,zynqmp-dma-1.0", },
 	{}
 };
-- 
2.53.0



