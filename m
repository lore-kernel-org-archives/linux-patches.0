Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FDD259C9D
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 20:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745958262; cv=none; b=RhPWEGhWJXrhO/ttguT6FtZ8UalBcirTjsGPdGCJUDYRvzh/BSFW/GHUmUsi3u/0nmTpTDAruDH5RfywPnVY4097OKnRZLUuRR6DXBkiMBi7mnQCyi9cHNqms7ee2iUw+i5VDAj/aFUshvW5H2rOrwCwKWN1D9thyPgBBDH46hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745958262; c=relaxed/simple;
	bh=je4PX87/pOXLlsfa4Mz89lMVrtgvdaQj3AqWmieL8Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhFxIf3/N18PIRE8dRrPW3JPEr9eFh+Y2ojjSclV2ywXRR4Po/C42aHepnPjX/FNNfhZWKUBVxFyI14kZeE8rkNYpaBKUt40wltVlQjZIPhV640GYXv0iRgl17fwf4Uh5DV98+QT6lQHR2k0I2hDQD8KtTDVkwngvRWt5VqHtIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kaWXsEP2; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kaWXsEP2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745958262; x=1777494262;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=je4PX87/pOXLlsfa4Mz89lMVrtgvdaQj3AqWmieL8Qo=;
  b=kaWXsEP2PBUaFEcF9+bH9Zh9lAxSOLeh+MvlpkKHgncZMZybhma5g7nL
   0KVlA609kDNdWRs8m+OTVVmY5z5rXypyl9K0S0jQTwJVs31zoinc3WyRz
   A6Iz+2N9auhT5KsfUBFVge7RI+OrxmpTlNWKml9dUqOrSKRVsOUsJ5iul
   naotOuxeP1v6bnRCRgSMwhF+yjr5lGugMpEg7UiV5kFQvbOD3tKSJ/Rgl
   rsnH/63ouoPBZvM1fM4pm6XjKXoQ3jJ0QbzxxFQta9JNSALPii35Om/u6
   DAEjZTLLnCDH/FPglvZp5zDWUngEp46lxW3n8kGNCkfmnjzwGKpwp95ZA
   Q==;
X-CSE-ConnectionGUID: GyLvRS2pQl6xshV2ik9mzg==
X-CSE-MsgGUID: pQJUbuLbQySJuEV41rwwXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11418"; a="47314062"
X-IronPort-AV: E=Sophos;i="6.15,250,1739865600"; 
   d="scan'208";a="47314062"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2025 13:24:19 -0700
X-CSE-ConnectionGUID: YY9wJV3mSQGYQTGitr9kgg==
X-CSE-MsgGUID: wPtOYY0mQmKt6lRiZKmmiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,250,1739865600"; 
   d="scan'208";a="139036127"
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
Subject: [PATCH v4 1/4] ACPICA: Define MRRM ACPI table
Date: Tue, 29 Apr 2025 13:24:08 -0700
Message-ID: <20250429202412.380637-2-tony.luck@intel.com>
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

