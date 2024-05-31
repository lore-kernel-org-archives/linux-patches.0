Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08EB18306D
	for <patches@lists.linux.dev>; Fri, 31 May 2024 20:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717187839; cv=none; b=aaNzE9ukB0I0n2/KEe/zOntwY09dBdNzgaKnXqEyUlFWJLWGaiyP+jVxN7qqXV8rIM4MTYa5fAX5J8Ym4SfYxASguBbytj/PXcKQ4TQsXGruuyArPMm5lcIudXDnlIKtBuY4qJAebEebh4/KbX9xDNLNrySxtUxvD5M9CFQSm8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717187839; c=relaxed/simple;
	bh=uwrfu/RQXE+CPGny/VIfWFI+r++v83onQnRT6WNFLOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rU4GvyQi6khgxT5iIXn/OiaciIeYBmxdvbBAxOmPrklw8X8zG0JXmBADF+CGgMWgQkUOOlvtoLZuZhMCtmN9Cc0QVkm0nIuT7xdbVBwtFrMzc2Gjby4LbnzaF36ubz4ZufV65uYHuROODuLHtZL7jMadFSpqWEFRC6Htzmdrw3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R5JU9f7e; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R5JU9f7e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717187838; x=1748723838;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uwrfu/RQXE+CPGny/VIfWFI+r++v83onQnRT6WNFLOM=;
  b=R5JU9f7eADc6ojjQFy4mRnxjg2jw8iVwm3yGaDB7ff7Y3bZmCqvAHkuA
   vXoxjQH9rkW0KXc4O0z1BkcepSpPzAyLxYnS3Xns5EeVIZ5NeHCutWHaR
   fd7UQaAufKyCvHdmi7dtJE2/iLVS7SDihe7sXRxuBd1BXTbJQSZX3HUGq
   BP6tQ79Kz8CydDKRd8rkUVInGZjwz4oFEB8gywbolD66Rdd1QyfiQUQuC
   5PmeeF2A9bZDTmjpX2nmKDdIzwOmmt/GTOMKENmN5d0iTLIyV/1LKjJ7f
   GdIWafRIanOSu1ZPIYa3o6XKjy55EziseA9zLkILHqViWbl9Eax2wHXv/
   g==;
X-CSE-ConnectionGUID: dGnOQhowRii5I9NWIaJeew==
X-CSE-MsgGUID: a4uVpwysTDme5yppr1wdFQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="13871856"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="13871856"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:37:13 -0700
X-CSE-ConnectionGUID: Rm6XaC6qS4OMd2shuamntA==
X-CSE-MsgGUID: xSQWySafSlOgPQV7lfBwsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="36355396"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:37:13 -0700
From: Tony Luck <tony.luck@intel.com>
To: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Cc: platform-driver-x86@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH 09/11] platform/x86: intel_scu_wdt: Switch to new Intel CPU model defines
Date: Fri, 31 May 2024 13:37:05 -0700
Message-ID: <20240531203706.233365-10-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240531203706.233365-1-tony.luck@intel.com>
References: <20240531203706.233365-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/intel_scu_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel_scu_wdt.c b/drivers/platform/x86/intel_scu_wdt.c
index a5031a25632e..d0b6637861d3 100644
--- a/drivers/platform/x86/intel_scu_wdt.c
+++ b/drivers/platform/x86/intel_scu_wdt.c
@@ -50,7 +50,7 @@ static struct intel_mid_wdt_pdata tangier_pdata = {
 };
 
 static const struct x86_cpu_id intel_mid_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_MID, &tangier_pdata),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_MID, &tangier_pdata),
 	{}
 };
 
-- 
2.45.0

