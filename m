Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040811;
	b=bArO6PNQcQGnEotjXhUXKWHo1EqY1P3ekaiWv3o9fktnji4D6x+vYg+uIYrzY+1B3La6
	 gcWb54v2NNh+GHMkjyUz30GsYBSLzgKJRGL082iB/sgsl+vAY9Ul/yxhRU/BZQSUFoJdP
	 DWtO1uQ356Cj/GrPaX9cla02E7SphKx0KMHDuGoApey5d0pPRuPMc+wQdY0/DdVGvERo8
	 Dxeey4X/bXR4ucpWtreJR9LG9XjDzP47fH4R74cNvuuX2N+9ymSvD1sKH3a3JArwAgmel
	 PBUJSKMWgfJ8yeIsz2l/PWBrq7nG+KUfFPhnaEfzB560nInp7usUD+DdaGhNKWTY0sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/5IAVocS0j2l0mgekuR6TVQW6wZU3rpi+nVWQ0NKReo=;
	b=QZONXRPrebKfei5DeQuE3WVJsayhazFITq1NUsiL6vd7hBMolQUu2VVNP6DZavQBEQpP
	 dmjd8hebAdCmpQpq7I/ArjQbtdrxquoysEojEUGkwmMM+0/mZqsI/jF5leAzVO+Swl5xV
	 tG2FiS5oI7IwJ8dbtnALh18M5oQUqm2OpGaEvRbXopQi8yZ0E07cvAeAn0doqrKsrn5GN
	 3LRBWL2PiA8uYwM4sRjmXTBVk132Zc8fKvH0erdG/Sa1a6wzij8Mf5vHADZ9VoZjCqzhw
	 4rdKzh6QhfJn+8gy/YMseHJ2WVGqVLJUNeFcmQYqnqmsOH2EMjVnabXv0StgbSW9hsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RN+6xaG3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654DC606A31C;
	Wed, 18 Nov 2026 22:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RN+6xaG3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCC51F000C4;
	Wed, 18 Nov 2026 22:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040811;
	bh=/5IAVocS0j2l0mgekuR6TVQW6wZU3rpi+nVWQ0NKReo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RN+6xaG3WoT2WVC6K2/+7FRaG38+quNQvjVgya3pW8YZJDKhUUEiQtu45H5E+IKIy
	 OLpkmgY3LV3dSP7jP1+Nm1wSBnE0KaYMMLcPiGCv7YWykAQWQDzUuwKKySjN6DjoZw
	 s+9JfXC83B4Kyan0JILlPk5FHoLLLrcJydVG7+tk=
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
Subject: [PATCH 6.6 2591/3318] dmaengine: ioat: disable relaxed ordering before registering the device
Date: Wed, 18 Nov 2026 15:53:33 +0100
Message-ID: <20261118150438.907058684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e8f45a7fded43..1559ecab7ad44 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -1169,15 +1169,6 @@ static int ioat3_dma_probe(struct ioatdma_device *ioat_dma, int dca)
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
@@ -1193,6 +1184,15 @@ static int ioat3_dma_probe(struct ioatdma_device *ioat_dma, int dca)
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



