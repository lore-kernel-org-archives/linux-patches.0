Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4815B130A4F
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643307; cv=none; b=gv5UwlM/Umlm1zviP4dQji4tG0/hYNjCuOZqWli+8GY6gstyibRmgR6l3mCt5K48+28tEhE1MprzVkSBEuD9tNe67EwNvcO3+X6xeAZlvZvzHi467GNZzzDZHU7lUB8yQqHjdNgQ/YXrqZWU4Cb0I8HJYJ0NOFZ6Pkixcf2aM3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643307; c=relaxed/simple;
	bh=Cso0970iBLZBpku05aR/BgRRak+5ImAGQIo7igDchxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTp5WQJixXyMTOSQ69A86xMK+OyrMEeZaiJD9SeusYXu3ZEzYXkt9+65oFa0v8Gol19ThgWSPsaJrFNe2M4CIc3pHhI+ylcSk7F/CCaB2zQ9VVy1g5gqMenCwsB9uk2jgqzC26xSLorVKHr4/GwiqIlqociavUat8hPf/gMoiwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ACHsvMcR; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ACHsvMcR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643304; x=1743179304;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cso0970iBLZBpku05aR/BgRRak+5ImAGQIo7igDchxw=;
  b=ACHsvMcRCgWcMxyfNSMPvnzTpSzUgv1VR1w3Mmi3POMd6dikMKf0c+h+
   rjBiTgrY2CE06HfHfs8eQT8wUGfedYc0+edrrSzxRINSR0AWSQrI7H0Ce
   yooXHEtSJiIJdBxI+rP+QhphHxceLKXPaZGm2QkTLw+jxSyFqutkk2B0U
   n2OD7ZqsHVw32dttiBQo0Noomg0Wf8OXyIi7SMv6Zo28ACsZUaPfCZDX6
   ACg5mjAjiAbruyVYTijGMoMumo+aEXaNB7bvHuyMCq5woxC7QPMYC12b4
   aVWbELcnHa30VchkWXsy/NOz5HCSAKN/l+si07vXIiZN658UmdOnO+h0Q
   A==;
X-CSE-ConnectionGUID: mQNCFBxSR8OAwvlelPF3ZA==
X-CSE-MsgGUID: Sqxbz5P7TbC2/2m3aT/B2w==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294731"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294731"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16725976"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 10/74] x86/cpu/vfm: Update arch/x86/events/intel/uncore_nhmex.c
Date: Thu, 28 Mar 2024 09:27:04 -0700
Message-ID: <20240328162820.242778-10-tony.luck@intel.com>
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
 arch/x86/events/intel/uncore_nhmex.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore_nhmex.c b/arch/x86/events/intel/uncore_nhmex.c
index 92da8aaa5966..466833478e81 100644
--- a/arch/x86/events/intel/uncore_nhmex.c
+++ b/arch/x86/events/intel/uncore_nhmex.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Nehalem-EX/Westmere-EX uncore support */
+#include <asm/cpu_device_id.h>
 #include "uncore.h"
 
 /* NHM-EX event control */
@@ -1217,7 +1218,7 @@ static struct intel_uncore_type *nhmex_msr_uncores[] = {
 
 void nhmex_uncore_cpu_init(void)
 {
-	if (boot_cpu_data.x86_model == 46)
+	if (boot_cpu_data.x86_vfm == INTEL_NEHALEM_EX)
 		uncore_nhmex = true;
 	else
 		nhmex_uncore_mbox.event_descs = wsmex_uncore_mbox_events;
-- 
2.44.0

