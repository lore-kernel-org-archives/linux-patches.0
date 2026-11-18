Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018645;
	b=whqnRM2y7SXCxPTQ4JooEmF2fB7Ky6TQKLsRVxI+Eo1pSQDZUC01Gq7Icj9rLOdxHq0a
	 3U9/ktSwVkB+CIoOaxF8DfUZTy0irJczIhnxkwjpDGMJN/cSjinsmV6QdHSIV7d0/cAPh
	 LeuQLlLI9gSoTjNzwsBa9M7qyO0AynjmNyk9FCpDMujWK+pYypxKelgijuuAy9HFTiDt6
	 lr5225R2i1KCbPL2tFz5r20ztcmagbDWUsMqKw7RWcwaYNPmm5ht4qQrFen+hLbpuC3A3
	 A9YaeW8VcyjxykWDpZKhZcIXfIEVjZ/SzlpC5msHtI89fBD5sJPxq2irQ12A8VNn/5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018645;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XI5kRJUpQtLt4NJTzTHUGmc3n01KbPdXRgFEeNWfOfI=;
	b=oXOjh4i/CvAamCxZ8CDj0y6mYQfCtu6w2/GVMMvzgT2C1KVNgHNRQ9AcBIbz907+LuwJ
	 h8IMx/RKF8CSi9I69svsw5Vzc6uZxOxXQP+OJcDM4FS0JWP+6IHB3iErbOuuwisSRt7cV
	 dnLVGcXzzgzGxjSxjXa7wHI5lnFmUwmDfi4XVPojGJwnEwIw+ObtpqOR1w7E2/zB+ynTn
	 YNTju9ix/0Pc057GMlbz2VtMIrbXV00Z1dQjBmA4tbyE8HPLkYd4I2i9yTRYHUeauc3+D
	 fdzE8P9lqfcvZr3ILdERcNmzJeYYCBfNLwZDS5qFhYUq/XhM/ZRFCM1haJZID8KIBQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hhBvgduz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F71606A31C;
	Wed, 18 Nov 2026 16:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hhBvgduz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FF31F000C4;
	Wed, 18 Nov 2026 16:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018645;
	bh=XI5kRJUpQtLt4NJTzTHUGmc3n01KbPdXRgFEeNWfOfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hhBvgduz4TUug3O2juR8VBW5PXKFv5Hb942fDpCszWXS5ow0bCEsD9lCse/nbpHEY
	 NQiNUboKkHiKK5IVV/UpTHYSpPPVMZ1NZiwUxS5q3Qm/VCMpwN6fXYNFip8xJKnGZ8
	 8Sz8dj6v/UZKNP6xW7TlFK11gvKqCl/AZTrnngKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1315/2651] dmaengine: switchtec-dma: fix resource leak in alloc_chan_resources
Date: Wed, 18 Nov 2026 15:42:35 +0100
Message-ID: <20261118150335.318285142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 1188942d6160b9f799af297bdb5d7812cd7fde6d ]

switchtec_dma_alloc_chan_resources() returns directly on any later
failure, without ever freeing the descriptor rings and coherent DMA
memory it just allocated. The dmaengine core does not call
device_free_chan_resources() when device_alloc_chan_resources() fails,
so the driver has to unwind its own partial state.

The device-removed check also runs after ring_active and
comp_ring_active have already been set true, so a failure there left
the channel marked active despite alloc_chan_resources() reporting
failure.

Add an error-unwind path that disables the channel and frees the
descriptor rings on every failure after allocation. ring_active and
comp_ring_active are cleared under the same locks
switchtec_dma_free_chan_resources() already uses, since the completion
tasklet checks comp_ring_active under complete_lock before touching
the completion ring, and a stale IRQ can still be in flight when this
unwind path runs.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/dmaengine/20260707165555.350951F000E9@smtp.kernel.org
Fixes: 30eba9df76ad ("dmaengine: switchtec-dma: Implement hardware initialization and cleanup")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Link: https://lore.kernel.org/dmaengine/20260707165555.350951F000E9@smtp.kernel.org/T/#u
Link: https://patch.msgid.link/20260902062153.31048-3-logang@deltatee.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/switchtec_dma.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/switchtec_dma.c b/drivers/dma/switchtec_dma.c
index 9eb8a49beda33..06b50d380792a 100644
--- a/drivers/dma/switchtec_dma.c
+++ b/drivers/dma/switchtec_dma.c
@@ -988,15 +988,15 @@ static int switchtec_dma_alloc_chan_resources(struct dma_chan *chan)
 
 	rc = enable_channel(swdma_chan);
 	if (rc)
-		return rc;
+		goto err_free_desc;
 
 	rc = reset_channel(swdma_chan);
 	if (rc)
-		return rc;
+		goto err_disable_channel;
 
 	rc = unhalt_channel(swdma_chan);
 	if (rc)
-		return rc;
+		goto err_disable_channel;
 
 	swdma_chan->ring_active = true;
 	swdma_chan->comp_ring_active = true;
@@ -1007,7 +1007,8 @@ static int switchtec_dma_alloc_chan_resources(struct dma_chan *chan)
 	rcu_read_lock();
 	if (!rcu_dereference(swdma_dev->pdev)) {
 		rcu_read_unlock();
-		return -ENODEV;
+		rc = -ENODEV;
+		goto err_ring_inactive;
 	}
 
 	perf_cfg = readl(&swdma_chan->mmio_chan_fw->perf_cfg);
@@ -1029,6 +1030,20 @@ static int switchtec_dma_alloc_chan_resources(struct dma_chan *chan)
 		FIELD_GET(PERF_MRRS_MASK, perf_cfg));
 
 	return SWITCHTEC_DMA_SQ_SIZE;
+
+err_ring_inactive:
+	spin_lock_bh(&swdma_chan->submit_lock);
+	swdma_chan->ring_active = false;
+	spin_unlock_bh(&swdma_chan->submit_lock);
+
+	spin_lock_bh(&swdma_chan->complete_lock);
+	swdma_chan->comp_ring_active = false;
+	spin_unlock_bh(&swdma_chan->complete_lock);
+err_disable_channel:
+	disable_channel(swdma_chan);
+err_free_desc:
+	switchtec_dma_free_desc(swdma_chan);
+	return rc;
 }
 
 static void switchtec_dma_free_chan_resources(struct dma_chan *chan)
-- 
2.53.0



