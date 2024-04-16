Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968C913BC1A
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302409; cv=none; b=KIBWd1Xn0skjhpM081eE8VfQAC3NcPPF1LduprzPwNHcesxdSAxiMMyL6JEUGC2oPyEM2dNzH+j+PRZ5RXXiUFydQGa7fExAl5rgoADItnr4hRqV2PJanX2tMpS3Ln1dBVHKG5mKQzVrm2PD/CKPdG5C9NXNg/papaAAX8d5BjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302409; c=relaxed/simple;
	bh=PH4S/Ii609Lmbnp6CowHBve2HoFhBNoMQHmg9A/lKU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQ3jZN+zZ183UDS+9Wiy4BR660PftbkSRjjEl/eAI8rT3oj1A/j/ZiCL+Cmpq90kWcl4VrjWmi4628POsw/BAPbmQF2wUz4SqyTPWqaH4d9pUMq0iazhLeriEuodelD7XdcpttMQjxivJ/KdB8SdSFA+6UZDPfHmEzZwk3LxpAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HWdGEyvW; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HWdGEyvW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302408; x=1744838408;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PH4S/Ii609Lmbnp6CowHBve2HoFhBNoMQHmg9A/lKU0=;
  b=HWdGEyvWi+w/hh5TaVJV8/9nvIEmCFmX7jKgM6QifibI5CSOn9I/6ZJP
   FrPi0Fl10cO836chjTDvKE8lYSpdHRXgl/YV4fhRQsXXpWMwqcjwPzdpV
   Ly9Gg2jwi6U4zZkF9PKEg08OP/dFaNCRw4ZGhHnAoij8UBMOxsOIURANs
   K0z4Q3DTyGeczfRybWtF9VzuxGMRdz7mhbJIqriP3HhAchwMXBXDYV/2s
   qAYXIGJ6GQG8cwIlptD5Qvf/aaLzkfrP+bYRvTvzYyHBuDJ2+5H/uTBcK
   qDEWVfT5UB9pwIT83D+nguOixMcxhRXD3O+jc/aEs7Dq2U1bBi683bMXR
   Q==;
X-CSE-ConnectionGUID: O4id0TVbR4uagNGsrOsyBQ==
X-CSE-MsgGUID: RvJ4pqjeSByfN07r5zsPew==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914760"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914760"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:00 -0700
X-CSE-ConnectionGUID: egm7MHCnSA6HF6mzVp+mcw==
X-CSE-MsgGUID: 3K5d/Tp+Q7qbI8YVRVaKKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22871944"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:19:59 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 20/74] x86/cpu/vfm: Update arch/x86/kernel/cpu/match.c
Date: Tue, 16 Apr 2024 14:19:22 -0700
Message-ID: <20240416211941.9369-21-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/match.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index 2243083f0bc2..8651643bddae 100644
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -25,7 +25,7 @@
  * asm/cpu_device_id.h contains a set of useful macros which are shortcuts
  * for various common selections. The above can be shortened to:
  *
- * X86_MATCH_INTEL_FAM6_MODEL(BROADWELL, NULL);
+ * X86_MATCH_VFM(INTEL_BROADWELL, NULL);
  *
  * Arrays used to match for this should also be declared using
  * MODULE_DEVICE_TABLE(x86cpu, ...)
-- 
2.44.0

