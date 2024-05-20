Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EDB13C8E4
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245214; cv=none; b=HbVfLlWj4k9UajMk3KXFljHKs/c2OQAcknG6T+o6za678RxdLTpO1QlWppR+Ib7vaeklSEvb/cL+7YGUFizKVYyi4/usRjXvkSWSqiOHMPrG9XkL9AjlH1cdPmV+8iJIR2ZYipxsq/Ylcow1gVloO07EgIEtYYXSs5WFFxcPVls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245214; c=relaxed/simple;
	bh=7ymWfCCzp7TNiplx+Q1AsZqgqALtTY2Wy8qBKmus9Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvj1seCdtTCzEJ9gVahmBheHk8gIBI+w6YhqfVeMFn7A85ZvCukesHQC2XMoemizzsDfLhWDcikPP8gu81WRKVZZ1VI+InqzbbP4IidfDYgf+MpR38VXY27+gBTexsXIJARt5eOJToKcQMBEP9OpvVi5sIFqXXeeVaxRT9fXKSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ON6UgFCP; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ON6UgFCP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245212; x=1747781212;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7ymWfCCzp7TNiplx+Q1AsZqgqALtTY2Wy8qBKmus9Ng=;
  b=ON6UgFCPVtS/5wpSPVyX7eWKzNj9/ta1vxiMqEh2z8sA4IO7iY0shPQQ
   MT+les/uSntRJbpnL/JLFHFVyqCGeDQMj+1hSxHTPb8fEtgMBerVNM4hm
   t2h3uKtEv+fbjyB05VhKGWIjUSYRXfPfjoSMynDo21hGF+L2WvHe/nVeZ
   rb2sc/7fQ81drLsDp8z4EtgMh83QfSASqyFrs8ETQp5+bDrRVW5SMjSUj
   jCVZE+JpnIMLHycQ0K/9aBvcboPL6gRXSCkAsX2UKo4lX9fxedbZTfjMQ
   6k6HrNB3KGIBEOKkONT6HHFVef8SwNmS9IySF+BCX7ts4jGmArpG6a5Ox
   g==;
X-CSE-ConnectionGUID: Txs2qsK9QfyjlN2TzfsqkA==
X-CSE-MsgGUID: kM/pDFVnSSmLugRj6YK+Zw==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199891"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199891"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:39 -0700
X-CSE-ConnectionGUID: sEjHnpiNQZqU+zl84XsQug==
X-CSE-MsgGUID: UcFKgdpcQxaOoN1sHwb9vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593489"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:39 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Luck <tony.luck@intel.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v6 35/49] EDAC/i10nm: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:46:06 -0700
Message-ID: <20240520224620.9480-36-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240520224620.9480-1-tony.luck@intel.com>
References: <20240520224620.9480-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/edac/i10nm_base.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/edac/i10nm_base.c b/drivers/edac/i10nm_base.c
index 3fd22a1eb1a9..24dd896d9a9d 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -942,16 +942,16 @@ static struct res_config gnr_cfg = {
 };
 
 static const struct x86_cpu_id i10nm_cpuids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(ATOM_TREMONT_D,	X86_STEPPINGS(0x0, 0x3), &i10nm_cfg0),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(ATOM_TREMONT_D,	X86_STEPPINGS(0x4, 0xf), &i10nm_cfg1),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(ICELAKE_X,		X86_STEPPINGS(0x0, 0x3), &i10nm_cfg0),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(ICELAKE_X,		X86_STEPPINGS(0x4, 0xf), &i10nm_cfg1),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(ICELAKE_D,		X86_STEPPINGS(0x0, 0xf), &i10nm_cfg1),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(SAPPHIRERAPIDS_X,	X86_STEPPINGS(0x0, 0xf), &spr_cfg),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(EMERALDRAPIDS_X,	X86_STEPPINGS(0x0, 0xf), &spr_cfg),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(GRANITERAPIDS_X,	X86_STEPPINGS(0x0, 0xf), &gnr_cfg),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(ATOM_CRESTMONT_X,	X86_STEPPINGS(0x0, 0xf), &gnr_cfg),
-	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(ATOM_CRESTMONT,	X86_STEPPINGS(0x0, 0xf), &gnr_cfg),
+	X86_MATCH_VFM_STEPPINGS(INTEL_ATOM_TREMONT_D,	X86_STEPPINGS(0x0, 0x3), &i10nm_cfg0),
+	X86_MATCH_VFM_STEPPINGS(INTEL_ATOM_TREMONT_D,	X86_STEPPINGS(0x4, 0xf), &i10nm_cfg1),
+	X86_MATCH_VFM_STEPPINGS(INTEL_ICELAKE_X,	X86_STEPPINGS(0x0, 0x3), &i10nm_cfg0),
+	X86_MATCH_VFM_STEPPINGS(INTEL_ICELAKE_X,	X86_STEPPINGS(0x4, 0xf), &i10nm_cfg1),
+	X86_MATCH_VFM_STEPPINGS(INTEL_ICELAKE_D,	X86_STEPPINGS(0x0, 0xf), &i10nm_cfg1),
+	X86_MATCH_VFM_STEPPINGS(INTEL_SAPPHIRERAPIDS_X,	X86_STEPPINGS(0x0, 0xf), &spr_cfg),
+	X86_MATCH_VFM_STEPPINGS(INTEL_EMERALDRAPIDS_X,	X86_STEPPINGS(0x0, 0xf), &spr_cfg),
+	X86_MATCH_VFM_STEPPINGS(INTEL_GRANITERAPIDS_X,	X86_STEPPINGS(0x0, 0xf), &gnr_cfg),
+	X86_MATCH_VFM_STEPPINGS(INTEL_ATOM_CRESTMONT_X,	X86_STEPPINGS(0x0, 0xf), &gnr_cfg),
+	X86_MATCH_VFM_STEPPINGS(INTEL_ATOM_CRESTMONT,	X86_STEPPINGS(0x0, 0xf), &gnr_cfg),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, i10nm_cpuids);
-- 
2.45.0

