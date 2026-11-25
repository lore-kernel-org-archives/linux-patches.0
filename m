Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795594340;
	b=1o9qSTW92lQFQjzYyDjGxD9VOcWnwks8lAsQrFbm7FyRY3yrs/XilYIZsh+1CleRbkXV
	 SLLfTPARxpg0rE81uZkwxBCO8/vu21WrgP6vAB6P7RzCSnCZZ0UKD10vgApJtQR8Sfva2
	 ykdahEwqyd/gAFmIPg709nlC1lsGyPSeysXDUV57hrTLImJ/KpJndZ5Ozw2lEv3EKboqr
	 JHnhVfOq9JEXAqqWe7C5esEW/b/WP4a6Q+Dnu9DVYMb4PGHtj4wPkM2FWoW58be8GiYID
	 2LfYrc/l6Du34PMHFmFiRka0tbmYVqMe854fHGJQAWpCvSDHNHmEriFTzCUQfb8jfYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795594340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=RvTzp89Tia0fpYrJxAuXu38p5PS/XuC5GJr2NcEzDWM=;
	b=lWBrdfcYOgZ3ZP87e8U42KlH+GuLRFEnDPEqcMVIf2Mc21K6socYEepurcODqqmSdE67
	 8G7VmetC8CIAxroJ3nQzkHQGwPvtxEfiU9h0fa8AHYgEjBklNVjtiDgjeqN3fh2D965+v
	 d2rlp7K2T8eES+21EnjMAcgQgPpGuJv7j2Iqd5XZP/jGQ0LfABxlFS/M3XXcMhuNHzcvk
	 P2FdKVKClrR9WmTtsdSMJXBtzxv0Gp12MqCA+8L14OjlIB008IIaFuava7UgGlBx4aLnE
	 lpapBGyDXEYz2x7x2LhJmidZyy9QPM5FzlzzfPY2ivNEbXMhOvlLRA1sw0IEC7KFGtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lCYLzaOU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF16606A31E;
	Wed, 25 Nov 2026 08:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lCYLzaOU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46EA1F0093E;
	Wed, 25 Nov 2026 08:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795594339;
	bh=RvTzp89Tia0fpYrJxAuXu38p5PS/XuC5GJr2NcEzDWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lCYLzaOUlhyNGxUchSmOICkoN8Ffo0DUTWIswDkLGpFvelPOLm7rUiBD9Kx8FSNeD
	 5ic2YUUfBjfne2EXhxlr9YLhl5yaTPrMfD5ffdvRRjRKB3ZYbQKelVjp31z8zIPg3P
	 8oYtydxPAPSGmhPBtYd8xiNx3VaWmAg4Vudh11miAnMWJQchBKCAAaG456dWqYU/Tz
	 AERP765oIqsJ4JK9Iety405O1/93fIVLk4FYH/yP8VFjHRUdMnErd0Ec55lvbqL7Xl
	 bgKtH5YVFjcSfuHnKXe8HAg4Cv1/kUph62hFJOMliNMylfug4fneZvqLF0Rvbr2hTL
	 Id8qbviWd4IpA==
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
Subject: [PATCH v10 03/18] virt: coco: tsm: Remove the device from lookup before PCI teardown
Date: Wed, 25 Nov 2026 13:41:06 +0530
Message-ID: <20261125081121.379481-4-aneesh.kumar@kernel.org>
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

PCI connect looks up a TSM by ID under pci_tsm_rwsem. Previously,
pci_tsm_unregister() released that lock after tearing down PCI state
while the TSM was still in the class lookup. A racing connect could then
attach a new PCI context that the teardown would never see.

Remove the device from the class lookup before pci_tsm_unregister() that
destroy their contexts. Drop the device reference only after PCI
teardown completes.

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
index 3e45b58183e2..863e2f5bb166 100644
--- a/drivers/virt/coco/tsm-core.c
+++ b/drivers/virt/coco/tsm-core.c
@@ -56,8 +56,8 @@ static struct tsm_dev *alloc_tsm_dev(struct device *parent)
 	return no_free_ptr(tsm_dev);
 }
 
-static struct tsm_dev *tsm_register_pci_or_reset(struct tsm_dev *tsm_dev,
-						 struct pci_tsm_ops *pci_ops)
+static int tsm_register_pci_or_reset(struct tsm_dev *tsm_dev,
+				     struct pci_tsm_ops *pci_ops)
 {
 	int rc;
 
@@ -66,13 +66,12 @@ static struct tsm_dev *tsm_register_pci_or_reset(struct tsm_dev *tsm_dev,
 	if (rc) {
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
@@ -96,14 +95,21 @@ struct tsm_dev *tsm_register(struct device *parent, struct pci_tsm_ops *pci_ops)
 	if (rc)
 		return ERR_PTR(rc);
 
-	return tsm_register_pci_or_reset(no_free_ptr(tsm_dev), pci_ops);
+	rc = tsm_register_pci_or_reset(tsm_dev, pci_ops);
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
 	pci_tsm_unregister(tsm_dev);
-	device_unregister(&tsm_dev->dev);
+	put_device(&tsm_dev->dev);
 }
 EXPORT_SYMBOL_GPL(tsm_unregister);
 
-- 
2.43.0

