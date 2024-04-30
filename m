Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217041C2329
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495910; cv=none; b=ewxLd4GXADIhuvz3MN15af0nWR4Bi74yrNcOPjlFPTypJPweNx6D6mbBz4xv498nSlMRP9ZyAGna6NuPttx1YjhFJhpqf0jGCLbzvReFnMJ1cSMMhfRHOQIFFTLbVO3PZevcJsgOw47gaeSjhaKPWz4lzCvSeU/hC5Z8GkkNVpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495910; c=relaxed/simple;
	bh=KWWRdUU5f5jfluH+XjQDN6u50z+YdtCCFs2TFHrBnZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukV5INdOfLM7DE1Fhyqp6NhP1rCi95abhIJPobdd6EcCdY06Ze6yxcxdCCD5JPF8KlkICGvq0uyRCfZST2/NPK35SGKy7SRp8B90OScwPNA6zWW4DLwaFjglUePFypk1JrW6Td1sAYzRb0qCs39H7MvN0fZxmwlTi9TMhVaqkWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cn9lUR4H; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cn9lUR4H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495908; x=1746031908;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KWWRdUU5f5jfluH+XjQDN6u50z+YdtCCFs2TFHrBnZg=;
  b=cn9lUR4H4lmvkXJtLjWj6AG03YpSTOqFw+G8wnPQKDKD2+KrZPdPv5w4
   skg/tId5gGIRtKXSJdhKbdRTB8QT9jC5/r/+KfaQYHDKsjepUxOqpN8GB
   D7J6GNBqju1f1ZqVZsXp3dawEOypkMEC5G3BLMwA7qNIEvDORd7pmF8ux
   8P/lJO7w99+vYcx6IV+K0uPt9zVWMgQt8ysP9yoo8JYtt3vUNtH2RMgam
   8EzkJbKJd76B7Tm4v0vjqC05qQ5H2aVM1uA/QFmXkHJsFIWM6/YyLDM+h
   HRPaEJrSz/ZKX6lLHLXYsK90htkrkYQRvMJmBFKlcQsCvPIXq2B1QywQC
   Q==;
X-CSE-ConnectionGUID: rBWhjHLsSOmXGswrluT5gQ==
X-CSE-MsgGUID: cTDvl7OWR+y+QpSORS9gJg==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075749"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075749"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:23 -0700
X-CSE-ConnectionGUID: 8p6YeWqzSna9phiURt0taQ==
X-CSE-MsgGUID: N3h3NHA9TFeDFdjFZzPeQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515496"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:19 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 30/47] x86/platform/atom: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:43 -0700
Message-ID: <20240430165100.73491-30-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430165100.73491-1-tony.luck@intel.com>
References: <20240430164913.73473-1-tony.luck@intel.com>
 <20240430165100.73491-1-tony.luck@intel.com>
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

