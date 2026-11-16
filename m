Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794817326;
	b=lTqp60Shn04Kduwj3SquHVWgIfWTIk39bmUC3Kinsoe8EfnzbvQ6MZwQEvAiHKRALx45
	 iUZT8g96G8NYD0yzXom8WJW/DSLdJloQqKz1wmUlBVAs2t6F4PnJHZIoYe4Xy6DEOt1NV
	 dsLaigMejsbZFD+qxocNlavx7NtKYcxyZE9tGEs4CRyQEb7Q0qOlqQ1yGTcvw8pRgNuBi
	 wD5pITYgrFBgAhApKteszWj63gEbDgkYYtd8WDf+PeqBLO1UMP0pSQvjj1kBZtsiyyJnd
	 X5SY+OKl0F7tJzoroOvFds5/KHvKjN6zX+is1lm4An5QtQYpNzmHw5BsvWaPNaSSm2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794817326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=o3Cb6Xq0hJCoqEoWsMGeuO1zla0Znah9UtrDmm5BWW4=;
	b=bNHq5QCTMj6xq+OSgSOxDoU/Hld4yS8vV3SNC42wOljTfwoNa6OzADCTNk49+xhR9u1o
	 LFBmAR+Yhrd/i9UpeAetlFtFgQs8DJuJ7c+/c8oqSYXaaibJ14dj6mih6+MNkXtd8Tgqc
	 ZpBGcaruAMFlZ0QNkNdlbyLDik4GpHcPwkbudaUdcArrM94qPMJgec5GOhCogEqFxnH5A
	 dfvOUrhK5CV0p284tgycfxUStagfPmQZdLrfjVG048TAy6vw0zW07IIqHblM5qLX6WscM
	 mbLzdaZ+Zl+aEryJyzJ6M0c8Fg4KCtP7wozy/479o1p1B9JoCb7Zqp6E4NXazb2rjlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Y/S2Bzxf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94A1606A335;
	Mon, 16 Nov 2026 08:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y/S2Bzxf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6831F000CB;
	Mon, 16 Nov 2026 08:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794817326;
	bh=o3Cb6Xq0hJCoqEoWsMGeuO1zla0Znah9UtrDmm5BWW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y/S2BzxfzWceQ+bc4DIiQGF10OF/Kl8RiAbmIiPUtrDrbBepUM9xXfjkTgkBaqUq9
	 gp7LmkMXT8XJop73/ZXWwUOpb9RILLq8ts7q8Yfdj5RK5VRTb6PqOxcnzdEPTy3t6S
	 2jpE44dBrdmndCy7MetDYkin6VILJrApMJYzYaE3DKWDxxH1RI1fgDw9Y+RxTJrTnR
	 aKrvJFSGobeVr7yqNYqwrHfzRYHTCEjaDrc4XiZD8/QjVBeq1WlzElzw2YVZe+Oc4b
	 qAjDWZtPTaes7Sk2jM/va7JvY2oSXTlmvtKRQd8lJ1t1vgHIiVcNbGqht/AzESSoAK
	 7PkEQVKcj4w1w==
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
Subject: [PATCH v9 13/13] PCI/TSM: Wait for users during unregister
Date: Mon, 16 Nov 2026 13:49:35 +0530
Message-ID: <20261116081935.85372-14-aneesh.kumar@kernel.org>
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

Wait for TEE Security Manager (TSM) users before tearing down PCI
connections, including IOMMUFD virtual IOMMUs (vIOMMUs) with no vDEVICE
objects. A vDEVICE represents a physical device within a guest's virtual
IOMMU.

Add registration_lock to protect operations against unregister. New
operations try the read lock. Long-lived users increment the user
refcount under that lock. Unregister holds the write lock while dropping
the registration reference, waiting for users and tearing down PCI
connections.

PCI Device Security Manager (DSM) removal holds the registration read
lock while waiting for its contexts and completing teardown. If
unregister prevents taking the read lock, retain a device reference and
wait for all TSM users instead.

Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: linux-pci@vger.kernel.org
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/crypto/ccp/sev-dev-tsm.c |   4 +-
 drivers/pci/tsm/core.c           | 172 ++++++++++++++++++++++---------
 drivers/virt/coco/tsm-core.c     | 137 ++++++++++++++++++++++--
 include/linux/pci-tsm.h          |   7 +-
 include/linux/tsm.h              |  15 ++-
 5 files changed, 273 insertions(+), 62 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index 46f2539d2d5a..5c61ce74ee0f 100644
--- a/drivers/crypto/ccp/sev-dev-tsm.c
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -392,8 +392,8 @@ void sev_tsm_init_locked(struct sev_device *sev, void *tio_status_page)
 
 void sev_tsm_uninit(struct sev_device *sev)
 {
-	if (sev->tsmdev)
-		tsm_unregister(sev->tsmdev);
+	if (sev->tsmdev && WARN_ON(tsm_unregister(sev->tsmdev)))
+		return;
 
 	sev->tsmdev = NULL;
 }
diff --git a/drivers/pci/tsm/core.c b/drivers/pci/tsm/core.c
index a713025d1a5a..9d1b05c848b6 100644
--- a/drivers/pci/tsm/core.c
+++ b/drivers/pci/tsm/core.c
@@ -54,10 +54,7 @@ struct tsm_dev *pci_tsm_get_device(struct pci_dev *pdev)
 	ops = tsm_dev->pci_ops;
 	if (!ops->viommu_get_ops)
 		return NULL;
-	if (!try_module_get(ops->owner))
-		return ERR_PTR(-ENODEV);
-	get_device(&tsm_dev->dev);
-	return tsm_dev;
+	return tsm_get(tsm_dev);
 }
 EXPORT_SYMBOL_GPL(pci_tsm_get_device);
 
@@ -209,16 +206,16 @@ static int probe_fn(struct pci_dev *pdev, void *dsm)
 	return 0;
 }
 
-static int pci_tsm_connect(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
+static int __pci_tsm_connect(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
 {
 	int rc;
 	struct pci_tsm_pf0 *tsm_pf0;
 	const struct pci_tsm_ops *ops = tsm_dev->pci_ops;
-	struct pci_tsm *pci_tsm __free(tsm_remove) = ops->probe(tsm_dev, pdev);
 
 	/* connect() mutually exclusive with subfunction pci_tsm_init() */
 	lockdep_assert_held_write(&pci_tsm_rwsem);
 
+	struct pci_tsm *pci_tsm __free(tsm_remove) = ops->probe(tsm_dev, pdev);
 	if (!pci_tsm)
 		return -ENXIO;
 
@@ -253,6 +250,18 @@ static int pci_tsm_connect(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
 	return 0;
 }
 
+static int pci_tsm_connect(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
+{
+	int rc;
+
+	if (!tsm_trylock_registration(tsm_dev))
+		return -ENODEV;
+
+	rc = __pci_tsm_connect(pdev, tsm_dev);
+	tsm_unlock_registration(tsm_dev);
+	return rc;
+}
+
 static ssize_t connect_show(struct device *dev, struct device_attribute *attr,
 			    char *buf)
 {
@@ -341,6 +350,8 @@ struct pci_tsm_context {
  * from being disconnected until pci_tsm_context_put() releases the context.
  * Each successful call allocates a separate context, even for the same device,
  * and requires a matching pci_tsm_context_put().
+ * The caller must retain its tsm_get_device() reference until the context
+ * is released.
  *
  * Return: A new context, or an error pointer on failure.
  */
@@ -350,23 +361,35 @@ struct pci_tsm_context *pci_tsm_context_get(struct pci_dev *pdev,
 	struct pci_tsm_context *context;
 	struct pci_tsm_pf0 *pf0;
 
-	guard(rwsem_read)(&pci_tsm_rwsem);
-	if (!pdev->tsm || !is_link_tsm(pdev->tsm->tsm_dev))
-		return ERR_PTR(-EOPNOTSUPP);
+	down_read(&pci_tsm_rwsem);
+	if (!pdev->tsm || !is_link_tsm(pdev->tsm->tsm_dev)) {
+		context = ERR_PTR(-EOPNOTSUPP);
+		goto out_unlock;
+	}
 
 	/* The device must be connected to the TSM requested by the caller. */
-	if (pdev->tsm->tsm_dev != tsm_dev)
-		return ERR_PTR(-EXDEV);
+	if (pdev->tsm->tsm_dev != tsm_dev) {
+		context = ERR_PTR(-EXDEV);
+		goto out_unlock;
+	}
+
+	if (!tsm_trylock_registration(tsm_dev)) {
+		context = ERR_PTR(-ENODEV);
+		goto out_unlock;
+	}
 
 	context = kzalloc_obj(*context);
-	if (!context)
-		return ERR_PTR(-ENOMEM);
+	if (!context) {
+		context = ERR_PTR(-ENOMEM);
+		goto out_unlock_registration;
+	}
 
 	pf0 = to_pci_tsm_pf0(pdev->tsm);
-	guard(mutex)(&pf0->lock);
+	mutex_lock(&pf0->lock);
 	if (pf0->removing) {
 		kfree(context);
-		return ERR_PTR(-ENODEV);
+		context = ERR_PTR(-ENODEV);
+		goto out_unlock_mutex;
 	}
 
 	if (!pf0->dsm_context_users)
@@ -376,6 +399,12 @@ struct pci_tsm_context *pci_tsm_context_get(struct pci_dev *pdev,
 	context->pf0 = pf0;
 	context->pdev = pci_dev_get(pdev);
 	context->dsm_dev = pci_dev_get(pf0->base_tsm.pdev);
+out_unlock_mutex:
+	mutex_unlock(&pf0->lock);
+out_unlock_registration:
+	tsm_unlock_registration(tsm_dev);
+out_unlock:
+	up_read(&pci_tsm_rwsem);
 	return context;
 }
 EXPORT_SYMBOL_GPL(pci_tsm_context_get);
@@ -779,52 +808,88 @@ static void __pci_tsm_destroy(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
 
 void pci_tsm_destroy(struct pci_dev *pdev)
 {
-	struct pci_tsm_pf0 *pf0 = NULL;
-	struct completion *drained;
-	bool interrupted = false;
-	long rc;
+	struct tsm_dev *tsm_dev = NULL;
+	bool registration_locked = false;
 
 	down_write(&pci_tsm_rwsem);
-	if (pdev->tsm &&
-	    is_link_tsm(pdev->tsm->tsm_dev) && is_pci_tsm_pf0(pdev)) {
-		pf0 = to_pci_tsm_pf0(pdev->tsm);
-		drained = &pf0->dsm_context_drain_complete;
+	if (pdev->tsm && is_link_tsm(pdev->tsm->tsm_dev) &&
+	    is_pci_tsm_pf0(pdev)) {
+		struct pci_tsm_pf0 *pf0 = to_pci_tsm_pf0(pdev->tsm);
+
 		mutex_lock(&pf0->lock);
 		pf0->removing = true;
-
 		mutex_unlock(&pf0->lock);
-		/* An unused DSM may never have completed dsm_context_drain_complete. */
-		if (pf0->dsm_context_users)
-			rc = try_wait_for_completion(drained);
-		else
-			rc = 1;
-
-		/* Context release needs the read side of pci_tsm_rwsem. */
-		up_write(&pci_tsm_rwsem);
-		while (rc <= 0) {
-			if (interrupted) {
-				rc = wait_for_completion_timeout(drained, HZ * 10);
+
+		if (pf0->dsm_context_users) {
+			struct completion *drain_complete;
+			const char *users;
+			bool interrupted = false;
+			long rc;
+
+			tsm_dev = pdev->tsm->tsm_dev;
+			/*
+			 * Keep users_drain_complete alive if unregister completes while
+			 * we wait without the registration lock.
+			 */
+			get_device(&tsm_dev->dev);
+			registration_locked = tsm_trylock_registration(tsm_dev);
+			if (registration_locked) {
+				/* Keep PF0 alive while pci_tsm_rwsem is dropped. */
+				drain_complete = &pf0->dsm_context_drain_complete;
+				users = "IOMMUFD device assignment contexts";
 			} else {
-				rc = wait_for_completion_interruptible_timeout(drained,
-									       HZ * 10);
-				if (rc < 0) {
-					interrupted = true;
-					pci_warn(pdev, "Task \"%s\" (%d) blocked until vdevices are released\n",
-						 current->comm, task_pid_nr(current));
+				/*
+				 * The DSM completion is embedded in PF0.
+				 * If unregister runs while pci_tsm_rwsem
+				 * is dropped, it may free PF0 after the
+				 * last context signals the completion but
+				 * before this waiter finishes accessing
+				 * it.
+				 *
+				 * Without the registration lock, wait on
+				 * the TSM's users_drain_complete completion
+				 * instead. The device reference keeps that
+				 * completion alive even if unregister
+				 * finishes before this waiter resumes.
+				 */
+
+				drain_complete = &tsm_dev->users_drain_complete;
+				users = "virtual IOMMUs and other TSM users";
+			}
+			/* Context release needs the read side of pci_tsm_rwsem. */
+			up_write(&pci_tsm_rwsem);
+			rc = try_wait_for_completion(drain_complete);
+			while (rc <= 0) {
+				if (interrupted) {
+					rc = wait_for_completion_timeout(drain_complete, HZ * 10);
+				} else {
+					rc = wait_for_completion_interruptible_timeout(
+						drain_complete, HZ * 10);
+					if (rc < 0) {
+						interrupted = true;
+						pci_warn(pdev, "Task \"%s\" (%d) removing Device Security Manager; waiting for %s\n",
+							 current->comm, task_pid_nr(current),
+							 users);
+					}
 				}
+				if (!rc)
+					pci_warn(pdev, "Device Security Manager removal blocked; waiting for %s\n",
+						 users);
 			}
-			if (!rc)
-				pci_warn(pdev, "TSM connection is in use, waiting for vdevices\n");
+			down_write(&pci_tsm_rwsem);
 		}
-		down_write(&pci_tsm_rwsem);
 	}
 	__pci_tsm_destroy(pdev, NULL);
 	up_write(&pci_tsm_rwsem);
+	if (registration_locked)
+		tsm_unlock_registration(tsm_dev);
+	if (tsm_dev)
+		put_device(&tsm_dev->dev);
 }
 
 void pci_tsm_init(struct pci_dev *pdev)
 {
-	guard(rwsem_read)(&pci_tsm_rwsem);
+	down_read(&pci_tsm_rwsem);
 
 	/*
 	 * Subfunctions are either probed synchronous with connect() or later
@@ -832,27 +897,36 @@ void pci_tsm_init(struct pci_dev *pdev)
 	 * connect() raced initial bus scanning.
 	 */
 	if (pdev->tsm)
-		return;
+		goto out_unlock;
 
 	if (pci_tsm_link_count) {
 		struct pci_dev *dsm = find_dsm_dev(pdev);
+		struct tsm_dev *tsm_dev;
 
 		if (!dsm)
-			return;
+			goto out_unlock;
 
 		/*
 		 * The only path to init a Device Security Manager capable
 		 * device is via connect().
 		 */
 		if (!dsm->tsm)
-			return;
+			goto out_unlock;
+
+		tsm_dev = dsm->tsm->tsm_dev;
+		if (!tsm_trylock_registration(tsm_dev))
+			goto out_unlock;
 
 		if (is_link_tsm(dsm->tsm->tsm_dev) &&
 		    to_pci_tsm_pf0(dsm->tsm)->removing)
-			return;
+			goto out_unlock_registration;
 
 		probe_fn(pdev, dsm);
+out_unlock_registration:
+		tsm_unlock_registration(tsm_dev);
 	}
+out_unlock:
+	up_read(&pci_tsm_rwsem);
 }
 
 void pci_tsm_unregister(struct tsm_dev *tsm_dev)
diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
index 766f4ad67ed7..2a45d479379a 100644
--- a/drivers/virt/coco/tsm-core.c
+++ b/drivers/virt/coco/tsm-core.c
@@ -7,7 +7,10 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/cleanup.h>
+#include <linux/jiffies.h>
 #include <linux/pci-tsm.h>
+#include <linux/pid.h>
+#include <linux/sched.h>
 
 /* The caller must hold a tsm_get_device() reference for the entire use. */
 const struct iommufd_viommu_ops *tsm_viommu_get_ops(struct tsm_dev *tsm_dev,
@@ -26,15 +29,85 @@ static const struct class tsm_class = {
 };
 static DEFINE_IDA(tsm_ida);
 
+/**
+ * tsm_trylock_registration() - protect an operation against TSM unregister
+ * @tsm_dev: TSM whose allocation is protected by the caller
+ *
+ * Never wait for the read lock: unregister holds the write lock while
+ * draining users. * tsm_get() takes a user reference before releasing the
+ * read lock.
+ *
+ * Return: true with the read lock held, or false if unregister prevents use.
+ */
+bool tsm_trylock_registration(struct tsm_dev *tsm_dev)
+{
+	if (!down_read_trylock(&tsm_dev->registration_lock))
+		return false;
+
+	if (tsm_dev->unregistering) {
+		up_read(&tsm_dev->registration_lock);
+		return false;
+	}
+	return true;
+}
+
+void tsm_unlock_registration(struct tsm_dev *tsm_dev)
+{
+	up_read(&tsm_dev->registration_lock);
+}
+
+static void tsm_put_user(struct tsm_dev *tsm_dev)
+{
+	if (refcount_dec_and_test(&tsm_dev->users))
+		complete_all(&tsm_dev->users_drain_complete);
+}
+
+/**
+ * tsm_get() - acquire a user reference to a TSM found by a bus lookup
+ * @tsm_dev: TSM whose lifetime is protected by the caller
+ *
+ * The caller must protect @tsm_dev against removal until this returns.
+ * A successful call takes a device reference, pins the backend module and
+ * adds a user that tsm_unregister() will wait for. Release it with
+ * tsm_put_device().
+ *
+ * Return: @tsm_dev on success, or ERR_PTR(-ENODEV) if the TSM is unregistering
+ * or the backend module cannot be pinned.
+ */
+struct tsm_dev *tsm_get(struct tsm_dev *tsm_dev)
+{
+	if (!tsm_trylock_registration(tsm_dev))
+		return ERR_PTR(-ENODEV);
+
+	/* Keep the backend code and operation tables loaded while in use. */
+	if (!try_module_get(tsm_dev->pci_ops->owner)) {
+		tsm_unlock_registration(tsm_dev);
+		return ERR_PTR(-ENODEV);
+	}
+	/*
+	 * Keep tsm_dev allocated through tsm_put_device(), including after
+	 * dropping the user reference wakes tsm_unregister().
+	 */
+	get_device(&tsm_dev->dev);
+	/*
+	 * Make explicit unregister wait before tearing down backend
+	 * resources.
+	 */
+	refcount_inc(&tsm_dev->users);
+	tsm_unlock_registration(tsm_dev);
+	return tsm_dev;
+}
+
 /**
  * tsm_get_device() - Pin the TSM attached to a device
  * @dev: device whose TSM is to be pinned
  *
  * A successful lookup takes a TSM device reference and pins the backend
- * module. Release both with tsm_put_device(). Backends providing vIOMMU
- * operations must not unregister their TSM independently of module unload.
+ * module. It also adds a user that tsm_unregister() will wait for. Release
+ * these references with tsm_put_device().
  * Return: NULL if no vIOMMU-capable TSM is attached, an error if the module
- * cannot be pinned, or the TSM device associated with the pinned backend.
+ * cannot be pinned or the TSM is unregistering, or the TSM device associated
+ * with the pinned backend.
  */
 struct tsm_dev *tsm_get_device(struct device *dev)
 {
@@ -48,6 +121,7 @@ void tsm_put_device(struct tsm_dev *tsm_dev)
 {
 	struct module *owner = tsm_dev->pci_ops->owner;
 
+	tsm_put_user(tsm_dev);
 	put_device(&tsm_dev->dev);
 	module_put(owner);
 }
@@ -85,6 +159,9 @@ static struct tsm_dev *alloc_tsm_dev(struct device *parent)
 		return ERR_PTR(id);
 
 	tsm_dev->id = id;
+	init_rwsem(&tsm_dev->registration_lock);
+	refcount_set(&tsm_dev->users, 1);
+	init_completion(&tsm_dev->users_drain_complete);
 	dev = &tsm_dev->dev;
 	dev->parent = parent;
 	dev->class = &tsm_class;
@@ -132,13 +209,61 @@ struct tsm_dev *tsm_register(struct device *parent, struct pci_tsm_ops *pci_ops)
 }
 EXPORT_SYMBOL_GPL(tsm_register);
 
-void tsm_unregister(struct tsm_dev *tsm_dev)
+static void tsm_wait_for_users(struct tsm_dev *tsm_dev)
+{
+	struct completion *drain_complete = &tsm_dev->users_drain_complete;
+	bool interrupted = false;
+	long rc = try_wait_for_completion(drain_complete);
+
+	while (rc <= 0) {
+		if (interrupted) {
+			rc = wait_for_completion_timeout(drain_complete, HZ * 10);
+		} else {
+			rc = wait_for_completion_interruptible_timeout(
+				drain_complete, HZ * 10);
+			if (rc < 0) {
+				interrupted = true;
+				dev_warn(&tsm_dev->dev,
+					 "Task \"%s\" (%d) unregistering TSM; release virtual IOMMUs and other TSM users\n",
+					 current->comm, task_pid_nr(current));
+			}
+		}
+		if (!rc)
+			dev_warn(&tsm_dev->dev, "TSM unregister blocked; release virtual IOMMUs and other TSM users\n");
+	}
+}
+
+/**
+ * tsm_unregister() - unregister a TSM after draining its users
+ * @tsm_dev: TSM to unregister
+ *
+ * Blocks new users and waits for references acquired by tsm_get_device(),
+ * including vIOMMUs without vdevices, and pending DSM removals before tearing
+ * down PCI connections. The wait cannot be aborted by a signal; userspace
+ * must release the vIOMMUs and vdevices to let it finish.
+ *
+ * Return: 0 on success, or -ENODEV if unregistration has already started.
+ */
+int tsm_unregister(struct tsm_dev *tsm_dev)
 {
-	/* Remove the class lookup first. */
+	down_write(&tsm_dev->registration_lock);
+	if (tsm_dev->unregistering) {
+		up_write(&tsm_dev->registration_lock);
+		return -ENODEV;
+	}
+	tsm_dev->unregistering = true;
+
 	device_del(&tsm_dev->dev);
-	if (tsm_dev->pci_ops)
+	/* No new user references can be acquired while the write lock is held. */
+	tsm_put_user(tsm_dev);
+	tsm_wait_for_users(tsm_dev);
+
+	if (IS_ENABLED(CONFIG_PCI_TSM) && tsm_dev->pci_ops)
 		pci_tsm_unregister(tsm_dev);
+
+	up_write(&tsm_dev->registration_lock);
 	put_device(&tsm_dev->dev);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(tsm_unregister);
 
diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
index 85dea90e0d77..12eb4e1abc50 100644
--- a/include/linux/pci-tsm.h
+++ b/include/linux/pci-tsm.h
@@ -24,10 +24,9 @@ struct tsm_dev;
  *		  or NULL if unsupported
  * @owner: Module providing the vIOMMU operations, if built as a module
  *
- * The vIOMMU owner holds a TSM device reference and pins the backend module
- * before querying @viommu_get_ops, releasing both after vIOMMU destruction.
- * A backend providing this callback must not unregister its TSM while the
- * module is pinned.
+ * The vIOMMU owner holds a TSM user reference, a device reference and a
+ * backend module reference before querying @viommu_get_ops, releasing them
+ * after vIOMMU destruction. TSM unregister waits for the user reference.
  *
  * This operations are mutually exclusive either a tsm_dev instance
  * manages physical link properties or it manages function security
diff --git a/include/linux/tsm.h b/include/linux/tsm.h
index 3d5286aeaa42..0996b888df21 100644
--- a/include/linux/tsm.h
+++ b/include/linux/tsm.h
@@ -2,6 +2,9 @@
 #ifndef __TSM_H
 #define __TSM_H
 
+#include <linux/completion.h>
+#include <linux/refcount.h>
+#include <linux/rwsem.h>
 #include <linux/sizes.h>
 #include <linux/types.h>
 #include <linux/uuid.h>
@@ -116,6 +119,13 @@ struct tsm_dev {
 	struct device dev;
 	int id;
 	const struct pci_tsm_ops *pci_ops;
+	/* Read side protects operations; write side protects unregister. */
+	struct rw_semaphore registration_lock;
+	/* Protected by registration_lock; prevents reuse after unregister. */
+	bool unregistering;
+	/* Incremented under registration_lock; unregister waits for zero. */
+	refcount_t users;
+	struct completion users_drain_complete;
 };
 
 DEFINE_FREE(put_tsm_dev, struct tsm_dev *,
@@ -124,10 +134,13 @@ DEFINE_FREE(put_tsm_dev, struct tsm_dev *,
 int tsm_report_register(const struct tsm_report_ops *ops, void *priv);
 int tsm_report_unregister(const struct tsm_report_ops *ops);
 struct tsm_dev *tsm_register(struct device *parent, struct pci_tsm_ops *ops);
-void tsm_unregister(struct tsm_dev *tsm_dev);
+int tsm_unregister(struct tsm_dev *tsm_dev);
 struct tsm_dev *find_tsm_dev(int id);
 
 #ifdef CONFIG_TSM
+struct tsm_dev *tsm_get(struct tsm_dev *tsm_dev);
+bool tsm_trylock_registration(struct tsm_dev *tsm_dev);
+void tsm_unlock_registration(struct tsm_dev *tsm_dev);
 struct tsm_dev *tsm_get_device(struct device *dev);
 void tsm_put_device(struct tsm_dev *tsm_dev);
 const struct iommufd_viommu_ops *tsm_viommu_get_ops(struct tsm_dev *tsm_dev,
-- 
2.43.0

