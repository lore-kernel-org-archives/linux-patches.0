Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794817315;
	b=VJfrZjwB8xf6D1H8iRMHTT3R/NsV9p6TbBo1VZpNS78E1TyAkyCIc0ZE4DrtzNWQd01Y
	 6tgzerIeRQekV9awb0mc3u9TtybaU2C/tpyl98GVRNIllRNHnagSY5iE9xbKLsmWtkBp8
	 UJcDag+ZuSfXsTvXA/h2RkB5mTFXNHCSyw/Pzto9/RNROyNZrjCXcswofhGZMSKtmKJgr
	 xrR6tgJNb8LIgD99xgWmTN/YUf5XIzgqgOArfTQapIhQzARe7MdWDy39XgNwGD40cuBCF
	 JzE1F/Slf8RIq3uaiDy4Tm5oYTD/MAiMnSTLLI0aoIO6H0pxWKKsks6DtVk4T+qXMBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794817315;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=rAKTRV/7tcJkgsScVsHExj4BoDUpPl6GWu4KgcAwSWA=;
	b=e3sdAJjdQCbk5qdE75H8SYcHHgmuD2/UdvmGpj25rfPGg3MZQUEtpuOnnDLt4TxMVL9l
	 d9yM615k+ExvP1qDBnQBJQrvgFn96nKrb4f/1tLl0t+zdcRQJsO0Ud+QKLlDsfHbuZV6X
	 BjomzwAiok19cQEXsOafjzVeEcXFkOUw3sGEs1lA7jLrkPLr3wz4nssImVeGoDTSNdehi
	 CevT9GAVolS8u5KQ5CdhED4tKtDlmP9OnOOC99K83fMyyW4kLFkoDFyTIuhKtHBRhkH7X
	 ahLFzFOTmSiJCTtxg4Zyt/yGgGGMeBTn8HMu7+2izKeaMyMl9PAxX5XBKkcU9PC3EOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GQ1l12Gu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B2B606A31C;
	Mon, 16 Nov 2026 08:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GQ1l12Gu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2E21F000C4;
	Mon, 16 Nov 2026 08:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794817315;
	bh=rAKTRV/7tcJkgsScVsHExj4BoDUpPl6GWu4KgcAwSWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GQ1l12GueQGulAur4Cm19mOdr/DK22yun3CWe8JcQr9NduZerm851rmWzf3viwXGi
	 exziHx2lbccY9Qh1Kt0IKaoY3kIiOPe0nt3zUm6UtOW8cEtt83F9BVSTYdC/K056q0
	 jNBmbkND773eZfEGh5rCugX4TnaHL7dRRxFHGFfITKOYl+epHIBSbl3/F6paRA9ghv
	 Cd/OxNZZVxr3xHV0imsaJZUfSjnMJRZwOdyCIRtkTQ9LQJTvySWt5gwY9jYtnzAxYw
	 HzzO7Go19h06iajHt3p6JEb9Ex4nZLU/3LoK5fo3p8aDFoehgbzEvu6ZveZtnTB1Dr
	 l130ZwLUVQU6g==
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
Subject: [PATCH v9 12/13] PCI/TSM: Wait for device contexts before removing a DSM
Date: Mon, 16 Nov 2026 13:49:34 +0530
Message-ID: <20261116081935.85372-13-aneesh.kumar@kernel.org>
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

A PCI Device Security Manager (DSM) on physical function 0 (PF0) can be
removed while a sibling function still has an IOMMUFD vDEVICE object.
A vDEVICE represents a physical device within a virtual IOMMU for a guest
and holds a PCI/TSM context for its lifetime.

The context holds PCI device references to both the assigned function and
its DSM, but these references do not keep the PF0 Data Object Exchange
(DOE) mailbox alive. Ignoring -EBUSY from link disconnect allows removal
to reach pci_doe_destroy() while the context can still use the mailbox.

Reject new contexts and subfunction attachments once DSM removal starts.
Wait for existing contexts to be released before disconnecting the link
and allowing PCI removal to destroy the mailbox.

As with VFIO PCI removal, removal waits for userspace to release the
device. This patch does not provide an eventfd notification to request
that release.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Samuel Ortiz <sameo@rivosinc.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: linux-pci@vger.kernel.org
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/pci/tsm/core.c  | 75 ++++++++++++++++++++++++++++++++++++++---
 include/linux/pci-tsm.h |  9 +++--
 2 files changed, 77 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/tsm/core.c b/drivers/pci/tsm/core.c
index 4107ff443228..a713025d1a5a 100644
--- a/drivers/pci/tsm/core.c
+++ b/drivers/pci/tsm/core.c
@@ -10,10 +10,13 @@
 
 #include <linux/bitfield.h>
 #include <linux/iommufd.h>
+#include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/pci-doe.h>
 #include <linux/pci-tsm.h>
+#include <linux/pid.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/tsm.h>
@@ -361,7 +364,15 @@ struct pci_tsm_context *pci_tsm_context_get(struct pci_dev *pdev,
 
 	pf0 = to_pci_tsm_pf0(pdev->tsm);
 	guard(mutex)(&pf0->lock);
-	pf0->context_users++;
+	if (pf0->removing) {
+		kfree(context);
+		return ERR_PTR(-ENODEV);
+	}
+
+	if (!pf0->dsm_context_users)
+		reinit_completion(&pf0->dsm_context_drain_complete);
+
+	pf0->dsm_context_users++;
 	context->pf0 = pf0;
 	context->pdev = pci_dev_get(pdev);
 	context->dsm_dev = pci_dev_get(pf0->base_tsm.pdev);
@@ -375,8 +386,12 @@ void pci_tsm_context_put(struct pci_tsm_context *context)
 
 	down_read(&pci_tsm_rwsem);
 	mutex_lock(&pf0->lock);
-	if (!WARN_ON(!pf0->context_users))
-		pf0->context_users--;
+	if (WARN_ON(!pf0->dsm_context_users))
+		goto out_unlock;
+
+	if (!--pf0->dsm_context_users)
+		complete_all(&pf0->dsm_context_drain_complete);
+out_unlock:
 	mutex_unlock(&pf0->lock);
 	up_read(&pci_tsm_rwsem);
 
@@ -423,7 +438,7 @@ static int __pci_tsm_disconnect(struct pci_dev *pdev)
 	 * teardown.
 	 */
 	guard(mutex)(&tsm_pf0->lock);
-	if (tsm_pf0->context_users)
+	if (tsm_pf0->dsm_context_users)
 		return -EBUSY;
 	pci_tsm_walk_fns_reverse(pdev, remove_fn, NULL);
 	ops->disconnect(pdev);
@@ -459,6 +474,10 @@ static ssize_t disconnect_store(struct device *dev,
 	if (!sysfs_streq(buf, dev_name(&tsm_dev->dev)))
 		return -EINVAL;
 
+	if (is_link_tsm(tsm_dev) && is_pci_tsm_pf0(pdev) &&
+	    to_pci_tsm_pf0(pdev->tsm)->removing)
+		return -ENODEV;
+
 	rc = pci_tsm_disconnect(pdev);
 	if (rc)
 		return rc;
@@ -669,6 +688,9 @@ int pci_tsm_pf0_constructor(struct pci_dev *pdev, struct pci_tsm_pf0 *tsm,
 			    struct tsm_dev *tsm_dev)
 {
 	mutex_init(&tsm->lock);
+	init_completion(&tsm->dsm_context_drain_complete);
+	tsm->dsm_context_users = 0;
+	tsm->removing = false;
 	tsm->doe_mb = pci_find_doe_mailbox(pdev, PCI_VENDOR_ID_PCI_SIG,
 					   PCI_DOE_FEATURE_CMA);
 	if (!tsm->doe_mb) {
@@ -757,8 +779,47 @@ static void __pci_tsm_destroy(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
 
 void pci_tsm_destroy(struct pci_dev *pdev)
 {
-	guard(rwsem_write)(&pci_tsm_rwsem);
+	struct pci_tsm_pf0 *pf0 = NULL;
+	struct completion *drained;
+	bool interrupted = false;
+	long rc;
+
+	down_write(&pci_tsm_rwsem);
+	if (pdev->tsm &&
+	    is_link_tsm(pdev->tsm->tsm_dev) && is_pci_tsm_pf0(pdev)) {
+		pf0 = to_pci_tsm_pf0(pdev->tsm);
+		drained = &pf0->dsm_context_drain_complete;
+		mutex_lock(&pf0->lock);
+		pf0->removing = true;
+
+		mutex_unlock(&pf0->lock);
+		/* An unused DSM may never have completed dsm_context_drain_complete. */
+		if (pf0->dsm_context_users)
+			rc = try_wait_for_completion(drained);
+		else
+			rc = 1;
+
+		/* Context release needs the read side of pci_tsm_rwsem. */
+		up_write(&pci_tsm_rwsem);
+		while (rc <= 0) {
+			if (interrupted) {
+				rc = wait_for_completion_timeout(drained, HZ * 10);
+			} else {
+				rc = wait_for_completion_interruptible_timeout(drained,
+									       HZ * 10);
+				if (rc < 0) {
+					interrupted = true;
+					pci_warn(pdev, "Task \"%s\" (%d) blocked until vdevices are released\n",
+						 current->comm, task_pid_nr(current));
+				}
+			}
+			if (!rc)
+				pci_warn(pdev, "TSM connection is in use, waiting for vdevices\n");
+		}
+		down_write(&pci_tsm_rwsem);
+	}
 	__pci_tsm_destroy(pdev, NULL);
+	up_write(&pci_tsm_rwsem);
 }
 
 void pci_tsm_init(struct pci_dev *pdev)
@@ -786,6 +847,10 @@ void pci_tsm_init(struct pci_dev *pdev)
 		if (!dsm->tsm)
 			return;
 
+		if (is_link_tsm(dsm->tsm->tsm_dev) &&
+		    to_pci_tsm_pf0(dsm->tsm)->removing)
+			return;
+
 		probe_fn(pdev, dsm);
 	}
 }
diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
index 27a76aeedf50..85dea90e0d77 100644
--- a/include/linux/pci-tsm.h
+++ b/include/linux/pci-tsm.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __PCI_TSM_H
 #define __PCI_TSM_H
+#include <linux/completion.h>
 #include <linux/mutex.h>
 #include <linux/pci.h>
 #include <uapi/linux/iommufd.h>
@@ -107,14 +108,18 @@ struct pci_tsm {
  * struct pci_tsm_pf0 - Physical Function 0 TDISP link context
  * @base_tsm: generic core "tsm" context
  * @lock: mutual exclustion for pci_tsm_ops invocation
- * @context_users: live per-function contexts on this PF0; a nonzero count
+ * @dsm_context_users: live per-function contexts on this PF0; a nonzero count
  *	blocks link disconnect
+ * @dsm_context_drain_complete: completed when the last context is released
+ * @removing: reject new contexts while the DSM is being removed
  * @doe_mb: PCIe Data Object Exchange mailbox
  */
 struct pci_tsm_pf0 {
 	struct pci_tsm base_tsm;
 	struct mutex lock;
-	unsigned int context_users;
+	unsigned int dsm_context_users;
+	struct completion dsm_context_drain_complete;
+	bool removing;
 	struct pci_doe_mb *doe_mb;
 };
 
-- 
2.43.0

