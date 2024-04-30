Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67AE1C0DD1
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495908; cv=none; b=ufVFl277R/Wdxm3zQW3I7EKAAhFudidpE4xaLp7i5BW+0UTGk2eLyUt4ZvjUO6LyhoKvOTW7Px3gla3VVmA5rKW4hdGXjeHW4aYHK6PuEvIAeNIJsM/8wdi3LPlw/Q8PML3LSHeWMMbuMVEspJlKr65o6SRC8NrO+y98/MJPl38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495908; c=relaxed/simple;
	bh=/JbFqsT4QboTVC5nN5+7Tn0VrIVjmy0ALnM5ZmCJwqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/4e4PdCyMXjD6bDYgz95S982DyAjX4sWn4VBRJ4u/JAMSN5WLGXQJbttEMyGGz4YPualhyYolUcueLqFPD3CeOx71JiqupfUcGUXUvxaXXL24F1b8HaDkCCHbzsXsQoV1Lv7984lm0G58Gd9Hq9yUaVqf5ZkIeCXwed98jjt/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CYSrGovo; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CYSrGovo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495907; x=1746031907;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/JbFqsT4QboTVC5nN5+7Tn0VrIVjmy0ALnM5ZmCJwqg=;
  b=CYSrGovojppHF7LB5n5IxXYwsguNJKHDlN8iyo3mtqjKrIxP8eKdY9tI
   XKLkgjI5XdJB0fXz6j0s2Dh+4JFW6oKe2jC9TezHmn2uL8oLznjEOMIA4
   CVaT6dhGsD7kFcwF9XKU/vRjJITzgWoGGfLyVTL6bJ49L9V37JCwvgkLo
   gwPOwCu4xqEwoUV+Kck8cMZUp1hwTOG/CztnTNyFxd9E1kuOehDCsQKrD
   xHRCPpwHbA8qQIRQFCtEkocRyIcwqZeJvqffpEOWnpZasUOEyqohul+W0
   FypE3u8GmeGTa0qGaco9M54g2EiQ86n0ys60++ACNisK5cJJ6nPAcnF94
   A==;
X-CSE-ConnectionGUID: Cvy7Q94SR5GqNU6nlYbqNg==
X-CSE-MsgGUID: Jbg4FHKiS/6xGqtxT73o/Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075738"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075738"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:23 -0700
X-CSE-ConnectionGUID: R7a3kwDARDe5wiji/wbUkw==
X-CSE-MsgGUID: bg3AbzpATYiqGL4g0vHHAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515501"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:19 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 33/47] EDAC/i10nm: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:46 -0700
Message-ID: <20240430165100.73491-33-tony.luck@intel.com>
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
 drivers/edac/i10nm_base.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/edac/i10nm_base.c b/drivers/edac/i10nm_base.c
index 3fd22a1eb1a9..24dd896d9a9d 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -942,16 +942,16 @@ static struct res_config gnr_cfg = {
 };
 
 static const struct x86_cpu_id i10nm_cpuids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(ATOM_TREMONT_D,	X86_STEPPINGS(0x0, 0x3), &i10nm_cfg0),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(ATOM_TREMONT_D,	X86_STEPPINGS(0x4, 0xf), &i10nm_cfg1),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(ICELAKE_X,		X86_STEPPINGS(0x0, 0x3), &i10nm_cfg0),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(ICELAKE_X,		X86_STEPPINGS(0x4, 0xf), &i10nm_cfg1),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(ICELAKE_D,		X86_STEPPINGS(0x0, 0xf), &i10nm_cfg1),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(SAPPHIRERAPIDS_X,	X86_STEPPINGS(0x0, 0xf), &spr_cfg),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(EMERALDRAPIDS_X,	X86_STEPPINGS(0x0, 0xf), &spr_cfg),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(GRANITERAPIDS_X,	X86_STEPPINGS(0x0, 0xf), &gnr_cfg),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(ATOM_CRESTMONT_X,	X86_STEPPINGS(0x0, 0xf), &gnr_cfg),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(ATOM_CRESTMONT,	X86_STEPPINGS(0x0, 0xf), &gnr_cfg),
+	X86_MATCH_VFM_STEPPINGS(INTEL_ATOM_TREMONT_D,	X86_STEPPINGS(0x0, 0x3), &i10nm_cfg0),
+	X86_MATCH_VFM_STEPPINGS(INTEL_ATOM_TREMONT_D,	X86_STEPPINGS(0x4, 0xf), &i10nm_cfg1),
+	X86_MATCH_VFM_STEPPINGS(INTEL_ICELAKE_X,	X86_STEPPINGS(0x0, 0x3), &i10nm_cfg0),
+	X86_MATCH_VFM_STEPPINGS(INTEL_ICELAKE_X,	X86_STEPPINGS(0x4, 0xf), &i10nm_cfg1),
+	X86_MATCH_VFM_STEPPINGS(INTEL_ICELAKE_D,	X86_STEPPINGS(0x0, 0xf), &i10nm_cfg1),
+	X86_MATCH_VFM_STEPPINGS(INTEL_SAPPHIRERAPIDS_X,	X86_STEPPINGS(0x0, 0xf), &spr_cfg),
+	X86_MATCH_VFM_STEPPINGS(INTEL_EMERALDRAPIDS_X,	X86_STEPPINGS(0x0, 0xf), &spr_cfg),
+	X86_MATCH_VFM_STEPPINGS(INTEL_GRANITERAPIDS_X,	X86_STEPPINGS(0x0, 0xf), &gnr_cfg),
+	X86_MATCH_VFM_STEPPINGS(INTEL_ATOM_CRESTMONT_X,	X86_STEPPINGS(0x0, 0xf), &gnr_cfg),
+	X86_MATCH_VFM_STEPPINGS(INTEL_ATOM_CRESTMONT,	X86_STEPPINGS(0x0, 0xf), &gnr_cfg),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, i10nm_cpuids);
-- 
2.44.0

