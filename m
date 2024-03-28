Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156F613118C
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643314; cv=none; b=oFhbiDf7U1qgh6vp2aTFZ+OfprdseId0my9LRWUDQ2bvFxwUaY2P6dg3kycMO2eKTVtSablrAwGISeQ+44RyntQyVnlC2lOBvdDiLS44J25qA2wJDPPPxu58v3a7yErQhyCW1bGgtpjmzaItMPTxblTUkbs6IvNLsqVBo6L2cUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643314; c=relaxed/simple;
	bh=frPDqt/jTGsMhuXRZP5I2aou/N9zQ6TaB6jottwpuBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkGy3mLe3XE4CMq3XCLieUhdNSRfm9YQO+8dY3BYpo6C87p8DNQnYyWEvLqgALfb2GIjPAc5PhO3OIcluDp+KAZulvTs4kJ9KMXCjCUFek0EDYVpyy/uUE6PRfwMe12bbRJuziuc3EaRN6Brx+Sz59XFa4+MwJBLmVh3Vl3BHxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MyyVFwsp; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MyyVFwsp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643311; x=1743179311;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=frPDqt/jTGsMhuXRZP5I2aou/N9zQ6TaB6jottwpuBM=;
  b=MyyVFwspTMX5q+PV1P+mW3EYNgDG+mhgAGvSzkDWXGT/UClXFSOLdNWw
   0CcKDyewjcIJ+ZWllEQo1dO5Y1dmIqR6mJ6SKdULuHH+iqBgvscyxF8wG
   G5/4wtYeK0UsTjsu01d2c70pkJak8GuPRXIlgZhK+9jK6+jAW94kU/4TW
   dk1OFxteHbbsVOo2KXUKaBFPMAM0mJgWnW5HVKasZ3GO0K2Unx+5CmIZ9
   Jua3n9BPWPY8w0rysiQHgqWCasT4jrQwK4mZj4lT0Vv++ZJIlnX5UGqmF
   3i0BvKf3YQQbQTIxJeDDQ4HNOM4JjeA61Dj+qBA/cauRvInALVIHz6w3v
   A==;
X-CSE-ConnectionGUID: /bQ5Lq+aQxKpj0F0EzH0sg==
X-CSE-MsgGUID: 9O8YsgZ/RGOa+CT9u6JXbQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294762"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294762"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726070"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:23 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 37/74] x86/cpu/vfm: Update tpm files
Date: Thu, 28 Mar 2024 09:27:31 -0700
Message-ID: <20240328162820.242778-37-tony.luck@intel.com>
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
 drivers/char/tpm/tpm.h          | 1 +
 drivers/char/tpm/tpm_tis_core.h | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 61445f1dc46d..895f2dba266c 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -28,6 +28,7 @@
 #include <linux/tpm_eventlog.h>
 
 #ifdef CONFIG_X86
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #endif
 
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 13e99cf65efe..c940fd18988e 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -210,7 +210,7 @@ static inline int tpm_tis_verify_crc(struct tpm_tis_data *data, size_t len,
 static inline bool is_bsw(void)
 {
 #ifdef CONFIG_X86
-	return ((boot_cpu_data.x86_model == INTEL_FAM6_ATOM_AIRMONT) ? 1 : 0);
+	return ((boot_cpu_data.x86_vfm == INTEL_ATOM_AIRMONT) ? 1 : 0);
 #else
 	return false;
 #endif
-- 
2.44.0

