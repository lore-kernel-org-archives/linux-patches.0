Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6128130AD4
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643306; cv=none; b=AbCED23aCSnctnV/w/dFUMPt80l1xHlETVFSBEf03XUvtq0Bk0MAySQItnCYpAEpoV5Kg/x+BbF+WF/CFNf/QdPSVHHc+rvSiJ9b1rEex8CDht19db2VwyS+AY7y5NeTi1o630ES1X+Bn+Q6IaDrLYJA5ZNv/dpd+yLTAvNvLz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643306; c=relaxed/simple;
	bh=CwybUVe8crx1l4CZK03c9vCx8DvC8Bgt8uPcKdw9g+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2U4a9mGuCRMCFSjJ/dFS/o3p5DDYpZdZxeXpnWtfgz2MgV3aWkJBD1tOm4SulPyNb75rLTLVyfqCZJY8Ql2ZTYLvGvntVwtcgc91vvvdMFK3R6HaUxTg0nTi/R9G+veDHGgbqYWEnU0pSgPykZ0F1PnSNGdflu0PBvhRNqSqv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=czSLt3wZ; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="czSLt3wZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643303; x=1743179303;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CwybUVe8crx1l4CZK03c9vCx8DvC8Bgt8uPcKdw9g+E=;
  b=czSLt3wZnQA4hovIdC8iDSpmL0gxZnv1tU6sRlq99mLrWSRlUEM/uWog
   Qvk9Tcg6f0pEYLjrOeJRAzXZ+bFmejcQ1KK5zo+UEW7xMN/lqm5SAMC4c
   db0P+/sR5cydCGFYvIf6JREtOgrRSZdzyWPD9a5JCsPk60Atl/Cs+hYaM
   ysukePaBxdlwWkkslKgAMSw+1yUUm0NxukJAYI8F0yvbK7RjNzwdBh38Y
   ZJI3vcwF+UULnEsXP5HU92clQmgQ4Wc8sNC4Mo+aFp7yEMSFzzlEZOO1S
   toyqN5c8lWIgmLQ1FRzdWRxcJIwiNmqi+SVmo8rZBmw71/uPWQ9LSj7tQ
   A==;
X-CSE-ConnectionGUID: gYjy+Z6RQTmAi7psx8e9cg==
X-CSE-MsgGUID: DqSmcGi+RZKgbkswcUyJlQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294722"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294722"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16725957"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 05/74] x86/cpu/vfm: Update arch/x86/crypto/twofish_glue_3way.c
Date: Thu, 28 Mar 2024 09:26:59 -0700
Message-ID: <20240328162820.242778-5-tony.luck@intel.com>
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
 arch/x86/crypto/twofish_glue_3way.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 90454cf18e0d..82311249048f 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -12,6 +12,8 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
+#include <asm/cpu_device_id.h>
+
 #include "twofish.h"
 #include "ecb_cbc_helpers.h"
 
@@ -107,10 +109,10 @@ static bool is_blacklisted_cpu(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
 		return false;
 
-	if (boot_cpu_data.x86 == 0x06 &&
-		(boot_cpu_data.x86_model == 0x1c ||
-		 boot_cpu_data.x86_model == 0x26 ||
-		 boot_cpu_data.x86_model == 0x36)) {
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_ATOM_BONNELL:
+	case INTEL_ATOM_BONNELL_MID:
+	case INTEL_ATOM_SALTWELL:
 		/*
 		 * On Atom, twofish-3way is slower than original assembler
 		 * implementation. Twofish-3way trades off some performance in
-- 
2.44.0

