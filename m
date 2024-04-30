Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0A91C233D
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495910; cv=none; b=C8eYPlXyKAU/ae+jMs6UuCQB/ZeFqhTPdvVbUMzNXA1g5DtrrJSNvezuQslesdAPZB1dvNZA/9Cym0uqhs4nrR/q5QQ10rLBB+1sMhLws3zCQgKURNJAGGh2Qch8qN42gzQ2UHYweExN2//DugLpQx1YuC9fZv9UCjG88xE0V+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495910; c=relaxed/simple;
	bh=qqh/VHYxTuSJACNe+DTpuXgw37TddvW3ou6MW1MJcG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWXfxrDf6vBO9OisWLmApnkg0YbMQMFfgln5GELTnoOGCPjFdg5p3TuefKMxMVwEEYynpS2qxsu22wlLVlREpqTJofvwV08OxpGApWQzGUFpnS+snNjoeNGzGl9ETntnMTGs9fg2b3/Qo6XDoSExofbVu3lB0IdxnptVwZRc1uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NwLgpg0Q; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NwLgpg0Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495909; x=1746031909;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qqh/VHYxTuSJACNe+DTpuXgw37TddvW3ou6MW1MJcG0=;
  b=NwLgpg0QPj9RBbhOGQq8hD+SVMzTioAQNRb9CX2dRqj04LAOlB9hBuCE
   E+LIu8wcTAwn+zcTIYBIDIHTE9Rsftnb4b1Qb2z/zhiI2OJZITJFQXnM+
   xiHPQRzvSZ7oVSIMwUV+buO1PCijsE2HqWitfy4ddnwz+v4SaEq7nO/eu
   audsx46D1jfzdUmzBtzRGJfwlAeEMdtJ6zFSovKVpGE0YpjbMHhnHUUzn
   mCU/Pb1bIwWMBNcS6PJGb5wTPIrd5IAuisLPWmmjPmi9HYx2dZzyiWQSs
   vzU+8doNRGwHV8CvVSMIHEftHK0blXUJODrLvswFroqtoVmAlxo5ULRus
   g==;
X-CSE-ConnectionGUID: x5JMIbrpTHW0kqSo7dKwsg==
X-CSE-MsgGUID: mMMMH6/kSMupRXnzYeCYcQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075757"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075757"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:23 -0700
X-CSE-ConnectionGUID: iAU0A4HJSsSWcKKvzoSMgw==
X-CSE-MsgGUID: GFz/sRt3TiGBH9MFfDilnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515513"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:20 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v5 38/47] ACPI: LPSS: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:51 -0700
Message-ID: <20240430165100.73491-38-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430165100.73491-1-tony.luck@intel.com>
References: <20240430164913.73473-1-tony.luck@intel.com>
 <20240430165100.73491-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
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

