Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795594514;
	b=0PF2D5XlLRWcDW4SPBjmVdQe31L2/X5WZDKgl6GTEif6mLpmDCr0H6ZtnghCoSCfEMGF
	 nTx+SE54za/FLCtBKVExS27lzia/Z2JXQbxxNJebfR0HBAu7k6bSw5qcLB4KS32Ud5GHy
	 64W/5ocidFON+V6KvlTN3gxXrULTEP9JPnF3Yjj/4Kfg8IIkzg5EIEhwe4QH6UsjiuwHz
	 NmyFp0TlUa6Q5xF59PfRltlOzys320gV5XT2+bFr7HeACgfMLwDfpTpt9XtvSxiWQYQZR
	 vLwYG1KrByKyxxXE7fYBF1TbOctTUAOLZiW68Yy1ShDVqJa+0M1gL2Z6ati60xQbRSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795594514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=M2f6V5AKCbDzNBzVnkSKauxhXMtebYR0SxTIkkQuhcs=;
	b=07BhVp7roo4mqre2FJUo1MiXYAvDKDAOECHDvJsZ5NMUJYeGGySaVFVJ+DaJDoAlqNLT
	 xE1U7c67OobsML3pG5znxBhPscK+eiaOK1fFnDS7BGXLK7gmb+SNwLvl6Xa7m6Gl4P3Hh
	 GJd1p3VQOgroRjkkPXkTrFFxiUWc3qmlNUVUZK01LENwKlIgSdMDugN7BYeuNAlPT6vWe
	 VNZ6/Wt9lAE9MfjN8S2BiJ7J3YuX0Wqx88DIWjHpAA9aKO0UqD5joCIl9xNSM4A4m/1xU
	 yfUaL3n83CrG2t6qy50JnO3WtYIJ0sAA1tThS+kEcyoz98/L1lHQmIm2g8gG/8Cl08g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KsgO5m8B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCD0606A327;
	Wed, 25 Nov 2026 08:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KsgO5m8B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD361F000D8;
	Wed, 25 Nov 2026 08:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795594514;
	bh=M2f6V5AKCbDzNBzVnkSKauxhXMtebYR0SxTIkkQuhcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KsgO5m8Bhk1iDuCrve03xp4BI+FtwU/sO8+eEuQzS7ryfWDoglHTWXQD2z5pBx5Zo
	 t739exoWqmlERPhf0pdUzbYs5nBYWnhXH4mMXIHWh3V+477yVpEeOct6+MFDkd8K2j
	 7rEeeH6ZzNYK2etqqEf84jMwV/4IbqCvTdYGKM7igNBGa5u5/nV9yKoj+jdOxawTO2
	 VMk0ZXTfSCn+DQaP8XkegmVoLEiv9YdbHLnajPtVPu7rfgKYjZZxIDLhrc4sC5PgG+
	 ISloLS4rmDqKfjkFpi3MZNJ6Hicu9zciP7v8sRehsYAaoCCoDV0YdYbGxce9H7su6y
	 fyM6YFN5hRdgA==
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
Subject: [PATCH v10 17/18] PCI/TSM: Wait for DSM users before removing PF0
Date: Wed, 25 Nov 2026 13:41:20 +0530
Message-ID: <20261125081121.379481-18-aneesh.kumar@kernel.org>
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

Removing physical function 0 (PF0) attempts to disconnect its TSM link.
If a sibling function still has an IOMMUFD vDEVICE, dsm_context_users is
nonzero and disconnect returns -EBUSY. Removal currently continues to
pci_doe_destroy(), destroying PF0's Data Object Exchange (DOE) mailbox
while the assigned function may still need it.

Reject new DSM users and subfunction attachments once PF0 removal
starts. Wait for dsm_context_users to reach zero before disconnecting
the link and allowing PCI removal to destroy the mailbox.

Release pci_tsm_rwsem while waiting, since vDEVICE cleanup needs its
read side to decrement the count. Reacquire it for write before
disconnecting.

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
 drivers/pci/tsm.c       | 69 +++++++++++++++++++++++++++++++++++++++--
 include/linux/pci-tsm.h |  5 +++
 2 files changed, 71 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/tsm.c b/drivers/pci/tsm.c
index 88e88fc9aec6..b10bf0b2d5b7 100644
--- a/drivers/pci/tsm.c
+++ b/drivers/pci/tsm.c
@@ -9,10 +9,13 @@
 #define dev_fmt(fmt) "PCI/TSM: " fmt
 
 #include <linux/bitfield.h>
+#include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/pci-doe.h>
 #include <linux/pci-tsm.h>
+#include <linux/pid.h>
+#include <linux/sched.h>
 #include <linux/sysfs.h>
 #include <linux/tsm.h>
 #include <linux/xarray.h>
@@ -337,6 +340,12 @@ int pci_tsm_context_get(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
 
 	pf0 = to_pci_tsm_pf0(pdev->tsm);
 	guard(mutex)(&pf0->lock);
+	if (pf0->removing)
+		return -ENODEV;
+
+	if (!pf0->dsm_context_users)
+		reinit_completion(&pf0->dsm_context_drain_complete);
+
 	pf0->dsm_context_users++;
 	return 0;
 }
@@ -349,8 +358,12 @@ void pci_tsm_context_put(struct pci_dev *pdev)
 	down_read(&pci_tsm_rwsem);
 	pf0 = to_pci_tsm_pf0(pdev->tsm);
 	mutex_lock(&pf0->lock);
-	if (!WARN_ON(!pf0->dsm_context_users))
-		pf0->dsm_context_users--;
+	if (WARN_ON(!pf0->dsm_context_users))
+		goto out_unlock;
+
+	if (!--pf0->dsm_context_users)
+		complete_all(&pf0->dsm_context_drain_complete);
+out_unlock:
 	mutex_unlock(&pf0->lock);
 	up_read(&pci_tsm_rwsem);
 }
@@ -409,6 +422,10 @@ static ssize_t disconnect_store(struct device *dev,
 	if (!sysfs_streq(buf, dev_name(&tsm_dev->dev)))
 		return -EINVAL;
 
+	if (is_link_tsm(tsm_dev) && is_pci_tsm_pf0(pdev) &&
+	    to_pci_tsm_pf0(pdev->tsm)->removing)
+		return -ENODEV;
+
 	rc = pci_tsm_disconnect(pdev);
 	if (rc)
 		return rc;
@@ -620,6 +637,9 @@ int pci_tsm_pf0_constructor(struct pci_dev *pdev, struct pci_tsm_pf0 *tsm,
 			    struct tsm_dev *tsm_dev)
 {
 	mutex_init(&tsm->lock);
+	init_completion(&tsm->dsm_context_drain_complete);
+	tsm->dsm_context_users = 0;
+	tsm->removing = false;
 	tsm->doe_mb = pci_find_doe_mailbox(pdev, PCI_VENDOR_ID_PCI_SIG,
 					   PCI_DOE_FEATURE_CMA);
 	if (!tsm->doe_mb) {
@@ -708,8 +728,47 @@ static void __pci_tsm_destroy(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
 
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
@@ -737,6 +796,10 @@ void pci_tsm_init(struct pci_dev *pdev)
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
index 44895c585d75..b6830206e36f 100644
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
@@ -104,12 +105,16 @@ struct pci_tsm {
  * @base_tsm: generic core "tsm" context
  * @lock: mutual exclustion for pci_tsm_ops invocation
  * @dsm_context_users: users preventing DSM disconnect
+ * @dsm_context_drain_complete: completed when the last context is released
+ * @removing: reject new contexts while the DSM is being removed
  * @doe_mb: PCIe Data Object Exchange mailbox
  */
 struct pci_tsm_pf0 {
 	struct pci_tsm base_tsm;
 	struct mutex lock;
 	unsigned int dsm_context_users;
+	struct completion dsm_context_drain_complete;
+	bool removing;
 	struct pci_doe_mb *doe_mb;
 };
 
-- 
2.43.0

