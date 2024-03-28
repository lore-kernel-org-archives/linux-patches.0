Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4BD12DD92
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643315; cv=none; b=etqEjiHjls7N7Y9Em9jKSPspUF3j3XCv9gbAQJm8kdGjZhKPHAY9CwVJQxgIgAqbOSTQo/dTkpkAzBk+4TmwKuS864PlaF6Msl6jhD2Po0EiMlGJFVUAdTlAbkqfdoww+uoajmqD03P9cEYVTPErEyZrckuTKFyilWYe1BuK9fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643315; c=relaxed/simple;
	bh=L3+S4gA2ORuFzeK6+sQEVl45VQr8XCUrqX1gADKQOqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=seRYdRyAQnAh3crIfjo1f38UIqD/MEfA2+l3VdXUMvLR5tD1iCq0n6/DPJO9lWhMNzXOf+SQl2s6VuOyj9Q4nI7DfbBJEcAUyEW/tE3n9LkLBUfEWZMUKNe3OPG+XVkCNAaHRGCa3moGTl5TgVS0C/mq4pwNGhHhSYHYlKkNT1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LvfMjLNn; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LvfMjLNn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643311; x=1743179311;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L3+S4gA2ORuFzeK6+sQEVl45VQr8XCUrqX1gADKQOqw=;
  b=LvfMjLNnsSrgPOoM87TRzZx3NpHcsb/uPhD63kGSec9hNtTjWpzkqXDT
   bLW+u9c4hHDPR3hhJOpuw9uAy4oXVk0PILPyW8C3aMXiT8x0dcZLimJzr
   oKebOsXJWtxwQqTVrA/2+AiAVSGnAYGB0KydM3bjHa0F5MU3KNhn/YfCd
   9aIScyff3Cqxe6DMRf9uyttxexRsFykoD+pvbo3Zts4YYuIiqMrQ+Ko69
   JtUfT05tZVVTwafLX+Qn0s1HK1YNschdieiptURJ5VIN/qV9wMuoxED3j
   9PoAe1ASej+pytOtU/h+g2pd06FKBDsybdIx0GxMZBvx+SuBnwOFpzyM3
   w==;
X-CSE-ConnectionGUID: RIy2GhaHQTy1WMtQDdIU3g==
X-CSE-MsgGUID: QHWJDL4/TiSTYxcw4Y8VNA==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294760"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294760"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726063"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 35/74] x86/cpu/vfm: Update drivers/acpi/acpi_lpss.c
Date: Thu, 28 Mar 2024 09:27:29 -0700
Message-ID: <20240328162820.242778-35-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328090459.242500-tony.luck@intel.com>
References: <20240328090459.242500-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/acpi/acpi_lpss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index 04e273167e92..e7b57dcce146 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -337,8 +337,8 @@ static const struct lpss_device_desc bsw_spi_dev_desc = {
 };
 
 static const struct x86_cpu_id lpss_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT,	NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT,	NULL),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT,	NULL),
+	X86_MATCH_VFM(INTEL_ATOM_AIRMONT,	NULL),
 	{}
 };
 
-- 
2.44.0

