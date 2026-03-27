Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A545334A3D2
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 05:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774589231; cv=none; b=fXUKpKmONPENC5m5jtFCJ1F9Vslzj2w9bAezqb+pVihio05b+p1q9HDH7HniROkF9tueOg/7J9TNscynerChbB5iqCSM/tUt+z+Q+kuioTgvcW4t9ozfMA2QBnoUwxcWLFsNW53Ii8e93/U1b8Z+AMvS4v711Hy3K7t3Xc7gAG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774589231; c=relaxed/simple;
	bh=I/LICR98j4NyKeW19BwXls+7A2b5r/ZcdQ4p+18VO0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1BCTv9FLzCyJ2u0ShmiQnqvMI6AgZEUn13ZuceK/n8CQ00mfqNpJ3R03AV9mFxxTNAo9mdRSWbflXhIbtsLVGkFOGCEJVMjEEPmwlNjGE7/RHf8m23DjFgT4cuuh5ao0NVzaMs1uwa1bwY4gEV/IQxVJO/WCAJXC68rlbrm2HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eoTCgcFD; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eoTCgcFD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774589230; x=1806125230;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I/LICR98j4NyKeW19BwXls+7A2b5r/ZcdQ4p+18VO0g=;
  b=eoTCgcFDq/HTjLvgd3qrJ7Rr2iGwzajQ+/n4Il8Z51Tmg2IDVJq4rO76
   NIDcRafQI5tUO0bvkGqxRcvt5+YyYz4Gu0LEBg0wEZI4aeA6NAegRBOCC
   xQO0lbKRXXf3nXGjIcL0Hc0CZTSFXX6AjoX4mpYwPRSEJS4f4MMFrNooY
   giEAmJJ0HbEP2h720Dp8ltYGYQwxPrQkFMjoeDEwNdm9m4mwb/wA2hChB
   eM7EhKMQ1L1hPhT9M6wvy5zeWMhMp9lrVPkKzQ/u4/3K93jX/QnoqGNpt
   uVeyBFnVfKaOi7L9JGmQHYjwuyCDcVu57twLdwYE10dxP69e70t3k/qCg
   A==;
X-CSE-ConnectionGUID: i9aeBFBpTJWdw6J+OtNTsw==
X-CSE-MsgGUID: ORU/ymO/T/S8x4Ibeeuz4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="101117961"
X-IronPort-AV: E=Sophos;i="6.23,143,1770624000"; 
   d="scan'208";a="101117961"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 22:27:07 -0700
X-CSE-ConnectionGUID: SZetRyzOQz6keeXuIM+U0A==
X-CSE-MsgGUID: GRDfq8C5Q7aQNJya7tNvxw==
X-ExtLoop1: 1
Received: from dwillia2-desk.jf.intel.com ([10.88.27.145])
  by fmviesa003.fm.intel.com with ESMTP; 26 Mar 2026 22:27:06 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: dave.jiang@intel.com
Cc: patches@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com
Subject: [PATCH 7/9] dax/hmem: Parent dax_hmem devices
Date: Thu, 26 Mar 2026 22:28:19 -0700
Message-ID: <20260327052821.440749-8-dan.j.williams@intel.com>
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

For test purposes it is useful to be able to determine which
"hmem_platform" device is hosting a given sub-device.

Register hmem devices underneath "hmem_platform".

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/hmem/hmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index e1dae83dae8d..af21f66bf872 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -96,6 +96,7 @@ static int __hmem_register_device(struct device *host, int target_nid,
 		return -ENOMEM;
 	}
 
+	pdev->dev.parent = host;
 	pdev->dev.numa_node = numa_map_to_online_node(target_nid);
 	info = (struct memregion_info) {
 		.target_node = target_nid,
-- 
2.53.0

