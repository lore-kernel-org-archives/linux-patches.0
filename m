Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6FD179641
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982514; cv=none; b=SCMBh989f2Y8QYccMrIL9hhJm2uXr4Ai78HUT8JVAiwCQbDcfyBetUlEMkcGDornL8UHuRFTbaRfOdmCUHWWPGYDPenljOjz4cSfQB9m6LJpP/s9rbYfBmR08CoI4Xek7JS5nxoqL7ANRPgwyrdg9QXNvbjMP2I45JruQSC1gEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982514; c=relaxed/simple;
	bh=xV3Oh1McKHpj/3XYu97f2x4TjCIeJO+j0gsK/dnPiOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uy7Jz9l7NmCU+cTLNqEWyJCK1H0+waJUFPMOBIRE+uecg4+XMjn3FybDlVChwqHhyry+GzAq53xJ9dvjHfOchfvIifCOpOP600he63T7V00PR5ao2PJbs9znGLQaXFnD2LIy8lQxA9KXoSl2nZVZCBf5RiZupvwzywWs0tQpWB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XxRrveoH; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XxRrveoH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982513; x=1745518513;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xV3Oh1McKHpj/3XYu97f2x4TjCIeJO+j0gsK/dnPiOQ=;
  b=XxRrveoHcMyP9i05jFIY6svpOvO2/gQ4UPK/+YCOFjNGIXJo6OqQHSLY
   1MGwoOM3/VcO3WX4NrICdlX/T/h2XYksjnFVSQzXgPbVA7gX2uadPmQeU
   eQRzGg0CYe7WcP9vjrGzAiOsEv1F8/PMHmQm7+qTWzYVQ09NMYIwH6Auj
   fkz0l7ZbwOSvtSVUkeX8YnYC20EzCJb1A7FFC8b22nByfGL9diSEoqMDm
   su04SATE4LJY2hfN7o3/SJ8mEjyBeWufC2mzgF1rHhJIc1z5WMbKMplSX
   68MTQNeyMi5kXwK/adePGLeWv3c9zhSVdaV3OirM2iRIBsL/EonoYz/uO
   w==;
X-CSE-ConnectionGUID: 0FwyavEHR6iE/j8Q9cWJCw==
X-CSE-MsgGUID: BEnKb9BbSk+IwwI9rvvnyQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9481877"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9481877"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:01 -0700
X-CSE-ConnectionGUID: S4RPMVBYTBGkd5lj1nvPXg==
X-CSE-MsgGUID: 879y5PT3TXSQjKvb/qvLQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="29262647"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:01 -0700
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
Subject: [PATCH v4 20/71] perf/x86/intel/pt: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:15:00 -0700
Message-ID: <20240424181500.41538-1-tony.luck@intel.com>
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
 arch/x86/events/intel/pt.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 8e2a12235e62..14db6d9d318b 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -22,7 +22,7 @@
 #include <asm/insn.h>
 #include <asm/io.h>
 #include <asm/intel_pt.h>
-#include <asm/intel-family.h>
+#include <asm/cpu_device_id.h>
 
 #include "../perf_event.h"
 #include "pt.h"
@@ -211,11 +211,11 @@ static int __init pt_pmu_hw_init(void)
 	}
 
 	/* model-specific quirks */
-	switch (boot_cpu_data.x86_model) {
-	case INTEL_FAM6_BROADWELL:
-	case INTEL_FAM6_BROADWELL_D:
-	case INTEL_FAM6_BROADWELL_G:
-	case INTEL_FAM6_BROADWELL_X:
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_BROADWELL:
+	case INTEL_BROADWELL_D:
+	case INTEL_BROADWELL_G:
+	case INTEL_BROADWELL_X:
 		/* not setting BRANCH_EN will #GP, erratum BDM106 */
 		pt_pmu.branch_en_always_on = true;
 		break;
-- 
2.44.0

