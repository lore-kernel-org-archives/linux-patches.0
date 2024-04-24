Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AA617B51A
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982516; cv=none; b=YadFfyxoAzvvxnRLW3xKCysrnpIBsWUTF3Nxco2OC8jRwhmvNo0yHuRl71NSD85HuQKqFU2bYZ/jl/X+SfJI1OvdRFW+iaYw4vrvJr0QoRI60XCICu+HBNuT19kHk3ZHSgY5HpzUp3w7U15R6HhFeB0fOSjaasiGbIEN/XNt2E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982516; c=relaxed/simple;
	bh=SHMkDQNhLJVSbQAhNMfggf+iNz/SzZPr73nQsNDr5PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XD/BC9fPEhkW73OpFrWSAIB2lZt7iBhVtEyDxfJUFw6F+I/0JBSNCv29nqar6j+W3sL8LIkyC2tal3+iiWHIw/oaLTIBGmO6uyCZItJUjawWU0ZW24oryOaXL+G4I+cDv2J1p61gruQv1njr8+oPijaQJBIztotRqxkuSDAR6Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EzqFN724; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EzqFN724"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982514; x=1745518514;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SHMkDQNhLJVSbQAhNMfggf+iNz/SzZPr73nQsNDr5PA=;
  b=EzqFN724KBeGefGrObONnxN3UIadxC5++APXTbNTGzqKsZaVbxnq/XfM
   P+krqKGIiho8w8F5a5Wx4+nb8NU2InlEZPWBZVXyfIzbFFX1ktAcD5VcS
   DkPtkwgtvJOwkmw5Hd7ES7iN9bOU+tsOQyZKey3aH5rW0aGO9lrJ2Ci9f
   M4Q0+UmGfQjtX8KvuTZOttAX6b7KOzQ7VXSj3PfSY4HolJD5MRW7TqgJN
   atVK4K+7MP3UQSgxhkjnpu3C/8f3uJUsYuJ5LhiIjkNE9zOBCLeZZwzNR
   1KzgNmqynzC/e8MpdBp4/rsyCxGbnh8+pJKVZwGwUNaT3yONi+AFcORkx
   w==;
X-CSE-ConnectionGUID: 2GBtW5YeQxmnTrYGZFIaMg==
X-CSE-MsgGUID: 5IWqVLH1R0CEMLiacSxZUQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9481908"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9481908"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:03 -0700
X-CSE-ConnectionGUID: Pz7yq/wzTuOGL2Mza7wa0g==
X-CSE-MsgGUID: jApYVrXOTnujTNkAikv0Lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="29262668"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:03 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 23/71] perf/x86/intel/uncore: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:15:03 -0700
Message-ID: <20240424181503.41595-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424181245.41141-1-tony.luck@intel.com>
References: <20240424181245.41141-1-tony.luck@intel.com>
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

