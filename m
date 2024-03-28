Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0761213118C
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643319; cv=none; b=EBEoepK6jQhVgO0IocQQln+IuiZr5e/iTjHjlNOn/v1J2/DtrTB0qm8eEjCIcfsRRjMRaFMWcZ86g+Fvc4nyvrQJb2AMvK9s9DkaRgDqKEk6lkOg22FCxNtnPYVMOaDyv7+s4L2i573b+oBeBvkhvUEv0sKGnnjn6zL0IA1pLZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643319; c=relaxed/simple;
	bh=lGxY6/fpKVjagJiMiQslsjgDFgL5ZPdXodSr7eR0UbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRTmlIXXYI1jYhJ9zuV4MuAe0Oi2CfKgQZtAq7FV33lze5ZoDsJ2NXKUICJLB37TQqq/ij6qbrAGaUdKRF9goq1g4j9WPLDHG4BtlAGCidVbUcUuDa9x04YxJsCLCGMAf7Q1RpygSGdvNWB4HVKdTkd4X6s0gxo5bI7RPzaVkEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K544rFs1; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K544rFs1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643316; x=1743179316;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lGxY6/fpKVjagJiMiQslsjgDFgL5ZPdXodSr7eR0UbE=;
  b=K544rFs1qx0/JqtAkS800ek8x06EjpWFRl7/OyxokBOE0IfwmDLcOsP3
   7J3Pg64VcgqZ0uoOConuM5RgqA93i7GHjb0B0Zme7cupmS6gFipLmSRrk
   ttqavAMQkAiDoT0pcK9iX0BOYw0c4zJ6qCfvV+j+5f2MsrsBOcipggi6u
   fyyrrBto+Bu1bKQOg/3bOEM5X7c9LxeSSntrcsyfhnGxsCvMzV6pbjfSf
   tUqDMVk0FJFB3xfFSuho3l6j9YWOTSTIte7cv2fg2icRY0cc4JEL6X8M/
   6aDeL+4G0/5WdwijkNIgkSJTaRjUW3FqWKn7XWpoXQuLV613BV9IgAIRc
   Q==;
X-CSE-ConnectionGUID: 7w2RvQTQQ3iIb417HilP8w==
X-CSE-MsgGUID: Gqc81PkaQIyeu64gzPn4TQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294788"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294788"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726136"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:23 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 57/74] x86/cpu/vfm: Update drivers/platform/x86/intel/telemetry/pltdrv.c
Date: Thu, 28 Mar 2024 09:27:51 -0700
Message-ID: <20240328162820.242778-57-tony.luck@intel.com>
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
 drivers/platform/x86/intel/telemetry/pltdrv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/telemetry/pltdrv.c b/drivers/platform/x86/intel/telemetry/pltdrv.c
index 06311d0e9451..767a0bc6c7ad 100644
--- a/drivers/platform/x86/intel/telemetry/pltdrv.c
+++ b/drivers/platform/x86/intel/telemetry/pltdrv.c
@@ -177,8 +177,8 @@ static struct telemetry_plt_config telem_glk_config = {
 };
 
 static const struct x86_cpu_id telemetry_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT,	&telem_apl_config),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_PLUS,	&telem_glk_config),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT,	&telem_apl_config),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_PLUS,	&telem_glk_config),
 	{}
 };
 
-- 
2.44.0

