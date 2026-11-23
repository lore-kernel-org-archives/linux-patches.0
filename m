Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795422891;
	b=Jm6l0vM08bSAtkPz89O429pPMqr1Zbiq6XsNRQOoY1bmawkxYrVy02gVPOg+1OkZKA0J
	 X9zlXJh5slDPmCnWDBIehMB0EJRBZcp5VylJlr6p1wHlmsKC5aQGC3hNhHb9zUuyjbqa+
	 g+ObhMxDEE66wH/sKttzPE0y32TzLZX9SvSHAc8TbcRn0v4OwJ1VGkecuQqWojBh02Bf4
	 YEKWnzJB49XHp2zAhVl+NJn+dkKcmfBCXjm1V7FmuV++OXPZI9VmgYSci3GZK9acEJ6dl
	 T8Yj3qkuOfPPZB7CJWSLo0HTcbjpzUsam9ms7a0ZCm1Cg/AHKzc23Qyv2sYTFx+QH2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795422891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=S0CkxKEZLh+A0zDtgPkkMl7eTxD/0GT3y9yx6j4C4Rg=;
	b=lDn3shTPhrP03VRLuBvlXnf3NrhDGvWYQB5/9mBAEKjggNE0ivU0IjL/fZ1etaNlUUqp
	 Q9/38yiyDuc6A31VVkjvH7jWB/92btgz2kgOGTGEkfB1Og33LClPMp9Ty7Eo5KGUum5SC
	 AChOWYXHC+5wOncPz/4Nzi4v9P3UjcZfhJYdQ+gUbHuF4r0Ilrkmp14WnNGVIk9V08fSa
	 W3TgtKFJ5AVI91ZG/UG29CY5OH+i7GDqgNyg4tloor6SFVhwAtIT0+65rAPFb7PFjN1OR
	 IchevCM7CB0YpTZRoOHVPKaAok6RNYM36DveCVEV/0QJExst3GGdcZUgxbk2bFs8cnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="e3i8D7z/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC7E606A31E;
	Mon, 23 Nov 2026 08:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e3i8D7z/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3A91F000D2;
	Mon, 23 Nov 2026 08:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795422890;
	bh=S0CkxKEZLh+A0zDtgPkkMl7eTxD/0GT3y9yx6j4C4Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e3i8D7z/UB9F5P0vn+JZIEFggFLFqmENbmTom2LP/6YTp8ubOdzmz8NjOlmauqDLU
	 B/FlKPG7bCjRlxfI1Sj76MVHaq79zGBw/w1yMQKrePSZ+G/s3sBgJlHLgxPUyLN3rg
	 Y2HSCQTkO45oeOTkse/QevmHDBgq/xAcze5BG7xl3sJlwvArhC5NGWut2WOmKbfNaM
	 /TIsmRkQDltu3Hgek+G4JR8mv2m/UiqmZjxX3xitYmBPC2K4nRNZJLiMg4//HqtG7p
	 uIJ+A4sVwV+9t3nDBjw0ltz+qMks/FVYOj83JnHWwDbs8tPpzINpIBlSZbIJ6DuRqU
	 OG8vrO819NGOw==
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
Subject: [PATCH v1 10/10] PCI/TSM: Configure accepted device DMA during driver attachment
Date: Mon, 23 Nov 2026 14:03:37 +0530
Message-ID: <20261123083337.2731019-11-aneesh.kumar@kernel.org>
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

Device acceptance and DMA enablement are separate operations. An
accepted device may still need TSM-specific setup before it can perform
DMA.

Add dma_enable and dma_disable callbacks for device-security TSMs. For
TSMs implementing these callbacks, require the device to be accepted
before configuring DMA. Reject drivers setting driver_managed_dma, which
are not supported by this patch.

Take a TSM user reference before DMA configuration and retain it until
DMA cleanup finishes. This also references the TSM device and its driver
module, so tsm_unregister() waits for cleanup and the callback code
remains available. Record whether DMA setup holds this reference in
pci_dev::tsm_dma_pinned.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/pci/pci-driver.c | 31 +++++++++++++-
 drivers/pci/tsm.c        | 89 ++++++++++++++++++++++++++++++++++++++++
 include/linux/pci-tsm.h  | 35 ++++++++++++++--
 include/linux/pci.h      |  1 +
 4 files changed, 152 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 7efe808cdf0c..edabdf30b289 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/pci.h>
+#include <linux/pci-tsm.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/device.h>
@@ -1732,9 +1733,14 @@ static int pci_bus_num_vf(struct device *dev)
 static int pci_dma_configure(struct device *dev)
 {
 	const struct device_driver *drv = READ_ONCE(dev->driver);
+	bool use_default_domain = drv && !to_pci_driver(drv)->driver_managed_dma;
 	struct device *bridge;
 	int ret = 0;
 
+	ret = pci_tsm_dma_prepare(to_pci_dev(dev));
+	if (ret)
+		return ret;
+
 	bridge = pci_get_host_bridge_device(to_pci_dev(dev));
 
 	if (IS_ENABLED(CONFIG_OF) && bridge->parent &&
@@ -1757,12 +1763,34 @@ static int pci_dma_configure(struct device *dev)
 	pci_put_host_bridge_device(bridge);
 
 	/* @drv may not be valid when we're called from the IOMMU layer */
-	if (!ret && drv && !to_pci_driver(drv)->driver_managed_dma) {
+	if (!ret && use_default_domain) {
 		ret = iommu_device_use_default_domain(dev);
 		if (ret)
+			goto err_arch;
+	}
+
+	if (ret)
+		goto err_arch;
+
+	if (drv) {
+		ret = pci_tsm_dma_enable(to_pci_dev(dev));
+		if (ret) {
+			/* Driver core does not call dma_cleanup on this failure. */
+			pci_tsm_dma_cleanup(to_pci_dev(dev));
+			if (use_default_domain)
+				iommu_device_unuse_default_domain(dev);
+
 			arch_teardown_dma_ops(dev);
+			return ret;
+		}
 	}
 
+	return 0;
+
+err_arch:
+	pci_tsm_dma_cleanup(to_pci_dev(dev));
+
+	arch_teardown_dma_ops(dev);
 	return ret;
 }
 
@@ -1770,6 +1798,7 @@ static void pci_dma_cleanup(struct device *dev)
 {
 	struct pci_driver *driver = to_pci_driver(dev->driver);
 
+	pci_tsm_dma_cleanup(to_pci_dev(dev));
 	if (!driver->driver_managed_dma)
 		iommu_device_unuse_default_domain(dev);
 }
diff --git a/drivers/pci/tsm.c b/drivers/pci/tsm.c
index c21066e55d3b..6464670dde08 100644
--- a/drivers/pci/tsm.c
+++ b/drivers/pci/tsm.c
@@ -315,6 +315,92 @@ static bool is_devsec_tsm(struct tsm_dev *tsm_dev)
 	return tsm_dev && tsm_dev->pci_ops && tsm_dev->pci_ops->devsec_ops.lock;
 }
 
+/*
+ * Driver core already holds pdev->dev.mutex. Guest PCI/TSM operations take
+ * that mutex before pci_tsm_rwsem, so the read acquisition can wait here.
+ * The device mutex and refusal to unlock a driver-attached device keep
+ * pdev->tsm unchanged through DMA configuration and driver attachment.
+ */
+int pci_tsm_dma_prepare(struct pci_dev *pdev)
+{
+	const struct pci_tsm_ops *ops;
+	struct pci_tsm *tsm;
+	int ret = 0;
+
+	device_lock_assert(&pdev->dev);
+	if (!pdev->dev.driver)
+		return 0;
+
+	down_read(&pci_tsm_rwsem);
+
+	tsm = pdev->tsm;
+	if (!tsm || !is_devsec_tsm(tsm->tsm_dev))
+		goto out;
+
+	ops = to_pci_tsm_ops(tsm);
+	if (!ops->dma_enable)
+		goto out;
+
+	/* driver_managed_dma is unsupported. */
+	if (to_pci_driver(pdev->dev.driver)->driver_managed_dma) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (!device_cc_accepted(&pdev->dev)) {
+		ret = -EACCES;
+		goto out;
+	}
+
+	/*
+	 * pdev->tsm does not hold a TSM user reference. Take one so
+	 * tsm_unregister() waits until pci_tsm_dma_cleanup() finishes
+	 * calling dma_disable(). tsm_get() also references the TSM device
+	 * and module containing the callbacks.
+	 *
+	 * tsm_dma_pinned records whether DMA setup holds this reference;
+	 * pdev->tsm can also be set when no PCI driver is attached.
+	 */
+	if (IS_ERR(tsm_get(tsm->tsm_dev))) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	pdev->tsm_dma_pinned = true;
+out:
+	up_read(&pci_tsm_rwsem);
+	return ret;
+}
+
+int pci_tsm_dma_enable(struct pci_dev *pdev)
+{
+	device_lock_assert(&pdev->dev);
+	if (!pdev->tsm_dma_pinned)
+		return 0;
+
+	return to_pci_tsm_ops(pdev->tsm)->dma_enable(pdev);
+}
+
+void pci_tsm_dma_cleanup(struct pci_dev *pdev)
+{
+	const struct pci_tsm_ops *ops;
+	struct tsm_dev *tsm_dev;
+	int ret;
+
+	device_lock_assert(&pdev->dev);
+	if (!pdev->tsm_dma_pinned)
+		return;
+
+	ops = to_pci_tsm_ops(pdev->tsm);
+	tsm_dev = pdev->tsm->tsm_dev;
+	ret = ops->dma_disable(pdev);
+	if (ret)
+		/* TODO: Prevent DMA to private memory before releasing the TSM reference. */
+		pci_err(pdev, "Failed to revoke confidential DMA (%d)\n", ret);
+	pdev->tsm_dma_pinned = false;
+	tsm_put_device(tsm_dev);
+}
+
 /**
  * pci_tsm_trylock_association() - Lock and check a PCI function's TSM state
  * @tsm: struct pci_tsm kept allocated by the caller throughout the operation
@@ -1265,6 +1351,9 @@ int pci_tsm_register(struct tsm_dev *tsm_dev)
 	if (is_link_tsm(tsm_dev) && is_devsec_tsm(tsm_dev))
 		return -EINVAL;
 
+	if (!!tsm_dev->pci_ops->dma_enable != !!tsm_dev->pci_ops->dma_disable)
+		return -EINVAL;
+
 	guard(rwsem_write)(&pci_tsm_rwsem);
 
 	/* On first enable, update sysfs groups */
diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
index aef6cfb87082..4da2a24cc0fe 100644
--- a/include/linux/pci-tsm.h
+++ b/include/linux/pci-tsm.h
@@ -24,7 +24,7 @@ struct tsm_dev;
  *		operations).
  * @viommu_get_ops: Return operations for a supported TSM-owned vIOMMU type,
  *		  or NULL if unsupported
- * @owner: Module providing the vIOMMU operations, if built as a module
+ * @owner: Module providing the vIOMMU or DMA operations, if built as a module
  * @prepare_remove: Optional, reject new device operations before TSM unregister
  *		  waits for users, or before forced PF0 removal.
  *
@@ -76,15 +76,22 @@ struct pci_tsm_ops {
 	 *	  pci_tsm') for follow-on security state transitions from the
 	 *	  LOCKED state
 	 * @unlock: destroy TSM context and return device to UNLOCKED state
+	 * @dma_enable: enable DMA after PCI DMA configuration, before probe
+	 * @dma_disable: disable DMA on driver detach or DMA/probe failure
 	 *
 	 * Context: @lock and @unlock run under pci_tsm_rwsem held for write to
 	 * sync with TSM unregistration and each other. All operations run under
-	 * the device lock for mutual exclusion with driver attach and detach.
+	 * device::mutex for mutual exclusion with driver attach and detach.
+	 * @dma_enable and @dma_disable run under device::mutex with the TSM user
+	 * reference held, without pci_tsm_rwsem. They must not acquire
+	 * pci_tsm_rwsem or attestation_dev::lock.
 	 */
 	struct_group_tagged(pci_tsm_devsec_ops, devsec_ops,
 		struct pci_tsm *(*lock)(struct tsm_dev *tsm_dev,
 					struct pci_dev *pdev);
 		void (*unlock)(struct pci_tsm *tsm);
+		int (*dma_enable)(struct pci_dev *pdev);
+		int (*dma_disable)(struct pci_dev *pdev);
 	);
 };
 
@@ -177,6 +184,7 @@ struct pci_tsm_devsec {
 	struct pci_tsm_mmio *mmio;
 };
 
+#ifdef CONFIG_PCI_TSM
 /* physical function0 and capable of 'connect' */
 static inline bool is_pci_tsm_pf0(struct pci_dev *pdev)
 {
@@ -210,7 +218,9 @@ static inline bool is_pci_tsm_pf0(struct pci_dev *pdev)
 	return PCI_FUNC(pdev->devfn) == 0;
 }
 
-#ifdef CONFIG_PCI_TSM
+int pci_tsm_dma_prepare(struct pci_dev *pdev);
+int pci_tsm_dma_enable(struct pci_dev *pdev);
+void pci_tsm_dma_cleanup(struct pci_dev *pdev);
 struct pci_tsm *pci_tsm_trylock_association(struct pci_tsm *tsm);
 void pci_tsm_unlock_association(struct pci_tsm *tsm);
 void pci_tsm_set_ready(struct pci_tsm_pf0 *pf0, bool ready);
@@ -242,6 +252,25 @@ struct pci_tsm_mmio *pci_tsm_mmio_alloc_report(struct pci_dev *pdev,
 					    const void *report_data, size_t report_sz);
 int pci_tsm_mmio_free(struct pci_dev *pdev, struct pci_tsm_mmio *mmio);
 #else
+static inline bool is_pci_tsm_pf0(struct pci_dev *pdev)
+{
+	return false;
+}
+
+static inline int pci_tsm_dma_prepare(struct pci_dev *pdev)
+{
+	return 0;
+}
+
+static inline int pci_tsm_dma_enable(struct pci_dev *pdev)
+{
+	return 0;
+}
+
+static inline void pci_tsm_dma_cleanup(struct pci_dev *pdev)
+{
+}
+
 static inline struct pci_tsm *pci_tsm_trylock_association(struct pci_tsm *tsm)
 {
 	return ERR_PTR(-ENODEV);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index aa3765a20a96..487ef6c5dea6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -581,6 +581,7 @@ struct pci_dev {
 #endif
 #ifdef CONFIG_PCI_TSM
 	struct pci_tsm *tsm;		/* TSM operation state */
+	bool tsm_dma_pinned;		/* DMA binding holds a TSM user reference */
 #endif
 	u16		acs_cap;	/* ACS Capability offset */
 	u16		acs_capabilities; /* ACS Capabilities */
-- 
2.43.0

