Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23411509A2
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 18:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718044548; cv=none; b=jk9v9MzHfdw3MrDvF64H6Cp1V8JfyQDQC/n5xSE/PC5GM6DyZ90Nh40bbrydZlspALnC2gnDKWxKr2IP8+0JL4fjOX55XKiJ4WvZuwxCxF9aF1gRHItJWTGbzEC7dOiuOKB7+hTbr1FYziAyMD1fvMUmj/O+PF170to7qHbo2w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718044548; c=relaxed/simple;
	bh=n/UgyX1U4zOUKAVlm2WMJOCOaWfvqKc/RRK5WzMIgI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grUXDmfZEBGv5dO3OCpBpbWVrD9weuddQsiTWUFDeQ0dKDJlPegF0WpKeoWLHUXVpW7of/iuWvJ7R6QDyv+YKHFwtiUowH9WmSrz8dW5C/CQwrmBUhCIryuQaItilH7mpG6emyiDPiP3H7l+qHvc9swGOG53LC+ckgals2GhoNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZZ73w5vK; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZZ73w5vK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718044547; x=1749580547;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n/UgyX1U4zOUKAVlm2WMJOCOaWfvqKc/RRK5WzMIgI0=;
  b=ZZ73w5vKTBxTFqbISAAEmFZGj8IDAmi/HOReYIFRlku5dvpmfqZzhDI0
   nNQsLHQGNjxaZp8I2dmteIqjNTanCNzSJWID4Dw1FvBxV3gBhY7aLquqL
   ULOtE/QpUNSi2x0hKOIjRuIIlgnCyQT+SeO7zKPMiLY07B8Qj4LUgNhQ9
   heLDyWTq39DSjl9nc9heydcxmETuZJ2AUrNLgMuSUOAO9WRR2hKtjVsgO
   HRl4seR1LnBSzqyIz86EMi47xfO2pVbjpKADb/F6VmB7ZRZqfNFLljbuV
   S2Ms1x+Mkuz6y2IKjrGO2zXYre8sNPK9yjHyjvWK0h8OjULKNU2h65zDO
   g==;
X-CSE-ConnectionGUID: N6x7GWDkTcWUf7RRY/DVbQ==
X-CSE-MsgGUID: K1hp7BWXT9WDxdHRlEEuwg==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="12004831"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="12004831"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:35:38 -0700
X-CSE-ConnectionGUID: zStku52nQu6uU60eIgGNUQ==
X-CSE-MsgGUID: ZrrWjfSVTKmHoaoioOdLrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="43576575"
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
Subject: [PATCH v20 09/18] x86/resctrl: Add a new field to struct rmid_read for summation of domains
Date: Mon, 10 Jun 2024 11:35:19 -0700
Message-ID: <20240610183528.349198-10-tony.luck@intel.com>
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

When a user reads a monitor file rdtgroup_mondata_show() calls
mon_event_read() to package up all the required details into an rmid_read
structure which is passed across the smp_call*() infrastructure to code
that will read data from hardware and return the value (or error status)
in the rmid_read structure.

Sub-NUMA Cluster (SNC) mode adds files with new semantics. These require
the smp_call-ed code to sum event data from all domains that share an
L3 cache.

Add a pointer to the L3 "cacheinfo" structure to struct rmid_read
for the data collection routines to use to pick the domains to be
summed.

Reinette suggested that the rmid_read structure has become complex
enough to warrant documentation of each of its fields. Add the kerneldoc
documentation for struct rmid_read.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 99f601d05f3b..d29c7b58c151 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -145,12 +145,25 @@ union mon_data_bits {
 	} u;
 };
 
+/**
+ * struct rmid_read - Data passed across smp_call*() to read event count
+ * @rgrp:	Resctrl group
+ * @r:		Resource
+ * @d:		Domain. If NULL then sum all domains in @r sharing L3 @ci.id
+ * @evtid:	Which monitor event to read
+ * @first:	Initializes MBM counter when true
+ * @ci:		Cacheinfo for L3. Used when summing domains
+ * @err:	Return error indication
+ * @val:	Return value of event counter
+ * @arch_mon_ctx: Hardware monitor allocated for this read request (MPAM only)
+ */
 struct rmid_read {
 	struct rdtgroup		*rgrp;
 	struct rdt_resource	*r;
 	struct rdt_mon_domain	*d;
 	enum resctrl_event_id	evtid;
 	bool			first;
+	struct cacheinfo	*ci;
 	int			err;
 	u64			val;
 	void			*arch_mon_ctx;
-- 
2.45.0

