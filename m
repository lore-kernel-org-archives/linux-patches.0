Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C88217F4E5
	for <patches@lists.linux.dev>; Fri, 31 May 2024 20:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717187835; cv=none; b=PWWo7P2w+FBnxcEvD2CkRObDu6NNWMm7BlmrX6rGzf7bOauCpCN6uTi9k5RwA9RxdzWCbqKNTG68e0sMIEdUtvtUb+RdDCnPL7Dvm8aHzZNiJVblHOU8Oo/+TeLtrMw9Q28c/3vMKW/xIzSfROviYC2qHK/F+qI7vsyms0ZiNA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717187835; c=relaxed/simple;
	bh=PQHhBRWTyJ7lXAnwUF6T1t71Eh1K9Um/FsP12CRYfhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvV0tSD6PuAZnFhWbdXAkPrb6U/xhNCNq6SCqq1MTz3pbcNJs/jT1Yf2w+AoREbM0oBM/zAHNjqDiEDK9zsySUIIRWYNbD1/wcVCLSkBlVqQeHt3YO20e3wwkJv56qR4hsNmhNhSNNVFmxLJM2njEEPs4DaY4S6ln7+a3luYoz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PIidtctR; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PIidtctR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717187834; x=1748723834;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PQHhBRWTyJ7lXAnwUF6T1t71Eh1K9Um/FsP12CRYfhs=;
  b=PIidtctRBdYxKT2/ct1G5p4ZsjizYA+jyDtHFFzgVGDE5TT38wkCnhct
   2fBoQ4ZgYtNMyoCmPZQCskVV3okpS5BbVc/VHW0YUNV6SftB7og83VXjO
   M0rllS+/E187xOz5TbVxejmG+DnIx/on/vuawbH+jAjYyScEWlYLDhvG7
   hDaZ27mI8fdVNQa3vwGrkn3ERhSoSUEwwlWloBeGO3ARkhJqVXm+Y09r1
   LLjbdaAy4CALXN/lkX2y7L4cWh4uybW2UtNxFY18TxGBueDFdc4EGQwZ8
   vnVncTP1W7+5t6N3FfIw0vjsP4NpWuHcfZSullp2ncak0ybQx5IuSmsCS
   A==;
X-CSE-ConnectionGUID: CobReU7gQfKYkChSL0pYyA==
X-CSE-MsgGUID: gBCmgvF/QeKXaBknHsgQAQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="13871836"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="13871836"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:37:12 -0700
X-CSE-ConnectionGUID: EGw/odp1QjyARxLl2l8KHg==
X-CSE-MsgGUID: Z+S6GtXRQTymbrEgYf5zJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="36355381"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:37:12 -0700
From: Tony Luck <tony.luck@intel.com>
To: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Cc: platform-driver-x86@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 04/11] platform/x86: p2sb: Switch to new Intel CPU model defines
Date: Fri, 31 May 2024 13:37:00 -0700
Message-ID: <20240531203706.233365-5-tony.luck@intel.com>
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
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/p2sb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/p2sb.c b/drivers/platform/x86/p2sb.c
index 3bf5d2243491..31f38309b389 100644
--- a/drivers/platform/x86/p2sb.c
+++ b/drivers/platform/x86/p2sb.c
@@ -24,7 +24,7 @@
 #define SPI_DEVFN_GOLDMONT	PCI_DEVFN(13, 2)
 
 static const struct x86_cpu_id p2sb_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT, P2SB_DEVFN_GOLDMONT),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT, P2SB_DEVFN_GOLDMONT),
 	{}
 };
 
-- 
2.45.0

