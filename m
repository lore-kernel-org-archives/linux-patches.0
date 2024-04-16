Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E85380C14
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302403; cv=none; b=NXTekF17rEKJuzuSWHZl0VkG+ZiKrskna3mS3ktOXHB2Jh6i8SLu0kjumbdejrCIkfvXTc2QRA9W4MFgNcw4OlVGnmsSsSPq59/0vcuIY6KPv4evrbRC9v9NhKkymt3TKotdjrDnB/8bdIz3EuUHMfrvaaJmLwqp7gutnF1CL/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302403; c=relaxed/simple;
	bh=dOmQ7jUeo78k2rwa4FbxrxxtpSbAveIjEYydSHsCBrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8EKsUy2HG3vx8BhC6g0UmwoeNjL+tLpfye9/MjwfkBy7UbN/6nkUmYFmwzkmH9xs6OFfvXzLhSXE23oOcR0tmZTyNuQvcVNW1+0wX3aKNMVLHJOopCC/upq5ZtT1MJioIyPIi6zwiMARuuSj1unYgGDKZZ8ygz1Ri9TJuBF7pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MMmqa4F9; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MMmqa4F9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302402; x=1744838402;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dOmQ7jUeo78k2rwa4FbxrxxtpSbAveIjEYydSHsCBrw=;
  b=MMmqa4F9YKkDF21/AsUH0cxzEp3DgS85oXnLIwlmwboP5/JAp6HyEQdT
   ewF8n0hDLnHY+3IPe6sutRK6S9n67/wre8uMG1hllhQwCxXKgyPkwwixu
   uFBHXugrbWXaKEXngraPHgwifsbUsPa+jjBlLk6tDBIC8kunv/DbCNz8l
   Qsk/JfKwfcWCYvCOihmRMPis6/TG8hiEnNwbqGRlkc1PORg80YTvlCBQD
   jzhOWtOtpB2CH2ydlEzhiu84o2LUulB33OiIH47OX3ZxPzexciIarE3MD
   w8GRJ8XJYd6fpJnt5oTDG/Mq/b1sA+QXtTdC1FwM99Vm5U9JmJh4Wt+qV
   w==;
X-CSE-ConnectionGUID: H1KtutfsQLOQzA9dP29jcQ==
X-CSE-MsgGUID: X+NrYzwfTs69IK9WjHFNSg==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914703"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914703"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:19:58 -0700
X-CSE-ConnectionGUID: aR8oZ0HFSq2pax2xgW7KwQ==
X-CSE-MsgGUID: DeE0Jp8YTFuGRY5XaZsF+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22871897"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:19:57 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 08/74] x86/cpu/vfm: Update arch/x86/events/intel/pt.c
Date: Tue, 16 Apr 2024 14:19:10 -0700
Message-ID: <20240416211941.9369-9-tony.luck@intel.com>
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
 arch/x86/events/intel/pt.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 8e2a12235e62..e3320c2ee7c6 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -22,6 +22,7 @@
 #include <asm/insn.h>
 #include <asm/io.h>
 #include <asm/intel_pt.h>
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 
 #include "../perf_event.h"
@@ -211,11 +212,11 @@ static int __init pt_pmu_hw_init(void)
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

