Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3040E421A12
	for <patches@lists.linux.dev>; Wed, 29 Apr 2026 18:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777488552; cv=none; b=VJ289Uhi+zZlnOFj8122nUwVXlznc/ThKrHguDWZeG7uqeEl9BJ88e9Iz7Pbo6OuUK7k3FLk5wymaIuYFSGZFpsnK+t34iKZRLuOQ8KhSsdddIzvuPPGkilqO1qH7oB5jZzhri9XiT+88q6RzjV2IaW/rbKvoxQmsCyGj/Wm9dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777488552; c=relaxed/simple;
	bh=TpqgBuTQel4V5/BGOHX3wAgyHeUcGtOmEJQ2AKSmzOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVvdUxdtoHRtdoxjfu7F3mh3M/B2K98+/0iAOzLHqqI7zrXmmzAtWuDA3U2D1w37cYrKoxs+MZUGUBIGAzRH+a/J+2vVD5D2Qde252uPZlq2Kgird1KEvwWeOWWR78QOCjRKjELjYW53icDR9FmLCOJcrugfpj1dQbcE9tcntPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OUVxjfkU; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OUVxjfkU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777488548; x=1809024548;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TpqgBuTQel4V5/BGOHX3wAgyHeUcGtOmEJQ2AKSmzOg=;
  b=OUVxjfkUDc2lPuyU6ltyK9XkJArvdHFG4MfC8OcB0n6+VXN9rya4WSkt
   bV9W7alFTR0kS71Nu+Hi5ZsLmi0mtBqBFkURE7WD7q36jde1AKJn3n4Pk
   EI9qFOwzNrZRVFiALhs52pb4IhsfK4Rp0qjvUAmw3Zvuw83Eij1yA2+Ic
   y0PlFPCfweenTs4IqXCRd6+YVmyi4/DeFwSHIowFTFdmRzkD0rf9JmZzS
   ymH/P+nF79pYnKgIexYytICivY3rnU8rTSe+6fqaOEiBdZfw7IJoJl+Qx
   Yxy7Q3RGb8nqrDcrMqO6UqO4n9CanpzSzjjDYgR78smbMIVR3pZnqJDPL
   w==;
X-CSE-ConnectionGUID: 0qSWCpdmRcSg0t97Hm8cwg==
X-CSE-MsgGUID: cvCW7Vu+TR+lHQYWYBfJKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="89890679"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="89890679"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:49:05 -0700
X-CSE-ConnectionGUID: YBURRahzS6aVzIiPMXyLSA==
X-CSE-MsgGUID: CNEj4rkASy6J7jcBPE/V0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="238322987"
Received: from mjruhl-desk.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.13])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:49:05 -0700
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
Subject: [PATCH v6 01/10] x86/resctrl: Stop setting event_group::force_off on RMID shortage
Date: Wed, 29 Apr 2026 11:48:49 -0700
Message-ID: <20260429184858.36423-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429184858.36423-1-tony.luck@intel.com>
References: <20260429184858.36423-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop the force_off assignment from all_regions_have_sufficient_rmid().
This preserves current single-enumeration behaviour while preparing for
the upcoming per-mount enumeration, where latching force_off would
incorrectly suppress re-enumeration on subsequent mounts - even when the
user explicitly requested the feature via "rdt={feature}".

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 89b8b619d5d5..e2af700bca04 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -60,8 +60,8 @@ struct pmt_event {
  *			data for all telemetry regions of type @pfname.
  *			Valid if the system supports the event group,
  *			NULL otherwise.
- * @force_off:		True when "rdt" command line or architecture code disables
- *			this event group due to insufficient RMIDs.
+ * @force_off:		True when "rdt" command line disables this event group
+ *			to avoid system limitations due to insufficient RMIDs.
  * @force_on:		True when "rdt" command line overrides disable of this
  *			event group.
  * @guid:		Unique number per XML description file.
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

