Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2B5131BB7
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643319; cv=none; b=Uj0OHi5+6mfg/c7BP8DAsNL/1LmgFHsVlAg6BVpX81s2whk7Ti5jq61f3yjTpekgu2n2aLtSpWahfWSCOfE49XEScuEIq7tcHxDdM3Uszos2Y8ehbrYEL0kygszHXmkCm5AZUcr2wIAyaySIJ8TOv6c60qqmxRe5Vq1gdZJMRd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643319; c=relaxed/simple;
	bh=NHkS+PLB8tCqh4PRqBz9xJFe66d4//WHYse1TcAmK38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/2acmfGcR9bY0CWmuJaCE45pyLVv5SzXeKOVxg68dp7WkyivPFCpMM+UvF27/0mVRPkrxX9+I8smAgDz3ibUVu5oiq9Yq6utp4SKeDn2kaEViOMJ7If7ErFH3Gu1urMQW4qriHhhEbn76PTC7Ka3nGb8PoXLM4SEi3xBDq8rFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MZUv/8Hu; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MZUv/8Hu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643317; x=1743179317;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NHkS+PLB8tCqh4PRqBz9xJFe66d4//WHYse1TcAmK38=;
  b=MZUv/8Huounhfsw4Fosx3I8Qbj7CJwhmnS0VSerAO2+fRRGX98qmILZU
   MVfXh+xwVTqoyjUHbrrB8yiIrS1nUiySndye9Mp6QKauW/tCA1OZMCU3H
   ELTXzRrAuj//1XiCjtuql3S6JdL+r3Q/DdDkjNhr2F9gKtmUubiVcVFDF
   xa5R3h0wS5w1BsOinmTNMJy+5HJLPH2LHIgKE9vXX8/KxBrkHJObMalOy
   tpyl2dvhST71ddeNq9bUT03UGBll6V0PgM9I9tMo+e8+uY1tSV0pO8OUk
   xVXdJOhENsAewDwIVXVeRR0WZD8jtIs8qjeVfeMozFCLDRyR0TJyFCwRr
   w==;
X-CSE-ConnectionGUID: MJWFVdSrQgmQOtPTqS6Z5w==
X-CSE-MsgGUID: gFJXzZ0IRgeTSwKQ0X/YtQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294791"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294791"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726146"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:24 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 60/74] x86/cpu/vfm: Update drivers/platform/x86/p2sb.c
Date: Thu, 28 Mar 2024 09:27:54 -0700
Message-ID: <20240328162820.242778-60-tony.luck@intel.com>
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
 drivers/platform/x86/p2sb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/p2sb.c b/drivers/platform/x86/p2sb.c
index 3d66e1d4eb1f..8cfbf0bbd346 100644
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
2.44.0

