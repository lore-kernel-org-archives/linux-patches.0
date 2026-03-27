Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A011946BC
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 23:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774652561; cv=none; b=i4ym+fN8YbKGvFHL9bCKnIzD9EPmS65hRBYRpVUfO+Etp9BRJhe2JJnghgLSBsh7rd4teglohzkzq/85m5UL+dEIytVQQuIO6yxxHepJbEA1wBIkMUEZSoFSfSYJuymqX5WLS8snGJkxwb4dppKcMvgNGgTUsIg4Mn7P0XFDrto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774652561; c=relaxed/simple;
	bh=KTQ7nWd1dcRsTPRSBjMHRoadJTcdC/b2xOMoAR1aVUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXB1Lu7dKpEL3FJJUkz7aKrhe6w0+M/NPt0pv9bK/LJtk7WfJ+PHVlZMtsIRqvnQkP/5+vwIsfZC4USAbCozgQWv0vaOkzGvzXJQ2Z4LQRgl5RX7Z03TB38TC2vyXagl9dVzZG8MtEKlv3xEV/PCPvG+qgvZasef+ppMMcfrG04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L2n2AGXh; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L2n2AGXh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774652560; x=1806188560;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KTQ7nWd1dcRsTPRSBjMHRoadJTcdC/b2xOMoAR1aVUM=;
  b=L2n2AGXh5mAAbwKLq0skSPK88bYTyma0O4OREG9apeJsT0QiOvVAilPc
   91cG2en6lpGiv7d8I24Pw2R2BhO9mfkHcLE0++7ua6qGBIfHyl7WAEmQo
   h/XGgiYpmpWkjVH/kX2ajg1CpTklJyJl9C8eFYGEWFdkZ6SlPvR5ACYfB
   5oOoi3UczlIK7PP+wh6FGk7Vv0aEoVqXBty+N6uwh7RvzBgLQf3tNLetl
   3jCa9DCTJ1f3Aw0H+RyDHyPIofnMLzl0a68Qq64RPKzzB7k/mrxpJLPrV
   wiiWnErT9ZTNzC8OIoaqfVxQ+RkU8nfVo5ShnMnBuCtlZnsi45/bB2Ara
   w==;
X-CSE-ConnectionGUID: S7I0q5vESC2WPrpVlKNuag==
X-CSE-MsgGUID: OKGvm8WKSDyvDcnzwuCEUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="75613255"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="75613255"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:02:38 -0700
X-CSE-ConnectionGUID: gSMI/5azTlGY/0f3B8UcnA==
X-CSE-MsgGUID: WeJlQg5iQl2ElUkhH/ZwMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="218816021"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.83])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:02:14 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 0/7] Allow AET to use PMT/TPMI as loadable modules
Date: Fri, 27 Mar 2026 16:02:01 -0700
Message-ID: <20260327230208.18094-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323163452.25044-1-tony.luck@intel.com>
References: <20260323163452.25044-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The resctrl subsystem is always built into the base kernel. Currently,
enumerating Application Event Tracing (AET) features requires functions
from INTEL_PMT_TELEMETRY and INTEL_TPMI. Because resctrl makes direct calls
to these functions, it enforces a strict dependency requiring both PMT and
TPMI to be built-in.

This is overly restrictive. Use the symbol_get() mechanism to allow resctrl
to resolve these symbols at runtime, whether they reside in the base kernel
or in loadable modules.

Update the exports for intel_pmt_get_regions_by_feature() and
intel_pmt_put_feature_group() to be accessible via symbol_get(). Replace
the direct calls with indirect calls using function pointers.

Add extra hooks from filesystem to architecture code so that every
mount/unmount can be tracked. AET now does a complete cleanup on
unmount and a full enumeration on each mount.

Finally, adjust the Kconfig dependencies to allow X86_CPU_RESCTRL_INTEL_AET
to be enabled even when INTEL_PMT_TELEMETRY and INTEL_TPMI are configured
as modules.

Signed-off-by: Tony Luck <tony.luck@intel.com>
AI-review-of-v2: https://sashiko.dev/#/patchset/20260325171738.12207-1-tony.luck%40intel.com

---
Changes since version 2:
Link: https://lore.kernel.org/all/20260325171738.12207-1-tony.luck@intel.com/

Refactor so that AET can completely cleanup on unmount. This fixes the
existing minor problem, that the pmt_feature_group structures allocated
by INTEL_PMT are never freed. But it solves the bigger issue introduced
in v2 of this patch that the hold on the INTEL_PMT module is never
released.

Tony Luck (7):
  x86/resctrl: Drop setting of event_group::force_off when insufficient
    RMIDs
  fs/resctrl: Add interface to disable a monitor event
  fs,x86/resctrl: Add architecture hooks for every mount/unmount
  platform/x86/intel/pmt: Export PMT enumeration functions as GPL
  x86/resctrl: Allow AET to use PMT/TPMI as loadable modules
  x86/resctrl: Delete intel_aet_exit()
  x86/resctrl: Downgrade dependency of AET on INTEL_PMT

 include/linux/resctrl.h                    |  12 ++-
 arch/x86/kernel/cpu/resctrl/internal.h     |  10 +-
 arch/x86/kernel/cpu/resctrl/core.c         |  16 +++-
 arch/x86/kernel/cpu/resctrl/intel_aet.c    | 106 ++++++++++++++++++---
 drivers/platform/x86/intel/pmt/telemetry.c |   4 +-
 fs/resctrl/monitor.c                       |  12 +++
 fs/resctrl/rdtgroup.c                      |  20 +++-
 arch/x86/Kconfig                           |   2 +-
 8 files changed, 155 insertions(+), 27 deletions(-)


base-commit: c369299895a591d96745d6492d4888259b004a9e
-- 
2.53.0

