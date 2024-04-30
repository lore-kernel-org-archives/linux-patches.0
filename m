Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D3817F377
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 16:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714495896; cv=none; b=W0Oj56TSQzXwtSDcjc5ZwUq6Wp7eq2/ulsYwTex5SMsmDwFSyzfJX8PpuAp6GEuKHQ/oi+8aQGTy+H9fCYNl7mvuDaf62tdWbICwLGyZAyjj9rf8tuhrVN9NkKgZGCkcH4k0ylJyPmA+OljCdeuOLiE4bCik5VjxlutQqN/iC68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714495896; c=relaxed/simple;
	bh=DeoNg6vE2dUVTJ0VP57n/7LnvyNJiz2+PFZomKP9EJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1KTvxq+p5qwQWaAYhucN/C1HVVyg3h6GxN8Zd2rg9MDnep6P+SkOsnmYKmWZtpEdXe+s4bdOdwAoIxLkE06av9UKi7zYphtSvlEgN63EsLnv49cudgqwMjJmE6H197cr8lUy9MqN++11/xgbU4cQN4hgkoyAuw8q8KOBKqUdtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=caIbz4mc; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="caIbz4mc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714495895; x=1746031895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DeoNg6vE2dUVTJ0VP57n/7LnvyNJiz2+PFZomKP9EJU=;
  b=caIbz4mcJpmRNzYcY9VZGet+OcV9VG3Dg5L0IAvh/F91wgzLKYl6t0gY
   9jVhJR1DPLt6MPW6mZwQxmXuNpTxVFDLFO9Zlo/4Fs0a4Bm4LxgBMRFfx
   UYf8dLEvijWodqGlSep0mof5bCu4K1YLrNce6yyECuPEl9Ws8J3USd/T+
   By0tVwo4pU6wRbDeTJfxWStVByOI+mrMrZJsN5iVB+RT/n5uHD3kOfdT1
   /SN47GoEY6yP0UijVHu6u6e1HVrLTC4HSdlqbEu2zBIgabDIU6yzVhWnr
   DHmzj3TvBZOO3/ghhJBegt+y9vi4eTLTHsmpIDvlmjW10HwNXfWLbHBnr
   Q==;
X-CSE-ConnectionGUID: o8UPF7kxShKHTsDMKbKpcw==
X-CSE-MsgGUID: I9zb04mLShiyEQo/6oFsCA==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="10075621"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="10075621"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:21 -0700
X-CSE-ConnectionGUID: n/yqzZ3GS+SyJsc0nM/bng==
X-CSE-MsgGUID: qE3u1aXnQZ67KmhvfgNQug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26515422"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 09:51:12 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v5 08/47] cpufreq: Switch to new Intel CPU model defines
Date: Tue, 30 Apr 2024 09:50:21 -0700
Message-ID: <20240430165100.73491-8-tony.luck@intel.com>
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
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/cpufreq/speedstep-centrino.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/speedstep-centrino.c b/drivers/cpufreq/speedstep-centrino.c
index 75b10ecdb60f..ddd6f53bfd2a 100644
--- a/drivers/cpufreq/speedstep-centrino.c
+++ b/drivers/cpufreq/speedstep-centrino.c
@@ -520,10 +520,10 @@ static struct cpufreq_driver centrino_driver = {
  * or ASCII model IDs.
  */
 static const struct x86_cpu_id centrino_ids[] = {
-	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL,  6,  9, X86_FEATURE_EST, NULL),
-	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL,  6, 13, X86_FEATURE_EST, NULL),
-	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 15,  3, X86_FEATURE_EST, NULL),
-	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 15,  4, X86_FEATURE_EST, NULL),
+	X86_MATCH_VFM_FEATURE(IFM( 6,  9), X86_FEATURE_EST, NULL),
+	X86_MATCH_VFM_FEATURE(IFM( 6, 13), X86_FEATURE_EST, NULL),
+	X86_MATCH_VFM_FEATURE(IFM(15,  3), X86_FEATURE_EST, NULL),
+	X86_MATCH_VFM_FEATURE(IFM(15,  4), X86_FEATURE_EST, NULL),
 	{}
 };
 
-- 
2.44.0

