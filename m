Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0589E23ED71
	for <patches@lists.linux.dev>; Mon,  3 Mar 2025 23:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741044895; cv=none; b=oipbpG9s9bwyCJECsxSYKnaO1qS8oNLxJQfAUVaWsPkE+0DkP4FscGLxhv2+ABnVdqsclNfAkOQ7S6RqXP8kkhoIbrh6SELDnQlfvS/aeGvjFR9NAkwKAOVdSis52tpW7xL5HjnJKiDu0sCvtgL9tmk3HxSZW4nEygtr+0xwt5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741044895; c=relaxed/simple;
	bh=dUOelVMIQQD73F+GAf+V+9g1dvlZdazGdQL8u6euTHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOo/ENZRHTnkgailM1r6vkdHH+9AmZZMtALqUAlWuzXvdtn5R2AO9Xj1ubPHpwG6XxtvdeSKPtdiribAnbBRP7jU9KmSE6YQx87JnMN/n8Cs22rznVsEsOPglfG60/ahjRFi8QKa5MlGKXv5pYgPz+c70OglEDibR4k5AFeMcBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bEdljwJ0; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bEdljwJ0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741044894; x=1772580894;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dUOelVMIQQD73F+GAf+V+9g1dvlZdazGdQL8u6euTHI=;
  b=bEdljwJ0qDL8x4aT2tgJo320I4Hq6eUQfNbzRvJxcSpRn1W+6bmw/J2K
   hHFf4hZ1WinUj3SoieYbr7ZrL+547yj04jOS4mwqVQFSET8p0CfofetPX
   NEenD7na9jd/parBdeA7gSY2Szjqi9rcp3ES6M1olgCtN5XVepdu1etfH
   IxizwksYWyZgNVhnuVYGrXZjhkGhUPFebjfPF0B3OvBwTNuQb1iqRMjnP
   Bai6tLZWap7U9yPUO/+IUYPm672SB8jZrk3p/wZra3uPoC+4Xl6FDj9nq
   sdPv8li4qiOoM96IjFByFZijGMU8YF7GQXVmOO8cPYknJFyc/kPE+4Zz6
   g==;
X-CSE-ConnectionGUID: JLRC1kZ2SuGm5+q5YVQC8g==
X-CSE-MsgGUID: dTaJe3FRQR+Ee69dtsMB8w==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41835963"
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="41835963"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:34:47 -0800
X-CSE-ConnectionGUID: 0g3CZYF7QdqyW55C6dFfFQ==
X-CSE-MsgGUID: Vjr083SeSjC+Ly+ovxcDjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="117982298"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:33:52 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 10/17] x86/resctrl: Add detailed descriptions for Clearwater Forest events
Date: Mon,  3 Mar 2025 15:33:30 -0800
Message-ID: <20250303233340.333743-11-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250303233340.333743-1-tony.luck@intel.com>
References: <20250303233340.333743-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are two event groups one for energy reporting and another
for "perf" events.

See the XML description files in https://github.com/intel/Intel-PMT
in the xml/CWF/OOBMSM/{RMID-ENERGY,RMID-PERF}/ for the detailed
descriptions that were used to derive these descriptions.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_pmt.c | 43 +++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_pmt.c b/arch/x86/kernel/cpu/resctrl/intel_pmt.c
index 76ec42a67c48..78ab6d899ee2 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_pmt.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_pmt.c
@@ -70,7 +70,50 @@ struct telem_entry {
 	struct pmt_event evts[];
 };
 
+#define CWF_NUM_RMIDS	576
+#define CWF_ENERGY_GUID	0x26696143
+#define CWF_PERF_GUID	0x26557651
+#define	CWF_ENERGY_STRIDE	0x10
+#define CWF_PERF_STRIDE	0x38
+
+static struct telem_entry cwf_energy = {
+	.name				= "energy",
+	.guid				= CWF_ENERGY_GUID,
+	.num_rmids			= CWF_NUM_RMIDS,
+	.stride				= CWF_ENERGY_STRIDE,
+	.overflow_counter_off		= CWF_NUM_RMIDS * CWF_ENERGY_STRIDE,
+	.last_overflow_tstamp_off	= CWF_NUM_RMIDS * CWF_ENERGY_STRIDE + 8,
+	.last_update_tstamp_off		= CWF_NUM_RMIDS * CWF_ENERGY_STRIDE + 16,
+	.evts				= {
+		EVT(PMT_EVENT_ENERGY, "core_energy", 0x0, EVT_U46_18),
+		EVT(PMT_EVENT_ACTIVITY, "activity", 0x8, EVT_U46_18),
+		{ }
+	}
+};
+
+static struct telem_entry cwf_perf = {
+	.name				= "perf",
+	.guid				= CWF_PERF_GUID,
+	.num_rmids			= CWF_NUM_RMIDS,
+	.stride				= CWF_PERF_STRIDE,
+	.overflow_counter_off		= CWF_NUM_RMIDS * CWF_PERF_STRIDE,
+	.last_overflow_tstamp_off	= CWF_NUM_RMIDS * CWF_PERF_STRIDE + 8,
+	.last_update_tstamp_off		= CWF_NUM_RMIDS * CWF_PERF_STRIDE + 16,
+	.evts				= {
+		EVT(PMT_EVENT_STALLS_LLC_HIT, "stalls_llc_hit", 0x0, EVT_U64),
+		EVT(PMT_EVENT_C1_RES, "c1_res", 0x8, EVT_U64),
+		EVT(PMT_EVENT_UNHALTED_CORE_CYCLES, "unhalted_core_cycles", 0x10, EVT_U64),
+		EVT(PMT_EVENT_STALLS_LLC_MISS, "stalls_llc_miss", 0x18, EVT_U64),
+		EVT(PMT_EVENT_AUTO_C6_RES, "c6_res", 0x20, EVT_U64),
+		EVT(PMT_EVENT_UNHALTED_REF_CYCLES, "unhalted_ref_cycles", 0x28, EVT_U64),
+		EVT(PMT_EVENT_UOPS_RETIRED, "uops_retired", 0x30, EVT_U64),
+		{ }
+	}
+};
+
 static struct telem_entry *telem_entry[] = {
+	&cwf_energy,
+	&cwf_perf,
 	NULL
 };
 
-- 
2.48.1

