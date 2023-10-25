Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22081328DD
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 20:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FDIM6HYS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698265522; x=1729801522;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Tx/oqlnThnDhAMKCPAHvbL3cNtSoCShemyiqSxP550Q=;
  b=FDIM6HYSVM62e4RMoaA41s5KU2SHMEQk2EY2gVRtIhqkgmsYHm8Wnk65
   QdXdv8N0CF/sEZAY/oXO7JjtKcBiaMdxEcio+3A9qbA4EXDtBdTRlMlkM
   NyOUtcN+yGC/3pF/pGZMO2iLPlSNUw+6PLvLgRTG/iBj8dGsCtD6rcd2b
   DGi5jQC+KdSCQH9QfZq1Y9AqBq61HvmZNkwvq4hO6dYjJsDo65CN+JR2g
   aG05iVUOFMJnC2uE1VHBI06C2fNq9TcdofJJ4NTDJmss9sDN+O/DpaN5W
   A7U88Y8ioFYCdmwClRn82RIjROZzjwMlkuYstVDOKth6wl0sRXZW06VtX
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="6012491"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="6012491"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 13:25:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="902673240"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="902673240"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 13:22:57 -0700
From: Tony Luck <tony.luck@intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
	x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/cpu: Add model number for Intel Arrow Lake mobile processor
Date: Wed, 25 Oct 2023 13:25:13 -0700
Message-ID: <20231025202513.12358-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For "reasons" Intel has code-named this CPU with a "_H" suffix.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/intel-family.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 5fcd85fd64fd..197316121f04 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -27,6 +27,7 @@
  *		_X	- regular server parts
  *		_D	- micro server parts
  *		_N,_P	- other mobile parts
+ *		_H	- premium mobile parts
  *		_S	- other client parts
  *
  *		Historical OPTDIFFs:
@@ -124,6 +125,7 @@
 #define INTEL_FAM6_METEORLAKE		0xAC
 #define INTEL_FAM6_METEORLAKE_L		0xAA
 
+#define INTEL_FAM6_ARROWLAKE_H		0xC5
 #define INTEL_FAM6_ARROWLAKE		0xC6
 
 #define INTEL_FAM6_LUNARLAKE_M		0xBD
-- 
2.41.0

