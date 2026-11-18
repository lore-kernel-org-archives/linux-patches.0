Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049174;
	b=FAAepk+FgECpJ4aAVhD6x48ydYY5yutZ/aplmphlMRDnBdJQg7cQS6ZDH0CSepotA1Wf
	 EzwMlMkp6OoNtDCa7kMfvHUNYbpaQxqfjRUjpNWVDyi+ashxpTEl7sWdxLfipB6gUqJ1v
	 MO5Dz8ocacJZQabJYTiP91AnJ6WfDSs8bCDvsUYqShW1pNJh5M/K2qaOA6BRCGswhl0L1
	 twhaV9mW3YG4NhuKF3EgPDpRLPuPv6+L2dl3gca2+JGZeTh35ZZIT/kuQfl+lnJA0IcxH
	 +qNn63CH1tOVEEsuHhKd1B8GeYiLXOpnLqgIfAKaDO6mO22FZ76zT/g8qVt4h+IC/vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OsdnuMK5MjdqE9SAMfAL3LQI6iO0O9SbrmPOU6mghbw=;
	b=0ZMDssKZia6GsnjIlSRzNCm2uyGJxVzikm//Y834+q0wAtwEcEr0epj3O/0K/zLBW5yM
	 sTV4Qm+fc8hw2n5JCCTui38iBR5OLEQRfvYUFQqtIggLJBRxr3uaCLgLWhpK6KdW+hncX
	 Et6zVpxRqm9SoJ2mCWELjtln+3pBgYsJgRCWwCR99Bzmj2zUkggNsUL1KCE0AlZmHlTki
	 ysLsQvw9sev/x7z8DV+i9D0E9yqNE4jnpgKFvvIkmPEizMypmCSqXqPvrF17r04hmOkq3
	 IU2MRA5Knwvjg7hkEtukDu8bwwFTvuTqgp9KRl3I423RYtJANT0I8qar+Rnk8YcQOsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XTJwFneh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AC8606A32C;
	Thu, 19 Nov 2026 00:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XTJwFneh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98151F000C4;
	Thu, 19 Nov 2026 00:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049174;
	bh=OsdnuMK5MjdqE9SAMfAL3LQI6iO0O9SbrmPOU6mghbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XTJwFnehvFnrVaBf0bHWNG03ZgLqLAHg2ToUhvlDqPKBxgYFRlDSbSUiXM/xHkI7I
	 MWMCuVxYak0x3Kx1uJRkNyI44Uak5KRRIw1RFNAogm3T2CSQXH0JW63ypEi9XvCgol
	 Lcbqa5RXVE3HzQbAXdFesgK+tN+BaVP1GBcmYFqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2257/2857] dmaengine: ste_dma40: Fix probe IRQ leak
Date: Wed, 18 Nov 2026 15:54:51 +0100
Message-ID: <20261118150322.712985822@linuxfoundation.org>
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
index 7dfbdcff8684a..95fa80ef59ac6 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3679,7 +3679,7 @@ static int __init d40_probe(struct platform_device *pdev)
 
 	ret = d40_dmaengine_init(base, num_reserved_chans);
 	if (ret)
-		goto destroy_cache;
+		goto release_irq;
 
 	ret = dma_set_max_seg_size(base->dev, STEDMA40_MAX_SEG_SIZE);
 	if (ret) {
@@ -3693,12 +3693,14 @@ static int __init d40_probe(struct platform_device *pdev)
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



