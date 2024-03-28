Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2038626D
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643317; cv=none; b=AmZAqfRzpes/SXoS/d/9q7Eww3HMuYxD+FbBLwXoRdE1GFzrpgHhF4TlnPHJrEf3EPCxBqRjbCsQAXJho0LkFjI5QcmoitkbupI3sKkoB+C5NEq4rIlxG+38JZP5fIQwrcOEqQpyYTc189Qtihyl5aGIh6++4E34TtHCX7H0VBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643317; c=relaxed/simple;
	bh=/298Une+Q9Sn9FwIP6fJUsWhONOKrs7AQEbwqwMcHfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rf35Is8jTzk4eKqqH3buVGQgpD15LyAymv3wzx01laOWqt6+I4kbmcpudENmcB1kWWCb8cVw9Aj7UR7wiRItLmTl5aINdFtqK8dSOiGFBaUbozzned48+ZdcAvLyLOWeuBLddc03WUBhqWe9/UPG6EdiY8GTEUVABIOLyo3o6BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bYOUzBam; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bYOUzBam"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643314; x=1743179314;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/298Une+Q9Sn9FwIP6fJUsWhONOKrs7AQEbwqwMcHfA=;
  b=bYOUzBamlst1hWNhctxjrtMK1g1MwE6XnYD59L3Q+3WXL5Ehp2hGK7fM
   i0/5Ct2iNBeEKxNKsVeu4dQNCbATH1eVp042hCUmGWXz178RQVhDI9/kE
   KBavbEpwAa4rcxLoD1rOEHhOYW0MFtSN2vxM0gek7UqccN60UhCqnURQK
   7SUc31bVgcP4re+dAE996Z07kH3WkPJtrwpf87sNw8fCfqpeju/vbj953
   skQ44yavvNNwz2UImA7eWLXcGuu7bJaz26RwCsXREwRD2le+b3f/uQ42z
   5zcIgSGkXYRe/uFxJqIMW7yB6EaLbPIifKWegkE8DId3N1LGSL2o5bm4o
   Q==;
X-CSE-ConnectionGUID: /D1TLpY7SlKACLaCA3430w==
X-CSE-MsgGUID: P0Vpxy/vTpiw+PwnFbwr6Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294775"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294775"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726103"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:23 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 47/74] x86/cpu/vfm: Update drivers/pci/pci-mid.c
Date: Thu, 28 Mar 2024 09:27:41 -0700
Message-ID: <20240328162820.242778-47-tony.luck@intel.com>
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
 drivers/pci/pci-mid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci-mid.c b/drivers/pci/pci-mid.c
index fbfd78127123..bed9f0755271 100644
--- a/drivers/pci/pci-mid.c
+++ b/drivers/pci/pci-mid.c
@@ -38,8 +38,8 @@ pci_power_t mid_pci_get_power_state(struct pci_dev *pdev)
  * arch/x86/platform/intel-mid/pwr.c.
  */
 static const struct x86_cpu_id lpss_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SALTWELL_MID, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_MID, NULL),
+	X86_MATCH_VFM(INTEL_ATOM_SALTWELL_MID, NULL),
+	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_MID, NULL),
 	{}
 };
 
-- 
2.44.0

