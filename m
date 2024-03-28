Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666B6127B67
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643318; cv=none; b=QQJJkmrzAdZmGHMqCjGAjw24guM1WwINfP7qmd1ch5YBENOcbgUIaJpf89klRJjhOmTJrKI36Z6iROPrrgVgBZ3bCKVmrtXMdX6i1GNbj4XYt+yYt+0bGU2QpOqGix/WlOCzL3Ld06FZY837Es5PreNDiuG89ziJjQnXLqp0no8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643318; c=relaxed/simple;
	bh=zq3PVQPAcMWcn9vz87aBSrEUPTNktf+avk5R+71nh50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsWeyqpQjETE1sqRhBVaXXmNauHFVjCVXdBz0m+ND5vXME26J1kHkRa/oXDBL9pA3MTJKJM7xSMLwO4piu3U59tTRa/A6Dm2BhyATXuKuRM3D38bDSx/EtJSvoADyUqLX1k1YvzEbQe1PvTS8Eby2yAezVA67Zu/0oq9S1I40RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LIEj38ta; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LIEj38ta"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643315; x=1743179315;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zq3PVQPAcMWcn9vz87aBSrEUPTNktf+avk5R+71nh50=;
  b=LIEj38taeT5jnh0kvDQfSRu+OqZelrZwrEgPzd6rUydADFe9Dk7/hidl
   whSw447ecbIgqbruM4HTd8kMinkyWKJwVSmiLPPXngVDkyMxuaBxS8ddN
   3XSSq5/yxuIa+3BIh8vI2QGJn57Riv8JuDCFSXGfsJdkwmXpR9zDwYQvB
   l3+syw0CpcKSO97oIQCU97R4kP2N/ClACAjUSZGAn5+h5eye7ImXOlDMG
   bGtSc2zDaF/qOkgBlPGqB+oa/Fcfg5S96+saLaHQiPJZ0KjV49Btiwui4
   z2gNKUnE46mwldlrSyMWOMI2F2IxBz38dW/S6efq7Zy2kNfbd7Wx8Nmz+
   Q==;
X-CSE-ConnectionGUID: wqwhKugCTbmFwi7EhOta8Q==
X-CSE-MsgGUID: 7Pz2qdm6T+mFm4vl/NZ+kQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294785"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294785"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726127"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:23 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 54/74] x86/cpu/vfm: Update drivers/platform/x86/intel/speed_select_if/isst_if_common.c
Date: Thu, 28 Mar 2024 09:27:48 -0700
Message-ID: <20240328162820.242778-54-tony.luck@intel.com>
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
 drivers/platform/x86/intel/speed_select_if/isst_if_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
index 08df9494603c..96f3b221b6c8 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
@@ -719,8 +719,8 @@ static struct miscdevice isst_if_char_driver = {
 };
 
 static const struct x86_cpu_id hpm_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(GRANITERAPIDS_X,	NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_CRESTMONT_X,	NULL),
+	X86_MATCH_VFM(INTEL_GRANITERAPIDS_X,	NULL),
+	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT_X,	NULL),
 	{}
 };
 
-- 
2.44.0

