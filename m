Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795422859;
	b=ye1nxt/TLgAGLV1gZBNucJ6ba3IcMezxIbjOzuJQMZKxUSPnIyRaAqSzYtHf7VwF0aQx
	 KYuMy56zQG8JUgawVXtHDtIH/By7gzQqsMfQ2lgOq2zY/7k2p51dNOXO0UboruZV7vElx
	 +n6KHsbSthcnJ9UK3nHfnjscaI4+W6higo4NP0VI9sHi6KJwQDk4MEi/TXh0qusJtHd7h
	 VpPo7QltubH1WwkPIZR1sFURh9j1rMexPzLO611UuZIgvBg7LaVsG12RrPUFiIZCN00uD
	 JdKDkdRFTqhQk57PT3h1Rt7sSg9rtOIvNBPbaHsFFT/sqeBAFa9drxZwovMiRko856A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795422859;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=e007Vr7SP2trthfCPpQLAJOOXkeQk09cGEm/Lkfei4w=;
	b=PMpLqP4npLrk4g2uwo1gfB0ysJnXnlrGZhx2U9USFjVOXDlhCb0IGCKdftTGNRoOV6aI
	 Gw8WoNZI2UuKp4kcn+qr+BlcoTN6hB/YFN29s2hDSbMlmfVKLQ0PcEPZiayom0jooF8sn
	 QLs7EPxzuNoQ56nKX2BSKusy5dHFHHvUDghPKovJvVlRi64s6oF7cZ5kpmXGSlWM6bsom
	 U1IN2eyaQuJL3Dg+bJCZiIr85o3ZcIymdhnUoQTyFdn2z2Cq1uuIgXhxfv6zN1HHxjt4D
	 UHYQFoi206GWu5+oXX9Y3y85Vl1+NJL6zd5c93tJyYaRMf3JV4QuyYMKhN+LP79EhYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NLgatwCo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41798606A31A;
	Mon, 23 Nov 2026 08:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NLgatwCo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641AE1F000C4;
	Mon, 23 Nov 2026 08:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795422858;
	bh=e007Vr7SP2trthfCPpQLAJOOXkeQk09cGEm/Lkfei4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NLgatwCo4cJibOxfCaOKhjRUMbIqC5LWAd3keuMI115nVonDxwhQ6z6xoH0ojZ7gf
	 4pIoSNr/Ak3dF7ShzrHP4eqdENNUsRHWYBePjfWpTtOP85gsRNa2h18cQJRrp2CHmG
	 Y3UHvFIDdZpaFBB1KiRtu1MIe7gAwyMWh/3cxWsIyFIZAwDNbUZqqztWnO5zEvhUGX
	 rAM8nOTxxR3IfOLRBzSmbbSKiuz9MxghyeVMIotaxcG/i6SoNObM+AhgPlwzL2x2x0
	 Lf49ysUYLifEFsbXPewIuNtV8z5xHFy8DQfAB6DcQbxDgv1v734qXM8IoJYdtZJsww
	 3AprxjwdMjnOw==
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
Subject: [PATCH v1 05/10] PCI/TSM: Add association locking helpers for evidence acceptance
Date: Mon, 23 Nov 2026 14:03:32 +0530
Message-ID: <20261123083337.2731019-6-aneesh.kumar@kernel.org>
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

Later attestation patches let userspace finish device setup through
evidence-accept after host sysfs connect or guest sysfs lock returns.
Those commands use a saved struct pci_tsm and must prevent disconnect or
guest unlock from changing pci_dev::tsm or freeing the saved structure
while setup is in progress.

Add pci_tsm_trylock_association() to acquire pci_tsm_rwsem for write and
check that pci_dev::tsm still points to the saved structure. For a TSM
implementing devsec_ops, first take device::mutex to prevent driver
attachment during MMIO validation and device acceptance. This matches
the device-mutex-before-rwsem order used by PCI DMA preparation.

Neither lock acquisition waits. Host disconnect holds pci_tsm_rwsem for
write; guest unlock holds device::mutex and the rwsem. Both unregister
attestation, which takes ctlv::registration_lock for write to wait for
running CTLV ioctls. The evidence-accept ioctl holds that lock for read
when calling this helper, so waiting for disconnect or unlock would
deadlock. Return ERR_PTR(-EAGAIN) on contention and ERR_PTR(-ENODEV) if
the saved pointer no longer matches.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/pci/tsm.c       | 66 +++++++++++++++++++++++++++++++++++++++++
 include/linux/pci-tsm.h | 17 +++++++++++
 2 files changed, 83 insertions(+)

diff --git a/drivers/pci/tsm.c b/drivers/pci/tsm.c
index 4dafc5dc6fe3..56b6c812a8f9 100644
--- a/drivers/pci/tsm.c
+++ b/drivers/pci/tsm.c
@@ -294,6 +294,72 @@ static bool is_devsec_tsm(struct tsm_dev *tsm_dev)
 	return tsm_dev && tsm_dev->pci_ops && tsm_dev->pci_ops->devsec_ops.lock;
 }
 
+/**
+ * pci_tsm_trylock_association() - Lock and check a PCI function's TSM state
+ * @tsm: struct pci_tsm kept allocated by the caller throughout the operation
+ *
+ * For a TSM implementing devsec_ops, first trylock tsm->pdev->dev.mutex to
+ * prevent PCI driver attachment during MMIO validation and device setup.
+ * Then acquire pci_tsm_rwsem for write before checking that tsm->pdev->tsm
+ * still points to @tsm. A TSM implementing link_ops only needs the rwsem.
+ *
+ * Host disconnect holds pci_tsm_rwsem for write; guest unlock also
+ * holds pdev->dev.mutex. Both unregister attestation, which waits for
+ * running CTLV ioctls by taking ctlv::registration_lock for write.
+ *
+ * evidence-accept holds that registration lock for read when calling
+ * this helper. It must return -EAGAIN rather than wait for the locks
+ * held by disconnect or unlock, otherwise neither call can finish.
+ *
+ * Return: @tsm with the locks held, ERR_PTR(-EAGAIN) on lock contention, or
+ * ERR_PTR(-ENODEV) if tsm->pdev->tsm no longer points to @tsm.
+ */
+struct pci_tsm *pci_tsm_trylock_association(struct pci_tsm *tsm)
+{
+	struct pci_dev *pdev = tsm->pdev;
+	bool devsec = is_devsec_tsm(tsm->tsm_dev);
+
+	if (devsec && !device_trylock(&pdev->dev))
+		return ERR_PTR(-EAGAIN);
+
+	if (!down_write_trylock(&pci_tsm_rwsem)) {
+		if (devsec)
+			device_unlock(&pdev->dev);
+
+		return ERR_PTR(-EAGAIN);
+	}
+
+	if (pdev->tsm != tsm) {
+		up_write(&pci_tsm_rwsem);
+
+		if (devsec)
+			device_unlock(&pdev->dev);
+
+		return ERR_PTR(-ENODEV);
+	}
+
+	return tsm;
+}
+EXPORT_SYMBOL_GPL(pci_tsm_trylock_association);
+
+/**
+ * pci_tsm_unlock_association() - Release locks protecting a PCI function's TSM state
+ * @tsm: struct pci_tsm returned by a successful pci_tsm_trylock_association()
+ *
+ */
+void pci_tsm_unlock_association(struct pci_tsm *tsm)
+{
+	struct pci_dev *pdev = tsm->pdev;
+	bool devsec = is_devsec_tsm(tsm->tsm_dev);
+
+	lockdep_assert_held_write(&pci_tsm_rwsem);
+	up_write(&pci_tsm_rwsem);
+
+	if (devsec)
+		device_unlock(&pdev->dev);
+}
+EXPORT_SYMBOL_GPL(pci_tsm_unlock_association);
+
 /**
  * pci_tsm_set_ready() - Set when PF0 permits device assignment
  * @ready: whether the device is ready for assignment
diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
index 9c5f0b6c0f6d..d93d1c30d734 100644
--- a/include/linux/pci-tsm.h
+++ b/include/linux/pci-tsm.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __PCI_TSM_H
 #define __PCI_TSM_H
+#include <linux/cleanup.h>
 #include <linux/completion.h>
 #include <linux/mutex.h>
 #include <linux/pci.h>
@@ -159,6 +160,8 @@ static inline bool is_pci_tsm_pf0(struct pci_dev *pdev)
 }
 
 #ifdef CONFIG_PCI_TSM
+struct pci_tsm *pci_tsm_trylock_association(struct pci_tsm *tsm);
+void pci_tsm_unlock_association(struct pci_tsm *tsm);
 void pci_tsm_set_ready(struct pci_tsm_pf0 *pf0, bool ready);
 int pci_tsm_register(struct tsm_dev *tsm_dev);
 void pci_tsm_unregister(struct tsm_dev *tsm_dev);
@@ -179,6 +182,15 @@ bool pci_tsm_context_match_device(struct pci_tsm_context *context,
 				  struct pci_dev *pdev);
 struct tsm_dev *pci_tsm_get_device(struct pci_dev *pdev);
 #else
+static inline struct pci_tsm *pci_tsm_trylock_association(struct pci_tsm *tsm)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline void pci_tsm_unlock_association(struct pci_tsm *tsm)
+{
+}
+
 static inline void pci_tsm_set_ready(struct pci_tsm_pf0 *pf0, bool ready)
 {
 }
@@ -230,6 +242,11 @@ pci_tsm_context_match_device(struct pci_tsm_context *context,
 	return false;
 }
 #endif
+
+DEFINE_FREE(pci_tsm_unlock, struct pci_tsm *,
+	if (!IS_ERR_OR_NULL(_T))
+		pci_tsm_unlock_association(_T))
+
 extern struct rw_semaphore pci_tsm_rwsem;
 
 #endif /*__PCI_TSM_H */
-- 
2.43.0

