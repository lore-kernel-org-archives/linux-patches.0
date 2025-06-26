Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C022EF66F
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 16:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750956604; cv=none; b=KgOSxtVHtcfnXaWVeiA4c9TV3apC2xQ3I9lsnatvoFAY3QGtriaHMgmymgoMNNs/CPrxE5NrBf54pi9Vquz9QQh53zna3yFCduX/aUxLeMVVIYbpVLVdOTq/rzWTfVJ+PjDEsrBmIP4pqsoE0DCt9v10VVXlhG3voZAucJm0kUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750956604; c=relaxed/simple;
	bh=ixo7bJsQmnGV+5RozZo8jcxCPZZ7U9d0UgkIM6AZykU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLfGm22D0DHw/RVcwIUOhOdhV65mIfVnT6Lm3Kue1rsRiErdvUcOC+bRSxJQoQ79UFOu4wPcnriOb6bfAASPyxEHQTd1hma8FDxKBQ8rGfPBJwxeZ9XoiOfI7MM49plWhp8cSclHQxvqPktefZFBIwv3MFEydlDo5Q5dMp3l4xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=coLVt+7y; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="coLVt+7y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750956603; x=1782492603;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ixo7bJsQmnGV+5RozZo8jcxCPZZ7U9d0UgkIM6AZykU=;
  b=coLVt+7yvPfD6YHgWaK/gG/+D2XRS3M5AKq9IgxYxWZuSVZRXiD1LLHl
   L/x2SZUxpxYPym7FbXMPBa5Qb4Pi9ixuMVmVFNqq+Wwp73z7ntcEGgmg9
   hdFXtNHlVpZCWKPxZDlXRjroMJlJTPEhqqkV87a8Lyj/YZcTeDwlYZ+E7
   ovhvOgmbzv50o9Ab6gM2elSAbwuRvwn6iXWvRO2SSEev78GyISSgzxy5f
   4i1AMK8D5Uc0pwL1xX67MBRcW7KZ0HaaUvuNALXu/5Nya36vyQGdefIDd
   enYFzEQ12KMN+AWnG3sJRJud7YEqzaZ3zanwCBGF+tzx+c+dJvyfBv7tW
   w==;
X-CSE-ConnectionGUID: GbmFTz6GQnq7nqPUYhr5wA==
X-CSE-MsgGUID: 6xIIO3t8R4mJ5f+wT6KUZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53136446"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53136446"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:49:58 -0700
X-CSE-ConnectionGUID: hmM+XgG0RrC7Lqmu2KtvNQ==
X-CSE-MsgGUID: +lXwONQGRwieTaitsKZ9xA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="153069250"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:49:57 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v6 16/30] x86,fs/resctrl: Add and initialize rdt_resource for package scope core monitor
Date: Thu, 26 Jun 2025 09:49:25 -0700
Message-ID: <20250626164941.106341-17-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250626164941.106341-1-tony.luck@intel.com>
References: <20250626164941.106341-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Counts for each Intel telemetry event are periodically sent to one or
more aggregators on each package where accumulated totals are made
available in MMIO registers.

Add a new resource for monitoring these events so that CPU hotplug
notifiers will build domains at the package granularity.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            |  2 ++
 fs/resctrl/internal.h              |  2 ++
 arch/x86/kernel/cpu/resctrl/core.c | 10 ++++++++++
 fs/resctrl/rdtgroup.c              |  2 ++
 4 files changed, 16 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 23e2874105e3..76c54b81e426 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -53,6 +53,7 @@ enum resctrl_res_level {
 	RDT_RESOURCE_L2,
 	RDT_RESOURCE_MBA,
 	RDT_RESOURCE_SMBA,
+	RDT_RESOURCE_PERF_PKG,
 
 	/* Must be the last */
 	RDT_NUM_RESOURCES,
@@ -252,6 +253,7 @@ enum resctrl_scope {
 	RESCTRL_L2_CACHE = 2,
 	RESCTRL_L3_CACHE = 3,
 	RESCTRL_L3_NODE,
+	RESCTRL_PACKAGE,
 };
 
 /**
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 4dc678af005c..53ced959a27d 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -239,6 +239,8 @@ struct rdtgroup {
 
 #define RFTYPE_DEBUG			BIT(10)
 
+#define RFTYPE_RES_PERF_PKG		BIT(11)
+
 #define RFTYPE_CTRL_INFO		(RFTYPE_INFO | RFTYPE_CTRL)
 
 #define RFTYPE_MON_INFO			(RFTYPE_INFO | RFTYPE_MON)
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 03c481725fdb..a5f01cac2363 100644
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
@@ -433,6 +441,8 @@ static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
 		return get_cpu_cacheinfo_id(cpu, scope);
 	case RESCTRL_L3_NODE:
 		return cpu_to_node(cpu);
+	case RESCTRL_PACKAGE:
+		return topology_physical_package_id(cpu);
 	default:
 		break;
 	}
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 9dac8017a2f8..d9bb01edd582 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2195,6 +2195,8 @@ static unsigned long fflags_from_resource(struct rdt_resource *r)
 	case RDT_RESOURCE_MBA:
 	case RDT_RESOURCE_SMBA:
 		return RFTYPE_RES_MB;
+	case RDT_RESOURCE_PERF_PKG:
+		return RFTYPE_RES_PERF_PKG;
 	}
 
 	return WARN_ON_ONCE(1);
-- 
2.49.0

