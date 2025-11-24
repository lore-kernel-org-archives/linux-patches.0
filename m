Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6DF303CAE
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 18:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010487; cv=none; b=YJa4lVkbQ7DX8U6ad89H+Hl2veAnSi4mvcLBqYvM0qaTBwC2/gE2ZGlNLge34YkM6a2wwg/FwnZd4MwcE7ygvwRNVd+82cexWVvmrRMy8LYdlXOugtSJe8yoTQ2PgpRWC91BhOcm+76FLrUW33GNh8VQjVzY8dQT8iYAxulBKuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010487; c=relaxed/simple;
	bh=u7RmMkbdyc5QHVMIPLc9Jc97zGTH0J2VNf3TiEGFH8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQjU4ftrispemh4+EJIF82GeOzhiz3qEdQlnYa3CVqNCZTOnBI26mU7f9Y+m38puJUDhPeO1Q4SPiKFHmyXtY8SxbMwhJ/I04N79DhgHiU3QwonPY63X4bWa5su3vijfuPHdPmZkHOrAzOdmY7E6QU3QB8S+fYa3/al/zTP2kYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M/g4z9T3; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M/g4z9T3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764010485; x=1795546485;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u7RmMkbdyc5QHVMIPLc9Jc97zGTH0J2VNf3TiEGFH8k=;
  b=M/g4z9T3Apdwb67bzsXnwmXKMcbnveMSKH6UsazknQTENWGRR+5D3/bp
   UbTZYCavFLbPKjHOEhSdbj0fR+NNIhyqXmNtbHvTKYOfrXhp+DyQE9bHi
   nsibq89cg9atziR9QHVSvkuHIH/PPaWPRFMbfQoWejcpcnnK9o2gjS4fs
   JbaYJBHF8ed/e5znxWsGThICgoo0ThX1UYkNbTqnplhju3YOsRt48/K9A
   j5u+uDlUP1NCDKr3+gzsgSYlgIXIsqe65MVk0GHoyfJchHEYYf3YBHUZ0
   tQns2UaSIo8eYBGAse/zPpGipmH6iyQFCAumRjhBNkXOdKV0a4h7zcnXQ
   A==;
X-CSE-ConnectionGUID: EVtj+5xqTROjuBvjqr47Xg==
X-CSE-MsgGUID: ZfV/fSWGR8+ZoRoRiE2vmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76636468"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="76636468"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:22 -0800
X-CSE-ConnectionGUID: CL9bpNl/S3Gdy8yQrZIztQ==
X-CSE-MsgGUID: eqTSDx6uRUujtASb+Whxbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192224952"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:22 -0800
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
Subject: [PATCH v14 04/32] x86/resctrl: Clean up domain_remove_cpu_ctrl()
Date: Mon, 24 Nov 2025 10:53:41 -0800
Message-ID: <20251124185412.24155-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251124185412.24155-1-tony.luck@intel.com>
References: <20251124185412.24155-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For symmetry with domain_remove_cpu_mon() refactor domain_remove_cpu_ctrl()
to take an early return when removing a CPU does not empty the domain.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 49b133e847d4..64ed81cbf8bf 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -604,28 +604,27 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 		return;
 	}
 
+	cpumask_clear_cpu(cpu, &hdr->cpu_mask);
+	if (!cpumask_empty(&hdr->cpu_mask))
+		return;
+
 	if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
 		return;
 
 	d = container_of(hdr, struct rdt_ctrl_domain, hdr);
 	hw_dom = resctrl_to_arch_ctrl_dom(d);
 
-	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
-	if (cpumask_empty(&d->hdr.cpu_mask)) {
-		resctrl_offline_ctrl_domain(r, d);
-		list_del_rcu(&d->hdr.list);
-		synchronize_rcu();
-
-		/*
-		 * rdt_ctrl_domain "d" is going to be freed below, so clear
-		 * its pointer from pseudo_lock_region struct.
-		 */
-		if (d->plr)
-			d->plr->d = NULL;
-		ctrl_domain_free(hw_dom);
+	resctrl_offline_ctrl_domain(r, d);
+	list_del_rcu(&hdr->list);
+	synchronize_rcu();
 
-		return;
-	}
+	/*
+	 * rdt_ctrl_domain "d" is going to be freed below, so clear
+	 * its pointer from pseudo_lock_region struct.
+	 */
+	if (d->plr)
+		d->plr->d = NULL;
+	ctrl_domain_free(hw_dom);
 }
 
 static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
-- 
2.51.1

