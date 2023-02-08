Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91D9361
	for <patches@lists.linux.dev>; Wed,  8 Feb 2023 17:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675877029; x=1707413029;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=APZX0G5IZa6GeGV9W55Z4my3mBh76dR803XupKW3Id8=;
  b=GhCK99VxDGI0tEUXUIQZQPqD72wKc5l2VLQ38vZFpvuB/TH9M7JHfTlV
   omDbuxXnK5Jj6xj4w5kR9xLdCl1VHIJt1NPgIaJjFliTYB5nS1UbpXlZN
   bN4UHQ9Ff3hDa1egbBnuPmfdYTb4xlgmgHNZeLCVshyg+4ZEmWepyvgmn
   NBxXpxvr4rGzpd39iDEI3pMxorX2xIGaiupxaK1WnwfTbNOzK0IRHjHpt
   orQ31aN/lQt6fRjCV5n71vV7m7QJJU0/OMqJg6w5g9Vqo4EcbrtnKi3Ay
   XVa7HoluQrGfEpPSRFYlPFdm/35rERxXi4Q1txSQtjBGGkknOa9C7utni
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="357262621"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="357262621"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 09:23:48 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="667325207"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="667325207"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 09:23:47 -0800
From: Tony Luck <tony.luck@intel.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/cpu: Add Lunar Lake M
Date: Wed,  8 Feb 2023 09:23:40 -0800
Message-Id: <20230208172340.158548-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kan Liang <kan.liang@linux.intel.com>

Intel confirmed the existence of this CPU in Q4'2022
earnings presentation.

Add the CPU model number.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/intel-family.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 347707d459c6..33a9682a183d 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -123,6 +123,8 @@
 #define INTEL_FAM6_METEORLAKE		0xAC
 #define INTEL_FAM6_METEORLAKE_L		0xAA
 
+#define INTEL_FAM6_LUNARLAKE_M		0xBD
+
 /* "Small Core" Processors (Atom/E-Core) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */
-- 
2.39.1

