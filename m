Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB8450278E
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 22:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790633727; cv=none; b=iZn+zK9KJdXgm7hJihFtXHhUgHDRiWTxjRRCusxmckuLGfMResWV/8L8X6N8Svb4ronNkcuXnYh6n/emp6ISbscggA68yn4b3MvNlIUBKu2hYtDVaTR4dfJkOGM19lKMhBWH+qqFnY4Ib2M8MKSMjkhQs7yr+golr0ImrtqbtYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790633727; c=relaxed/simple;
	bh=Lt8FCzYvITElzYlBQf+YZR8q+LpXlOQFy5oBI6Gh+Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i85f9q8a7qaaDKkYlvX47tj/50O68JyoA5EqNPg+1Vra5WOIaX//uAKl3t5AiQCuChJNijtiOisXpQgvyZho4YOMiywo/LnPxPzAZR2JdZbl9cQN2iQAdOO1PyD38f+bz0El+tzkr4YKmSkfKE4M8ZdWB1H3chJZGIi4hncEVvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S2SpZugA; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S2SpZugA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790633720; x=1822169720;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Lt8FCzYvITElzYlBQf+YZR8q+LpXlOQFy5oBI6Gh+Xs=;
  b=S2SpZugAIGWuR3ZVS1XuqVqu2vtTSeOIzoPijjhyD7hEtxdXxBMwDJzy
   fq564KO9+YuD18p2MD194BmYEU59h31qoT+JopUQDeuAnboJO0986CSHs
   m8fisrE2upNCljx2mFz0CNgn7i97Yd9HyYcjhg1fwdqZTFPyESxersNt0
   bUlsmSSVUDhnLMlAOb7P3MC4oj/9krca2xyxEav47OfFMmMJe+4EDdm2w
   zbcoBzDWsA+YZen8XzJlD265v/xhss45J9QJG3H92u75m+rK6W/o2YNfh
   OEbAXl0C71vGEYWtU0ZRygdImCYdqnJe8YMjpyduD0lQp0DNv92K80xRO
   w==;
X-CSE-ConnectionGUID: kjEg4/YcQQCCtRU7/27OWw==
X-CSE-MsgGUID: gageWlztSZGRF16ssxPd+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="90387160"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="90387160"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:17 -0700
X-CSE-ConnectionGUID: awguaEKjTJ+V7Oo64HerHg==
X-CSE-MsgGUID: YIJOq/5qTMyUL3pV9EtD7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="274685460"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.143])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 15:15:16 -0700
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
Subject: [PATCH v13 02/25] x86/cpufeatures: Add missing CQM feature dependency
Date: Mon, 28 Sep 2026 15:14:46 -0700
Message-ID: <20260928221509.68002-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928221509.68002-1-tony.luck@intel.com>
References: <20260928221509.68002-1-tony.luck@intel.com>
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
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v13:
	Added Reinette RB tag
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

