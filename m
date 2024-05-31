Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F660182D28
	for <patches@lists.linux.dev>; Fri, 31 May 2024 20:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717187839; cv=none; b=CYf3v5aIVJI6l2BKXAA6WUxShPZm3MUenaSNFHY7jm9RjN+wgcI9rznPwKSZyWwMdpXi9J6YQA1DN2+P7S/DSk/5oH7DH62YNKgJJrCnKC0ppPr4n2FFGB1YyI1sCOf6DIyE+S/j9oURKPHU2+VektGf9vSZMHR1nmc7Nrc/ZCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717187839; c=relaxed/simple;
	bh=hG3FP4AcNKVMSK2tzoC+JG6H48CVh98nrbPvxUI40RA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jue9+PBbuirxrmgyuiebDcjxLKlswk6NN9yzC2XGUcbYNz7t8CRBy9cxjQKug/02UpfLwx8ggLuMP9kUPabT7FAOK9U1ZtB/LGQELiI3iHBO2oh0TrhibBzGg/0BPN6N/yZYONo4+1ErztwyK0KPoIzChs8lFRUIDV7OY3yLaHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gUP/T61I; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gUP/T61I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717187837; x=1748723837;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hG3FP4AcNKVMSK2tzoC+JG6H48CVh98nrbPvxUI40RA=;
  b=gUP/T61Iy5SqtuvdZ3E+191+qT1OCC0LYo+JxOSaHHOcfm9T1Tks8vi3
   LhJx41RSpf7q3GwASS2BCIJyHCPSWFxVamsw3+nIEOKB2sV6UBkcV3NJp
   OL/rk1BDDGtZ/7m9j51g1WAbPIOEhtrfKGMsiYxhvMij9D58DN6A11m+J
   NTiFMpOcnL5uP28VPIHqDvLbHayWbRBodK+1cLKTVB6QUZMc/nRJICSO9
   qJWf8MhyfmoZmXGRST865GHA6ohAGanUvCW3Z8exiDV1pjbbztU6EnItC
   zlSS2EvWUYH0B6CI0pHgE5PQ01eXVkMm6tF09gWYtMvwz1Q5n29zUGVdH
   Q==;
X-CSE-ConnectionGUID: ro5nwlpEQgO9fsCFj1/BOQ==
X-CSE-MsgGUID: v/55CH3USLSbC6G6LivYHg==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="13871852"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="13871852"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:37:13 -0700
X-CSE-ConnectionGUID: 2KJ6j4tWRxO+4C2bRmM4hg==
X-CSE-MsgGUID: 92NgkqxAQFu6Qz1BzbeUwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="36355393"
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
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: [PATCH 08/11] platform/x86: intel_speed_select_if: Switch to new Intel CPU model defines
Date: Fri, 31 May 2024 13:37:04 -0700
Message-ID: <20240531203706.233365-9-tony.luck@intel.com>
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
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c b/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
index 1b6eab071068..6c36f7704fe7 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
@@ -161,7 +161,7 @@ static struct notifier_block isst_pm_nb = {
 };
 
 static const struct x86_cpu_id isst_if_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_X, NULL),
+	X86_MATCH_VFM(INTEL_SKYLAKE_X, NULL),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, isst_if_cpu_ids);
-- 
2.45.0

