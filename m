Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1B1469843
	for <patches@lists.linux.dev>; Wed, 29 Jul 2026 17:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785346084; cv=none; b=XYLj/A+DD1fBS3M/DdyO2v9eH2YYPNzEdSwmQ/I7pe6CRtgS+rzWlJV6Hswxl0hD/KeQRL+jY45fHOQ7eUzGnfQbaEKdM9zPWS/8WRiirbcB0/IhNGndZ6knf3rgHHsbRuz0Comtv0CBgF9qUsmYuUhoFs4DsF8faK0eCpCAGs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785346084; c=relaxed/simple;
	bh=b/Y9b11eCewCizECX0FkrMSQKmvy4W1xK4zbXsP02cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pt8i56lMsddyo5ITg/pLe2M/7N1BJa0izXD4yWadxugAnKFIprCcuddbsoefuP9Ss64qNgdUm52v9BOShwOebBpB/QGX39ByHSQTKdjYBHCCq2mSM/jfkzDOVkl71LZk9JmgrEngg6DzwCYxqr0LJjFupPnlM3GQH9LPhxKb/sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=go5RdwIk; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="go5RdwIk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785346083; x=1816882083;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b/Y9b11eCewCizECX0FkrMSQKmvy4W1xK4zbXsP02cg=;
  b=go5RdwIkOXxQ0Or6h++SalEkQy31RXUMB+wJ2q04nMbBktJRjcHaSevs
   pCwZ/S6sCDeS3K+kNLi3tMVEOvFQgOwymkS1OnpMjc8XgWsCihjb/1Drk
   k43+d9Jmo1P00JHLf27x72Wef3sfvROXLeK/JLazDUF/vNIUVG/lLmb5y
   iLLKg883t5HfQj0TKUBcMe9mnG4GlPY+dkDJN/WD5rOCYHWgcJt8QtoZ4
   kyogfWr7swJ5Cok0Acg8U8HqYVdVadYIRpcTa+rj77zObwcOghFG7FOfH
   O748QBnb+PxWQiJlwhYplXlCdCTpfGI6xqTsSzVfN0H2JZufLVTmQfGqp
   A==;
X-CSE-ConnectionGUID: KiT0yKrjTYiVyOkAUzuYSg==
X-CSE-MsgGUID: 9ezttxnGSmSU+xQfBsYz5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="97473565"
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="97473565"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:00 -0700
X-CSE-ConnectionGUID: ubeLygm+TK2K2Csr1HlgUw==
X-CSE-MsgGUID: zFbr0poVTzWe4hkYFY7tUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="262024549"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.238])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:00 -0700
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
	Hongyu Ning <hongyu.ning@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v10 02/17] x86/resctrl: Require 64-bit x86 for resctrl support
Date: Wed, 29 Jul 2026 10:27:37 -0700
Message-ID: <20260729172752.11561-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729172752.11561-1-tony.luck@intel.com>
References: <20260729172752.11561-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chen Yu <yu.c.chen@intel.com>

All known hardware that supports Intel RDT or AMD QoS is 64-bit. Future
enhancements like MMIO-based Enhanced RDT (ERDT) monitoring require
readq()/writeq() which are only available on 64-bit. There is also no
realistic use case for users to build a 32-bit kernel on a server and
enable resctrl.

Drop 32-bit support by changing the X86_CPU_RESCTRL dependency from X86
to X86_64.

Since X86_CPU_RESCTRL now implies X86_64, remove the redundant X86_64
dependency from X86_CPU_RESCTRL_INTEL_AET.

Tested-by: Hongyu Ning <hongyu.ning@linux.intel.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v10:
	New patch. Split out from the "Simplyfy Kconfig" patch in
	v9.  Chen Yu also needs this for his MMIO enabling patches,
	so I've just copied his patch.

 arch/x86/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bdad90f210e4..6685e120cff3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -514,7 +514,7 @@ config X86_MPPARSE
 
 config X86_CPU_RESCTRL
 	bool "x86 CPU resource control support"
-	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
+	depends on X86_64 && (CPU_SUP_INTEL || CPU_SUP_AMD)
 	depends on MISC_FILESYSTEMS
 	select ARCH_HAS_CPU_RESCTRL
 	select RESCTRL_FS
@@ -537,7 +537,7 @@ config X86_CPU_RESCTRL
 
 config X86_CPU_RESCTRL_INTEL_AET
 	bool "Intel Application Energy Telemetry"
-	depends on X86_64 && X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
+	depends on X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
 	help
 	  Enable per-RMID telemetry events in resctrl.
 
-- 
2.55.0

