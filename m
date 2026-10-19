Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792443054;
	b=pMsgrn8y1WJVrYDu1YEsK1doDG1GhF+WuMXcerry1vPv0KB1VSw8F+U3T91mqyPjYexx
	 0zjTO+v5DQgnEBWX7bi/VmtSL0eQSJyzr/x8oKb/SsWzE2hQJ+EstXxiaVeUTAIibzs7n
	 S4tNR9Q3HM+5G5HSzMADYfm/VWrtD8eN+7jMTElcxBadPeQUqOmBQwBo25Td1Klcpln2h
	 /5mFlJnoijdZk4GdBQ/DGQ9XiNkjyNItPqQ3gwNKa6t51aW/TbbOMV/xlUZfDNRDtSxR5
	 Etg1QWa/mHm6C25sImqtPGTQcqBhEKXdC/oxeVhZBpsCc2smGFdhHLyjmWmO5hMIcNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443054;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2xibkmjnwtqh/VnVH8jztve42630lVoW9zqGDONC4jk=;
	b=1d3sMg3+rRIwMPa0H/1esFqNnsBDPGfBM6aUJl7qabYtZ1aigMPe19V7HUP8ZiS3cmVs
	 O5yjolmXEJ0c9PwEktpcDtBz6gcZJqZNGmeIz1Y7Cz2aYC2BA2NZCNeiQyKAw6+JhQXCf
	 Sl/LaOM3rQLHvQDWBOdxCO7Jbc8uFeCa00iqJnJK5IttvR4Qbj9NK6klM/qku9Nq8r/sb
	 DhuoiH/Syd3xt1eGu4pO9OJKyPEzBbENSOLogwkXoW2TArzDp9+sgBetF3wQmYNoADGK2
	 3cBj4O8401CewUaeQpM8p4clMlc0WKDYL9kyLIg8Uh7P+IDR0BE3m/LxXkQXdZwKJkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Kx18gGX2;
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C17606A333
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 20:50:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12C17606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Kx18gGX2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792443054; x=1823979054;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2ZVI/LHv+rFsSt+bEhFO/KBrUTQ5SCxV+L+I4nxa8Tw=;
  b=Kx18gGX2eHwH76IJ6XDVqLAK1IXRyCykPZ8zx2wE5ONJiImFELUI6ACI
   BCWZio84YBANV8/PdT1Cyhb4cpvRQDA86XNctuCpyJ2wZ71hJuwC2cdDi
   6P+x7vpjBTjAbsXTwT+HnhY0K/2fFPVtJAWv5GHIqle8WcDv5U7VOyY7a
   VCGltdL10tCUZaHS4MQ8IKwkHXAxF+jtt2u/oN/v4tyw75FUKjDzWaQ28
   zFJ5sGqS76gA1/Gl6MoyTvS85vLJjuzm66FMuibSwrpiXQYLOprij4b1L
   mdir4+fQmfHEVoW3kdngZeogFo8kJQsUi35/Cuwtn7RlpSzo3rGjRzFfR
   Q==;
X-CSE-ConnectionGUID: Yqhrsz+ISiCH4g3SdLA6Mw==
X-CSE-MsgGUID: BE6e6CEXRm6lWNAlbnejuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1131163"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1131163"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:49 -0700
X-CSE-ConnectionGUID: A79T1QYHSMWgsXyQDUUzXQ==
X-CSE-MsgGUID: 0+TF96LkStqf1WXNZAAZYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3008638"
Received: from spandruv-mobl5.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.87])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:49 -0700
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
Subject: [PATCH v14 07/24] x86/resctrl: Update special case for Intel Haswell enumeration
Date: Mon, 19 Oct 2026 13:50:14 -0700
Message-ID: <20261019205031.16977-8-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019205031.16977-1-tony.luck@intel.com>
References: <20261019205031.16977-1-tony.luck@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Certain Intel Haswell CPUs support L3 cache allocation but do not enumerate the
feature. A quirk probes for support and provides hard-coded parameters. The
quirk sets both the L3 resource and the global rdt_alloc_capable, but only
the global is used to signal that normal enumeration can be skipped.

Setting the global in the quirk is redundant. The quirk runs before
allocation enumeration and is the only code that can mark a resource as
allocation capable that early, so finding any allocation capable resource
at the start of enumeration already identifies the quirk case.

Stop setting rdt_alloc_capable in the quirk and skip allocation enumeration
when resctrl_alloc_capable() reports a resource is already allocation
capable, in preparation for removing the global.

No functional change intended.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v14:
	Updated commit comment in context, problem, solution form.
---
 arch/x86/kernel/cpu/resctrl/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index f0cfb37482d3..f2bf160d01c1 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -177,8 +177,6 @@ static inline void cache_alloc_hsw_probe(void)
 	r->cache.min_cbm_bits = 2;
 	r->cache.arch_has_sparse_bitmasks = false;
 	r->alloc_capable = true;
-
-	rdt_alloc_capable = true;
 }
 
 /*
@@ -930,7 +928,11 @@ static __init bool get_rdt_alloc_resources(void)
 	struct rdt_resource *r;
 	bool ret = false;
 
-	if (rdt_alloc_capable)
+	/*
+	 * On Haswell systems cache_alloc_hsw_probe() already marked
+	 * RDT_RESOURCE_L3 as alloc_capable. No further enumeration is needed.
+	 */
+	if (resctrl_alloc_capable())
 		return true;
 
 	if (!boot_cpu_has(X86_FEATURE_RDT_A))
-- 
2.56.0

