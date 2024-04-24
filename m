Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25EF16DEAD
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982509; cv=none; b=iSCkaEuq49Dkti/EH2Z0eHjtWHyOo0vuUxWIG5sTu2HSDibfAxEPree2hNJIZ7HKsWbPcD1Dlr4TKBdF9XUGcd3vy9y4W5lt0SOhvpW5xvpJs2kzOu0H9u2f92XCvhp3NpXsDsUuRC7VbwCRBfn/B2Zh25HggZZlJN7xnztGuh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982509; c=relaxed/simple;
	bh=ljYYX+5RyEwARkxEi545qAS3MvJiGaPOJYML2NIcM9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlvAjp5B4Y3XgWXWzBZVAEkNS5QBEdQQZ7EglvQkTfp88FKVLuCt9Mu+BEKQaFx+ESZZbJNAylPD3plDqjFRnPBk09BlW9gHCvAWDd7d9PrvB9ta2ggHTXlkL/bdORB+2zTbNjRIpVWRBGXWFJsfoDBRG2a7p5u1B/s6I9b5zNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JWxBovjW; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JWxBovjW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982508; x=1745518508;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ljYYX+5RyEwARkxEi545qAS3MvJiGaPOJYML2NIcM9A=;
  b=JWxBovjW4eF6j4bJDv6VZ1+YouiP/aP13y5co6JDJ1DQkX2xcVGOf8G0
   cEtbblKebd8PeP9GV32QToXEU+iBIrzxWY+ICBudbXLmo0FjQqsSzSgDI
   ytJQQxJsU65kti5QWfebccxXqWasnvSmex779EfFF0GElz1wiL2Dkbqlz
   WPYCCpIkC0eyJQsFouYAMrU8NP6ellMSXdXTgl2qbRLL0EnBbe2k0GKYc
   caQ9i1XY1Yu7xMccTWVm0ONLEifjvg1CXTup1vSKLUzJh4CN8SPAeky2r
   84XpszRqgh/yZ7aetxenj6X1tPoqps4rvgC/+fJ4Eve6kJmOr8pxkPfs3
   g==;
X-CSE-ConnectionGUID: BCoSRTh4TjCfBpAc6DrdgA==
X-CSE-MsgGUID: bNPdF5eWTUi5oQl9YVTxWQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9481800"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9481800"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:14:54 -0700
X-CSE-ConnectionGUID: wIyDnPmwTt2Z7zyczF/3LQ==
X-CSE-MsgGUID: OvHxs7oUSmyRwoiBU4H5Yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="29262591"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:14:54 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	linux-pm@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v4 12/71] powercap: intel_rapl: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:14:53 -0700
Message-ID: <20240424181453.41384-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424181245.41141-1-tony.luck@intel.com>
References: <20240424181245.41141-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/powercap/intel_rapl_msr.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/powercap/intel_rapl_msr.c b/drivers/powercap/intel_rapl_msr.c
index 35cb152fa9aa..733a36f67fbc 100644
--- a/drivers/powercap/intel_rapl_msr.c
+++ b/drivers/powercap/intel_rapl_msr.c
@@ -139,14 +139,14 @@ static int rapl_msr_write_raw(int cpu, struct reg_action *ra)
 
 /* List of verified CPUs. */
 static const struct x86_cpu_id pl4_support_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE_L, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GRACEMONT, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_TIGERLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_ALDERLAKE, NULL),
+	X86_MATCH_VFM(INTEL_ALDERLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_ATOM_GRACEMONT, NULL),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE, NULL),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_P, NULL),
+	X86_MATCH_VFM(INTEL_METEORLAKE, NULL),
+	X86_MATCH_VFM(INTEL_METEORLAKE_L, NULL),
 	{}
 };
 
-- 
2.44.0

