Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216583;
	b=BpZsAcZhXSBV8SeSvKtPPILCnGtJIAON7JAmHCWwgfRh7eIwfRSJWunng93pxr0oKr9G
	 xTZ4/88DWL7GpLVY90Z6dizOUgLHC36wWZScwmK9phGP8rBL1bPA6Ue3EjfvObfSZxYdD
	 E6ksGGCqNWiOeeGzzTTZ8b+P+MerChnyWOvUYLgGEkwwzpQEVcn8xYzqWN94a9VSZ3D/P
	 6MTFEpxTJ29PvGk9y5wAndIkqTc9KeBz8HsJN5ln6X7IywufFNiUbzJv8zhhDi+VtKPmL
	 /pXP+LSFKT1URMsKDR94UWeA92oWN3F5vc7WTQpGvX5/M9cKwoUB8W/HRo/6nB6fQVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/RNq45i7IZF3bLVy1HSFw55p53ekfPF1rOE7icbWsUU=;
	b=Gul5/x4AQ2yCn2kgnuBYP2m5S/9Z0OT85ExquBp7qfSIgRPwaKNKqDWRr0tqtEfVj3bT
	 7lJNsBm+pmKfEN4I9z100GrjWqQbN8tn7NvXo8xg8j3QfrLYbVZi7doswZ3tTTJJaBVWP
	 DgGGQtMb7QYQNleTWi2dqiT00pVd1V1LxbjcxVc49vJym3Lu0avQEbLd7+/7AVB3pEHbU
	 iGQT2ACUTupw6KcRQ215K3qVcK8/w1JwQn7RVZt2e72m7enSWzNAfbzp/aHVHq8eEtQ4c
	 OqI0TXwRfDAYXXm+b+tpzaj3UIXUvrZ0nRszAWZy/uw/dl0uaSztyyWPUJhu4KzxeGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dm0sI5Wq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A1B606A31A;
	Wed, 28 Oct 2026 19:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dm0sI5Wq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8681F01825;
	Wed, 28 Oct 2026 19:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216583;
	bh=/RNq45i7IZF3bLVy1HSFw55p53ekfPF1rOE7icbWsUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dm0sI5WqImamyX69+UR6M/gV6kD7QE38iK36LegvvMH8Co/GPU5YRAMULBvPwcKLT
	 6XJbDTZ8yRgavTdD8SaKX1U6+ZCHKFM/0ajGXBDKyiZrt0xJ0QO3z0qHocjZwlyyfr
	 46Gy8JnJGT8CMDA4CNGoCqUGkcB+71ftqgZ/E0cM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1608/1887] PCI: Make pci_match_one_device() match on ID instead of device
Date: Wed, 28 Oct 2026 18:01:44 +0100
Message-ID: <20261028170536.059223174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gary Guo <gary@garyguo.net>

[ Upstream commit c967b365d7b51c2297d9be5df39ac3e20638faf4 ]

PCI dynamic ID needs to match IDs against a new ID to see if it already
exists. Existing APIs can only match IDs against devices, so the dynamic ID
insertion code creates a temporary device only for matching purposes.
Rename pci_match_one_device() to pci_match_one_id() so it can be used for
this purpose instead; add a pci_id_from_device() helper to make it easy to
convert users.

Similarly, convert pci_match_id() to do_pci_match_id(). But keep the
existing API because there are many users.

Signed-off-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patch.msgid.link/20260723-pci_id_fix-v4-7-3580726844e1@garyguo.net
Stable-dep-of: 3ffc4c9690c3 ("PCI: Fix UAF when probe runs concurrent to dyn ID removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c | 38 +++++++++++++++++++++++++----------
 drivers/pci/pci.h        | 43 +++++++++++++++++++++++++++++-----------
 drivers/pci/search.c     |  4 +++-
 3 files changed, 62 insertions(+), 23 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 9cbef46dc1af5..2b5b70e5b393a 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -90,6 +90,27 @@ static void pci_free_dynids(struct pci_driver *drv)
 	spin_unlock(&drv->dynids.lock);
 }
 
+/**
+ * do_pci_match_id - See if a PCI ID matches a given pci_id table
+ * @ids: array of PCI device ID structures to search in
+ * @dev_id: the PCI device ID structure to match against.
+ *
+ * Returns the matching pci_device_id structure or %NULL if there is no match.
+ */
+static const struct pci_device_id *
+do_pci_match_id(const struct pci_device_id *ids,
+		const struct pci_device_id *dev_id)
+{
+	if (ids) {
+		while (ids->vendor || ids->subvendor || ids->class_mask) {
+			if (pci_match_one_id(ids, dev_id))
+				return ids;
+			ids++;
+		}
+	}
+	return NULL;
+}
+
 /**
  * pci_match_id - See if a PCI device matches a given pci_id table
  * @ids: array of PCI device ID structures to search in
@@ -105,14 +126,9 @@ static void pci_free_dynids(struct pci_driver *drv)
 const struct pci_device_id *pci_match_id(const struct pci_device_id *ids,
 					 struct pci_dev *dev)
 {
-	if (ids) {
-		while (ids->vendor || ids->subvendor || ids->class_mask) {
-			if (pci_match_one_device(ids, dev))
-				return ids;
-			ids++;
-		}
-	}
-	return NULL;
+	struct pci_device_id dev_id = pci_id_from_device(dev);
+
+	return do_pci_match_id(ids, &dev_id);
 }
 EXPORT_SYMBOL(pci_match_id);
 
@@ -138,15 +154,17 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 {
 	struct pci_dynid *dynid;
 	const struct pci_device_id *found_id = NULL, *ids;
+	struct pci_device_id dev_id;
 
 	/* When driver_override is set, only bind to the matching driver */
 	if (dev->driver_override && strcmp(dev->driver_override, drv->name))
 		return NULL;
 
+	dev_id = pci_id_from_device(dev);
 	/* Look at the dynamic ids first, before the static ones */
 	spin_lock(&drv->dynids.lock);
 	list_for_each_entry(dynid, &drv->dynids.list, node) {
-		if (pci_match_one_device(&dynid->id, dev)) {
+		if (pci_match_one_id(&dynid->id, &dev_id)) {
 			found_id = &dynid->id;
 			break;
 		}
@@ -156,7 +174,7 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 	if (found_id)
 		return found_id;
 
-	for (ids = drv->id_table; (found_id = pci_match_id(ids, dev));
+	for (ids = drv->id_table; (found_id = do_pci_match_id(ids, &dev_id));
 	     ids = found_id + 1) {
 		/*
 		 * The match table is split based on driver_override.
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 32cc16ce8a68b..49a0f23ebe4aa 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -204,21 +204,40 @@ extern unsigned long pci_hotplug_mmio_pref_size;
 extern unsigned long pci_hotplug_bus_size;
 
 /**
- * pci_match_one_device - Tell if a PCI device structure has a matching
- *			  PCI device id structure
- * @id: single PCI device id structure to match
- * @dev: the PCI device structure to match against
+ * pci_id_from_device - Obtain a pci_device_id from a PCI device
+ * @dev: the PCI device
  *
- * Returns the matching pci_device_id structure or %NULL if there is no match.
+ * Return: a pci_device_id filled.
  */
-static inline const struct pci_device_id *
-pci_match_one_device(const struct pci_device_id *id, const struct pci_dev *dev)
+static inline struct pci_device_id pci_id_from_device(const struct pci_dev *dev)
 {
-	if ((id->vendor == PCI_ANY_ID || id->vendor == dev->vendor) &&
-	    (id->device == PCI_ANY_ID || id->device == dev->device) &&
-	    (id->subvendor == PCI_ANY_ID || id->subvendor == dev->subsystem_vendor) &&
-	    (id->subdevice == PCI_ANY_ID || id->subdevice == dev->subsystem_device) &&
-	    !((id->class ^ dev->class) & id->class_mask))
+	return (struct pci_device_id) {
+		.vendor = dev->vendor,
+		.device = dev->device,
+		.subvendor = dev->subsystem_vendor,
+		.subdevice = dev->subsystem_device,
+		.class = dev->class,
+	};
+}
+
+/**
+ * pci_match_one_id - Tell if a PCI device ID matches a needle PCI device ID
+ * @id: single PCI device id structure to match against (needle)
+ * @dev_id: the actual ID from the PCI device
+ *
+ * ID can be retrieved from device using pci_id_from_device().
+ *
+ * Return: the matching pci_device_id structure or %NULL if there is no match.
+ */
+static inline const struct pci_device_id *
+pci_match_one_id(const struct pci_device_id *id,
+		 const struct pci_device_id *dev_id)
+{
+	if ((id->vendor == PCI_ANY_ID || id->vendor == dev_id->vendor) &&
+	    (id->device == PCI_ANY_ID || id->device == dev_id->device) &&
+	    (id->subvendor == PCI_ANY_ID || id->subvendor == dev_id->subvendor) &&
+	    (id->subdevice == PCI_ANY_ID || id->subdevice == dev_id->subdevice) &&
+	    !((id->class ^ dev_id->class) & id->class_mask))
 		return id;
 	return NULL;
 }
diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index b4c138a6ec025..376f5cbe08a87 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -243,8 +243,10 @@ static int match_pci_dev_by_id(struct device *dev, const void *data)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	const struct pci_device_id *id = data;
+	struct pci_device_id dev_id;
 
-	if (pci_match_one_device(id, pdev))
+	dev_id = pci_id_from_device(pdev);
+	if (pci_match_one_id(id, &dev_id))
 		return 1;
 	return 0;
 }
-- 
2.53.0



