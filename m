Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B7913C3F9
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245212; cv=none; b=Kue8Cw0cmYRJx2x9dfID1vZvf5dtgp0Zd/X/enNmh07w7fksGldq+3ni60SHhkNBctELbFJV+qQmHlLKb1iFuyrv/PCuVewDgbElJKvjhq7tsCMeNHDNpx58+Nup0wjOGk262kzKnLNx5U/v9rzRxIdd1o3eVMgN0YHNLyP1WuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245212; c=relaxed/simple;
	bh=sASbPr2zR3JdDKlYAQlWUeMercohyneum+eNLKpGg/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKawh3Fu+1sRjkwUatldNVoxaGO4iVG73UrwHJYgsPstij4jjzxX8ZYwOjQ0SKlXX53KsxpCcO81uotvx5k1fMRG4/QX8EtKrPuR4BeFYJDUH9LWfGABEEcELU4wP+PbisjUHwey+tJocSJHSg72v9o2qAhgNhXtMZJz3hIty60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EIzwhYTx; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EIzwhYTx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245210; x=1747781210;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sASbPr2zR3JdDKlYAQlWUeMercohyneum+eNLKpGg/c=;
  b=EIzwhYTx3Lt3V+qqgSAbn94w/U7teoFEO2n5rZ8gWa+clB+fN9crskkC
   X46IPrPDXjX5ZLkxx/gv0ZQfOPuXw25SAZ3x3mrGiFs3sSuoQFibNEzVk
   rj7t/+HbnOv47S3jCy7IdZQt6OmO0+2FiEafGgIKWGUVUxSm27MDkWmsa
   YhZKpDoeI8FJKWB8GXRIT4jcV1xYEOYEkpU66vofD29vK5QsurrlqiZ0c
   ExSvwSYdYft0R/DTQEGwbRd30T0pHkPEzuT/5L1O9rwIzPcYp0q3fVovw
   N1TiyuXz5b3wy01BvxeHgW8+8j6zubUGEzqD1BZEaY4nL+sdpijqglE+K
   A==;
X-CSE-ConnectionGUID: tYkcwMoHRue//5/JZsVmZA==
X-CSE-MsgGUID: ZSH4vcBoQoWGuZMCrC01rQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199880"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199880"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:39 -0700
X-CSE-ConnectionGUID: nlACXApCRPuDY0QXHvTOlQ==
X-CSE-MsgGUID: rNZxRk8JRsmWn+lR2jNOeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593486"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:39 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Luck <tony.luck@intel.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v6 34/49] x86/boot: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:46:05 -0700
Message-ID: <20240520224620.9480-35-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240520224620.9480-1-tony.luck@intel.com>
References: <20240520224620.9480-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model but
boot code doesn't have all the infrastructure to use them. Hard
code the one CPU model number used here.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/boot/cpucheck.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/cpucheck.c b/arch/x86/boot/cpucheck.c
index fed8d13ce252..0aae4d4ed615 100644
--- a/arch/x86/boot/cpucheck.c
+++ b/arch/x86/boot/cpucheck.c
@@ -203,7 +203,7 @@ int check_knl_erratum(void)
 	 */
 	if (!is_intel() ||
 	    cpu.family != 6 ||
-	    cpu.model != INTEL_FAM6_XEON_PHI_KNL)
+	    cpu.model != 0x57 /*INTEL_XEON_PHI_KNL*/)
 		return 0;
 
 	/*
-- 
2.45.0

