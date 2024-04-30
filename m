Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944D61C0DD6
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495906; cv=none; b=JUTi1wielRWgVZzyOYH7y+wPgHSvTenNVDNaJd1+2ZEg4BM5kUcGA1tjbbWx/pDbO8+gMdyQFw4TJq30beN6OYCQoH88NomFdi7X1Dkq1DBT/Pl4Y+0YjuQUwYN8eQJvbRalhb/0B2ewvB5H1AMaJ7LQUYcTbJTJ368JKi7Jq1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495906; c=relaxed/simple;
	bh=o94uwlfooWAFAb9a0zSupQqjH4F0Kx+XTQ+2KGCPpF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hM1rK8httNB0WFDlplsvNKdBuFRNvPnYoAVh1tgiXPzT4rgh/SL8QlSngF5qDQUlZlPaOWSfq3OLkoff/ZoC32xJ1xuotBplLzBkvSDzcLLVgVQiE8VyPZwl9GnE8qc7kX1kjQkbwSzCByTlgaYcWtKgfokdXzvUloRQRsb4lNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dLgve6os; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dLgve6os"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495905; x=1746031905;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o94uwlfooWAFAb9a0zSupQqjH4F0Kx+XTQ+2KGCPpF4=;
  b=dLgve6osQ2NEmkmi4DSGdo2RvXKYqkPzShMfY1QTswb4RAnXd7WA5B7N
   WUu2c24IdDA+0Bjdh3HyZZBxgNUDS9jU50ut57Ek6IoG+WPFt7QS5b34F
   RCLxOHZBvRN+ArsKK4qs8+r6PYmFfBc3flzwsRTZu7fvry+XbNmA53rRV
   ORY5A9Z4JW4OTLDd85i5TJCiKjgTUz9Kna5/3w+TIIbswppQQSquD/Au4
   HibUp+XG0nlEnPsiR4ACXgRRMbUqHwlZDkp542lZlQoO+ZJd1jQZZ4piB
   1x1AufxoKeByGUBA5V5byop3FEZRtEmuKkSluMr/t2O3FznreVAx+ChDR
   w==;
X-CSE-ConnectionGUID: a2lb6m/PS3GB4oBFR1R67Q==
X-CSE-MsgGUID: Me+NHw9uT7CWsGoNMG6Qzg==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075691"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075691"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:22 -0700
X-CSE-ConnectionGUID: qfzK5AcFScaZEd2llae08g==
X-CSE-MsgGUID: jjq2A11tQRyQS0Eav/sjmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515468"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:18 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v5 21/47] platform/x86: p2sb: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:34 -0700
Message-ID: <20240430165100.73491-21-tony.luck@intel.com>
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
Acked-by: Hans de Goede <hdegoede@redhat.com>
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

