Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4A613AA3E
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302407; cv=none; b=iw1xIcNfJdKWkk6d3hJCzbYWN7mjv9LFHPUHAZ+TqgT4oAoO5XB09fLI+wnCId73jkTQdSx8JkfTf9saI3BjcSL2HzD26YjO83b9ncBaDWNc234Kd7GwLBsWz/UcooPNB7qVGgLW+tbTragv5QMlMrHM+qaRplJ3lt9nQ/3PV4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302407; c=relaxed/simple;
	bh=eG+ObRK9OWYeF0qpPClL+eIH5Z0ykTXrKTfDIbFpAOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQSIOMIqgTZBZniOom5LgLj4SGeZmVvE6lOIIXIjxtgkyUx95TMu0aX7QrCiub2SR9aRjX4AxVtmpOQj0IEa16iBNQ3T9KAVVEk/sZqYcU5UQHahVgSZfug4UCO90w+PwtlvBhHrYC6fMZZGcFU9dHnPbrsQqq3Ccp7ata7+pE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gC7M6uIJ; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gC7M6uIJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302406; x=1744838406;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eG+ObRK9OWYeF0qpPClL+eIH5Z0ykTXrKTfDIbFpAOw=;
  b=gC7M6uIJ99dJRduLNMBo28g6TniKysv5/bixB9AQ3NgxJ1eYvUMOgBtf
   kRgdh2ikSvfFGUEYo/vdkEAlRSPf1CLFK+ZgtsOsa8Zjn2bJGJGOXPDF5
   2CImpLeGzSJlM4b/MEQ453WnE3ILaZ0xBsDXz1g0XkqGT6RMJ9GuYH9cx
   6qsb4ZUJVd+MDVdFe+HnBq9dgeBxS1Xs9vZ74Dseh9eq6fO1VRjHamyco
   xisV1XeF/1PuXYyHHTsJgorevd1GExUdzURD8tP//moxGD90qQ33FxEAi
   W2Ldsz/KlQCsoEnJbvh+EKJKGK3JJVzCcjssH9WB7pwYEnLEGR7qBcRL7
   w==;
X-CSE-ConnectionGUID: T/Aw4mQvSOOWpM9wP4cT5Q==
X-CSE-MsgGUID: X39BVwHEQNOTzVlHa0dT4g==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914738"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914738"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:19:59 -0700
X-CSE-ConnectionGUID: ddUWVdmxTVWRD4LrJ3Svxw==
X-CSE-MsgGUID: aveIVrY4ThuRDVMOroWgAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22871930"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:19:59 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 16/74] x86/cpu/vfm: Update arch/x86/kernel/cpu/bugs.c
Date: Tue, 16 Apr 2024 14:19:18 -0700
Message-ID: <20240416211941.9369-17-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/bugs.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index ab18185894df..896d4e2150fe 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -26,6 +26,7 @@
 #include <asm/msr.h>
 #include <asm/vmx.h>
 #include <asm/paravirt.h>
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/e820/api.h>
 #include <asm/hypervisor.h>
@@ -2391,20 +2392,20 @@ static void override_cache_bits(struct cpuinfo_x86 *c)
 	if (c->x86 != 6)
 		return;
 
-	switch (c->x86_model) {
-	case INTEL_FAM6_NEHALEM:
-	case INTEL_FAM6_WESTMERE:
-	case INTEL_FAM6_SANDYBRIDGE:
-	case INTEL_FAM6_IVYBRIDGE:
-	case INTEL_FAM6_HASWELL:
-	case INTEL_FAM6_HASWELL_L:
-	case INTEL_FAM6_HASWELL_G:
-	case INTEL_FAM6_BROADWELL:
-	case INTEL_FAM6_BROADWELL_G:
-	case INTEL_FAM6_SKYLAKE_L:
-	case INTEL_FAM6_SKYLAKE:
-	case INTEL_FAM6_KABYLAKE_L:
-	case INTEL_FAM6_KABYLAKE:
+	switch (c->x86_vfm) {
+	case INTEL_NEHALEM:
+	case INTEL_WESTMERE:
+	case INTEL_SANDYBRIDGE:
+	case INTEL_IVYBRIDGE:
+	case INTEL_HASWELL:
+	case INTEL_HASWELL_L:
+	case INTEL_HASWELL_G:
+	case INTEL_BROADWELL:
+	case INTEL_BROADWELL_G:
+	case INTEL_SKYLAKE_L:
+	case INTEL_SKYLAKE:
+	case INTEL_KABYLAKE_L:
+	case INTEL_KABYLAKE:
 		if (c->x86_cache_bits < 44)
 			c->x86_cache_bits = 44;
 		break;
-- 
2.44.0

