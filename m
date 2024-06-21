Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE9F16F0DB
	for <patches@lists.linux.dev>; Fri, 21 Jun 2024 22:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719009552; cv=none; b=kmPK2ch1dCRnI1Nks4FgyTntuVv8FDCmRKCRrjtKA54KIjR+JJZAQxmNHfpFxBhEhQnYVuw9r/8xuG04Somikl+iiGQ8ae0kqi16YHoKLgy1U5MCU0IvnlVMEcw6eUef95mdh3gd7K23eS3sl2ZXJCLkmjtUgaMVbrjIyKMLliU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719009552; c=relaxed/simple;
	bh=SH3mTIpDj2uEXUy+GY0B7A3UVMKQH25ecx2M84QmrdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Un20PBA91Qf2kzJZ4DPXSVdLeJFXnuukmhfm+PZ9E61H0tNwtOUfDqkfXyodvooysMehs0NghXUCPZWW7k4Czm8iOCPdQbS8+FVRfx6UDig+yJeUci28Ec4WJ4z7+F70lA8cwpxHft4d5YOtaM31PoqcjoqBBvN4DEItTW75/aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QrM8DlUI; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QrM8DlUI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719009550; x=1750545550;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SH3mTIpDj2uEXUy+GY0B7A3UVMKQH25ecx2M84QmrdU=;
  b=QrM8DlUIPXe/JNs1PF3TQfawkCxiicWjgazhxmXiL/0m1SEW6AR46PSM
   KNGmVcziL61yFLDIHE9JbdxOU2LNZrjmK4HaZ6eAOgmBgA9iZIaLNLfni
   bpDy44LE4S8nprUMv2LBvJFuEMNt4JRk6hNdlFybAy6WK/L41ULyutkPv
   SWrbxrv75kPy+C15SmhTHTDKsNSZnu0pAw52R2UEaeEky26l7mVD1VoOa
   F8zq5ZCWX1okJ+HXBXOxHXccwW1lV2fGufC4+ZAshqLOFWNMQ/DKrFF4q
   gq1rBOumEcb0DaGaqWDZY+to7fGijcVIGJoDadz5jbxDegYXcvsOiaPVW
   A==;
X-CSE-ConnectionGUID: S+ENZqbuSUyJUhcjS989tw==
X-CSE-MsgGUID: zUTNUhztS7aON1u7lcWgzA==
X-IronPort-AV: E=McAfee;i="6700,10204,11110"; a="26691285"
X-IronPort-AV: E=Sophos;i="6.08,256,1712646000"; 
   d="scan'208";a="26691285"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 15:39:07 -0700
X-CSE-ConnectionGUID: MMG+Pmc3R7GPU7RjBYBL1A==
X-CSE-MsgGUID: 4gqPE+SxTqqV35Fm2BqZLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,256,1712646000"; 
   d="scan'208";a="73935651"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 15:39:07 -0700
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
Subject: [PATCH v21 05/18] x86/resctrl: Add node-scope to the options for feature scope
Date: Fri, 21 Jun 2024 15:38:46 -0700
Message-ID: <20240621223859.43471-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240621223859.43471-1-tony.luck@intel.com>
References: <20240621223859.43471-1-tony.luck@intel.com>
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

