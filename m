Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B66C139CF1
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302407; cv=none; b=qh3B4+T9w3hkoQCLtNNzre/6UYYtND6hYy6hWz9Lz4H64jOmJ4r1OS8+RMPHx+KAFchpjnFzvNQCVSphtfNPZSGxZsNrszN0CGWqJSht243fVIKMkKbkfsv1rpxgbdHQH+Rb78rhJsxJxGwOTB/u3KvtEhsuFb/pfvgsc2+HQz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302407; c=relaxed/simple;
	bh=dndizT9Ulq9m7aFlxgyZ2k3frDvJlY8U1hLr/jIpAEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dScayGK2VOX7dQiBttDCtIXBc+xjrCMv2mFQnCoyHDqxy0SaC/3r6uL0MjL03S7WJgsUFuK4RQholsVTeJxrcS4L+lhWIfYT7K3x4QAKHzOG+7OJbvxRrRDQGqe68HYHwBlFJ89WI6LTRI5eRfavNdklpCDMEurkSkk/DxDfcV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=csSR8/3p; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="csSR8/3p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302404; x=1744838404;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dndizT9Ulq9m7aFlxgyZ2k3frDvJlY8U1hLr/jIpAEk=;
  b=csSR8/3pPcmoweSuRtHtWpWycbDFTfYhSGAJPXMDjEbNoJU9aJBbUh2w
   KGfgNzEN81pcOBcJZT1nLj5BmU4l4nuJIApKrb43rWWLM6GzPLI+oWj6v
   8uj6cHr1I2NLPjNRW0EZVVIPen3qeFbqpVZdPcaKPU6XuJeWny+9K1Ecr
   lWc4yHbu4Ruiyn48+SzvMeu9k9nvE8WWkSKKS137u9v1dXDtGJIox6+pb
   zP3JrNmK7QlMnFdnReUnJ49gdwm4G1RMFS52RdBObeuMDVhFd+rAJXTHJ
   Hq+Yf6nwyQC9zPDY1vz89wprPbUYNjwtW8cTIYuYKHwa/QLQfdHKkCDAB
   Q==;
X-CSE-ConnectionGUID: tXZloMhGTlK/vFXsEYU2XA==
X-CSE-MsgGUID: 4adWryacQWWgxEApgJGnLQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914730"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914730"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:19:59 -0700
X-CSE-ConnectionGUID: flv1RO1ORNO662lmqvguqw==
X-CSE-MsgGUID: SQhwVD34QViMG6w4D1ELgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22871922"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:19:58 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 14/74] x86/cpu/vfm: Update arch/x86/kernel/apic/apic.c
Date: Tue, 16 Apr 2024 14:19:16 -0700
Message-ID: <20240416211941.9369-15-tony.luck@intel.com>
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
 arch/x86/kernel/apic/apic.c | 38 ++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index c5f5561406bd..8e0514eb552b 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -497,32 +497,32 @@ static struct clock_event_device lapic_clockevent = {
 static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
 
 static const struct x86_cpu_id deadline_match[] __initconst = {
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(HASWELL_X, X86_STEPPINGS(0x2, 0x2), 0x3a), /* EP */
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(HASWELL_X, X86_STEPPINGS(0x4, 0x4), 0x0f), /* EX */
+	X86_MATCH_VFM_STEPPINGS(INTEL_HASWELL_X, X86_STEPPINGS(0x2, 0x2), 0x3a), /* EP */
+	X86_MATCH_VFM_STEPPINGS(INTEL_HASWELL_X, X86_STEPPINGS(0x4, 0x4), 0x0f), /* EX */
 
-	X86_MATCH_INTEL_FAM6_MODEL( BROADWELL_X,	0x0b000020),
+	X86_MATCH_VFM(INTEL_BROADWELL_X,	0x0b000020),
 
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(BROADWELL_D, X86_STEPPINGS(0x2, 0x2), 0x00000011),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(BROADWELL_D, X86_STEPPINGS(0x3, 0x3), 0x0700000e),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(BROADWELL_D, X86_STEPPINGS(0x4, 0x4), 0x0f00000c),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(BROADWELL_D, X86_STEPPINGS(0x5, 0x5), 0x0e000003),
+	X86_MATCH_VFM_STEPPINGS(INTEL_BROADWELL_D, X86_STEPPINGS(0x2, 0x2), 0x00000011),
+	X86_MATCH_VFM_STEPPINGS(INTEL_BROADWELL_D, X86_STEPPINGS(0x3, 0x3), 0x0700000e),
+	X86_MATCH_VFM_STEPPINGS(INTEL_BROADWELL_D, X86_STEPPINGS(0x4, 0x4), 0x0f00000c),
+	X86_MATCH_VFM_STEPPINGS(INTEL_BROADWELL_D, X86_STEPPINGS(0x5, 0x5), 0x0e000003),
 
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(SKYLAKE_X, X86_STEPPINGS(0x3, 0x3), 0x01000136),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(SKYLAKE_X, X86_STEPPINGS(0x4, 0x4), 0x02000014),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(SKYLAKE_X, X86_STEPPINGS(0x5, 0xf), 0),
+	X86_MATCH_VFM_STEPPINGS(INTEL_SKYLAKE_X, X86_STEPPINGS(0x3, 0x3), 0x01000136),
+	X86_MATCH_VFM_STEPPINGS(INTEL_SKYLAKE_X, X86_STEPPINGS(0x4, 0x4), 0x02000014),
+	X86_MATCH_VFM_STEPPINGS(INTEL_SKYLAKE_X, X86_STEPPINGS(0x5, 0xf), 0),
 
-	X86_MATCH_INTEL_FAM6_MODEL( HASWELL,		0x22),
-	X86_MATCH_INTEL_FAM6_MODEL( HASWELL_L,		0x20),
-	X86_MATCH_INTEL_FAM6_MODEL( HASWELL_G,		0x17),
+	X86_MATCH_VFM(INTEL_HASWELL,		0x22),
+	X86_MATCH_VFM(INTEL_HASWELL_L,		0x20),
+	X86_MATCH_VFM(INTEL_HASWELL_G,		0x17),
 
-	X86_MATCH_INTEL_FAM6_MODEL( BROADWELL,		0x25),
-	X86_MATCH_INTEL_FAM6_MODEL( BROADWELL_G,	0x17),
+	X86_MATCH_VFM(INTEL_BROADWELL,		0x25),
+	X86_MATCH_VFM(INTEL_BROADWELL_G,	0x17),
 
-	X86_MATCH_INTEL_FAM6_MODEL( SKYLAKE_L,		0xb2),
-	X86_MATCH_INTEL_FAM6_MODEL( SKYLAKE,		0xb2),
+	X86_MATCH_VFM(INTEL_SKYLAKE_L,		0xb2),
+	X86_MATCH_VFM(INTEL_SKYLAKE,		0xb2),
 
-	X86_MATCH_INTEL_FAM6_MODEL( KABYLAKE_L,		0x52),
-	X86_MATCH_INTEL_FAM6_MODEL( KABYLAKE,		0x52),
+	X86_MATCH_VFM(INTEL_KABYLAKE_L,		0x52),
+	X86_MATCH_VFM(INTEL_KABYLAKE,		0x52),
 
 	{},
 };
-- 
2.44.0

