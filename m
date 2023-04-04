Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DEAC951
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 17:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680630434; x=1712166434;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rjejLiGUXIbOe7jQV21f4FmaJdek8+dj6WEcqUPlHmQ=;
  b=V7lBcUeM5NA1s89X7g+RE4xPcyLoaH/LpD2kxwDYYNAWJbfNtp7PDDUg
   CC9W0W5i9qZgN6UW+0l3KFg+GMoyk7mAWyVs4SZsgiNsx9HeyI6LaIPVD
   PbR7anbmBaaXyX+tXbLTC13bNurqT0fsqVEzYbsuyiWkOHDjWMu6ufpuG
   6VmEOua5TsWjdn1JjLEbhr/IFwL2Kb7TyOVGrlsiiCfKFhSZUVYvqu8DO
   jqEQnEHEV1upOTGNVNT41KSIZlZxdh/yKipFg6R/ZYLWhV4TWTudRslK2
   bPP5xi4dLXe/HfXjbniCozbnst47KR3Ny/E37MetktAhHnjpD5713FlD8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="340988617"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="340988617"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 10:46:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="686455309"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="686455309"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 10:46:50 -0700
From: Tony Luck <tony.luck@intel.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2] x86/cpu: Add model number for Intel Arrow Lake processor
Date: Tue,  4 Apr 2023 10:46:41 -0700
Message-Id: <20230404174641.426593-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324195932.241441-1-tony.luck@intel.com>
References: <20230324195932.241441-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Successor to Lunar Lake

Signed-off-by: Tony Luck <tony.luck@intel.com>
---

Changes in v2:

Boris: "URL will become stale sooner or later"
	Re-wrote commit without reference to Intel press release.

 arch/x86/include/asm/intel-family.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index cbaf174d8efd..b3af2d45bbbb 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -125,6 +125,8 @@
 
 #define INTEL_FAM6_LUNARLAKE_M		0xBD
 
+#define INTEL_FAM6_ARROWLAKE		0xC6
+
 /* "Small Core" Processors (Atom/E-Core) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */
-- 
2.39.2

