Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692E2130A4F
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643313; cv=none; b=A4mrDvBf7XMDDEoAnpJB4ymB+4kFp/vtmOs9CFS4OTB+ST4BL5w0/ITtSMYvgRfo7jR8JCS7sJz0EL3LVgm5siGODCGV7Qe3GY8qfMr+o/ZZ9xADPIQ+oUvOf9KfFsr2Zrd1pFWnWpkhGBXZTaplo43kXqDhXNXP7JKo5HAN2b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643313; c=relaxed/simple;
	bh=obhXYEmt6d4ZPBEnG583vH7Ox14Ir+rTrmmNAEgF6jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+M/8SdsJC2iWHJlhXkk4X4NxrumWv1Aa2dOFeKgqkZHU6RSOajsNDCr/jST47DUFowH/JPTQBNAoUAEIOX8/fEsdx+O+R2YwFt+0RQs94OK4L7rYBCnZ/A60zQJjJl9PHy39vy2t56eqP9aLMbCUuHgYlR5YARLaQ8RaWP6IdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lpbmPgRa; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lpbmPgRa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643310; x=1743179310;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=obhXYEmt6d4ZPBEnG583vH7Ox14Ir+rTrmmNAEgF6jg=;
  b=lpbmPgRaoggGQT1L+DLNXIHk492Xx1YOgmU0uN2EFK1PrInMpnnlAzsU
   T9MnwkKgGZQPKxeC7T412JPWkgOqqEJzPbyo2A+8efg/RfUW/AV4A0qid
   64US605g0ZXMJ9uxC+8vAB1W0R6HAkx9LoKOFzwxIk+uQ4qobJ8o1kXck
   /wRe/xBaHZN8/IYC3LXdh8LwtSGZMtcN6TiA5gA/92UkKS7fd7O8K16iS
   IsYgUR2ZKZgrZ7+NJKwmRXBh/w1VeVWxtP8XmA8zJzxw0LwVU+OPs7Pzk
   +R5S7zyUsOKdeITFaCefKEt0T+MTixmJEktRZqKPd9eW2yUTpxdiSzNK8
   g==;
X-CSE-ConnectionGUID: iG+DkyOGTnmNoGySMH4b+w==
X-CSE-MsgGUID: Lhyw2p82QA2nNBtRFM+PJg==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294758"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294758"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726056"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 33/74] x86/cpu/vfm: Update arch/x86/pci/intel_mid_pci.c
Date: Thu, 28 Mar 2024 09:27:27 -0700
Message-ID: <20240328162820.242778-33-tony.luck@intel.com>
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
 arch/x86/pci/intel_mid_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
index 8edd62206604..933ff795e53e 100644
--- a/arch/x86/pci/intel_mid_pci.c
+++ b/arch/x86/pci/intel_mid_pci.c
@@ -216,7 +216,7 @@ static int pci_write(struct pci_bus *bus, unsigned int devfn, int where,
 }
 
 static const struct x86_cpu_id intel_mid_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_MID, NULL),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_MID, NULL),
 	{}
 };
 
@@ -243,7 +243,7 @@ static int intel_mid_pci_irq_enable(struct pci_dev *dev)
 		model = id->model;
 
 	switch (model) {
-	case INTEL_FAM6_ATOM_SILVERMONT_MID:
+	case VFM_MODEL(INTEL_ATOM_SILVERMONT_MID):
 		polarity_low = false;
 
 		/* Special treatment for IRQ0 */
-- 
2.44.0

