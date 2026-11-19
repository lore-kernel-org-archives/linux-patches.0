Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795113939;
	b=sbedPG2hdu0cv6TJziJA53mF9JTztTJGJl0NyKANd504SCec6ZOTlg2EPutr75SIaIZY
	 G+hOhoWKoxQIhYHv9cy7RcgDi7/1U8rR4r8kjODV5ZIo6xe9GW3ftfdA+st4Kz2em7+Vg
	 OOw4acMOAsJED1EcwY0wC+jaVu+gYJQtCg5foz1uF0wCzAyigsFWkapKDNZ3DzCOq52qe
	 qCZM9SmJvpD0Nf4v+P9e8Kq7XYOaGivwu8gNAYa/ImrvkSsFysDfTt0NKO9M0CMmLxwfB
	 tBScy06GONw7ylqxr54HL/0hMf8eqAWJaO9JRlqjorH4tULEic+lVOzjEKmX2hZBJIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795113939;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=irCiZAu30yZFxb8dTqSOTg+RM86kBDl2zI66vyFsxDw=;
	b=26UU4fzqQI9UvuPZzIp2qiZNOlDcfIHH51bOGKovoglKjFibE51HSXjQNUC1osSKi3Qp
	 Za1rVWn0DluIIdzPEneTJCeV83PWk3vZaOqiUHkMah1+fH119Tz0UFetOAZuFK8qo9c8T
	 UjLFXYsGO+rmC2GZ+G78zZsbFgTVjtrG4DuOHmry6XhPkaRxsirNa9A40kxj3xVWwutoh
	 U52Ar5IZ6us1V7d9sPjlhrve5QlYTWrOGkIL3RyHkif+tZi4kpHTqOnTmKjtGSoKHfTc1
	 G4pPWayvojPwiM0P7xk9uUlcrFSQz8VKH45ZUeuHb7NL+NKDtSsdJ9AbA9ecIx0+YMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=NSFChQ2B;
	arc=none smtp.remote-ip=198.175.65.15
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297AC606A324
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 18:45:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 297AC606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=NSFChQ2B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795113938; x=1826649938;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YSmIHT3wHFEvU0PrNYevo0+CrXmVy0Ad1eCiGP9zAjA=;
  b=NSFChQ2BadvEesCA7RcBOrzA8D3mjHoDJpempN4Q0wtWCJwqgW0KeDUO
   N2t2BIGIJc0fsE2FnK8LDc6TKqhB1hd/aROgKPdsixkN0uBYKp6ZsNiPt
   n7PVggqisUpYpVdvYt8UYcQYRFkoq+YZnQnx2Tcn06qc/kKUkLOqBfPs6
   zOvQX8yf1EYTZoIvp94ooKG2UZAY37bKhSg4bJBLxg+vIfCBS4QQNPNuT
   BJiJVE12+sQy9BgCn2V6DIWIxqAQPTEaaa04ZhxyiskEywK0F8uhYnvhZ
   Da6VXoFgGTJKHyHs21DuV1IoH5l1hvOHfY4QSKu477tqTVrPwO8saf+76
   A==;
X-CSE-ConnectionGUID: d6FNPOT8RaKwkUu1LacQKA==
X-CSE-MsgGUID: 1EnW2F3OTmGoTIazB6OecA==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="3981813"
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="3981813"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 10:45:38 -0800
X-CSE-ConnectionGUID: BKvh0bKITXOXmzXGb9wAmQ==
X-CSE-MsgGUID: bePDBXrqS4avuFPbz2K6cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="10513040"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.223.213])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 10:45:38 -0800
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Chen Yu <yu.c.chen@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/resctrl: Add SNC support for Granite Rapids "D" CPU
Date: Thu, 19 Nov 2026 10:45:24 -0800
Message-ID: <20261119184524.12846-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
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

Sub-NUMA Cluster (SNC) mode divides available RMID counters between
NUMA nodes that share an instance of an L3 cache.

Granite Rapids "D" CPUs can enable SNC mode, so Linux must adjust
when SNC is enabled.

Update the table of SNC capable CPU models.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index a6a9090c4808..eee76570cf6a 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -381,6 +381,7 @@ static const struct x86_cpu_id snc_cpu_ids[] __initconst = {
 	X86_MATCH_VFM(INTEL_GRANITERAPIDS_X, 0),
 	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT_X, 0),
 	X86_MATCH_VFM(INTEL_ATOM_DARKMONT_X, 0),
+	X86_MATCH_VFM(INTEL_GRANITERAPIDS_D, 0),
 	{}
 };
 
-- 
2.56.0

