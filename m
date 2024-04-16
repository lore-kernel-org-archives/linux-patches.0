Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B894D13E052
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302416; cv=none; b=o7ZNQP78JQ5yrHT5AUnROkCR7RNdCz7wgzP6qlxB7NHuYeCsoNRdSF/r6ismj9GchSIMsKt98MiHwKwDUlK9YeVIg/RJTjDsI8QOVjV3ijdcFZfvDdBr4EubcYqS7kBpqwc82y+g8xFSKpmsenIb9dSpqaR+mZH5Iuzrqb/nLOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302416; c=relaxed/simple;
	bh=FfXHVVXxAXvXhf26U3fzvKJ4+8iaBCg597mpHe5hnu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkMnhhy0r8O2CDwlkvmx/LzhkkxBIqAeI2Ex/hoUXqANuif+4zTLY5st3CDOH0ewPNpRkzFGGCoaFF56GNxqZppiXt/uqefet2Yu/E1nK8vJTxlWLV1ArjgPThK9AEXKOh6fjmur+Ojh5nERpR7Rm66j+JST7YtT2/8zny8oYec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ApCfyoEI; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ApCfyoEI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302414; x=1744838414;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FfXHVVXxAXvXhf26U3fzvKJ4+8iaBCg597mpHe5hnu0=;
  b=ApCfyoEIydTFiCETlQsgKu/J1FnxXAU4NNpSAgyAC5rCLSQSJYjDo9sH
   ngHHCvYNvW7M/pyn7DKQxOJZMNWIgs2AW3RGfbBdDA5pj/YXHZK2PMghJ
   LQDry5tP5JzkMWjFFhg8GcCLJ61nCuHeuiVAPqZRu+usjM5NSoCvYpx0e
   Ne11O8k7N3eUzvtfAG2tCYYq5YOArcv7HaldOlW2+tAQ+L9nL9mOFda2q
   piPq5t/P0NNKFy3NnIRHYU5LaS0lSznYbWdSeJKuM9jVJlUqZgEAZkOin
   e7gy5UJWPqIXan7ur1R30X/n7A27YG+w7lyJ7V8tD+br5Jo9ZlIQghiEi
   w==;
X-CSE-ConnectionGUID: p/Ram5AtRiu5x58B9wSAhw==
X-CSE-MsgGUID: LqeAd4WpQJW6NFho8lb5AQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914821"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914821"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:02 -0700
X-CSE-ConnectionGUID: Si1VIfi7S3G9qCcDXwEhNg==
X-CSE-MsgGUID: wokfdItaTSyixIfeJLTpdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22872018"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:01 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 32/74] x86/cpu/vfm: Update arch/x86/mm/init.c
Date: Tue, 16 Apr 2024 14:19:34 -0700
Message-ID: <20240416211941.9369-33-tony.luck@intel.com>
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
 arch/x86/mm/init.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 679893ea5e68..fadc3fc3ee41 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -261,21 +261,17 @@ static void __init probe_page_size_mask(void)
 	}
 }
 
-#define INTEL_MATCH(_model) { .vendor  = X86_VENDOR_INTEL,	\
-			      .family  = 6,			\
-			      .model = _model,			\
-			    }
 /*
  * INVLPG may not properly flush Global entries
  * on these CPUs when PCIDs are enabled.
  */
 static const struct x86_cpu_id invlpg_miss_ids[] = {
-	INTEL_MATCH(INTEL_FAM6_ALDERLAKE   ),
-	INTEL_MATCH(INTEL_FAM6_ALDERLAKE_L ),
-	INTEL_MATCH(INTEL_FAM6_ATOM_GRACEMONT ),
-	INTEL_MATCH(INTEL_FAM6_RAPTORLAKE  ),
-	INTEL_MATCH(INTEL_FAM6_RAPTORLAKE_P),
-	INTEL_MATCH(INTEL_FAM6_RAPTORLAKE_S),
+	X86_MATCH_VFM(INTEL_ALDERLAKE, 0),
+	X86_MATCH_VFM(INTEL_ALDERLAKE_L, 0),
+	X86_MATCH_VFM(INTEL_ATOM_GRACEMONT, 0),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE, 0),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_P, 0),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_S, 0),
 	{}
 };
 
-- 
2.44.0

