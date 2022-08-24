Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E6E6716
	for <patches@lists.linux.dev>; Wed, 24 Aug 2022 17:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661363848; x=1692899848;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f/Wy77xPvMogLyGL99b3MLpib/d02/LgmpIGjWGoH+w=;
  b=CFNPJAa3hBNh9ovOmELowGGIVO70Et5uTQIDoOziI+c8+vGFp9cHfX15
   jDmGmeW8lqa8nkOKuL92oOgIQGeHdwr4TcO5erzXv6NqJZvB+n61PTRvM
   50C1ETp5axFnjXzFZ4swLnh5PjeCYbjQ2AFlQvp7slcH+UDjbM/EmCK8C
   Rte55/upUPIpaWsAs04nYVljeqEG5BZl3Hm7z9q7aYjRHuaSjlrWaa++O
   o1066EaWf1YOs7A3qmMK78LTSD335UiqLNw/845tkvIRsVfimUvJUnqrl
   uS4CrnEu8h2CKQe/diGQiPil/aQyzqqwHlpnYCtwTQcsNTqO44uJgyq3E
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="274425470"
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="274425470"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 10:57:27 -0700
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="670614087"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 10:57:26 -0700
From: Tony Luck <tony.luck@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/cpu: Add CPU model numbers for Meteor Lake
Date: Wed, 24 Aug 2022 10:57:18 -0700
Message-Id: <20220824175718.232384-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add model numbers for client and mobile parts.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---
These are destined for release in 2023 on Intel 4 process node.

As is the custom, I'm just adding the model numbers so perf, power
etc. teams can added model specific code to their respective subsystems

Patch based on tip x86/urgent branch

 arch/x86/include/asm/intel-family.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index aeb38023a703..5d75fe229342 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -115,6 +115,9 @@
 #define INTEL_FAM6_RAPTORLAKE_P		0xBA
 #define INTEL_FAM6_RAPTORLAKE_S		0xBF
 
+#define INTEL_FAM6_METEORLAKE		0xAC
+#define INTEL_FAM6_METEORLAKE_L		0xAA
+
 /* "Small Core" Processors (Atom) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */

base-commit: cdaa0a407f1acd3a44861e3aea6e3c7349e668f1
-- 
2.35.3

