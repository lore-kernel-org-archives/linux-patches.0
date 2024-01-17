Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446AA249E5
	for <patches@lists.linux.dev>; Wed, 17 Jan 2024 19:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705519137; cv=none; b=RNjwzUaue1M7TpuDeo7zpzSsd+wQBAsFNtVUkAWT/vzeA7eHJj1VFc1/vJ4mF1+/dPddlE7SuCw260tnJopwKBFZe1k0v0CaLJ9tizcXHsC+/pP5347qO3I18Btpv2HDFiDqripBsm1ROe3IvWaOVUsRwHMTsBiFOHbI5Uoc9hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705519137; c=relaxed/simple;
	bh=GGQMmT5N9sfBSSRs9pcu+QkT7m+yWBsSw/myue7XHdc=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding; b=SoiDjrWH4YBv3zu9icedYhssaGqshh2fYtEWxMaQWmo49UpBYofSioT3yaZkHO8YXC7STnP6EUv2EIz/TuvGoU9XuhPe0omSwfGOfB796l+eeXjGmvay9rYQFSg3l67A9bmTBoqqzD6n+9ISFH8UW9nPaoengRWBCMEteqcBZ6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VtgDTjXh; arc=none smtp.client-ip=134.134.136.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VtgDTjXh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705519135; x=1737055135;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GGQMmT5N9sfBSSRs9pcu+QkT7m+yWBsSw/myue7XHdc=;
  b=VtgDTjXhiWLFxtaG4v1PyXK3+8F8QwQ9PVutBcyUVP0prdtND3bYYjXG
   VOzlJpjs8vxzEfMS6vwt+nCV590L0PQ5Su84Tn0g/W+zfxjVTm9F2hKYh
   yEJVCD6kAaeSEwVTOGSmkr6Tlzj2h8VL2aovErFaO6O4B6qyKL5E+Ps/A
   uBqBrhA8cAkqnApb+h0gnXWIUkvscyb/d8vHBb1KzbV2FHlb5c81AmIgG
   6Zr+8J3WnLBBk8JLDVJt1gVjaukvc/ve84V+SYglYEYb/2RfU7BE7Rj0q
   bbnWL36Gc8Ipr05qSHFyFyJti4ndpporjXCSGn6nRSojkaULQ86wT10jU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="466635010"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="466635010"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 11:18:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="32889661"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 11:18:55 -0800
From: Tony Luck <tony.luck@intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
	x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/cpu: Add model number for Intel Clearwater Forest processor
Date: Wed, 17 Jan 2024 11:18:44 -0800
Message-ID: <20240117191844.56180-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Server product based on the Atom Darkmont core.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/intel-family.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 197316121f04..b65e9c46b922 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -162,6 +162,8 @@
 #define INTEL_FAM6_ATOM_CRESTMONT_X	0xAF /* Sierra Forest */
 #define INTEL_FAM6_ATOM_CRESTMONT	0xB6 /* Grand Ridge */
 
+#define INTEL_FAM6_ATOM_DARKMONT_X	0xDD /* Clearwater Forest */
+
 /* Xeon Phi */
 
 #define INTEL_FAM6_XEON_PHI_KNL		0x57 /* Knights Landing */
-- 
2.43.0

