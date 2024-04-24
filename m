Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D571E1836E8
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982527; cv=none; b=siCTg5J8U1QbONjzs9TWugaquUJBlxeqE93/vz5/c1J1TSkvsMqVcyiTX4erNovNCyXndOcagVJkgFTirwtPiFs7WT8ZfvyT328TM5ZJwXXBkvSN22CUFLUod3SpxR/Q+hZOTNpzG1Rq4bS607HcZoigCj2oi7mlMYiJwwI2Egs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982527; c=relaxed/simple;
	bh=ebqOtnUkt/A9psEl5cZDP3DS54C80vHz8/R3RNrcpS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVASkrE1kCYIUm8uBBMwdEJGlm/KDU0xwWbwjrkus5f1j4HT9BoXrF4op/eVgz7K7vtLW7DSuczczMqbiWyTCVUxI62o/dT4ubwxdr+yQwKLig1vdubMoZdDSBqwg8ycIY/LLZSm8ZEQkVI1GB8niHRqmRy0FLoRBd7Cr0Fm6B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RWnejerB; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RWnejerB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982526; x=1745518526;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ebqOtnUkt/A9psEl5cZDP3DS54C80vHz8/R3RNrcpS8=;
  b=RWnejerBtUAlDuuMHv+2F+xTDYALDTwimNmS3D1VPshn6WGgQbWgs0tR
   UDUYamnvhJjzJGWDnDclZv89u58dmUL1bxqFTEgnwHze/A+q8Yi8TYsCx
   EUxDDG6jTgYlKYO2FBtBBeEuU6XjNmtPzrW3CtZ/D66j+inEH9WBA9kp3
   Q4/XqEkp5jF4iQgfVJQ5TfBEfZMU/kNHUk1E1zZGuAB+D5y0CDBJeqVSg
   tOPoTspUgBJPN/q4sSmczur8/xiegf8fpQNVAg6bIoKbS/Pq2rwdiCYMj
   SmoNpeqyFszffY3TCldyACVBzkfhV/n7fd4akUbObxGW2C2/AqDWVKDhR
   w==;
X-CSE-ConnectionGUID: PRQvD+DzS/Cm6m1fMTM96w==
X-CSE-MsgGUID: wdPnu8U6Rv6ghHizBEzmig==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9482062"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9482062"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:17 -0700
X-CSE-ConnectionGUID: JpdAqOPdReKZb5fPA5G9Eg==
X-CSE-MsgGUID: 8NhhASDjSpKDp8oAugHh2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="29262785"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:17 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Peter Hilber <peter.hilber@opensynergy.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Feng Tang <feng.tang@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v4 39/71] x86/tsc: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:15:17 -0700
Message-ID: <20240424181517.41907-1-tony.luck@intel.com>
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
 arch/x86/kernel/tsc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 5a69a49acc96..c4745141dd17 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -26,7 +26,7 @@
 #include <asm/x86_init.h>
 #include <asm/geode.h>
 #include <asm/apic.h>
-#include <asm/intel-family.h>
+#include <asm/cpu_device_id.h>
 #include <asm/i8259.h>
 #include <asm/uv/uv.h>
 
@@ -682,7 +682,7 @@ unsigned long native_calibrate_tsc(void)
 	 * clock.
 	 */
 	if (crystal_khz == 0 &&
-			boot_cpu_data.x86_model == INTEL_FAM6_ATOM_GOLDMONT_D)
+			boot_cpu_data.x86_vfm == INTEL_ATOM_GOLDMONT_D)
 		crystal_khz = 25000;
 
 	/*
@@ -713,7 +713,7 @@ unsigned long native_calibrate_tsc(void)
 	 * For Atom SoCs TSC is the only reliable clocksource.
 	 * Mark TSC reliable so no watchdog on it.
 	 */
-	if (boot_cpu_data.x86_model == INTEL_FAM6_ATOM_GOLDMONT)
+	if (boot_cpu_data.x86_vfm == INTEL_ATOM_GOLDMONT)
 		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
 
 #ifdef CONFIG_X86_LOCAL_APIC
-- 
2.44.0

