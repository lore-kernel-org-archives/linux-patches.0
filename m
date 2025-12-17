Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D587633F8BD
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 17:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765992138; cv=none; b=czpeUyx7Ue1WzizmQ1qPGN6THhndyh28mC7+T1Il+2G+8nIqxfotocKCGgnHNcmpm+CerOWwfe1GThI7uumuXNOsOSTf5hXe4hcVfcvxKfQ33j6u5U74ZuzarII3NqyI1UJqqmHgX6KUq6U8djU8dgwY4kOpWDc3NvT4uh98x2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765992138; c=relaxed/simple;
	bh=0HA9p6eS8yytLVl8cuuEfZt+5tKW/vgFMRD2CbIm8Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0Vv6TBPaWKVyoke2zAh8Qkb0oHonKPnVMcPzePa3x6s8beTXWXkK3BBzLzvLgOmgnsSuSk0UocHWQjPjT7J2E/IE6eNJx5Dud+2/jmaEmofUJ5AK3EgjyhhT0ugLdDXnVBRfzkAZTrQubcP5d3dofZ+t6ZCJ6mgl7tZRHhDJ/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hD9x1BqL; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hD9x1BqL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765992117; x=1797528117;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0HA9p6eS8yytLVl8cuuEfZt+5tKW/vgFMRD2CbIm8Fc=;
  b=hD9x1BqLLWthofrKxFaBqcD5ez0Q2pocTg9xpIcuNyFkPk1U7HUDbMoF
   Vfo4n8aHET+kfMe/sefDbsylFbSzcHxiH16GvDMx9k1jgYAHV5W+3NYLg
   8iQVt1PmLBPgQWqaIw2rv+RZXaou13VysF3b1B4WlhPu73hrvvAA+Gotd
   3J3ubUK3dEzpLF4PXzlPHacxL6evsphTQfRzdI30TbRCfm/v4bPH4hEPF
   bn1Nxyk557PGCuRCR38dXABErF2SlRIE2ft/48J8+hrKmz5LB8Q0erq0j
   3rke8lkRoggmjz9JWfXNz4oEN0bkcC6diStoDAlzl2SP+8/fphWGwm8X3
   g==;
X-CSE-ConnectionGUID: Xkkl7dqpQZqFDJ8RuPbrog==
X-CSE-MsgGUID: jQHuB+IaRai73JNjZKZP9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="90594729"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="90594729"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:35 -0800
X-CSE-ConnectionGUID: jbdVU0QHQ+eKXAV/NEUB7A==
X-CSE-MsgGUID: z2bUQCfZRMGlPCHdA2Zcdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="221748208"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.131])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:33 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v17 14/32] x86,fs/resctrl: Add and initialize a resource for package scope monitoring
Date: Wed, 17 Dec 2025 09:21:01 -0800
Message-ID: <20251217172121.12030-15-tony.luck@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217172121.12030-1-tony.luck@intel.com>
References: <20251217172121.12030-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new PERF_PKG resource and introduce package level scope for monitoring
telemetry events so that CPU hot plug notifiers can build domains at the
package granularity.

Use the physical package ID available via topology_physical_package_id()
to identify the monitoring domains with package level scope. This enables
user space to use:
 /sys/devices/system/cpu/cpuX/topology/physical_package_id
to identify the monitoring domain a CPU is associated with.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 include/linux/resctrl.h            |  2 ++
 fs/resctrl/internal.h              |  2 ++
 arch/x86/kernel/cpu/resctrl/core.c | 10 ++++++++++
 fs/resctrl/rdtgroup.c              |  2 ++
 4 files changed, 16 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index dc148b7feb71..2a3613f27274 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -53,6 +53,7 @@ enum resctrl_res_level {
 	RDT_RESOURCE_L2,
 	RDT_RESOURCE_MBA,
 	RDT_RESOURCE_SMBA,
+	RDT_RESOURCE_PERF_PKG,
 
 	/* Must be the last */
 	RDT_NUM_RESOURCES,
@@ -270,6 +271,7 @@ enum resctrl_scope {
 	RESCTRL_L2_CACHE = 2,
 	RESCTRL_L3_CACHE = 3,
 	RESCTRL_L3_NODE,
+	RESCTRL_PACKAGE,
 };
 
 /**
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 14e5a9ed1fbd..0110d1175398 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -255,6 +255,8 @@ struct rdtgroup {
 
 #define RFTYPE_ASSIGN_CONFIG		BIT(11)
 
+#define RFTYPE_RES_PERF_PKG		BIT(12)
+
 #define RFTYPE_CTRL_INFO		(RFTYPE_INFO | RFTYPE_CTRL)
 
 #define RFTYPE_MON_INFO			(RFTYPE_INFO | RFTYPE_MON)
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 2dd48b59ba9b..986b1303efb9 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -100,6 +100,14 @@ struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
 			.schema_fmt		= RESCTRL_SCHEMA_RANGE,
 		},
 	},
+	[RDT_RESOURCE_PERF_PKG] =
+	{
+		.r_resctrl = {
+			.name			= "PERF_PKG",
+			.mon_scope		= RESCTRL_PACKAGE,
+			.mon_domains		= mon_domain_init(RDT_RESOURCE_PERF_PKG),
+		},
+	},
 };
 
 u32 resctrl_arch_system_num_rmid_idx(void)
@@ -440,6 +448,8 @@ static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
 		return get_cpu_cacheinfo_id(cpu, scope);
 	case RESCTRL_L3_NODE:
 		return cpu_to_node(cpu);
+	case RESCTRL_PACKAGE:
+		return topology_physical_package_id(cpu);
 	default:
 		break;
 	}
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index b20d104ea0c9..4952ba6b8609 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2395,6 +2395,8 @@ static unsigned long fflags_from_resource(struct rdt_resource *r)
 	case RDT_RESOURCE_MBA:
 	case RDT_RESOURCE_SMBA:
 		return RFTYPE_RES_MB;
+	case RDT_RESOURCE_PERF_PKG:
+		return RFTYPE_RES_PERF_PKG;
 	}
 
 	return WARN_ON_ONCE(1);
-- 
2.52.0

