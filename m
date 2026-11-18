Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059620;
	b=Zs5OzLUklXhhY+5ZbNNLL0c2v1HFGZD0+ZlfKQamVVmUUGXr/kPHubiMLfQ/KWAkTBCM
	 Ckse+puPOQnfgb2U0JwA+utceW6XfUflNNkHI5eB5px2mjchFGzCi8MXggf/xPnu6GSYR
	 v3udghdzuUKu/u8JZc6JzEYDDKTSIDkGlqaxTXh8KJXiXx1kD1fFGtHpZBjllT4EGdqPU
	 5ibYjYZsHfa5gxCbt8jH73IInE3XoRXOqDAHCRGWKvaHJXUDKfVj18eeJ2M3m+TWBA2On
	 VLDFeAeISxuGYgufodoh8G18Ghk1dGUJ3p9t1lXXBz51QFq5j5GgCVpqu4je4usFyrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qe054UWgq5kwh2G1T7hSo3RXw53alPuU2pSRz81YHU8=;
	b=lVUY5DqbVSFvZkIL/dXPb7e4gWwppSOGhUhEDJUv7dLJJsIJENUX8DiIkKdOLHTB2WUb
	 Ns3YxdrQ3acEmLGnYcnYHOsMXOsugtHS+7kPgw2PthU4ndnZzjtYUYBSDSkxc60ROZvj3
	 N/rD+Ai+VKL0nwKXFcskcQhHz5J8qSzwg4ZtV+SZ9XUQRQvDTnR8qJx4jxpjb1nb48ACs
	 i0STC2UihqxzHWjAN0tvZBgKe4zevpRljpiWlyLwTXJCO+aBz/NDgD7PfjPDqul02Fytl
	 26cQvVwtL7Ac948bzF+71txjHty46AMcl4MzIh7X8CQqYLU/kxa1Lkg5LCKUCkGxCOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ydHW8TQL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A64460A381F;
	Thu, 19 Nov 2026 03:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ydHW8TQL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7240D1F000C6;
	Thu, 19 Nov 2026 03:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059620;
	bh=qe054UWgq5kwh2G1T7hSo3RXw53alPuU2pSRz81YHU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ydHW8TQLf0KuTVWvhJTMq9qrYBDOEU/VUreG54n1H9HXvVB4cAar+eUMu5z2NMDzb
	 22CrzeT+K6uxQZbv9SK0UZl1ijOW+M7GQiftLycoABuffIIsYoCPaa9/Dq4vCNUt4b
	 EDnS3pOppvFGjd9uLpJeN7WcnbSS2FD9hD/9kAfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0906/1848] xen/pcifront: Drop pcifront_common_process() tests of pcidev, pdrv
Date: Wed, 18 Nov 2026 15:49:04 +0100
Message-ID: <20261118145954.717261233@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 34ab316d7287692bad41ce4a431b43d60a8bd20f ]

pcifront_common_process() exits early if pcidev or pcidev->driver are NULL,
so simplify it by not checking them again.

[bhelgaas: split flag change to separate patch]
Link: https://lore.kernel.org/r/20211004125935.2300113-4-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 3b4854b69ee7 ("xen/pcifront: check that an AER callback exists before calling it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/xen-pcifront.c | 52 +++++++++++++-------------------------
 1 file changed, 17 insertions(+), 35 deletions(-)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index c6fe0cfec0f68..2ad209ba659bf 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -585,61 +585,43 @@ static pci_ers_result_t pcifront_common_process(int cmd,
 						struct pcifront_device *pdev,
 						pci_channel_state_t state)
 {
-	pci_ers_result_t result;
 	struct pci_driver *pdrv;
 	int bus = pdev->sh_info->aer_op.bus;
 	int devfn = pdev->sh_info->aer_op.devfn;
 	int domain = pdev->sh_info->aer_op.domain;
 	struct pci_dev *pcidev;
-	int flag = 0;
 
 	dev_dbg(&pdev->xdev->dev,
 		"pcifront AER process: cmd %x (bus:%x, devfn%x)",
 		cmd, bus, devfn);
-	result = PCI_ERS_RESULT_NONE;
 
 	pcidev = pci_get_domain_bus_and_slot(domain, bus, devfn);
 	if (!pcidev || !pcidev->driver) {
 		dev_err(&pdev->xdev->dev, "device or AER driver is NULL\n");
 		pci_dev_put(pcidev);
-		return result;
+		return PCI_ERS_RESULT_NONE;
 	}
 	pdrv = pcidev->driver;
 
-	if (pdrv) {
-		if (pdrv->err_handler && pdrv->err_handler->error_detected) {
-			pci_dbg(pcidev, "trying to call AER service\n");
-			if (pcidev) {
-				flag = 1;
-				switch (cmd) {
-				case XEN_PCI_OP_aer_detected:
-					result = pdrv->err_handler->
-						 error_detected(pcidev, state);
-					break;
-				case XEN_PCI_OP_aer_mmio:
-					result = pdrv->err_handler->
-						 mmio_enabled(pcidev);
-					break;
-				case XEN_PCI_OP_aer_slotreset:
-					result = pdrv->err_handler->
-						 slot_reset(pcidev);
-					break;
-				case XEN_PCI_OP_aer_resume:
-					pdrv->err_handler->resume(pcidev);
-					break;
-				default:
-					dev_err(&pdev->xdev->dev,
-						"bad request in aer recovery "
-						"operation!\n");
-
-				}
-			}
+	if (pdrv->err_handler && pdrv->err_handler->error_detected) {
+		pci_dbg(pcidev, "trying to call AER service\n");
+		switch (cmd) {
+		case XEN_PCI_OP_aer_detected:
+			return pdrv->err_handler->error_detected(pcidev, state);
+		case XEN_PCI_OP_aer_mmio:
+			return pdrv->err_handler->mmio_enabled(pcidev);
+		case XEN_PCI_OP_aer_slotreset:
+			return pdrv->err_handler->slot_reset(pcidev);
+		case XEN_PCI_OP_aer_resume:
+			pdrv->err_handler->resume(pcidev);
+			return PCI_ERS_RESULT_NONE;
+		default:
+			dev_err(&pdev->xdev->dev,
+				"bad request in aer recovery operation!\n");
 		}
 	}
-	if (!flag)
-		result = PCI_ERS_RESULT_NONE;
 
-	return result;
+	return PCI_ERS_RESULT_NONE;
 }
 
 
-- 
2.53.0



