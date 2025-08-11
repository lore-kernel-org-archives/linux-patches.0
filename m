Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E40B2E2F0F
	for <patches@lists.linux.dev>; Mon, 11 Aug 2025 18:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936265; cv=none; b=ZMgeSOi1uBIfaTx+nYP36kgYtzF5JTqSjwIBvqQQDDwmPfvECMaG9wG0MrNN21wcXSJXldAdL1RfhAKHyl+T4rCsvWnIBU7wSAPa0XQhaPtrLBblM3tJ2BP4hbAnB7NSJnUxbQ5Loqt4Tlr403bRt6gpKsgkiIhZZAQD0/2E8x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936265; c=relaxed/simple;
	bh=H/CL40qmwKzhEkdxKODAv/wPY/R63z2nHv7mHfvz3BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqrX+T69rpVSP5ufNb/8gRE4YvYxdUoJt1UcqXb0NIloMezMY4si53zQLJ/dQxXISmZ6EW9Vtdds7fpaiojggKVH+W+joXbJ5Q9uwF6YdWFW0aylunku0VmD2nJQ4Qlr9GLoOWUtADS3qDt0b+M0dn4HaGXPJTZnIQFqeyDaglY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LZWW7sQu; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LZWW7sQu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754936264; x=1786472264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H/CL40qmwKzhEkdxKODAv/wPY/R63z2nHv7mHfvz3BE=;
  b=LZWW7sQu9kq0fM9bg/fGgPYdHjSPMrfoYZP7ydHYUZmZuQidwjYOYNde
   VCK++PRd+hHVkf4vMfvXMVah04pAxb11P/BWfNv0oxwXAFIi3rvVp9pCi
   B8rDPfGaetUf1Obsfbw36bM3+7WLholQpMVweMKF7YnrWws2K/Z5Gqye2
   +ChGpW16bHyaJu3nUsr314wKaZIKFBASaKwC0AAucJyXfGv2GnLo0EdwV
   Fl8I4qQCF50yGTZUlX54ZkVwzFSnzkkbSDf9uBq97VzisD55qVUB87dLS
   Pc2NLxZ/isGi39UB5bHjryIbKDeNQpo1Z/MCQP5kL0GCw/PQuGe2nKBny
   A==;
X-CSE-ConnectionGUID: DqBc52e5QU2dOEejwA52yw==
X-CSE-MsgGUID: JLCfYGwAQ6i1kE3y+ZAQpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="68277420"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68277420"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:27 -0700
X-CSE-ConnectionGUID: KeR5gTGyTWGvigyQw77MXQ==
X-CSE-MsgGUID: Ru68FjGoRr2iKKgRIeOpbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="196825665"
Received: from puneetse-mobl.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.229])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:17:24 -0700
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
Subject: [PATCH v8 16/32] x86,fs/resctrl: Add and initialize rdt_resource for package scope monitor
Date: Mon, 11 Aug 2025 11:16:50 -0700
Message-ID: <20250811181709.6241-17-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811181709.6241-1-tony.luck@intel.com>
References: <20250811181709.6241-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new PERF_PKG resource and introduce package level scope for
monitoring telemetry events so that CPU hotplug notifiers can build domains
at the package granularity.

Use the physical package ID available via topology_physical_package_id()
to identify the monitoring domains with package level scope. This enables
user space to use:
 /sys/devices/system/cpu/cpuX/topology/physical_package_id
to identify the monitoring domain a CPU is associated with.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            |  2 ++
 fs/resctrl/internal.h              |  2 ++
 arch/x86/kernel/cpu/resctrl/core.c | 10 ++++++++++
 fs/resctrl/rdtgroup.c              |  2 ++
 4 files changed, 16 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 19409227ccd0..61c73772a177 100644
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
index 00cd93661650..b16e2fc42b3f 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -240,6 +240,8 @@ struct rdtgroup {
 
 #define RFTYPE_DEBUG			BIT(10)
 
+#define RFTYPE_RES_PERF_PKG		BIT(11)
+
 #define RFTYPE_CTRL_INFO		(RFTYPE_INFO | RFTYPE_CTRL)
 
 #define RFTYPE_MON_INFO			(RFTYPE_INFO | RFTYPE_MON)
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 480e381d416e..ec29b7f250ab 100644
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
index 31f9425783ef..26928ad0a35a 100644
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
2.50.1

