Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DAD1C9EA4
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495916; cv=none; b=B8p+v78Xz+IHL9mnKos7h+c+GmJjgROVOdMgSUoAPbvEoChNoLbJczP3bDNyj2p2L4NB53p7epUCnCJNhlhgU10LoXmfLif1wp/rdESd5Wlqn5480+USPeMEPIZjy7GokKr1XtHSytmj+2zPE7igziFHrlXVY3nLVl3p2XbBFOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495916; c=relaxed/simple;
	bh=P/jfG3oJQnxJWF8y4/FRhX5DE6yIHQm3rt2+JP3bIkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gm1v4gIKb5rrD7ITsduusH4HEjcMn5gzLnSA3ouVjTNENmWpIYHF5F8WHUNjXoMPp/+oansuFMTxjQG4r3xxCi3cOgFESmekxFbHf4A5YgYR8kC7SDTXjphhMms/o3SJFIhU1FPuxuF6mzUUl2N2IdsiZk7eA6zuneNdC+ng+FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mUt3bEV5; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mUt3bEV5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495913; x=1746031913;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P/jfG3oJQnxJWF8y4/FRhX5DE6yIHQm3rt2+JP3bIkc=;
  b=mUt3bEV5YQCK6QCPoy4i/UB5NYj8rL2JnAgL2Xg/wNunQ3j8l0Bar9v0
   uciITDASVPj6kcjlwiN3nXHDTU9J2qefAsf6nGINsfJVCa3sJfPyvQzT+
   udlnbTV//szX1sRGUlm21PrxDfz5Wt2XPcqxPxOdbDCgr+N1Du52EdsZH
   VvGO/jDgOGOnSpF3cihKPw4ZkCdcyot8clryPYt52sydCIjdR/m6qZNFJ
   XNGTkDqbo0nYnMjSzLjd8Q0uw7yVF8QL2+y3OBmKM0Dy5vXnXEie+Juwg
   3Ca/r3qdoaAefok8jLBqpubGQUlxzlpJYEq4dHPOEv6dvCwo/9ISRSfPV
   g==;
X-CSE-ConnectionGUID: 1vpvsDezR0GUcgRRgUE/tg==
X-CSE-MsgGUID: TypNlYYYQKqHMDFywHlAGw==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075790"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075790"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:23 -0700
X-CSE-ConnectionGUID: 6o9jFqaiQ4+hzuwM6EpCyQ==
X-CSE-MsgGUID: JlaGPKsHQk6QaSJvCu3SoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515504"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:19 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 34/47] EDAC, pnd2: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:47 -0700
Message-ID: <20240430165100.73491-34-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430165100.73491-1-tony.luck@intel.com>
References: <20240430164913.73473-1-tony.luck@intel.com>
 <20240430165100.73491-1-tony.luck@intel.com>
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

