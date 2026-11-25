Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795594490;
	b=ZQ74sup1DPd6c0uRO+LRiTltzr9QgDPAipKhITrU+gS6pTsQ1hECcP1HRXzN890dPP5n
	 VYj5jcyR7R1pH5FApID7nG6LjnXlyaff0gULnZiYrnB5lddsiW90nFr3X2zmRhVA693Ki
	 tNz5yMZeLcFCsyVfSUx0Rb0lBUv2sm62L8AEvE3V1IS0XbPmCsLKzUFUwdSM1YM0Kmblo
	 1bGjAV0YtAW/hdld/RH6lEfPCy4m/691YfW3rdljPA8VJgBXGxWCc529I42suZwqViVUd
	 CxLnJanAH2Eds7p1/Vqfm1sMITXS2Jeo1LiQzWMORvW7gkMnO6aCVxyenjotkp7/5+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795594490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=u9HgPNrADctKV0cNUnNPBxSH8VCeQWXjUobqY+QLmgU=;
	b=2jmPOzjgc2w2QKJor5OQpOmN4gfrtFB4SBbYhtGpdgSPZVVcJZ64D1FNHP+AzDrNvcoc
	 0gicQ9UVuRW6RbysCUnnx2UdO2RgDjIBsTLe6sXITInnah2xnjV/uSl9Q6glAggqOozCP
	 W9U6y4ZwvAdGcoTcnpo//9YqVb+4RZul1P94t97I05c0XNcGzlbKRbUEjQgr830pBFO0P
	 l3jOQ0tIC1tNsgb0hu5pIhJ/1v3vBLB2UJSfLz3DbG1NUA6VisCmcAyCWdbYYGh8RLTx5
	 jlBS1vR2n+y1xAUxlncLDHBypaqCFrl2LQWH/aV8KmvCDiqi+nVOyQp2L1MZ2GwQfWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PEHfmNXy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDC8606A321;
	Wed, 25 Nov 2026 08:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PEHfmNXy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8FB1F000D1;
	Wed, 25 Nov 2026 08:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795594489;
	bh=u9HgPNrADctKV0cNUnNPBxSH8VCeQWXjUobqY+QLmgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PEHfmNXypxAQviZBuzm+SUVG1YH8JH14TjUc1E0Op8Qco8Xc++mVptMeop6M9JHKD
	 eN2D6p2nw6SqCR1HFJ2I5q/DOfKk9V5x3GRJ9YY/YT+XIsbItl3EbmM+Aa7W+3kig0
	 +N7psWRRGrjLZOtV9Uo9v7Hrw+Y2a0q7VxbibJFhbLT/1UjJt3Pr56hPYR59NsXsP8
	 ko6kHlD4LYXUGNsgkKOS5i2TUEowGQFqNyG4OzEoOhtL/14VDbLo8jiOkHstQn+WKB
	 mS99cCkRoVUEWuoHsemmEzt9d7J/myJl8Z1rgFQmUVw+3hzNx9NwFsyQno1UGQRIWP
	 95w4nAOjACOMA==
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
Subject: [PATCH v10 15/18] iommufd/viommu: Allow PCI TSM backends to provide vIOMMU operations
Date: Wed, 25 Nov 2026 13:41:18 +0530
Message-ID: <20261125081121.379481-16-aneesh.kumar@kernel.org>
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

Allow VIOMMU_ALLOC to use the TSM lookup helpers and query its vIOMMU
operations before falling back to the physical IOMMU driver.

Add the PCI TSM viommu_get_ops callback and tsm_viommu_get_ops() helper
to query operations for a requested vIOMMU type.

Add a TSM backing tag and store iommu_dev and tsm_dev in a union.

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Xu Yilun <yilun.xu@linux.intel.com>
Cc: iommu@lists.linux.dev
Cc: linux-pci@vger.kernel.org
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/iommu/iommufd/viommu.c | 60 +++++++++++++++++++++++++---------
 drivers/virt/coco/tsm-core.c   | 11 +++++++
 include/linux/iommufd.h        |  8 ++++-
 include/linux/pci-tsm.h        | 11 +++++++
 include/linux/tsm.h            | 11 +++++++
 5 files changed, 84 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
index dab499d24c45..909ef86f39a9 100644
--- a/drivers/iommu/iommufd/viommu.c
+++ b/drivers/iommu/iommufd/viommu.c
@@ -15,6 +15,10 @@ void iommufd_viommu_destroy(struct iommufd_object *obj)
 
 	if (viommu->ops && viommu->ops->destroy)
 		viommu->ops->destroy(viommu);
+
+	if (viommu->backing == IOMMUFD_VIOMMU_BACKING_TSM)
+		tsm_put_device(viommu->tsm_dev);
+
 	refcount_dec(&viommu->hwpt->common.obj.users);
 	if (viommu->kvm_file)
 		fput(viommu->kvm_file);
@@ -32,7 +36,7 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 	struct iommufd_hwpt_paging *hwpt_paging;
 	struct iommufd_viommu *viommu;
 	struct iommufd_device *idev;
-	struct iommu_device *iommu_dev;
+	struct iommu_device *iommu_dev = NULL;
 	const struct iommufd_viommu_ops *ops;
 	size_t viommu_size;
 	int rc;
@@ -44,20 +48,38 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 	if (IS_ERR(idev))
 		return PTR_ERR(idev);
 
-	iommu_dev = iommufd_device_get_iommu_dev(idev);
-	if (!iommu_dev) {
-		rc = -EOPNOTSUPP;
+	struct tsm_dev *tsm_dev __free(tsm_put_device) = tsm_get_device(idev->dev);
+	if (IS_ERR(tsm_dev)) {
+		rc = PTR_ERR(tsm_dev);
 		goto out_put_idev;
 	}
-	if (!iommu_dev->ops->get_viommu_ops) {
-		rc = -EOPNOTSUPP;
+
+	if (tsm_dev)
+		ops = tsm_viommu_get_ops(tsm_dev, idev->dev, cmd->type);
+	else
+		ops = NULL;
+
+	if (IS_ERR(ops)) {
+		rc = PTR_ERR(ops);
 		goto out_put_idev;
 	}
-	ops = iommu_dev->ops->get_viommu_ops(idev->dev, cmd->type);
+
 	if (!ops) {
-		rc = -EOPNOTSUPP;
-		goto out_put_idev;
+		tsm_put_device(no_free_ptr(tsm_dev));
+
+		iommu_dev = iommufd_device_get_iommu_dev(idev);
+		if (!iommu_dev || !iommu_dev->ops->get_viommu_ops) {
+			rc = -EOPNOTSUPP;
+			goto out_put_idev;
+		}
+
+		ops = iommu_dev->ops->get_viommu_ops(idev->dev, cmd->type);
+		if (!ops) {
+			rc = -EOPNOTSUPP;
+			goto out_put_idev;
+		}
 	}
+
 	/*
 	 * It is a driver bug to omit the required operations or provide a size
 	 * smaller than the core vIOMMU structure.
@@ -100,13 +122,19 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 	refcount_inc(&viommu->hwpt->common.obj.users);
 	INIT_LIST_HEAD(&viommu->veventqs);
 	init_rwsem(&viommu->veventqs_rwsem);
-	/*
-	 * It is the most likely case that a physical IOMMU is unpluggable. A
-	 * pluggable IOMMU instance (if exists) is responsible for refcounting
-	 * on its own.
-	 */
-	viommu->backing = IOMMUFD_VIOMMU_BACKING_IOMMU;
-	viommu->iommu_dev = iommu_dev;
+
+	if (tsm_dev) {
+		viommu->backing = IOMMUFD_VIOMMU_BACKING_TSM;
+		viommu->tsm_dev = no_free_ptr(tsm_dev);
+	} else {
+		/*
+		 * It is the most likely case that a physical IOMMU is unpluggable.
+		 * A pluggable IOMMU instance (if exists) is responsible for
+		 * refcounting on its own.
+		 */
+		viommu->backing = IOMMUFD_VIOMMU_BACKING_IOMMU;
+		viommu->iommu_dev = iommu_dev;
+	}
 
 	rc = ops->viommu_init(viommu, idev->dev,
 			      hwpt_paging->common.domain,
diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
index 4f735c628ec3..8cb6fdaf8a84 100644
--- a/drivers/virt/coco/tsm-core.c
+++ b/drivers/virt/coco/tsm-core.c
@@ -9,6 +9,17 @@
 #include <linux/cleanup.h>
 #include <linux/pci-tsm.h>
 
+/* The caller must hold a tsm_get_device() reference for the entire use. */
+const struct iommufd_viommu_ops *tsm_viommu_get_ops(struct tsm_dev *tsm_dev,
+		struct device *dev, enum iommu_viommu_type type)
+{
+	if (!tsm_dev->pci_ops->viommu_get_ops)
+		return NULL;
+
+	return tsm_dev->pci_ops->viommu_get_ops(dev, type);
+}
+EXPORT_SYMBOL_GPL(tsm_viommu_get_ops);
+
 static void tsm_release(struct device *);
 static const struct class tsm_class = {
 	.name		= "tsm",
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 192d46b8ccfd..77c1a2944c3b 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -23,6 +23,7 @@ struct iommufd_access;
 struct iommufd_ctx;
 struct iommufd_device;
 struct iommufd_viommu_ops;
+struct tsm_dev;
 struct page;
 
 enum iommufd_object_type {
@@ -100,13 +101,18 @@ void iommufd_ctx_get(struct iommufd_ctx *ictx);
 
 enum iommufd_viommu_backing {
 	IOMMUFD_VIOMMU_BACKING_IOMMU,
+	IOMMUFD_VIOMMU_BACKING_TSM,
 };
 
 struct iommufd_viommu {
 	struct iommufd_object obj;
 	struct iommufd_ctx *ictx;
 	enum iommufd_viommu_backing backing;
-	struct iommu_device *iommu_dev;
+	union {
+		struct iommu_device *iommu_dev;
+		struct tsm_dev *tsm_dev;
+	};
+
 	struct iommufd_hwpt_paging *hwpt;
 	struct file *kvm_file;
 
diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
index 6e31faa2c36c..44895c585d75 100644
--- a/include/linux/pci-tsm.h
+++ b/include/linux/pci-tsm.h
@@ -3,7 +3,9 @@
 #define __PCI_TSM_H
 #include <linux/mutex.h>
 #include <linux/pci.h>
+#include <uapi/linux/iommufd.h>
 
+struct iommufd_viommu_ops;
 struct module;
 struct pci_tsm;
 struct tsm_dev;
@@ -16,14 +18,23 @@ struct tsm_dev;
  * @devsec_ops: Lock, unlock, and interrogate the security state of the
  *		function via the platform TSM (typically virtual function
  *		operations).
+ * @viommu_get_ops: Return operations for a supported TSM-owned vIOMMU type,
+ *		  or NULL if unsupported
  * @owner: Module implementing the PCI TSM operations
  *
+ * The vIOMMU owner holds a TSM device reference and pins the backend module
+ * before querying @viommu_get_ops, releasing both after vIOMMU destruction.
+ * A backend providing this callback must not unregister its TSM while the
+ * module is pinned.
+ *
  * This operations are mutually exclusive either a tsm_dev instance
  * manages physical link properties or it manages function security
  * states like TDISP lock/unlock.
  */
 struct pci_tsm_ops {
 	struct module *owner;
+	const struct iommufd_viommu_ops *(*viommu_get_ops)(
+		struct device *dev, enum iommu_viommu_type type);
 
 	/*
 	 * struct pci_tsm_link_ops - Manage physical link and the TSM/DSM session
diff --git a/include/linux/tsm.h b/include/linux/tsm.h
index dc03b2e38eaf..a1c805d6342f 100644
--- a/include/linux/tsm.h
+++ b/include/linux/tsm.h
@@ -110,6 +110,8 @@ struct tsm_report_ops {
 };
 
 struct pci_tsm_ops;
+struct iommufd_viommu_ops;
+
 struct tsm_dev {
 	struct device dev;
 	int id;
@@ -128,6 +130,8 @@ struct tsm_dev *find_tsm_dev(int id);
 #ifdef CONFIG_TSM
 struct tsm_dev *tsm_get_device(struct device *dev);
 void tsm_put_device(struct tsm_dev *tsm_dev);
+const struct iommufd_viommu_ops *tsm_viommu_get_ops(struct tsm_dev *tsm_dev,
+		struct device *dev, enum iommu_viommu_type type);
 #else
 static inline struct tsm_dev *tsm_get_device(struct device *dev)
 {
@@ -137,6 +141,13 @@ static inline struct tsm_dev *tsm_get_device(struct device *dev)
 static inline void tsm_put_device(struct tsm_dev *tsm_dev)
 {
 }
+
+static inline const struct iommufd_viommu_ops *
+tsm_viommu_get_ops(struct tsm_dev *tsm_dev, struct device *dev,
+		enum iommu_viommu_type type)
+{
+	return NULL;
+}
 #endif
 
 DEFINE_FREE(tsm_put_device, struct tsm_dev *,
-- 
2.43.0

