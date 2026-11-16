Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794817210;
	b=b8N1/BfblVmkjm/SMIr9DznXbf0tAhmOg1/Rc6yAwQYC1BSRwUZykEjjfqh/9H7BzuER
	 Sxqwn/oLC0RXpFV6inpJclevn7wvMUoJzUr52iLSYl+jIKVXehfu7YSfFKXuKSzGA9aDU
	 TtM4UV0JShBfZEode0xkkPkhMDSuNJ+BB3edr15WFQLfwX9CNOZf2k/6FyyGncBm+T6Px
	 raGCFlQ22FcpR3iXAh+v8+iSLTrkIzp5PmTjErxBROB+KoPdXNjSRYPTgwA4o3cmiOSuJ
	 spm5ZutAnQva9NVkpc8rTqLvtHZgXnSMSJbdy3NopLUVCRIeCBU5AHpC1YNnGb0vUbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794817210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=LyPjg2E0PNn9cbVAYSizK7C8d7eNwvUHf19SePJDyrM=;
	b=0ZBfilGBk4w2cV3Hll4zDUYnUWDaen3IXes2iQ5Zu6WE9PIm25LN0d6mZCSdWTHHFJCd
	 fGRdwmRTg/Xvvu6GmJRGHXleNnu1vuHqiUHtNoFaVI0PpAlZLg7Xo2CHrbse8tvBxss90
	 ngvt2kzu2zlCQy6V2mGOuzrMH/EfA2zG8JLnLfSKhSBHaWcZZ35RbFxywSagUdzT2dOJE
	 i2nWSjKz6VK6AP6EhNlNgC5P+mH5l+eDKLXZPyq34KBnXBysTETvBg1+bgxddyW4h9FL8
	 AE4YdpUeiyZXmqkhkHkTG2oLyY0LCoU5TT/5KvbpGUNWN+fsxsB6cme9ja/7YpkezLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kP859x1W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055B4606A32A;
	Mon, 16 Nov 2026 08:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kP859x1W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067A11F000C4;
	Mon, 16 Nov 2026 08:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794817209;
	bh=LyPjg2E0PNn9cbVAYSizK7C8d7eNwvUHf19SePJDyrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kP859x1WSILYDy/zuuJg11KME06/c4spUgqW0jxLMZgFIlAaz+CvbjaNXnpGC1vc8
	 4zxLQUgPKAD0EsCLmoc9J+FdvZFIBaFEcak2Srqw99YCQg/B0BcvuiF9Fst6ACunPg
	 u9FnlFQFhLnlSyb3UaYNtGNWIPaalm+OXGxtuMXU7YP8TL6+24nuAsOHFXcmOMZDsu
	 3BbENBpjSanh8Px65co4/qJyRgutY3LLS3m2UQMr6Tfh5uErAjYwP1+AhVy/2PA4ZF
	 rrJr45xildwEp4krCDy39JsAbTWNirjYROhQSWiU4tijownLZqajYWdU/ABWshQuXE
	 BRqZwSfSeUaYQ==
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
	iommu@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v9 02/13] virt: coco: tsm: Remove the device from lookup before PCI teardown
Date: Mon, 16 Nov 2026 13:49:24 +0530
Message-ID: <20261116081935.85372-3-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116081935.85372-1-aneesh.kumar@kernel.org>
References: <20261116081935.85372-1-aneesh.kumar@kernel.org>
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

PCI connect looks up a TSM by ID under pci_tsm_rwsem. Previously,
pci_tsm_unregister() released that lock after tearing down PCI state
while the TSM was still in the class lookup. A racing connect could then
attach a new PCI context that the teardown would never see.

Remove the device from the class lookup first, then take the PCI write
lock to drain in-flight operations and destroy their contexts. Drop the
device reference only after PCI teardown completes.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: linux-coco@lists.linux.dev
Fixes: 3225f52cde56 ("PCI/TSM: Establish Secure Sessions and Link Encryption")
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/tsm-core.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
index 03894c5663f1..57db3f14cf46 100644
--- a/drivers/virt/coco/tsm-core.c
+++ b/drivers/virt/coco/tsm-core.c
@@ -56,23 +56,22 @@ static struct tsm_dev *alloc_tsm_dev(struct device *parent)
 	return no_free_ptr(tsm_dev);
 }
 
-static struct tsm_dev *tsm_register_pci_or_reset(struct tsm_dev *tsm_dev,
-						 struct pci_tsm_ops *pci_ops)
+static int __tsm_register(struct tsm_dev *tsm_dev, struct pci_tsm_ops *pci_ops)
 {
 	int rc;
 
 	tsm_dev->pci_ops = pci_ops;
 	rc = pci_tsm_register(tsm_dev);
 	if (rc) {
+		tsm_dev->pci_ops = NULL;
 		dev_err(tsm_dev->dev.parent,
 			"PCI/TSM registration failure: %d\n", rc);
-		device_unregister(&tsm_dev->dev);
-		return ERR_PTR(rc);
+		return rc;
 	}
 
 	/* Notify TSM userspace that PCI/TSM operations are now possible */
 	kobject_uevent(&tsm_dev->dev.kobj, KOBJ_CHANGE);
-	return tsm_dev;
+	return 0;
 }
 
 struct tsm_dev *tsm_register(struct device *parent, struct pci_tsm_ops *pci_ops)
@@ -96,15 +95,22 @@ struct tsm_dev *tsm_register(struct device *parent, struct pci_tsm_ops *pci_ops)
 	if (rc)
 		return ERR_PTR(rc);
 
-	return tsm_register_pci_or_reset(no_free_ptr(tsm_dev), pci_ops);
+	rc = __tsm_register(tsm_dev, pci_ops);
+	if (rc) {
+		device_del(dev);
+		return ERR_PTR(rc);
+	}
+	return no_free_ptr(tsm_dev);
 }
 EXPORT_SYMBOL_GPL(tsm_register);
 
 void tsm_unregister(struct tsm_dev *tsm_dev)
 {
+	/* Remove the class lookup first. */
+	device_del(&tsm_dev->dev);
 	if (tsm_dev->pci_ops)
 		pci_tsm_unregister(tsm_dev);
-	device_unregister(&tsm_dev->dev);
+	put_device(&tsm_dev->dev);
 }
 EXPORT_SYMBOL_GPL(tsm_unregister);
 
-- 
2.43.0

