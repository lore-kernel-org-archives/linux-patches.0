Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C4784E16
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302407; cv=none; b=B5b4n6GOQVgxkOgzToJjcrF/IoUKWpPHBw99qyWbn2SLKoaerl5gAGpnur3FOos7rnUAaMmH7XdOnJLIXG58gDDgqnlcRZPT5F7m51CVejklriI/oFxtn7+StbozES+tpozQryZQn0FR+M6lP9uhVE48Xy002RX8dUAUNO4uJkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302407; c=relaxed/simple;
	bh=SHMkDQNhLJVSbQAhNMfggf+iNz/SzZPr73nQsNDr5PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhS6kcBuXJ2/5ZbP2c5M6n8fEpY/CMcUrJo4nyUuMBS/AOUDBNT6a6OL9CQ+dYFCmOINEuJEofMp6LxLmzHstFg7K8sCy7aESXX76BFnlmB0OH/11dIrgeOa0Py++5WgPyS97uCz8qDY7vFXlljBjQPtOyzJp5LnefpUYbSxr+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mMjZ+Mn7; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mMjZ+Mn7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302403; x=1744838403;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SHMkDQNhLJVSbQAhNMfggf+iNz/SzZPr73nQsNDr5PA=;
  b=mMjZ+Mn73AdwOV09gp2pvWGG61EruPoF5AYniphiJduSqmhtaPOdZumh
   6VAVom2xKr8u1O/hFWISiF9OiskhvhDOr3WT3TAoc4VRBqMOxh3Lr6WaC
   rjRhi3UVTLxGR+WeitfERkA9KAGtBjZgEgK2cJWdNRKT6HwC/m538MOjz
   pMrAjChiWT8e/1v8doMASdTYjwK7AjN4DUomOeY9hS+QX/35fgjOp8ZuU
   cQA2LC4AmyBzpF6hWa0dZayr5tD5sE1z6tJ/gEQc5XpFp14Zr2znvYNqf
   sTu+2mUFyjhbcG5Z05V0YrjaEhSUy4KFQLeAMkuBGi2DplXOPKGCVh34r
   g==;
X-CSE-ConnectionGUID: mL5QZijqSfeyMfkgtuOJqw==
X-CSE-MsgGUID: lEUvb+shSBSd/0B3jwzvlg==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914717"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914717"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:19:58 -0700
X-CSE-ConnectionGUID: vi0hrBCvQbeBzeAzoE3L2w==
X-CSE-MsgGUID: pJpM6/XKQEWICrasbKIn7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22871910"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:19:58 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 11/74] x86/cpu/vfm: Update arch/x86/events/intel/uncore_snbep.c
Date: Tue, 16 Apr 2024 14:19:13 -0700
Message-ID: <20240416211941.9369-12-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240416211941.9369-1-tony.luck@intel.com>
References: <20240416211941.9369-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/events/intel/uncore_snbep.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 2eaf0f339849..74b8b21e8990 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* SandyBridge-EP/IvyTown uncore support */
+#include <asm/cpu_device_id.h>
 #include "uncore.h"
 #include "uncore_discovery.h"
 
@@ -3285,7 +3286,7 @@ void bdx_uncore_cpu_init(void)
 	uncore_msr_uncores = bdx_msr_uncores;
 
 	/* Detect systems with no SBOXes */
-	if ((boot_cpu_data.x86_model == 86) || hswep_has_limit_sbox(BDX_PCU_DID))
+	if (boot_cpu_data.x86_vfm == INTEL_BROADWELL_D || hswep_has_limit_sbox(BDX_PCU_DID))
 		uncore_msr_uncores[BDX_MSR_UNCORE_SBOX] = NULL;
 
 	hswep_uncore_pcu.constraints = bdx_uncore_pcu_constraints;
@@ -5394,7 +5395,7 @@ static int icx_iio_get_topology(struct intel_uncore_type *type)
 static void icx_iio_set_mapping(struct intel_uncore_type *type)
 {
 	/* Detect ICX-D system. This case is not supported */
-	if (boot_cpu_data.x86_model == INTEL_FAM6_ICELAKE_D) {
+	if (boot_cpu_data.x86_vfm == INTEL_ICELAKE_D) {
 		pmu_clear_mapping_attr(type->attr_update, &icx_iio_mapping_group);
 		return;
 	}
-- 
2.44.0

