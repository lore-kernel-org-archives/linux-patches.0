Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2700133D9
	for <patches@lists.linux.dev>; Tue, 23 Aug 2022 17:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661276916; x=1692812916;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3DXsFiehmOWjIK0HPPx03C/izDXYsGR9JU9dpMMy13M=;
  b=mjBh2S5SCaT+H/82lL0cmVAvfFJ2ifvvo+LbWPM/NmrPaTzibZnZ1D0A
   4aMNycHW/KwXb6ZxPgjEUIvyZrGLNw3Bw+pRShh9aofJgJro2ZhHGlDkj
   nddVMu/ZZZkiQasP19enxdFwLL1JclCQoL2mQ7y7Jf1XeAgAAxfAcyouw
   6mLt17e0xUlZ5nhRLsFCD0SuD3daf98WcKeoxGBYL/T/gxymN1ZmSlKGP
   PfL2pV1ZKi1JYP1tuHulFsbSgQQfNbiuvsFY0XUI2C1qXeQlO4LYd/VYL
   DuMd0utOiUctKsC8w8h15DlnV6+ji1pTwynnOjePrAlLwfQt4kPU9uMTj
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="292500055"
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="292500055"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 10:48:35 -0700
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="612493072"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 10:48:35 -0700
From: Tony Luck <tony.luck@intel.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/cpu: Add new Raptor Lake CPU model number
Date: Tue, 23 Aug 2022 10:48:19 -0700
Message-Id: <20220823174819.223941-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Note1: Model 0xB7 already claimed the "no suffix" #define for a regular
client part, so add (yet another) suffix "S" to distinguish this new
part from the earlier one.

Note2: the RAPTORLAKE* and ALDERLAKE* processors are very similar from a
software enabling point of view.  There are no known features that have
model-specific enabling and also differ between the two.  In other words,
every single place that list *one* or more RAPTORLAKE* or ALDERLAKE*
processors should list all of them.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/intel-family.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index def6ca121111..aeb38023a703 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -27,6 +27,7 @@
  *		_X	- regular server parts
  *		_D	- micro server parts
  *		_N,_P	- other mobile parts
+ *		_S	- other client parts
  *
  *		Historical OPTDIFFs:
  *
@@ -112,6 +113,7 @@
 
 #define INTEL_FAM6_RAPTORLAKE		0xB7
 #define INTEL_FAM6_RAPTORLAKE_P		0xBA
+#define INTEL_FAM6_RAPTORLAKE_S		0xBF
 
 /* "Small Core" Processors (Atom) */
 
-- 
2.35.3

