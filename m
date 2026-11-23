Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795422853;
	b=sK4cPOrDIzhIXnV1xm7tKX/z4QbgQho53FX6hiPTrLr9l9pXu79x/X8cIGi668xAqgDs
	 X+9prNcWluHOSqYfb2ZYryu+D34sK2wXQnPKbAnlc51lLhyyMqBYy9Dhpzl7RMtA0c7rg
	 lg8/3TVOFvROrEtf09rvksGJPtt+IRTI48a6haNRGoUhii1kjm2oiTxJ+wcZrXFXaYkvJ
	 8TWKeJpGT8oCmr3WY+8Ff6hf6D7UcYAqoZ+V3tBE5DVghYOcBzeWYDMMa8LKUA7MWZQ0h
	 23C70p2kwcvgJ5/6W2wAx73KkhAKstqLLVLj4WX/pJsjbAfq5hbhgLB3TeNmO303d/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795422853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=fOH7E35lxEGepNovJH9QtB9PcHgeh5NlvzVMH4pZ6YI=;
	b=a+LXV2C+ZVD+By8ag12n1Pw0t0RaokSqfbv1bO+diVB2Jpx+Eep9MyB3dwPnuBPDtLgx
	 O6pHf9coNAAWVlHM3k52IbMfQ2acrM7ILlfG0S3NpziMRoy36MzunGiErTubgSa0ospPA
	 oaFlNlgcQdZTr3S8m67UbtTP1+TTIUR3ij5EV9NDj70P7LCkguFKi0imqfunbdR5Gyg3q
	 kPW3GgAJbGmpoog/TXbav/ht7etpvWMS+gCaQtto/g2OyD3MCAKsOWQxYkcpWQVS6vWdn
	 ardsLT48NUeBqd0Y0PwrmU0UryR2B7pIuxVaWlpM6xR6wQlyXEySaRzTS/t5rn/0Eig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SaJaz1MU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A585606A31A;
	Mon, 23 Nov 2026 08:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SaJaz1MU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9AA1F00A3C;
	Mon, 23 Nov 2026 08:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795422852;
	bh=fOH7E35lxEGepNovJH9QtB9PcHgeh5NlvzVMH4pZ6YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SaJaz1MUPUBzQbxk1flY/HeG7dTHB0XbljxFYuWjM/9KNkkD7vV+0AOsnuMbPRsoe
	 RKs/KR6v6+3m1CCxPWwCA0NCedFJldnfXu9Gatu6awGOWID2RrEjirqUaLjjqH3mjM
	 XkC+gLBMzMElJvUKWO9gjbuvF40PadEK1OcQr/M9MPTFOyg2sKWVFZrCulDkJjErR0
	 8Ney3FSCX3G5/3f6pGDHkOboOehIkICiU3RI2+ov67zAfTxpTRvzkfgpklm+AKiicN
	 ftp/yt3aR5CbbqUhnUqc076Y7Whtel4J1tTNRPejNr4tAD53hXm6NpBxpmnxHoZOfr
	 r6OBjtJzi5gVw==
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
Subject: [PATCH v1 04/10] PCI/TSM: Defer TSM vDEVICE allocation until device setup completes
Date: Mon, 23 Nov 2026 14:03:31 +0530
Message-ID: <20261123083337.2731019-5-aneesh.kumar@kernel.org>
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

A successful connect does not necessarily complete the checks and setup
needed to assign a device to a confidential guest. Authentication and
userspace evidence acceptance may still be required.

Add pci_tsm_pf0::ready and pci_tsm_set_ready(). While ready is false,
pci_tsm_context_get() returns -EACCES, preventing TSM virtual device
(vDEVICE) allocation.

Initialize ready to true to preserve existing TSM driver behavior. A
follow-up CCA patch will clear ready during connect and set it after
evidence-accept completes the required device setup.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/pci/tsm.c       | 31 ++++++++++++++++++++++++++++++-
 include/linux/pci-tsm.h | 10 ++++++++++
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/tsm.c b/drivers/pci/tsm.c
index 2be92bde8780..4dafc5dc6fe3 100644
--- a/drivers/pci/tsm.c
+++ b/drivers/pci/tsm.c
@@ -27,7 +27,8 @@
  * Provide a read/write lock against the init / exit of pdev tsm
  * capabilities and arrival/departure of a TSM instance
  */
-static DECLARE_RWSEM(pci_tsm_rwsem);
+DECLARE_RWSEM(pci_tsm_rwsem);
+EXPORT_SYMBOL_GPL(pci_tsm_rwsem);
 
 /*
  * Count of TSMs registered that support physical link operations vs device
@@ -293,6 +294,26 @@ static bool is_devsec_tsm(struct tsm_dev *tsm_dev)
 	return tsm_dev && tsm_dev->pci_ops && tsm_dev->pci_ops->devsec_ops.lock;
 }
 
+/**
+ * pci_tsm_set_ready() - Set when PF0 permits device assignment
+ * @ready: whether the device is ready for assignment
+ *
+ * pci_tsm_context_get() rejects requests with -EACCES while pf0->ready
+ * is false. A TSM driver can clear it during connect and set it after
+ * completing authentication, evidence acceptance and device setup.
+ *
+ * Hold pci_tsm_rwsem for write and pf0->lock through device setup and
+ * this update. pci_tsm_context_get() checks ready under pf0->lock, so
+ * device assignment cannot proceed before setup completes.
+ */
+void pci_tsm_set_ready(struct pci_tsm_pf0 *pf0, bool ready)
+{
+	lockdep_assert_held_write(&pci_tsm_rwsem);
+	lockdep_assert_held(&pf0->lock);
+	pf0->ready = ready;
+}
+EXPORT_SYMBOL_GPL(pci_tsm_set_ready);
+
 static ssize_t connect_store(struct device *dev, struct device_attribute *attr,
 			     const char *buf, size_t len)
 {
@@ -393,6 +414,12 @@ struct pci_tsm_context *pci_tsm_context_get(struct pci_dev *pdev,
 		goto out_unlock_mutex;
 	}
 
+	if (!pf0->ready) {
+		kfree(context);
+		context = ERR_PTR(-EACCES);
+		goto out_unlock_mutex;
+	}
+
 	if (!pf0->dsm_context_users)
 		reinit_completion(&pf0->dsm_context_drain_complete);
 
@@ -724,6 +751,8 @@ int pci_tsm_pf0_constructor(struct pci_dev *pdev, struct pci_tsm_pf0 *pf0,
 	init_completion(&pf0->dsm_context_drain_complete);
 	pf0->dsm_context_users = 0;
 	pf0->removing = false;
+	/* Default to ready for TSM drivers that complete setup during connect. */
+	pf0->ready = true;
 	/*
 	 * Note, low-level TSM driver responsible for determining if it wants to
 	 * proceed with a device that has no DOE mailbox. TSM may have an
diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
index 7e91c15ffe3b..9c5f0b6c0f6d 100644
--- a/include/linux/pci-tsm.h
+++ b/include/linux/pci-tsm.h
@@ -4,6 +4,7 @@
 #include <linux/completion.h>
 #include <linux/mutex.h>
 #include <linux/pci.h>
+#include <linux/rwsem.h>
 #include <uapi/linux/iommufd.h>
 
 struct iommufd_viommu_ops;
@@ -111,6 +112,7 @@ struct pci_tsm {
  *	blocks link disconnect
  * @dsm_context_drain_complete: completed when the last context is released
  * @removing: reject new contexts while the DSM is being removed
+ * @ready: TSM driver has completed the checks and setup needed for assignment
  * @doe_mb: PCIe Data Object Exchange mailbox
  */
 struct pci_tsm_pf0 {
@@ -119,6 +121,7 @@ struct pci_tsm_pf0 {
 	unsigned int dsm_context_users;
 	struct completion dsm_context_drain_complete;
 	bool removing;
+	bool ready;
 	struct pci_doe_mb *doe_mb;
 };
 
@@ -156,6 +159,7 @@ static inline bool is_pci_tsm_pf0(struct pci_dev *pdev)
 }
 
 #ifdef CONFIG_PCI_TSM
+void pci_tsm_set_ready(struct pci_tsm_pf0 *pf0, bool ready);
 int pci_tsm_register(struct tsm_dev *tsm_dev);
 void pci_tsm_unregister(struct tsm_dev *tsm_dev);
 int pci_tsm_link_constructor(struct pci_dev *pdev, struct pci_tsm *tsm,
@@ -175,6 +179,10 @@ bool pci_tsm_context_match_device(struct pci_tsm_context *context,
 				  struct pci_dev *pdev);
 struct tsm_dev *pci_tsm_get_device(struct pci_dev *pdev);
 #else
+static inline void pci_tsm_set_ready(struct pci_tsm_pf0 *pf0, bool ready)
+{
+}
+
 static inline int pci_tsm_register(struct tsm_dev *tsm_dev)
 {
 	return 0;
@@ -222,4 +230,6 @@ pci_tsm_context_match_device(struct pci_tsm_context *context,
 	return false;
 }
 #endif
+extern struct rw_semaphore pci_tsm_rwsem;
+
 #endif /*__PCI_TSM_H */
-- 
2.43.0

