Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F40A937
	for <patches@lists.linux.dev>; Fri, 17 Apr 2026 00:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776384565; cv=none; b=CiXUhw98q9xf9xa6QheGwYXDpzGJyOVEqNFlXRukCdoUtmuCn2ll+QrSW0Xy0sLCiBcEF8+qQ6ftXjys45JmVY4eaBbsKQ5ViEyzUA21cYN78Bdxr1OGzwhuNPAU5YxdX96VYXihkjVxUMJcAuUa5MVZ1lbSVZvb5LOBOkcUnAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776384565; c=relaxed/simple;
	bh=jaoXggD58FVYKNlS5gEyeZYwYQw7MOZ3aLdudKgX4Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qtmm7red5OCB9Aqx+PY3jdXDOCTz9V5+wnrgtQ0tbC2BO1S1zLKzzwx5oA1+OuSOg5nrQbE/oSXTMzNsOXzWBQw8nrD4F/1w2Rh42IbXVOTIWtcNRpC+AhjWuUFEpJ/dd8tHsju28bj2+Zd1xG4qH6n5uVYaF1McXSJrwcSgpFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IEocdZiS; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IEocdZiS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776384563; x=1807920563;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jaoXggD58FVYKNlS5gEyeZYwYQw7MOZ3aLdudKgX4Ak=;
  b=IEocdZiS9uqqRJ0Khk8ZvTVjEfELOrVr4tOFmVcpR63SErIantzl/kTe
   Rvaf3OhIotdqfI4qByGw4fTchkyFWZN5gcJmKaItmcxZIgYwxvGys03PR
   G5CFx8wN2U86IRK+/yD3RESvsQ0nzi0avlBiYFIar9JKV8TzJkgI6axRh
   bQzgSE9UB7BndCpfP+5Vr4J4aXa3TWpd3HvHR74dxlOE5+UnxhvTBLafZ
   xCT0uNsKD2/6NUjXwY2c4n/scDGgJRMwxrXgRpQetq7N+L01GGTnhrSdz
   yCIWTcVMgagvbdoU/tHBQ6copQfRy5zUMNASSXKQK6C6V3d7PTa05wN+5
   Q==;
X-CSE-ConnectionGUID: 6pMUP6X8QOagZUjBn2Gz1w==
X-CSE-MsgGUID: v8S7d0mhRyO5e8PgNi1sBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11761"; a="77270081"
X-IronPort-AV: E=Sophos;i="6.23,183,1770624000"; 
   d="scan'208";a="77270081"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2026 17:09:23 -0700
X-CSE-ConnectionGUID: X0kBPrxuQ9Cj+OfG87fcIQ==
X-CSE-MsgGUID: 7wJsfx+BSzCMppgdDzGfZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,183,1770624000"; 
   d="scan'208";a="232630238"
Received: from vverma7-desk1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.234])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2026 17:09:18 -0700
From: Tony Luck <tony.luck@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Herman Li <herman.li@intel.com>,
	Zaid Alali <zaidal@os.amperecomputing.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3] ACPI: APEI: EINJ: Fix EINJV2 memory error injection
Date: Thu, 16 Apr 2026 17:08:51 -0700
Message-ID: <20260417000851.78924-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Error types in EINJV2 use different bit positions for each flavor of
injection from legacy EINJ.

Two issues:

1) The address sanity checks in einj_error_inject() were skipped for V2
   injections. Noted by sashiko[1]
2) __einj_error_trigger() failed to drop the entry of the target
   physical address from the list of resources that need to be
   requested.

Add a helper function that checks if an injection is to memory and use it
to solve each of these issues.

Note that the old test in __einj_error_trigger() checked that param2 was
not zero. This isn't needed because the sanity checks in einj_error_inject()
reject memory injections with param2 == 0.

Fixes: b47610296d17 ("ACPI: APEI: EINJ: Enable EINJv2 error injections")
#Reported-by: sashiko <sashiko@sashiko.dev>
Reported-by: Herman Li <herman.li@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://sashiko.dev/#/patchset/20260415163620.12957-1-tony.luck%40intel.com # [1]
---

Changes since V2:
Fix additional issue reported by sashiko when reviewing earlier version.

 drivers/acpi/apei/einj-core.c | 51 +++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/acpi/apei/einj-core.c b/drivers/acpi/apei/einj-core.c
index a9248af078f6..25bfab62b73b 100644
--- a/drivers/acpi/apei/einj-core.c
+++ b/drivers/acpi/apei/einj-core.c
@@ -46,6 +46,12 @@
 				ACPI_EINJ_CXL_MEM_UNCORRECTABLE | \
 				ACPI_EINJ_CXL_MEM_FATAL)
 
+/* EINJV2 Error types from ACPI v6.5 specification */
+#define ACPI_EINJV2_PROCESSOR	BIT(0)
+#define ACPI_EINJV2_MEMORY	BIT(1)
+#define ACPI_EINJV2_PCIX	BIT(2)
+#define ACPI_EINJV2_VENDOR	BIT(31)
+
 /*
  * ACPI version 5 provides a SET_ERROR_TYPE_WITH_ADDRESS action.
  */
@@ -401,8 +407,18 @@ static struct acpi_generic_address *einj_get_trigger_parameter_region(
 
 	return NULL;
 }
+
+static bool is_memory_injection(u32 type, u32 flags)
+{
+	if (flags & SETWA_FLAGS_EINJV2)
+		return !!(type & ACPI_EINJV2_MEMORY);
+	if (type & ACPI5_VENDOR_BIT)
+		return !!(vendor_flags & SETWA_FLAGS_MEM);
+	return !!(type & MEM_ERROR_MASK);
+}
+
 /* Execute instructions in trigger error action table */
-static int __einj_error_trigger(u64 trigger_paddr, u32 type,
+static int __einj_error_trigger(u64 trigger_paddr, u32 type, u32 flags,
 				u64 param1, u64 param2)
 {
 	struct acpi_einj_trigger trigger_tab;
@@ -480,7 +496,7 @@ static int __einj_error_trigger(u64 trigger_paddr, u32 type,
 	 * This will cause resource conflict with regular memory.  So
 	 * remove it from trigger table resources.
 	 */
-	if ((param_extension || acpi5) && (type & MEM_ERROR_MASK) && param2) {
+	if ((param_extension || acpi5) && is_memory_injection(type, flags)) {
 		struct apei_resources addr_resources;
 
 		apei_resources_init(&addr_resources);
@@ -660,7 +676,7 @@ static int __einj_error_inject(u32 type, u32 flags, u64 param1, u64 param2,
 		return rc;
 	trigger_paddr = apei_exec_ctx_get_output(&ctx);
 	if (notrigger == 0) {
-		rc = __einj_error_trigger(trigger_paddr, type, param1, param2);
+		rc = __einj_error_trigger(trigger_paddr, type, flags, param1, param2);
 		if (rc)
 			return rc;
 	}
@@ -718,35 +734,30 @@ int einj_error_inject(u32 type, u32 flags, u64 param1, u64 param2, u64 param3,
 		      SETWA_FLAGS_PCIE_SBDF | SETWA_FLAGS_EINJV2)))
 		return -EINVAL;
 
+	/*
+	 * Injections targeting a CXL 1.0/1.1 port have to be injected
+	 * via the einj_cxl_rch_error_inject() path as that does the proper
+	 * validation of the given RCRB base (MMIO) address.
+	 */
+	if (einj_is_cxl_error_type(type) && (flags & SETWA_FLAGS_MEM))
+		return -EINVAL;
+
 	/* check if type is a valid EINJv2 error type */
 	if (is_v2) {
 		if (!(type & available_error_type_v2))
 			return -EINVAL;
 	}
-	/*
-	 * We need extra sanity checks for memory errors.
-	 * Other types leap directly to injection.
-	 */
 
 	/* ensure param1/param2 existed */
 	if (!(param_extension || acpi5))
 		goto inject;
 
-	/* ensure injection is memory related */
-	if (type & ACPI5_VENDOR_BIT) {
-		if (vendor_flags != SETWA_FLAGS_MEM)
-			goto inject;
-	} else if (!(type & MEM_ERROR_MASK) && !(flags & SETWA_FLAGS_MEM)) {
-		goto inject;
-	}
-
 	/*
-	 * Injections targeting a CXL 1.0/1.1 port have to be injected
-	 * via the einj_cxl_rch_error_inject() path as that does the proper
-	 * validation of the given RCRB base (MMIO) address.
+	 * We need extra sanity checks for memory errors.
+	 * Other types leap directly to injection.
 	 */
-	if (einj_is_cxl_error_type(type) && (flags & SETWA_FLAGS_MEM))
-		return -EINVAL;
+	if (!is_memory_injection(type, flags))
+		goto inject;
 
 	/*
 	 * Disallow crazy address masks that give BIOS leeway to pick
-- 
2.53.0

