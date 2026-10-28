Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215873;
	b=lVsuhLmShDg3j8ClyijYS2YvWkiJ9nXVKCVtT3y6bLFEIhm7foHygz515Zjrz9ocDMlH
	 Vm7YOiY28/zQuf0qsBve5d8VnABiSrjy4/v8L3KoPl6QPPxBHbPpgCuKw3Sbbr+SatYvG
	 R9fFHMozMT6yFHYiEMgKi5ocLAhxt5/VLQiweR803eIwPJ7omgrd8J9o2uana5OUWSUPg
	 oBUuXGYuLSF1PPG4KCSfJzXgqm1B7CCn3nf6BDhRszhT4Oe/ozSQcGrHrDIYStWkcF2Uj
	 Mj+Ui/CeMhb2ilWLyK6al3mqNJGR4cKp6iJYJ1tE7MpCKtGdSPLSlanEiDJoH1Hmnlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215873;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R06OM5xcg6urDknaXThKgiqVcPYd8TXz4WV0+Hhrgh8=;
	b=zknQSbgvLH/fvdXzVD6ZnJYlz4EHCv0NtocQ1IJSr4sL0aQALEtrN8nJUkitgMF/fKqR
	 6kM1Gt5y5G3lFAegZph1qugQKK/ozviS/0mE9LdbF5NW8GOumqueEQE2BD7c4k5rFQhxn
	 dzoZIzIUAJfwxZ1TmW5jvEfFy3tBjITjcn7Kk3eJoW7c7qXoJtuwtsj4Ca31yI7eZkBin
	 M8xhLTdt0suLdc2Bo/V7BJLeWqWAtQA8oBJN3MRqL2mzWOMhoSG9zNXjYY2NGymoUyJ0y
	 6jFlxYT4IiVsZuJHoEO7Wsgzmt/kyJmXmfOPlvYnU4W9+ifBCxYybOtojyKQNK51sIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vpxAhAY5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332F5606A323;
	Wed, 28 Oct 2026 19:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vpxAhAY5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DF21F01828;
	Wed, 28 Oct 2026 19:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215873;
	bh=R06OM5xcg6urDknaXThKgiqVcPYd8TXz4WV0+Hhrgh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vpxAhAY5FJkiK5g1//alrd9hNjS278G2s6f6/vC5w5FGgXLgOOTEEHj2A10sM1JBd
	 W+4c0MTu397ch460sfJf31KEKbjvBHbdhlVGRiCnHN5+OknXOhEHTxvG9+0n51/IhU
	 i9nBspDK41oS/jlIPApQ38lAqpiJUmcoKWADlEcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1360/1887] NTB: ntb_transport: Use ntb_get_dma_dev() for DMA buffers
Date: Wed, 28 Oct 2026 17:57:36 +0100
Message-ID: <20261028170530.392621751@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 852b94ff92cbe26a0dbb15eed9474f5493767f3b ]

ntb_transport currently uses ndev->pdev->dev for coherent allocations
and frees.

Switch the coherent buffer allocation/free paths to use
ntb_get_dma_dev(), so ntb_transport can work with NTB implementations
where the NTB PCI function is not the right device to use for DMA
mappings.

Suggested-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260306031443.1911860-3-den@valinux.co.jp
Stable-dep-of: da6d997ac556 ("ntb: Store original DMA address for future release")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/ntb_transport.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 6cd884d1d7eb9..8cb5439cf3b09 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -791,13 +791,13 @@ static void ntb_transport_msi_desc_changed(void *data)
 static void ntb_free_mw(struct ntb_transport_ctx *nt, int num_mw)
 {
 	struct ntb_transport_mw *mw = &nt->mw_vec[num_mw];
-	struct pci_dev *pdev = nt->ndev->pdev;
+	struct device *dma_dev = ntb_get_dma_dev(nt->ndev);
 
 	if (!mw->virt_addr)
 		return;
 
 	ntb_mw_clear_trans(nt->ndev, PIDX, num_mw);
-	dma_free_coherent(&pdev->dev, mw->alloc_size,
+	dma_free_coherent(dma_dev, mw->alloc_size,
 			  mw->alloc_addr, mw->dma_addr);
 	mw->xlat_size = 0;
 	mw->buff_size = 0;
@@ -867,7 +867,7 @@ static int ntb_set_mw(struct ntb_transport_ctx *nt, int num_mw,
 		      resource_size_t size)
 {
 	struct ntb_transport_mw *mw = &nt->mw_vec[num_mw];
-	struct pci_dev *pdev = nt->ndev->pdev;
+	struct device *dma_dev = ntb_get_dma_dev(nt->ndev);
 	size_t xlat_size, buff_size;
 	resource_size_t xlat_align;
 	resource_size_t xlat_align_size;
@@ -896,12 +896,12 @@ static int ntb_set_mw(struct ntb_transport_ctx *nt, int num_mw,
 	mw->buff_size = buff_size;
 	mw->alloc_size = buff_size;
 
-	rc = ntb_alloc_mw_buffer(mw, &pdev->dev, xlat_align);
+	rc = ntb_alloc_mw_buffer(mw, dma_dev, xlat_align);
 	if (rc) {
 		mw->alloc_size *= 2;
-		rc = ntb_alloc_mw_buffer(mw, &pdev->dev, xlat_align);
+		rc = ntb_alloc_mw_buffer(mw, dma_dev, xlat_align);
 		if (rc) {
-			dev_err(&pdev->dev,
+			dev_err(dma_dev,
 				"Unable to alloc aligned MW buff\n");
 			mw->xlat_size = 0;
 			mw->buff_size = 0;
@@ -914,7 +914,7 @@ static int ntb_set_mw(struct ntb_transport_ctx *nt, int num_mw,
 	rc = ntb_mw_set_trans(nt->ndev, PIDX, num_mw, mw->dma_addr,
 			      mw->xlat_size);
 	if (rc) {
-		dev_err(&pdev->dev, "Unable to set mw%d translation", num_mw);
+		dev_err(dma_dev, "Unable to set mw%d translation", num_mw);
 		ntb_free_mw(nt, num_mw);
 		return -EIO;
 	}
-- 
2.53.0



