Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049125;
	b=BwcEPJMu+2MOUl4w4pQ9UWbPbpIiBAO3/oPCMGNVSKqtLUxo/S7PWlzUCQJPVZ2+lSWU
	 RhzJDz7XIRhVZVOnsRC0fvopTy8EhTAHs2WYpH3etomUURDLwq7VC21Fjf4jxHwzVNtuV
	 XaMDPVcelZ9EFAdT0mftiRgv8caOw0H/ttdK+Q4bxo7cX9aaBu+7SmEuq/r1cU6T9mTZ9
	 SW+kST2NGBwawgm16pjh864lIi77vwVXgXIulfeBDkkl6Gz4Hc7+u2gypDsklhQsZZabI
	 L2ewkz9Td9Zscxd/ZcnvwYoZRcdVY0t3Z5AyVUqjJ8Loh9KBDzeyJsOF7BogtBCAhtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZgKBFpk21uHGWmfBqFBsDUvkvDjREfwJj7CEj+ifje4=;
	b=hygsylhgLXgfRQBgUHGoSfSzobWo/TTYRmPBjeWdsze+Wb2517Q9LwSQAmVc6fRTLYUo
	 7bs2mgz2PgByZ4CUgRim3L6aLLh/l2k0ptM5a7FEnrB/IpsF0u2Zcs8VtpPmMhYFgFdE7
	 KITPhrpp5iwaKOsyzBEfi8pKYYftmYU+HTArpEO+bDLHC2L6AKJqmEN0rs684Pk8Toq17
	 vchABXbmgUB/TWMCZZBAMTmakM+yw5FdKBTL0LAc547ZZImwnf0dUpre7qwHlLub4PQ9v
	 oQRrN24Q2dZqBUXgs+d8Ajxd06hth0Gh+bt2Jlclr7yr8dP6fTiuFJU+Zvj01Lb/g+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vt0JhE1S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DB3606A320;
	Thu, 19 Nov 2026 00:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vt0JhE1S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B297D1F000C4;
	Thu, 19 Nov 2026 00:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049125;
	bh=ZgKBFpk21uHGWmfBqFBsDUvkvDjREfwJj7CEj+ifje4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vt0JhE1Sz2RY1LrsoAZDtggy8+yuO74oJmth55KgoKwO3aThseEMAjpaKLlmOWkwJ
	 XLuGR8o7LKdmqdW0O3JNIOHnDzm83jbP9j/FkQFoMy0hnZrjyuPW64VQ7q5pl+7Z83
	 yFKpzRfte83ZN92HpZe/UZaJE2MoqRyn3xeu++Vs=
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
Subject: [PATCH 6.1 2241/2857] dmaengine: plx_dma: fix NULL pointer deref in plx_dma_isr()
Date: Wed, 18 Nov 2026 15:54:35 +0100
Message-ID: <20261118150322.130427697@linuxfoundation.org>
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
index 12725fa1655ff..cfba2db346fe6 100644
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
 	dma->chancnt = 1;
 	INIT_LIST_HEAD(&dma->channels);
-- 
2.53.0



