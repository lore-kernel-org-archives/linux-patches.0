Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDF42417F2
	for <patches@lists.linux.dev>; Mon,  3 Mar 2025 23:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741044899; cv=none; b=rUGW56/TQ906BgYvH3QAhEI5qh3q3ggBSD+qFBsLqCixdX1HvdWd071mV6xBP80OLcVsobYW42DRlxtejhoHGHXfxFVC9dMcLGr5xZgNvffReKstxyi57yCGrXxB2jVg9qkt2xkuIxrCzmxhCX1n3aI7Tsnt010M3Xebp/2yJa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741044899; c=relaxed/simple;
	bh=Zsqynul38j95zpfxq5ZpDkQrG4cFn76n8qt4QnxnJ/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUalrqvtWRYp+JVFssREs7m+VdFI4EWiU06LQkoUP22hIoVSwdjhJloOOPMFDqnKOl7vgsOilfrdtTYAPhFa0gPDTSimMII4nrqaJ9P7ZQbQbBNM4lqS0c6yilkT1E1WvsyI/zFaRVLYvyefkZK9ol0hBwyNogzNJZpRC7MmTXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kVwVKtQu; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kVwVKtQu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741044898; x=1772580898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zsqynul38j95zpfxq5ZpDkQrG4cFn76n8qt4QnxnJ/Y=;
  b=kVwVKtQuvjyevcWi9f8XqLRmA2BuFr7K68NRliG3aVlAtDdYG+CYzPT0
   V8ypaERYEiNCEuA3BJyjOGuYrCzqwUERJUyoZOc+UKSHdrH35UCXwEDsd
   EcvgValkss1yYeBbR7YJcAYFYSnhAFrzTpcoZX9kw1iRXXKZbHFkKBByf
   3VoBWvXjKdNf9h9ZDOav+c46v2KiOPlnKDWxkMnTRA0pOdwPJU0XG1QH7
   BRQs+8LAUzAramoPYntgDZ30IQP6ioW6xfIisH0p2FGM7NE4Nk1lOPhBK
   QLFOkPVaU7knOXixyYhEBkG4KLzZCPhj0TbD4w+Vk0EfBOY4c3NGlzTAT
   A==;
X-CSE-ConnectionGUID: AZpaNm9iSSOIgIWsDzz8Og==
X-CSE-MsgGUID: Q3DS/Kk4QsCC8qKSEgfwjQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41836003"
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="41836003"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:34:48 -0800
X-CSE-ConnectionGUID: 7MfLMAbPQoiSF1iE4oV/iQ==
X-CSE-MsgGUID: iCMw5Tc3TNKea+8EvPa4+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="117982310"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:33:53 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 16/17] x86/resctrl: Enable package event monitoring
Date: Mon,  3 Mar 2025 15:33:36 -0800
Message-ID: <20250303233340.333743-17-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250303233340.333743-1-tony.luck@intel.com>
References: <20250303233340.333743-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All the code to support this is in place. Unconditionally enable
the package resource during early initialization so that domain
lists are built.

Enumeration of the package events happens at first mount, if there
are no package scoped events, then this resource is disabled.

TODO: Cleanup the domains.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_pmt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_pmt.c b/arch/x86/kernel/cpu/resctrl/intel_pmt.c
index e89130387387..52ff5eb79b4e 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_pmt.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_pmt.c
@@ -244,6 +244,8 @@ int rdt_get_intel_pmt_mon_config(void)
 
 	INIT_LIST_HEAD(&r->evt_list);
 
+	r->mon_capable = true;
+
 	return 1;
 }
 
-- 
2.48.1

