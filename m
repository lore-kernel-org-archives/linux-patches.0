Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794817220;
	b=DEB4sjz8lFCVbBGBmRJYaHkFJQAHR85Ga5NjF2Da+Epa+ZVA4Jng/MSlfxRuznHU4CuO
	 zQWI5yFzWZGq9MtiuMhj6odxb2zaDRMsiN0uJ4pe9EmXFt6CDWOSEddc03YBYXR+NrNkH
	 jePJOo9lZy5pwGONXxgC8VbuML2czkurWUT+0Myqr7NXP8XlePJp6ZkE4B4c4HdrJNcMd
	 sgVFt6eEd5GmgvA3nEd0j+QDdVcxAAaOrzZ8tD40b7l7VGGK41I4MuhG76A7Dv7XFQ+VK
	 Sjs8l8EkZcBHqMKpT1qWcwGg5kjap7AXMHT2atsGJjaaNaSNB6nMgKesgUwCLxpKVsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794817220;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=J3CB7pxtf7r6yeaYjA+I3Ez6gum2kkw3DZcJlhmDkkM=;
	b=MIAy6EltVjr8Ho6FmFCLdMsblBfrCT3/ZIwvhTLkuKKU683Q02tIJbGipzk1PlaCyDkQ
	 vWjDgT9kFxhH690lrG6YlGto5/0sDP/634YtVxRYL7ZWHAmoDh6v1sZoX4eLWsbqHm2jF
	 yEgRZmaYxZJItY5vYMya2bO2lPSbZe5W83vzKlKmNZJo4mVqO5V6cVvxFXRG4DnnFFoqR
	 k201hhoCMsglb/f6e4r0HSWG2JkiHe/QmPZ56m5nLfpEJKf7f2QiNh3v0iCxYnWGoGZyk
	 ZANwRMswxW2zMgks8uDf0GizEepkBQrXA+ML78iSnWHmmSsAxQEbuI22wDpaB6Qm9jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NTNR5R7n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914E9606A31C;
	Mon, 16 Nov 2026 08:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NTNR5R7n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F85A1F000D2;
	Mon, 16 Nov 2026 08:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794817220;
	bh=J3CB7pxtf7r6yeaYjA+I3Ez6gum2kkw3DZcJlhmDkkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NTNR5R7nbheK6VgAJ9u7fTe+isxkFW+XY1TwRlI3EXm7PC/eeeHx+8yEYGhcPtYKC
	 rxvjKO3wtwsWoHf7XK6jmxEM8vTeixpm+5nb/FS2MUVb6nhkhSh7mhgz0aUN6fzCvT
	 RwgReYW3bCgWe4yf8ZL6KcqAGZ4u5Z6g5TxEejvwcuGib0wbfdIiRigh4j0vDnf0pI
	 VXKPfjpDSOYHyqnIcmhtaNyNQLOamSDDvpIseeuqgKZSR9vU4ni4W1ofDMPblBF2hd
	 NuVDmjUjtYMmO4qWNBOxllH+SWcTQJjkw9Kjo/a9RdDTUMcQzOCLeIrkCGQEDgNhCb
	 J6n33KgpJZ3lw==
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
Subject: [PATCH v9 03/13] virt: coco: tsm: Complete PCI registration before publishing the device
Date: Mon, 16 Nov 2026 13:49:25 +0530
Message-ID: <20261116081935.85372-4-aneesh.kumar@kernel.org>
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

tsm_register() calls device_add() before initializing and validating the
PCI operations. This makes the new TSM discoverable through the class
lookup while PCI registration can still fail. This ordering was introduced
by commit 3225f52cde56 ("PCI/TSM: Establish Secure Sessions and Link
Encryption").

An existing link TSM can keep the PCI connect attribute visible during
registration of another TSM. A concurrent write naming the new TSM can
therefore reach it through:

  connect_store()
    find_tsm_dev()
      class_find_device()
    is_link_tsm()
    pci_tsm_connect()

If the new backend supplies both link and device security operations,
pci_tsm_register() rejects it before taking pci_tsm_rwsem. The registration
thread then follows:

  tsm_register()
    __tsm_register()
      pci_tsm_register() -> -EINVAL
      tsm_dev->pci_ops = NULL
    device_del()
    put_tsm_dev() [cleanup guard]

If connect has already attached a PCI context, its temporary device
reference does not protect the stored tsm_dev pointer after the call
returns. Registration cleanup can then free a TSM still referenced by
that context. The original tsm_register_pci_or_reset() error path also
had this problem: device_unregister() removed the class device and dropped
its reference without tearing down an attached PCI context.

Commit dbe7fb3c96b1 ("virt: coco: tsm: Remove the device from lookup
before PCI teardown") subsequently added the unlocked pci_ops reset shown above.
That reset can also race with the connect path's accesses to pci_ops.

Complete PCI registration before device_add() publishes the class device.
On PCI registration failure, the TSM remains undiscoverable. If
device_add() fails instead, unregister the PCI operations to roll back
the counters and PCI sysfs visibility before releasing the device.

Send the PCI change notification only after device_add() succeeds.

Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: linux-coco@lists.linux.dev
Fixes: 3225f52cde56 ("PCI/TSM: Establish Secure Sessions and Link Encryption")
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/tsm-core.c | 35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
index 57db3f14cf46..181d6114086f 100644
--- a/drivers/virt/coco/tsm-core.c
+++ b/drivers/virt/coco/tsm-core.c
@@ -56,24 +56,6 @@ static struct tsm_dev *alloc_tsm_dev(struct device *parent)
 	return no_free_ptr(tsm_dev);
 }
 
-static int __tsm_register(struct tsm_dev *tsm_dev, struct pci_tsm_ops *pci_ops)
-{
-	int rc;
-
-	tsm_dev->pci_ops = pci_ops;
-	rc = pci_tsm_register(tsm_dev);
-	if (rc) {
-		tsm_dev->pci_ops = NULL;
-		dev_err(tsm_dev->dev.parent,
-			"PCI/TSM registration failure: %d\n", rc);
-		return rc;
-	}
-
-	/* Notify TSM userspace that PCI/TSM operations are now possible */
-	kobject_uevent(&tsm_dev->dev.kobj, KOBJ_CHANGE);
-	return 0;
-}
-
 struct tsm_dev *tsm_register(struct device *parent, struct pci_tsm_ops *pci_ops)
 {
 	struct tsm_dev *tsm_dev __free(put_tsm_dev) = alloc_tsm_dev(parent);
@@ -91,15 +73,24 @@ struct tsm_dev *tsm_register(struct device *parent, struct pci_tsm_ops *pci_ops)
 	if (rc)
 		return ERR_PTR(rc);
 
-	rc = device_add(dev);
-	if (rc)
+	/* Complete PCI registration before exposing the TSM to class lookup. */
+	tsm_dev->pci_ops = pci_ops;
+	rc = pci_tsm_register(tsm_dev);
+	if (rc) {
+		tsm_dev->pci_ops = NULL;
+		dev_err(parent, "PCI/TSM registration failure: %d\n", rc);
 		return ERR_PTR(rc);
+	}
 
-	rc = __tsm_register(tsm_dev, pci_ops);
+	rc = device_add(dev);
 	if (rc) {
-		device_del(dev);
+		pci_tsm_unregister(tsm_dev);
 		return ERR_PTR(rc);
 	}
+
+	/* Notify TSM userspace that PCI/TSM operations are now possible. */
+	kobject_uevent(&dev->kobj, KOBJ_CHANGE);
+
 	return no_free_ptr(tsm_dev);
 }
 EXPORT_SYMBOL_GPL(tsm_register);
-- 
2.43.0

