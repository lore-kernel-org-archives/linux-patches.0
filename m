Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795594466;
	b=MAZWnvkoS+DkyxspeNgZdCmyeUWUDmVQs8gNQcRIS4847pZXFTrwTGu9NlFthtqUIzac
	 QjuX9/0CLKlXzo5w9OUVcBNbk5TipTAH2MD+xA1KL1I2E60YPSeX98TMG65ruGxrwnDKN
	 ni9nLOcUnxzT4bZAOlhSTvQExJoet+xTje8KNrT8V+7LyRL6VbCPSuCef1vgA4Q6tb/4a
	 PQvpsrdlClOWA/Cvs9jUXketvptbRokSNd+ZzouXm1y2vXEuGyRbtv5EK+SJ8raTY0XqM
	 DFvdDwd72ZOrikAJDHNRlsID1Lcl/i9I9Slh08fMRnQqPmGU+FSJ1GNmyX2iPSOKoNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795594466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=VHYKwMKvPACMn5MQeShJE0HU3QErcgbBmjTZnSqlsy0=;
	b=E5RFA9OR5FaSdCi0RtglptLR7hjD7cEj0o/3nuGULin7tAiE2L4pKMmIi9aMFSLrsdVZ
	 gFx7FFoOWPO3+aRq7EgkdBiEpZTooIpletw7zha4oGwml7MPaoTE9Zs/x79+Eku0XajqW
	 qGLFlxfupYxk1jBK+CIDDcmTU/3Q3JjUPt3UXQynqysN41F1+q/5Ud9DE1esEzCl+zEdm
	 h3gRiduqJ1Jf+EVSS8hb+ihDSymAaDxe5sIDGta1G+0hDaSvopz0/Z1dHgC89hhLFttxa
	 qHkWYNy9Ug6duUT1RjTHfMA31ARhwvhGo4x7RR2+R0P5Ic/WjdAbwvYpgTsrbG778WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ftuJ51iu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080CF606A327;
	Wed, 25 Nov 2026 08:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ftuJ51iu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F141F00A00;
	Wed, 25 Nov 2026 08:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795594465;
	bh=VHYKwMKvPACMn5MQeShJE0HU3QErcgbBmjTZnSqlsy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ftuJ51iuKT8qxzSlV3oRYofion3uPTZb0NguEaItP5YhgIPQfX0KbOPl+z6tUfEQI
	 PuZL55ETNQTfYuJWhokBt23P0kyvJZxEeAYlVy30DwTKTg6L/eVk7sQWtNCDWkqSe1
	 xhT6yKyj4EFes7IwRS+uunNz3ebtsLtSvmKiXwYLuassine8f/6wUc9R0uC2439a/Y
	 nOOUgTvL4xt24yBQDqJQ2FOlgbqyMtGCxkkFi0iXd4fhlzwNd+eu8oiJEpBhj3c52R
	 iK/RAGPCfbnU7lsXnbg6jXZ4E72wR2kGq8425BWU7jIQOE7lNCPyoy396rvZ03AStz
	 WrVc5KbX8GHgw==
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
Subject: [PATCH v10 13/18] PCI/TSM: Add helpers to look up and reference a device's TSM
Date: Wed, 25 Nov 2026 13:41:16 +0530
Message-ID: <20261125081121.379481-14-aneesh.kumar@kernel.org>
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

Add tsm_get_device() to find and reference the TSM attached to a device,
using pci_tsm_get_device() for PCI devices. Resolve the PCI association
under pci_tsm_rwsem and acquire TSM device and backend module
references. Return NULL when no TSM is attached and an error if the
module cannot be pinned.

Add tsm_put_device() to release the device reference before the module
reference, since the final device put may call into the backend module.

Set the AMD SEV TSM operations owner to THIS_MODULE so lookup pins the
module implementing its callbacks.

Following patch lets IOMMUFD use vIOMMU operations implemented by the
selected device's TSM. vIOMMU allocation must look up that TSM to find
its operations. The vIOMMU keeps the TSM device and module references
until it is destroyed, so the TSM allocation cannot be freed and its
callback code cannot be unloaded while the vIOMMU can still call it.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/crypto/ccp/sev-dev-tsm.c |  1 +
 drivers/pci/tsm.c                | 19 +++++++++++++++++++
 drivers/virt/coco/tsm-core.c     | 32 ++++++++++++++++++++++++++++++++
 include/linux/pci-tsm.h          | 10 ++++++++++
 include/linux/tsm.h              | 19 +++++++++++++++++++
 5 files changed, 81 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index 46f2539d2d5a..45f2995c3e4d 100644
--- a/drivers/crypto/ccp/sev-dev-tsm.c
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -340,6 +340,7 @@ static void dsm_disconnect(struct pci_dev *pdev)
 }
 
 static struct pci_tsm_ops sev_tsm_ops = {
+	.owner = THIS_MODULE,
 	.probe = dsm_probe,
 	.remove = dsm_remove,
 	.connect = dsm_connect,
diff --git a/drivers/pci/tsm.c b/drivers/pci/tsm.c
index ddff81554372..88e88fc9aec6 100644
--- a/drivers/pci/tsm.c
+++ b/drivers/pci/tsm.c
@@ -9,6 +9,7 @@
 #define dev_fmt(fmt) "PCI/TSM: " fmt
 
 #include <linux/bitfield.h>
+#include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/pci-doe.h>
 #include <linux/pci-tsm.h>
@@ -35,6 +36,24 @@ static const struct pci_tsm_ops *to_pci_tsm_ops(struct pci_tsm *tsm)
 	return tsm->tsm_dev->pci_ops;
 }
 
+struct tsm_dev *pci_tsm_get_device(struct pci_dev *pdev)
+{
+	const struct pci_tsm_ops *ops;
+	struct tsm_dev *tsm_dev;
+
+	guard(rwsem_read)(&pci_tsm_rwsem);
+	if (!pdev->tsm)
+		return NULL;
+
+	tsm_dev = pdev->tsm->tsm_dev;
+	ops = tsm_dev->pci_ops;
+	if (!try_module_get(ops->owner))
+		return ERR_PTR(-ENODEV);
+	get_device(&tsm_dev->dev);
+	return tsm_dev;
+}
+EXPORT_SYMBOL_GPL(pci_tsm_get_device);
+
 static inline bool is_dsm(struct pci_dev *pdev)
 {
 	return pdev->tsm && pdev->tsm->dsm_dev == pdev;
diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
index bf09bb4546de..4f735c628ec3 100644
--- a/drivers/virt/coco/tsm-core.c
+++ b/drivers/virt/coco/tsm-core.c
@@ -16,6 +16,38 @@ static const struct class tsm_class = {
 };
 static DEFINE_IDA(tsm_ida);
 
+/**
+ * tsm_get_device() - Pin the TSM attached to a device
+ * @dev: device whose TSM is to be pinned
+ *
+ * A successful lookup takes a TSM device reference and pins the backend
+ * module. Release both with tsm_put_device(). The TSM must remain registered
+ * while the module is pinned.
+ * Return: NULL if no TSM is attached, an error if the module
+ * cannot be pinned, or the TSM device associated with the pinned backend.
+ */
+struct tsm_dev *tsm_get_device(struct device *dev)
+{
+	if (!dev_is_pci(dev))
+		return NULL;
+
+	return pci_tsm_get_device(to_pci_dev(dev));
+}
+EXPORT_SYMBOL_GPL(tsm_get_device);
+
+void tsm_put_device(struct tsm_dev *tsm_dev)
+{
+	struct module *owner;
+
+	if (!tsm_dev)
+		return;
+
+	owner = tsm_dev->pci_ops->owner;
+	put_device(&tsm_dev->dev);
+	module_put(owner);
+}
+EXPORT_SYMBOL_GPL(tsm_put_device);
+
 static int match_id(struct device *dev, const void *data)
 {
 	struct tsm_dev *tsm_dev = container_of(dev, struct tsm_dev, dev);
diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
index e6fe099f2cc9..6e31faa2c36c 100644
--- a/include/linux/pci-tsm.h
+++ b/include/linux/pci-tsm.h
@@ -4,6 +4,7 @@
 #include <linux/mutex.h>
 #include <linux/pci.h>
 
+struct module;
 struct pci_tsm;
 struct tsm_dev;
 
@@ -15,12 +16,15 @@ struct tsm_dev;
  * @devsec_ops: Lock, unlock, and interrogate the security state of the
  *		function via the platform TSM (typically virtual function
  *		operations).
+ * @owner: Module implementing the PCI TSM operations
  *
  * This operations are mutually exclusive either a tsm_dev instance
  * manages physical link properties or it manages function security
  * states like TDISP lock/unlock.
  */
 struct pci_tsm_ops {
+	struct module *owner;
+
 	/*
 	 * struct pci_tsm_link_ops - Manage physical link and the TSM/DSM session
 	 * @probe: establish context with the TSM (allocate / wrap 'struct
@@ -143,6 +147,7 @@ int pci_tsm_doe_transfer(struct pci_dev *pdev, u8 type, const void *req,
 			 size_t req_sz, void *resp, size_t resp_sz);
 int pci_tsm_context_get(struct pci_dev *pdev, struct tsm_dev *tsm_dev);
 void pci_tsm_context_put(struct pci_dev *pdev);
+struct tsm_dev *pci_tsm_get_device(struct pci_dev *pdev);
 #else
 static inline int pci_tsm_register(struct tsm_dev *tsm_dev)
 {
@@ -152,6 +157,11 @@ static inline void pci_tsm_unregister(struct tsm_dev *tsm_dev)
 {
 }
 
+static inline struct tsm_dev *pci_tsm_get_device(struct pci_dev *pdev)
+{
+	return NULL;
+}
+
 static inline int
 pci_tsm_context_get(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
 {
diff --git a/include/linux/tsm.h b/include/linux/tsm.h
index 19dedf971f14..dc03b2e38eaf 100644
--- a/include/linux/tsm.h
+++ b/include/linux/tsm.h
@@ -124,4 +124,23 @@ int tsm_report_unregister(const struct tsm_report_ops *ops);
 struct tsm_dev *tsm_register(struct device *parent, struct pci_tsm_ops *ops);
 void tsm_unregister(struct tsm_dev *tsm_dev);
 struct tsm_dev *find_tsm_dev(int id);
+
+#ifdef CONFIG_TSM
+struct tsm_dev *tsm_get_device(struct device *dev);
+void tsm_put_device(struct tsm_dev *tsm_dev);
+#else
+static inline struct tsm_dev *tsm_get_device(struct device *dev)
+{
+	return NULL;
+}
+
+static inline void tsm_put_device(struct tsm_dev *tsm_dev)
+{
+}
+#endif
+
+DEFINE_FREE(tsm_put_device, struct tsm_dev *,
+	if (!IS_ERR_OR_NULL(_T))
+		tsm_put_device(_T))
+
 #endif /* __TSM_H */
-- 
2.43.0

