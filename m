Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E621323E
	for <patches@lists.linux.dev>; Tue, 23 Aug 2022 17:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661276743; x=1692812743;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=g3N8QaZ47KTjxRr1VmyrexxfaDyUTuIj7D/06GMA7EQ=;
  b=V+iL0DVojY+nvGgLTu3m6arUJ2SYraOm2VGykcPwIX7ZJKOd4dkYpYhN
   mdNJF+sh+3hFMFCQGAWknVQ6TuT3K05RHfWgEccQ29hRNsBhnaCrSXhLH
   U4wyuY0zqQJEOQNAVmT76eB5dl3lg7iskpzeE59od8WACa5OkkEmenHvt
   643YDvBnKqOqnFnT4WiUhdaYHeyUjH2GLWdrDSLZtr8adrfjBnHvpuD78
   CaX0xRHByaBStBhFqM/KJLp72UtKctI88UaHhok8z/NeV157W8Drq7ngD
   nPtsxolfaanwIIlXfttfNAnfNysgd0heFNjXGM4rsm1VVAulrh9rh1I9t
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="295038674"
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="295038674"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 10:45:43 -0700
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="642530901"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 10:45:43 -0700
From: Tony Luck <tony.luck@intel.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/cpu: Add yet another Raptorlake CPU model number
Date: Tue, 23 Aug 2022 10:45:30 -0700
Message-Id: <20220823174530.223914-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a second model number used by Raptorlake client CPUs.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/intel-family.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index def6ca121111..c4e316921dd5 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -22,6 +22,7 @@
  *		Common OPTDIFFs:
  *
  *			- regular client parts
+ *		_S	- other client parts
  *		_L	- regular mobile parts
  *		_G	- parts with extra graphics on
  *		_X	- regular server parts
@@ -112,6 +113,7 @@
 
 #define INTEL_FAM6_RAPTORLAKE		0xB7
 #define INTEL_FAM6_RAPTORLAKE_P		0xBA
+#define INTEL_FAM6_RAPTORLAKE_S		0xBF
 
 /* "Small Core" Processors (Atom) */
 
-- 
2.35.3

