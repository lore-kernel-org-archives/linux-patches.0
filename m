Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFFC40DFB0
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 23:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774652560; cv=none; b=LgQ1yYulqyuDsVvySMVExPLp4eumNE1pVP3czJ1qEW3bzLAwqN/c+dX0K5PXUyUw0jOFv3YvgGPNbyYOVlxK7ho9AjffLAJTOsyLu2bsmk+ttcKwF64xAg1BMDRUROAt2tE+YioVP8JUJgG6ITEaSQHNA6XxKkBz8OEOk3arHKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774652560; c=relaxed/simple;
	bh=8zNQaI5+5hl82nEhqMvTbAX163F7y9T3+XZ35TcbybM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c91SqmeVpssgSfeHEUxJfGc3heXrtq+74UOUtXJseZANTvCTzuibcjq9TzCkeVIXKDxo5ID5ooipuotU0vAkfmIasHMjwJadXHYElBi2dLoxHd3l3kYrPpTEkN2QUlLKIpbIVWUOy3POsekf9KsVIhS15yskRCpjGzgC6ZGzgXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nmi2f77d; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nmi2f77d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774652559; x=1806188559;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8zNQaI5+5hl82nEhqMvTbAX163F7y9T3+XZ35TcbybM=;
  b=Nmi2f77dOOfca7Q8cUmQmbuHHyQM6dqCZ6oW3hPR6x2PyLUYbLrwJZHi
   5wq0mM8JF0U05Y0X31qcDtnEDJFYIAPrT4cvsbb1mKayqNL9VJSQ0t4sg
   Gm1Tyj6MdaMb3wGBnA64td7drG23CLTg4xZ7p3hl9D4TMvAOxic6WRRsM
   Iq8UXnvzxcsXUjtsEDmuL14d1DDXpqJAgjUfUn8JB5KcbvBIrRGhyWjrR
   jbasmoAlZUmvHWCny4U3kkcLxzoJ2pM3uAaQ2LcRmnRAiVVX8CYTEEVxg
   r3eeOgP8HxhAglAzf2zASXMb/yBBxI77oNgGM3l2rt+TWpd4f8ryp3Hw3
   g==;
X-CSE-ConnectionGUID: G09jggbKQJq2FY9vmsepzg==
X-CSE-MsgGUID: 554NSBsBSvG5X6aE8jD5Hg==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="75613248"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="75613248"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:02:38 -0700
X-CSE-ConnectionGUID: 0rknclz9TjWW7WWKNCQqfg==
X-CSE-MsgGUID: pErcDJFBRgaZT9utZpKCfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="218816023"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.83])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:02:15 -0700
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
Subject: [PATCH v3 1/7] x86/resctrl: Drop setting of event_group::force_off when insufficient RMIDs
Date: Fri, 27 Mar 2026 16:02:02 -0700
Message-ID: <20260327230208.18094-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327230208.18094-1-tony.luck@intel.com>
References: <20260323163452.25044-1-tony.luck@intel.com>
 <20260327230208.18094-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Setting the force_off flag does not matter when AET features are only
enumerated once (on first mount).

In preparation for enumeration on every mount, drop this because it
overrides user request with rdt= boot option to force enable a feature.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 89b8b619d5d5..015627401ed2 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -214,10 +214,8 @@ static bool all_regions_have_sufficient_rmid(struct event_group *e, struct pmt_f
 		if (!p->regions[i].addr)
 			continue;
 		tr = &p->regions[i];
-		if (tr->num_rmids < e->num_rmid) {
-			e->force_off = true;
+		if (tr->num_rmids < e->num_rmid)
 			return false;
-		}
 	}
 
 	return true;
-- 
2.53.0

