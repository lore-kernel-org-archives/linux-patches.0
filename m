Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039560;
	b=Rf7LjHMBByrEBIGo4pgu1qsQfKj5OFZQjpUz97a7ipiIAN9bz2AdqfF/zyJ27dPTtC85
	 x/isFj0HP9k894jgCA66SvfmUOFGQppv9t0e9nDMRrtL1nqvfyQB8ZLhXew+RygYHt8Aj
	 E2rHS2pr+XrRu7+nmxToHmZVCPtXAMAZTj5on+Za44fY0M8lMiLj64Ip/BM60SBVRzh8c
	 bGUhC4Fw8aFRLZlCB8Z17FtAtXIKIJXPUEFCIbNWiuQ1shLKInDbW20ccNHrerNkJdXQu
	 qDFXUqljSJEzOy+/2ssD4clAbkxLJgtQxWeZ/lIVzFAZ3sazMJTQ+c3NoyaNTrBbQvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dBzZUl9TBvVbWT55EusNw8o2WxnHg5SsmS0aDZV2UYY=;
	b=juwWOmmeLkpjDSY2vHCSAQvjccqiF5BV1LtEhO2aefmqUmhv2yrVYgiJwhAtfastGhZl
	 BibP7lcs3cnNDC5rzEdOSNBwkR6QwgyhsR/+72dMGB3r426+tVNALNDwoABn+H8g8M3Yf
	 Gtt+t0WShNQn9BuACChqs9Svw9EUcIcsNW2VOPx5gGOxIChXjBVfyczVdZPibfDp+KgSt
	 vn+JWZwWn3FPEWInrpGZUgsj+3+dxqrjNcV696EH4GBvAhv87P0a67cYSfLVI3c8gqTn0
	 jsyn91mcmLd9tUpzgO3cUAyAJk99uSywIrOUWHFYd16kfzNJ2wH41epR9QuFq9fz9kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mfPytp3S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD35D606A325;
	Wed, 18 Nov 2026 22:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mfPytp3S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1007F1F000C4;
	Wed, 18 Nov 2026 22:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039560;
	bh=dBzZUl9TBvVbWT55EusNw8o2WxnHg5SsmS0aDZV2UYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mfPytp3SPz1gZPnHk5bF50zx0xW8eWHE3cTLlkLRMbVU3Hyc5rYWfWE+FHLWmDv4Z
	 krXuZ0y7ZKL4vhUC47b+AqPz/DsV5W0ReHzMoIhVbAPFKQex22M85sFkod2zGmW1hH
	 yW2YvGCno1BNMqryQzpLCwn5bAClFCXiBpMYVSL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2102/3318] ACPI: PCI: Introduce acpi_dev_get_pci_dev()
Date: Wed, 18 Nov 2026 15:45:24 +0100
Message-ID: <20261118150425.143678761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 80c12398218f1..6fc7d0f6b1370 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -299,20 +299,20 @@ struct acpi_handle_node {
 };
 
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
 
@@ -333,7 +333,7 @@ struct pci_dev *acpi_get_pci_dev(acpi_handle handle)
 
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



