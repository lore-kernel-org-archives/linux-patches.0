Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E279F13C3D2
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245212; cv=none; b=Hh9zlTdGo5k1qdSWvUTk9YtQV361pPTnLLW3J+xTh8ToGY9eUJNJznXBFrwMBKK4StcEbQsZTmbiMatHX01zhMKDKC2+7+Yb2c+XoiXTD/DaLiDYAHE7zcdzrEFouH/u8MTPLzaiwONBDWXygWt9SM32zQn4C/EAX7MZIUXQJmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245212; c=relaxed/simple;
	bh=dSW16Z5owqXk0diJ8oqVw/YYkOHbNprsGlWIpUTivak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTWM0Vt2R7SiTt3EVk0a/mhIU/qUdCbm3nkL6VaCEIC5qQJ4UJdXfH8RX4fN7s7yc/FsncFY29SOh2K/AVsJniVt3WkPtEyG8aj2lWW4q8naYZLKCxOnun4rUd4fp7vytP1DAXeOrE8MLyBXnowgFmgNHLxhB85ud8KeaviBZoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kiJUcg+9; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kiJUcg+9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245210; x=1747781210;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dSW16Z5owqXk0diJ8oqVw/YYkOHbNprsGlWIpUTivak=;
  b=kiJUcg+9yL2rddVFNareTbodN99gxdfTE0uo11phtksxYLPYfGkm1cUV
   ILdlvmcvb3wItd2l6zDyVhd9MLbGHduJldDeRLXuvS7zMoZj1eEbpHH9+
   PAtJ2/cpXLFwo4keyuV6LVle3yvzZnfcyoKDqpeEcjRjMti4+ldP+2xB/
   oRj8ZPDPMQrrKVSdjuaeiZgMxh5JipmXRqiVu2LtXoOymkqKzWvOWfxQm
   7Lm84k0Oifw+eymDDzZdxdLSRWxSOYgjY44fiSr/Q44PW5nzekoD9Ulyy
   sf3ux4qtbZcxWF36uzzHuPJbajGmDkgJJ//l3MyLKQtO6IxqNsr04sn1V
   w==;
X-CSE-ConnectionGUID: UBo5pqsCSmCwV71YW9+y7Q==
X-CSE-MsgGUID: wRi5Ak/PRFOX3U6bzqseBA==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199838"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199838"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:39 -0700
X-CSE-ConnectionGUID: 10UPfhpOSu27kDmEtACdaw==
X-CSE-MsgGUID: 15/3bRvIQzO/o2blYupKog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593473"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:38 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Luck <tony.luck@intel.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v6 30/49] x86/virt/tdx: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:46:01 -0700
Message-ID: <20240520224620.9480-31-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240520224620.9480-1-tony.luck@intel.com>
References: <20240520224620.9480-1-tony.luck@intel.com>
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
index 49a1c6890b55..4e2b2e2ac9f9 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -33,7 +33,7 @@
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
 #include <asm/tdx.h>
-#include <asm/intel-family.h>
+#include <asm/cpu_device_id.h>
 #include <asm/processor.h>
 #include <asm/mce.h>
 #include "tdx.h"
@@ -1426,9 +1426,9 @@ static void __init check_tdx_erratum(void)
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
2.45.0

