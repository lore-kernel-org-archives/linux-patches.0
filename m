Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055765;
	b=5X/7GX98AAlZvrU3Y4doYM9tuR0DiulZWgou98T7WyC0wsPZG4Cqucl2JZCnhnT0hmpP
	 Pov/VAgQ/JlJwdbROoRbH50thuL4DG5EEoQID/ewNqfnyk7qe5+fKF2G9z9dEoZLMT6U4
	 3L1i3LjUEgsU8nXFgrx9u6d6gIBEq+0oZ13JD6nTYvAsM2L87g7DTPdap/T/tstW8jTTM
	 P8F1m87sNHehY2vX/D+SjKSZz3UqwdRqO5hF8uA9QDV0EcAV8c+3FXVtNQfT0Sh+lz7kM
	 jN3xtWHdeimGoKOjTvRCBvXm0v1s4WxjCjo58QAPXnnVcea8ukgAqdAU+Wb654QtoOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2oNKlmfx3bTWCK14fWHDro13Dql1nqZSd4pKbjsU+Hk=;
	b=0fV7+4hpsLAZNbzL0aeNVZtdMR01616OwJwm1DV0t7nMYNJkga68uP58PkpE5dsqxuq6
	 6YSV7dDVdma0X0VDmRKgfkuHhqAazSlIQcHsqxUECcR/zl5KtUzyEegiLWPudqKqUxuF5
	 hEOuvFbRUbaHAagWWQRobmaWpbpKqoxDJ9O0AEIe1eOe3MCvX03H4Y/tnGyubkhMD8jm2
	 GDCLFJmC7zTfjGKXjTjLvQkmaI0vipDV11dzGd7N/qvDuJbCk7R7oYVm8ljVA1Cr1kXZI
	 xkx/VnU8DgnF/u8Kaqq5lhEC99jAYwhvw7IHze+jrM6R3jxFo+SBomJE85onHKz7+Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2VnZThc8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E667606A325;
	Thu, 19 Nov 2026 02:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2VnZThc8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AADD1F000C7;
	Thu, 19 Nov 2026 02:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055765;
	bh=2oNKlmfx3bTWCK14fWHDro13Dql1nqZSd4pKbjsU+Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2VnZThc8LFu3A9TunVykpcTydVIjWLDDo55oBfkGHnKKcxgTjs1nTWY7VpO04VDvp
	 NvJvSDcHEAIRur9PR/468vVz+MFpEgvV4mNfVYhxRA0T96KTShuUA7ejjL3ZLbPt4P
	 0xECF29q11jamE8fJSaw+ab6NnOTdPPNd46I7Dys=
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
Subject: [PATCH 5.15 1748/2214] dmaengine: plx_dma: fix NULL pointer deref in plx_dma_isr()
Date: Wed, 18 Nov 2026 15:57:04 +0100
Message-ID: <20261118150121.532971945@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



