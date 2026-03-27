Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD80387353
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 23:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774652564; cv=none; b=ZuNXfQX9ePVs2owaLHJ+EhsT9SYayIJI8DI+4Ggxg6teKQ63qyDoOudYv1V47enZe8iC20ZmUQxPDPuqv/Gb7PGkdLe+ie1Btp1YciSCJFNxH/ukocDoKJ5huAAdAaOa+nFD73WMD0I9CP5ueJPd0Cn5PXv/boV6XyL9EHEA64M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774652564; c=relaxed/simple;
	bh=xvwMYcVdCqzLdQ4ED+pIfDk1uzwQGWdHDFFqCqDUAy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FY4rLaqHwCy6f4B+edhy9eNoqmuAtajPyN/lWxyXb/y3D9SC0IQH7/JPCRClPeQizlZyNHyYyzyb7D0I1OxIE6acDE8Z61ybNGLDBnqp/k/mmsIBAlD0xUt2w56pSSs3XBG4rr6WPmI95nJB3QreH15h8dAmW9SIbhJeZGEAku4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MgPym2Jo; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MgPym2Jo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774652562; x=1806188562;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xvwMYcVdCqzLdQ4ED+pIfDk1uzwQGWdHDFFqCqDUAy8=;
  b=MgPym2JoGS0dQFbUPVQjHEOcmI0F5uAQCDeqCmqQxiWcJBW3C11IC6sk
   5hB2JZa+tgujBJA+POGpeVqIuUmICODqnif8eETBXTY4tQZUVQTHLOPDp
   rAzZtvYOjZNEN8qjzLc9JPlPuJRyvLGp5CoIr4E4UzGZBml+in+AXt7X7
   77MBS2wFJjiuaOEu0emW//7EXF0Ff2mUq6Y+y1/VxxRm4uYBKSag4mc9d
   iLYva+PisyNlrI2qRfRPPcmyHREgR73dm8ausR+OdYdYAdPKMr9WQ5mjg
   GdgimLRHsDPn2hM5Pf4TNCEcl2e4ECHU1HYPbBdAIXdff/pKyJQ1Emva0
   w==;
X-CSE-ConnectionGUID: bDL17OcbRKmPfEvzHQRlyA==
X-CSE-MsgGUID: JhaYTafnQPmPumIZqwV4SQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="75613284"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="75613284"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:02:39 -0700
X-CSE-ConnectionGUID: +kn42FCPQES1OKkISWfNow==
X-CSE-MsgGUID: UNFlocXDRQGbo6wvWpuWdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="218816029"
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
Subject: [PATCH v3 4/7] platform/x86/intel/pmt: Export PMT enumeration functions as GPL
Date: Fri, 27 Mar 2026 16:02:05 -0700
Message-ID: <20260327230208.18094-5-tony.luck@intel.com>
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

