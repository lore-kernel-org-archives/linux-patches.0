Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794817274;
	b=rl4MaK2e/XKRLkphk3LTz/t5oUDLQfj1RYh2IASyYX3zrims3bxbjiyiJ9WLp5d9s+q2
	 5Q64XNt2FsDp8crkuaVO5tFOb99e8Z+DQP33SK2je0TLbafHjHYd5tOts2USbCAlliObO
	 Oz9F3aRMNLbDDP8LxsLV572ysTgNpxintlYixvnRS4g99yB/Xfxvt6/AyU7bhL1Z2LJiH
	 ynldktZj3CWGYO+7OOTn1a66PlWKdy6t9swrWfsn+lK/Ycp/QtfsdS95Tjt9T/wPwS0o3
	 P8G8qPkhu80IqiuZ42D0L2jsZTEMRwTOax/de9uWwkTZNuV5gKZHHPagz4jNpoGA9+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794817274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=SWGlckkH35wtCcy87Jb4lWaJ8+KZobeCBU+VnO/JtTs=;
	b=Cj29RDlweYvJmRQSS/OIj5GeweK75sKRXV/IueshdiHu/eTpRNQhtgmqID0+wKWC7ay2
	 Kmvf+zMoRNr1qpujkMmaX33mD1/C29X3AbxlxodcaGU4kmxcorzWbFPR//MT7oZD0GTxh
	 h3wkNGoqr38AgsE2g6l08mNzWJreqQ4bWo10anxIxmZrIyJjgg0CSTaAuJ9LBT/4FlrlR
	 5VCUkChi5qtHExWWqTYeAlFJ7mYid3eWl5h1pXJ74S5GlQLYMuVGSV/aFhwjHzsFwZup2
	 amUB1fp12IVcUC2BmDPsdYEj0lD0IRuuUr0otCKJ6VVRgFu8sQovPpxXBN1HJb2wt2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J9xlQ9e8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045C6606A32C;
	Mon, 16 Nov 2026 08:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J9xlQ9e8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACAD1F000C4;
	Mon, 16 Nov 2026 08:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794817273;
	bh=SWGlckkH35wtCcy87Jb4lWaJ8+KZobeCBU+VnO/JtTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J9xlQ9e80ShWSlxHqOHc+EDP2jbUEcSO+C/6Aw7sSXUpqgxJmVBRDmKv1xo8Ai07f
	 hOphGU2E4Dp+6V7vM1iT9nvQavem1llpRchYhk+EQsEFImG+vnhka17roIVc1Vexmy
	 Xc5P7KL3RHJacVhfVBOlLEJpwdpkPDnKZt8RWLY4hqvuk9uPZj/bLWMEKkw5nau+cQ
	 JFDKBnj2yDImlNNdwWihDgwsCtN8mcyVWwj71GeTy/+qFkK6qmJdZlGyEToHE0feq0
	 sGAAOXFsVFlZCocQ0FZ1/QkI/Fn1845bd4JIY+cLvVlXJmq7mhkf3JKKWR49zigfpc
	 3ZKNJGbbx1M0g==
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
Subject: [PATCH v9 08/13] PCI/TSM: Keep connections active while device contexts exist
Date: Mon, 16 Nov 2026 13:49:30 +0530
Message-ID: <20261116081935.85372-9-aneesh.kumar@kernel.org>
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

Add PCI TEE Security Manager (TSM) contexts that prevent PF0 disconnect
while in use. Verify that the device is connected to the requested TSM.
Each successful get returns a separate context and requires a matching
put. Reject disconnect with -EBUSY until all contexts are released.

Remove the legacy bind and unbind interface. Device security state is
managed by the backend, so also remove the associated "bound" sysfs
attribute and its ABI documentation.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/ABI/testing/sysfs-bus-pci |  15 +-
 drivers/pci/tsm/core.c                  | 227 ++++++++++--------------
 include/linux/pci-tsm.h                 |  71 +++++---
 3 files changed, 136 insertions(+), 177 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index be9126e56894..ab9083f3b0d3 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -660,6 +660,7 @@ Contact:	linux-coco@lists.linux.dev
 Description:
 		(WO) Write the name of the TSM device that was specified
 		to 'connect' to teardown the connection.
+		The write fails with EBUSY if the TSM is in use.
 
 What:		/sys/bus/pci/devices/.../tsm/dsm
 Contact:	linux-coco@lists.linux.dev
@@ -677,20 +678,6 @@ Description:	(RO) Return PCI device name of this device's DSM (Device
 		PCIe switch port. This is a "link" TSM attribute, see
 		Documentation/ABI/testing/sysfs-class-tsm.
 
-What:		/sys/bus/pci/devices/.../tsm/bound
-Contact:	linux-coco@lists.linux.dev
-Description:	(RO) Return the device name of the TSM when the device is in a
-		TDISP (TEE Device Interface Security Protocol) operational state
-		(LOCKED, RUN, or ERROR, not UNLOCKED). Bound devices consume
-		platform TSM resources and depend on the device's configuration
-		(e.g. BME (Bus Master Enable) and MSE (Memory Space Enable)
-		among other settings) to remain stable for the duration of the
-		bound state. This attribute is only visible for devices that
-		support TDISP operation, and it is only populated after
-		successful connect and TSM bind. The TSM bind operation is
-		initiated by VFIO/IOMMUFD. This is a "link" TSM attribute, see
-		Documentation/ABI/testing/sysfs-class-tsm.
-
 What:		/sys/bus/pci/devices/.../authenticated
 Contact:	linux-pci@vger.kernel.org
 Description:
diff --git a/drivers/pci/tsm/core.c b/drivers/pci/tsm/core.c
index 24d4dd4f1b96..8f0e5af808a5 100644
--- a/drivers/pci/tsm/core.c
+++ b/drivers/pci/tsm/core.c
@@ -12,6 +12,7 @@
 #include <linux/pci.h>
 #include <linux/pci-doe.h>
 #include <linux/pci-tsm.h>
+#include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/tsm.h>
 #include <linux/xarray.h>
@@ -292,96 +293,100 @@ static int remove_fn(struct pci_dev *pdev, void *data)
 	return 0;
 }
 
-/*
- * Note, this helper only returns an error code and takes an argument for
- * compatibility with the pci_walk_bus() callback prototype. pci_tsm_unbind()
- * always succeeds.
- */
-static int __pci_tsm_unbind(struct pci_dev *pdev, void *data)
+bool pci_tsm_is_configured(struct pci_dev *pdev)
 {
-	struct pci_tdi *tdi;
-	struct pci_tsm_pf0 *tsm_pf0;
-
-	lockdep_assert_held(&pci_tsm_rwsem);
-
-	if (!pdev->tsm)
-		return 0;
-
-	tsm_pf0 = to_pci_tsm_pf0(pdev->tsm);
-	guard(mutex)(&tsm_pf0->lock);
-
-	tdi = pdev->tsm->tdi;
-	if (!tdi)
-		return 0;
-
-	to_pci_tsm_ops(pdev->tsm)->unbind(tdi);
-	pdev->tsm->tdi = NULL;
+	guard(rwsem_read)(&pci_tsm_rwsem);
 
-	return 0;
+	return !!pdev->tsm;
 }
+EXPORT_SYMBOL_GPL(pci_tsm_is_configured);
 
-void pci_tsm_unbind(struct pci_dev *pdev)
-{
-	guard(rwsem_read)(&pci_tsm_rwsem);
-	__pci_tsm_unbind(pdev, NULL);
-}
-EXPORT_SYMBOL_GPL(pci_tsm_unbind);
+struct pci_tsm_context {
+	struct pci_tsm_pf0 *pf0;
+	struct pci_dev *pdev;
+	struct pci_dev *dsm_dev;
+};
 
 /**
- * pci_tsm_bind() - Bind @pdev as a TDI for @kvm
- * @pdev: PCI device function to bind
- * @kvm: Private memory attach context
- * @tdi_id: Identifier (virtual BDF) for the TDI as referenced by the TSM and DSM
+ * pci_tsm_context_get() - Keep a device's PF0 TSM connection active
+ * @pdev: PCI function whose PF0 TSM connection must remain active
+ * @tsm_dev: TSM that must manage the device's connection
  *
- * Returns 0 on success, or a negative error code on failure.
+ * Verify that @pdev is connected to @tsm_dev and prevent its PF0 connection
+ * from being disconnected until pci_tsm_context_put() releases the context.
+ * Each successful call allocates a separate context, even for the same device,
+ * and requires a matching pci_tsm_context_put().
  *
- * Context: Caller is responsible for constraining the bind lifetime to the
- * registered state of the device. For example, pci_tsm_bind() /
- * pci_tsm_unbind() limited to the VFIO driver bound state of the device.
+ * Return: A new context, or an error pointer on failure.
  */
-int pci_tsm_bind(struct pci_dev *pdev, struct kvm *kvm, u32 tdi_id)
+struct pci_tsm_context *pci_tsm_context_get(struct pci_dev *pdev,
+					    struct tsm_dev *tsm_dev)
 {
-	struct pci_tsm_pf0 *tsm_pf0;
-	struct pci_tdi *tdi;
-
-	if (!kvm)
-		return -EINVAL;
+	struct pci_tsm_context *context;
+	struct pci_tsm_pf0 *pf0;
 
 	guard(rwsem_read)(&pci_tsm_rwsem);
+	if (!pdev->tsm || !is_link_tsm(pdev->tsm->tsm_dev))
+		return ERR_PTR(-EOPNOTSUPP);
 
-	if (!pdev->tsm)
-		return -EINVAL;
+	/* The device must be connected to the TSM requested by the caller. */
+	if (pdev->tsm->tsm_dev != tsm_dev)
+		return ERR_PTR(-EXDEV);
 
-	if (!is_link_tsm(pdev->tsm->tsm_dev))
-		return -ENXIO;
+	context = kzalloc_obj(*context);
+	if (!context)
+		return ERR_PTR(-ENOMEM);
 
-	tsm_pf0 = to_pci_tsm_pf0(pdev->tsm);
-	guard(mutex)(&tsm_pf0->lock);
+	pf0 = to_pci_tsm_pf0(pdev->tsm);
+	guard(mutex)(&pf0->lock);
+	pf0->context_users++;
+	context->pf0 = pf0;
+	context->pdev = pci_dev_get(pdev);
+	context->dsm_dev = pci_dev_get(pf0->base_tsm.pdev);
+	return context;
+}
+EXPORT_SYMBOL_GPL(pci_tsm_context_get);
 
-	/* Resolve races to bind a TDI */
-	if (pdev->tsm->tdi) {
-		if (pdev->tsm->tdi->kvm != kvm)
-			return -EBUSY;
-		return 0;
-	}
+void pci_tsm_context_put(struct pci_tsm_context *context)
+{
+	struct pci_tsm_pf0 *pf0 = context->pf0;
+
+	down_read(&pci_tsm_rwsem);
+	mutex_lock(&pf0->lock);
+	if (!WARN_ON(!pf0->context_users))
+		pf0->context_users--;
+	mutex_unlock(&pf0->lock);
+	up_read(&pci_tsm_rwsem);
 
-	tdi = to_pci_tsm_ops(pdev->tsm)->bind(pdev, kvm, tdi_id);
-	if (IS_ERR(tdi))
-		return PTR_ERR(tdi);
+	pci_dev_put(context->pdev);
+	pci_dev_put(context->dsm_dev);
+	kfree(context);
+}
+EXPORT_SYMBOL_GPL(pci_tsm_context_put);
 
-	pdev->tsm->tdi = tdi;
+struct pci_tsm_pf0 *pci_tsm_context_pf0(struct pci_tsm_context *context)
+{
+	return context->pf0;
+}
+EXPORT_SYMBOL_GPL(pci_tsm_context_pf0);
 
-	return 0;
+struct pci_dev *pci_tsm_context_dsm_dev(struct pci_tsm_context *context)
+{
+	return context->dsm_dev;
 }
-EXPORT_SYMBOL_GPL(pci_tsm_bind);
+EXPORT_SYMBOL_GPL(pci_tsm_context_dsm_dev);
 
-static void pci_tsm_unbind_all(struct pci_dev *pdev)
+bool pci_tsm_context_match_device(struct pci_tsm_context *context,
+				  struct pci_dev *pdev)
 {
-	pci_tsm_walk_fns_reverse(pdev, __pci_tsm_unbind, NULL);
-	__pci_tsm_unbind(pdev, NULL);
+	guard(rwsem_read)(&pci_tsm_rwsem);
+
+	return pdev->tsm && is_link_tsm(pdev->tsm->tsm_dev) &&
+	       to_pci_tsm_pf0(pdev->tsm) == context->pf0;
 }
+EXPORT_SYMBOL_GPL(pci_tsm_context_match_device);
 
-static void __pci_tsm_disconnect(struct pci_dev *pdev)
+static int __pci_tsm_disconnect(struct pci_dev *pdev)
 {
 	struct pci_tsm_pf0 *tsm_pf0 = to_pci_tsm_pf0(pdev->tsm);
 	const struct pci_tsm_ops *ops = to_pci_tsm_ops(pdev->tsm);
@@ -389,21 +394,28 @@ static void __pci_tsm_disconnect(struct pci_dev *pdev)
 	/* disconnect() mutually exclusive with subfunction pci_tsm_init() */
 	lockdep_assert_held_write(&pci_tsm_rwsem);
 
-	pci_tsm_unbind_all(pdev);
-
 	/*
-	 * disconnect() is uninterruptible as it may be called for device
-	 * teardown
+	 * Refuse to disconnect the link until all contexts have been released.
+	 *
+	 * disconnect() is uninterruptible as it may also be called for device
+	 * teardown.
 	 */
 	guard(mutex)(&tsm_pf0->lock);
+	if (tsm_pf0->context_users)
+		return -EBUSY;
 	pci_tsm_walk_fns_reverse(pdev, remove_fn, NULL);
 	ops->disconnect(pdev);
+	return 0;
 }
 
-static void pci_tsm_disconnect(struct pci_dev *pdev)
+static int pci_tsm_disconnect(struct pci_dev *pdev)
 {
-	__pci_tsm_disconnect(pdev);
+	int ret = __pci_tsm_disconnect(pdev);
+
+	if (ret)
+		return ret;
 	tsm_remove(pdev->tsm);
+	return 0;
 }
 
 static ssize_t disconnect_store(struct device *dev,
@@ -425,38 +437,13 @@ static ssize_t disconnect_store(struct device *dev,
 	if (!sysfs_streq(buf, dev_name(&tsm_dev->dev)))
 		return -EINVAL;
 
-	pci_tsm_disconnect(pdev);
+	rc = pci_tsm_disconnect(pdev);
+	if (rc)
+		return rc;
 	return len;
 }
 static DEVICE_ATTR_WO(disconnect);
 
-static ssize_t bound_show(struct device *dev,
-			  struct device_attribute *attr, char *buf)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct pci_tsm_pf0 *tsm_pf0;
-	struct pci_tsm *tsm;
-	int rc;
-
-	ACQUIRE(rwsem_read_intr, lock)(&pci_tsm_rwsem);
-	if ((rc = ACQUIRE_ERR(rwsem_read_intr, &lock)))
-		return rc;
-
-	tsm = pdev->tsm;
-	if (!tsm)
-		return sysfs_emit(buf, "\n");
-	tsm_pf0 = to_pci_tsm_pf0(tsm);
-
-	ACQUIRE(mutex_intr, ops_lock)(&tsm_pf0->lock);
-	if ((rc = ACQUIRE_ERR(mutex_intr, &ops_lock)))
-		return rc;
-
-	if (!tsm->tdi)
-		return sysfs_emit(buf, "\n");
-	return sysfs_emit(buf, "%s\n", dev_name(&tsm->tsm_dev->dev));
-}
-static DEVICE_ATTR_RO(bound);
-
 static ssize_t dsm_show(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
@@ -511,13 +498,6 @@ static umode_t pci_tsm_attr_visible(struct kobject *kobj,
 	if (pci_tsm_link_group_visible(kobj)) {
 		struct pci_dev *pdev = to_pci_dev(kobj_to_dev(kobj));
 
-		if (attr == &dev_attr_bound.attr) {
-			if (is_pci_tsm_pf0(pdev) && has_tee(pdev))
-				return attr->mode;
-			if (pdev->tsm && has_tee(pdev->tsm->dsm_dev))
-				return attr->mode;
-		}
-
 		if (attr == &dev_attr_dsm.attr) {
 			if (is_pci_tsm_pf0(pdev))
 				return attr->mode;
@@ -544,7 +524,6 @@ DEFINE_SYSFS_GROUP_VISIBLE(pci_tsm);
 static struct attribute *pci_tsm_attrs[] = {
 	&dev_attr_connect.attr,
 	&dev_attr_disconnect.attr,
-	&dev_attr_bound.attr,
 	&dev_attr_dsm.attr,
 	NULL
 };
@@ -634,22 +613,6 @@ static struct pci_dev *find_dsm_dev(struct pci_dev *pdev)
 	return NULL;
 }
 
-/**
- * pci_tsm_tdi_constructor() - base 'struct pci_tdi' initialization for link TSMs
- * @pdev: PCI device function representing the TDI
- * @tdi: context to initialize
- * @kvm: Private memory attach context
- * @tdi_id: Identifier (virtual BDF) for the TDI as referenced by the TSM and DSM
- */
-void pci_tsm_tdi_constructor(struct pci_dev *pdev, struct pci_tdi *tdi,
-			     struct kvm *kvm, u32 tdi_id)
-{
-	tdi->pdev = pdev;
-	tdi->kvm = kvm;
-	tdi->tdi_id = tdi_id;
-}
-EXPORT_SYMBOL_GPL(pci_tsm_tdi_constructor);
-
 /**
  * pci_tsm_link_constructor() - base 'struct pci_tsm' initialization for link TSMs
  * @pdev: The PCI device
@@ -729,12 +692,6 @@ int pci_tsm_register(struct tsm_dev *tsm_dev)
 	return 0;
 }
 
-static void pci_tsm_fn_exit(struct pci_dev *pdev)
-{
-	__pci_tsm_unbind(pdev, NULL);
-	tsm_remove(pdev->tsm);
-}
-
 /**
  * __pci_tsm_destroy() - destroy the TSM context for @pdev
  * @pdev: device to cleanup
@@ -768,10 +725,12 @@ static void __pci_tsm_destroy(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
 	else if (tsm_dev != tsm->tsm_dev)
 		return;
 
-	if (is_link_tsm(tsm_dev) && is_pci_tsm_pf0(pdev))
-		pci_tsm_disconnect(pdev);
-	else
-		pci_tsm_fn_exit(pdev);
+	if (is_link_tsm(tsm_dev) && is_pci_tsm_pf0(pdev)) {
+		if (pci_tsm_disconnect(pdev))
+			pci_warn(pdev, "TSM connection is still in use\n");
+	} else {
+		tsm_remove(pdev->tsm);
+	}
 }
 
 void pci_tsm_destroy(struct pci_dev *pdev)
diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
index 6fe3d0ea875f..1458935234a4 100644
--- a/include/linux/pci-tsm.h
+++ b/include/linux/pci-tsm.h
@@ -5,8 +5,8 @@
 #include <linux/pci.h>
 
 struct pci_tsm;
+struct pci_tsm_context;
 struct tsm_dev;
-struct kvm;
 
 /*
  * struct pci_tsm_ops - manage confidential links and security state
@@ -30,16 +30,12 @@ struct pci_tsm_ops {
 	 * @connect: establish / validate a secure connection (e.g. IDE)
 	 *	     with the device
 	 * @disconnect: teardown the secure link
-	 * @bind: bind a TDI in preparation for it to be accepted by a TVM
-	 * @unbind: remove a TDI from secure operation with a TVM
 	 *
 	 * Context: @probe, @remove, @connect, and @disconnect run under
 	 * pci_tsm_rwsem held for write to sync with TSM unregistration and
 	 * mutual exclusion of @connect and @disconnect. @connect and
 	 * @disconnect additionally run under the DSM lock (struct
 	 * pci_tsm_pf0::lock) as well as @probe and @remove of the subfunctions.
-	 * @bind and @unbind run under pci_tsm_rwsem held for read
-	 * and the DSM lock.
 	 */
 	struct_group_tagged(pci_tsm_link_ops, link_ops,
 		struct pci_tsm *(*probe)(struct tsm_dev *tsm_dev,
@@ -47,9 +43,6 @@ struct pci_tsm_ops {
 		void (*remove)(struct pci_tsm *tsm);
 		int (*connect)(struct pci_dev *pdev);
 		void (*disconnect)(struct pci_dev *pdev);
-		struct pci_tdi *(*bind)(struct pci_dev *pdev,
-					struct kvm *kvm, u32 tdi_id);
-		void (*unbind)(struct pci_tdi *tdi);
 	);
 
 	/*
@@ -69,25 +62,12 @@ struct pci_tsm_ops {
 	);
 };
 
-/**
- * struct pci_tdi - Core TEE I/O Device Interface (TDI) context
- * @pdev: host side representation of guest-side TDI
- * @kvm: TEE VM context of bound TDI
- * @tdi_id: Identifier (virtual BDF) for the TDI as referenced by the TSM and DSM
- */
-struct pci_tdi {
-	struct pci_dev *pdev;
-	struct kvm *kvm;
-	u32 tdi_id;
-};
-
 /**
  * struct pci_tsm - Core TSM context for a given PCIe endpoint
  * @pdev: Back ref to device function, distinguishes type of pci_tsm context
  * @dsm_dev: PCI Device Security Manager for link operations on @pdev
  * @tsm_dev: PCI TEE Security Manager device for Link Confidentiality or Device
  *	     Function Security operations
- * @tdi: TDI context established by the @bind link operation
  *
  * This structure is wrapped by low level TSM driver data and returned by
  * probe()/lock(), it is freed by the corresponding remove()/unlock().
@@ -103,18 +83,20 @@ struct pci_tsm {
 	struct pci_dev *pdev;
 	struct pci_dev *dsm_dev;
 	struct tsm_dev *tsm_dev;
-	struct pci_tdi *tdi;
 };
 
 /**
  * struct pci_tsm_pf0 - Physical Function 0 TDISP link context
  * @base_tsm: generic core "tsm" context
  * @lock: mutual exclustion for pci_tsm_ops invocation
+ * @context_users: live per-function contexts on this PF0; a nonzero count
+ *	blocks link disconnect
  * @doe_mb: PCIe Data Object Exchange mailbox
  */
 struct pci_tsm_pf0 {
 	struct pci_tsm base_tsm;
 	struct mutex lock;
+	unsigned int context_users;
 	struct pci_doe_mb *doe_mb;
 };
 
@@ -161,10 +143,14 @@ int pci_tsm_pf0_constructor(struct pci_dev *pdev, struct pci_tsm_pf0 *tsm,
 void pci_tsm_pf0_destructor(struct pci_tsm_pf0 *tsm);
 int pci_tsm_doe_transfer(struct pci_dev *pdev, u8 type, const void *req,
 			 size_t req_sz, void *resp, size_t resp_sz);
-int pci_tsm_bind(struct pci_dev *pdev, struct kvm *kvm, u32 tdi_id);
-void pci_tsm_unbind(struct pci_dev *pdev);
-void pci_tsm_tdi_constructor(struct pci_dev *pdev, struct pci_tdi *tdi,
-			     struct kvm *kvm, u32 tdi_id);
+bool pci_tsm_is_configured(struct pci_dev *pdev);
+struct pci_tsm_context *pci_tsm_context_get(struct pci_dev *pdev,
+					    struct tsm_dev *tsm_dev);
+void pci_tsm_context_put(struct pci_tsm_context *context);
+struct pci_tsm_pf0 *pci_tsm_context_pf0(struct pci_tsm_context *context);
+struct pci_dev *pci_tsm_context_dsm_dev(struct pci_tsm_context *context);
+bool pci_tsm_context_match_device(struct pci_tsm_context *context,
+				  struct pci_dev *pdev);
 #else
 static inline int pci_tsm_register(struct tsm_dev *tsm_dev)
 {
@@ -173,12 +159,39 @@ static inline int pci_tsm_register(struct tsm_dev *tsm_dev)
 static inline void pci_tsm_unregister(struct tsm_dev *tsm_dev)
 {
 }
-static inline int pci_tsm_bind(struct pci_dev *pdev, struct kvm *kvm, u64 tdi_id)
+
+static inline bool pci_tsm_is_configured(struct pci_dev *pdev)
 {
-	return -ENXIO;
+	return false;
 }
-static inline void pci_tsm_unbind(struct pci_dev *pdev)
+
+static inline struct pci_tsm_context *
+pci_tsm_context_get(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static inline void pci_tsm_context_put(struct pci_tsm_context *context)
+{
+}
+
+static inline struct pci_tsm_pf0 *
+pci_tsm_context_pf0(struct pci_tsm_context *context)
+{
+	return NULL;
+}
+
+static inline struct pci_dev *
+pci_tsm_context_dsm_dev(struct pci_tsm_context *context)
+{
+	return NULL;
+}
+
+static inline bool
+pci_tsm_context_match_device(struct pci_tsm_context *context,
+			     struct pci_dev *pdev)
 {
+	return false;
 }
 #endif
 #endif /*__PCI_TSM_H */
-- 
2.43.0

