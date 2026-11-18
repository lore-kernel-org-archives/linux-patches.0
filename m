Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060407;
	b=acpJeu2SB6R64ePXgSGbwEWAJ/eXp/eqKVqMUNP+OIqlhaxq0EcbWk3Y33dD8Qy9fyhl
	 t/Izju+K+P3CVjesR4H+o//kN7Xhe+ktcWHbiYdgVtRv5o5HX01x0LRKB7s1ME8dvT5sS
	 QnY//5iaPhh7nAeALjZGCXbm4mCaw9NHPzmO5Z21k9xfT7T8EByS5DYzc0yYhM6qPA5He
	 TefSm3T2NAFjsjk/xRLDshdbYUBGbPluFmGsEnMbUG1IEJl07BvFbmP/Ta7YNl3/KG8xo
	 maiNqingLn4rCl6G4AvPLeRTDCUgorNm8ravGaoDwQqY8Zqaoa1iqXXtGVsE/tQFurw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UOjI2l+yia4oi1FQ2a4zhXolhjP5ANaZhYUvYGhgPW0=;
	b=wJRyfRT6tig4TikvR9/udno/5V9i186apF6W9bNsZslEHkmfnPtB6EMa8apYiWHwr6BO
	 SMZQ5LJscbBm6cgxO0P2e72XV4NGvJN4Ob3tGjKKCYFHFk1ixQf1oq9T9d0nLBSCRg0mU
	 /spGnM4ScKha3i6mudmpwAATBYaqfX3wSVN2JUHoQJ01shILo7r+hJVO4S1/QdI4vDeKk
	 JlMbfY05mjR/rxaVy9ryutBMz2HuDYkhZw021shyRX4G44ZLQkN7YonMXd4NqQadoXqXz
	 6JQiN6Ydpru5kWBvVPDBTWYYEKlMCR5a4Yj3svOe2L+R9LnUTdFwyF7tgbtTzlzDySg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ATvdjMTa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC7D606A326;
	Thu, 19 Nov 2026 03:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ATvdjMTa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D589A1F000C4;
	Thu, 19 Nov 2026 03:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060407;
	bh=UOjI2l+yia4oi1FQ2a4zhXolhjP5ANaZhYUvYGhgPW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ATvdjMTa0HQ03ga2L4+b3TXxIup/GebN55KOE6fb0hiC3nQ9NrleUewcnmq/ZQKyX
	 RPxI+YwftgLeg4FAZPAHjpJSoYFe+Harpk53vUP2/eKwagSgFLfh8DcIoGLn3IRiSq
	 5Dq+Tgf278G1Pgg0Jh6DrLlnbXB0W0m56c4vzI5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abin Joseph <abin.joseph@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1187/1848] dmaengine: zynqmp_dma: Add support for AMD Versal Gen 2 DMA IP
Date: Wed, 18 Nov 2026 15:53:45 +0100
Message-ID: <20261118150009.211708160@linuxfoundation.org>
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
index 27b19e84124ec..504dc00415c30 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -24,10 +24,10 @@
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
@@ -147,6 +147,9 @@
 #define tx_to_desc(tx)		container_of(tx, struct zynqmp_dma_desc_sw, \
 					     async_tx)
 
+/* IRQ Register offset for Versal Gen 2 */
+#define IRQ_REG_OFFSET			0x308
+
 /**
  * struct zynqmp_dma_desc_ll - Hw linked list descriptor
  * @addr: Buffer address
@@ -213,6 +216,7 @@ struct zynqmp_dma_desc_sw {
  * @bus_width: Bus width
  * @src_burst_len: Source burst length
  * @dst_burst_len: Dest burst length
+ * @irq_offset: Irq register offset
  */
 struct zynqmp_dma_chan {
 	struct zynqmp_dma_device *zdev;
@@ -237,6 +241,7 @@ struct zynqmp_dma_chan {
 	u32 bus_width;
 	u32 src_burst_len;
 	u32 dst_burst_len;
+	u32 irq_offset;
 };
 
 /**
@@ -255,6 +260,14 @@ struct zynqmp_dma_device {
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
@@ -879,6 +892,7 @@ static int zynqmp_dma_chan_probe(struct zynqmp_dma_device *zdev,
 	struct zynqmp_dma_chan *chan;
 	struct resource *res;
 	struct device_node *node = pdev->dev.of_node;
+	const struct zynqmp_dma_config *match_data;
 	int err;
 
 	chan = devm_kzalloc(zdev->dev, sizeof(*chan), GFP_KERNEL);
@@ -907,6 +921,10 @@ static int zynqmp_dma_chan_probe(struct zynqmp_dma_device *zdev,
 		return -EINVAL;
 	}
 
+	match_data = of_device_get_match_data(&pdev->dev);
+	if (match_data)
+		chan->irq_offset = match_data->offset;
+
 	chan->is_dmacoherent =  of_property_read_bool(node, "dma-coherent");
 	zdev->chan = chan;
 	tasklet_setup(&chan->tasklet, zynqmp_dma_do_tasklet);
@@ -1140,6 +1158,7 @@ static int zynqmp_dma_remove(struct platform_device *pdev)
 }
 
 static const struct of_device_id zynqmp_dma_of_match[] = {
+	{ .compatible = "amd,versal2-dma-1.0", .data = &versal2_dma_config },
 	{ .compatible = "xlnx,zynqmp-dma-1.0", },
 	{}
 };
-- 
2.53.0



