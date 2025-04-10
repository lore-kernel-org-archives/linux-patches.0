Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D976A20CCCC
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 22:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744324343; cv=none; b=bQ8vjz54WmJvb1ETJbeLgnc/YXP9qjle1InjcVxsnO74HuIt9lLf2Q3eND7gzZ3eYoeHlS0o4g/6NZrVn1na5x1i0d4LbrQ/vKQ9vwmu811ze2PVYk3Mcn84A2Wb7WkG/z8txEl6414LCLjObfzJ7GbK15AWWXdGvB0c5PkGiNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744324343; c=relaxed/simple;
	bh=je4PX87/pOXLlsfa4Mz89lMVrtgvdaQj3AqWmieL8Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiY5E3siG8KbW3CQIAU7ud2md9O4vrR1t6fC4VG1gOxEgZTj3cXtcpp7dF+EdSaQrZK8HR5Y0GrD+gQ8XTlwkY8hhLhck3pGQd8DktmPwH8/beZurnbmvyAZFp+Bhz7r9OGQN0vwVgDTlv7jbslhJOkgeXT4JVIDH6MilM+PKMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jYcaaF3w; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jYcaaF3w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744324340; x=1775860340;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=je4PX87/pOXLlsfa4Mz89lMVrtgvdaQj3AqWmieL8Qo=;
  b=jYcaaF3wi1H+8vj3EA/MGpBid3SY471hGq8hyFaTwi/Qto9o85aRK5Xj
   /RVQvQ5itibPxkJKOYi9zZKFJLF9T1GVOay5iSsVFHiHf8i/iWvzLUVp6
   Bt76fETe6yLH2PIUc/8fhxkq3qOxb0wxsAJ898roXSe4zAIJ9mroRIvzz
   t8P9Hw3ob//3+Kp0jXmyfu81bqAJcJw9vZVIR85csNACvRmNH4L61GZ1o
   /KjGYVwkGoZgKZmquhnc+qqgcGAjY1cHZpIs1OycG/+rei7T1wO37Dmep
   H9qMY+YrG4YanGrvypT9yEzu+vWHiNwrunTZb95EyCJrgdaZLFRfGbTAW
   Q==;
X-CSE-ConnectionGUID: /QMIY0HhRyO/AFjgmhYyOw==
X-CSE-MsgGUID: LExriszmQJ2W0l6tMsdb3A==
X-IronPort-AV: E=McAfee;i="6700,10204,11400"; a="56845631"
X-IronPort-AV: E=Sophos;i="6.15,203,1739865600"; 
   d="scan'208";a="56845631"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 15:32:17 -0700
X-CSE-ConnectionGUID: pQkjhSwaR1akJ5NHG91UNg==
X-CSE-MsgGUID: JIu3knYsRFSfi/ixon2BAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,203,1739865600"; 
   d="scan'208";a="128988749"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 15:32:16 -0700
From: Tony Luck <tony.luck@intel.com>
To: rafael.j.wysocki@intel.com
Cc: lenb@kernel.org,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 1/4] ACPICA: Define MRRM ACPI table
Date: Thu, 10 Apr 2025 15:32:04 -0700
Message-ID: <20250410223207.257722-2-tony.luck@intel.com>
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

Patch for reference, this has already been applied to
https://github.com/acpica/acpica and will in due course make its way
into Linux when the next ACPICA release is ported over.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/acpi/actbl1.h |  7 +++++++
 include/acpi/actbl2.h | 42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index 387fc821703a..4cb36392e9e9 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -110,6 +110,13 @@ struct acpi_whea_header {
 	u64 mask;		/* Bitmask required for this register instruction */
 };
 
+/* Larger subtable header (when Length can exceed 255) */
+
+struct acpi_subtbl_hdr_16 {
+	u16 type;
+	u16 length;
+};
+
 /* https://docs.microsoft.com/en-us/windows-hardware/drivers/ddi/acpitabl/ns-acpitabl-aspt_table */
 #define ASPT_REVISION_ID 0x01
 struct acpi_table_aspt {
diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index 2e917a8f8bca..e7423db6e24b 100644
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
+	struct acpi_subtbl_hdr_16 header;
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

