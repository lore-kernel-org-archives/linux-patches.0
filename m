Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AD33A1D10
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 21:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774907013; cv=none; b=ojxAkmGwOMCNcWAAMaDrud1Klo8hN/u+hoTCLAYfF23x3w4EVoBib9ViV6LOQgTVL6mvQXyMcE99vfcvMCOLrB3wtU/Pq4xpD/F2Y1tX+7TYiM1McHauEGLQ6uGipgyYpwq4Asx/lpLzS/rZsRr1RkWtNn5n2ydlhbVWbwsopiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774907013; c=relaxed/simple;
	bh=xvwMYcVdCqzLdQ4ED+pIfDk1uzwQGWdHDFFqCqDUAy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OeTzthO9wzyZC/k2EWhDVdXgXXFtWxfXGcBEiQIBSzazviTkWd/+aYRCq57gtolsGauIoPLz/1J7GgkrAzd+1rP2ruJAJ8jXb5AYMW7hY9amppls4eiSS13IwjX9oU3teWUps6yN5Q/Rkw5anujFKr35MJ4vCmJoFUiivlHYYIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e1eVaVfo; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e1eVaVfo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774907012; x=1806443012;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xvwMYcVdCqzLdQ4ED+pIfDk1uzwQGWdHDFFqCqDUAy8=;
  b=e1eVaVfogF6jgy/NQnWQynb2B5WxzXJDDNyWf2BVgQTjJkXT1cLLTTW+
   8B5PZBcPOZ2263/MQiWS2ftHELSWo275goen0rXcKVFQvOQP8F+h4IF93
   gP24DXQcfXR+8pw8xJxDfYb6JXyh5Fv1OwwGgnoN9ufVUNA7AVO7WKEUM
   ItpRLY+8CPSNbm9kK+8jBbHM/yflCrIqI7q1x4/3P0wgGO6vcQwMTGxxH
   /5v35lKsoc1FqGhpaQ9g/fMlfBtBixZSMR1i1xXnR86BbJR+oqj4eEdeS
   /roc5emY3BZNKAJVDtWuIJ4lyZZfTebDwAMIeuL1I1Ht3iu+VGc8xciFv
   w==;
X-CSE-ConnectionGUID: Ftgfflg9S3K5DUU/JUnXoA==
X-CSE-MsgGUID: Lwtj2YhFRImxt17Oy9zBmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="79772127"
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="79772127"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:43:32 -0700
X-CSE-ConnectionGUID: 8O1VqrF0QjOgNmSBEYXiGw==
X-CSE-MsgGUID: TNr/jLuLRWKJP6uv69mWUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="225185934"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.186])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:43:31 -0700
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
Subject: [PATCH v4 1/7] platform/x86/intel/pmt: Export PMT enumeration functions as GPL
Date: Mon, 30 Mar 2026 14:43:16 -0700
Message-ID: <20260330214322.96686-2-tony.luck@intel.com>
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

The symbol_get() function requires that objects be GPL licensed.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/pmt/telemetry.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
index a52803bfe124..4504fb9fd83c 100644
--- a/drivers/platform/x86/intel/pmt/telemetry.c
+++ b/drivers/platform/x86/intel/pmt/telemetry.c
@@ -287,13 +287,13 @@ struct pmt_feature_group *intel_pmt_get_regions_by_feature(enum pmt_feature_id i
 
 	return no_free_ptr(feature_group);
 }
-EXPORT_SYMBOL(intel_pmt_get_regions_by_feature);
+EXPORT_SYMBOL_GPL(intel_pmt_get_regions_by_feature);
 
 void intel_pmt_put_feature_group(struct pmt_feature_group *feature_group)
 {
 	kref_put(&feature_group->kref, pmt_feature_group_release);
 }
-EXPORT_SYMBOL(intel_pmt_put_feature_group);
+EXPORT_SYMBOL_GPL(intel_pmt_put_feature_group);
 
 int pmt_telem_read(struct telem_endpoint *ep, u32 id, u64 *data, u32 count)
 {
-- 
2.53.0

