Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795594429;
	b=hxqMi4pc3nVzEgQcvCVk7azt9f9nZV+LyveXx17rc9oVyN6lTipV9+CUEIVvfGcXH5j0
	 aehpqvDc11puKt710PznWh07IUHXOtQc5fyLKexgAawFrwAIVH72Sw/9ylYtpmngSJii4
	 JKWeU9mToTTsqQCSHAKyJbjW2UT1eJnufpDvJ/E88fRibUmNyrDykcY6Bg+5Er9QZozHb
	 uNGBqPH8Di6q9FGagvoDbqJl4Au8NY3IQRFww6rGpn+1Elxa6asfgl0Zl6A6n2YnOSbh7
	 HU+sO2Kbj2qfUNyixjGu+zL78OBLfJ9unt3H68+WdnN1kGyqDZQ4wbwB9zLPj8WFL8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795594429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=IH2pQOU7oldfAWKlDrprybS+h8ReUbartZTWqF4qC7Q=;
	b=wXGJdBsQVUsWVfPy6ihnrJFJ0sWz47S5tOZaHyOaR+MThwfXPkD8kjMoceLOoV7WBZ7q
	 QPdx9R/JcV8cal8Y1S7Y+HC6YngPRpumNNI3nNEKu2zQ105rLAAbNbLBQPRup+6eDshu2
	 HrMeRzfj2UolnQz0mZbRJM8MXK3ZUB+3G+Lko2G1xc1tdCtD4dgnpAt3iDEspYgRi16iT
	 weHftgf74UbG/9+FEpanUb1sXuKgKI69lsvkNJeYjtgLnh7WbRRYRryftxkOSFdjh8bQB
	 dgNVfUv8pV93a0p/XCXVw9t372BIw4UDj6l6ng84dmWYz0jzGEDAJq7JyW6c2oIv71Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="nPOGZV/+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0F9606A323;
	Wed, 25 Nov 2026 08:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nPOGZV/+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADFC1F000EF;
	Wed, 25 Nov 2026 08:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795594428;
	bh=IH2pQOU7oldfAWKlDrprybS+h8ReUbartZTWqF4qC7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nPOGZV/+siujRm+SwwxF7viFh28mpzN0iKoMknMGVrb4mzh3N+yNo6Rz9CZFDsyaG
	 M+c5i0+ENLE5/gX5cpsQ0sFMEXGtOe7jipg5SNEYXwOYk4l1qcTK+Jdz9m+2+p6Wie
	 r5iNMd1BcWk3Phrht0F2G6qyMlPhAbhuUkqEgQAhIHU1FyOls094vgEwRQX2pSZxuk
	 6n+sB9tObla4fexnki+YwLWu3LWMfqVbZ1NvrOqiDUA/jBSiFKzowqo7U3Pq6v9srM
	 vv23ED7Xono+s9PSx1N7hf1CkVHWn5V5Nub0ZmKQoj2adbXHyOREBqIWyKopii00z/
	 7eYj9jKikFRww==
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
Subject: [PATCH v10 10/18] PCI/TSM: Add helpers to prevent disconnect while in use
Date: Wed, 25 Nov 2026 13:41:13 +0530
Message-ID: <20261125081121.379481-11-aneesh.kumar@kernel.org>
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

Add PCI TEE Security Manager (TSM) helpers that prevent PF0 disconnect
while a function is in use. Validate the function's TSM association and
increment PF0's dsm_context_users count on get. Find PF0 through the
same function and decrement the count on put. Reject disconnect with
-EBUSY until all users have released it.

The caller must prevent removal of the function between get and put, for
example by keeping its VFIO device open. No per-call allocation is
needed.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/ABI/testing/sysfs-bus-pci |  1 +
 drivers/pci/tsm.c                       | 79 ++++++++++++++++++++++---
 include/linux/pci-tsm.h                 | 14 +++++
 3 files changed, 85 insertions(+), 9 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index be9126e56894..2906257eb610 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -660,6 +660,7 @@ Contact:	linux-coco@lists.linux.dev
 Description:
 		(WO) Write the name of the TSM device that was specified
 		to 'connect' to teardown the connection.
+		The write fails with EBUSY if the TSM is in use.
 
 What:		/sys/bus/pci/devices/.../tsm/dsm
 Contact:	linux-coco@lists.linux.dev
diff --git a/drivers/pci/tsm.c b/drivers/pci/tsm.c
index 1423c64dc9c8..73f16a9a78ef 100644
--- a/drivers/pci/tsm.c
+++ b/drivers/pci/tsm.c
@@ -292,6 +292,51 @@ static int remove_fn(struct pci_dev *pdev, void *data)
 	return 0;
 }
 
+/**
+ * pci_tsm_context_get() - Prevent disconnect of a device's PF0 TSM connection
+ * @pdev: PCI function whose PF0 TSM connection must remain active
+ * @tsm_dev: TSM that must manage the device's connection
+ *
+ * Verify that @pdev is connected to @tsm_dev and increment the DSM user count.
+ * Each successful call requires a matching pci_tsm_context_put() for @pdev.
+ * The caller must prevent removal of @pdev until that put, for example by
+ * keeping the VFIO device open.
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+int pci_tsm_context_get(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
+{
+	struct pci_tsm_pf0 *pf0;
+
+	guard(rwsem_read)(&pci_tsm_rwsem);
+	if (!pdev->tsm || !is_link_tsm(pdev->tsm->tsm_dev))
+		return -EOPNOTSUPP;
+
+	/* The device must be connected to the TSM requested by the caller. */
+	if (pdev->tsm->tsm_dev != tsm_dev)
+		return -EXDEV;
+
+	pf0 = to_pci_tsm_pf0(pdev->tsm);
+	guard(mutex)(&pf0->lock);
+	pf0->dsm_context_users++;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_tsm_context_get);
+
+void pci_tsm_context_put(struct pci_dev *pdev)
+{
+	struct pci_tsm_pf0 *pf0;
+
+	down_read(&pci_tsm_rwsem);
+	pf0 = to_pci_tsm_pf0(pdev->tsm);
+	mutex_lock(&pf0->lock);
+	if (!WARN_ON(!pf0->dsm_context_users))
+		pf0->dsm_context_users--;
+	mutex_unlock(&pf0->lock);
+	up_read(&pci_tsm_rwsem);
+}
+EXPORT_SYMBOL_GPL(pci_tsm_context_put);
+
 /*
  * Note, this helper only returns an error code and takes an argument for
  * compatibility with the pci_walk_bus() callback prototype. pci_tsm_unbind()
@@ -381,7 +426,7 @@ static void pci_tsm_unbind_all(struct pci_dev *pdev)
 	__pci_tsm_unbind(pdev, NULL);
 }
 
-static void __pci_tsm_disconnect(struct pci_dev *pdev)
+static int __pci_tsm_disconnect(struct pci_dev *pdev)
 {
 	struct pci_tsm_pf0 *tsm_pf0 = to_pci_tsm_pf0(pdev->tsm);
 	const struct pci_tsm_ops *ops = to_pci_tsm_ops(pdev->tsm);
@@ -392,18 +437,29 @@ static void __pci_tsm_disconnect(struct pci_dev *pdev)
 	pci_tsm_unbind_all(pdev);
 
 	/*
-	 * disconnect() is uninterruptible as it may be called for device
-	 * teardown
+	 * Refuse to disconnect the link until all contexts have been released.
+	 *
+	 * disconnect() is uninterruptible as it may also be called for device
+	 * teardown.
 	 */
 	guard(mutex)(&tsm_pf0->lock);
+	if (tsm_pf0->dsm_context_users)
+		return -EBUSY;
+
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
+
 	tsm_remove(pdev->tsm);
+	return 0;
 }
 
 static ssize_t disconnect_store(struct device *dev,
@@ -425,7 +481,10 @@ static ssize_t disconnect_store(struct device *dev,
 	if (!sysfs_streq(buf, dev_name(&tsm_dev->dev)))
 		return -EINVAL;
 
-	pci_tsm_disconnect(pdev);
+	rc = pci_tsm_disconnect(pdev);
+	if (rc)
+		return rc;
+
 	return len;
 }
 static DEVICE_ATTR_WO(disconnect);
@@ -768,10 +827,12 @@ static void __pci_tsm_destroy(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
 	else if (tsm_dev != tsm->tsm_dev)
 		return;
 
-	if (is_link_tsm(tsm_dev) && is_pci_tsm_pf0(pdev))
-		pci_tsm_disconnect(pdev);
-	else
+	if (is_link_tsm(tsm_dev) && is_pci_tsm_pf0(pdev)) {
+		if (pci_tsm_disconnect(pdev))
+			pci_warn(pdev, "TSM connection is still in use\n");
+	} else {
 		pci_tsm_fn_exit(pdev);
+	}
 }
 
 void pci_tsm_destroy(struct pci_dev *pdev)
diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
index 6fe3d0ea875f..38b03d71e3f3 100644
--- a/include/linux/pci-tsm.h
+++ b/include/linux/pci-tsm.h
@@ -110,11 +110,13 @@ struct pci_tsm {
  * struct pci_tsm_pf0 - Physical Function 0 TDISP link context
  * @base_tsm: generic core "tsm" context
  * @lock: mutual exclustion for pci_tsm_ops invocation
+ * @dsm_context_users: users preventing DSM disconnect
  * @doe_mb: PCIe Data Object Exchange mailbox
  */
 struct pci_tsm_pf0 {
 	struct pci_tsm base_tsm;
 	struct mutex lock;
+	unsigned int dsm_context_users;
 	struct pci_doe_mb *doe_mb;
 };
 
@@ -165,6 +167,8 @@ int pci_tsm_bind(struct pci_dev *pdev, struct kvm *kvm, u32 tdi_id);
 void pci_tsm_unbind(struct pci_dev *pdev);
 void pci_tsm_tdi_constructor(struct pci_dev *pdev, struct pci_tdi *tdi,
 			     struct kvm *kvm, u32 tdi_id);
+int pci_tsm_context_get(struct pci_dev *pdev, struct tsm_dev *tsm_dev);
+void pci_tsm_context_put(struct pci_dev *pdev);
 #else
 static inline int pci_tsm_register(struct tsm_dev *tsm_dev)
 {
@@ -180,5 +184,15 @@ static inline int pci_tsm_bind(struct pci_dev *pdev, struct kvm *kvm, u64 tdi_id
 static inline void pci_tsm_unbind(struct pci_dev *pdev)
 {
 }
+static inline int
+pci_tsm_context_get(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void pci_tsm_context_put(struct pci_dev *pdev)
+{
+}
+
 #endif
 #endif /*__PCI_TSM_H */
-- 
2.43.0

