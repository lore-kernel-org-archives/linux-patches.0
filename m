Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061218;
	b=yxgg1YW9vKpWLDVRdvqkCxcKDy1o6emcuVMjMrZU5toHYBBC0HD7sva0VaPB63pSzGyn
	 iNKZ1mPEgRZNKCI7Z0EdvMkl5lnCTFjDyctTbUSbAbfg9C+d+diLued2oTOJef/3BaXzO
	 ri1jh+yhNkLjJcNbtCWCNJ4NxLRv0uqGZMk3QFcoGAH1pDvgShm0s0SfTg6KUxUYINOpA
	 fU7qSAWslkBBQ6dHjufIb8NIQMucK64cff7Pq1KuOFxB3+Z7l5N/O/5465K+uH/GLiD1E
	 7yScaHCOOkwoI6rRiejJqJZAC4roWJONAMyJF5NWVMnePKPKM6NcAialYNsev64zkWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e+sIWLiftudr+O0BqLKzUt7Fuf6+j2sCrGn2Zxhp5O8=;
	b=vPe3g7kQ4cYsjL7vGxheKU5JWhLCZmvwVn8VL109axSd11x11HjVvNXZD9Bv+5yIRhK0
	 CqDQVzYFsyzKfLHS/ro3XCJ8Lg5gCyW9lJfZX/YUtYCzS1Brp/Wqv10EHIzQ66C8oNIrV
	 GR+wP9U8alK064MC8wBYZJIAH6HNJufLOCcQzhVbU4cq9buhtbt83CyEXRA2qZARwAsOu
	 CrYH0ZphZw7q+wu1pzr9ciqtwQ6ITgeTc3qZdJLPexWNvO4cFlCcWh7heoaalTaRZECQc
	 D7xM7hKkK/rL3jGKFuG4VF2R3Tb0GoVhdn5oX8Xt3tSPktPBLGBvH9wBW3qCxxymtBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y862PpW3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCC7606A320;
	Thu, 19 Nov 2026 04:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y862PpW3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236F51F000C4;
	Thu, 19 Nov 2026 04:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061218;
	bh=e+sIWLiftudr+O0BqLKzUt7Fuf6+j2sCrGn2Zxhp5O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y862PpW3LMKPVk2MO5eswFrVRtZ9hLzWrpcKIDGVv+MoUjdQbNOHE/omQFA6OG1nt
	 JRu5d3RlDJYGTScmBj5LQBccG2s1ND3+zL916PVj/t7M4agek6fX741DNqg1fwIIas
	 S5aX7SdOAwbKeWjo9W65Eetbt+v2/zgTo/h5J0wo=
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
Subject: [PATCH 5.10 1475/1848] dmaengine: ioat: disable relaxed ordering before registering the device
Date: Wed, 18 Nov 2026 15:58:33 +0100
Message-ID: <20261118150021.041896079@linuxfoundation.org>
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
index 2a47b9053bad8..677efa50fefce 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -1168,15 +1168,6 @@ static int ioat3_dma_probe(struct ioatdma_device *ioat_dma, int dca)
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
@@ -1192,6 +1183,15 @@ static int ioat3_dma_probe(struct ioatdma_device *ioat_dma, int dca)
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



