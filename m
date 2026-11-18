Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031068;
	b=QabgDwjhuQPnV6H4Xj7M9s2bjTY6ho3NPXPEk3wyajW3/EPcNtgjCL6LEt9xspMqHJiU
	 gqw+fQGBYpOBJYG9ZtNbOkeAL5Dyy1qH1HPKOgnP7kz3B1xMIyvMTOsmkHQvgV/qDqHAa
	 IHIE9Hx1xw8NYzs7Kb6GWqa5OyuVH9kn6Klics2HP13mck6646g8gurOwPs05NPJdUdVN
	 pNnPH1XUBjRPROzSM+etG4bChgOEIWksOWtdUSlkTDC+6hiQmlqu+lHiNt/eG+tS64M6Q
	 r7bblQETNrBBVn+KPzhDgb65JYEbxh1qhvVn1J8X/pBlE0caOUeLv40pSrmKGZwCQ8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2uAHtO+B7CS5xW94kfc4FI453XN1JExPHHmpfpn9D+s=;
	b=Z97/vlIKtR1gldJ1bUp55PBSYmfyrtdaWFQe2YH3DG9HCSey2FOnt0qfSaGgo702dHUA
	 4xvknfpO+53rs54RTP5VqqjVrMjsJ7fDCDWsup6Um5ul5TZHJD/nuC/h23m3KIYvgMeJC
	 iNSgTtQUa+ACKdlg6OW0ppzvL48o/ZBNpf281Zv7yha5XCM1RCO0ZC1sSMvy356yprwez
	 KPZwBWc5cLJcQ0fazvJsSgEsLxi6ahPIsXqwDj7yDbsf6C+hwBOtBpZSrVjBJOg9/Iba6
	 RO5TQA9jqR1Sqz/2LXdhH7koOxN5hprRNOmFQbPZPjL0obFrJmZp032ebu3TJUntRig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tbTiOf72;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39588606A31C;
	Wed, 18 Nov 2026 19:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tbTiOf72
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0E81F000C4;
	Wed, 18 Nov 2026 19:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031068;
	bh=2uAHtO+B7CS5xW94kfc4FI453XN1JExPHHmpfpn9D+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tbTiOf72wmNG2NEhLRmRTGakK5pLJbWodB+embsUL2k1gHZDoGcyTdSuacvNBvOKj
	 M3MAy8jKU7LLbme27PCw0AX4JEZ2N1VVlvRdc+Vx3RzhElggaAY+ZT77oIEzPUo83n
	 yQydpfNsL2MjQlqOgOfo0d/gkRT5vDrX/2wmAwSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0885/1756] dmaengine: ste_dma40: Init hardware before registration
Date: Wed, 18 Nov 2026 15:50:12 +0100
Message-ID: <20261118150044.825351185@linuxfoundation.org>
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



