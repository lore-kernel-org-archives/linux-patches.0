Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030950;
	b=qobRqf6atuKgKtBedUi79jLtq25dlu8dxWo2D/oq79PMsT1NKL6azd8NEbgkoiI/ZzNj
	 ANp4mkpNKvj2RtssCcycfRKrE2vxVz3CRKUQ0ybsxLeXhUXoctn4ZmjZG6G3JKR4nA6G3
	 UGh19T9auX+mbw3sUr7birWnG5zhg1/GR19YAwdgR1jqIVKfFuysHt96rmSizaFvspZR1
	 Y08CIw9hNdxh3ylwI2nx0fdiXpY6PP0s31W9jcHPEf3gw63TA2zmRw/ifZBrzSt44owFZ
	 zUTYL3H5weolzu3Pl3Kn4yzzkaOBBeW2r7TlXLjJlYI06y/6JPY1yozPBmFIRDcIxTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nJhJEAlA5pdoNLgDfs7o/fHXjCQzhduRKM5yK8IvHdU=;
	b=5akKw4MUD5UTzwjeu1+pN20QPsrZS2A3yZUlUbSblEV5DiKpGzmX6D8J8zncfJlwylN9
	 /pAWu5jDkxnl5HNoelVbfCTZ0pjonLrkN2cqLbXr9rvStiYFq5LpOj613WKir8RNuXsYB
	 nyGTswQeZlSDslME5HsDSbhk/hBWVoD/702SjUaDUUgzTxQy7Y6cxZh/IFywWf05xg5Ap
	 DSP3FcvRsk5Q9yNnoX7fXcKiPuoEM5iV0FX6NJki7zLmsq89uCI2N8rAmDxZ2toOX2/Ss
	 fUhAJz0soKxRWjMpMc5zN4gMNtwfMasF7owW02yNIaE5/nZAwHIKNcnHVk4TY0RTZQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pR6Dg73M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50164606A325;
	Wed, 18 Nov 2026 19:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pR6Dg73M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5847C1F000C4;
	Wed, 18 Nov 2026 19:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030949;
	bh=nJhJEAlA5pdoNLgDfs7o/fHXjCQzhduRKM5yK8IvHdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pR6Dg73M4/i23W7wgYXO7mTum1iXCI2gcbcG1wk/x6vO63wPURy7imaFK67E9r+hB
	 s7l04Ok0cMUCDBDdkb5WhkSnIm7W843Zrm9xbyacs9gyyyjr4MQpQ1uWNfGHn3CK4b
	 VOizZlAi0BbE8wcDwz5XRhAY1aAD5whQEyPx3iXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0886/1756] dmaengine: ste_dma40: Fix probe IRQ leak
Date: Wed, 18 Nov 2026 15:50:13 +0100
Message-ID: <20261118150044.983745120@linuxfoundation.org>
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

[ Upstream commit 7ca608cf6b842685bbbe131d4f7d638f7cdc2b5d ]

d40_probe() registers the hardware interrupt before several later probe
steps that can fail. Those error paths jump to destroy_cache without
freeing the IRQ, leaving the handler registered after probe resources have
been released.

Route failures after a successful IRQ request through a dedicated cleanup
label. Keep the request before DMAengine registration because that
registration publishes channels to clients.

Fixes: 8d318a50b3d7 ("DMAENGINE: Support for ST-Ericssons DMA40 block v3")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/dmaengine/20260618051539.15E201F000E9@smtp.kernel.org/
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-10-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index c88de0dc7c6eb..1b833fa77fba9 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3681,18 +3681,20 @@ static int __init d40_probe(struct platform_device *pdev)
 	}
 	ret = d40_dmaengine_init(base, num_reserved_chans);
 	if (ret)
-		goto destroy_cache;
+		goto release_irq;
 
 	ret = of_dma_controller_register(np, d40_xlate, NULL);
 	if (ret) {
 		dev_err(dev,
 			"could not register of_dma_controller\n");
-		goto destroy_cache;
+		goto release_irq;
 	}
 
 	dev_info(base->dev, "initialized\n");
 	return 0;
 
+ release_irq:
+	free_irq(base->irq, base);
  destroy_cache:
 	if (base->lcla_pool.dma_addr)
 		dma_unmap_single(base->dev, base->lcla_pool.dma_addr,
-- 
2.53.0



