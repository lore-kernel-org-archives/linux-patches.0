Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0123014534A
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302417; cv=none; b=sf+5pd6QY++l071k/L7WPB+UL1tPFGvsUHTrw5bZDS8iYmlabsr/UQSGhSSnpjJxrHCCDkLWXZVnVHsLnOAG/Rovemrs/Rkj6qdGpJTNsAM9xItWdqj8JKaQTXbH0AMVpYuIdpNlMr6WmfT7xpVn6raC9CPXdIDQ2znDwAEdfoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302417; c=relaxed/simple;
	bh=KWWRdUU5f5jfluH+XjQDN6u50z+YdtCCFs2TFHrBnZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGQO+8xcDJO59YxDCaP7GzTT+fVvKbliyJbvo+mOenZdan48clI0QWMuuNAdK6c1Oxld8TdRAspMjV/jYPP3Rk27LlpEcfedrFz5k7VeoBB3MydWoXHP523LPq11h3VORkWxtEMVyIzmwrkUBU0ik0RuW3DURtMMNYkaiMIb4pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EGXAQFr6; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EGXAQFr6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302416; x=1744838416;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KWWRdUU5f5jfluH+XjQDN6u50z+YdtCCFs2TFHrBnZg=;
  b=EGXAQFr6d4OstD+V9ryXce68DF8BkB0fQ4UVkjOuCd37H2pCoF6hbSOJ
   UtpPCB6eNcUSukuh0s270eM/KkjX2nEwi7Hf4Z8dWzaBYOptJiikSXJoM
   scX250zlmV4WRjgso5svSQsnszWtF/pyg5P9IscIz5tXC/4qdY7n3Wo62
   d8UOKmxVnhMP5Q0YRcEhPBXQiQVbtbkTICsDHW+V5Lfc3GaCyG0nRygZj
   3XNBKR6ehSdkUqxmsTzHlwnEGgWtxOD55UTPEKRrsgWAfQJFam1c3rG1e
   do9tKxt7QbnMr1GYKYnG+McyE4oODeJVop5014tTZ9W8wZWS3O56CVGp+
   Q==;
X-CSE-ConnectionGUID: o2M3WSgSSWqIQ0yYlM3Drw==
X-CSE-MsgGUID: LxRyPFB/RHCTUI5GUWZxwA==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914846"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914846"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:03 -0700
X-CSE-ConnectionGUID: D6L1S+hoRXClavCCmEi41Q==
X-CSE-MsgGUID: ftUbrBCPSTaQEDOBp8BqjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22872059"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:02 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 37/74] x86/cpu/vfm: Update arch/x86/platform/atom/punit_atom_debug.c
Date: Tue, 16 Apr 2024 14:19:39 -0700
Message-ID: <20240416211941.9369-38-tony.luck@intel.com>
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
 arch/x86/platform/atom/punit_atom_debug.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/atom/punit_atom_debug.c b/arch/x86/platform/atom/punit_atom_debug.c
index 6b9c6deca8ba..44c30ce6360a 100644
--- a/arch/x86/platform/atom/punit_atom_debug.c
+++ b/arch/x86/platform/atom/punit_atom_debug.c
@@ -165,14 +165,13 @@ static void punit_s2idle_check_register(struct punit_device *punit_device) {}
 static void punit_s2idle_check_unregister(void) {}
 #endif
 
-#define X86_MATCH(model, data)						 \
-	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 6, INTEL_FAM6_##model, \
-					   X86_FEATURE_MWAIT, data)
+#define X86_MATCH(vfm, data)					 \
+	X86_MATCH_VFM_FEATURE(vfm, X86_FEATURE_MWAIT, data)
 
 static const struct x86_cpu_id intel_punit_cpu_ids[] = {
-	X86_MATCH(ATOM_SILVERMONT,		&punit_device_byt),
-	X86_MATCH(ATOM_SILVERMONT_MID,		&punit_device_tng),
-	X86_MATCH(ATOM_AIRMONT,			&punit_device_cht),
+	X86_MATCH(INTEL_ATOM_SILVERMONT,	&punit_device_byt),
+	X86_MATCH(INTEL_ATOM_SILVERMONT_MID,	&punit_device_tng),
+	X86_MATCH(INTEL_ATOM_AIRMONT,		&punit_device_cht),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_punit_cpu_ids);
-- 
2.44.0

