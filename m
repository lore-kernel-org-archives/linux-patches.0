Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795422865;
	b=Udj7ERLUu/xmxNniUFhjn83Csd345tZ90Dk3/pxFnIyHRb5+f+nZHq5/gszKscyfBBd5
	 qsZyOAoVfiw7yvEG+4kpXCEPe131WV6eFWR4BNHMHJB88rVAS3YzMdJzSnOdKeE45ZB9r
	 PARlbpgxNR8NYmHMMo4H0jqX/ryg/ip0jEexV27JhPbsvfojEKOL85a4uuKsji30MY26I
	 V38M52TZPM818q90g6e9vDCDXNfxlF1D2dCleGwEkAZ4KWAyQOv7lBtTnJIKhAZQPzFYM
	 v8xpkkf0AKjPI0Doj7ZYwfVBVw6B1BMD962IZ6sfQUPBqbOtWzCLpZLN/3ET4Lyi7MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795422865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=1hUL3SB1P4VJJgXuG8hIIZFMdy/J3GLV11Mdb+Pgrk4=;
	b=yNndXfLbqBOTm7L10Kz7Heywqg3v59WNl9D0QIpsUsdT9+28idQqJJbiJVOYB8SPHLsw
	 lsB7yU31X3549yEawjAbquS6v/5TG02MHq9w0xxiznYxaGDqqjHS1ueAR/7OT+mqoQKuS
	 sss8OzpIdeiuEXxOWTwGt7bvQgTEbtSI9+CEm1zcRMP35/LacLzLZ72ZMlAprmeYGmmFA
	 wkNwWF9fZo+vJbHXDrQ3U5VgoFplNSVdlxigFCk/EO4tVL5w1HieccQIZEgCLn+FXlBgR
	 xPtG/BhVMHiTy6r4J/j1FojKaQgfG8x/+olTghTVlm8MnfkmR6bTscTOhXFqzV/XGBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="jdoUqg/0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD40606A31A;
	Mon, 23 Nov 2026 08:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jdoUqg/0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E2E1F000C4;
	Mon, 23 Nov 2026 08:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795422865;
	bh=1hUL3SB1P4VJJgXuG8hIIZFMdy/J3GLV11Mdb+Pgrk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jdoUqg/0ETjpz93Wp1GairowujXzFVlLu66hqXWgZ66hOxzVg0U60KGbIWOHQv0km
	 ph/JpZTQTb8NjFYJnoQcAuMpTTJcMBYopxqonyXp9fD2x6qBHjXmj9DjjV2gOO4Z8C
	 i/+clkhJc7yAYpcgRma88j4RzfLq1MTdP766Hlf7UBqgeIWZB6yIXuIkQMDCLwd9Gd
	 EMCCXjgDxs7tMQDzYyiwcfDlxugdFt65k/8/eGvYoiFZZmU7Nz8tlBLnaIqA4hrkKr
	 ukdnRoiX+GMVMeGnNbU1X5v+jvmIGALtM/s+hllNjYllkjJc/Si80kZMo3LXU+pBZo
	 oASXkhK9/4HKA==
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
Subject: [PATCH v1 06/10] PCI/TSM: Notify TSM drivers before waiting for TSM user references
Date: Mon, 23 Nov 2026 14:03:33 +0530
Message-ID: <20261123083337.2731019-7-aneesh.kumar@kernel.org>
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

Call the optional prepare_remove callback from tsm_unregister() before
waiting for TSM user references. Host PF0 callbacks run with
pci_tsm_rwsem held for write, followed by pci_tsm_pf0::lock. Guest
device-security callbacks take device::mutex before pci_tsm_rwsem for
write, matching PCI DMA preparation.

Later CCA patches use this callback to reject new host physical device
(PDEV) operations and guest evidence requests before unregister waits
for existing users. The guest DMA patch also uses this ordering to
reject DMA-enable requests while permitting DMA disable.

Also invoke prepare_remove() from pci_tsm_destroy() before waiting for
existing struct pci_tsm_context objects to be released. Sysfs disconnect
continues to return -EBUSY while those objects remain.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/pci/tsm.c            | 50 +++++++++++++++++++++++++++++++++---
 drivers/virt/coco/tsm-core.c |  2 ++
 include/linux/pci-tsm.h      | 10 ++++++++
 3 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/tsm.c b/drivers/pci/tsm.c
index 56b6c812a8f9..f04498265383 100644
--- a/drivers/pci/tsm.c
+++ b/drivers/pci/tsm.c
@@ -906,6 +906,21 @@ static void __pci_tsm_destroy(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
 	}
 }
 
+static void pci_tsm_prepare_remove(struct pci_dev *pdev)
+{
+	struct pci_tsm_pf0 *pf0 = to_pci_tsm_pf0(pdev->tsm);
+	const struct pci_tsm_ops *ops = pdev->tsm->tsm_dev->pci_ops;
+
+	lockdep_assert_held_write(&pci_tsm_rwsem);
+	guard(mutex)(&pf0->lock);
+	if (pf0->removing)
+		return;
+
+	pf0->removing = true;
+	if (ops->prepare_remove)
+		ops->prepare_remove(pdev);
+}
+
 void pci_tsm_destroy(struct pci_dev *pdev)
 {
 	struct tsm_dev *tsm_dev = NULL;
@@ -916,9 +931,7 @@ void pci_tsm_destroy(struct pci_dev *pdev)
 	    is_pci_tsm_pf0(pdev)) {
 		struct pci_tsm_pf0 *pf0 = to_pci_tsm_pf0(pdev->tsm);
 
-		mutex_lock(&pf0->lock);
-		pf0->removing = true;
-		mutex_unlock(&pf0->lock);
+		pci_tsm_prepare_remove(pdev);
 
 		if (pf0->dsm_context_users) {
 			struct completion *drain_complete;
@@ -1034,6 +1047,37 @@ void pci_tsm_init(struct pci_dev *pdev)
 	up_read(&pci_tsm_rwsem);
 }
 
+/* Reject new device operations before tsm_unregister() waits for users. */
+void pci_tsm_prepare_unregister(struct tsm_dev *tsm_dev)
+{
+	const struct pci_tsm_ops *ops = tsm_dev->pci_ops;
+	struct pci_dev *pdev = NULL;
+
+	if (is_devsec_tsm(tsm_dev)) {
+		if (!ops->prepare_remove)
+			return;
+
+		for_each_pci_dev(pdev) {
+			guard(device)(&pdev->dev);
+			guard(rwsem_write)(&pci_tsm_rwsem);
+
+			if (pdev->tsm && pdev->tsm->tsm_dev == tsm_dev)
+				ops->prepare_remove(pdev);
+		}
+
+		return;
+	}
+
+	guard(rwsem_write)(&pci_tsm_rwsem);
+	for_each_pci_dev(pdev) {
+		if (!pdev->tsm || pdev->tsm->tsm_dev != tsm_dev)
+			continue;
+
+		if (is_pci_tsm_pf0(pdev))
+			pci_tsm_prepare_remove(pdev);
+	}
+}
+
 void pci_tsm_unregister(struct tsm_dev *tsm_dev)
 {
 	struct pci_dev *pdev = NULL;
diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
index 31ef48203eac..ba9183783dd1 100644
--- a/drivers/virt/coco/tsm-core.c
+++ b/drivers/virt/coco/tsm-core.c
@@ -260,6 +260,8 @@ int tsm_unregister(struct tsm_dev *tsm_dev)
 	}
 
 	tsm_dev->unregistering = true;
+	if (IS_ENABLED(CONFIG_PCI_TSM) && tsm_dev->pci_ops)
+		pci_tsm_prepare_unregister(tsm_dev);
 
 	device_del(&tsm_dev->dev);
 	/* No new user references can be acquired while the write lock is held. */
diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
index d93d1c30d734..75df64a2e97d 100644
--- a/include/linux/pci-tsm.h
+++ b/include/linux/pci-tsm.h
@@ -25,6 +25,8 @@ struct tsm_dev;
  * @viommu_get_ops: Return operations for a supported TSM-owned vIOMMU type,
  *		  or NULL if unsupported
  * @owner: Module providing the vIOMMU operations, if built as a module
+ * @prepare_remove: Optional, reject new device operations before TSM unregister
+ *		  waits for users, or before forced PF0 removal.
  *
  * The vIOMMU owner holds a TSM user reference, a device reference and a
  * backend module reference before querying @viommu_get_ops, releasing them
@@ -36,11 +38,14 @@ struct tsm_dev;
  *
  * @viommu_get_ops runs with the backend module pinned. The PCI/TSM
  * association is checked during acquisition under pci_tsm_rwsem.
+ * @prepare_remove runs under pci_tsm_rwsem for write, with pci_tsm_pf0::lock
+ * for link devices or device::mutex for device-security operations.
  */
 struct pci_tsm_ops {
 	struct module *owner;
 	const struct iommufd_viommu_ops *(*viommu_get_ops)(
 		struct device *dev, enum iommu_viommu_type type);
+	void (*prepare_remove)(struct pci_dev *pdev);
 
 	/*
 	 * struct pci_tsm_link_ops - Manage physical link and the TSM/DSM session
@@ -165,6 +170,7 @@ void pci_tsm_unlock_association(struct pci_tsm *tsm);
 void pci_tsm_set_ready(struct pci_tsm_pf0 *pf0, bool ready);
 int pci_tsm_register(struct tsm_dev *tsm_dev);
 void pci_tsm_unregister(struct tsm_dev *tsm_dev);
+void pci_tsm_prepare_unregister(struct tsm_dev *tsm_dev);
 int pci_tsm_link_constructor(struct pci_dev *pdev, struct pci_tsm *tsm,
 			     struct tsm_dev *tsm_dev);
 int pci_tsm_pf0_constructor(struct pci_dev *pdev, struct pci_tsm_pf0 *pf0,
@@ -203,6 +209,10 @@ static inline void pci_tsm_unregister(struct tsm_dev *tsm_dev)
 {
 }
 
+static inline void pci_tsm_prepare_unregister(struct tsm_dev *tsm_dev)
+{
+}
+
 static inline bool pci_tsm_is_configured(struct pci_dev *pdev)
 {
 	return false;
-- 
2.43.0

