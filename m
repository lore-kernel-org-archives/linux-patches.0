Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009EC7B
	for <patches@lists.linux.dev>; Wed, 27 Apr 2022 23:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651101071; x=1682637071;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PEHCXjXuGeH255YPGNEQTyRSOPX9oekMUvTMM96x13g=;
  b=RtJEPz7WEQzqJbLn9vqGxWxwkglEPDNzOyqGCt7ZVlRLXToygBQ6Zbev
   9QFpvZyV6rTcAbtzueNj8FEtja9VTtTWpiXLx0cLmpB50SRtcYaRKwOwZ
   fP/9U4UNIxLbvuhPmTWZ7kIZRNbWmJHGr2dmy2hr/zeb3/o1kHcddjDun
   SbwzdXSGYZM0TxYmxwWq9aiJOrbp5q9oN2Z+SCJ/iOR7aQ1s+4s9kj/wV
   4EAQWfvBnis2gUrsSgrwNBIw5cynKSjoTKRCEX8yM6uAWL7cESgGVzlat
   OklNwLRUQbPO5EXpzT1otgQv6/UxzReIY5oi723G3iM6aWrHfPOdqM94R
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="352532710"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="352532710"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 16:11:10 -0700
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="559263685"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 16:11:09 -0700
From: Tony Luck <tony.luck@intel.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/split_lock: Enable the split lock feature on Raptor Lake
Date: Wed, 27 Apr 2022 16:10:59 -0700
Message-Id: <20220427231059.293086-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Raptor Lake supports the split lock detection feature. Add it to
the split_lock_cpu_ids[] array.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index f7a5370a9b3b..24b473895635 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1230,6 +1230,7 @@ static const struct x86_cpu_id split_lock_cpu_ids[] __initconst = {
 	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X,	1),
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,		1),
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,		1),
+	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE,		1),
 	{}
 };
 
-- 
2.35.1

