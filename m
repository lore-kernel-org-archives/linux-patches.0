Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AD912DDAC
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643317; cv=none; b=qs1pD0OZNVNT/9KBqH4/BpKrL2/PURoxYbYda1pW+tv63KU4zR9d7vd8i6bIrMhvzjEdSqWov5RhUebFru4mCUEE4bEHpcTtX6VO/4ScuxO78KITLio0PtP7C4ZddX8GG4eivIHByArnmM0wVSCnIwVY8LzqwE2l6mPttL3tJs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643317; c=relaxed/simple;
	bh=GAJ4tXjEN7lQ2UunRHqVUyKqhAXnTvHjZyO58Eg7pVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHxwlxc+ypFK28kG+KLR/TGXWS2aT33t60vszx/C+A+AtcEpor3BlZE5Seqi4ZUgdZA1oupXz+7KDtBsC/k+LPHTL+e7sXR9/MRVETvZcGqO1Uq0XnnG0Dwe/GwQxUbp65iIYTiLtBhQY8GUnrtQOvjw4eKG9uN0shh6yF/PxQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GhFR2UkE; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GhFR2UkE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643314; x=1743179314;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GAJ4tXjEN7lQ2UunRHqVUyKqhAXnTvHjZyO58Eg7pVo=;
  b=GhFR2UkEWG7duhoOQoJnjmmd4q57vMWTKJSieR5NRko2WfCg5oMt2ud6
   uQduw942uLhS+gds2/HITPt5yozhh+Tx+/f9TV04MM7qKODNQ6wfQQqLN
   dFLNU9QhxnqAQsXQNUkIe7PdIlEoNXb3YUpSMabHR8JD4PGs6ue4IpgqS
   zNdV9Rgmp5wFwFcgbUY1VpzHdDvMArxDKR/+6Ssi9uN/jVJ6dR1S7VM42
   YV47ErW9FUdCuiKSNjCzwvy8VwfhPsS+nuR0kBHU6LqpomNeDMoMuU1A2
   T6rm3/xz92lXHa8eiJl968P6G+sqKqz4V0XUiIugyFP5sboVo+NmB1Zzx
   Q==;
X-CSE-ConnectionGUID: T9xtYMGUR7Gleiz3zM6mEg==
X-CSE-MsgGUID: xWxdE+zATSeq94g2Sbn1jA==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294778"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294778"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726109"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:23 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 49/74] x86/cpu/vfm: Update drivers/platform/x86/intel/ifs/core.c
Date: Thu, 28 Mar 2024 09:27:43 -0700
Message-ID: <20240328162820.242778-49-tony.luck@intel.com>
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
 drivers/platform/x86/intel/ifs/core.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index 7b11198d85a1..33412a584836 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -11,16 +11,15 @@
 
 #include "ifs.h"
 
-#define X86_MATCH(model, array_gen)				\
-	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 6,	\
-		INTEL_FAM6_##model, X86_FEATURE_CORE_CAPABILITIES, array_gen)
+#define X86_MATCH(vfm, array_gen)				\
+	X86_MATCH_VFM_FEATURE(vfm, X86_FEATURE_CORE_CAPABILITIES, array_gen)
 
 static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
-	X86_MATCH(SAPPHIRERAPIDS_X, ARRAY_GEN0),
-	X86_MATCH(EMERALDRAPIDS_X, ARRAY_GEN0),
-	X86_MATCH(GRANITERAPIDS_X, ARRAY_GEN0),
-	X86_MATCH(GRANITERAPIDS_D, ARRAY_GEN0),
-	X86_MATCH(ATOM_CRESTMONT_X, ARRAY_GEN1),
+	X86_MATCH(INTEL_SAPPHIRERAPIDS_X, ARRAY_GEN0),
+	X86_MATCH(INTEL_EMERALDRAPIDS_X, ARRAY_GEN0),
+	X86_MATCH(INTEL_GRANITERAPIDS_X, ARRAY_GEN0),
+	X86_MATCH(INTEL_GRANITERAPIDS_D, ARRAY_GEN0),
+	X86_MATCH(INTEL_ATOM_CRESTMONT_X, ARRAY_GEN1),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);
-- 
2.44.0

