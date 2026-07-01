Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32373C661D
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 21:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782941771; cv=none; b=eLH9p6qtgIiTqBL5sQsPKBP6BX+esgVKErqnP3+8YgRPlKqoV7e6b+dBF3ydgCERzllMotrQQfZmUwsNJh9I0mRGgvhkkDLNacYSAYrLSilKiMDG85cZzFuMDg0BB6gIymcY1rw9+9rd2pYhjOYsYy8ggDUZxROyXj7eEM1u7mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782941771; c=relaxed/simple;
	bh=5cYhYMUkBy36cAJFUn8ndzcMhPsFC3aFfrjbuEGFLMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSaK+i0zvIMRCmNANDWKBA0FxuCZBMDf3DfXDGUhVGxA4GYRMUpm0GYUsA1LvaH6VjSxFPrvO0xF7D/W03dUwkCy9S7arBTGSSQ9ep4uDit+VSHbk53PTKm/JD7CaHIncpxRnuogfcV1BqIuQj7DbBYhi3QQUEU7Mms1WaiTBOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hUzsog6S; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hUzsog6S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782941768; x=1814477768;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5cYhYMUkBy36cAJFUn8ndzcMhPsFC3aFfrjbuEGFLMY=;
  b=hUzsog6SmZQmcStui/V5L8yMAbSuNYXJehXzJsFPfLN2xvjHpnD7m1N0
   GdGofMfYRJ2nAEWE75XExddDAr6WMEn89LNNpteCItf6sBhI00xGwKJfP
   J6C8/jS4kXuhOYmIaMk+AffXN8jjakl6tkSk0NqvCRHprm3jTzPJ6oZED
   b+HXCxF4vG97MSzzY3sfuhTTv2WWU3PksHXDhtXfqjfwCfLKJRfLJlWdb
   emDbfTbkxRUUmhz66Rnyc1bQNA49BVjKd6RMiZ4LiVT86kNukaj9pK7KL
   rgnQLuPPERh8NMgUWUwr0zLzSY9YmpbgH7H8sghByDPsNoNOpFIIu7dky
   A==;
X-CSE-ConnectionGUID: 74UF6D3kTgehv1ePHh0n0Q==
X-CSE-MsgGUID: tRrga37pTE2c9y2PrfZYcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11834"; a="94285814"
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="94285814"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:04 -0700
X-CSE-ConnectionGUID: rECg4VylRoKq/Ojk/HylTw==
X-CSE-MsgGUID: Ns8HRb+XQ1WEn08XBNdDFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="252242542"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.120])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:04 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v9 08/12] platform/x86/intel/pmt: Register enumeration functions with resctrl
Date: Wed,  1 Jul 2026 14:35:49 -0700
Message-ID: <20260701213553.15222-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260701213553.15222-1-tony.luck@intel.com>
References: <20260701213553.15222-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

INTEL_PMT_TELEMETRY is a loadable module, but resctrl is built-in and cannot
call PMT functions directly.

Use ".probe_type = PROBE_FORCE_SYNCHRONOUS" to ensure sequential, synchronous
calls to per-device .probe() functions.  Register the telemetry enumeration
function pointers at the end of pmt_telem_init() when all .probe() functions
have run and enumeration is complete.

Unregister at the start of pmt_telem_exit() before teardown of the
auxiliary drivers.

Note that checkpatch complains about the #include of <asm/resctrl.h>.
This is needed rather than <linux/resctrl.h> to get the function stub
definitions when CONFIG_X86_CPU_RESCTRL=n.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
--
v9:
	Back to register in .init() and unregister in .exti()
	Add PROBE_FORCE_SYNCHRONOUS
---
 drivers/platform/x86/intel/pmt/telemetry.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
index f243ccf3185b..fba0b3912c06 100644
--- a/drivers/platform/x86/intel/pmt/telemetry.c
+++ b/drivers/platform/x86/intel/pmt/telemetry.c
@@ -25,6 +25,8 @@
 #include <linux/uaccess.h>
 #include <linux/xarray.h>
 
+#include <asm/resctrl.h>
+
 #include "class.h"
 
 #define TELEM_SIZE_OFFSET	0x0
@@ -429,17 +431,23 @@ static struct auxiliary_driver pmt_telem_aux_driver = {
 	.probe		= pmt_telem_probe,
 	.driver = {
 		.suppress_bind_attrs = true,
+		.probe_type = PROBE_FORCE_SYNCHRONOUS,
 	},
 };
 
 static int __init pmt_telem_init(void)
 {
-	return auxiliary_driver_register(&pmt_telem_aux_driver);
+	int ret = auxiliary_driver_register(&pmt_telem_aux_driver);
+
+	intel_aet_register_enumeration(THIS_MODULE, intel_pmt_get_regions_by_feature,
+				       intel_pmt_put_feature_group);
+	return ret;
 }
 module_init(pmt_telem_init);
 
 static void __exit pmt_telem_exit(void)
 {
+	intel_aet_unregister_enumeration();
 	auxiliary_driver_unregister(&pmt_telem_aux_driver);
 	xa_destroy(&telem_array);
 }
-- 
2.54.0

