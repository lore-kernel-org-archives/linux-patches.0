Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025506;
	b=aoHiv4IcdwyNCKhFtVFEpVGxMCMb0S6faGinE2DYtST1I4m5pQGlQLCsIdPNgrMR7kqz
	 T90iytMgW1DpfKU2eVgk6Je8RVdgxFg/OlNsGoYFq4NMYJmp8gwWYLV+2DfsLqs8FaEdG
	 5RM7XxKGtakc15PkfhZLUEg7vP0QEzhAS45kiymzT5Ig7NZ2GSbNFvpQTFfeYi7XQoBfN
	 uZ4HVWp2G8iyQYJ8KP6bFR9CW6TgVsAHFvXOZII18piPCAQv4B9RRTelKZ/qed+3HUDRO
	 XE8wluT/05O3HfoN+RV6FVgxMgt41b3yyCx/5EHM6USPQAA5iO61+B5UBQzF7Gw0lAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+EjkLulcrWgDIvmAMvGflvn3LCPYtsZB6i7qzqxka/4=;
	b=I1+AdjiJB6lOaj7tB+62TfBeBnCfIek85xIrUBVPVI4T8YNsEMe1LG+Et4wgkhPP6YVv
	 P+e4OYwOnW/sfqoR9hGeyIxjnBvU5/+hfzt04vP/fDPgt5lhNOb6z8RD6mF+5NGWYHeMl
	 UHjN1a60sGbOS3fv0GyexJZ4YeFX0qYbHaE+MHQDvHeKvPz34OiV0OECmsoxuMSkVXX0O
	 h91+1F1AdeTwwdJKC1W8NXMKozD6K7ypIBNlP6guvcQ12RM1ALx4nFWrb6NC/IwLkDoui
	 2sUHg2z4iCOJH6fyIU6Ol9MZmSIXT/Q5S03E6fu0RKB57thS7RF/MCeMaHaVJqM7fmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xYdYBwXY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8C5606A325;
	Wed, 18 Nov 2026 18:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xYdYBwXY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7456B1F000C8;
	Wed, 18 Nov 2026 18:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025506;
	bh=+EjkLulcrWgDIvmAMvGflvn3LCPYtsZB6i7qzqxka/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xYdYBwXY55yCauqrfrBTsOPyJmJq2gMHXBBwNddmTRQ9LB4eFzN6EXfKG6NdpxWQd
	 Y91+jkA3Zs9txTFEalpGNoParlsSBHwoiKytrBxy1mMOqfzF8alpgEtNsC/Pvdz18+
	 9FtPZouZtvC5Ty8EaN53FJWW1dNk+QLF+uXUjRWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1101/2151] dmaengine: plx_dma: fix NULL pointer deref in plx_dma_isr()
Date: Wed, 18 Nov 2026 15:47:16 +0100
Message-ID: <20261118150202.363800374@linuxfoundation.org>
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

[ Upstream commit f3017892457d8bb664ea4b912910dc254e2dd825 ]

plx_dma_create() registered the interrupt handler with request_irq()
before initializing plxdev->bar. If the device raised an interrupt in
that window, plx_dma_isr() would dereference the still-NULL bar.

Move the bar assignment ahead of request_irq() so everything the
handler can touch is initialized before it can run.

Reported-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Reported-by: Kyungwook Boo <bookyungwook@gmail.com>
Link: https://lore.kernel.org/all/20260610112121.676561-1-jjy600901@snu.ac.kr
Fixes: c2dbcaa8c672 ("dmaengine: plx-dma: Implement hardware initialization and cleanup")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Link: https://lore.kernel.org/all/20260610112121.676561-1-jjy600901@snu.ac.kr/T/#u
Link: https://patch.msgid.link/20260902062153.31048-11-logang@deltatee.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/plx_dma.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/plx_dma.c b/drivers/dma/plx_dma.c
index 34b6416c3287e..5e98a8509aa46 100644
--- a/drivers/dma/plx_dma.c
+++ b/drivers/dma/plx_dma.c
@@ -505,17 +505,17 @@ static int plx_dma_create(struct pci_dev *pdev)
 	if (!plxdev)
 		return -ENOMEM;
 
-	rc = request_irq(pci_irq_vector(pdev, 0), plx_dma_isr, 0,
-			 KBUILD_MODNAME, plxdev);
-	if (rc)
-		goto free_plx;
-
 	spin_lock_init(&plxdev->ring_lock);
 	tasklet_setup(&plxdev->desc_task, plx_dma_desc_task);
 
 	RCU_INIT_POINTER(plxdev->pdev, pdev);
 	plxdev->bar = pcim_iomap_table(pdev)[0];
 
+	rc = request_irq(pci_irq_vector(pdev, 0), plx_dma_isr, 0,
+			 KBUILD_MODNAME, plxdev);
+	if (rc)
+		goto free_plx;
+
 	dma = &plxdev->dma_dev;
 	INIT_LIST_HEAD(&dma->channels);
 	dma_cap_set(DMA_MEMCPY, dma->cap_mask);
-- 
2.53.0



