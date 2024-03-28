Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A34212DDAC
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643315; cv=none; b=FLOhiDI0uc9N/IUZ+biJCg/wJ+dSAVj1z3mTDB3RKkerUxvd8mhgBrC7w3I20MpaQAXidp6cr8BlFMB6gWV7HZe1d/5VgoZ2WG6DgZ91E3PL7dBQWq71qSUQHW+zkZopgl1cPRV8p+7u6jyBYgWuaurSIYYsQ0V6ql7zs3jMSMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643315; c=relaxed/simple;
	bh=P/jfG3oJQnxJWF8y4/FRhX5DE6yIHQm3rt2+JP3bIkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTdm8lezsNYR5oZWtWNWhIj+lmidQzWY019Gm4gBb7iM4AWlwNjKV9B1647YaHB6gzBizMlRwsCSDW3GS0EtLJgwwysCrLVuURsMm5fx8L9my70MLN4b5iKby1mrjBkgR0nT1/O7x0KmePu0b7Z2yUEaIJrQ0m+PsGePcEy9eE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kXFueHq9; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kXFueHq9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643312; x=1743179312;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P/jfG3oJQnxJWF8y4/FRhX5DE6yIHQm3rt2+JP3bIkc=;
  b=kXFueHq9TX11cZvcAY8xCWLbMb+pv8X3nk+T4G10Azg1a5aGPiCyOYAT
   G+mHOEqc4vbsb3q5Ko1kMV9ZvYfevQiUBNqSpNAWHyOfz0SvSvlIFUrZd
   RkmoIDTuBPzjTHIZ5PgepryNn4JN2JKpy+NZmX2oVSxXMlxgPERIAOQga
   NtLYoKRr7Gr+y5VuICWfvk9JG5u6RWqKYeEEqESLiOCGoCjumulehjylG
   sgs+WhnMhe8kkfEKYUiqpr6+vlXPg2xUuFvEMXJ2ZoUP3VdUbd5kp8PPO
   eC3WiNmHtG/etlTloNp0LX69SjRv+CQbEgJKJgyJdkBvU/XXfuVA2uA//
   g==;
X-CSE-ConnectionGUID: NSJrrUjuTTS6+XHV6TMU4g==
X-CSE-MsgGUID: opqHBxWrR26PeRth3Qs4vQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294768"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294768"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726083"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:23 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 41/74] x86/cpu/vfm: Update drivers/edac/pnd2_edac.c
Date: Thu, 28 Mar 2024 09:27:35 -0700
Message-ID: <20240328162820.242778-41-tony.luck@intel.com>
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
 drivers/edac/pnd2_edac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/pnd2_edac.c b/drivers/edac/pnd2_edac.c
index 2afcd148fcf8..f93f2f2b1cf2 100644
--- a/drivers/edac/pnd2_edac.c
+++ b/drivers/edac/pnd2_edac.c
@@ -1511,8 +1511,8 @@ static struct dunit_ops dnv_ops = {
 };
 
 static const struct x86_cpu_id pnd2_cpuids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT,	&apl_ops),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_D,	&dnv_ops),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT,	&apl_ops),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_D,	&dnv_ops),
 	{ }
 };
 MODULE_DEVICE_TABLE(x86cpu, pnd2_cpuids);
-- 
2.44.0

