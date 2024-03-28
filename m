Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A3C130E5D
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643318; cv=none; b=jekdhSRhULUg8EG8buHCXMyXSsg3f05BOyC4TbJ+PHXvWpq4NukimIR7d+DquXH4GZf2o3aJJgurbdMjxPiqUNiE2nuuc5giLwDWQS4m3bIeqPuuAIH+Oeo6HKcZPmm8zQ8kzjWFfsbjDgaXaSR5L2QxzOKZtnj3PMTamLvaCkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643318; c=relaxed/simple;
	bh=i5bcoBcmvU7uXKCZja5nQG8SX5zG7nFXavF27vF+S+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtlYrMJIwIkT39puuloHiIZRoUKwYZWBNRGqTrLFSWaCsywuDbVHMmNGwqIqvL/98FWVFumFDbhjfu4/w5QL9r3zyZt1mqgyYlzHkEQdVFKoNZxPdXfKXWlvCHWcfx8LOhmM0uOvuJ18XdDltM7p+XS1BMUMDvVhyVopOAZeJGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ElS5JH65; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ElS5JH65"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643316; x=1743179316;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i5bcoBcmvU7uXKCZja5nQG8SX5zG7nFXavF27vF+S+o=;
  b=ElS5JH65SjWkzanA44R5PhvKxDKST5ncjjPCtzYlOFF9U89E4erAP7pf
   7/AAC1UKUtcIcb/6VTADfYugWlK51jumTp4DlohPfM77uqErNLFi9sKQa
   rEy1bXXPuVDuL7jl3pbiRVDXHMXyVXtSl+pVIl/EQZV9bxIAJxbhw3zxp
   qJUwc5Igtb7E2SAg7DMWY+4TAWB8VXz792A+ZIlCfAAjI5g0c++hfcT2R
   /UhisgU8dnpCf5As97EfPaGj0EY+aFRlxKfygMknJ23PnIRiOKmuD6zau
   CYsNnH1yLH9LEInScyMDBBfS8Ua4poHi2EYktSNi2PACZumwX4gGwmLox
   A==;
X-CSE-ConnectionGUID: VDq/tt1CSaujj66HtXUwCA==
X-CSE-MsgGUID: e2TIhN55TU2Y4lhCBAI4Qw==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294786"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294786"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726130"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:23 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 55/74] x86/cpu/vfm: Update drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
Date: Thu, 28 Mar 2024 09:27:49 -0700
Message-ID: <20240328162820.242778-55-tony.luck@intel.com>
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
2.44.0

