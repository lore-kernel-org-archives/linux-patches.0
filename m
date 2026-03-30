Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927C83A6B6E
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 21:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774907026; cv=none; b=KVgPAqDDY5M//dVR4ClsrYQ5htO7AYlH7FNRKTFN1yaSPex/WAVpVpQxoQFfj5Fh0yDdrGwujteQPLBhNBI02DUCd9KFUlM/T9crczBAflpHK6LkgKItAZGqAbiUc/PTLTnOcpXgDCxxAvLnAWO6oomysYidC6BoxyXpLbt4qDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774907026; c=relaxed/simple;
	bh=p1P+ZN8u2jBEwcuU+cz9O1GwBYuc8jFJvKjGneOz9qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOO28l5Dm/FT81TBeoiN1ywucC/gKAsgI++1FARBy63dfmlC1PnnZIjOp4fTUidlSkp+1kEyzpeD3VqGW+wqKvNy2o1BBPpgrAN0rcQSew8ZLbTsq1ybAOnJ5NVJeO/xuq8VePcfjSai1TQ4YEnCdJYuhMOgcg/9bL+GGd7cJJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UhF7v8cv; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UhF7v8cv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774907017; x=1806443017;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p1P+ZN8u2jBEwcuU+cz9O1GwBYuc8jFJvKjGneOz9qA=;
  b=UhF7v8cv9e4TBs6G4JEDdN81Jqu0rCHmQRvAct4yN3N2078H8fJDEAS5
   8GQQoVtlre1D/eR39s9GYFGC1pFAbqQl2JXe45bdG8w3F+SRY3Oc9rDLp
   Q0AeI2gsZsjpqUpjZqoCaUsk+I22oCXvn0iQKTrOFRImcBBE380zBqKxk
   dqA3lYQUsBmLZAg2UAlh57tiv84KMiq7hi+ixnA78cRi3/l1YPwDdPIdX
   lV3+A+7YvfsvwGD7gBWJHjuAglH1n8F4afdJjeAITh5l1mWO8LPr8NXZ1
   e0n+v+w+aTHG27LhMo1lSsv4neI+8/41AdWPGgypGiyusleh963aC6HqP
   Q==;
X-CSE-ConnectionGUID: dr9nVGCuQpitic3bxQsMNA==
X-CSE-MsgGUID: 8MlVRDhsS/uo+6H4P8wmNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="79772179"
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="79772179"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:43:35 -0700
X-CSE-ConnectionGUID: TZExhEX2QB2qJncrOL0Jmw==
X-CSE-MsgGUID: 2RfCne/uRi6uMvJE6GACxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="225185956"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.186])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:43:35 -0700
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
Subject: [PATCH v4 7/7] x86/resctrl: Downgrade dependency of AET on INTEL_PMT
Date: Mon, 30 Mar 2026 14:43:22 -0700
Message-ID: <20260330214322.96686-8-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330214322.96686-1-tony.luck@intel.com>
References: <20260330214322.96686-1-tony.luck@intel.com>
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

