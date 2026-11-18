Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061221;
	b=Ju46FWje+optDhgkEFOsY0K9eEPVYFOBZB5J33dcERSAK/oiXeM6nqc7JwUhZbtue1k9
	 BRPGPwJjENL0kq/zxfwisKDxrnUpQCAZiOfOy2PwqDOP7z4NbWObeNErm3W3v6IVcVDWv
	 GnNMGN3gAyuCVaruriF4pdu56YzKKQjD1me71lYDaVR3HZ3cK/VUra9hs3h2jIx4BI4/A
	 BMmm3WWZWSJwxgtzliWgCI0grW/c9fPKU1yuSfNMQ18ppGK4igvUcgQcXrrFsV0vafG+L
	 fwf6qUsW4PA9dNghvGnFKzRTAgiSOfS1GahNnCRovT2uH7MEEbzt/efy4N0h3XaVNSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z8SrNgBLNtAk9PgmSkCaEVsrSDTwYR1mCx/vbCGFw0A=;
	b=vJ8GUgQ+aRWd2kMMk6f7PvA6HGCVg9GtqkNQGfzqGkq+vU3hv6vBzovlIkBjjUNOHLFD
	 reaT9YMnYhknz0wkoIJrBocJB7ayiG6t2iP9Mx6nbB5rplK9vLeAbDo6OjoKbcoZXrSkS
	 UcUcCE89VAMCMuFvt3ucQMfUxLJ68+u37vBlt088QEDXeWkNa85NW6MOnploLb1JKH2ny
	 lTWr6QKTwpzTZPppzLP8wOOwEc7/nEVgcal4qCT/nGRm5nuZCbRsDg6401paZZ7QGupOT
	 rFW+lJnbatjQl8rUUAkgXAKfPbjG9qEymXzRp5ZL70RgN1TQod6kXd4LAdQe3GADl4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YbvBWr1H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80453606A320;
	Thu, 19 Nov 2026 04:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YbvBWr1H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7211F000C4;
	Thu, 19 Nov 2026 04:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061221;
	bh=z8SrNgBLNtAk9PgmSkCaEVsrSDTwYR1mCx/vbCGFw0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YbvBWr1H8VvWBGwGon0CqpgnoBIty0boNlbjQcgZhvie744QbGmlVx4KNTiF44lWE
	 M9FCBnnDQ6+cWbcUz9heHYzPKKh6ise81857aUF7AaMsKkzLYZ9DLQFGqXdziK4Bo/
	 BCUN1om/6vMN3K//TfiaQs+qLPsb0KpGin1g/mXM=
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
Subject: [PATCH 5.10 1476/1848] dmaengine: plx_dma: fix NULL pointer deref in plx_dma_isr()
Date: Wed, 18 Nov 2026 15:58:34 +0100
Message-ID: <20261118150021.078861999@linuxfoundation.org>
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
index 1669345441619..c0a224000575a 100644
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



