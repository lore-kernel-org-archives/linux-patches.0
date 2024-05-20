Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED73E37169
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245199; cv=none; b=nz+OZwolftIAJTZzUo8iehYYr1R8Su2c6vS7M1AByWB/1u4qOVOB/3JE5Rk5mqS6awT5rB5HVwNJBxg/wRskReyf7TB6O0GRgr8P/DgUHl4UbbcsVj3UGBUXra9gUBivpWA4DKuP36Gapy5ylGTyLrdOUhkanWUcbm91i2aSaf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245199; c=relaxed/simple;
	bh=fAvicYEUo7N506OzcEwxkas4C1y1eHYtbiBB7lA+htE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5KmwrOKJqMWMIGgldzt6/eNWXCTDlJOsgXRtzgqLEJf/4HWkAXkK2787ffsBmqfeOGWcyNGvIaP5SumcRS/3/szP3bSlursU+vNoZyt/IBIunZ46Htn4LxyzuTELbfiWlI47dJ/eRG1CSm9YerLuGhESsYFcXmoe8ocBVz4BPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VgkYkA9f; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VgkYkA9f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245198; x=1747781198;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fAvicYEUo7N506OzcEwxkas4C1y1eHYtbiBB7lA+htE=;
  b=VgkYkA9fJCfJwWTqJrAj5Ilh1CrX3jNdcn9siM4zG68q8hDWdICqn2rq
   PNtxcSe3Rnwnz2kG5YYYZ0J0DaRnp4jXhA02QSLPnEtIMBV/5x1gKbnFo
   a3uXYSCtNNAUp8qJH5M4NB+IZKLmRWYA38qs+I1MwLZz5V70uaXoE5sm9
   1olcg22De97EbkfVpcOa8hZ3mzqJaCKuFIVKnFLGsqMHnA+FvgzCOrAe7
   QpLNgBEpYJYgTOW8ss5J/T1YrInetMR3KWLQOS96JmzF0mqbM1tX9E9CM
   6aNaEsmMazMyrEyxR/dfHTWitHNIcToSgju+/QkeYAHvewYF+pPdY4wyu
   A==;
X-CSE-ConnectionGUID: mXYIbjqdRSK4SrhufDBNzQ==
X-CSE-MsgGUID: WgwJ99quQU6+Q/i2ARG1aQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199543"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199543"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:35 -0700
X-CSE-ConnectionGUID: BvlCwA5NSc6OcdylUaJZ4Q==
X-CSE-MsgGUID: MVc/I4PNQpijetxDdSbbUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593392"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:35 -0700
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
	patches@lists.linux.dev,
	Jithu Joseph <jithu.joseph@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v6 04/49] platform/x86/intel/ifs: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:45:35 -0700
Message-ID: <20240520224620.9480-5-tony.luck@intel.com>
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

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/intel/ifs/core.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index 7b11198d85a1..33412a584836 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -11,16 +11,15 @@
 
 #include "ifs.h"
 
-#define X86_MATCH(model, array_gen)				\
-	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 6,	\
-		INTEL_FAM6_##model, X86_FEATURE_CORE_CAPABILITIES, array_gen)
+#define X86_MATCH(vfm, array_gen)				\
+	X86_MATCH_VFM_FEATURE(vfm, X86_FEATURE_CORE_CAPABILITIES, array_gen)
 
 static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
-	X86_MATCH(SAPPHIRERAPIDS_X, ARRAY_GEN0),
-	X86_MATCH(EMERALDRAPIDS_X, ARRAY_GEN0),
-	X86_MATCH(GRANITERAPIDS_X, ARRAY_GEN0),
-	X86_MATCH(GRANITERAPIDS_D, ARRAY_GEN0),
-	X86_MATCH(ATOM_CRESTMONT_X, ARRAY_GEN1),
+	X86_MATCH(INTEL_SAPPHIRERAPIDS_X, ARRAY_GEN0),
+	X86_MATCH(INTEL_EMERALDRAPIDS_X, ARRAY_GEN0),
+	X86_MATCH(INTEL_GRANITERAPIDS_X, ARRAY_GEN0),
+	X86_MATCH(INTEL_GRANITERAPIDS_D, ARRAY_GEN0),
+	X86_MATCH(INTEL_ATOM_CRESTMONT_X, ARRAY_GEN1),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);
-- 
2.45.0

