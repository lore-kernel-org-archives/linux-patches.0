Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E881130AD4
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643316; cv=none; b=buQy015BCv9fhPijz8QxHU4aLBa5eFtep/glAhOWIsX/opzt4i3WhPUjxYInw67TsgYYaJXSmu1imcc7nPh4t/F8EEpnGJLS49s3+97X8XoFRKWPY6PHgJ/+tPQcAzvCqZJKTvY+EJPtLwSp4tWKGj9BZmY/jaf4mO09BrBHsOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643316; c=relaxed/simple;
	bh=dygrK2zjHqwHAZ7GV+1GDX0xP4BgW/ok8UeOvnt7+Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXULlGSkzLTF4gew36jkjmrdGGzPb/Bpm8DVCbCnjJmeS+ICOGrjDPjFGdd/uu2zV0PiaHh87gXI1XqF1ibMuqac7JD5n4anqofZFYbOIHvjatuhL5iV78/BlRS9CrEKC6w1TepxibZx/r5ppIIFmROHTDYi41dwO9/FEhHcQQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nzn4w3dD; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nzn4w3dD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643311; x=1743179311;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dygrK2zjHqwHAZ7GV+1GDX0xP4BgW/ok8UeOvnt7+Gk=;
  b=Nzn4w3dDCEL/rXRv88U34ZYuiraCVzVcwJzYGJEY+Fpwk4eW4/Zve6Te
   uCe2DFLsseFUgs+lt+H1fXEFqmtnGKlQD51NGijT6+72PKYMrbe9Ojm8X
   UDIG4vgGZPLtz+kkjxbD8WQg2ngPVtCOPJLgO+P0VfNpz04DNTw5nIXN2
   qnUG0H4MOOUMelYkirCnF1KjtlnMQJ2gkty6FWtjfqsNSXfDUgo3PSEx9
   cKuZVDFBfM02LMF3T/v562JUkg00R3Vn1H5XzlxNFFwYUMNz+4YxHuRi/
   LA8CBAIwaoyPLqop1Wl9+QlImQTTM6MU3IZsGhTTWcrv3KJ4lAH7is3y7
   Q==;
X-CSE-ConnectionGUID: rNtqWRSNRUq4gv2DiFkXtg==
X-CSE-MsgGUID: W6eBalQxQNy+KVOq5ylm5g==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294759"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294759"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726060"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 34/74] x86/cpu/vfm: Update arch/x86/virt/vmx/tdx/tdx.c
Date: Thu, 28 Mar 2024 09:27:28 -0700
Message-ID: <20240328162820.242778-34-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328090459.242500-tony.luck@intel.com>
References: <20240328090459.242500-tony.luck@intel.com>
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
 arch/x86/virt/vmx/tdx/tdx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 4d6826a76f78..6d352c115fba 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -34,6 +34,7 @@
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
 #include <asm/tdx.h>
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/processor.h>
 #include <asm/mce.h>
@@ -1427,9 +1428,9 @@ static void __init check_tdx_erratum(void)
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

