Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025551;
	b=5SG/lyZDNBI6EUhcNAlcHssfBweo6FcQa21iqee4IQI+6Df6g2ew6ncZuO2CsKF5T/9f
	 lzsJBPkyNDmE20zuOJj/xRW2eopQoEe8LmuHCv6r3JnAfTLbmMv0APkOQmN0f7HolH5sY
	 tuQI1XglZpauMQan1FKYFIEMWBAcX7zXrd7Z4nXcd9VqLS65lyIYSM/IfZaZj4pKbdAlB
	 3/Sj8MzmxRKkeLt01O9WXQnSWELOkyit7pxbClRNCvl9ZQTdedHv369Zs0ML2bor/4vET
	 cc86ddOhJYe/HtbSxrHFKDV0N09NJdacgejOkw2FyEXxoL8njnAKtSlGyV3Xt01QEeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025551;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vK5oi/a1kEPv1laRq4JStqnFcQiDKsiQKU/nZ/Mhq1E=;
	b=HPxy9zt6SF1FyQhbgcdWDD+RYf+WH+lo3Xp51jC/bhG5rI+o+pwHvg50YBAEotokKb/h
	 NCuib49sM7QQDzvXhDrsxRqlLyNBewERXqLgAixMOhBdTdKqTGLYKhalVB35Bmp+e5cES
	 sUgGMOLEffKnBfc6ft2Gj0icdCrqowarYLmbGZZ8zXmrRPscNjRG+eIkuZjdp68EFx9uW
	 Lnc+McrUFzWCkSxfJ/TSn+Jj9D9sr6x49w+INKzfNFQ/TJMtGTd/ygEAuVq9GiiWmCpN9
	 6veOK9Fo5mM/YsF/2gZUL87hKXp2NdkuzllbRjT80dAXZ4TgXN6vRd5hAZk2+4Oy7EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AqaLWv0y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B72606A31C;
	Wed, 18 Nov 2026 18:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AqaLWv0y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDE71F000C4;
	Wed, 18 Nov 2026 18:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025550;
	bh=vK5oi/a1kEPv1laRq4JStqnFcQiDKsiQKU/nZ/Mhq1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AqaLWv0ycH57k3alvVcTrSfBy2Ja92IRKs3QlS0njcOM6MYJGlc7MUsFVnlIUH1Lg
	 tyCCBNYQD2/1e7p/d5B4GbS0CUs+/n6qjLXbppEfde0RCd0Tcs+HFMZs5uNkOFPkFt
	 39cpTmvixGnBYxrFBSqPrlIHS9YBnisLf6XA/H/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1120/2151] dmaengine: ste_dma40: Init hardware before registration
Date: Wed, 18 Nov 2026 15:47:35 +0100
Message-ID: <20261118150203.013504699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit ffd583a734dc4bdafb9e18d9aa48b6efafd1a628 ]

d40_probe() enables the interrupt handler and registers DMAengine devices
before calling d40_hw_init(). An interrupt pending from the bootloader can
therefore reach the handler while the hardware interrupt state is not
initialized and channel lookup entries are empty. The handler deliberately
does not acknowledge an interrupt for an unknown channel, so a level IRQ
can retrigger continuously.

Initialize the hardware and set the DMA segment limit before requesting
the IRQ or registering DMAengine devices. d40_hw_init() clears pending
logical and physical interrupt status, so request_irq() can enable the
line normally after the hardware state is initialized.

This ensures that the handler and clients only observe initialized
hardware.

Fixes: 8d318a50b3d7 ("DMAENGINE: Support for ST-Ericssons DMA40 block v3")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/dmaengine/20260819225215.5EA2F1F000E9@smtp.kernel.org/
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-9-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 4e5907f6840fd..c88de0dc7c6eb 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3670,20 +3670,19 @@ static int __init d40_probe(struct platform_device *pdev)
 	}
 	pm_runtime_use_autosuspend(base->dev);
 
+	dma_set_max_seg_size(base->dev, STEDMA40_MAX_SEG_SIZE);
+
+	d40_hw_init(base);
+
 	ret = request_irq(base->irq, d40_handle_interrupt, 0, D40_NAME, base);
 	if (ret) {
 		d40_err(dev, "No IRQ defined\n");
 		goto destroy_cache;
 	}
-
 	ret = d40_dmaengine_init(base, num_reserved_chans);
 	if (ret)
 		goto destroy_cache;
 
-	dma_set_max_seg_size(base->dev, STEDMA40_MAX_SEG_SIZE);
-
-	d40_hw_init(base);
-
 	ret = of_dma_controller_register(np, d40_xlate, NULL);
 	if (ret) {
 		dev_err(dev,
-- 
2.53.0



