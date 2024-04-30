Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEED18130F
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495898; cv=none; b=skjarGHVTqJ+IP4gvC5HC5ILYJ7LNl/Zu8X/l3qWqmUs/7pxK0BuFlbtwZ8PceoCGTHguxL6veeKA6DZv2AW2xvo0orO1MXGlv3Z+Pg1q2r0rijKAJiR2+qrEv107aDwiDPDWhNPvY77Vir6WW8H21mngzwW0TqN+ijbvzSgytk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495898; c=relaxed/simple;
	bh=kkF0kOmubRaABW0Hf14QsZUk5Z9XWIfvaI1+06NWDic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCHrve7Y41jHkb06p1+g5F/lB+AXiCV5F8be4LcJFswcOo0kesAPzURLUH6pCv5NEjG8qV+o6lSf1RKDLCUy0mjF188O8lcdYMgPqgxXg0s6vj5KokGecsy1THQDKUqK58P7sd3vqINm1EkOOtqFNt37f3QKDaapUdiwmH1WgZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VAIPBZBM; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VAIPBZBM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495897; x=1746031897;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kkF0kOmubRaABW0Hf14QsZUk5Z9XWIfvaI1+06NWDic=;
  b=VAIPBZBM6Fan9bj3wTzvPn5Q+xCyWbn0vdQHSU4/64tu+tyaHWEhRDzV
   Fi9U+FbrN/dPPtoy8N2Y9wIqkajX1bT38ll4SKawx0xHpNeb9c22oVNB0
   lLO3Vd0o41IKl41sk8R9BkOwfjveQ4M5n99Rt/7UTBk0SfwSwNvGyTu1T
   buGpLGBdPyCtpudVIJmnaewdeXWCHtfP5zyQr6ntuX3P9rkefgPz1QkTP
   Nbt0eDxNz1WjUDyMd5EjBhWAzVUY2/UFbC1FOpmLrLZoVhUn8S/N7Gli0
   SM2+Ww3qMzru7wZFpIV0Me2rIBPgUTh7ULx5eTDzCxsH9riTYhgFjdRSp
   A==;
X-CSE-ConnectionGUID: DVG5mSj8TJuNK88WwCx4lw==
X-CSE-MsgGUID: hYABDD8oQEqBiG0ptKrnbw==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075636"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075636"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:21 -0700
X-CSE-ConnectionGUID: N6+EOdB9SaSSOBvNYBrNlw==
X-CSE-MsgGUID: SQergmIjS4eho8Rfw9pcmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515416"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:11 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH v5 06/47] KVM: x86/pmu: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:19 -0700
Message-ID: <20240430165100.73491-6-tony.luck@intel.com>
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
Acked-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index c397b28e3d1b..2faa67a4bfb6 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -34,16 +34,16 @@ EXPORT_SYMBOL_GPL(kvm_pmu_eventsel);
 
 /* Precise Distribution of Instructions Retired (PDIR) */
 static const struct x86_cpu_id vmx_pebs_pdir_cpu[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, NULL),
+	X86_MATCH_VFM(INTEL_ICELAKE_D, NULL),
+	X86_MATCH_VFM(INTEL_ICELAKE_X, NULL),
 	/* Instruction-Accurate PDIR (PDIR++) */
-	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, NULL),
+	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X, NULL),
 	{}
 };
 
 /* Precise Distribution (PDist) */
 static const struct x86_cpu_id vmx_pebs_pdist_cpu[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, NULL),
+	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X, NULL),
 	{}
 };
 
-- 
2.44.0

