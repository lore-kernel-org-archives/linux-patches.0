Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354E52BEC3D
	for <patches@lists.linux.dev>; Tue, 13 May 2025 16:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747153232; cv=none; b=tCEV8raDhTici8+aUFLhfj7z2YYbG+qs+5nC8nW3/PyPlv35E4mhyhKVmKfFJDgCkHOkGJoyw7DsAC54gGnyn6rgOzqxvWYmMQej+3jd3ptkZ3D8k3Hk5sM8qZQPzIkgmWUWLymHpcvdMkVYwRxV8fnPn/1DEyB5TadTvFeKeAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747153232; c=relaxed/simple;
	bh=p6PCSkSdSaZ/NJpmcH4VjI/9YpSMDFDuXD6Vn7ggxi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jrb3APCehcLG6fHQJzN3xnrgRyZmDMLhEVr1TaZsa2RAlw0WdUqtQewcPCyUBpUKY+qGgnivHTjgl8naQVW+uOqESJBZDmjNSpvhcvSf8QOogfoMsG5qjREWHPS8iNPdGIdSGDqfTWdT72CkniJEDNGxQKinE1tMtr1+SWGAtYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BQr27ZOk; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BQr27ZOk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747153231; x=1778689231;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p6PCSkSdSaZ/NJpmcH4VjI/9YpSMDFDuXD6Vn7ggxi4=;
  b=BQr27ZOkoK4raFM7M3toAS4kvy17SaX2pQdpzXL7T4KPzlteqE43ltKX
   4omoc4/cJH1t+CBHdV92ctUx89cqdNLHiYlUVzQuHJ8YUn6L2rrgkefhS
   ApgWINyiZs5eBRQzIlN61xk4LGEzRtlTC3PMPLlKCeEgORmhqrYa3yGI3
   k2ZCsSdI97W/D0BEDm0thEEW0RZ/FmUJapEZCSRhYK9gtmsZi20FKCqh8
   BdXFXv8kg6jZWAzjHLErKWmNQuxvVGodcvD98wRDHsDWfGC5fo5VK3QYB
   VmL+/rz3H0XdD5XLfEm06QgujZCO44B/TWl2tdydZOy53CHaJVC0QhsvN
   w==;
X-CSE-ConnectionGUID: SOw2gMdDRVaPYGUogCQpPA==
X-CSE-MsgGUID: vS5r/OAHQlGvpbKIZYZjig==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="48887652"
X-IronPort-AV: E=Sophos;i="6.15,285,1739865600"; 
   d="scan'208";a="48887652"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 09:20:29 -0700
X-CSE-ConnectionGUID: tVCcoLQWSXuG6JUNJY1H9Q==
X-CSE-MsgGUID: 2H6nEzQwRmqkphMJf6o3/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,285,1739865600"; 
   d="scan'208";a="142712431"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 09:20:28 -0700
Date: Tue, 13 May 2025 09:20:26 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chen, Yu C" <yu.c.chen@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	Babu Moger <babu.moger@amd.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>,
	Drew Fustini <dfustini@baylibre.com>
Subject: Re: [PATCH v4 12/31] fs/resctrl: Improve handling for events that
 can be read from any CPU
Message-ID: <aCNxSjUEFREUS8zG@agluck-desk3>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-13-tony.luck@intel.com>
 <e818906f-b03a-474b-8a6b-d291cf1a74fe@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e818906f-b03a-474b-8a6b-d291cf1a74fe@intel.com>

On Tue, May 13, 2025 at 11:19:23AM +0800, Chen, Yu C wrote:

Thanks for the bug report.

> get warning like below:
> BUG: using smp_processor_id() in preemptible [00000000] code: mount/1595
> caller is __mon_event_count+0x2e/0x1e0
> 2483 [ 2095.332850] Call Trace:
> 2484 [ 2095.332861]  <TASK>
> 2485 [ 2095.332872]  dump_stack_lvl+0x55/0x70
> 2486 [ 2095.332887]  check_preemption_disabled+0xbf/0xe0
> 2487 [ 2095.332902]  __mon_event_count+0x2e/0x1e0
> 2488 [ 2095.332918]  mon_event_count+0x2a/0xa0
> 2489 [ 2095.332934]  mon_add_all_files+0x202/0x270
> 2490 [ 2095.332953]  mkdir_mondata_subdir+0x1bf/0x1e0
> 2491 [ 2095.332970]  ? kcore_update_ram.isra.0+0x270/0x270
> 2492 [ 2095.332985]  mkdir_mondata_all+0x9d/0x100
> 2493 [ 2095.333000]  rdt_get_tree+0x336/0x5d0
> 2494 [ 2095.333014]  vfs_get_tree+0x26/0xf0
> 2495 [ 2095.333028]  do_new_mount+0x186/0x350
> 2496 [ 2095.333044]  __x64_sys_mount+0x101/0x130
> 2497 [ 2095.333061]  do_syscall_64+0x54/0xd70
> 2498 [ 2095.333075]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Hmmm. You are right, but I didn't see this. Perhaps it only shows
if CONFIG_DEBUG_PREEMPT is set?

> Maybe avoid getting the CPU at all in __mon_event_count() if
> evt->any_cpu is true?
> 
> thanks,
> Chenyu
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index d9364bee486e..32385c811a92 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -358,12 +358,15 @@ static struct mbm_state *get_mbm_state(struct
> rdt_l3_mon_domain *d, u32 closid,
> 
>  static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  {
> -       int cpu = smp_processor_id();
>         struct rdt_l3_mon_domain *d;
>         struct mbm_state *m;
> -       int err, ret;
> +       int err, ret, cpu;
>         u64 tval = 0;
> 
> +       /*only CPU sensitive event read cares about which CPU to read from
> */
> +       if (!rr->evt->any_cpu)
> +               cpu = smp_processor_id();
> 
> tele

I might fix with a helper just in case some compiler doesn't keep track
and issues a "may be used before set" warning.

-Tony


diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index ddfc1c5f60d6..6041cb304624 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -356,9 +356,24 @@ static struct mbm_state *get_mbm_state(struct rdt_l3_mon_domain *d, u32 closid,
 	return states ? &states[idx] : NULL;
 }
 
+static bool cpu_on_wrong_domain(struct rmid_read *rr)
+{
+	cpumask_t *mask;
+
+	if (rr->evt->any_cpu)
+		return false;
+
+	/*
+	 * When reading from a specific domain the CPU must be in that
+	 * domain. Otherwise the CPU must be one that shares the cache.
+	 */
+	mask = rr->d ? &rr->d->hdr.cpu_mask : &rr->ci->shared_cpu_map;
+
+	return !cpumask_test_cpu(smp_processor_id(), mask);
+}
+
 static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 {
-	int cpu = smp_processor_id();
 	struct rdt_l3_mon_domain *d;
 	struct mbm_state *m;
 	int err, ret;
@@ -373,11 +388,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 	}
 
 	if (rr->d) {
-		/*
-		 * Unless this event can be read from any CPU, check
-		 * that execution is on a CPU in the domain.
-		 */
-		if (!rr->evt->any_cpu && !cpumask_test_cpu(cpu, &rr->d->hdr.cpu_mask))
+		if (cpu_on_wrong_domain(rr))
 			return -EINVAL;
 		rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid,
 						 rr->evt->evtid, &tval, rr->arch_mon_ctx);
@@ -389,11 +400,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 		return 0;
 	}
 
-	/*
-	 * Unless this event can be read from any CPU, check that
-	 * execution is on a CPU that shares the cache.
-	 */
-	if (!rr->evt->any_cpu && !cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
+	if (cpu_on_wrong_domain(rr))
 		return -EINVAL;
 
 	/*
