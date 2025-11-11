Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7998339B58;
	Tue, 11 Nov 2025 01:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823986; cv=none; b=oCSvEq6nzHHWNl5768OJKXPfDJMcWH6z8mwR7dWKG/9DGGQNB3vox4j/h1E6WzzG4Zbra1eYPT5O3OcbMHL+RrTYaBKy+ReKUf7SV9keLtgUxHv1Klb+O22H2PRDi/gYWaFCfYrxF+AVdKD2m31x5wFaAyhHXauQ264Am94hA5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823986; c=relaxed/simple;
	bh=0fGhF3Zt/KGQKO1euqob9u194vLCGQkzuD9SswVmhM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rB9+npCXfr+XvjI0KXJB4ohzi06wpw3tcmIjemIh1KvRCSgF3N4Pgrsy/SFHhZvOExOdss/80Or/UTU15f0p+cYeK0Yi/a6rFnTkax4973RoWg/sPCdu794ImgGjFG/1edR0REmvYKU3e/qZNOCdGniqFd86FFxnJxs9RjafGQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r3YAxZym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3YAxZym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7416AC113D0;
	Tue, 11 Nov 2025 01:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823986;
	bh=0fGhF3Zt/KGQKO1euqob9u194vLCGQkzuD9SswVmhM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3YAxZymbr2WCAu4FG0N7rVJBs5jvT/GoIUxvjOdiBSnP6TiOeal5QEVW1RW8S77d
	 zphDd1YNG/yG23eXNKZQEsuXkoo6FTR5TpfCTdYGCSrGwWyHioXkQxk1a8DBJCDY4q
	 Ywta2muCRqJPxac9oQsYd2lLuDzhXjBAUdJQvIyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 415/849] dmaengine: mv_xor: match alloc_wc and free_wc
Date: Tue, 11 Nov 2025 09:39:45 +0900
Message-ID: <20251111004546.473378040@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit a33e3b667d2f004fdfae6b442bd4676f6c510abb ]

dma_alloc_wc is used but not dma_free_wc.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://lore.kernel.org/r/20250821220942.10578-1-rosenp@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mv_xor.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 1fdcb0f5c9e72..5e83862960461 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1013,7 +1013,7 @@ static int mv_xor_channel_remove(struct mv_xor_chan *mv_chan)
 
 	dma_async_device_unregister(&mv_chan->dmadev);
 
-	dma_free_coherent(dev, MV_XOR_POOL_SIZE,
+	dma_free_wc(dev, MV_XOR_POOL_SIZE,
 			  mv_chan->dma_desc_pool_virt, mv_chan->dma_desc_pool);
 	dma_unmap_single(dev, mv_chan->dummy_src_addr,
 			 MV_XOR_MIN_BYTE_COUNT, DMA_FROM_DEVICE);
@@ -1163,7 +1163,7 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 err_free_irq:
 	free_irq(mv_chan->irq, mv_chan);
 err_free_dma:
-	dma_free_coherent(&pdev->dev, MV_XOR_POOL_SIZE,
+	dma_free_wc(&pdev->dev, MV_XOR_POOL_SIZE,
 			  mv_chan->dma_desc_pool_virt, mv_chan->dma_desc_pool);
 err_unmap_dst:
 	dma_unmap_single(dma_dev->dev, mv_chan->dummy_dst_addr,
-- 
2.51.0



