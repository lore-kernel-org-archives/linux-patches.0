Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0731F39A803
	for <patches@lists.linux.dev>; Fri, 10 Apr 2026 20:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775851551; cv=none; b=Qu1Ewy/B3mkUxdq0Y7BZbKOZJCgSnYuqXf4I4zkHMTT7TUONCtbpCd7gIGDEOPTC/xPGeFWU51vVBVVzt1eNbbGlRnqomBn8C2l3a9sEag01QUHUUBRVPBDC+B2b1enY3f8yW7KjWh2n2NhslfRWLZ7XCFLv8g96ty6aKrS/F4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775851551; c=relaxed/simple;
	bh=7BKmVp4Jak6CUpTsD40UwX1nrKrmQl1rsGLW3/TW0C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwIEF678VXBbJuBqeLa0ctsZuB1W27PvGRrltrnOKjWhjt8L6WBaFP1wgMJnodHV2PksFMyuahc9eYSBp16niX/db2vSx1yYyof4DiUQJbssKsjgFcEud7q6cXvq2pD5+7at67iRUbzLXuKRjmTMFcKX2ZEiEGAnfqpmC/0Bj4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oj/7e2Tr; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oj/7e2Tr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775851545; x=1807387545;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7BKmVp4Jak6CUpTsD40UwX1nrKrmQl1rsGLW3/TW0C0=;
  b=Oj/7e2TrnNHWf3Sl7/fR7bXcJqokreI+b+FP2Euyfw+YerNRzhDgJLAK
   N4g/LBrFgJBXCag1Ozvm/XIEP7BJpEr+uAkTYXHOk8nJe9FupPWU+69Hj
   gaf7hON7/Ugjg2C2aoHlU/pO/XpdRp88f5UfeRdjvtI9JvlVTL3jvg3s+
   KE1K9rwQkP+bm7k1vHsbRWj+ZX3XyaePiKdt1TDE/qB+dOqLzOjdV0eI7
   oHOqWVlPGNKILi+O00a7d/5wYglgKos9KupoA4yzCTw8HTkpxDbQDSz3h
   W11PQudeWj4Pgdc0vFBrzgRinrPfuIhDrL34xslmg+CD0to894dqCzcB0
   A==;
X-CSE-ConnectionGUID: bI8FUNqrTs6vfGkOtyOz4g==
X-CSE-MsgGUID: UVt8ZGdATZqpZ9uQyVvh3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11755"; a="76898118"
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="76898118"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 13:05:42 -0700
X-CSE-ConnectionGUID: 71undcw1QP2KzOdcCojFXw==
X-CSE-MsgGUID: jEN7YwvcSd+y+I9aAejhDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="228155035"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.106])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 13:05:41 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH v5 7/7] x86/resctrl: Relax Kconfig dependency on INTEL_PMT_TELEMETRY
Date: Fri, 10 Apr 2026 13:05:32 -0700
Message-ID: <20260410200532.58602-8-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260410200532.58602-1-tony.luck@intel.com>
References: <20260410200532.58602-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that AET resolves PMT symbols at runtime via the registration API,
INTEL_PMT_TELEMETRY no longer needs to be built-in.  Relax the Kconfig
dependency so that INTEL_PMT_TELEMETRY can be configured as a loadable module.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e2df1b147184..1a60da62da33 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -542,7 +542,7 @@ config X86_CPU_RESCTRL
 
 config X86_CPU_RESCTRL_INTEL_AET
 	bool "Intel Application Energy Telemetry"
-	depends on X86_64 && X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
+	depends on X86_64 && X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY != n && INTEL_TPMI != n
 	help
 	  Enable per-RMID telemetry events in resctrl.
 
-- 
2.53.0

