Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A67234C9BF;
	Wed,  3 Dec 2025 16:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777733; cv=none; b=gXSOYLrdicg9nQ3RYUyjXjd+Gma4gFDmwmLVMgT92K5SqdPzeyAOrq6Plmnw9alZ5eSP4h871cmFUeEW7pmSn6KFvOd1tGZzaym5FXnIj0bBQgFWZbHKvtqZ2Jf+ZKFOeBk5+9mLVx/QH9hLZkg5TQzhkLyjou/YYMHHdPXsqoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777733; c=relaxed/simple;
	bh=aF2kAm4Rj08SdVr3g4CVwx9XCgi9FeYMuQVkDgVG7iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ze3VQAfs60QR7/Pf2oq9hRmoVU362VfdvtV3lnvBE2xLnV2RojuKN7WHUj2vjzLQFQDqS+m4CUHUhn+Gx2Gkli98ZPdZQ5QExSCiUqjB4fcPD4IMtysF/dO1bb1kAapnM3LVipUmDGJKH4L11stlOLNOKN+hNBUqXUKnLc/zm4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCB2g5U/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCB2g5U/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A7AC4CEF5;
	Wed,  3 Dec 2025 16:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777732;
	bh=aF2kAm4Rj08SdVr3g4CVwx9XCgi9FeYMuQVkDgVG7iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCB2g5U/++MvaONpGdMh4d7iu2LvdKFL0homXxv3H2DFsobulicmjFXIESYClm2Hj
	 gEI1uiyzmrg36WLOSfywMDRskqvywP4LDYJJpaiXwV+PGLhVztgO1C7wBOjg1hW5OE
	 3i+AeJjIyADoL0BApcOG3EMduGUJ0eYvWvyHkBfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/392] dmaengine: mv_xor: match alloc_wc and free_wc
Date: Wed,  3 Dec 2025 16:24:38 +0100
Message-ID: <20251203152418.803118180@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ca0ba1d462832..8b215cbca1186 100644
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



