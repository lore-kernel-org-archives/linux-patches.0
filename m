Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029246;
	b=nu2HDQkBrpRI5l0lOTXBInxdF8Q+CtjwXWwRkEjIXqutxlzen5g2zlCSyMq+Kftcki9I
	 0WrdJGURHrO2i7DZoR4UbuyuAetW/1tdkB/gM1kVvA/UemGTTIjSOGDuyWT4LhgUq+CjM
	 F1FcZ/fKFLThQUCoZRFMxbfcCrErAliqJvh8o2k8eFte40122s3F/1FCdTCz37EQinboX
	 X6abeEhRUX7KhNNCVkSjr/l30AVqPW+8skTbGi4tL0WkjjLhIr5U224gzpov7Jj6s8azz
	 b7bzHSCIsKVS/yOJpJxWKc0NSBW+UJ7mK59oOAJVVnnnlAA5SbVEIrgTiRyePxo8AOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j0wZ70K13XgWMmZqJWSpvn+0c5tDDN/OsprHO1lAZH8=;
	b=4XAXVh1C0bg0pFyUajLHml0xlRjHlTfhfuaEBSIdZ5CWSwrlkU2iDK8gKA6LJqBX22+H
	 d65765XOM39l3uswlVV1QRSBzSpT+ULKbCSrB5o1gnETiPRD0zphgQcMv5DJBjTXZVaYG
	 CDv7bQ6FNl1AYR2dqcJm2UsEIUxes71+Cx5puVmK+s+E/qjEYlmjARQNmwDrrtcglReM5
	 GbsjG3DGmqOr2BZrUUxklwQvKI4mCkN6kwiKgfmhVbBXhsvtL2AXzJC8/4pJ8hMmF8/kf
	 O2ZrwRCYfzC8jEC1Djd9aok0yzuSt7CFK5fDl5zG0Rmp1W2z2rtguEf+vgC+Yra+YgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SPBhhCLP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B645606A330;
	Wed, 18 Nov 2026 19:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SPBhhCLP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13FC1F000C4;
	Wed, 18 Nov 2026 19:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029246;
	bh=j0wZ70K13XgWMmZqJWSpvn+0c5tDDN/OsprHO1lAZH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SPBhhCLP9m/mBHgx4JsVIZRugpqpNsyvr/9qyjSxiasidJr+kix8HzmOYnooEbBEv
	 J1ChVW8HmAu745+Cbz43IeXspyVYJDRX2vtymikhbjKd94KBYr7IXoTy3qLz+S252o
	 vv9O7J+VyXl7sU/crb7rQ4o3K3sU+k4WB9gAWMqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0283/1756] ACPI: PCI: Introduce acpi_dev_get_pci_dev()
Date: Wed, 18 Nov 2026 15:40:10 +0100
Message-ID: <20261118150019.678105373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 9d4f0ecb87fd939207682ec30dcaf128d43f07fb ]

Some acpi_get_pci_dev() callers already have a struct ACPI device for
which they want to get the struct pci_dev pointer of the associated
PCI device, so they don't need to look for one.

For this reason, add acpi_dev_get_pci_dev() that will get a PCI device
for a given ACPI one (if possible) and turn acpi_get_pci_dev() into
a static inline helper passing the acpi_fetch_acpi_dev() return value
directly to acpi_dev_get_pci_dev().

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/3430928.44csPzL39Z@rafael.j.wysocki
Stable-dep-of: 2f4ddf2bd1ba ("ACPI: scan: Stop calling acpi_bus_init_power() early")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pci_root.c     | 22 +++++++++++-----------
 include/acpi/acpi_drivers.h |  9 +++++++--
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index b22781852953c..9679c2d47a84f 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -294,20 +294,20 @@ struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle)
 EXPORT_SYMBOL_GPL(acpi_pci_find_root);
 
 /**
- * acpi_get_pci_dev - convert ACPI CA handle to struct pci_dev
- * @handle: the handle in question
+ * acpi_dev_get_pci_dev - Get a struct pci_dev for a given ACPI device
+ * @adev: Target ACPI device.
  *
- * Given an ACPI CA handle, the desired PCI device is located in the
- * list of PCI devices.
+ * Find the PCI device associated with @adev, if any, and bump up its reference
+ * counter.
  *
- * If the device is found, its reference count is increased and this
- * function returns a pointer to its data structure.  The caller must
- * decrement the reference count by calling pci_dev_put().
- * If no device is found, %NULL is returned.
+ * Callers are responsible for dropping the PCI device reference obtained by
+ * this function.
+ *
+ * Return: The struct pci_dev pointer of a reference-counted PCI device on
+ * success or NULL on failure.
  */
-struct pci_dev *acpi_get_pci_dev(acpi_handle handle)
+struct pci_dev *acpi_dev_get_pci_dev(struct acpi_device *adev)
 {
-	struct acpi_device *adev = acpi_fetch_acpi_dev(handle);
 	struct acpi_device_physical_node *pn;
 	struct pci_dev *pci_dev = NULL;
 
@@ -328,7 +328,7 @@ struct pci_dev *acpi_get_pci_dev(acpi_handle handle)
 
 	return pci_dev;
 }
-EXPORT_SYMBOL_GPL(acpi_get_pci_dev);
+EXPORT_SYMBOL_GPL(acpi_dev_get_pci_dev);
 
 /**
  * acpi_pci_osc_control_set - Request control of PCI root _OSC features.
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index b14d165632e76..3f9e16f44b2bd 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -59,14 +59,19 @@ int acpi_pci_link_free_irq(acpi_handle handle);
 struct pci_bus;
 
 #ifdef CONFIG_PCI
-struct pci_dev *acpi_get_pci_dev(acpi_handle);
+struct pci_dev *acpi_dev_get_pci_dev(struct acpi_device *adev);
 #else
-static inline struct pci_dev *acpi_get_pci_dev(acpi_handle handle)
+static inline struct pci_dev *acpi_dev_get_pci_dev(struct acpi_device *adev)
 {
 	return NULL;
 }
 #endif
 
+static inline struct pci_dev *acpi_get_pci_dev(acpi_handle handle)
+{
+	return acpi_dev_get_pci_dev(acpi_fetch_acpi_dev(handle));
+}
+
 /* Arch-defined function to add a bus to the system */
 
 struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root);
-- 
2.53.0



