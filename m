Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792443081;
	b=Kg6sBz++ThAyuEHS3dDtn+fZzHbBOdLja7aYRwBJCd4fLLY25Jd0+/JFt0/KxmKs55UI
	 wMbZZOgGVCEfj8M4klRqcenvWHXkrNbQEth2dE2HtKS4jA5FjL06r7LEnoIi4E5nAL4Z8
	 fZnWEsLeSIMyANqtSHe7DpICPTz2Bx6p0II+Fc5AFnMoesmmkx+QJ/jkHCoL8evFifR5a
	 kyptOk12pbPvfIAqjf4a65BVLghVtzAS4a16qTUej7R2W3Io5mKMdF/CEax64FNxZTEAu
	 qBRAygOQ7NiFeESEDztKP/0u+eRHg8Jt/cqUbeqGele1tfFa/SVeQ+Z6/9S1eJmHJng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443081;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=k1sNnZdMrY8Xw8RH0rFCdkCjaTS9ovoPnIf+IQOoRWQ=;
	b=mt7luo7lzV4FNuctruLsWoFMaOouJShvXhiMh6c3KEaWsT7qtpRgqGcaauZyu4WULy5g
	 MO2Tr3Jpxxl4yarLfHjvFPQCvrGxdwJlPeaROltKv3VLr2e6VXpj9uEKQMCYf/Wa3PZBg
	 RQ4Lkao4mdY2fOBQ20SPNiG5PllV38a6Nm3W+a9kly3xGSqZl55Rm/RPMEeAgWAEqVR70
	 MiFL8gWYyJZ9fX6YVRI7CnBBuxsAJedfhTaczVbhxo6BdYJARYQG8mMsmuX4IfPFyrOIG
	 Wv8xfIaMMqgUMYGXI8VbC2k0W/9O1hVawAvAkOfMyeUWDFFLlhLVz0evQQ7ujSlNJqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=R9fqLy8N;
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0E160A261A
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 20:51:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF0E160A261A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=R9fqLy8N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792443070; x=1823979070;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WYsdRrfJuaf/uEqJnoHVEx7Rgt1D5015c/sEvBLD9MI=;
  b=R9fqLy8N6Kyuxvzo7nIOBRHQlLLg/qA8Z+TwTwx/YrPoIRmUgVdVQkav
   mk1f8iM/k8S+FLYFWJXZlDxl3kmUSC+TWASGHiSYPkBPnsZqqms1jb5T6
   0VrKqN1QP2svcytRgmbA44r9QlJGSmVsgRYZ8oyiPhX41FNka6RLTFsVE
   Yf18kHh+qvGUNLSxCwJDat0LeT5G1oV8AZjMCn3xk/tQOsk8zJPonyxVM
   1rTsKJrRL8H/i7nJO4w5lfTYBvc4edDon6VTPDNBRmniB4vJoH2K7tUF3
   Hfqm6xquJBZd4fLZkBJP7W8WcJF4JfAt0lncf++bD2Ed6nEYmSmexiZkq
   Q==;
X-CSE-ConnectionGUID: qDq69jNLTme2/+tmtNqE4g==
X-CSE-MsgGUID: 7tDwmpB2Q8ieFXrBIRhubg==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1131303"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1131303"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:52 -0700
X-CSE-ConnectionGUID: PpbH1qWORWWHvfMSR/O21w==
X-CSE-MsgGUID: cHP7J4KpQE6FNtWuyRfPCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3008702"
Received: from spandruv-mobl5.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.87])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:52 -0700
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
Subject: [PATCH v14 22/24] x86/resctrl: Require 64-bit x86 for resctrl support
Date: Mon, 19 Oct 2026 13:50:29 -0700
Message-ID: <20261019205031.16977-23-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019205031.16977-1-tony.luck@intel.com>
References: <20261019205031.16977-1-tony.luck@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Intel Application Energy Telemetry (AET) provides event counts in 64-bit
MMIO registers. For accurate results these must be read with a single
64-bit load, which is only available to 64-bit kernels, so AET support
depends on X86_64.

AET is about to become an unconditional part of x86 resctrl instead of
being selected by the separate CONFIG_X86_CPU_RESCTRL_INTEL_AET option.
resctrl can then no longer be built for 32-bit kernels.

Make resctrl depend on X86_64, in preparation for removing
CONFIG_X86_CPU_RESCTRL_INTEL_AET. This drops resctrl support from 32-bit
kernels, in line with Dave Hansen's proposal [1] to document reduced
support for 32-bit x86. Keeping support for 32-bit kernels is not
worth it. Modern systems that support resctrl almost always have more
memory than can be addressed by a 32-bit Linux kernel.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/all/c6ab0c24-8931-4f0d-9be6-23498ab4c38b@intel.com/ # [1]
---
v14:
	New commit message.
---
 arch/x86/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 15fd9ec5ecac..06b5d0c4633e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -518,7 +518,7 @@ config X86_MPPARSE
 
 config X86_CPU_RESCTRL
 	bool "x86 CPU resource control support"
-	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
+	depends on X86_64 && (CPU_SUP_INTEL || CPU_SUP_AMD)
 	depends on MISC_FILESYSTEMS
 	select ARCH_HAS_CPU_RESCTRL
 	select RESCTRL_FS
@@ -541,7 +541,7 @@ config X86_CPU_RESCTRL
 
 config X86_CPU_RESCTRL_INTEL_AET
 	bool "Intel Application Energy Telemetry"
-	depends on X86_64 && X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
+	depends on X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
 	help
 	  Enable per-RMID telemetry events in resctrl.
 
-- 
2.56.0

