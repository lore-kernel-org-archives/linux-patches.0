Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7692263C6A
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 20:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745958264; cv=none; b=nel0iBGmtfOuyyeu5LxW6D96H8g7xUT96+XqLf9rkF8gZDrjmqGV6CsNKsyW4RpgIsMi7g063rUViTr/4+ADIRNNNqIktrXCE7qPArjP0y8N5k4d+IpXaGCsmDp82EgA9/auHr0Tj+/yTGt4GGHw5t8PGawhN8z3KYznDuyD1Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745958264; c=relaxed/simple;
	bh=mvgK1uFtqEsCi8+cfLkgU8dVp3KLbVexxg4gOXXIb4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKc3sxJ9yj7fGunAwmZEvtuBK/ng7J843EoTxg6W5XML6PFzua5Tok6TYE+GLiAXBRgQ3eQGjAFNUcX3aLJxKMT+n2SZirH32PT3LLDl7mpgv9vCzoo4zPWm6ckoL/JUg3r1EzKRGBOyT8g68GYDY4U57KA2AvzibnPAbR8au88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XQQfBrtY; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XQQfBrtY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745958263; x=1777494263;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mvgK1uFtqEsCi8+cfLkgU8dVp3KLbVexxg4gOXXIb4k=;
  b=XQQfBrtY3WQ4FcB/uJkzSsi4vo2HvxZ85aDWRE6s/nuIkBPESaaTiMYL
   MHkdC6p4GQXYlGJs4US2ex/Sg7henj48I+NGVtJsd/dqJL6/9moDUVBqA
   S47gv3shtiknAwkyAoYfM14srEofPts9xwh4JvSTgodPCEWHA5d3qkBZ3
   miQYvIqxxZ3Uf73sNOQh39x9uCz+J+QX56xQ20H8j9GDt+kxjCeUfjyH+
   E1ayou/saRBn6eRsiSUXMcCJ/XRZfEKbuo66OUzem9BGlS5L1npXfTq1P
   6Dr+GaXZgkI3c/piOkieRSqoa3CN0K5/adtn0svlWa5sC9pQcsyinUC3v
   A==;
X-CSE-ConnectionGUID: rpX3xrkiQDON4AjEQN6JPw==
X-CSE-MsgGUID: MYsNIc54Rd2hr6TFVEVbnA==
X-IronPort-AV: E=McAfee;i="6700,10204,11418"; a="47314069"
X-IronPort-AV: E=Sophos;i="6.15,250,1739865600"; 
   d="scan'208";a="47314069"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2025 13:24:19 -0700
X-CSE-ConnectionGUID: WN1JIc4JSWuwmwDzURyIZw==
X-CSE-MsgGUID: xfnvbjugS7arA9kC8tRMFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,250,1739865600"; 
   d="scan'208";a="139036134"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2025 13:24:18 -0700
From: Tony Luck <tony.luck@intel.com>
To: rafael@kernel.org
Cc: lenb@kernel.org,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 3/4] ACPI/MRRM: Add /sys files to describe memory ranges
Date: Tue, 29 Apr 2025 13:24:10 -0700
Message-ID: <20250429202412.380637-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250429202412.380637-1-tony.luck@intel.com>
References: <20250429202412.380637-1-tony.luck@intel.com>
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
 drivers/acpi/acpi_mrrm.c | 143 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 142 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_mrrm.c b/drivers/acpi/acpi_mrrm.c
index ab8022e58da5..f04645a0407f 100644
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
 
@@ -18,25 +22,162 @@ int acpi_mrrm_max_mem_region(void)
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
+	unsigned int nid;
+
+	for_each_online_node(nid) {
+		for (int z = 0; z < MAX_NR_ZONES; z++) {
+			struct zone *zone = NODE_DATA(nid)->node_zones + z;
+
+			if (!populated_zone(zone))
+				continue;
+			if (zone_intersects(zone, PHYS_PFN(e->base), PHYS_PFN(e->length)))
+				return zone_to_nid(zone);
+		}
+	}
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

