Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5273B4CA779
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 23:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600412; cv=none; b=fyDZN/kHDRvj/VimzcWg4U1/xMmNd6aG7989aZzlAjtfybROl+8WHK4Lr7SrxAZ/pREtnzvlQ7qy0zos74iMmTRP/t5MFuypDJg0pPDs65y1n64DFOx91Fn35uir5IrhF36aZikTYQ4BpWAiQvvvtTDMmjdD9pOW63zkBH2MFqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600412; c=relaxed/simple;
	bh=XCX+SCuVuGGp2hSn0gORTZORy11446xuO1qh/nEZE9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2nuvNQzVDqQjIWxXYgOCraCNVhnHlkoRfX1elhJx8C9RLQBQek2J63D+CMD+CM85OAHMBtQ19AiqGgszge6R2hgV1JSezMwLirAL7AqNKTMTvqtyWnir9ezV2ntViHlIdRzozpDf0N68Vs3gMxSd6fVCAJcz+XbmKkuraIa7KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d28sS7u6; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d28sS7u6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789600412; x=1821136412;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XCX+SCuVuGGp2hSn0gORTZORy11446xuO1qh/nEZE9U=;
  b=d28sS7u6Pk1iavkKzJr3gTemDLdhy/l4ORUSDZrNxiDSHOrgcAxeGp1b
   /aGqv+oJEkG1uSa3c4it94xa7ZsrtUutknySPK+q0Mjk7tc8oEtHZffBx
   /nd6L4pDuOmVL3y5V8VlHxtgi9MRMMSbk0ZNiL2J9CPpzXJpj+ddacfCc
   ybtJtUDdTZeDE1cLbsDltRJqQo7F3xwyIKpgkQ0g6uf6UM9o3/67R2x8U
   lW80nkLHEQcNeEqylsi/wX4pCn9ff9aPE8ilzFYxDALoMSYM0V/Az13f7
   BbBB9i927EsjBcC+Ygy0fW5SEyDRU7qhXqY6mzRlsx9iyBSu6K5j4IFdL
   g==;
X-CSE-ConnectionGUID: 9D0UJxdIT6awV6Jx+a9HMA==
X-CSE-MsgGUID: 77mtF7qQTUu2u7XsB2DuOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93861317"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93861317"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:30 -0700
X-CSE-ConnectionGUID: hQxGxMWMRne8pqCNZzK7mQ==
X-CSE-MsgGUID: +ni1n5YoRyyxBmVVEGwSYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277231420"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.219])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:30 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v12 01/25] x86/cpufeatures: Add missing CQM feature dependency
Date: Wed, 16 Sep 2026 16:12:56 -0700
Message-ID: <20260916231320.14502-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916231320.14502-1-tony.luck@intel.com>
References: <20260916231320.14502-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Intel Software Developer's Manual says that software must check that
CPUID(0x7,0x0).EBX[12] (Linux X86_FEATURE_CQM) is set before checking
for monitoring features in CPUID leaf 0xF.

Add the missing dependency of X86_FEATURE_CQM_LLC on X86_FEATURE_CQM.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v12:
	Drop the X86_FEATURE renames. Just add the missing dependency.
---
 arch/x86/kernel/cpu/cpuid-deps.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index 99801e844b30..93d45b688f6c 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -67,6 +67,7 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_AVX512_4FMAPS,		X86_FEATURE_AVX512F   },
 	{ X86_FEATURE_AVX512_VPOPCNTDQ,		X86_FEATURE_AVX512F   },
 	{ X86_FEATURE_AVX512_VP2INTERSECT,	X86_FEATURE_AVX512VL  },
+	{ X86_FEATURE_CQM_LLC,			X86_FEATURE_CQM       },
 	{ X86_FEATURE_CQM_OCCUP_LLC,		X86_FEATURE_CQM_LLC   },
 	{ X86_FEATURE_CQM_MBM_TOTAL,		X86_FEATURE_CQM_LLC   },
 	{ X86_FEATURE_CQM_MBM_LOCAL,		X86_FEATURE_CQM_LLC   },
-- 
2.55.0

