Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216828;
	b=1ayTlOUsGFrM/bB5tYEh6rKTeDb9J9ThOffQ2YVePExn1hnx1IfawhtzHSPaix2uPmOH
	 GrGKLBSXnL3iLY10GBm9QRhuUhX0TzbLHTX4bu2p1Q0hnf8Q/ubF8rQXprpcnzmXRrQwu
	 QheGwbvTXsj6ObCFg/Yps4FKC8XNoIKsS1Z99h9hD8psLpq0VPW7LoDh9YbomEvyBaVkj
	 L9A/rkv9jZ3ryF8NAXShS/qgxmr3DGDZqtohUX8YezPjNNUGlNRz/s+gUtNoBnQQhrxNY
	 IVlGJYMA4QdzbkArWFHoYWq+B+NFFR2xzh9egcLD/H9lDBR3lkC1Xx/N4chV9yrsZkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pAKsgPZw0Fj2F9+ordR0zXYo2l2EFXcWFkBdywsVe60=;
	b=B+esB7gu2zOwz6vJ10pyDNpk/WUiLYV84U+rwEeDSLiispd4wpqJAbPFqDcuffbnZZM3
	 daB0pBXf7nbShT2qko/u/sS6aLRDR0F8yPe7lqrvsjxGWBmh2qghJfe1ixMzCWajmfnCr
	 pwvQTG1G7Oo0m1T1Ud8op0SoLvh57IwyzE9opSWeLpKZvrBh/vcW3m9O/IB3ufcmhCsO6
	 kx/G5l35hyF02G5dV3sVN/j0dLlE3Y/Tph6Q3HfGumsk3cKRVK5uzVA5B483XRQTpG7n7
	 WjfAYp8b7hSEDBwJoXWWf936StJ0q8U7JwWRm23gKI9wD0/Kv9DEPIa7taWfAi1wgGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V0hbFWH6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DEF606A31D;
	Wed, 28 Oct 2026 19:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V0hbFWH6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42E91F01825;
	Wed, 28 Oct 2026 19:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216828;
	bh=pAKsgPZw0Fj2F9+ordR0zXYo2l2EFXcWFkBdywsVe60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V0hbFWH6qPdDRAArZEQVORC8sS5mFfJ96eIWbrxu2n0SzPErAfQ1azXTMIav3XCX8
	 XSWrPLd1XRB0cwNwTTMgAPNInJ/ajbL4d9SHQgkqQviHzuMVnkW6wzFwjuNzL997gM
	 SYtTVg5xJ+ifCUx71cknC+P3HzHG048Y5SrUFP4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1649/1887] ACPI: bus: Introduce acpi_bus_get_primary_device()
Date: Wed, 28 Oct 2026 18:02:25 +0100
Message-ID: <20261028170536.988749316@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 72530e1f72b0515a73fd88292254d04fecf03649 ]

The function used for obtaining the first "physical" device for which
the given ACPI one is the ACPI companion, acpi_get_first_physical_node(),
may return a stale device pointer (mostly in theory) because
acpi_unbind_one() may run as a whole after dropping the ACPI device's
physical_node_lock in acpi_get_first_physical_node() and before it
returns.  The last reference to the "physical" device may be dropped
then before the pointer to it is returned to the caller.

If that happens and the acpi_get_first_physical_node() caller invokes
get_device() on the pointer obtained from it, which is done by the
majority of its callers, a use-after-free will occur.

To prepare for addressing this problem, introduce a new function for
getting the first "physical" device associated with the given ACPI one
(the "primary physical device") that will also reference count the
device in question before returning a pointer to it.

Make that new function and acpi_get_first_physical_node() share the
physical node list lookup code.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/2843318.mvXUDI8C0e@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bus.c      | 54 +++++++++++++++++++++++++++++------------
 include/acpi/acpi_bus.h |  6 +++++
 2 files changed, 44 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index fafa15507b141..4ec726be27a63 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -643,30 +643,52 @@ static int __init acpi_setup_sb_notify_handler(void)
                              Device Matching
    -------------------------------------------------------------------------- */
 
+
+static struct device *primary_physical_device(struct acpi_device *adev)
+{
+	struct acpi_device_physical_node *pn;
+
+	pn = list_first_entry_or_null(&adev->physical_node_list,
+				      struct acpi_device_physical_node, node);
+	if (pn)
+		return pn->dev;
+
+	return NULL;
+}
+
 /**
- * acpi_get_first_physical_node - Get first physical node of an ACPI device
+ * acpi_bus_get_primary_device - Get first physical device for a given ACPI one
+ * @adev: ACPI device to get the first physical device for.
+ *
+ * Find the first physical device for which @adev is the ACPI companion and
+ * reference count it if present.
+ *
+ * Return: Pointer to the first physical counterpart of @adev or NULL if there
+ * are none.  Callers are responsible for invoking put_device() on the returned
+ * device.
+ */
+struct device *acpi_bus_get_primary_device(struct acpi_device *adev)
+{
+	if (!adev)
+		return NULL;
+
+	guard(mutex)(&adev->physical_node_lock);
+
+	return get_device(primary_physical_device(adev));
+}
+EXPORT_SYMBOL_GPL(acpi_bus_get_primary_device);
+
+/**
+ * acpi_get_first_physical_node - Find first physical node of an ACPI device
  * @adev:	ACPI device in question
  *
  * Return: First physical node of ACPI device @adev
  */
 struct device *acpi_get_first_physical_node(struct acpi_device *adev)
 {
-	struct mutex *physical_node_lock = &adev->physical_node_lock;
-	struct device *phys_dev;
-
-	mutex_lock(physical_node_lock);
-	if (list_empty(&adev->physical_node_list)) {
-		phys_dev = NULL;
-	} else {
-		const struct acpi_device_physical_node *node;
+	guard(mutex)(&adev->physical_node_lock);
 
-		node = list_first_entry(&adev->physical_node_list,
-					struct acpi_device_physical_node, node);
-
-		phys_dev = node->dev;
-	}
-	mutex_unlock(physical_node_lock);
-	return phys_dev;
+	return primary_physical_device(adev);
 }
 EXPORT_SYMBOL_GPL(acpi_get_first_physical_node);
 
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 6badc50ec4e66..147b560947c66 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -556,6 +556,7 @@ void acpi_bus_unregister_driver(struct acpi_driver *driver);
 int acpi_bus_scan(acpi_handle handle);
 void acpi_bus_trim(struct acpi_device *start);
 acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
+struct device *acpi_bus_get_primary_device(struct acpi_device *adev);
 int acpi_match_device_ids(struct acpi_device *device,
 			  const struct acpi_device_id *ids);
 void acpi_set_modalias(struct acpi_device *adev, const char *default_id,
@@ -797,6 +798,11 @@ static inline void acpi_put_acpi_dev(struct acpi_device *adev)
 }
 #else	/* CONFIG_ACPI */
 
+static inline struct device *acpi_bus_get_primary_device(struct acpi_device *adev)
+{
+	return NULL;
+}
+
 static inline int register_acpi_bus_type(void *bus) { return 0; }
 static inline int unregister_acpi_bus_type(void *bus) { return 0; }
 
-- 
2.53.0



