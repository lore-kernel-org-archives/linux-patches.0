Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795422884;
	b=e5aAsU9R1B6lOSlvBJeh4/4RpwTJsuDayQsC4pHhi4JYScnI079gn0vtDCGV1MbhBxJw
	 RkL7kClMuvwkgXjo0dHmK55ozlku/cp/W46h4wcxae55DJnRMsjBqF63jQTACMPXEtqLk
	 3ctr/tVYtWQQYIMWREDMkMdszeiOFEnuOHxt+sHRN59pwPhR5No+Dt/1qizitfuMVtsRk
	 us81rofe/5QbsCeUfyCjKSD2Ac5qNYVJljanvehuKp+OemDmRa8HHHIp7Xe1ID/rh6RdN
	 15JWp7AFd4pefCAr3X9hLhBMNNII/DluW3JU3K1GZG1pq2B/YYTj7ihzlmKGY/h3OcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795422884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=xHhglW313MkizJXyvkLCla3gJPdHyjMdO69HShSVBvY=;
	b=4InvYPQ679dcMz12SrlNoCrtYH8QShh8ztGfaLvzxkttrHXJJJYKBwjwcroU/Mqfyo0V
	 yR9NrFkrndjh/FFhR5COZsEde+SZYnI2acvkbU49BlXwPjA0yfF0iSLeeInofl+ClH5xi
	 GS4xTpkW8l2ookLaybGc5w0m3wYifYe2B2JMvrc/g2Ff3mlNdmURECwC4d91S+BOwP+Ky
	 eFKTsNOG9Zgpyo9BrtG0grtfDV7WU9WdRe53p/Ne2N9s/jZ32CmGA+Uw5G7HGqmcO7vVn
	 Ova7F45ASKz5U5RV3ccdMmPUKXzTEQALDfCcGltvSKE/ycmbvS2fnZlGMQfTUHP50mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KK94oxng;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B217B606A32D;
	Mon, 23 Nov 2026 08:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KK94oxng
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237671F000C0;
	Mon, 23 Nov 2026 08:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795422884;
	bh=xHhglW313MkizJXyvkLCla3gJPdHyjMdO69HShSVBvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KK94oxngKzQBD7D/nzwMozk3Ukr4WUYW3WEQELOdCEHe+J78u5xGZX/g20zz2ewXZ
	 MR+1KMWbwlE57s/fYJH0UhJYN646mufkF3J+XcyP2vmbk6N1eQoRWeGE3gysPjUzf1
	 hmrFEpEV5XzlPSv39fkquNa/FzrtH9p+OCWcs59wSGFrEt5LiWlN3vSNVxmO+XoE1b
	 Ry2bG2F5n+cTEiusBKu/hFz+aRNpu5LNgjokgnwi1TiH8siZVff/vZeNBmqpuazX6h
	 ChUoeRzZ4NppemZBN/eyYYssU7Qwh/fXR0AAHW0YnwXDDJYWbTBcQV/1HY0p8NTaNs
	 EtTKlLSX4z2HQ==
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
Subject: [PATCH v1 09/10] PCI/TSM: Build encrypted MMIO descriptors from a supplied report
Date: Mon, 23 Nov 2026 14:03:36 +0530
Message-ID: <20261123083337.2731019-10-aneesh.kumar@kernel.org>
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

The TDISP Device Interface Report describes a device interface's
configuration, including its MMIO ranges and their attributes. Each MMIO
range identifies its BAR, starting physical address and size.

The device adds the MMIO Reporting Offset (MRO) to the physical
addresses included in the report. When the MRO is a multiple of the BAR
size, masking the reported address by the BAR size recovers the offset
within that BAR. Combining this offset with the guest's PCI resource
start gives the corresponding guest physical address.

TSM drivers need to parse these reports and identify the MMIO ranges
requiring private mappings. Provide common PCI/TSM helpers so each
driver does not have to implement the same parsing and resource setup.

Add pci_tsm_mmio_alloc_report() to parse a caller-supplied report.
Record each range's guest physical address and retain its reported
address for firmware mapping validation. Skip non-TEE and currently
unsupported MSI-X ranges.

Add helpers to register the ranges in iomem with IORES_DESC_ENCRYPTED,
Setup requires device::mutex and rejects devices with a PCI driver
attached.

A later guest attestation patch uses these helpers during
evidence-accept. The caller remains responsible for verifying the report
and validating the MMIO mappings before allowing device use.

Based on the original patch from Dan Williams <djbw@kernel.org>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/pci/tsm.c       | 227 ++++++++++++++++++++++++++++++++++++++++
 include/linux/ioport.h  |   1 +
 include/linux/pci-tsm.h |  35 +++++++
 3 files changed, 263 insertions(+)

diff --git a/drivers/pci/tsm.c b/drivers/pci/tsm.c
index 2fbd146db387..c21066e55d3b 100644
--- a/drivers/pci/tsm.c
+++ b/drivers/pci/tsm.c
@@ -21,6 +21,7 @@
 #include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/tsm.h>
+#include <linux/unaligned.h>
 #include <linux/xarray.h>
 #include "pci.h"
 
@@ -650,6 +651,232 @@ static ssize_t dsm_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(dsm);
 
+static void mmio_teardown(struct pci_tsm_mmio *mmio, int nr)
+{
+	while (nr--)
+		remove_resource(pci_tsm_mmio_resource(mmio, nr));
+}
+
+/**
+ * pci_tsm_mmio_setup() - mark device MMIO as encrypted in iomem
+ * @pdev: device owner of MMIO resources
+ * @mmio: container of an array of resources to mark encrypted
+ */
+int pci_tsm_mmio_setup(struct pci_dev *pdev, struct pci_tsm_mmio *mmio)
+{
+	int i;
+
+	device_lock_assert(&pdev->dev);
+	if (pdev->dev.driver)
+		return -EBUSY;
+
+	for (i = 0; i < mmio->nr; i++) {
+		struct resource *res = pci_tsm_mmio_resource(mmio, i);
+		int j;
+
+		if (resource_size(res) == 0 || !res->end)
+			break;
+
+		/* Only require the caller to set the range, init remainder */
+		*res = DEFINE_RES_NAMED_DESC(res->start, resource_size(res),
+					     "PCI MMIO Encrypted",
+					     IORESOURCE_MEM,
+					     IORES_DESC_ENCRYPTED);
+
+		for (j = 0; j < PCI_NUM_RESOURCES; j++)
+			if (resource_contains(pci_resource_n(pdev, j), res))
+				break;
+
+		/* Request is outside of device MMIO */
+		if (j >= PCI_NUM_RESOURCES)
+			break;
+
+		if (insert_resource(&iomem_resource, res) != 0)
+			break;
+	}
+
+	if (i >= mmio->nr)
+		return 0;
+
+	mmio_teardown(mmio, i);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(pci_tsm_mmio_setup);
+
+void pci_tsm_mmio_teardown(struct pci_tsm_mmio *mmio)
+{
+	mmio_teardown(mmio, mmio->nr);
+}
+EXPORT_SYMBOL_GPL(pci_tsm_mmio_teardown);
+
+/*
+ * PCIe ECN TEE Device Interface Security Protocol (TDISP)
+ *
+ * Device Interface Report data object layout as defined by PCIe r7.0 section
+ * 11.3.11
+ */
+#define PCI_TSM_DEVIF_REPORT_MMIO_ATTR_MSIX_TABLE BIT(0)
+#define PCI_TSM_DEVIF_REPORT_MMIO_ATTR_MSIX_PBA BIT(1)
+#define PCI_TSM_DEVIF_REPORT_MMIO_ATTR_IS_NON_TEE BIT(2)
+#define PCI_TSM_DEVIF_REPORT_MMIO_ATTR_IS_UPDATABLE BIT(3)
+#define PCI_TSM_DEVIF_REPORT_MMIO_ATTR_RANGE_ID GENMASK(31, 16)
+
+/* An interface report 'pfn' is 4K in size */
+struct pci_tsm_devif_mmio {
+	__le64 pfn;
+	__le32 nr_pfns;
+	__le32 attributes;
+};
+
+struct pci_tsm_devif_report {
+	__le16 interface_info;
+	__le16 reserved;
+	__le16 msi_x_message_control;
+	__le16 lnr_control;
+	__le32 tph_control;
+	__le32 mmio_range_count;
+	struct pci_tsm_devif_mmio mmio[];
+};
+
+/**
+ * pci_tsm_mmio_alloc_report() - allocate encrypted MMIO range descriptor
+ * @pdev: device owner of MMIO ranges
+ * @report_data: TDISP Device Interface (DevIf) Report blob
+ * @report_sz: DevIf Report size
+ *
+ * Return: the encrypted MMIO range descriptor on success, NULL on failure
+ *
+ * The caller keeps pdev->tsm valid throughout this call.
+ */
+struct pci_tsm_mmio *pci_tsm_mmio_alloc_report(struct pci_dev *pdev,
+					    const void *report_data, size_t report_sz)
+{
+	struct pci_tsm *tsm = pdev->tsm;
+	struct tsm_dev *tsm_dev = tsm->tsm_dev;
+	u64 last_reporting_end;
+	const struct pci_tsm_devif_report *report;
+	u32 mmio_range_count;
+	int last_bar = -1;
+	int i;
+
+	if (report_sz < sizeof(struct pci_tsm_devif_report))
+		return NULL;
+
+	if (dev_WARN_ONCE(&tsm_dev->dev, !IS_ALIGNED((unsigned long) report_data, 8),
+			  "misaligned report data\n"))
+		return NULL;
+
+	report = report_data;
+	mmio_range_count = __le32_to_cpu(report->mmio_range_count);
+
+	/* check that the report object is self-consistent on mmio entries */
+	if (report_sz < struct_size(report, mmio, mmio_range_count))
+		return NULL;
+
+	/* create pci_tsm_mmio descriptors from the report data */
+	struct pci_tsm_mmio *mmio __free(kfree) =
+		kzalloc(struct_size(mmio, mmio, mmio_range_count), GFP_KERNEL);
+	if (!mmio)
+		return NULL;
+
+	for (i = 0; i < mmio_range_count; i++) {
+		u64 range_off;
+		struct range range;
+		const struct pci_tsm_devif_mmio *mmio_data = &report->mmio[i];
+		struct pci_tsm_mmio_entry *entry;
+		/* report values in are in terms of 4K pages */
+		u64 tsm_offset = __le64_to_cpu(mmio_data->pfn) * SZ_4K;
+		u64 size = (u64)__le32_to_cpu(mmio_data->nr_pfns) * SZ_4K;
+		u32 attr = __le32_to_cpu(mmio_data->attributes);
+		int bar = FIELD_GET(PCI_TSM_DEVIF_REPORT_MMIO_ATTR_RANGE_ID,
+				    attr);
+
+		if (bar >= PCI_STD_NUM_BARS ||
+		    !(pci_resource_flags(pdev, bar) & IORESOURCE_MEM)) {
+			pci_dbg(pdev, "Invalid reporting bar ID %d\n", bar);
+			return NULL;
+		}
+
+		if (last_bar > bar) {
+			pci_dbg(pdev, "Reporting bar ID not in ascending order\n");
+			return NULL;
+		}
+
+		if (last_bar < bar) {
+			/* transition to a new bar */
+			last_bar = bar;
+		} else if (tsm_offset < last_reporting_end) {
+			pci_dbg(pdev, "Reporting ranges within BAR not in ascending order\n");
+			return NULL;
+		}
+
+		last_reporting_end = tsm_offset + size;
+		if (last_reporting_end < tsm_offset) {
+			pci_dbg(pdev, "Reporting range overflow\n");
+			return NULL;
+		}
+
+		range_off = tsm_offset & (pci_resource_len(pdev, bar) - 1);
+
+		if (pci_resource_len(pdev, bar) < range_off + size) {
+			pci_dbg(pdev, "Reporting range larger than BAR size\n");
+			return NULL;
+		}
+
+		range.start = pci_resource_start(pdev, bar) + range_off;
+		range.end = range.start + size - 1;
+
+		if (FIELD_GET(PCI_TSM_DEVIF_REPORT_MMIO_ATTR_IS_NON_TEE,
+			      attr)) {
+			pci_dbg(pdev, "Skipping non-TEE range, BAR%d %pra\n",
+				bar, &range);
+			continue;
+		}
+
+		/* Currently not supported */
+		if (FIELD_GET(PCI_TSM_DEVIF_REPORT_MMIO_ATTR_MSIX_TABLE,
+			      attr) ||
+		    FIELD_GET(PCI_TSM_DEVIF_REPORT_MMIO_ATTR_MSIX_PBA, attr)) {
+			pci_dbg(pdev, "Skipping MSIX range BAR%d %pra\n", bar,
+				&range);
+			continue;
+		}
+
+		/* Update __counted_by(nr) before accessing the new entry. */
+		mmio->nr++;
+		entry = pci_tsm_mmio_entry(mmio, mmio->nr - 1);
+		entry->res.start = range.start;
+		entry->res.end = range.end;
+		entry->tsm_offset = tsm_offset;
+	}
+
+	return_ptr(mmio);
+}
+EXPORT_SYMBOL_GPL(pci_tsm_mmio_alloc_report);
+
+/**
+ * pci_tsm_mmio_free() - free a pci_tsm_mmio instance
+ * @pdev: device owner of MMIO ranges
+ * @mmio: instance to free
+ *
+ * Returns 0 if @mmio was idle on entry, -EBUSY otherwise
+ */
+int pci_tsm_mmio_free(struct pci_dev *pdev, struct pci_tsm_mmio *mmio)
+{
+	for (int i = 0; i < mmio->nr; i++) {
+		struct resource *res = pci_tsm_mmio_resource(mmio, i);
+
+		if (dev_WARN_ONCE(&pdev->dev, resource_assigned(res),
+				  "MMIO resource still assigned %pr\n", res))
+			return -EBUSY;
+	}
+
+	kfree(mmio);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_tsm_mmio_free);
+
 /**
  * pci_tsm_unlock() - Transition TDI from LOCKED/RUN to UNLOCKED
  * @pdev: TDI device to unlock
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index f7930b3dfd0a..e8a9fd653620 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -144,6 +144,7 @@ enum {
 	IORES_DESC_RESERVED			= 7,
 	IORES_DESC_SOFT_RESERVED		= 8,
 	IORES_DESC_CXL				= 9,
+	IORES_DESC_ENCRYPTED			= 10,
 };
 
 /*
diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
index c43aa3e85bb0..aef6cfb87082 100644
--- a/include/linux/pci-tsm.h
+++ b/include/linux/pci-tsm.h
@@ -139,12 +139,42 @@ struct pci_tsm_pf0 {
 	struct pci_doe_mb *doe_mb;
 };
 
+/**
+ * struct pci_tsm_mmio_entry - an encrypted MMIO range
+ * @res: MMIO address range (typically Guest Physical Address, GPA)
+ * @tsm_offset: Host Physical Address, HPA obfuscation offset added by the TSM.
+ *		Translates report addresses to GPA.
+ */
+struct pci_tsm_mmio_entry {
+	struct resource res;
+	u64 tsm_offset;
+};
+
+struct pci_tsm_mmio {
+	int nr;
+	struct pci_tsm_mmio_entry mmio[] __counted_by(nr);
+};
+
+static inline struct pci_tsm_mmio_entry *
+pci_tsm_mmio_entry(struct pci_tsm_mmio *mmio, int idx)
+{
+	return &mmio->mmio[idx];
+}
+
+static inline struct resource *pci_tsm_mmio_resource(struct pci_tsm_mmio *mmio,
+						     int idx)
+{
+	return &mmio->mmio[idx].res;
+}
+
 /**
  * struct pci_tsm_devsec - context for tracking private/accepted PCI resources
  * @base_tsm: generic core "tsm" context
+ * @mmio: encrypted MMIO resources for this assigned device
  */
 struct pci_tsm_devsec {
 	struct pci_tsm base_tsm;
+	struct pci_tsm_mmio *mmio;
 };
 
 /* physical function0 and capable of 'connect' */
@@ -206,6 +236,11 @@ bool pci_tsm_context_match_device(struct pci_tsm_context *context,
 				  struct pci_dev *pdev);
 struct tsm_dev *pci_tsm_get_device(struct pci_dev *pdev);
 struct pci_tsm_devsec *to_pci_tsm_devsec(struct pci_tsm *tsm);
+int pci_tsm_mmio_setup(struct pci_dev *pdev, struct pci_tsm_mmio *mmio);
+void pci_tsm_mmio_teardown(struct pci_tsm_mmio *mmio);
+struct pci_tsm_mmio *pci_tsm_mmio_alloc_report(struct pci_dev *pdev,
+					    const void *report_data, size_t report_sz);
+int pci_tsm_mmio_free(struct pci_dev *pdev, struct pci_tsm_mmio *mmio);
 #else
 static inline struct pci_tsm *pci_tsm_trylock_association(struct pci_tsm *tsm)
 {
-- 
2.43.0

