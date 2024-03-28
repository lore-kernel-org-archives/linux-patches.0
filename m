Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28B18626D
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643319; cv=none; b=FoCD5UVj2mzI5njbeVUka9TuDutqld2bgaSh9Ahj+NINUKQPOyWC4IZRFbW41VbFjv3kFs/1b3tLKZOWtBlVO35fcUM90tE4qqbTDCrrvyh+krW/PAzpohqN7RTS17AA6wknI/TddcjM7AdxHguW9/l/2jkFBA/5zsITTqpF5Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643319; c=relaxed/simple;
	bh=xr6bb9OF0NXrEF0HgBC2BNEdfy38NpnLKwUrq7aiRyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGS2HGN5ewrZwbD7mobnm+1J9Zgzfvmqp1tk0nyKhlXDKRBuGTQbcQR/EimzKNo8vzsXPPVHCLvi0A554TITJNZt2Wx+2y2/wbO/AzPQ9Ixboy95O3HbP3nxqIE2IxtocPj4RVbO0r8s+0EBLcvyCdeRCHsETdulgE5pxZ259ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cU0VHeo/; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cU0VHeo/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643316; x=1743179316;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xr6bb9OF0NXrEF0HgBC2BNEdfy38NpnLKwUrq7aiRyk=;
  b=cU0VHeo/i2yypyArRZ6H8OcSM+liR45k8ZenWodWrPrf0zAJmiab5eq4
   9f5FhVkenigh7giLRNuMzlCpLw6LQIm9Uo5/ZMweFczzD0koJ996/duzE
   yRHe36RJ/v0dKEiHYgyhooKAVB1qxTjmXk31DfHr3Qvx7YE3qw6UMoDMP
   rmE0EgbsmxLchpjlhTJLGuSnv4vASjHKVxOC+bDO2nHUUbzzqQ/H2k60V
   AqcgXZfd32L3xLQponWBn/aT3LLAY5PWciSYGTAKWClZvKgMzOUp1r5xm
   YaeMVRr5mm9y0TjL3Dm6qU7zD4pwKkeNUkzUZn2mVSyQFjLDpJ0Mdmtng
   Q==;
X-CSE-ConnectionGUID: B3e2ix9oS7KTEVleHs0k5Q==
X-CSE-MsgGUID: pp0aVu/+QbudNwP0/bN9Xw==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294787"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294787"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726133"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:23 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 56/74] x86/cpu/vfm: Update drivers/platform/x86/intel/telemetry/debugfs.c
Date: Thu, 28 Mar 2024 09:27:50 -0700
Message-ID: <20240328162820.242778-56-tony.luck@intel.com>
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
 drivers/platform/x86/intel/telemetry/debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/telemetry/debugfs.c b/drivers/platform/x86/intel/telemetry/debugfs.c
index 1d4d0fbfd63c..70e5736c44c7 100644
--- a/drivers/platform/x86/intel/telemetry/debugfs.c
+++ b/drivers/platform/x86/intel/telemetry/debugfs.c
@@ -308,8 +308,8 @@ static struct telemetry_debugfs_conf telem_apl_debugfs_conf = {
 };
 
 static const struct x86_cpu_id telemetry_debugfs_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT,	&telem_apl_debugfs_conf),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_PLUS,	&telem_apl_debugfs_conf),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT,	&telem_apl_debugfs_conf),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_PLUS,	&telem_apl_debugfs_conf),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, telemetry_debugfs_cpu_ids);
-- 
2.44.0

