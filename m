Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D65080BFC
	for <patches@lists.linux.dev>; Fri, 28 Jun 2024 21:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719611790; cv=none; b=UjJVi/4/u9M1nIHediqZlCMqc89bkrPwsM3jhOnd9EOGZORVC7RU6L/SkayL0xbmfu9XDtRlaQHxrXFt9iafvrdOaQWEZqNETUrlL6lwXsbC3KwSiU5qYHfWz63C5cU6QeuZVQxrb7WWOx+TGAZHmJAitKXBHVqxL6J3Ce9+1K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719611790; c=relaxed/simple;
	bh=SH3mTIpDj2uEXUy+GY0B7A3UVMKQH25ecx2M84QmrdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqAaWmulEwepUc71d5kzJe5LzrWSi3a2Qlv0ZLxiugfeLoEmr1r+iKP0JylvqXjwc6ENsI0pU2NveC2T759vMcv1iDvMgks4COUpXwG9p8EJcGoh73Dl8FOf3qXjIOcXj+xhISl2YTiCETIe/TxdyPfeXe3YpmgBYAr19cmRzuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ic53K+lg; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ic53K+lg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719611789; x=1751147789;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SH3mTIpDj2uEXUy+GY0B7A3UVMKQH25ecx2M84QmrdU=;
  b=Ic53K+lgyBdyqK0pJtEL7+gbLEsHTE/+TQ0DEHgXUnbdPdY7u/5CsDeU
   ZNA9XuRdqN3flXY71BACjVNrhwJ5BGEybhv4VjNov3I27pyHa34OGG7o+
   40xwRVnUZ+QByuNOGoonMZ8NuLY87QvWfDFV8SvBMuhlXfDkMxOXbUCNz
   JTsCwgMAFBaqfhGqX0PJOEPX8oqtEkL+0jGZmhz3U8Z5CU6TV0VFJ1LJ4
   7zqPs1bAbi95/HyOVvNCL9rp+x3Q6E1GkeCekgU+uTCkszCcA/pqAfNaz
   941jaqOkt+qObGimqVmsMm0dtCRFRnWU2FwQSXECuzm989l3v1+A9E5hy
   g==;
X-CSE-ConnectionGUID: bCgFvWi2S6+ceNa55oZchg==
X-CSE-MsgGUID: wUDj0OPkTYWZltPxUNsPGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11117"; a="16762562"
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="16762562"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 14:56:27 -0700
X-CSE-ConnectionGUID: OaEMUvwKSEygZmBJP1jY4Q==
X-CSE-MsgGUID: GprbUlCxQyqW/PSdqCF41w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="68065648"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 14:56:26 -0700
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
Subject: [PATCH v23 05/19] x86/resctrl: Add node-scope to the options for feature scope
Date: Fri, 28 Jun 2024 14:56:05 -0700
Message-ID: <20240628215619.76401-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240628215619.76401-1-tony.luck@intel.com>
References: <20240628215619.76401-1-tony.luck@intel.com>
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
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
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
2.45.2

