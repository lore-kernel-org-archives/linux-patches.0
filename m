Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025500;
	b=Fh0Hn9LOTz8jbhImzslSYiXYm5aCYUe1DxSkU9GoACPClaDgth+4wMgOyXz/KbKrCsU2
	 vX8XVhWh5l1BgTpGO2204ha5yceeyt0sx0tTf3uv56o3LqcnIRvdR7afkDhgHzOnQSeEy
	 sIiFxkNLY1EcHnHGgHu/SSnyXdFIoJRv0vY/GeOirB0fnicf6CmtHF9vwYt4kEmqy1xSl
	 qBUImCfB30FGcjE6Ysf7fn8o4/yTqnJDWaM4RoFSrP4uwTkPt7qiRBzoJZErKpa+CYDnj
	 1L3UjdfeEWxXbeLYUZpxXCXjsTiAn/J5kh96S4qB5/z4eFypqRXraYVLUodD/FxQSVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cEeU8H0YMMdG+85fo9opRhSIt8oXujmBqE5Am7xmij8=;
	b=Qp8aYMuZ3UqKXKoRe0C1VQKkku08wzdnOYxhxaVwsAfDgjT6cGKfuVfOhoO6F++4mRBb
	 o0xstxejper7fNSD9K/WCx+gVETGyXqR8wdMxg9Vsog3UEjBH07IRHT72f21lcC8TstdQ
	 6Fy753jELDKpWfTe8PonjFmmVPLX7/sZcYSbk4sQVyoUOATcXMtJbRmCYqOBFNGVBXONT
	 xipx+2ER6xiwp8kNbo0wfe/9VuZPfIx9+nEssL8DVJ0qE6+y/7ki3GLTxrylBhEmumTfW
	 2Nfy65IPJygH2hk1oRGkv27vXgYZD2YDT5LMxjS65VcDtDD13TuSkvuPATJjNQs0xwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nRwORT5J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B74B606A32C;
	Wed, 18 Nov 2026 18:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nRwORT5J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7A91F000C4;
	Wed, 18 Nov 2026 18:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025499;
	bh=cEeU8H0YMMdG+85fo9opRhSIt8oXujmBqE5Am7xmij8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nRwORT5JgGoKeTCNv+4Q+FHQWQ3N5NvlqTIBF11T3fRgFQbwet7wO+snTQ+NLxmt5
	 twOUDbLCC8sVLyibMa3Hneqds0d+SH44PEpQjAYVeZfMcc+O0OkFMLZ7wsch2702s5
	 FM3GM0jQtH6zlckrNrPFz8BkjGNPffeH16hlgWJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1100/2151] dmaengine: ioat: disable relaxed ordering before registering the device
Date: Wed, 18 Nov 2026 15:47:15 +0100
Message-ID: <20261118150202.330405811@linuxfoundation.org>
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

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 10d34fbca6e09a6a18d64fa3ebaa3db9f27fc1a6 ]

ioat3_dma_probe() disabled PCIe relaxed ordering after calling
dma_async_device_register(), so if an error occurs and the code jumps
to err_disable_interrupts, the function returns with the device still
registered in the core's dma_device_list while the caller frees the
ioatdma_device struct, leaving a dangling registration that anything
walking the device list can dereference after it's been freed.

Move the capability read/write ahead of dma_async_device_register()
instead. Nothing after registration depends on relaxed ordering
already being disabled, and nothing before it depends on the device
being registered, so this is a plain reordering. It also means every
remaining step after registration can't fail, so there's no need to
ever have to unregister the device once registered.

Fixes: 511deae0261c ("dmaengine: ioatdma: disable relaxed ordering for ioatdma")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/dmaengine/20260707165906.249F41F000E9@smtp.kernel.org
Acked-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Link: https://lore.kernel.org/dmaengine/20260707165906.249F41F000E9@smtp.kernel.org/T/#u
Link: https://patch.msgid.link/20260902062153.31048-9-logang@deltatee.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ioat/init.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/ioat/init.c b/drivers/dma/ioat/init.c
index 227398673b731..376fc111929fd 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -1170,15 +1170,6 @@ static int ioat3_dma_probe(struct ioatdma_device *ioat_dma, int dca)
 		       ioat_chan->reg_base + IOAT_DCACTRL_OFFSET);
 	}
 
-	err = dma_async_device_register(&ioat_dma->dma_dev);
-	if (err)
-		goto err_disable_interrupts;
-
-	ioat_kobject_add(ioat_dma, &ioat_ktype);
-
-	if (dca)
-		ioat_dma->dca = ioat_dca_init(pdev, ioat_dma->reg_base);
-
 	/* disable relaxed ordering */
 	err = pcie_capability_read_word(pdev, PCI_EXP_DEVCTL, &val16);
 	if (err) {
@@ -1194,6 +1185,15 @@ static int ioat3_dma_probe(struct ioatdma_device *ioat_dma, int dca)
 		goto err_disable_interrupts;
 	}
 
+	err = dma_async_device_register(&ioat_dma->dma_dev);
+	if (err)
+		goto err_disable_interrupts;
+
+	ioat_kobject_add(ioat_dma, &ioat_ktype);
+
+	if (dca)
+		ioat_dma->dca = ioat_dca_init(pdev, ioat_dma->reg_base);
+
 	if (ioat_dma->cap & IOAT_CAP_DPS)
 		writeb(ioat_pending_level + 1,
 		       ioat_dma->reg_base + IOAT_PREFETCH_LIMIT_OFFSET);
-- 
2.53.0



