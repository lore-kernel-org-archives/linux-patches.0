Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04C439281D
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 23:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774652564; cv=none; b=juXl90NTOTV/VEPgbCQxCYp15tuJiI/VbPlh8wenNkCld03lA/7Y2Y/kJ9hvGLEhJetQ1EAyngONHgO+GnUyGE0+bFXuaaBXnpSKOnM3w0IwGPGcWzgHMQOcoZQId89bh/dUCIcgVmBDzUytj/qb2PgN5t1jesYRcbQwRuOuK54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774652564; c=relaxed/simple;
	bh=p1P+ZN8u2jBEwcuU+cz9O1GwBYuc8jFJvKjGneOz9qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmhUDWr34GrqNLeFtOyRGM/3Rl7qYy4Rs/Uvkaq6lGvl++z6eovnfk2y9meh7PA0kk9JAXdMxQQgBAddA9r/8oC2qkGKPGZdQFGR8iUIjsGO+VDviMYfQlY0CKTk1iOa2wEy2pt/FIA4pEUO9acl+xKG3Y7K7fj3es0B0gZtrVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lej2xalF; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lej2xalF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774652563; x=1806188563;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p1P+ZN8u2jBEwcuU+cz9O1GwBYuc8jFJvKjGneOz9qA=;
  b=Lej2xalFtfzql6GWwFA9WRDWsz8erics8tkp/DPAA251vwGuRh7PhyBX
   PRK4milFF4WhAyzXorDzQkaUu0OP9dSpUxa1XyqgVJZJKt8as4H72+7Ou
   pZIvQeMYVs6UWb6IrhyGCPAA3bHt8LHMx16tCr+aYKthfYqn7lQA1gBRo
   uNv31YWa1n+BxSA5sPSfrrDGMO5qiPIRfJBHiAhcj/YWQSuGpa0Zjl3LC
   ojfLTRc/JTHiSZEDgKgDe+OJ5RXkL2ZMJ6K3mEhJnresgbnFE0uJNOkLQ
   5dAFK2R5Li3JVuFNg0ik5o4W86tMw3ykYRG/hl6uiqpiaO0EdlavSq+52
   A==;
X-CSE-ConnectionGUID: /SIyzAqeQ2GvxeYlvCwMyQ==
X-CSE-MsgGUID: vTKHJLY2S0OrQOwT6LSkDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="75613310"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="75613310"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:02:40 -0700
X-CSE-ConnectionGUID: 6S36lz5hRoyoLURNGnme9Q==
X-CSE-MsgGUID: E4wXtDk6QUmFWlLOYSaYVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="218816035"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.83])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:02:16 -0700
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
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 7/7] x86/resctrl: Downgrade dependency of AET on INTEL_PMT
Date: Fri, 27 Mar 2026 16:02:08 -0700
Message-ID: <20260327230208.18094-8-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327230208.18094-1-tony.luck@intel.com>
References: <20260323163452.25044-1-tony.luck@intel.com>
 <20260327230208.18094-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The INTEL_AET code now using symbol_get() to access the INTEL_PMT
enumeration functions so no requirement that they be built-in to
the base kernel.

Update the Kconfig dependencies.

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

