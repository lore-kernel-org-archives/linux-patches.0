Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE903C13EF
	for <patches@lists.linux.dev>; Tue, 26 May 2026 22:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779833565; cv=none; b=i1OiokYh7HTk+019M0IWRCG1q3OFuUhpdh8Jvyz4i9MmZM1H6xcLCE0YkuaFBP0lT/XfDloJXOSHONLWYVGyv5LoOPX+QtsGMMIL5qTMKVY7FyUmqtsU2fVB5nq/DEDn2PfT42USmnU5Qjv5VCxobi9rT3OWc5bqZvPUN1E2zw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779833565; c=relaxed/simple;
	bh=ZEPcbsxwxGdJcpRaGAcw/RWDtCcjk7MT/SdgWQbw8aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gn2vISICRGSXtc+A4kUim/ByBFdATq0HJIPCF7O983Eu3PEv7i7w3FcaCWS3/m0Df+Vya9914WaUBjoyfXQgYk+BgdYLafWz8lvDUvAcb+KBKoDddse2e/0sCSTYmc42Jl7Xep2ZVm6QbuLnJDqZoCdWwWaiiYN1/cnQJS9Cpww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ltEYpJuK; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ltEYpJuK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779833564; x=1811369564;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZEPcbsxwxGdJcpRaGAcw/RWDtCcjk7MT/SdgWQbw8aQ=;
  b=ltEYpJuKw03O6ieze/v3oeWJ8Q9SGfMxFHJeHA4zSbaPVYXiaNaoOWEC
   AepqvXOBNTrbBGtZ76Zacnfo4wFI1TkzEEJReEWsBskvHFlefV0/UEOOv
   rJq9q25O8sBEqrBp/29by0mcAdW0mvlZ+ujicvFVFWY1vWCTpPcCCkIEA
   ruMIibEqFOwE0Ykdn0zlRKzkTDsmAtpMXHwwk5kD3s0jRKkcN8YyX8bgP
   YIhsWipn72Gj4CKBvxLsNOs0mMWc3QNJ4HivSX4Ynj8jjhFMxN7cRRTb+
   uRiBO9WUQLc3D2i+IL07TPVNxrhZ4uVRkpOCTqoDEaSs2hE4dBIYKUn9p
   w==;
X-CSE-ConnectionGUID: X44sn+nES9G9Ny5pk8ML5A==
X-CSE-MsgGUID: j52K9cqiS8Wwgn5KwIO8Zg==
X-IronPort-AV: E=McAfee;i="6800,10657,11798"; a="84516105"
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="84516105"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 15:12:44 -0700
X-CSE-ConnectionGUID: FQqUIygtSwSvrL85hwEWQQ==
X-CSE-MsgGUID: VlDjJlFGSXOCeDMPPre62Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="237622163"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 15:12:43 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: reinette.chatre@intel.com
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH RESEND v3 0/3] x86,fs/resctrl: Fix long-standing issues
Date: Tue, 26 May 2026 15:12:34 -0700
Message-ID: <cover.1779833414.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

V3: https://lore.kernel.org/lkml/cover.1779476724.git.reinette.chatre@intel.com/

Sashiko encountered failure while reviewing the original V3 submission of
this series. This partial submission of only the last three patches of V3
is only intended for Sashiko so that it can consider the patches missed during
V3 review.

This submission lists the last three patches as 1/3, 2/3 and 3/3 since Sashiko
considers a submission only consisting out of 7/9, 8/9, and 9/9 as "incomplete":
https://sashiko.dev/#/patchset/cover.1779832265.git.reinette.chatre%40intel.com

Reinette Chatre (3):
  fs/resctrl: Prevent deadlock and use-after-free in info file handlers
  x86/resctrl: Ensure domain fully initialized before placed on RCU list
  fs/resctrl: Fix UAF from worker threads when domains are removed

 arch/x86/kernel/cpu/resctrl/core.c      |  18 +-
 arch/x86/kernel/cpu/resctrl/intel_aet.c |   5 +-
 fs/resctrl/ctrlmondata.c                |  38 ++--
 fs/resctrl/internal.h                   |   3 +-
 fs/resctrl/monitor.c                    | 100 ++++++----
 fs/resctrl/rdtgroup.c                   | 244 ++++++++++++++++++++----
 6 files changed, 301 insertions(+), 107 deletions(-)

-- 
2.50.1

