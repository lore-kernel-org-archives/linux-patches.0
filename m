Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E801C211A3C
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 22:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744324343; cv=none; b=IrJ68zLQw5ctYStDOteuYcakVk1mYnLMUUVnV0aG86J+aHT49iAwUKY0qBDlNJrL3PsNcG7tZ3mb7rydcUG7DWSR4RHVbVAkw86C0vTSutXRssYLLkYJCPRF/i2giQUBIrg2eS0T3aH7h0Id5ynmKn9JiAGFEq1fcs8yfAD3ClU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744324343; c=relaxed/simple;
	bh=1j1mdJXfx0wueebPZ05boLFylytFBjvR89Q6vMiokl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1Cqb4SBmYtkA5/HlNeodzw0VqrVw7HNwZdzeb78tmaDhtPcla8g1HsEhB7EszYWiAmbaI+zYt6WnORYKpliDT1lD2nGf7nbVfXcJBH1wwc/EG0pSu7/q9rkLCxMl1NyD4iU/lEyqax0AKpFy8s0UnDV5CbMhweYTcT6tHcCeFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MtuTrynD; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MtuTrynD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744324342; x=1775860342;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1j1mdJXfx0wueebPZ05boLFylytFBjvR89Q6vMiokl0=;
  b=MtuTrynDkIBE8Rb2Bch2mIByl9/w6cwQNcTXH5LvFChUS0EXubp0TICN
   rzRFIQC9qsxh0us8Yzoz5vwmcmJyS+ixvZDGsrl7ukN68RoVHlbwmowDy
   5ck8V0TFXJ6D+sBoqDT5YStzqVmsiXKZAFo8bZTiJYK+sC3qeB5tp2fH8
   tIEqVxditi+p6wchWXmuOiRksuLbv5FnoFLClGnN+iDqI/+xzomEDA/EK
   CNue5PY4Hzl3AaEloPU5cJSlHhMnByn63sW3CwdUtUZ8NmUaVTsEbwrJf
   66YEMKB95m/ZG5/0bUDwu8ksOXZKRSHyQRroHcRFuFA46B3XUXXn9xP/Z
   Q==;
X-CSE-ConnectionGUID: JEN6U8zTRLyqgwAgEg+dTQ==
X-CSE-MsgGUID: NA2T93m7Ss6grm92YX94jQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11400"; a="56845637"
X-IronPort-AV: E=Sophos;i="6.15,203,1739865600"; 
   d="scan'208";a="56845637"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 15:32:17 -0700
X-CSE-ConnectionGUID: 99VlDKOnTD2C3YIi54+vrw==
X-CSE-MsgGUID: 5JmEZIZ1TV+kEiAbNkvQ2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,203,1739865600"; 
   d="scan'208";a="128988756"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 15:32:17 -0700
From: Tony Luck <tony.luck@intel.com>
To: rafael.j.wysocki@intel.com
Cc: lenb@kernel.org,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 3/4] ACPI/MRRM: Add /sys files to describe memory ranges
Date: Thu, 10 Apr 2025 15:32:06 -0700
Message-ID: <20250410223207.257722-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250410223207.257722-1-tony.luck@intel.com>
References: <20250410223207.257722-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Perf and resctrl users need an enumeration of which memory addresses
are bound to which "region" tag.

Parse the ACPI MRRM table and add /sys entries for each memory range
describing base address, length, NUMA node, and which region tags apply
for same-socket and cross-socket access.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/acpi/acpi_mrrm.c | 145 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 144 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_mrrm.c b/drivers/acpi/acpi_mrrm.c
index ab8022e58da5..9d8d332d383e 100644
--- a/drivers/acpi/acpi_mrrm.c
+++ b/drivers/acpi/acpi_mrrm.c
@@ -3,12 +3,16 @@
  * Copyright (c) 2025, Intel Corporation.
  *
  * Memory Range and Region Mapping (MRRM) structure
+ *
+ * Parse and report the platform's MRRM table in /sys.
  */
 
 #define pr_fmt(fmt) "acpi/mrrm: " fmt
 
 #include <linux/acpi.h>
 #include <linux/init.h>
+#include <linux/string.h>
+#include <linux/sysfs.h>
 
 static int max_mem_region = -ENOENT;
 
@@ -18,25 +22,164 @@ int acpi_mrrm_max_mem_region(void)
 	return max_mem_region;
 }
 
+struct mrrm_mem_range_entry {
+	u64 base;
+	u64 length;
+	int node;
+	u8  local_region_id;
+	u8  remote_region_id;
+};
+
+static struct mrrm_mem_range_entry *mrrm_mem_range_entry;
+static u32 mrrm_mem_entry_num;
+
+static int get_node_num(struct mrrm_mem_range_entry *e)
+{
+#ifdef CONFIG_NUMA
+	unsigned int nid;
+
+	for_each_online_node(nid) {
+		for (int z = 0; z < MAX_NR_ZONES; z++) {
+			struct zone *zone = NODE_DATA(nid)->node_zones + z;
+
+			if (!populated_zone(zone))
+				continue;
+			if (zone_intersects(zone, PHYS_PFN(e->base), PHYS_PFN(e->length)))
+				return zone->node;
+		}
+	}
+#endif
+
+	return -ENOENT;
+}
+
 static __init int acpi_parse_mrrm(struct acpi_table_header *table)
 {
+	struct acpi_mrrm_mem_range_entry *mre_entry;
 	struct acpi_table_mrrm *mrrm;
+	void *mre, *mrrm_end;
+	int mre_count = 0;
 
 	mrrm = (struct acpi_table_mrrm *)table;
 	if (!mrrm)
 		return -ENODEV;
 
+	if (mrrm->flags & ACPI_MRRM_FLAGS_REGION_ASSIGNMENT_OS)
+		return -EOPNOTSUPP;
+
+	mrrm_end = (void *)mrrm + mrrm->header.length - 1;
+	mre = (void *)mrrm + sizeof(struct acpi_table_mrrm);
+	while (mre < mrrm_end) {
+		mre_entry = mre;
+		mre_count++;
+		mre += mre_entry->header.length;
+	}
+	if (!mre_count) {
+		pr_info(FW_BUG "No ranges listed in MRRM table\n");
+		return -EINVAL;
+	}
+
+	mrrm_mem_range_entry = kmalloc_array(mre_count, sizeof(*mrrm_mem_range_entry),
+					     GFP_KERNEL | __GFP_ZERO);
+	if (!mrrm_mem_range_entry)
+		return -ENOMEM;
+
+	mre = (void *)mrrm + sizeof(struct acpi_table_mrrm);
+	while (mre < mrrm_end) {
+		struct mrrm_mem_range_entry *e;
+
+		mre_entry = mre;
+		e = mrrm_mem_range_entry + mrrm_mem_entry_num;
+
+		e->base = mre_entry->addr_base;
+		e->length = mre_entry->addr_len;
+		e->node = get_node_num(e);
+
+		if (mre_entry->region_id_flags & ACPI_MRRM_VALID_REGION_ID_FLAGS_LOCAL)
+			e->local_region_id = mre_entry->local_region_id;
+		else
+			e->local_region_id = -1;
+		if (mre_entry->region_id_flags & ACPI_MRRM_VALID_REGION_ID_FLAGS_REMOTE)
+			e->remote_region_id = mre_entry->remote_region_id;
+		else
+			e->remote_region_id = -1;
+
+		mrrm_mem_entry_num++;
+		mre += mre_entry->header.length;
+	}
+
 	max_mem_region = mrrm->max_mem_region;
 
 	return 0;
 }
 
+#define RANGE_ATTR(name, fmt)						\
+static ssize_t name##_show(struct kobject *kobj,			\
+			  struct kobj_attribute *attr, char *buf)	\
+{									\
+	struct mrrm_mem_range_entry *mre;				\
+	const char *kname = kobject_name(kobj);				\
+	int n, ret;							\
+									\
+	ret = kstrtoint(kname + 5, 10, &n);				\
+	if (ret)							\
+		return ret;						\
+									\
+	mre = mrrm_mem_range_entry + n;					\
+									\
+	return sysfs_emit(buf, fmt, mre->name);				\
+}									\
+static struct kobj_attribute name##_attr = __ATTR_RO(name)
+
+RANGE_ATTR(base, "0x%llx\n");
+RANGE_ATTR(length, "0x%llx\n");
+RANGE_ATTR(node, "%d\n");
+RANGE_ATTR(local_region_id, "%d\n");
+RANGE_ATTR(remote_region_id, "%d\n");
+
+static struct attribute *memory_range_attrs[] = {
+	&base_attr.attr,
+	&length_attr.attr,
+	&node_attr.attr,
+	&local_region_id_attr.attr,
+	&remote_region_id_attr.attr,
+	NULL
+};
+
+ATTRIBUTE_GROUPS(memory_range);
+
+static __init int add_boot_memory_ranges(void)
+{
+	struct kobject *pkobj, *kobj;
+	int ret = -EINVAL;
+	char *name;
+
+	pkobj = kobject_create_and_add("memory_ranges", acpi_kobj);
+
+	for (int i = 0; i < mrrm_mem_entry_num; i++) {
+		name = kasprintf(GFP_KERNEL, "range%d", i);
+		if (!name)
+			break;
+
+		kobj = kobject_create_and_add(name, pkobj);
+
+		ret = sysfs_create_groups(kobj, memory_range_groups);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
 static __init int mrrm_init(void)
 {
 	int ret;
 
 	ret = acpi_table_parse(ACPI_SIG_MRRM, acpi_parse_mrrm);
 
-	return ret;
+	if (ret < 0)
+		return ret;
+
+	return add_boot_memory_ranges();
 }
 device_initcall(mrrm_init);
-- 
2.48.1

