Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061269;
	b=Zqxg3NvFHepZdKRbBn5GF347QR7OtTvmt/1R3B6uXaj+CsDdU+GWT5evcAZiCzOE/v5y
	 X8bcoPLZ0/rlXQ/pJADwjuSX+LfHv8QmYlSYdSUyL9oMSGlkOff56Cpi9hnmBApUWugbn
	 YlxO8DCRyq2hw6sof/kc8+/PeRElKbojDem4SPd+QrRes23vF7AEBl6vajtboJ4Pw10AT
	 +zT8POInwqHS1bdt6dnbe6Sq/rz2ISicvQ/gkG0uMK9yctihn/PY3X8A3xZau9avyZOd3
	 sxTVMyaxpCc4azlvAJnM+yazAMbV6nJWqWYnBRb1Q4QbCNzXg5KxqAErR5tHSAwGymg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GgmMN8KtlLTItfn1gx0DsJz7BSL2pFqS+wPdwelvV+0=;
	b=M/gYnVX8gp1Oqn+ly9IiyJsqorxHCY7B8tgl2Il0XHj6iZ6HhuaKNeyXm+rQmUFs6XNY
	 oaORpSE3NXhEyDP5WsDsZOqDd/AcyZf0ItS8Q8zW/3vDu9sp6koY/kUaWQNPRJ6rINPuw
	 nWzJ9AepQe1VeuxH2pyhaNvPgFux29B771TDdAnsYDLTPhACmwWql8GdaInGKQK4Up5y9
	 7J1I36VggkB6PxG2f7b8/K8bAnW7Pt6klYi7iV3L1jZuMklUlBCFHh805Y1CvMtDUrfle
	 FkDdfrTB7DKbTtwH4iFPGhE6LlB1KWd+3cJ9BXtiIeAjeLkLn+PokmGq4Z9gXzRHPkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a5NQEFDv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC8E606A337;
	Thu, 19 Nov 2026 04:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a5NQEFDv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB19D1F000C5;
	Thu, 19 Nov 2026 04:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061269;
	bh=GgmMN8KtlLTItfn1gx0DsJz7BSL2pFqS+wPdwelvV+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a5NQEFDvIowIhiVldZ13HEetYYhX8eBt8xsQxcFTlAYlTxnWBY6UV0WylJ1UckIfs
	 jOMgRKkV/WKeQCX3HbqGkJrzZSf+xmLY9udNjcfNDMJHvll9z/OJn3KEAVQbZlhn3y
	 Gn2tEps/5Fnl+7lMFfwOQxRIa+ordPa3aFKV5X1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1491/1848] dmaengine: ste_dma40: Fix probe IRQ leak
Date: Wed, 18 Nov 2026 15:58:49 +0100
Message-ID: <20261118150021.652564252@linuxfoundation.org>
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
index b49749dc22df3..9408aeb72eeda 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3680,7 +3680,7 @@ static int __init d40_probe(struct platform_device *pdev)
 
 	ret = d40_dmaengine_init(base, num_reserved_chans);
 	if (ret)
-		goto destroy_cache;
+		goto release_irq;
 
 	ret = dma_set_max_seg_size(base->dev, STEDMA40_MAX_SEG_SIZE);
 	if (ret) {
@@ -3694,12 +3694,14 @@ static int __init d40_probe(struct platform_device *pdev)
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



