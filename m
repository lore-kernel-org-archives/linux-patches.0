Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5CE41768
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 19:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lHSYM/Gw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696535752; x=1728071752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EDSMQlWhSsxLzFyBq31WH4okGSdNULRVmIbq83ubD4s=;
  b=lHSYM/Gw2ndmEp3i4v4B2LSXJ/mSaSTC2UjINhOKyvpFqD5sLFtAKh1G
   DeNPY5DLKg2kznFF6/U8ttDejmxTdklzZ2NCXGH8MZ3vKVL/2xtEotyOL
   rhInEJBScOhHZXIoDrXqnAN0gB0w3lLeDF0cQAuG8X5sMupoy+dBYy5tG
   1sP0tucjUelwFFFuezKDmG1rsJL8cs2tTpqbsEOTn6KPTfVp43dLWhqKG
   iizehb+WyhIrEKhQ1yURDJG3R3O/K2KpOCX8P+uwKbkVBlZOHL1Akz+Mm
   KW1qbm7Mk//YmZ87DuVco6CgPX808Y/lJShHSK3R0Fpcx+civivBIBKua
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="386432588"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="386432588"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 12:55:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="755600137"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="755600137"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 12:55:45 -0700
From: Jithu Joseph <jithu.joseph@intel.com>
To: ilpo.jarvinen@linux.intel.com,
	hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rostedt@goodmis.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	pengfei.xu@intel.com
Subject: [PATCH v4 7/9] platform/x86/intel/ifs: Add new CPU support
Date: Thu,  5 Oct 2023 12:51:35 -0700
Message-Id: <20231005195137.3117166-8-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231005195137.3117166-1-jithu.joseph@intel.com>
References: <20230929202436.2850388-1-jithu.joseph@intel.com>
 <20231005195137.3117166-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add Granite Rapids(GNR) and Sierra Forest(SRF) cpuids to x86 match table
so that IFS driver can be loaded for those.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
---
 drivers/platform/x86/intel/ifs/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index 4ff2aa4b484b..0c8927916373 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -18,6 +18,9 @@
 static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
 	X86_MATCH(SAPPHIRERAPIDS_X),
 	X86_MATCH(EMERALDRAPIDS_X),
+	X86_MATCH(GRANITERAPIDS_X),
+	X86_MATCH(GRANITERAPIDS_D),
+	X86_MATCH(ATOM_CRESTMONT_X),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);
-- 
2.25.1

