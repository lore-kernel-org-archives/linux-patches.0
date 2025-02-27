Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D0D4438B
	for <patches@lists.linux.dev>; Thu, 27 Feb 2025 22:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740696522; cv=none; b=mkVQopTYgrfWEsdfljpuXLSqMkVF5DoAtfGdg0EybKCUpv2DDwebo/33DgeY9qcq4XcFwJkIz4QcIz8ZOiXo5MbdLtmRKmhVChHLfSXcuYeCa+fsmqdBh2KJNYQwPAjnlk0EE2xktP6cOUDFARVpshxgO9cvQN2QzHuNVtIdjdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740696522; c=relaxed/simple;
	bh=brG2Wad/ONqxpi3EfYHQF1xtjKk5coID4SyaddPLRWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTUm2U6pRMJaSTclZls4MdS6bwPcDx9DNvmkTwE8IF9ZmHJb0UrOk5vlFNyBAnC9JfkUoTS0nw29NBji/CKWyo13FqU/0uuowv6Qwzyb/AYRDjt8Ya8VUxr6JCvhZ0UkkEz2hwD7fKN4clvoQvGEfHbZpLrm9jfl602kfGlIwYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HXSUA5z3; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HXSUA5z3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740696520; x=1772232520;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=brG2Wad/ONqxpi3EfYHQF1xtjKk5coID4SyaddPLRWE=;
  b=HXSUA5z3LR75RWHCj8mU6MX8PtbTc6s6f1KdZzqYk3K3aFyDRcdFF/1T
   +bkpK/Zb7N3omKV817Jw+p0jYL2YqbCanZHOatjFJcLIvEIVkzcHHgdBx
   2gTPzA+S9SWbYQ/GqN2qBlrUMNdaCjQmH8/wEMbtjuWtcuhF90WlzqBt2
   CyakiZElnuZPGC72Nk2xz/YQmbJAYZVCvO+YZQbdJKTira9Oy3PKTsKqx
   iEjKF1gofvukDrWA2l8/+QYqhH4lGRlxYgzdfe2HUcpYorzM8Z4/VvxzE
   2vDZyxiEkEkvEJ0oxsupTT4kU7rxMO22nNoLVTWJGqpFYZEncIkkubI4F
   A==;
X-CSE-ConnectionGUID: AntjmmGOTaiLc9P+N8r8VQ==
X-CSE-MsgGUID: UzkvUnwhSACkh4sz9GdDYg==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="64077562"
X-IronPort-AV: E=Sophos;i="6.13,320,1732608000"; 
   d="scan'208";a="64077562"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 14:48:39 -0800
X-CSE-ConnectionGUID: Ch6+C6PhRb6uFs0lLTE0Mg==
X-CSE-MsgGUID: pUI98d4zTBWjHCjyS32nPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,320,1732608000"; 
   d="scan'208";a="117187045"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 14:48:38 -0800
From: Tony Luck <tony.luck@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 1/4] ACPICA: Define MRRM ACPI table
Date: Thu, 27 Feb 2025 14:48:25 -0800
Message-ID: <20250227224828.306537-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250227224828.306537-1-tony.luck@intel.com>
References: <20250227224828.306537-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch for reference, this has already been applied to
https://github.com/acpica/acpica and will in due course make its way
into Linux when the next ACPICA release is ported over.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/acpi/actbl1.h |  7 +++++++
 include/acpi/actbl2.h | 42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index 387fc821703a..07cb62541884 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -110,6 +110,13 @@ struct acpi_whea_header {
 	u64 mask;		/* Bitmask required for this register instruction */
 };
 
+/* Larger subtable header (when Length can exceed 255) */
+
+struct acpi_subtable_header_16 {
+	u16 type;
+	u16 length;
+};
+
 /* https://docs.microsoft.com/en-us/windows-hardware/drivers/ddi/acpitabl/ns-acpitabl-aspt_table */
 #define ASPT_REVISION_ID 0x01
 struct acpi_table_aspt {
diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index 2e917a8f8bca..662a1bc927ea 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -37,6 +37,7 @@
 #define ACPI_SIG_MCHI           "MCHI"	/* Management Controller Host Interface table */
 #define ACPI_SIG_MPAM           "MPAM"	/* Memory System Resource Partitioning and Monitoring Table */
 #define ACPI_SIG_MPST           "MPST"	/* Memory Power State Table */
+#define ACPI_SIG_MRRM           "MRRM"      /* Memory Range and Region Mapping table */
 #define ACPI_SIG_MSDM           "MSDM"	/* Microsoft Data Management Table */
 #define ACPI_SIG_NFIT           "NFIT"	/* NVDIMM Firmware Interface Table */
 #define ACPI_SIG_NHLT           "NHLT"	/* Non HD Audio Link Table */
@@ -1736,6 +1737,47 @@ struct acpi_msct_proximity {
 	u64 memory_capacity;	/* In bytes */
 };
 
+/*******************************************************************************
+ *
+ * MRRM - Memory Range and Region Mapping (MRRM) table
+ * Conforms to "Intel Resource Director Technology Architecture Specification"
+ * Version 1.1, January 2025
+ *
+ ******************************************************************************/
+
+struct acpi_table_mrrm {
+	struct acpi_table_header header;	/* Common ACPI table header */
+	u8 max_mem_region;			/* Max Memory Regions supported */
+	u8 flags;				/* Region assignment type */
+	u8 reserved[26];
+	u8 memory_range_entry[];
+};
+
+/* Flags */
+#define ACPI_MRRM_FLAGS_REGION_ASSIGNMENT_OS (1<<0)
+
+/*******************************************************************************
+	*
+	* Memory Range entry - Memory Range entry in MRRM table
+	*
+	******************************************************************************/
+
+struct acpi_mrrm_mem_range_entry {
+	struct acpi_subtable_header_16 header;
+	u32 reserved0;		/* Reserved */
+	u64 addr_base;		/* Base addr of the mem range */
+	u64 addr_len;		/* Length of the mem range */
+	u16 region_id_flags;	/* Valid local or remote Region-ID */
+	u8 local_region_id;	/* Platform-assigned static local Region-ID */
+	u8 remote_region_id;	/* Platform-assigned static remote Region-ID */
+	u32 reserved1;		/* Reserved */
+	/* Region-ID Programming Registers[] */
+};
+
+/* Values for region_id_flags above */
+#define ACPI_MRRM_VALID_REGION_ID_FLAGS_LOCAL   (1<<0)
+#define ACPI_MRRM_VALID_REGION_ID_FLAGS_REMOTE  (1<<1)
+
 /*******************************************************************************
  *
  * MSDM - Microsoft Data Management table
-- 
2.48.1

