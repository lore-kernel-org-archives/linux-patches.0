Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC3D34CFDA
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 05:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774589233; cv=none; b=rHEWB9v/pVfj1VtiiqFvhvZUpGDDhKNU23pNlLuTjDZpMqrXiDT+1uHWTgn4I+F9ojjMs7IRpLtbKk3TCF9EyBdgsiXcGFX/zkumSWKPs+tmZufj8dRJfcKEn6mgyYfNyMapomCT9zGJfFepbq7TEOJMp1YBQMOYb4V7nTg1cSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774589233; c=relaxed/simple;
	bh=GMBYpZmceq0OlfuLFZhD3fmrAyMPVoOz3a4NOzWIB1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a83MbWrZKa/4Js2HN3qh3hH02PPnGJeiGjUVffYraOPFw1nMcSRmp4MEcA6UQIzKgE8LagoVOwJKwEFwyhBVqIM3762fkLyINaf9hw1Ptfu+ssGClVIQi8KtxfN3+Zu3qs+uvcyoMnXzuN+M0YmjVQBEVdudEoHTWNbRPQyK/mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T7916O34; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T7916O34"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774589231; x=1806125231;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GMBYpZmceq0OlfuLFZhD3fmrAyMPVoOz3a4NOzWIB1A=;
  b=T7916O340737CfucWZP42cMv5UT5/tCCXwFqBTHtwtf+NZpolbzwRBY8
   U+SsqxiNMA40pBKz95pFiwV6TCcEhz8jf6aM+BZbiR25p6jNfZ+N/B9Rx
   PMbcX2VGuXZSYOfcimEXiQn1+oXhdWo0JOHR+1Kbx5KcugLAylbF1eYg1
   sMfFfa89uNx2FELcHzUC2lfAVmDl/l1RFl5H6krYOat2gTIuI4Xj+KrQK
   PQQ/NDQEwton8D+3kDJcEwKpfBN2RBBgm5MOC9CoV0LTgGC5Eba10vMV8
   AwdvU6twGjiY/cWY9HIRe9Jaep3G76JGmGvm8lQXhOlrJ2txcguZe11ua
   Q==;
X-CSE-ConnectionGUID: iSNudnEWQkOct9Kb88+lSA==
X-CSE-MsgGUID: hINTwue7R7OSB/bcnIIjhQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="101117969"
X-IronPort-AV: E=Sophos;i="6.23,143,1770624000"; 
   d="scan'208";a="101117969"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 22:27:07 -0700
X-CSE-ConnectionGUID: 3udjRQiRRk2bD77S64RF3Q==
X-CSE-MsgGUID: SVZ295VqRoWn6+WQ0p1bsg==
X-ExtLoop1: 1
Received: from dwillia2-desk.jf.intel.com ([10.88.27.145])
  by fmviesa003.fm.intel.com with ESMTP; 26 Mar 2026 22:27:06 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: dave.jiang@intel.com
Cc: patches@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com
Subject: [PATCH 9/9] tools/testing/cxl: Test dax_hmem takeover of CXL regions
Date: Thu, 26 Mar 2026 22:28:21 -0700
Message-ID: <20260327052821.440749-10-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327052821.440749-1-dan.j.williams@intel.com>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When platform firmware is committed to publishing EFI_CONVENTIONAL_MEMORY
in the memory map, but CXL fails to assemble the region, dax_hmem can
attempt to attach a dax device to the memory range.

Take advantage of the new ability to support multiple "hmem_platform"
devices, and to enable regression testing of several scenarios:

* CXL correctly assembles a region, check dax_hmem fails to attach dax
* CXL fails to assemble a region, check dax_hmem successfully attaches dax
* Check that loading the dax_cxl driver loads the dax_hmem driver
* Attempt to race cxl_mock_mem async probe vs dax_hmem probe flushing.
  Check that both positive and negative cases.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/cxl/test/mock.h      |  8 +++++
 tools/testing/cxl/test/cxl.c       | 57 ++++++++++++++++++++++++++++++
 tools/testing/cxl/test/hmem_test.c | 47 ++++++++++++++++++++++++
 tools/testing/cxl/test/mem.c       |  3 ++
 tools/testing/cxl/test/mock.c      | 50 ++++++++++++++++++++++++++
 tools/testing/cxl/Kbuild           |  7 ++++
 tools/testing/cxl/test/Kbuild      |  1 +
 7 files changed, 173 insertions(+)
 create mode 100644 tools/testing/cxl/test/hmem_test.c

diff --git a/tools/testing/cxl/test/mock.h b/tools/testing/cxl/test/mock.h
index 2684b89c8aa2..4f57dc80ae7d 100644
--- a/tools/testing/cxl/test/mock.h
+++ b/tools/testing/cxl/test/mock.h
@@ -2,6 +2,7 @@
 
 #include <linux/list.h>
 #include <linux/acpi.h>
+#include <linux/dax.h>
 #include <cxl.h>
 
 struct cxl_mock_ops {
@@ -27,8 +28,15 @@ struct cxl_mock_ops {
 	int (*hmat_get_extended_linear_cache_size)(struct resource *backing_res,
 						   int nid,
 						   resource_size_t *cache_size);
+	int (*walk_hmem_resources)(struct device *host, walk_hmem_fn fn);
+	int (*region_intersects)(resource_size_t start, size_t size,
+				 unsigned long flags, unsigned long desc);
+	int (*region_intersects_soft_reserve)(resource_size_t start,
+					      size_t size);
 };
 
+int hmem_test_init(void);
+void hmem_test_exit(void);
 void register_cxl_mock_ops(struct cxl_mock_ops *ops);
 void unregister_cxl_mock_ops(struct cxl_mock_ops *ops);
 struct cxl_mock_ops *get_cxl_mock_ops(int *index);
diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 7deeb7ff7bdf..9a9f52090c1d 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -1121,6 +1121,53 @@ static void mock_cxl_endpoint_parse_cdat(struct cxl_port *port)
 	cxl_endpoint_get_perf_coordinates(port, ep_c);
 }
 
+/*
+ * Simulate that the first half of mock CXL Window 0 is "Soft Reserve" capacity
+ */
+static int mock_walk_hmem_resources(struct device *host, walk_hmem_fn fn)
+{
+	struct acpi_cedt_cfmws *cfmws = mock_cfmws[0];
+	struct resource window =
+		DEFINE_RES_MEM(cfmws->base_hpa, cfmws->window_size / 2);
+
+	dev_dbg(host, "walk cxl_test resource: %pr\n", &window);
+	return fn(host, 0, &window);
+}
+
+/*
+ * This should only be called by the dax_hmem case, treat mismatches (negative
+ * result) as "fallback to base region_intersects()". Simulate that the first
+ * half of mock CXL Window 0 is IORES_DESC_CXL capacity.
+ */
+static int mock_region_intersects(resource_size_t start, size_t size,
+				  unsigned long flags, unsigned long desc)
+{
+	struct resource res = DEFINE_RES_MEM(start, size);
+	struct acpi_cedt_cfmws *cfmws = mock_cfmws[0];
+	struct resource window =
+		DEFINE_RES_MEM(cfmws->base_hpa, cfmws->window_size / 2);
+
+	if (resource_overlaps(&res, &window))
+		return REGION_INTERSECTS;
+	pr_debug("warning: no cxl_test CXL intersection for %pr\n", &res);
+	return -1;
+}
+
+
+static int
+mock_region_intersects_soft_reserve(resource_size_t start, size_t size)
+{
+	struct resource res = DEFINE_RES_MEM(start, size);
+	struct acpi_cedt_cfmws *cfmws = mock_cfmws[0];
+	struct resource window =
+		DEFINE_RES_MEM(cfmws->base_hpa, cfmws->window_size / 2);
+
+	if (resource_overlaps(&res, &window))
+		return REGION_INTERSECTS;
+	pr_debug("warning: no cxl_test soft reserve intersection for %pr\n", &res);
+	return -1;
+}
+
 static struct cxl_mock_ops cxl_mock_ops = {
 	.is_mock_adev = is_mock_adev,
 	.is_mock_bridge = is_mock_bridge,
@@ -1136,6 +1183,9 @@ static struct cxl_mock_ops cxl_mock_ops = {
 	.devm_cxl_add_dport_by_dev = mock_cxl_add_dport_by_dev,
 	.hmat_get_extended_linear_cache_size =
 		mock_hmat_get_extended_linear_cache_size,
+	.walk_hmem_resources = mock_walk_hmem_resources,
+	.region_intersects = mock_region_intersects,
+	.region_intersects_soft_reserve = mock_region_intersects_soft_reserve,
 	.list = LIST_HEAD_INIT(cxl_mock_ops.list),
 };
 
@@ -1561,8 +1611,14 @@ static __init int cxl_test_init(void)
 	if (rc)
 		goto err_root;
 
+	rc = hmem_test_init();
+	if (rc)
+		goto err_mem;
+
 	return 0;
 
+err_mem:
+	cxl_mem_exit();
 err_root:
 	platform_device_put(cxl_acpi);
 err_rch:
@@ -1600,6 +1656,7 @@ static __exit void cxl_test_exit(void)
 {
 	int i;
 
+	hmem_test_exit();
 	cxl_mem_exit();
 	platform_device_unregister(cxl_acpi);
 	cxl_rch_topo_exit();
diff --git a/tools/testing/cxl/test/hmem_test.c b/tools/testing/cxl/test/hmem_test.c
new file mode 100644
index 000000000000..3a1a089e1721
--- /dev/null
+++ b/tools/testing/cxl/test/hmem_test.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2026 Intel Corporation */
+#include <linux/moduleparam.h>
+#include <linux/workqueue.h>
+#include "../../../drivers/dax/bus.h"
+
+static bool hmem_test;
+
+static void hmem_test_work(struct work_struct *work)
+{
+}
+
+static void hmem_test_release(struct device *dev)
+{
+	struct hmem_platform_device *hpdev =
+		container_of(dev, typeof(*hpdev), pdev.dev);
+
+	memset(hpdev, 0, sizeof(*hpdev));
+}
+
+static struct hmem_platform_device hmem_test_device = {
+	.pdev = {
+		.name = "hmem_platform",
+		.id = 1,
+		.dev = {
+			.release = hmem_test_release,
+		},
+	},
+	.work = __WORK_INITIALIZER(hmem_test_device.work, hmem_test_work),
+};
+
+int hmem_test_init(void)
+{
+	if (!hmem_test)
+		return 0;
+
+	return platform_device_register(&hmem_test_device.pdev);
+}
+
+void hmem_test_exit(void)
+{
+	if (hmem_test)
+		platform_device_unregister(&hmem_test_device.pdev);
+}
+
+module_param(hmem_test, bool, 0444);
+MODULE_PARM_DESC(hmem_test, "Enable/disable the dax_hmem test platform device");
diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index cb87e8c0e63c..cc847e9aeceb 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -1695,6 +1695,9 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 	struct cxl_dpa_info range_info = { 0 };
 	int rc;
 
+	/* Increase async probe race window */
+	usleep_range(500*1000, 1000*1000);
+
 	mdata = devm_kzalloc(dev, sizeof(*mdata), GFP_KERNEL);
 	if (!mdata)
 		return -ENOMEM;
diff --git a/tools/testing/cxl/test/mock.c b/tools/testing/cxl/test/mock.c
index b8fcb50c1027..6454b868b122 100644
--- a/tools/testing/cxl/test/mock.c
+++ b/tools/testing/cxl/test/mock.c
@@ -251,6 +251,56 @@ struct cxl_dport *__wrap_devm_cxl_add_dport_by_dev(struct cxl_port *port,
 }
 EXPORT_SYMBOL_NS_GPL(__wrap_devm_cxl_add_dport_by_dev, "CXL");
 
+int __wrap_region_intersects(resource_size_t start, size_t size,
+			     unsigned long flags, unsigned long desc)
+{
+	int rc = -1;
+	int index;
+	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
+
+	if (ops)
+		rc = ops->region_intersects(start, size, flags, desc);
+	if (rc < 0)
+		rc = region_intersects(start, size, flags, desc);
+	put_cxl_mock_ops(index);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(__wrap_region_intersects);
+
+int __wrap_region_intersects_soft_reserve(resource_size_t start, size_t size)
+{
+	int rc = -1;
+	int index;
+	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
+
+	if (ops)
+		rc = ops->region_intersects_soft_reserve(start, size);
+	if (rc < 0)
+		rc = region_intersects_soft_reserve(start, size);
+	put_cxl_mock_ops(index);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(__wrap_region_intersects_soft_reserve);
+
+int __wrap_walk_hmem_resources(struct device *host, walk_hmem_fn fn)
+{
+	int index, rc = 0;
+	bool is_mock = strcmp(dev_name(host), "hmem_platform.1") == 0;
+	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
+
+	if (is_mock) {
+		if (ops)
+			rc = ops->walk_hmem_resources(host, fn);
+	} else {
+		rc = walk_hmem_resources(host, fn);
+	}
+	put_cxl_mock_ops(index);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(__wrap_walk_hmem_resources);
+
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("cxl_test: emulation module");
 MODULE_IMPORT_NS("ACPI");
diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index 53d84a6874b7..540425c7cd41 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -11,8 +11,12 @@ ldflags-y += --wrap=devm_cxl_endpoint_decoders_setup
 ldflags-y += --wrap=hmat_get_extended_linear_cache_size
 ldflags-y += --wrap=devm_cxl_add_dport_by_dev
 ldflags-y += --wrap=devm_cxl_switch_port_decoders_setup
+ldflags-y += --wrap=walk_hmem_resources
+ldflags-y += --wrap=region_intersects
+ldflags-y += --wrap=region_intersects_soft_reserve
 
 DRIVERS := ../../../drivers
+DAX_HMEM_SRC := $(DRIVERS)/dax/hmem
 CXL_SRC := $(DRIVERS)/cxl
 CXL_CORE_SRC := $(DRIVERS)/cxl/core
 ccflags-y := -I$(srctree)/drivers/cxl/
@@ -70,6 +74,9 @@ cxl_core-y += config_check.o
 cxl_core-y += cxl_core_test.o
 cxl_core-y += cxl_core_exports.o
 
+obj-m += dax_hmem.o
+dax_hmem-y := $(DAX_HMEM_SRC)/hmem.o
+
 KBUILD_CFLAGS := $(filter-out -Wmissing-prototypes -Wmissing-declarations, $(KBUILD_CFLAGS))
 
 obj-m += test/
diff --git a/tools/testing/cxl/test/Kbuild b/tools/testing/cxl/test/Kbuild
index af50972c8b6d..c168e3c998a7 100644
--- a/tools/testing/cxl/test/Kbuild
+++ b/tools/testing/cxl/test/Kbuild
@@ -7,6 +7,7 @@ obj-m += cxl_mock_mem.o
 obj-m += cxl_translate.o
 
 cxl_test-y := cxl.o
+cxl_test-y += hmem_test.o
 cxl_mock-y := mock.o
 cxl_mock_mem-y := mem.o
 
-- 
2.53.0

