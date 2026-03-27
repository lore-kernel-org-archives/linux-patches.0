Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB313195EF
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 05:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774589230; cv=none; b=XrNyPHkIWd244A/ovtTuQitjRUPQdaVZorC9nL0ITMqhqNL6lHPv2awhwAPRnupQSgzVWUcl4DkXMBm+/uEdTGFrkN6QIMmaJYEMiZaAolzMeLw0R8teMim3TrAUKcmfB/BHvGwyusjMzr6dXy2RV/YG8Lhn0TBkVkoTdzyPT5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774589230; c=relaxed/simple;
	bh=pXYLlyR7AvX4cYo/+0W6iPdaXHmlws5szrL2k65F1/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIfs9K5uZtdJgMpx47l+MgIxhyZbvd7NkD70BAYtllunKxlw9uf2Z7OX2V8VLk57eE+054ClBLK/wX6hAYeyYwZiK7gBwnKnr6Nk24Eu6GN8zOAm05Qj38ElYI8zcMOSkxrIN+8fGMoN5ceE0a3jbqIRL5AJOxDt1joll3JpHYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O1X/wMR+; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O1X/wMR+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774589229; x=1806125229;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pXYLlyR7AvX4cYo/+0W6iPdaXHmlws5szrL2k65F1/M=;
  b=O1X/wMR+83n34GWMrh78us02Q0/3ecQqtmlmvQhkrN07Uv3ZpXj5Mn2o
   4nJXkH2wGGtrc3R6FuRv+WCYIoilWiJhJsgtBb3n9PZ2GBn0kM1XJ/hh0
   to3qkXqIvr+rK9z7ywA/45fOh4NtXO43Cwjj0Ak7mZsQNFUGJsuAmHi1+
   jSsQUi6W2h4fKyMLet44vJVxTIuywWp1SGaTQiRuvEIEqBSTKyQGG0mGa
   zRNI/SnE3UYuHwYNFL3FQjTI02qNRFZ7yKm06u8kXLSpEhmHMw1K0k0H9
   7Uz+1M9ziSFVeQP52tJO0n1iZkuxAeTGBZsisENgjvH+xwu2WzaGbrUR1
   g==;
X-CSE-ConnectionGUID: MnZn2iysR+ygwgEP6v3kzg==
X-CSE-MsgGUID: cuc1PC/jSsOTvE5+/q59hw==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="101117955"
X-IronPort-AV: E=Sophos;i="6.23,143,1770624000"; 
   d="scan'208";a="101117955"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 22:27:06 -0700
X-CSE-ConnectionGUID: KQFpEI9qQYatTxCo9jTCRw==
X-CSE-MsgGUID: O4C4NkfoR3+2iA4k41nwUw==
X-ExtLoop1: 1
Received: from dwillia2-desk.jf.intel.com ([10.88.27.145])
  by fmviesa003.fm.intel.com with ESMTP; 26 Mar 2026 22:27:05 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: dave.jiang@intel.com
Cc: patches@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com
Subject: [PATCH 5/9] dax/hmem: Reduce visibility of dax_cxl coordination symbols
Date: Thu, 26 Mar 2026 22:28:17 -0700
Message-ID: <20260327052821.440749-6-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327052821.440749-1-dan.j.williams@intel.com>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No other module or use case should be using dax_hmem_initial_probe or
dax_hmem_flush_work(). Limit their use to dax_hmem, and dax_cxl
respectively.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/hmem/device.c | 2 +-
 drivers/dax/hmem/hmem.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/hmem/device.c b/drivers/dax/hmem/device.c
index 991a4bf7d969..675d56276d78 100644
--- a/drivers/dax/hmem/device.c
+++ b/drivers/dax/hmem/device.c
@@ -9,7 +9,7 @@ static bool nohmem;
 module_param_named(disable, nohmem, bool, 0444);
 
 bool dax_hmem_initial_probe;
-EXPORT_SYMBOL_GPL(dax_hmem_initial_probe);
+EXPORT_SYMBOL_FOR_MODULES(dax_hmem_initial_probe, "dax_hmem");
 
 static bool platform_initialized;
 static DEFINE_MUTEX(hmem_resource_lock);
diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index b2ab1292fa81..dd3d7f93baee 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -74,7 +74,7 @@ void dax_hmem_flush_work(void)
 {
 	flush_work(&dax_hmem_work.work);
 }
-EXPORT_SYMBOL_GPL(dax_hmem_flush_work);
+EXPORT_SYMBOL_FOR_MODULES(dax_hmem_flush_work, "dax_cxl");
 
 static int __hmem_register_device(struct device *host, int target_nid,
 				  const struct resource *res)
-- 
2.53.0

