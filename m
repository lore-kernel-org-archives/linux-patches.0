Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465713A5452
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 21:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774907014; cv=none; b=iN3yAoQHgv8qOc6prcO//zMJ0t2IRG7rFXcJ9ApZ7ZzQN6WW1g+GZ8vZgzDhlVGIqCS8TlppKneDkuMfQfAtug9ne0qeWqRvgg1qZFIAIGz3jRfGeqFdHL/xAtCe15aVEOTZPp85BDX/XNt6ZI0Z+0AJQ9EZFtVJ3gPSH1YUnlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774907014; c=relaxed/simple;
	bh=8zNQaI5+5hl82nEhqMvTbAX163F7y9T3+XZ35TcbybM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Js+ibCf+h97NugvKDpjz/yIKlkOrhTVObjrl1AtLVxcnMLsHyxfeGnyVal5Nk5nChxAA5LrQU8kR3pZyOmRwbtN1B6QQYtss+CvSDmf029ex+z2YdSCG5UGwdGyYw5a/dH9W0D+Kh51MmzX0FvZ/45FYJeKrkeZe8XX8BYNtH8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WZ8tb5cl; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WZ8tb5cl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774907013; x=1806443013;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8zNQaI5+5hl82nEhqMvTbAX163F7y9T3+XZ35TcbybM=;
  b=WZ8tb5clo+E6FckJ2F7q/uxqWzO5fRrK/W33Y3E7oYpZnOzcc/Vq0BOH
   NeOOLfqHj5gL0T4Hx01k3ovXbWyWAuwm4hugJxPubQxPsZ9+mOYcePeZr
   x8mKWsZh5OsIaxaADEMKW3Y1QaG2tm7lmXu3uVeLyLnszPiPPqMgIh6Xo
   ihR9DTokDRHx1zxzTH4tPdE6X46F1H4jWUZd0/H3UxQaI6B6afMQ6S445
   nCm6KasNTAetgaunZRvINGzDtOR1apvqeACLtZBvOv9FJjn2pOGojjUEg
   GGRI4hw1rM06PWeg/LN2lH/BCOJ1cFDgu+IPFi4M9UKLxSvCjnxdRSSVc
   g==;
X-CSE-ConnectionGUID: eqyIHEDCRQOj7DSo0U92xw==
X-CSE-MsgGUID: wRlQ4+lwQiqYP+preSYZUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="79772135"
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="79772135"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:43:32 -0700
X-CSE-ConnectionGUID: VXyE2nADTL2SQCNBpVpb1w==
X-CSE-MsgGUID: VKZHCZpaQD+KPAgEbxIrzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="225185938"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.186])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:43:32 -0700
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
Subject: [PATCH v4 2/7] x86/resctrl: Drop setting of event_group::force_off when insufficient RMIDs
Date: Mon, 30 Mar 2026 14:43:17 -0700
Message-ID: <20260330214322.96686-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330214322.96686-1-tony.luck@intel.com>
References: <20260330214322.96686-1-tony.luck@intel.com>
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

