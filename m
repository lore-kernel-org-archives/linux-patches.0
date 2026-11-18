Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061418;
	b=0LgtdmtZ6FcOrc9v8/I/vMfxKafJVF1J9tTJAj6GGF/ilb7SHc+pJ3Dg8H7peWGUSg8G
	 s2yo/bZPtG6rx9Fpz8Y3B04Sd0ad2pkZk+OCfcyBCLGH9FlAhhFeHkCtplEz40ryxXoDi
	 VyVK/2Yx/VflNbfyFulLMR8XnQqUu03F8jAxVHDWQ0PEmu8eHWxw+pgFJ3PYziLeKC/C9
	 YcRiIZp/rpziPQCqJW4YFPxti+nLWrVATNF3NfcRhIUpn+spe7m+1CFFGS2sHALM6n56f
	 Ih6tVclBsAl6wihZF08TcOjrjmoJ/MDCiTS3CXbfhSo/g/arE3Vz0WGJ8MV0KJVMa1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JJ+0HoQS6rjCaj85hIiggBDj+t7fxepuLObIBLtJ9O8=;
	b=hA19sbXsZ8l2C2tCjvbt3WLDhrvM/72Z6tNz6qLByUzrXlIcTGFY3qyZuaQToQQQvg/U
	 IYe/T0XyHBBsmQytcd1Ry46p+B7Wlj5KoSCJNWj7ha1rKPIm8fcKJyXcL4qGuO6+LWCPl
	 nsg1Xe3DcYItv19w4zv9HA884RD+rb34XaJ2/vI2GvxKiZn0hpdgkbSWN+9n2gm8rWcW4
	 kO3r8YCURN4Vd/3bt5TCO07lnE6SkbGRxnXB8oxIv08uE4P3wQ2pgiyVLMtwUsTfE/ICe
	 ep8cBLz3b0eJSGIXE6YtBJ9GCiMQkka5m9IW3azxDtipXmTXOAmG6IuNdTRSBFVtPlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uUuDJjFL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C07606A326;
	Thu, 19 Nov 2026 04:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uUuDJjFL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67E41F000C5;
	Thu, 19 Nov 2026 04:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061418;
	bh=JJ+0HoQS6rjCaj85hIiggBDj+t7fxepuLObIBLtJ9O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uUuDJjFLWvxeL8iXwwMk0updKM6mYrlJDbxNwBWdNHx5rZiDX5+jez5V89MPdHGYf
	 4g3+RE78ZpVMCg4nNoUi/xHIxHNS3yy1ELLcPWR6VjHB6TH8vQgeiqxckTTPq0A7l0
	 zGQeg/HGfEZ/6yq6JXeBabMgULO35FEV9Wl1PTf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1544/1848] crypto: talitos - init tasklets before requesting IRQs
Date: Wed, 18 Nov 2026 15:59:42 +0100
Message-ID: <20261118150024.216868780@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 666d66df25253070cb297cb920b0bcfcfe5eb871 ]

The talitos interrupt handlers schedule priv->done_task[] via
tasklet_schedule(). Since the second IRQ support, probe has requested
the IRQs before calling tasklet_init(), so an interrupt already pending
when a line is requested, e.g. engine state left by the bootloader or
a kexec'd kernel, would schedule a tasklet with a NULL callback.

Look up the IRQ numbers and map the registers up front, so that
-EPROBE_DEFER returns before anything is allocated and the done_task[]
selection and reset_device() can see the secondary IRQ. Only request
the IRQs once the channel fifos are allocated and init_device() has
reset the engine. This matches remove(), which frees the IRQs before
killing the tasklets.

remove() frees every IRQ number that is > 0, so make sure that only
requested lines are set when it runs from the probe error path: clear
both numbers when probe fails before the request, and clear any line
talitos_probe_irq() did not request. Previously a failed primary
request in the two-IRQ case freed the never-requested secondary line.

Fixes: c3e337f88a5b ("crypto: talitos - support for channel remap and 2nd IRQ")
Assisted-by: LLM
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/talitos.c | 54 ++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 7b2dc027cb9ad..2557e5f9c43e3 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3287,21 +3287,13 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 	int err;
 	bool is_sec1 = has_ftr_sec1(priv);
 
-	priv->irq[0] = platform_get_irq(ofdev, 0);
-	if (priv->irq[0] < 0)
-		return priv->irq[0];
-
 	if (is_sec1) {
 		err = request_irq(priv->irq[0], talitos1_interrupt_4ch, 0,
 				  dev_driver_string(dev), dev);
 		goto primary_out;
 	}
 
-	priv->irq[1] = platform_get_irq_optional(ofdev, 1);
-	if (priv->irq[1] == -EPROBE_DEFER)
-		return priv->irq[1];
-
-	/* get the primary irq line */
+	/* single (or primary) irq line */
 	if (priv->irq[1] < 0) {
 		err = request_irq(priv->irq[0], talitos2_interrupt_4ch, 0,
 				  dev_driver_string(dev), dev);
@@ -3313,7 +3305,7 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 	if (err)
 		goto primary_out;
 
-	/* get the secondary irq line */
+	/* secondary irq line */
 	err = request_irq(priv->irq[1], talitos2_interrupt_ch1_3, 0,
 			  dev_driver_string(dev), dev);
 	if (err) {
@@ -3326,7 +3318,9 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 primary_out:
 	if (err) {
 		dev_err(dev, "failed to request primary irq\n");
+		/* neither line is requested, keep remove() from freeing them */
 		priv->irq[0] = 0;
+		priv->irq[1] = 0;
 	}
 
 	return err;
@@ -3338,12 +3332,27 @@ static int talitos_probe(struct platform_device *ofdev)
 	struct device_node *np = ofdev->dev.of_node;
 	struct talitos_private *priv;
 	unsigned int num_channels;
+	void __iomem *reg;
 	int i, err;
 	int stride;
+	int irq0;
+	int irq1;
 
 	if (of_property_read_u32(np, "fsl,num-channels", &num_channels))
 		return -EINVAL;
 
+	irq0 = platform_get_irq(ofdev, 0);
+	if (irq0 < 0)
+		return irq0;
+
+	irq1 = platform_get_irq_optional(ofdev, 1);
+	if (irq1 == -EPROBE_DEFER)
+		return irq1;
+
+	reg = devm_platform_ioremap_resource(ofdev, 0);
+	if (IS_ERR(reg))
+		return PTR_ERR(reg);
+
 	priv = devm_kzalloc(dev, struct_size(priv, chan, num_channels), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
@@ -3358,12 +3367,7 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	spin_lock_init(&priv->reg_lock);
 
-	priv->reg = devm_platform_ioremap_resource(ofdev, 0);
-	if (IS_ERR(priv->reg)) {
-		dev_err(dev, "failed to of_iomap\n");
-		err = PTR_ERR(priv->reg);
-		goto err_out;
-	}
+	priv->reg = reg;
 
 	/* get SEC version capabilities from device tree */
 	of_property_read_u32(np, "fsl,channel-fifo-len", &priv->chfifo_len);
@@ -3414,9 +3418,7 @@ static int talitos_probe(struct platform_device *ofdev)
 		stride = TALITOS2_CH_STRIDE;
 	}
 
-	err = talitos_probe_irq(ofdev);
-	if (err)
-		goto err_out;
+	priv->irq[0] = irq0;
 
 	if (has_ftr_sec1(priv)) {
 		if (priv->num_channels == 1)
@@ -3426,6 +3428,7 @@ static int talitos_probe(struct platform_device *ofdev)
 			tasklet_init(&priv->done_task[0], talitos1_done_4ch,
 				     (unsigned long)dev);
 	} else {
+		priv->irq[1] = irq1;
 		if (priv->irq[1] > 0) {
 			tasklet_init(&priv->done_task[0], talitos2_done_ch0_2,
 				     (unsigned long)dev);
@@ -3457,7 +3460,7 @@ static int talitos_probe(struct platform_device *ofdev)
 		if (!priv->chan[i].fifo) {
 			dev_err(dev, "failed to allocate request fifo %d\n", i);
 			err = -ENOMEM;
-			goto err_out;
+			goto err_noirq;
 		}
 
 		atomic_set(&priv->chan[i].submit_count,
@@ -3470,9 +3473,14 @@ static int talitos_probe(struct platform_device *ofdev)
 	err = init_device(dev);
 	if (err) {
 		dev_err(dev, "failed to initialize device\n");
-		goto err_out;
+		goto err_noirq;
 	}
 
+	/* enable interrupts once the channel fifos and tasklets are set up */
+	err = talitos_probe_irq(ofdev);
+	if (err)
+		goto err_out;
+
 	/* register the RNG, if available */
 	if (hw_supports(dev, DESC_HDR_SEL0_RNG)) {
 		err = talitos_register_rng(dev);
@@ -3530,6 +3538,10 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	return 0;
 
+err_noirq:
+	/* the irq numbers are known, but the lines are not requested yet */
+	priv->irq[0] = 0;
+	priv->irq[1] = 0;
 err_out:
 	talitos_remove(ofdev);
 
-- 
2.53.0



