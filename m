Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793740992;
	b=oNi5pNvWmYWgLgtr9nULHofR2shzKXZg9fHLhD0BBbRAYWsZF9IsFSbAwv2gEw6Y9jCK
	 15fu7Tb49FoEon6z3j3h2TOLXR0KheIMedXIe32wKSqkEdWBdJe2Zpa/2WQyQKxusjEzA
	 rQi9MFsPkMs68SxUNQJm2o2XQW2qnh/dXNsb36IcB8ehlNeKZ0EQ6e+pRKRSuaYjQqrM1
	 4SRcuVG5NnJ3AXhYd3VDR4yXrFvQV86CIACIYWJSAcDItEoV8aWU8XVGmLsxBeGVMJmWz
	 IA782BhymxNObbAjR+PjGxzPNzhSgoeneGaNXEOqgikdDTFgZXWtnxh8xUOJgzOvMvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793740992;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fwJS2tr1Rxb89A2TFS7+CmwlHzGipvKA6NK3QGClmVg=;
	b=Z+SJdUGEIGGxJviyceCFmabfNnkLLXLN/yaE3iGxgO5eKCJ53UGyC9u9NFqHEPR/RVcx
	 mzFc7mNjtxlQWtHuqi/hzmah6LyessaakJhsu1QF7J0VnG3o2o2hOh7ORoqiNx4+IIu8K
	 3pVBF+dME4n5jCa+VXG/HNOM/f7LRG7O4uLBRh0/AGw2icbUnU3juOB/31Solf40mtSq3
	 u9q9WznnJlwq4ZJdhWKYklA8PutatBGF62238DZ2hM7XGrUbO56OCPU0L0VZDJ5HnZ+xZ
	 QXCoGcp4Kj1jgVByxJ8DEq6fvWrHvzPSeo00W8drwc4cV3/ZiAnQ0RqNjDEYImdbFmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=LfTyP40c;
	arc=none smtp.remote-ip=192.198.163.11
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31DD606A328
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 21:23:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D31DD606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=LfTyP40c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793740991; x=1825276991;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5fsFBAMfv8hiL1Az+0v+EZko0qrMcQRRQnWCy199kIo=;
  b=LfTyP40cq8bK6Pc/R+isagMnV2rRt8UmceySfW2A+vFqTTPl5I8v2Ves
   jkqwhMxEc7KvpIFSn5aRO7/nD4gU7DDWe22ebnsHhcBl13wO9PANqx1MD
   XLVs1svKNKhY3qt/p5+G4NPHlRJtmFTS3FzS6TGRozgCNu3nw5AbDwj7g
   zJ3Hzwr/bSu0f/Xx7jZOFxDKDyGod2ndKRKt2UgRKjEUxyC9x3v8fgIzy
   lLZGvyJE8grNKqf84qcqxIIohe+miiyquwpCmzuurxlK21FxH17fRTkWz
   1glYguertXmC/YOlrgtejCUR4zeO3NYfPWFsDd8aKXN0/pUz0ZR0Fvtav
   A==;
X-CSE-ConnectionGUID: jM1dKuJNTTCMcM9riqmeWw==
X-CSE-MsgGUID: wAVdwQskRfOqgOpoVMH/eg==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2393466"
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="2393466"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 13:23:10 -0800
X-CSE-ConnectionGUID: wESkskv1QdKHqGmfiRw12w==
X-CSE-MsgGUID: mg/ht22LR7Oo094rPbZOlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="6624561"
Received: from rosenzwe-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.124])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 13:23:07 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH v2 02/11] x86/resctrl: Disable symmetric L2 CAT on Panther Lake
Date: Tue,  3 Nov 2026 13:22:45 -0800
Message-ID: <20261103212254.18314-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103212254.18314-1-tony.luck@intel.com>
References: <20261103212254.18314-1-tony.luck@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Panther Lake reports L2 CAT in the symmetric CPUID leaf even though the
feature differs between P-cores and E-cores.

Disable the symmetric l2cat option for Panther Lake so resctrl does not
enumerate this asymmetric feature as symmetric.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 7951cfd20da4..709075ffc706 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -1128,6 +1128,9 @@ static __init void __check_quirks_intel(void)
 	case INTEL_BROADWELL_X:
 		intel_rdt_mbm_apply_quirk();
 		break;
+	case INTEL_PANTHERLAKE_L:
+		set_rdt_options("!l2cat");
+		break;
 	}
 }
 
-- 
2.56.0

