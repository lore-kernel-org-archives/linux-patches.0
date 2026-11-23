Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795422846;
	b=djM7VURoJUL1vHV7i4u41AagMoypNCBobUNP0U38xCNDvfBAb9gsvxKx7QjTEV8lpG8J
	 /7TQYlMrXQJz+vzwb/g1/LCGebVJ+jV63HV4p4GlTK4gil126Ybsu2VCq4vXyNgs2qQc0
	 pLYUgWQmZcY44cKP4xeyNw+xaPe7PrHHxu5S8Vn+/0Z4qkbiNdMweBnI8VJnu7osmlrA3
	 qCuAnl3Ty1Oa0u77dJw+2MRsui+fHROc5TWIFaADGrz6/2I2t2GlIoHZ+7us7T8DXtC3d
	 xy7BDKrSesmIRZgZhINag2q14V8NlFYX1uDIPu0wDJBoAqvcAMj19f15ES5RdceB9Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795422846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=tIpTvIvF8EZNjaDBVZRgW5KyukM2VcdMfdpffjKsIbs=;
	b=aGqeWa0+BWsPGCBGlCjTD1ux0UI782V1Lq/H/weYIv1S8dXyAeAUnv9MKXR6JjQ4m7vr
	 uiBSA92poqJtwCPbIJA3lw4naztgSKbzDboy/OxlGl3epU01C4E6BRkN3ft18cSF47ieH
	 5LG2r8UJrzsuYXb5pS6n7AoT3sxcBmlIxE7STtDsNuuu3jmt5s/mpZurxDqn6LjZjjrYG
	 DUPh9+6h+KZN7cWMuh6nITAlmF6ih/WNNXiLq3UFVXVr/+5lzqKeXVstLADf6xfAVGQp9
	 tKHLFrzgvMK0/eaw1U2PKnMhCLbzkX5raVSf6GI6kARhx6yxM4jRP18xURxtsX73Fgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VnZEwJ4l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7384C606A332;
	Mon, 23 Nov 2026 08:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VnZEwJ4l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08031F000CF;
	Mon, 23 Nov 2026 08:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795422846;
	bh=tIpTvIvF8EZNjaDBVZRgW5KyukM2VcdMfdpffjKsIbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VnZEwJ4lxN3Ur6af4lWDrxFwkGIXCPl6GYNjnPclBuFNZHI2sdDBYbqD+MKPQ1OZB
	 cDBgmvF2dKWU6Xtp0iPxYCVuUoJ0sbiFmq3b2klbNsFOlY0AtvP4I0RGB9sgFnKKN7
	 8CRrW4iF1nc+YxqaaegU98xa50tbSoxCeO0zlUb4gvH26R27LUhp3Vc1SXjiKBXU8M
	 syf5/sg0uzpXLdy7xzXeCq9cL/qQYDwwrnxRur2qoi5o49MzvwvKVr0f2Ehjmz6BjX
	 rRVei0DMAGU/YoAA2FxDluGvl1wc3K+O5vBhdoc/azYtPxcZ6zejsMYcwGIrlOhtgA
	 aHwNZJIHpKrtA==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	driver-core@lists.linux.dev,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v1 03/10] PCI/TSM: Let TSM drivers discover the CMA DOE mailbox
Date: Mon, 23 Nov 2026 14:03:30 +0530
Message-ID: <20261123083337.2731019-4-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
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

Move CMA DOE discovery out of pci_tsm_pf0_constructor(). An external
Endpoint requires a mailbox, while an RcIEP can use device assignment
without DOE. Let each TSM driver enforce its own requirement.

Keep SEV-TIO requiring a CMA mailbox and reject devices without one. A
later patch adds the CCA host driver's mailbox checks, allowing RcIEPs
to operate without DOE.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/crypto/ccp/sev-dev-tsm.c |  7 ++++++
 drivers/pci/tsm.c                | 39 ++++++++++++++++----------------
 include/linux/pci-tsm.h          |  4 ++--
 3 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index 5c61ce74ee0f..af22f36a2318 100644
--- a/drivers/crypto/ccp/sev-dev-tsm.c
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -213,6 +213,13 @@ static struct pci_tsm *tio_pf0_probe(struct pci_dev *pdev, struct sev_device *se
 	if (!dsm)
 		return NULL;
 
+	dsm->tsm.doe_mb = pci_find_doe_mailbox(pdev, PCI_VENDOR_ID_PCI_SIG,
+					       PCI_DOE_FEATURE_CMA);
+	if (!dsm->tsm.doe_mb) {
+		pci_warn(pdev, "TSM init failure, no CMA mailbox\n");
+		return NULL;
+	}
+
 	rc = pci_tsm_pf0_constructor(pdev, &dsm->tsm, sev->tsmdev);
 	if (rc)
 		return NULL;
diff --git a/drivers/pci/tsm.c b/drivers/pci/tsm.c
index 5ff1265714aa..2be92bde8780 100644
--- a/drivers/pci/tsm.c
+++ b/drivers/pci/tsm.c
@@ -714,30 +714,31 @@ EXPORT_SYMBOL_GPL(pci_tsm_link_constructor);
 /**
  * pci_tsm_pf0_constructor() - common 'struct pci_tsm_pf0' (DSM) initialization
  * @pdev: Physical Function 0 PCI device (as indicated by is_pci_tsm_pf0())
- * @tsm: context to initialize
+ * @pf0: PF0 state to initialize
  * @tsm_dev: Platform TEE Security Manager, initiator of security operations
  */
-int pci_tsm_pf0_constructor(struct pci_dev *pdev, struct pci_tsm_pf0 *tsm,
+int pci_tsm_pf0_constructor(struct pci_dev *pdev, struct pci_tsm_pf0 *pf0,
 			    struct tsm_dev *tsm_dev)
 {
-	mutex_init(&tsm->lock);
-	init_completion(&tsm->dsm_context_drain_complete);
-	tsm->dsm_context_users = 0;
-	tsm->removing = false;
-	tsm->doe_mb = pci_find_doe_mailbox(pdev, PCI_VENDOR_ID_PCI_SIG,
-					   PCI_DOE_FEATURE_CMA);
-	if (!tsm->doe_mb) {
-		pci_warn(pdev, "TSM init failure, no CMA mailbox\n");
-		return -ENODEV;
-	}
+	mutex_init(&pf0->lock);
+	init_completion(&pf0->dsm_context_drain_complete);
+	pf0->dsm_context_users = 0;
+	pf0->removing = false;
+	/*
+	 * Note, low-level TSM driver responsible for determining if it wants to
+	 * proceed with a device that has no DOE mailbox. TSM may have an
+	 * alternate method for coordinating TDISP.
+	 */
+	if (!pf0->doe_mb)
+		pci_dbg(pdev, "No DOE mailbox for Component Measurement and Authentication\n");
 
-	return pci_tsm_link_constructor(pdev, &tsm->base_tsm, tsm_dev);
+	return pci_tsm_link_constructor(pdev, &pf0->base_tsm, tsm_dev);
 }
 EXPORT_SYMBOL_GPL(pci_tsm_pf0_constructor);
 
-void pci_tsm_pf0_destructor(struct pci_tsm_pf0 *pf0_tsm)
+void pci_tsm_pf0_destructor(struct pci_tsm_pf0 *pf0)
 {
-	mutex_destroy(&pf0_tsm->lock);
+	mutex_destroy(&pf0->lock);
 }
 EXPORT_SYMBOL_GPL(pci_tsm_pf0_destructor);
 
@@ -954,16 +955,16 @@ void pci_tsm_unregister(struct tsm_dev *tsm_dev)
 int pci_tsm_doe_transfer(struct pci_dev *pdev, u8 type, const void *req,
 			 size_t req_sz, void *resp, size_t resp_sz)
 {
-	struct pci_tsm_pf0 *tsm;
+	struct pci_tsm_pf0 *pf0;
 
 	if (!pdev->tsm || !is_pci_tsm_pf0(pdev))
 		return -ENXIO;
 
-	tsm = to_pci_tsm_pf0(pdev->tsm);
-	if (!tsm->doe_mb)
+	pf0 = to_pci_tsm_pf0(pdev->tsm);
+	if (!pf0->doe_mb)
 		return -ENXIO;
 
-	return pci_doe(tsm->doe_mb, PCI_VENDOR_ID_PCI_SIG, type, req, req_sz,
+	return pci_doe(pf0->doe_mb, PCI_VENDOR_ID_PCI_SIG, type, req, req_sz,
 		       resp, resp_sz);
 }
 EXPORT_SYMBOL_GPL(pci_tsm_doe_transfer);
diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
index 68ebe774121b..7e91c15ffe3b 100644
--- a/include/linux/pci-tsm.h
+++ b/include/linux/pci-tsm.h
@@ -160,9 +160,9 @@ int pci_tsm_register(struct tsm_dev *tsm_dev);
 void pci_tsm_unregister(struct tsm_dev *tsm_dev);
 int pci_tsm_link_constructor(struct pci_dev *pdev, struct pci_tsm *tsm,
 			     struct tsm_dev *tsm_dev);
-int pci_tsm_pf0_constructor(struct pci_dev *pdev, struct pci_tsm_pf0 *tsm,
+int pci_tsm_pf0_constructor(struct pci_dev *pdev, struct pci_tsm_pf0 *pf0,
 			    struct tsm_dev *tsm_dev);
-void pci_tsm_pf0_destructor(struct pci_tsm_pf0 *tsm);
+void pci_tsm_pf0_destructor(struct pci_tsm_pf0 *pf0);
 int pci_tsm_doe_transfer(struct pci_dev *pdev, u8 type, const void *req,
 			 size_t req_sz, void *resp, size_t resp_sz);
 bool pci_tsm_is_configured(struct pci_dev *pdev);
-- 
2.43.0

