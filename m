Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018651;
	b=5Q4f045jmSugCyP5FC9bM0apKFI26PLhRjqMckHUhjaGF7VCQ7wjjGtx1h9FxQ431ukf
	 w8oIkwpypiP6dH7ZYfbMMJvBzSwfBqqFGZNBj9T1Ab8NdLZfSNctNZ6ULDu8zPepyoLR7
	 TejKdFSVsnRoOAWqN66C9heyNmvNiBmh1kpNXCYX3HPN0dQWOV6DLl4V7LIEwG1FUCpxB
	 DH7WutAVgwS/W44w1GmaAJlHpGmddV6+JLOHejO0JCwwItu9SHSk+HF0XDZZgk0IDrNBh
	 52bluQ/yxhhBYkhNK2PGxvctAs5k0aLydQhqTpHtCftEymGBMlFcndcHiW3h8FKx2vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NSiRg3JYbzAfSgIw0riiVeyKcWibi9K2BFnzdCbpvjY=;
	b=HbiWX4e+YFitHm1xir6OSU0HMiQWXOTeSNadIaiuATTDNhCqkjK6NbDszsVipnWo04yR
	 wwOA8FoyE0cxjoCvNUCB5gZ9gLv7fEZXaxyLDx4FT0+0ShmnFwb7FHqVRB8jgGUilS25n
	 tEM6tpqy7B4nXh0VWVikrlgVKfo9Tqs2I3DtzVvCYLFxFtdsPl8ut1Qpulrg+1tRZhw1R
	 bb1pD0sfYlh+l+sS/botRxTaFHzzAucOPGRLyNpciPqtnHej6DRiFanjQpFhzyrvfnZE/
	 CmV1ARxwYAiI+ZiKFupWfB91QplRforcvU5fI3JWbhpOrtNi2/CaLeA6KRV203qUT9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aOn+6I6z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8942606A31C;
	Wed, 18 Nov 2026 16:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aOn+6I6z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D967A1F000C5;
	Wed, 18 Nov 2026 16:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018651;
	bh=NSiRg3JYbzAfSgIw0riiVeyKcWibi9K2BFnzdCbpvjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aOn+6I6zesvdrkwe/5G8NxyKMICchCGjciZCAet0a8QKv4CvAFvUDjzk7rHFSKDvr
	 fEBfnYXG5Oxb5jnIGbtKoCf+7LVEmaI1xNpONaRBhHeDcensRJzdO2xIoH87juPssA
	 LYgifoOqoTr0XPXrFGwJVT6e2QOj16xq8xHLBtVM=
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
Subject: [PATCH 7.3 1317/2651] dmaengine: ioat: disable relaxed ordering before registering the device
Date: Wed, 18 Nov 2026 15:42:37 +0100
Message-ID: <20261118150335.399660427@linuxfoundation.org>
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
index 737496391109e..a57024c4b066e 100644
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



