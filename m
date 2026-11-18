Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023678;
	b=aE71XUqLngRzjf8apAuPBfQfCpsUDLZYC2ht/dVX1EdpG0LbjSnaT+opRMNWxggV2pkF
	 Q8QWS+0OqyVHsxrlsB1DI/C4LebGAuqIzfmtdxw7ieltgdPcZGqtnd0me1qFeTCInUVfZ
	 d0Meos2XtSgY/Mv6jtiOXAcdXPkI4SvEliS8/DzyLe2F3IQ8L/vsnoWLVSHITaZzBbD2D
	 G0mbwqHrnk78s+0jyJQ4H78uZHMP5S0q6pME8r7/dV7+4Z7dvwTMTwadqkgwyy55zs0/Q
	 fABk09OpBqaqkyX4nvPkoTqweSQwrNptnAriexbMH8dwskFQJctgSMro66aHalF3RCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iW/XW/dp3JQoO6093QgRYnsFg5Z1qyuAc8hy52iTWJY=;
	b=M8FrsouRsfhwYeOkyQrp3gL4vsJtUltql1TpLdZRrr/hh/VaGnxNwHp+zge+1WN9t5cu
	 pclEiubezM1FndtGvgBFeAMH//rQcURYLA9TWGGpaKC9V6+cuQamD1dkeaifbGONiAq6y
	 WOm97Sh1iKesPZocF2rME9qRVvJqw5w0N34DSM4bcGC0tKDjjTMGdQoH2KypATQTEMaS1
	 EjZVtBT0tT9b9aCPLXwuNEIoBiyydzK2GnQzMGtCvLkBdjdaB5s7SJEoHO078ZvJ5kqnN
	 y7zrJsYwOyxdafJNa6Sq6zUt/LA0BNGbWJR56i0tpe363gkiNgFAXG75mBl24U52hYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aDUiMCI6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A52606A320;
	Wed, 18 Nov 2026 17:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aDUiMCI6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D891F000C4;
	Wed, 18 Nov 2026 17:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023678;
	bh=iW/XW/dp3JQoO6093QgRYnsFg5Z1qyuAc8hy52iTWJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aDUiMCI6gJ5lvOWsZrUn/xbpbzMEIr7ZLjF32L35xwa5ITlW1C6MMWW/6YkuvzJZg
	 sLwoa9VX+XojFT+2fkM+AUklpcE4w62T3GVfAJwVtxgsPHolBsouSqIf/z13rPWZI/
	 FufkVA3Vckv27e3aXtngqFVraWaGXs3LnQ1a0nas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0455/2151] dmaengine: mv_xor: kill tasklet on channel add error path
Date: Wed, 18 Nov 2026 15:36:30 +0100
Message-ID: <20261118150138.599113529@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit bcb4d469b19d53dc21e4a1da12d4438e7489e150 ]

If request_irq() succeeds but a later step (self-test or device
registration) fails, the error path at err_free_irq frees the IRQ
but does not kill the tasklet.  A previously scheduled tasklet can
still run after the channel is freed, accessing freed memory.

Add tasklet_kill() after free_irq() on the error path.

Fixes: ff7b04796d98 ("dmaengine: DMA engine driver for Marvell XOR engine")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260909234601.101883-1-rosenp@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mv_xor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 5e83862960461..8229c69089b94 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1162,6 +1162,7 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 
 err_free_irq:
 	free_irq(mv_chan->irq, mv_chan);
+	tasklet_kill(&mv_chan->irq_tasklet);
 err_free_dma:
 	dma_free_wc(&pdev->dev, MV_XOR_POOL_SIZE,
 			  mv_chan->dma_desc_pool_virt, mv_chan->dma_desc_pool);
-- 
2.53.0



