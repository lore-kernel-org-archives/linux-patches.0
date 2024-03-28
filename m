Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7071311A0
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643312; cv=none; b=c7LbYA0iOvHxuv+QOgMuj8stO3FBTGPZfAtz6Xlh4eEc6ItXorBXA55JSxISxDLrvirm+k4E2x1gX/T+qqn/U0TmYriW49PgUjxBgckX3xnJ3DLbMztjiQ5w1VrScwolMg8y/k8Tl8zjbbsGQHxQzRD10/clHK6yg8kzulR78Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643312; c=relaxed/simple;
	bh=SJlMBQ9+4jWXRbv38yD7DIIo26tnroeP+h8FST/98Kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXDEAHRrbXF8wgp7cURHjdqJqR8JW4v3a7OqyFJd1RPCsEqdU6pjMSB2gHKGI1lpU3Fe17FdP6JBiaX/OAU29MUwQaZbkwKiJjHn3kvacM1prnuVf1KhqCme3/hUfViGNaHNh06yzc7iNvM2nCyvceXx7euuDENWv0my4eO6PrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e6jR73BU; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e6jR73BU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643309; x=1743179309;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SJlMBQ9+4jWXRbv38yD7DIIo26tnroeP+h8FST/98Kk=;
  b=e6jR73BUM1//JuSCY8DXL+vdS+VxC9hoa3+4PDo43hkNrN+0y1yQ8jJx
   9hngA3mlZ7g0U3wjGTQtIBsknNi5VYybsJ5H7YXFwshVzpyFa+IE5n3Xi
   SoaDrF7xB5oI2CEIppnzsqDDjLrliJb8auZHX/bY9TptuPnUlh6xVUHhz
   x5n5WEs8xquzEVsS1bPclJhVx/wQwmRIpQpg1KKMIJpdZh8N0t8bAndvF
   GP19+QkdU9gZEjoLimGOTk0J9Pw0ckbeU9vmDkB1c0G9AEgprykeDerY6
   lvBlfssfNcniXK3v+4wM60uyKN44b6VELGvmQu9LyGqQ4sJf+SeapKbrj
   A==;
X-CSE-ConnectionGUID: L922V0N5S6yzBiIJ/LuCpg==
X-CSE-MsgGUID: 3V0HrcfoT42db1AMinUXUA==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294751"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294751"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726039"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 28/74] x86/cpu/vfm: Update arch/x86/kernel/tsc.c
Date: Thu, 28 Mar 2024 09:27:22 -0700
Message-ID: <20240328162820.242778-28-tony.luck@intel.com>
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
 arch/x86/kernel/tsc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 5a69a49acc96..0699aa0cf3bb 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -26,6 +26,7 @@
 #include <asm/x86_init.h>
 #include <asm/geode.h>
 #include <asm/apic.h>
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/i8259.h>
 #include <asm/uv/uv.h>
@@ -682,7 +683,7 @@ unsigned long native_calibrate_tsc(void)
 	 * clock.
 	 */
 	if (crystal_khz == 0 &&
-			boot_cpu_data.x86_model == INTEL_FAM6_ATOM_GOLDMONT_D)
+			boot_cpu_data.x86_vfm == INTEL_ATOM_GOLDMONT_D)
 		crystal_khz = 25000;
 
 	/*
@@ -713,7 +714,7 @@ unsigned long native_calibrate_tsc(void)
 	 * For Atom SoCs TSC is the only reliable clocksource.
 	 * Mark TSC reliable so no watchdog on it.
 	 */
-	if (boot_cpu_data.x86_model == INTEL_FAM6_ATOM_GOLDMONT)
+	if (boot_cpu_data.x86_vfm == INTEL_ATOM_GOLDMONT)
 		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
 
 #ifdef CONFIG_X86_LOCAL_APIC
-- 
2.44.0

