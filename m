Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611F423908B
	for <patches@lists.linux.dev>; Fri, 11 Jul 2025 23:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278044; cv=none; b=LOMB55CEGSr6Y/aLKIV13bkbTff+klDDJpRsbzeu8AE0v4RRYePAWcKR41eAoFNdG4qQT9+Pbl5gbteGTZAUzD7QXb/Lf1d556atDF5/APf4ZixzTIx00ugYBty/D7wcdxOquIv8FHpIjA9il1GNbKx7TqRN6JkfOp7vRTr7QWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278044; c=relaxed/simple;
	bh=kAOLcoB/MKCZbpUlxZ86Zqqe8+lquFRcUAeLjFIgeJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUCj/uqA8fGhKNcEC6g7UsQs5HLH9Z1VLM6mOcZ+Dcvv67YO+XGI27JOJC7TThwj/UQtW9hIWWy+HtCIOYF0yig9L1aw9J6CYAPVnkMcRM7YNU6gX1AUTuid4mhcwmb6nqu6+r7zt4aq562Uo+o+WxUjU5zehuOjJt5rdA3iCbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z89ivw1M; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z89ivw1M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752278042; x=1783814042;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kAOLcoB/MKCZbpUlxZ86Zqqe8+lquFRcUAeLjFIgeJE=;
  b=Z89ivw1Mp25Um8k1RgvvOBjNpqJaM+ieysGJyQz7Iid9/xTi8FaWuMSe
   S8NSltaWml+70YaV0zabBWWAOt6wgWOBbBTBKiaAjIWC8po+4QUHk0aon
   FpfTxBDwDq5R8xvNnlukmdgZQucAMBkGao3bNRM4VF9DcHBc7snGOvc+H
   63AxLTXMochCtwAEycedn3g+7LccHyxlkTnhKqnUjKQx0JW0QEm1NAzUp
   fUqj9+VYvv/rdcdSXwHcWmNOiqNpWv/Za3LjzgqfmaWf0RTf5/LKCCuYp
   Q5l0jgm3bJrjSX7sYZ/o0OKVcmtKOeVxyV5iMnEiUOjT4LY9zuPJ8y8Ri
   w==;
X-CSE-ConnectionGUID: HXQaX0ViQSy3DJJHAEouXA==
X-CSE-MsgGUID: WWYz9DfNTG2XLb9vDhGa1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54292700"
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="54292700"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:53:59 -0700
X-CSE-ConnectionGUID: BqAT4Fz3TZ6gTWvCZNC9vw==
X-CSE-MsgGUID: uzpZLkQmSfKSpBwCD5Krgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="155902134"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:00 -0700
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
Subject: [PATCH v7 16/31] x86,fs/resctrl: Add and initialize rdt_resource for package scope core monitor
Date: Fri, 11 Jul 2025 16:53:23 -0700
Message-ID: <20250711235341.113933-17-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250711235341.113933-1-tony.luck@intel.com>
References: <20250711235341.113933-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new PERF_PKG resource and introduce package level scope for
monitoring these events so that CPU hotplug notifiers can build domains
at the package granularity.

Use the physical package ID available via topology_physical_package_id()
to identify the monitoring domains with package level scope.

This enables user space to use
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
index d2fc0fcd0226..d89378346044 100644
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
index 263a34f06a5b..b0bacadd9786 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -240,6 +240,8 @@ struct rdtgroup {
 
 #define RFTYPE_DEBUG			BIT(10)
 
+#define RFTYPE_RES_PERF_PKG		BIT(11)
+
 #define RFTYPE_CTRL_INFO		(RFTYPE_INFO | RFTYPE_CTRL)
 
 #define RFTYPE_MON_INFO			(RFTYPE_INFO | RFTYPE_MON)
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 22ff91b666d0..2b2f76c76d73 100644
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
index 627243a1175c..11792e841525 100644
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
2.50.0

