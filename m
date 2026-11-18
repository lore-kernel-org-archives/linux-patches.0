Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030952;
	b=M0XYctFscAlJr2Burat+MYGFUGEXq+xdS4eqdCn1Qcd020B8a4mETaqJhHde07W+i9ze
	 zun8j+LmKhPyyVS2SxeHXzrG40OtzeNDMWefOAlwh+l4BJ/FtaazH7eXCV2Z88d4ova6x
	 onm5QjjRPXadRNAPZ+vYsHniXV+WodqARmHAVGgmGJzq8fXEQQhDIaLAuELqeb1x16xRW
	 1ZiROQ7rt4AubY0jK5cO7JaS8No4zvSswNWFrHjcp91rFAefJmazMbAcMGTGx5RbwYeqw
	 wXgcuC57Vr6h3Xlc0VTXVBZLLD0lF3pT0xIQ2+mo79syf1yejb+xJXWjFUNKeYx+29w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mVtCVh47i2MyMKVyABv0k+SMVT69kMllzsUbZI0wTlU=;
	b=yuh+WQ22jPaIMPNelQUmw8nklZuiCCHDcBqWWvkS+omam64r0S3rtap3OpGKkkqkmHvc
	 aprLi8msRXd6laLt2LZksxbZ1lMsn0e6psb5MW/BYs2hi1ucYEFPr6f/NUp4mLu2hPQpx
	 A8PIiriCYKM/I8Qeqh7YtVoF8r1L4VmFORmU/+wisok10d5PDQhxIT9Du57cGEX8jtsi8
	 PofvtGvPMCXc0ZQqGVPg8mqGatQAutJiRm35KmkeyLvG2WAh2yGeXoovKWPHudMsEEv24
	 TXgZFQxEvBj4bShF7KbywGRTW4RLKgxPR5fT7UK4p5Qc5+NCwDdB56LLcw3Xa2IPAIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XkzFB/jf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D178F606A325;
	Wed, 18 Nov 2026 19:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XkzFB/jf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C63F1F000C4;
	Wed, 18 Nov 2026 19:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030952;
	bh=mVtCVh47i2MyMKVyABv0k+SMVT69kMllzsUbZI0wTlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XkzFB/jfPI4uI9tEoEijc4T2P7gtpD5Vc8zX1EESgDrJQj2u2bWx+6GeL/hZypeVg
	 jozsZFoF7a7P7Dnjh9dPaCbsW/eFM1R6MnPdVgVc2ykLDer+arCZ8mhktenA9VLyJs
	 4WC61dMrcx38egrxOUQsAQiW3PaH2Q4MfU+vL5AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0887/1756] dmaengine: ste_dma40: Fix DMA registration unwind
Date: Wed, 18 Nov 2026 15:50:14 +0100
Message-ID: <20261118150045.035347747@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit f71ef686f913c8e9771a54466a76d653b83cd3dd ]

d40_dmaengine_init() registers DMAengine devices using devres-managed
unregister actions. If probe fails after one of those registrations, the
DMAengine devices stay visible until devres unwinds after d40_probe()
returns.

The channel tasklets are also initialized before each DMAengine device is
registered. An interrupt can therefore have queued a tasklet by the time a
later registration step fails, but unregistering the DMAengine devices
does not drain that tasklet before probe-owned storage is released.

Add tasklet cleanup actions to the DMAengine registration devres group.
Install each action before publishing its DMAengine device. If action
registration fails, those tasklets have never been exposed and cannot have
been scheduled, so use devm_add_action() without immediate reset cleanup.

On later failure, free the IRQ before releasing the group so no new
tasklets can be scheduled, then unregister the DMAengine devices and drain
their tasklets before freeing the remaining probe resources. Keep the
managed registrations and cleanup actions in place on successful probe by
removing only the temporary group markers.

Fixes: 42ae6f1695be ("dmaengine: ste_dma40: Remove platform data")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/dmaengine/20260819225215.5EA2F1F000E9@smtp.kernel.org/
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-11-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 45 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 1b833fa77fba9..c7c727411a275 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2876,6 +2876,18 @@ static void __init d40_chan_init(struct d40_base *base, struct dma_device *dma,
 	}
 }
 
+static void d40_kill_tasklets(void *data)
+{
+	struct dma_device *dma = data;
+	struct d40_chan *d40c;
+	struct dma_chan *chan;
+
+	list_for_each_entry(chan, &dma->channels, device_node) {
+		d40c = container_of(chan, struct d40_chan, chan);
+		tasklet_kill(&d40c->tasklet);
+	}
+}
+
 static void d40_ops_init(struct d40_base *base, struct dma_device *dev)
 {
 	if (dma_has_cap(DMA_SLAVE, dev->cap_mask)) {
@@ -2922,6 +2934,11 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 
 	d40_ops_init(base, &base->dma_slave);
 
+	err = devm_add_action(base->dev, d40_kill_tasklets,
+			      &base->dma_slave);
+	if (err)
+		goto exit;
+
 	err = dmaenginem_async_device_register(&base->dma_slave);
 
 	if (err) {
@@ -2937,6 +2954,11 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 
 	d40_ops_init(base, &base->dma_memcpy);
 
+	err = devm_add_action(base->dev, d40_kill_tasklets,
+			      &base->dma_memcpy);
+	if (err)
+		goto exit;
+
 	err = dmaenginem_async_device_register(&base->dma_memcpy);
 
 	if (err) {
@@ -2954,6 +2976,12 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	dma_cap_set(DMA_CYCLIC, base->dma_both.cap_mask);
 
 	d40_ops_init(base, &base->dma_both);
+
+	err = devm_add_action(base->dev, d40_kill_tasklets,
+			      &base->dma_both);
+	if (err)
+		goto exit;
+
 	err = dmaenginem_async_device_register(&base->dma_both);
 
 	if (err) {
@@ -3549,6 +3577,7 @@ static int __init d40_probe(struct platform_device *pdev)
 	struct d40_base *base;
 	struct resource *res;
 	struct resource res_lcpa;
+	void *dmaenginem_reg_group;
 	int num_reserved_chans;
 	u32 val;
 	int ret;
@@ -3679,20 +3708,32 @@ static int __init d40_probe(struct platform_device *pdev)
 		d40_err(dev, "No IRQ defined\n");
 		goto destroy_cache;
 	}
+
+	dmaenginem_reg_group = devres_open_group(dev, NULL, GFP_KERNEL);
+	if (!dmaenginem_reg_group) {
+		ret = -ENOMEM;
+		goto release_irq;
+	}
+
 	ret = d40_dmaengine_init(base, num_reserved_chans);
 	if (ret)
-		goto release_irq;
+		goto release_dmaenginem;
 
 	ret = of_dma_controller_register(np, d40_xlate, NULL);
 	if (ret) {
 		dev_err(dev,
 			"could not register of_dma_controller\n");
-		goto release_irq;
+		goto release_dmaenginem;
 	}
+	devres_remove_group(dev, dmaenginem_reg_group);
 
 	dev_info(base->dev, "initialized\n");
 	return 0;
 
+ release_dmaenginem:
+	free_irq(base->irq, base);
+	devres_release_group(dev, dmaenginem_reg_group);
+	goto destroy_cache;
  release_irq:
 	free_irq(base->irq, base);
  destroy_cache:
-- 
2.53.0



