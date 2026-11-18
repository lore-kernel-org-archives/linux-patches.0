Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039471;
	b=2gPlv8chqF+e0IUec7rr5DxzVHboYWqQp5Rnmc5boaZKI0YdCnc7pKMDgafiKUOQIgrL
	 ++779okpcNlWFJX+7NZqRd+zELVl6D8UVjAuVJxfg2tRYtUtVf5EbC2uqwmtqYyOdkAxV
	 IaDLQ9UiXT7z+42y7o7J/IIM9KnUfZRExY1OXy73yZSvpWMvCbf0ozJZH5s30bXA4PUnf
	 2kKx+8i3taLIb8zSjM4CanIEtXaiisgmbLyX1Y8AwuE0/RZfeKNQvuzBl0Ghak4gy1aVv
	 gXhzgatOKxKd6JjxS9ghw5GWBNqVZFmqb25igtl7talcRa78FQ1wNJITIU3HDyW/ifQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039471;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RcoXEdDc+tXbQsqnKIRSDWfMMiVEYHesEVc0GWdrHr8=;
	b=nDXp2o8yGk1EEI/cbb7CAcg+bBsrkNWrobnnMDi7PnfHvJZmjPgh5oDdo4n4i5eefkcZ
	 2nFu4P0ZXSTGTKDpoAXaR4Rcy4yZevX0Ps5JER4pQ3XnGhJGIOOSk5Or56rtYzyvemnqF
	 zWrQVu4PW8/3+swjU3u11Jv/wxH0m9wq035r04xciX5L+j8AaY+3KAN7TDaQYTfzc2wwt
	 TqRCrAjhnNh1YbWBDIlJNvMJRnkbygHWdIvaqP6M7o2y03hqed/OjOJBzmkW9wR7GQxZA
	 gHN4oN/vyeH4ku9EI8t3SAG6raeWk8bcZE9u+EsYG75LWNJwp+dOh347f1eCxIoCs8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YxLxDXbS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA47606A320;
	Wed, 18 Nov 2026 22:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YxLxDXbS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB8B1F000C4;
	Wed, 18 Nov 2026 22:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039470;
	bh=RcoXEdDc+tXbQsqnKIRSDWfMMiVEYHesEVc0GWdrHr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YxLxDXbSQqNm1yvodNa8iltlexutfMDc86P3Gu48A9akVCeQOXfBU0TD2mfNb6et/
	 5srBS67fpOLFnbkkeKGMPSi8EP2ijvUiy2dNNA//ntAAUWA54TotKCj779HtBbmyR+
	 tLLyCNCdNrcAI/Eb8d8hNply+C2Mz7x/J9S6fww8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Golla Nagendra <nagendra.golla@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2095/3318] dmaengine: zynqmp_dma: Fix chan probe/remove error handling
Date: Wed, 18 Nov 2026 15:45:17 +0100
Message-ID: <20261118150424.940133836@linuxfoundation.org>
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
index e8068cf62613b..7d4aa37bc38bb 100644
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



