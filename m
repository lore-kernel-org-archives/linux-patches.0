Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579BB37107E
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 19:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780343814; cv=none; b=vBIN4UKZaD/oHlQNNDE6iQ4T7JfJjJE8jUf5HneUhk5T/cTkc73lacXsiBqmZ4stLBJ56aFAETg64VCusUX0bF5ge6NZhtBhzFKEsdiQ3kIebhys36I5d/PLdJPJrYOwpUm8HpA1oNVZ6dX6SATGDeEXY8uH5sBaIj6YJD/KncI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780343814; c=relaxed/simple;
	bh=2yRBZq0wNgcv23WH3tFU/B6WYYBVM9uDMjWdCDryFvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmUuiX8GP+ISkOWS/mdJb6dFCy/CDy19rcJ/xBuk+MuFd1FMhKTXtZBm1JfdkzudQ21W4U+fRJdgyI0B5LGpTX/GgTtzGbaOu+lLQAvS/oC7f+zBf/HwsmoPTj8dwZuipMenNPHTjtfU9oX2sAKVXcbmAcDkTxTeIHMhAhuxdEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dY7i5mAv; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dY7i5mAv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780343804; x=1811879804;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2yRBZq0wNgcv23WH3tFU/B6WYYBVM9uDMjWdCDryFvM=;
  b=dY7i5mAvccK4oo1MCFDOuQA5i92uTc0F/QiBAC8KGEF9JSNZPJmKJgNZ
   cdX4D9Dvj1JkicSVNIUUz/h/0uRZaIfqZxd+pFXoCcp0XYaabtXJ6JL6+
   rMIURXpCb5ZHyknyk/wgv07qXqkpkWJ+kqV2JVMFEX300P4qVESqZwgtT
   /Wsb0m++zdxbRWPd7Lm7pV0dRjnFG6jiASX1wgahUctb6y4XlBuIEvR83
   yK8Xkl7rWpjoQedOSFM+HO9lQEQPONZHw2aUV8UHZ9rIb5Fb3B27oeFJ6
   DF8Z1vDzH9YAPIe8tEWv4EgSJxtZuCnPJnD2smaJk0X9EmQ7nAwaOEJgp
   Q==;
X-CSE-ConnectionGUID: eF9ENINFQNKlBOiu4POAGw==
X-CSE-MsgGUID: DC9/rvluR7yVaHISJIgz9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="81011596"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="81011596"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:42 -0700
X-CSE-ConnectionGUID: HvpD4iFwSDqR6yT5lC/1DA==
X-CSE-MsgGUID: nyzngwtaRdeLzvPMBaZmng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="247946503"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.168])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 12:56:41 -0700
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
Subject: [PATCH v7 05/14] x86/resctrl: Stop setting event_group::force_off on RMID shortage
Date: Mon,  1 Jun 2026 12:56:23 -0700
Message-ID: <20260601195632.15876-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601195632.15876-1-tony.luck@intel.com>
References: <20260601195632.15876-1-tony.luck@intel.com>
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
2.54.0

