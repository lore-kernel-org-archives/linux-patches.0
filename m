Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A1E14D70E
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 18:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718044543; cv=none; b=uvLw/vycM7Xs6Ri13MHfZsTTEaofJiVO/90gQD1YZ6OOIuyXxj8kX2LBPRFh8k5vq2shCYbmbvT8W29OqlF3+Lh3j5MNzDwgbpm7pZ7v29qKrCTYjCygaWJIy0yHjLC9vII8YoLOhk42Oc+0f2vnE3BcBktY2hV9lLL8qmknsf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718044543; c=relaxed/simple;
	bh=rn0KrBbaxmxIvcwnUxg9RXSoxA6CbEQejJ+AMhDKEk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1tbDbOnJVlwMTF6JHfuDoZgArHQYnbg++I2je2cUaTG/o9ClYdsw0heM3zWQtp/j0UbKDG3gt4WHQCTcR2IfkxWfI2G+PxpLPd234f7Ymz6dE/zwdOIB1emPPuQdnO5rDUfWtpPPem4I2UWH2ZecIzJ4+X0XVAIgYJrHdDATNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L1j2G1rH; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L1j2G1rH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718044542; x=1749580542;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rn0KrBbaxmxIvcwnUxg9RXSoxA6CbEQejJ+AMhDKEk0=;
  b=L1j2G1rHNSpmTOBdvCXWwrc0733pqloVNpLlmd4rXKtxIANt9QxPQMnh
   c7//G4itI51mZOYumAd33U9gJmN3al87U+zRLzdZPgdhlc38ivTkOgFSG
   Fo7/z0SgpguP+QEDoP/T0hiiJ+MZNZm73Z5lXUa9vOCV/mxMxuEe0ZOYp
   MLKrvu0zpxn5cB738HnRLWbSm+B915ojqFN5WQU09j7rrZDojm5gmOEcj
   IM7qF4RvCZSvaCTzFKNtJk0+gaA0Z5kwRx9lRxC+IMjBMAf5pBesCtiRr
   cGVYUGmm8STcGAzm9jKFt0/d7/uFCafQ7w2PV+CZLUaUHs6HZmhcOK3re
   A==;
X-CSE-ConnectionGUID: VAo2GH3cRr2VRyGhYrZxdg==
X-CSE-MsgGUID: Hw5Mfg/USOSoejRVgqYTHQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="12004804"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="12004804"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:35:38 -0700
X-CSE-ConnectionGUID: uFnKXVJdSkeA91sLvnT/SQ==
X-CSE-MsgGUID: 2W5jD0MRQjayUotCB7WUKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="43576563"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:35:38 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v20 05/18] x86/resctrl: Add node-scope to the options for feature scope
Date: Mon, 10 Jun 2024 11:35:15 -0700
Message-ID: <20240610183528.349198-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240610183528.349198-1-tony.luck@intel.com>
References: <20240610183528.349198-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently supported resctrl features are all domain scoped the same as the
scope of the L2 or L3 caches.

Add RESCTRL_L3_NODE as a new option for features that are scoped at the
same granularity as NUMA nodes. This is needed for Intel's Sub-NUMA
Cluster (SNC) feature where monitoring features are divided between
nodes that share an L3 cache.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            | 1 +
 arch/x86/kernel/cpu/resctrl/core.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index aa2c22a8e37b..64b6ad1b22a1 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -176,6 +176,7 @@ struct resctrl_schema;
 enum resctrl_scope {
 	RESCTRL_L2_CACHE = 2,
 	RESCTRL_L3_CACHE = 3,
+	RESCTRL_L3_NODE,
 };
 
 /**
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index b4f2be776408..b86c525d0620 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -510,6 +510,8 @@ static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
 	case RESCTRL_L2_CACHE:
 	case RESCTRL_L3_CACHE:
 		return get_cpu_cacheinfo_id(cpu, scope);
+	case RESCTRL_L3_NODE:
+		return cpu_to_node(cpu);
 	default:
 		break;
 	}
-- 
2.45.0

