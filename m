Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795594352;
	b=EIpLJpP3J8+nYVBnJfBR7u+HEqJrYB0mUovfVH13o2c/Lmm8ba1q+KSJhKaDM4S06uSP
	 WYvHR6b3Gjy3Um1rcd0h3SJ1puIoV1CpgzgeIbtOA87ATmgegs1NsJqbGw1YGkTCcRnFe
	 2CyeceYC1m2VranR9FHqG9d2ZLyxFwVmQQVar5PIbOIXvSedRKpcbkgvGiM2rYJhcaREY
	 WPLLPZ9Ubz8/XDejDx+kOirFhlz8NnBsCTHYlBwOC07Sjhf+KBtAqumDXHgEnufnw3PRj
	 s65buS4GUwgJGTH5dMCwrWOvmq1i+bEejnBYLge5vywc/4Zr0qfsgpdHOAI4mjjZT3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795594352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=aC7Yvp7R/nUyGaPxpcS0Wg+BA10n7Dewov7GQjC+GV8=;
	b=bW+NNg+xKpn+1kRroZJ5CupGd50OeURWLHnxrfjY/2fZsYbjcJwzptsgfqI2C2HeTBkX
	 f0ZMOBvOS5uLPGro44eBvI4TCdYeX6jpMC593VEwzeVZCnBijhLvgBsB016G2v1wDr0E5
	 Y40+xl4TXbjuLyHEfJrVBWc5+FdxLYReIqLNRj4LAadCxKROo/4ZOh/3HcPg4pvD1s0L9
	 E67o3gZm6zpkLLp6RDR2DKXzitxiKJHpUoGDjg7iqLuT3Iu91kl+a4r6bFL0D4u56aJWu
	 /Zam62u+45mz1Ip3ii11JSQl8b+RKVVA649hHDDSzlzaNSFoYNsOXSd9rWndTvjZNTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K92SQg3N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA7F606A31E;
	Wed, 25 Nov 2026 08:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K92SQg3N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D151F000E1;
	Wed, 25 Nov 2026 08:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795594351;
	bh=aC7Yvp7R/nUyGaPxpcS0Wg+BA10n7Dewov7GQjC+GV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K92SQg3N2CI8twZHo/WbVCD7n2//h7W1QmrkrJbmQ0PuwiaLPWniaSFjWeiw7iGr7
	 HP7p4Yj5sjNZ+OPO4kF3KlraX0hE7IVVZKlB6bRiHdWX1nAqTIkrq/abDwDk629BxE
	 LbYvxSeJ/do69BNG9pvlZtp89bOWTN9YpyoIKHYiHfq4RQb0VERwcSQJ6fnHdwf0CI
	 z81eQLrsdnqC306shrYc5Z7F4JBdcWYQ5G1RviKJ+dSH0NvHViaF3oK7RlkN5zjDqb
	 rV2FGrI6Aq93gDgsTAw5CDl2ogam9uUtxJzitRv3l49yGSm5wP/lVlVuUiGSaMoaCs
	 Pgy1UEfDWrfLg==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Alex Williamson <alex@shazbot.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Lukas Wunner <lukas@wunner.de>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Steven Price <steven.price@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	kvm@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v10 04/18] virt: coco: tsm: Complete PCI registration before publishing the device
Date: Wed, 25 Nov 2026 13:41:07 +0530
Message-ID: <20261125081121.379481-5-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261125081121.379481-1-aneesh.kumar@kernel.org>
References: <20261125081121.379481-1-aneesh.kumar@kernel.org>
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

tsm_register() calls device_add() before initializing and validating the
PCI operations. This makes the new TSM discoverable through the class
lookup while PCI registration can still fail.

An existing link TSM can keep the PCI connect attribute visible during
registration of another TSM. A concurrent write naming the new TSM can
therefore reach it through:

  connect_store()
    find_tsm_dev()
      class_find_device()
    is_link_tsm()
    pci_tsm_connect()

If the new backend supplies both link and device security operations,
pci_tsm_register() rejects it before taking pci_tsm_rwsem. The registration
thread then follows:

  tsm_register()
    tsm_register_pci_or_reset()
      pci_tsm_register() -> -EINVAL
    device_del()
    put_tsm_dev()

If connect has already attached a PCI context, registration cleanup can
free a TSM still referenced by that context.

Complete PCI registration before device_add() publishes the class device.
On PCI registration failure, the TSM remains undiscoverable.

Send the PCI change notification only after device_add() succeeds.

Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: linux-coco@lists.linux.dev
Fixes: 3225f52cde56 ("PCI/TSM: Establish Secure Sessions and Link Encryption")
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/tsm-core.c | 34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
index 863e2f5bb166..2fa746d078b3 100644
--- a/drivers/virt/coco/tsm-core.c
+++ b/drivers/virt/coco/tsm-core.c
@@ -56,24 +56,6 @@ static struct tsm_dev *alloc_tsm_dev(struct device *parent)
 	return no_free_ptr(tsm_dev);
 }
 
-static int tsm_register_pci_or_reset(struct tsm_dev *tsm_dev,
-				     struct pci_tsm_ops *pci_ops)
-{
-	int rc;
-
-	tsm_dev->pci_ops = pci_ops;
-	rc = pci_tsm_register(tsm_dev);
-	if (rc) {
-		dev_err(tsm_dev->dev.parent,
-			"PCI/TSM registration failure: %d\n", rc);
-		return rc;
-	}
-
-	/* Notify TSM userspace that PCI/TSM operations are now possible */
-	kobject_uevent(&tsm_dev->dev.kobj, KOBJ_CHANGE);
-	return 0;
-}
-
 struct tsm_dev *tsm_register(struct device *parent, struct pci_tsm_ops *pci_ops)
 {
 	struct tsm_dev *tsm_dev __free(put_tsm_dev) = alloc_tsm_dev(parent);
@@ -91,15 +73,23 @@ struct tsm_dev *tsm_register(struct device *parent, struct pci_tsm_ops *pci_ops)
 	if (rc)
 		return ERR_PTR(rc);
 
-	rc = device_add(dev);
-	if (rc)
+	/* Complete PCI registration before exposing the TSM to class lookup. */
+	tsm_dev->pci_ops = pci_ops;
+	rc = pci_tsm_register(tsm_dev);
+	if (rc) {
+		dev_err(parent, "PCI/TSM registration failure: %d\n", rc);
 		return ERR_PTR(rc);
+	}
 
-	rc = tsm_register_pci_or_reset(tsm_dev, pci_ops);
+	rc = device_add(dev);
 	if (rc) {
-		device_del(dev);
+		pci_tsm_unregister(tsm_dev);
 		return ERR_PTR(rc);
 	}
+
+	/* Notify TSM userspace that PCI/TSM operations are now possible. */
+	kobject_uevent(&dev->kobj, KOBJ_CHANGE);
+
 	return no_free_ptr(tsm_dev);
 }
 EXPORT_SYMBOL_GPL(tsm_register);
-- 
2.43.0

