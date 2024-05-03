Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E097828DD0
	for <patches@lists.linux.dev>; Fri,  3 May 2024 20:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714768420; cv=none; b=O4uaSjWYqJJsk6S1BjyTjIHZs395JYRH2K9WRk/4Zn+oEH7AjQ8DfAUJ7m5Cga4edum9ICHPV9pw9wHmYH3DN05QeGdHKtK+HfUHIz9OooVHO9vHLMX/ocje4mAR0rqsV7f5Eo40q97lASzWzWfHVs3r8Ls9GCLfGjXDP5PjWL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714768420; c=relaxed/simple;
	bh=L/DVqE53VmBOp8H/5zpv2eGbQKaWYwGvHxBLFSq2aW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2WmLP9k23GgSXDv3D/VK6D5Qv+IzV8sKJFoAsYHlz5aI5KjQpYZbNWOOpZSHaCXdFcrCKOg7/TIyw0oyHg5BgAVLqwh/5skZUP9KmYnft2ECVAGD8NG75ocJbPEimgkfz/CnVed7Lzwyyc2kAwsuWqy487y2phLcfCBmDev/bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HalZOfZu; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HalZOfZu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714768419; x=1746304419;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L/DVqE53VmBOp8H/5zpv2eGbQKaWYwGvHxBLFSq2aW8=;
  b=HalZOfZu1CUSvGy5J8OaBF7Nl31dJuoX+KAugsR2HihVgLCKnTPExKty
   FEGCFK+umoVsB8EP3Tune1C0DO2efnn1MBEulsPaGuxyxBf6K8ET5DTG8
   BealQJnTFR7Ggmzdlv89fNIg4jNGbl5Iq0TUyPlPfYx1D8gDMsE6P2PT/
   9xfJYPyD9z8FUP3JjQ6JZ7FDrYwvsfidTL1rHDlOSKfzWQ553IvdktRTl
   2d6TNN1PqYt68/nVwRD2Fk6Z0XnTxzvh/w6fnxju/lHHQ+qvULwr5Npu+
   gSCUOtGaPKXZRF7VpgdhzHiVp/xgYx5bdRX0yqUybV+ixhCpU3Az2kNQ8
   w==;
X-CSE-ConnectionGUID: 8tBziEGIRO+sgbmfrFQXHg==
X-CSE-MsgGUID: Vw7lRHFBSOG4BFWj3pnwhw==
X-IronPort-AV: E=McAfee;i="6600,9927,11063"; a="21274294"
X-IronPort-AV: E=Sophos;i="6.07,251,1708416000"; 
   d="scan'208";a="21274294"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2024 13:33:36 -0700
X-CSE-ConnectionGUID: N+9Grv6GRs2kiKsZnPdf4w==
X-CSE-MsgGUID: S7crYviRSyi/dufDhhxsnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,251,1708416000"; 
   d="scan'208";a="27431818"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2024 13:33:35 -0700
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
Subject: [PATCH v17 5/9] x86/resctrl: Add node-scope to the options for feature scope
Date: Fri,  3 May 2024 13:33:21 -0700
Message-ID: <20240503203325.21512-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240503203325.21512-1-tony.luck@intel.com>
References: <20240503203325.21512-1-tony.luck@intel.com>
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
index aa2c22a8e37b..5c7775343c3e 100644
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

