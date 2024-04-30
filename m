Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BD61C9EAA
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495915; cv=none; b=jUCAOMKooMCYH59i1ETwxUFQ5BbhZ/ySWYe2ZpxX0hODNz4/24d5oZCOLm18iiokPeQRwQkGaAQz9i6yYAqv7u9HKOLbkGaWteJNHs/czJglS7yozPjkun8MMLZqWHkqg08Fy5D4bi3sXkzVfkNpAppHRdMXZ6TpCf2n9DzD7R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495915; c=relaxed/simple;
	bh=KI0qEXYT6wupWkGzuL3OY5xqFep3SpstABMy3/LeX9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODLLVjiylyCuRbomTzj3IIqLwxdJGTgBT7JV6zYibSHN8rMlN/55Hmb6mJYEHpNzetPX6oKP0fnAwNOJ5bOswL2+ANwkcCjBr9MJM59J5uyJHvN4Uqd7o2KnikznEO5y4vXXAYMQOho31SRtK+A/FG9hf1DBlBnEGemRI/au4jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aQyCFrZt; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aQyCFrZt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495913; x=1746031913;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KI0qEXYT6wupWkGzuL3OY5xqFep3SpstABMy3/LeX9E=;
  b=aQyCFrZtXAvbAbQseEqxXrBo8A6QgIikQWRGNld6UQKJvCrxwtV8sA7r
   4Y8HOKVon4TvZWUt0vLfVp+7xRfM0WzL/gFO+OOB2YXzQ7e47C/Dg7zFj
   ASs2xrBeBD6zW+DHKQg6UstvVSqLOcp7VB6oV7viCRplNVuxwQ4tDscoP
   7PaS+35mxkVageBP2dNMSmgaTV6tgtSuXUmOWzflJQTre1zc8hpA0UDD+
   /B20RJEdkgBz1Fy2LvOzTBhANXRI4OzJs8aUbsvOv0d5eMQwg18BK/4p+
   fH68gCZnMIR2YYveqLM8s8UaRhO4e9X0Mpskl7oD016RE8yQIo2tKPg68
   g==;
X-CSE-ConnectionGUID: 2E/O/JTpTEa3wXka82/jOA==
X-CSE-MsgGUID: 9ux3NFvcRZqE+bmCWorhvA==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075784"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075784"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:23 -0700
X-CSE-ConnectionGUID: vLqWvcXHQROUmtpcfjSoqw==
X-CSE-MsgGUID: A34n5mQ3RV+fPpMRYckiTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515522"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:20 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v5 42/47] platform/x86: ISST: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:55 -0700
Message-ID: <20240430165100.73491-42-tony.luck@intel.com>
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
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/intel/speed_select_if/isst_if_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
index 08df9494603c..96f3b221b6c8 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
@@ -719,8 +719,8 @@ static struct miscdevice isst_if_char_driver = {
 };
 
 static const struct x86_cpu_id hpm_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(GRANITERAPIDS_X,	NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ATOM_CRESTMONT_X,	NULL),
+	X86_MATCH_VFM(INTEL_GRANITERAPIDS_X,	NULL),
+	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT_X,	NULL),
 	{}
 };
 
-- 
2.44.0

