Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8F8F510
	for <patches@lists.linux.dev>; Fri, 27 Jun 2025 00:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750984008; cv=none; b=ZZhrrafmLM5J1JNa7IdYa/TFS3KHzBZ1xsKbSwIlIQ5AmvVjoZ0aEyBmNgpnWzOMyIFkUhyR8JwNjOq7hMbLllAlh4d5il2KO1D44nMnbd3NZVuRjjSUt9rdqVo0H/dwLflAiSE8G2rDhgdrSYSeMb9vVvWun/ueBkbd4Hi+sag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750984008; c=relaxed/simple;
	bh=2jlhl1pT0vOK+0eJYYLHSdYMDOjk44bGVrpxsdU43YA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GlwEFFqYqfJFfeiFnQttAy+jEeY4ZR9HRhlBMdaJa1ClVibwlXW7iQux4/tv/+E/ODmqtYaG1iqzQYd8fZrrXx6D02zN4jb5o1TUF3TTmJLHxzWmc+Aqe3rh82c26B+D+YuVaGza9s129QppDi7PykVcj0/AmKKnO7iKebGV2v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fPeK/WbX; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fPeK/WbX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750984007; x=1782520007;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2jlhl1pT0vOK+0eJYYLHSdYMDOjk44bGVrpxsdU43YA=;
  b=fPeK/WbX/iPwPVa80AxaYDiVD3Fo1QtneTLTPzUAjejyYFPrXQXRBJOh
   MoEkxfTUAK+/lgArYm5tkIYCcJer7NiU6u1U50Vro3nFkaLLrHG6j4zt2
   JxCO5visTjFaHMIEYH5ixEBnbMKqfIWqZWfpBY6PHEL/YRsVx98mXlJ/B
   EziyVSfIyGX6QSdCypuETnj/zYtfQfiQO10/BjVB0D4fpSFwIBIRVKcbs
   P2vrlcRBZQQLdr2ASJXuCfCxNdRSc2IgKbwcPaankQpMvtLStKo3hj6XQ
   8jsql3wUVjk9W46b1owF8ZQXiEDvZ4yo/S23LhUSQQ4i6JfT+v2G0kXss
   Q==;
X-CSE-ConnectionGUID: 7PHAlW78SQ2rrr13QQdhmg==
X-CSE-MsgGUID: yDENT+0cQI2787+CwDfLwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="75842879"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="75842879"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 17:26:47 -0700
X-CSE-ConnectionGUID: o4gK8dzQTaKbZnIK+5LjZg==
X-CSE-MsgGUID: 3j2suu7bTYe+PJ9hcPFwMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="189855296"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 17:26:47 -0700
Date: Thu, 26 Jun 2025 17:26:44 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v6 00/30] x86,fs/resctrl telemetry monitoring
Message-ID: <aF3lRKURweT4mhAj@agluck-desk3>
References: <20250626164941.106341-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250626164941.106341-1-tony.luck@intel.com>

Bother. Just got e-mail after posting v6 from lkp. Apparently
I applied the fixes to avoid "'d' used before set" in
domain_remove_cpu_ctrl() and domain_remove_cpu_mon() to some
other branch than the one that made it to my final version.

Please imagine the hunks below merged into patches 7 & 8.

-Tony

---

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 3ec8fbd2f778..39cee572a121 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -651,8 +651,8 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 	if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
 		return;
 
-	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
-	if (!cpumask_empty(&d->hdr.cpu_mask))
+	cpumask_clear_cpu(cpu, &hdr->cpu_mask);
+	if (!cpumask_empty(&hdr->cpu_mask))
 		return;
 
 	d = container_of(hdr, struct rdt_ctrl_domain, hdr);
@@ -696,8 +696,8 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
 		return;
 
-	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
-	if (!cpumask_empty(&d->hdr.cpu_mask))
+	cpumask_clear_cpu(cpu, &hdr->cpu_mask);
+	if (!cpumask_empty(&hdr->cpu_mask))
 		return;
 
 	switch (r->rid) {
