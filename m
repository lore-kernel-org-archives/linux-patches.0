Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9917E127B67
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643313; cv=none; b=D13LR1dy06Fi3cQnxG+0GM4U37hssvmPdUTwsy3koEu2mc5rjrH7o5i5PZgzcwjj5xrcXyTIPwlVjEpjaWZ7Y0pyfQjW91qBJm3+rdG3VVYKUA9Q5xzrPVz6cDOwErMLR25wSkSn+9fG8O0CGNz4KifO+iofo4z0ROXl6Tb/0vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643313; c=relaxed/simple;
	bh=+muWR4/mEwwLXtJHfxut/jEkspNEEcrpR5BzFhJ1KYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0vnNxTr2GMyMPMJzL22H+0kVwCiaWYfC/BswTpvr/hpH/wQ3U7NmOOGuACMBEk3qN4xHTStlhYk5vxv3z+VGSutdx6QGJrVDvIr5Bmsbp02ZQ374d2SCijxG+5xcsl9AcZi1zZcyqnlFRTE19Vx2N4WsPIxNIrLNNjyw1mnD6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BvxtKpa5; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BvxtKpa5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643309; x=1743179309;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+muWR4/mEwwLXtJHfxut/jEkspNEEcrpR5BzFhJ1KYM=;
  b=BvxtKpa5q00Isb1SA4UoJExHjhR+1e9Eel1ilcznZDGI0PnaOciH4ROt
   1Sf/msY5M4BWPG2dWDmdH/pgRq7P8/V1gn2r7YFFL68yDqc5PwXQO4ccZ
   n2P0Dqp4A7Cd8yjwBQDStAkx9FvGZEALhMq5CPl26zHcxXVqC8qiq1xK3
   +xrNg4gWdYR0lR49UlOch9Ppd3E5YGKOYtFA1Y55xMNkZ1mqAo9UmVKyg
   iJNo7XX+m7ExJBP88qFrU3aJB0Gp6qSRXKuZhnslYVzisMcDBJGpKnoHy
   T7DgUd8oW1vmm4baGyq3KVixPwYJ/vKASydOreALn6uHiLHOJ25LzOiNy
   A==;
X-CSE-ConnectionGUID: mYoOhB3GS8CUOlufSlgqbg==
X-CSE-MsgGUID: A+RW0Qj+TQGqGa5kP2Mpgg==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294748"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294748"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726029"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 25/74] x86/cpu/vfm: Update arch/x86/kernel/cpu/resctrl/core.c
Date: Thu, 28 Mar 2024 09:27:19 -0700
Message-ID: <20240328162820.242778-25-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/resctrl/core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 83e40341583e..863fef5e55a4 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -22,6 +22,7 @@
 #include <linux/cacheinfo.h>
 #include <linux/cpuhotplug.h>
 
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/resctrl.h>
 #include "internal.h"
@@ -821,18 +822,18 @@ static __init bool get_rdt_mon_resources(void)
 
 static __init void __check_quirks_intel(void)
 {
-	switch (boot_cpu_data.x86_model) {
-	case INTEL_FAM6_HASWELL_X:
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_HASWELL_X:
 		if (!rdt_options[RDT_FLAG_L3_CAT].force_off)
 			cache_alloc_hsw_probe();
 		break;
-	case INTEL_FAM6_SKYLAKE_X:
+	case INTEL_SKYLAKE_X:
 		if (boot_cpu_data.x86_stepping <= 4)
 			set_rdt_options("!cmt,!mbmtotal,!mbmlocal,!l3cat");
 		else
 			set_rdt_options("!l3cat");
 		fallthrough;
-	case INTEL_FAM6_BROADWELL_X:
+	case INTEL_BROADWELL_X:
 		intel_rdt_mbm_apply_quirk();
 		break;
 	}
-- 
2.44.0

