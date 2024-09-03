Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE6918DF90
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 17:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725384897; cv=none; b=c6OBrMznN4PAzN25DfRHY2JLZibxo0CCHpfVKPynKiI19h1cP/H3IdiNDQckPIGBjSDQRz1VOlRvIvgBCt+FXDLszS0EVxQNV94+yr0YoG2Bqts79FU0HExLCb5RK8M9QNa45I1F1c4lqB8zhKK8dazO/mBbTGRdUXGEan9LtEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725384897; c=relaxed/simple;
	bh=7zFa9+GlWtDjIZ/Wl3c7es83abZ/27P7Fsgc41gqdLM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CkB3eJDCahkHbruhuq2mI/5NutsGBe5GyglBQsM21uCTR/NJTDHZenjFRxzxi1Ie7j7lEP+OrNGXWUrLWVyf1QMSdnlN2xc/a7mDlI73tZf792I1QolsxKwJ4+uOKGdQsoubS6DQHysMr2FFd4mo8H9DW9g6idezxTQJXZikZwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F790yIkV; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F790yIkV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725384896; x=1756920896;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7zFa9+GlWtDjIZ/Wl3c7es83abZ/27P7Fsgc41gqdLM=;
  b=F790yIkVH5fc7loewJJpqsaEU6eSbylMbz4TRCj0T/ruQWVOHimB4fQC
   Qdj0LPjYp7n6lOW3e/W28G0rgfvNBvlRjfMLGz4X2FbPx5mG8PXmoI4Up
   bmcwRXqZW5fU2Mx1ipj6kgdgZy7vPjPNBx6s8eOTT9rC+5UX8IosTXW3e
   hwx9jHaLU0SSDShQFHPrYeead/TdfhGGHcIjf7wFeENUWs9WOpXGmU/2o
   9DBspstPI9YEIVzTWEMsnUejNFuCFrSxLc/T4ImOfyx4Dh+fpQ8cCQcel
   V2K/SFXbPIgtoLbnq1eRo8FSZO/zHy9DP+0FnbjaHmt7DQXNcdiAf9moZ
   g==;
X-CSE-ConnectionGUID: StKWtTVBQfa0BsudCbB7FA==
X-CSE-MsgGUID: h6VkGg03SD++ccRSF58phA==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="46528530"
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="46528530"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 10:34:55 -0700
X-CSE-ConnectionGUID: UgDc9cXVRt+HJKHbZZipQg==
X-CSE-MsgGUID: lE1O4ow9Sui0KKWHtgHugw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="65715870"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 10:34:54 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v8 0/3] Final pieces of Intel new families support
Date: Tue,  3 Sep 2024 10:34:40 -0700
Message-ID: <20240903173443.7962-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All except one of the precursor patches were merged to Linus' tree
in the v6.11 merge window. The exception is a one-liner that is in
the maintainer tree and linux-next, but didn't get pulled this time.

Here's that patch (cherry-picked from intel-next so it has Chanwoo
Choi's sign-off). Also the two cleanup patches that remove all the
old FAM6 specific infrastructure.

All on top of TIP x86/cpu branch.

Signed-off-by: Tony Luck <tony.luck@intel.com>

Tony Luck (3):
  extcon: axp288: Switch to new Intel CPU model defines
  x86/cpu/vfm: Delete X86_MATCH_INTEL_FAM6_MODEL[_STEPPING]() macros
  x86/cpu/vfm: Delete all the *_FAM6_ CPU #defines

 arch/x86/include/asm/cpu_device_id.h | 20 -------
 arch/x86/include/asm/intel-family.h  | 85 +---------------------------
 drivers/extcon/extcon-axp288.c       |  2 +-
 3 files changed, 3 insertions(+), 104 deletions(-)


base-commit: fd82221a59fa5ce9dc7523e11c5e995104a28cb0
-- 
2.46.0

