Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6740A143C5F
	for <patches@lists.linux.dev>; Tue, 12 Mar 2024 21:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710279780; cv=none; b=N0iUaocBRA/QmcATMfYmkowd881v17ruh8M356ANSgzuwqrbL28x8JoJN/A5+bEqFmfWCgstnzGxZ/naunHKhRlAgo8YgTaSiBxLQ989/o8/vC4hfWLPbMiwQcRK2h8smgNlC4lG6xBtxA4Dd5XxNrtobRl4x536+nGINEsmTag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710279780; c=relaxed/simple;
	bh=37B+wD8GZQ+AGX9Ef0uWyrg8h+w1cYHSWLfLo+YDOpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iusQQgba7i52Anai98XVah6zz0LK7CMNztFmiDF3XhCHUWhcAGhOptxfWm0+d1jjQWjkRplrOp0K5E8qYmaHVhpD3OMDS/e9Vy0ZXhFQAOoRQWcFTJG4D+BdjHvB4xxCNY9Lpdnm7pLjBohpQ3DZVr/1P2Rgc6GSr65hTNWfJkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YkHiIYEh; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YkHiIYEh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710279779; x=1741815779;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=37B+wD8GZQ+AGX9Ef0uWyrg8h+w1cYHSWLfLo+YDOpc=;
  b=YkHiIYEhNcFUfD+78+RlsCZJDpqwQnsWLUwmJhnga0AfPWx3pLOehL4e
   DgqHksJsQHZjqv/Im3tzzcl+WDgiSW0eV3Ik7DLgJxY3HWcmHUw4TbSrD
   /DdZUG6AjyVkVSlHptfHbjR/Neo4JX8HHVDV7il5tPXOPY9oEfRNukmsR
   OKOiR6DyKIOvQENU81GI9BaWSX9U6zVCyYhciSEWrO5BtBz0irdD+5OFz
   XDBmqPPL1PAOD0J8RPUE+EL6sUGeYxwXmNV5f2INBjBHbb2cVl3wdNioD
   MnzcRhWXQH/TuvB5qrdt7SD+zPB72mHw2jtC+/r3kHkCqnhc/ZOi4+t7P
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11011"; a="4884829"
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="4884829"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 14:42:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="12280152"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 14:42:55 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Drew Fustini <dfustini@baylibre.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v16 5/9] x86/resctrl: Add node-scope to the options for feature scope
Date: Tue, 12 Mar 2024 14:42:43 -0700
Message-ID: <20240312214247.91772-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240312214247.91772-1-tony.luck@intel.com>
References: <20240312214247.91772-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently supported resctrl features are all domain scoped the same as the
scope of the L2 or L3 caches.

Add RESCTRL_NODE as a new option for features that are scoped at the
same granularity as NUMA nodes. This is needed for Intel's Sub-NUMA
Cluster (SNC) feature where monitoring features are node scoped.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            | 1 +
 arch/x86/kernel/cpu/resctrl/core.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 1a4ac60522bb..87b360e87215 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -176,6 +176,7 @@ struct resctrl_schema;
 enum resctrl_scope {
 	RESCTRL_L2_CACHE = 2,
 	RESCTRL_L3_CACHE = 3,
+	RESCTRL_NODE,
 };
 
 /**
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index cd58c9d4710f..c34ce367c456 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -510,6 +510,8 @@ static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
 	case RESCTRL_L2_CACHE:
 	case RESCTRL_L3_CACHE:
 		return get_cpu_cacheinfo_id(cpu, scope);
+	case RESCTRL_NODE:
+		return cpu_to_node(cpu);
 	default:
 		break;
 	}
-- 
2.44.0

