Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792443072;
	b=WBkU6tnoXQod8AG5OkLjfKStIcQXM013YUVdDBFWfgPv+f0WGG/kmuum2gW4kaj2Mdsw
	 609L8NYwWkPgOP1V1VaA5qj5kAAxWS8R7rGsdl73rOiuy+o39cKzfDoasMP3N3rRXCovt
	 ay1oWd7/SOMxQ8B8SGB3/bkzeMuTcD1Smx1DgLaiBJ1/EYigYvvzRcAGJen4IrVRHmr+I
	 3+Y3kQDMv3Xnr1+nGHeek/DvW25kJUBA1i8TXYQnQoWLWtMI39nEEJEPstgBF+ZWnDZDu
	 jiG14p04r8urdAyI+wsP0HUeBy0T2hOJxpKnc8vd7pygxjaAJgEOrU3gJCDTWxGgJaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443072;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=S6Zb0tXCLcVWKBkJSSJ5LIY5EEk8HgP5V4eqUOyxYYQ=;
	b=4GQFy7DomA5osIevVaagfenITrN6wXODcNGlUzIU6DXs6ZW4g9vOOIc6xy80H8jaknRf
	 patOyLsOW88aRc+Yiur6nPL4keY1JFdqRd/1O3JJm0pfPohA7/0Nn+EWjE36JmFV1TvU6
	 feFPwl5JAPo9eskVxAY/sGYUxEDYusnQk3CGX2yRx1ofirdMO3gHXhv8bSTOFu+rmsEYD
	 WZv9Mijw6lZwmvw/8Cv9DjL8xXdZkNtadJtccAvJ0reOS2a/W+nB1GDLhDijifazb1Xxn
	 Vb7DdWYb9zfYVG/R3k8hxW4YG6SHP2KAls+l//X0oCd6Rw0ANmZcIRVxziZS+W02cLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=FSI3O9IN;
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B282B606A33D
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 20:51:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B282B606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=FSI3O9IN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792443067; x=1823979067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GUNh2fSeRDb/9opqrVuw2xTtG519fwruzb3NfLlbQ2c=;
  b=FSI3O9INqP++Ao+G2MHzzlar171zup0BYZbdMouKaQ7gHiuKFPx811Tt
   r5f4K4WywsuCPKchBEuDbgcvWg2CYxnjwsmSyy7OuVX/sjEjpNCO4MNon
   E6Iggmz2GYgYrr4SrgQ39yZlpHn+YQYoHXtOP2Wpf4v9fFLDKoPJpmF1v
   c+4YdVETDaoa9BQQOPIEyzgUzPXwFndb8CmjazjW5M/jsICLfPdUnK4i9
   MHR3PPRMzuz9eG4YBqvmy8RQa+6/JJO8o414pEF8vJiK/IiP73XCcN0qm
   JKGs0DDQk1M9W5c2DiUi3ZlfQQbs3fzGsZLe1/lCT9NfEC1vHnsiwHJU3
   A==;
X-CSE-ConnectionGUID: 85oEBcsoSPaZ7PDWEfzKVQ==
X-CSE-MsgGUID: brdpXXhPTLGuZYZARHcajw==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1131282"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1131282"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:51 -0700
X-CSE-ConnectionGUID: YiYCFNJbRe+jpAagXUBPyg==
X-CSE-MsgGUID: wpQu5ymkTzSMkxlqcxUmkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3008681"
Received: from spandruv-mobl5.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.87])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:50:51 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v14 19/24] x86/resctrl: Enforce system RMID limit on AET
Date: Mon, 19 Oct 2026 13:50:26 -0700
Message-ID: <20261019205031.16977-20-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019205031.16977-1-tony.luck@intel.com>
References: <20261019205031.16977-1-tony.luck@intel.com>
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

The RMID a CPU uses for telemetry is the RMID written to
MSR_IA32_PQR_ASSOC.RMID, so the number of RMIDs that register can hold
(enumerated via CPUID) bounds every monitoring resource. Each AET
(Application Energy Telemetry) event group separately describes how many
RMIDs its counters support.

The number of RMIDs an event group supports may be higher than the number
that can be written to MSR_IA32_PQR_ASSOC.RMID. The telemetry resource
then advertises more RMIDs than can ever be used, both to user space in
info/PERF_PKG_MON/num_rmids and, on systems where telemetry is the only
monitoring resource, as the number of RMIDs available to the mount.

Cap the number of RMIDs of the telemetry resource at the number that can
be written to MSR_IA32_PQR_ASSOC.RMID.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v14:
	New commit comment
---
 arch/x86/kernel/cpu/resctrl/internal.h  | 2 ++
 arch/x86/kernel/cpu/resctrl/core.c      | 2 +-
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 6 ++++++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index c66954bc01e7..1f080aad1b67 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -153,6 +153,8 @@ extern struct rdt_hw_resource rdt_resources_all[];
 
 extern bool intel_rdt_mbm_need_quirk;
 
+extern u32 pqr_assoc_num_rmid;
+
 void arch_mon_domain_online(struct rdt_resource *r, struct rdt_l3_mon_domain *d);
 
 /* CPUID.(EAX=10H, ECX=ResID=1).EAX */
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 40466f29e48e..689b9e31fe7a 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -46,7 +46,7 @@ static DEFINE_MUTEX(domain_list_lock);
 DEFINE_PER_CPU(struct resctrl_pqr_state, pqr_state);
 
 /* Number of unique RMID values that can be written to MSR_IA32_PQR_ASSOC.RMID */
-static u32 pqr_assoc_num_rmid;
+u32 pqr_assoc_num_rmid;
 
 static void mba_wrmsr_intel(struct msr_param *m);
 static void cat_wrmsr(struct msr_param *m);
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 75cd602d65ae..5c88236d850f 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -308,6 +308,12 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
 	else
 		r->mon.num_rmid = e->num_rmid;
 
+	/*
+	 * AET may claim to support more RMIDs than are permitted to be
+	 * assigned to MSR_IA32_PQR_ASSOC.RMID. Enforce this limit.
+	 */
+	r->mon.num_rmid = min(r->mon.num_rmid, pqr_assoc_num_rmid);
+
 	if (skipped_events)
 		pr_info("%s %s:0x%x monitoring detected (skipped %d events)\n", r->name,
 			e->pfname, e->guid, skipped_events);
-- 
2.56.0

