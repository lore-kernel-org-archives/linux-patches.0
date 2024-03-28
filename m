Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E80130E5D
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643309; cv=none; b=kGzSC3d/+/BfKTYRMOtwA3ceeFHGXXo20+97nydkkBkI4YkRaSnnx02cPzrBMbpTmCAQ1j+eNsHHHen09m+LMPmip1aI2eWO1Vs8ENAkbmVyqCd+GKUYyOGbfESfe2QdsCf821X05GIrdFRvF+mB98J9bYOfB+duq6yqlBIiNUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643309; c=relaxed/simple;
	bh=cqyzuAeGvuhZYodMb9AblLQW+gSz+JxsTr7KnJrT2no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brtBZE2iLMw4DwzFfScQdsYrHnm1n0pWnG1jmZUQ4RedTMvp4vAzbofgfFmPqlox3rYeDq2gmscyceRSA9Jd63tJOYZnRrCrz9KmPB1B6uV8ZkaG03suE9sWwaeNPEGEtiuxDzWb/d+n46kZmi1NtxlX63Xz6TfDJv7hj61KlCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dFT67xqk; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dFT67xqk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643306; x=1743179306;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cqyzuAeGvuhZYodMb9AblLQW+gSz+JxsTr7KnJrT2no=;
  b=dFT67xqkGmRABSE8UdKZL+P5RJO7BBYQlUx3qEkLtwLbPha8E1mEJqGI
   kF7meS+hJzbnYGvMAYQi0miX0/PMEIT4nICUhl0ns8sNgY49g1j9Q24mI
   3LvnDsciRzkOh8XMkQBB7SUWeLGYY7dt/L6sNOsufiJU2c+UqZeCs565V
   HvAzZL+mXUnIo7/NfrftvInQGz/De0tfUyuyh8b99yET0yva4+1HYklLr
   p1IvfMIeBe8O3y/LDloir4HGS6bN1Ho56J/Use1LYnkp69MkonfMlNHc+
   oIgpHHRrkh7VD6bEbJ4LvCWl44WkwXu1FFI7x9rILO/cq3NpUZudsn+JJ
   Q==;
X-CSE-ConnectionGUID: Flxp/H73QXCpBq0901jE3Q==
X-CSE-MsgGUID: 60kYX0wCRiWc1zX7MncVdg==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294735"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294735"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16725987"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 13/74] x86/cpu/vfm: Update arch/x86/events/rapl.c
Date: Thu, 28 Mar 2024 09:27:07 -0700
Message-ID: <20240328162820.242778-13-tony.luck@intel.com>
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
 arch/x86/events/rapl.c | 84 +++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/arch/x86/events/rapl.c b/arch/x86/events/rapl.c
index fb2b1961e5a3..45b62ef451aa 100644
--- a/arch/x86/events/rapl.c
+++ b/arch/x86/events/rapl.c
@@ -766,48 +766,48 @@ static struct rapl_model model_amd_hygon = {
 };
 
 static const struct x86_cpu_id rapl_model_match[] __initconst = {
-	X86_MATCH_FEATURE(X86_FEATURE_RAPL,		&model_amd_hygon),
-	X86_MATCH_INTEL_FAM6_MODEL(SANDYBRIDGE,		&model_snb),
-	X86_MATCH_INTEL_FAM6_MODEL(SANDYBRIDGE_X,	&model_snbep),
-	X86_MATCH_INTEL_FAM6_MODEL(IVYBRIDGE,		&model_snb),
-	X86_MATCH_INTEL_FAM6_MODEL(IVYBRIDGE_X,		&model_snbep),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL,		&model_hsw),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_X,		&model_hsx),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_L,		&model_hsw),
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_G,		&model_hsw),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL,		&model_hsw),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_G,		&model_hsw),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_X,		&model_hsx),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_D,		&model_hsx),
-	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNL,	&model_knl),
-	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNM,	&model_knl),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_L,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_X,		&model_hsx),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE_L,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(CANNONLAKE_L,	&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT,	&model_hsw),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_D,	&model_hsw),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_PLUS,	&model_hsw),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_L,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D,		&model_hsx),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X,		&model_hsx),
-	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE_L,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE_L,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GRACEMONT,	&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X,	&model_spr),
-	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X,	&model_spr),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P,	&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_S,	&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE,		&model_skl),
-	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE_L,	&model_skl),
+	X86_MATCH_FEATURE(X86_FEATURE_RAPL,	&model_amd_hygon),
+	X86_MATCH_VFM(INTEL_SANDYBRIDGE,	&model_snb),
+	X86_MATCH_VFM(INTEL_SANDYBRIDGE_X,	&model_snbep),
+	X86_MATCH_VFM(INTEL_IVYBRIDGE,		&model_snb),
+	X86_MATCH_VFM(INTEL_IVYBRIDGE_X,	&model_snbep),
+	X86_MATCH_VFM(INTEL_HASWELL,		&model_hsw),
+	X86_MATCH_VFM(INTEL_HASWELL_X,		&model_hsx),
+	X86_MATCH_VFM(INTEL_HASWELL_L,		&model_hsw),
+	X86_MATCH_VFM(INTEL_HASWELL_G,		&model_hsw),
+	X86_MATCH_VFM(INTEL_BROADWELL,		&model_hsw),
+	X86_MATCH_VFM(INTEL_BROADWELL_G,	&model_hsw),
+	X86_MATCH_VFM(INTEL_BROADWELL_X,	&model_hsx),
+	X86_MATCH_VFM(INTEL_BROADWELL_D,	&model_hsx),
+	X86_MATCH_VFM(INTEL_XEON_PHI_KNL,	&model_knl),
+	X86_MATCH_VFM(INTEL_XEON_PHI_KNM,	&model_knl),
+	X86_MATCH_VFM(INTEL_SKYLAKE_L,		&model_skl),
+	X86_MATCH_VFM(INTEL_SKYLAKE,		&model_skl),
+	X86_MATCH_VFM(INTEL_SKYLAKE_X,		&model_hsx),
+	X86_MATCH_VFM(INTEL_KABYLAKE_L,		&model_skl),
+	X86_MATCH_VFM(INTEL_KABYLAKE,		&model_skl),
+	X86_MATCH_VFM(INTEL_CANNONLAKE_L,	&model_skl),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT,	&model_hsw),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_D,	&model_hsw),
+	X86_MATCH_VFM(INTEL_ATOM_GOLDMONT_PLUS,	&model_hsw),
+	X86_MATCH_VFM(INTEL_ICELAKE_L,		&model_skl),
+	X86_MATCH_VFM(INTEL_ICELAKE,		&model_skl),
+	X86_MATCH_VFM(INTEL_ICELAKE_D,		&model_hsx),
+	X86_MATCH_VFM(INTEL_ICELAKE_X,		&model_hsx),
+	X86_MATCH_VFM(INTEL_COMETLAKE_L,	&model_skl),
+	X86_MATCH_VFM(INTEL_COMETLAKE,		&model_skl),
+	X86_MATCH_VFM(INTEL_TIGERLAKE_L,	&model_skl),
+	X86_MATCH_VFM(INTEL_TIGERLAKE,		&model_skl),
+	X86_MATCH_VFM(INTEL_ALDERLAKE,		&model_skl),
+	X86_MATCH_VFM(INTEL_ALDERLAKE_L,	&model_skl),
+	X86_MATCH_VFM(INTEL_ATOM_GRACEMONT,	&model_skl),
+	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X,	&model_spr),
+	X86_MATCH_VFM(INTEL_EMERALDRAPIDS_X,	&model_spr),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE,		&model_skl),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_P,	&model_skl),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_S,	&model_skl),
+	X86_MATCH_VFM(INTEL_METEORLAKE,		&model_skl),
+	X86_MATCH_VFM(INTEL_METEORLAKE_L,	&model_skl),
 	{},
 };
 MODULE_DEVICE_TABLE(x86cpu, rapl_model_match);
-- 
2.44.0

