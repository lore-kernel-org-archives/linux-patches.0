Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A639E13E052
	for <patches@lists.linux.dev>; Tue, 28 May 2024 22:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716934820; cv=none; b=KcygbljNA84dHDcS9blLzGOZMH4v7Q+knnbXlnaGIl8RrhAEHSEp/Mtdac4NuIRjxSYZTG3OBELGOs3GQyefbxpLrxXZWuBWLL84/UPT4YNMiA2mSJwdmfv6032BgcY6IuN0UCu1yf9tdMh+bu7t+3UvtaOm54puRI+EYrX0QsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716934820; c=relaxed/simple;
	bh=rn0KrBbaxmxIvcwnUxg9RXSoxA6CbEQejJ+AMhDKEk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYHkPyf3mzZWwmNqf59HMwqGJrxJNb1Euzo7NHMnrCb+oJB9O9gQiRhvGCBwfAyN4McmtOwCLGSyYIRc8r2gSnntZBn1BJhlh6puOt+WR4d5ank0d7vz047b9tDhhH00jjDZyymHlQ8RojGnXdmWK2nY2ocn19rZcz22kXEm7mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KMMekxmK; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KMMekxmK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716934819; x=1748470819;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rn0KrBbaxmxIvcwnUxg9RXSoxA6CbEQejJ+AMhDKEk0=;
  b=KMMekxmKTiiB01xgyfeIUjAzNgXetkUmks3625sIMaWYo8EZdQ9HlQml
   8WmW/+GZ5MrKTjofW+TY9ETJG1nl5a3JDDE8LXFXhIyml7zbvmkJhG4u3
   iEGlMyaftvivLd8h5dc8Qs56wiF2IV9Ey7X2eMenZLno70Nx2gk+2d/nI
   hhMGXHC+aXT2ulyuwztyVq1EZ+4on4zHB07HAc0CPgf8k56dc+f/jOktq
   ubFIpiAiSjvuLIg1fTHfTi5FB9Ycc1E0AwFGFwY/j1We5XzmLti6K3PZ8
   JmRE4pMqYzRACbOW80CID0tVydu1UTmSk904edY44eKUAipmtpuV+UG1U
   w==;
X-CSE-ConnectionGUID: QwJKAPN3TJiVUlRW5AfT6w==
X-CSE-MsgGUID: jI45cPqBSq2ja9GiiQQErw==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="30812168"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="30812168"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:16 -0700
X-CSE-ConnectionGUID: M7/367ZzQhair+rR5lcFNg==
X-CSE-MsgGUID: VYdtSlOZQm+m2JExil5zUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="40090725"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:16 -0700
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
Subject: [PATCH v19 05/20] x86/resctrl: Add node-scope to the options for feature scope
Date: Tue, 28 May 2024 15:19:50 -0700
Message-ID: <20240528222006.58283-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240528222006.58283-1-tony.luck@intel.com>
References: <20240528222006.58283-1-tony.luck@intel.com>
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

