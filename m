Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22FB1C3C1F
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 17:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765992106; cv=none; b=OzD5x7nR5XwJ3yyc58qhcKnCl9tHbqh66TUItZsNwR/DGBk//UdHf1wCD0WoT++nXLKqMPSAd/go1OP+gFhhYOVWBn1S7atYub8dxkF370LqRGMoJAINdbVS+uQIQIUtM2gDhdF4pe5GmVy9+RXBIztTDW+ekJeX/1vt/lqH15A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765992106; c=relaxed/simple;
	bh=6VkB+qk6Vk9qrLdbL758GmX2r6bPUKfMgZsehXkLIpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQ2uTdgXaofdnZO2o5cQxFABlX0DrN4o80moO27FEixKwJUpARG+ynExT+jmalex8zgH+/jHERAA1kNK8PIHvlxZaUk1FMkAfwrP3cgg5qCeb9stwyA7yhpaWZkqWy1EASdfFMAW2yF9pOPJtEAAhNERo2lv3O+c1JDQbumr9zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QbqUk7zF; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QbqUk7zF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765992101; x=1797528101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6VkB+qk6Vk9qrLdbL758GmX2r6bPUKfMgZsehXkLIpY=;
  b=QbqUk7zF9xRPgGgveHF6a0prOy6HpRAaV5BY6yThdDbQOEAg/PZtsnnj
   4tiN1EvSw6OLiThpmrwfJN7b0AhjURd5vJFa8BDS3yviVbBpjccQnu0g9
   CMhR41dJwdezmlvyLkXWRbhBncdCdLNLO0UgM0nVYJ7bvw92AQDq6b2Or
   X1sqjgKcCZXzQhbWzjMAz15qTb1NW87Z1Oiu/G1niFYVLmVc2VsS48t+0
   Dq6hGQvn0LA0ghtQ9j4tmQW88EwvAuoBQWOo9i7+4V23gUslDXpkdLP/6
   6+mChnN2dfQLUy9TdWJ2DtDiNxxLZVdTzNh7zzsX4ttzCsdAMgBi1GLHf
   Q==;
X-CSE-ConnectionGUID: JaIKmMP4SPiwQ+HERpG0bg==
X-CSE-MsgGUID: XW4caacBThy6+YldWMG2gw==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="90594641"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="90594641"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:32 -0800
X-CSE-ConnectionGUID: X0GdadOJSie4O/uD5tNlKA==
X-CSE-MsgGUID: y1OONoGKTOGqEuOtmhxedg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="221748159"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.131])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:31 -0800
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
Subject: [PATCH v17 04/32] x86/resctrl: Clean up domain_remove_cpu_ctrl()
Date: Wed, 17 Dec 2025 09:20:51 -0800
Message-ID: <20251217172121.12030-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217172121.12030-1-tony.luck@intel.com>
References: <20251217172121.12030-1-tony.luck@intel.com>
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
2.52.0

