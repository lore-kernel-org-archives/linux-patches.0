Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0B9181CEB;
	Wed, 24 Apr 2024 18:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982527; cv=none; b=D1ENktOT2qnGid7jUX3ZzXxnzJQED2sqZ/Vpv3hCy6w27kZdd6qML8r6zTr3NiXzsxVHGLtHc3rGH8+S7fJEK+7wJ2A+dzwChODcAxNn4O9b54TbTgUXg6VO41kQx6y5O5Rx+jR3Wafn7o5151MNCOrO9uxMilkbckQ6Arc3oRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982527; c=relaxed/simple;
	bh=zpJumNq7u5KsT133nYF8l88fxW5RaBTIKz2lN9diWJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wq5ct7ye5UkWqIfAYfP1JbOB1vICeubRai/sH0FNkKhTF0T8YJhhIJS+1nW5u1Qu+dUPXoV0dCRD3976FVoKGzVriFBvJobX+IoaS4OvCClhR4kD9+kaIMeepLctGiIsTygXz+YoztcaUefSCYRX2pZ7z6V9kGK7XBRdX3MM4nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZPaGAXpF; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZPaGAXpF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982523; x=1745518523;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zpJumNq7u5KsT133nYF8l88fxW5RaBTIKz2lN9diWJs=;
  b=ZPaGAXpFmrF7pCjwqM5CM6QYg5G4ValsGB9sjuvrsfG6bj18GW5VFx4r
   t98F8NMcEYIvU88SJN/WXS6EBM8GMBcBcFNvlTTNA7CoYxKrhM+TXhpCX
   1hSIMaOHmS+NoE6KQ5ZGDsBxq88FU9YH4657xViqdo8YGoIFJf4Gvgn+I
   QT8QWR1b9Z1+jGBtSvETjmDcj4SeCCrnk92CNk1HfYRGO5dcDnD3GaWRq
   yuHQBe7QZsCm6f6FO+gnZRSggxjeckiZxV+2kY2T+x53ruqecju373V0N
   uXEo9TTa2YdUC79mQUB4o2Gvp7ORwBs5kOghne9Cw2Mys1FFO9gKOB96g
   w==;
X-CSE-ConnectionGUID: wLNc78ayRoimaZluK2jr8A==
X-CSE-MsgGUID: 0iPA1gZ6RCyP0yyTHoWAjA==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9503546"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9503546"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:21 -0700
X-CSE-ConnectionGUID: yLYbQYPRRbq++zx8rXyWIQ==
X-CSE-MsgGUID: QcLdNXhVRx29TbGdnJqhFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="55750135"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 43/71] x86/virt/tdx: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:15:21 -0700
Message-ID: <20240424181521.41984-1-tony.luck@intel.com>
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
 arch/x86/virt/vmx/tdx/tdx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 4d6826a76f78..ee9a9273b75a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -34,7 +34,7 @@
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
 #include <asm/tdx.h>
-#include <asm/intel-family.h>
+#include <asm/cpu_device_id.h>
 #include <asm/processor.h>
 #include <asm/mce.h>
 #include "tdx.h"
@@ -1427,9 +1427,9 @@ static void __init check_tdx_erratum(void)
 	 * private memory poisons that memory, and a subsequent read of
 	 * that memory triggers #MC.
 	 */
-	switch (boot_cpu_data.x86_model) {
-	case INTEL_FAM6_SAPPHIRERAPIDS_X:
-	case INTEL_FAM6_EMERALDRAPIDS_X:
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_SAPPHIRERAPIDS_X:
+	case INTEL_EMERALDRAPIDS_X:
 		setup_force_cpu_bug(X86_BUG_TDX_PW_MCE);
 	}
 }
-- 
2.44.0

