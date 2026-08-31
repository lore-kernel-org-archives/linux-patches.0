Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1209D2DB791
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 17:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198292; cv=none; b=g5cdP5Hsw04zD2XQUJPUuDv0XxMbrWBzLXc1ad4MXZyU8XL0qQjGYrsAtmWKfNqiC6GHYVWzaufj/0GsoFkfHWy8tbsZzBwuZ4rjO42zUG+uAx/irIxU8OBpQw39YW6zmMXjPXZZ10+AsyGAYfI0zXbairkhCt0+DUbeQuAOpn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198292; c=relaxed/simple;
	bh=/jTi+tnt1ej+QcuyLCn8l49rg9sBgx4D2+lUqrqwpHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODbOqtOZPP/GdFm2GxK3xcA9jI6pY812cmdzW3QFSoqfnX8gDateTb7eSA7u/AA+4Ehe90omGxtOctAmKAtzRbIOVgzBCcYWiPYjGI3RxGSTK6qhgjotRQWpDGS1D7LKifhdRHs9loyPCefCNACZXdQ4kL+I7mNNbMvumvFMGls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e7TCYsyz; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e7TCYsyz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788198290; x=1819734290;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/jTi+tnt1ej+QcuyLCn8l49rg9sBgx4D2+lUqrqwpHM=;
  b=e7TCYsyzpgxNxsz0dwLGvOMY/DhjLCNOS940ggFIv/4EdJQywvL7aQAZ
   5P4MVyVEGmxUSFrTPKQtjf2hS3x+uziGXaZQdJJkl5zjy+fLv43PqqYTF
   3J+H1v2aYV1QGO++6n88OGHEFZLW3PbQ3fwPjfckQzE8xuUo0ULgVd0SS
   3MAEHKII30JGTIjc29ljzo720MQWHxbCLG99fJufL2R162c9g6QtzF2U6
   bStz1NrS8l7A5OcTgKO3g30T4tdimW+ITmv2WGIUxYcbrOtFzwEYPryq7
   WfhQuTOcnvc2hznLjqWZyN9Q/HaxzS8OAg8CVbswS74HbJ3n8eoQU0SDU
   Q==;
X-CSE-ConnectionGUID: NRlf4e8cR+KUm1Bckpugwg==
X-CSE-MsgGUID: Isuosn6kTTStI9S7UO3sMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="92480111"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="92480111"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:43 -0700
X-CSE-ConnectionGUID: cWyN4GQqSViS4oAqvP8PGQ==
X-CSE-MsgGUID: ZXRNy8tbQuigHjJ7mOWxVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="268907027"
Received: from aherrold-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.17])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 10:44:42 -0700
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
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v11 21/23] x86/resctrl: Require 64-bit x86 for resctrl support
Date: Mon, 31 Aug 2026 10:44:19 -0700
Message-ID: <20260831174421.13921-22-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831174421.13921-1-tony.luck@intel.com>
References: <20260831174421.13921-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Intel Application Energy Telemetry (AET) provides event counts in 64-bit
registers in MMIO space. For accurate results these should be read with a
single 64-bit load operation from the CPU.

In preparation for the removal of the separate CONFIG_X86_CPU_RESCTRL_INTEL_AET
configuration option, move the X86_64 dependency to X86_CPU_RESCTRL.

This in inline with Dave Hansen's proposal[1] for an addition to Linux
documentation that details the state of 32-bit x86 support.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/all/c6ab0c24-8931-4f0d-9be6-23498ab4c38b@intel.com/ [1]
---
v11:
Provide more accurate justification on why 32-bit support is not useful
for resctrl.

 arch/x86/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 15fd9ec5ecac..06b5d0c4633e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -518,7 +518,7 @@ config X86_MPPARSE
 
 config X86_CPU_RESCTRL
 	bool "x86 CPU resource control support"
-	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
+	depends on X86_64 && (CPU_SUP_INTEL || CPU_SUP_AMD)
 	depends on MISC_FILESYSTEMS
 	select ARCH_HAS_CPU_RESCTRL
 	select RESCTRL_FS
@@ -541,7 +541,7 @@ config X86_CPU_RESCTRL
 
 config X86_CPU_RESCTRL_INTEL_AET
 	bool "Intel Application Energy Telemetry"
-	depends on X86_64 && X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
+	depends on X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
 	help
 	  Enable per-RMID telemetry events in resctrl.
 
-- 
2.55.0

