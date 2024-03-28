Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D4413118C
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643310; cv=none; b=BzRcI0+e5Rbol55Fh3PXwi88rcRqPUZq7zVSmGGK/rQmcuszuJsJrJ2I7YEOixCCG9P8QDbc6cio2zAzvepxtVGE/0d2FiP2HzsWhvNS8Wnem8rUy5QK00qeyac8mOYvpCVESPT9UQmzHtBxMIntFZyZjOGw/6yxorNghCOu8Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643310; c=relaxed/simple;
	bh=hfAO5dUUBdOo2kpr9COyowjTdhmZ3c+vkRBcP68Am9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCdBkBwjg6y65LxcLzK5r2d1lH1c6OW1P8LG2RJV82Uc3x33MgGOZXrSZDn//+W+WCzUIWNnzTyUJJqQ17wciauyYqiqBlluFPdh+X/j/Tg4puBV/+wNzl6XxivQFLWQExrrwue018X7QPjOqAn00lP+pQWR76FC1KyO7TQxHII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xq6YYM9t; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xq6YYM9t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643306; x=1743179306;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hfAO5dUUBdOo2kpr9COyowjTdhmZ3c+vkRBcP68Am9Y=;
  b=Xq6YYM9tz6MXkd36EfZQZtybEFBT0isQAGoEATWsa/+5UC2aICUHN6G/
   F+6ayTYD/QRHEpPjqaDX671zKWtosOldgsJJxl0RGxywlgwsdI6JiZn0G
   XjH1jlkNjFaEOvaIl3ZedDg6tpQuCFWOsEMkJWvl4wjAj7MwaGmKd8o7m
   u7Rzw76xHNGxIO6HPVR0NHwJD4mHkj/QHqTDSCgepRlCoU5kHpHEry7eg
   oi5cuhkFWxvwjVdVtIQOpeUVWqSPy/9Ug81mtb00zRsdYOJAyu3DmixOJ
   2y0xpaTmqZcTT1XKTL42LaYIJmwq4EMHjBWqlUOeOcPJRLmyZsuCjNoDJ
   Q==;
X-CSE-ConnectionGUID: fQvzRYIORQan7JFAgK4CRQ==
X-CSE-MsgGUID: DcXtXtr5SDSaY2RMYO5usw==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294738"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294738"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16725997"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 16/74] x86/cpu/vfm: Update arch/x86/kernel/cpu/bugs.c
Date: Thu, 28 Mar 2024 09:27:10 -0700
Message-ID: <20240328162820.242778-16-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/bugs.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index e7ba936d798b..5db0264eb2e4 100644
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
@@ -2323,20 +2324,20 @@ static void override_cache_bits(struct cpuinfo_x86 *c)
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

