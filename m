Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E947922331
	for <patches@lists.linux.dev>; Mon, 13 May 2024 17:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715620670; cv=none; b=Vxf0dtV6NWBw5TsV5awx9DRFXz8/7hY3BrdfR+S9HMRgJyzl5BaLSydECF86TlWcDqimAX1aW7QFrnNA5KAdxeraj89qUd0Y6hAroj9B9FcTrBt2jwsDN49bqWjnoYl5gE6oBcTtNTk8xUwYlqjeXgTiUYC8cEOY9NRm3LMOMiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715620670; c=relaxed/simple;
	bh=QcQ/pCPEkSj5QIqFMXBcXK/NycL8IU+ixLdFa4lm54A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qZ7vu94GQt4N8wOZrMdDxrqwPWia5WQv0HFW/wNW46cw3ygnnEm+Z9QI0EvSJ/qFe1cHz/vN3BzGZB1XQ3mk6n+vxCo3MpQ++5heDifdaNUAlgyy/zamttUFu7wxEM5DQmVM8ptJEGw1yUdGNg+2eazhSwoBeDVcV7/5WnuS0DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GWsG0fid; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GWsG0fid"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715620669; x=1747156669;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QcQ/pCPEkSj5QIqFMXBcXK/NycL8IU+ixLdFa4lm54A=;
  b=GWsG0fidj9TzuZPVak/DZgGnb0G5hQXcKSUSyGJc7FrRlrcllql9XBca
   hCuRqNf6/zDIp9aQefVWnG+u+MFZ9U1pT6+C0PIeq8MGVV00epoAIP1AD
   zMGIimvvp9eOAsUJ+a1t4AM40PterubWtm+e1tTmtsNELarmRYDgUpOfM
   bTWqYRepcGxsR227wc44nK+lPuZDCVA7Iv0zhAdBRDtJeVjCZtLWIWEPi
   DX/lmEWmkWo/pMU3o/D+R0H2s0vH1exMcX+eYwANvFzc/BIQ3J6yTx3hn
   GIBudbVi+J78f7lcRCYjDxIeVrMyPZ9MvJb6RIbxYzejpv03ItMj2Jy+1
   w==;
X-CSE-ConnectionGUID: 5LNGO6MZT6e2WyGLI90CGw==
X-CSE-MsgGUID: 9v/p1KZtSniVOp4do2Inig==
X-IronPort-AV: E=McAfee;i="6600,9927,11072"; a="15390454"
X-IronPort-AV: E=Sophos;i="6.08,158,1712646000"; 
   d="scan'208";a="15390454"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 10:17:48 -0700
X-CSE-ConnectionGUID: Tdm0B/uKScm4G38ISZNCDA==
X-CSE-MsgGUID: CkR5S46DRImA1x1l+Q8T6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,158,1712646000"; 
   d="scan'208";a="30386078"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.105])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 10:17:48 -0700
Date: Mon, 13 May 2024 10:17:47 -0700
From: Tony Luck <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v17 8/9] x86/resctrl: Sub NUMA Cluster detection and
 enable
Message-ID: <ZkJLO-fNXVxdm6Bb@agluck-desk3>
References: <20240503203325.21512-1-tony.luck@intel.com>
 <20240503203325.21512-9-tony.luck@intel.com>
 <570e0c1d-8df8-45c6-a9a8-972e1ff2cf66@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <570e0c1d-8df8-45c6-a9a8-972e1ff2cf66@intel.com>

On Fri, May 10, 2024 at 02:24:49PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/3/2024 1:33 PM, Tony Luck wrote:
> > There isn't a simple hardware bit that indicates whether a CPU is
> > running in Sub NUMA Cluster (SNC) mode. Infer the state by comparing
> > the ratio of NUMA nodes to L3 cache instances.
> > 
> > When SNC mode is detected, reconfigure the RMID counters by updating
> > the MSR_RMID_SNC_CONFIG MSR on each socket as CPUs are seen.
> > 
> > Clearing bit zero of the MSR divides the RMIDs and renumbers the ones
> > on the second SNC node to start from zero.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  arch/x86/include/asm/msr-index.h   |   1 +
> >  arch/x86/kernel/cpu/resctrl/core.c | 119 +++++++++++++++++++++++++++++
> >  2 files changed, 120 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> > index e72c2b872957..ce54a1ffe1e5 100644
> > --- a/arch/x86/include/asm/msr-index.h
> > +++ b/arch/x86/include/asm/msr-index.h
> > @@ -1165,6 +1165,7 @@
> >  #define MSR_IA32_QM_CTR			0xc8e
> >  #define MSR_IA32_PQR_ASSOC		0xc8f
> >  #define MSR_IA32_L3_CBM_BASE		0xc90
> > +#define MSR_RMID_SNC_CONFIG		0xca0
> >  #define MSR_IA32_L2_CBM_BASE		0xd10
> >  #define MSR_IA32_MBA_THRTL_BASE		0xd50
> >  
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index a949e69308cd..6a1727ea1dfe 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -21,7 +21,9 @@
> >  #include <linux/err.h>
> >  #include <linux/cacheinfo.h>
> >  #include <linux/cpuhotplug.h>
> > +#include <linux/mod_devicetable.h>
> >  
> > +#include <asm/cpu_device_id.h>
> >  #include <asm/intel-family.h>
> >  #include <asm/resctrl.h>
> >  #include "internal.h"
> > @@ -746,11 +748,42 @@ static void clear_closid_rmid(int cpu)
> >  	      RESCTRL_RESERVED_CLOSID);
> >  }
> >  
> > +/*
> > + * The power-on reset value of MSR_RMID_SNC_CONFIG is 0x1
> > + * which indicates that RMIDs are configured in legacy mode.
> > + * This mode is incompatible with Linux resctrl semantics
> > + * as RMIDs are partitioned between SNC nodes, which requires
> > + * a user to know which RMID is allocated to a task.
> > + * Clearing bit 0 reconfigures the RMID counters for use
> > + * in Sub NUMA Cluster mode. This mode is better for Linux.
> > + * The RMID space is divided between all SNC nodes with the
> > + * RMIDs renumbered to start from zero in each node when
> > + * couning operations from tasks. Code to read the counters
> > + * must adjust RMID counter numbers based on SNC node. See
> > + * __rmid_read() for code that does this.
> > + */
> > +static void snc_remap_rmids(int cpu)
> > +{
> > +	u64 val;
> > +
> > +	/* Only need to enable once per package. */
> > +	if (cpumask_first(topology_core_cpumask(cpu)) != cpu)
> > +		return;
> > +
> > +	rdmsrl(MSR_RMID_SNC_CONFIG, val);
> > +	val &= ~BIT_ULL(0);
> > +	wrmsrl(MSR_RMID_SNC_CONFIG, val);
> > +}
> > +
> >  static int resctrl_arch_online_cpu(unsigned int cpu)
> >  {
> >  	struct rdt_resource *r;
> >  
> >  	mutex_lock(&domain_list_lock);
> > +
> > +	if (snc_nodes_per_l3_cache > 1)
> > +		snc_remap_rmids(cpu);
> > +
> >  	for_each_capable_rdt_resource(r)
> >  		domain_add_cpu(cpu, r);
> >  	mutex_unlock(&domain_list_lock);
> > @@ -990,11 +1023,97 @@ static __init bool get_rdt_resources(void)
> >  	return (rdt_mon_capable || rdt_alloc_capable);
> >  }
> >  
> > +/* CPU models that support MSR_RMID_SNC_CONFIG */
> > +static const struct x86_cpu_id snc_cpu_ids[] __initconst = {
> > +	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, 0),
> > +	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, 0),
> > +	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X, 0),
> > +	X86_MATCH_INTEL_FAM6_MODEL(GRANITERAPIDS_X, 0),
> > +	X86_MATCH_INTEL_FAM6_MODEL(ATOM_CRESTMONT_X, 0),
> > +	{}
> > +};
> > +
> > +/*
> > + * There isn't a simple hardware bit that indicates whether a CPU is running
> > + * in Sub NUMA Cluster (SNC) mode. Infer the state by comparing the
> > + * ratio of NUMA nodes to L3 cache instances.
> > + * It is not possible to accurately determine SNC state if the system is
> > + * booted with a maxcpus=N parameter. That distorts the ratio of SNC nodes
> > + * to L3 caches. It will be OK if system is booted with hyperthreading
> > + * disabled (since this doesn't affect the ratio).
> > + */
> > +static __init int snc_get_config(void)
> > +{
> > +	unsigned long *node_caches;
> > +	int mem_only_nodes = 0;
> > +	int cpu, node, ret;
> > +	int num_l3_caches;
> > +	int cache_id;
> > +
> > +	if (!x86_match_cpu(snc_cpu_ids))
> > +		return 1;
> > +
> > +	node_caches = bitmap_zalloc(num_possible_cpus(), GFP_KERNEL);
> > +	if (!node_caches)
> > +		return 1;
> > +
> > +	cpus_read_lock();
> > +
> > +	if (num_online_cpus() != num_present_cpus())
> > +		pr_warn("Some CPUs offline, SNC detection may be incorrect\n");
> > +
> > +	for_each_node(node) {
> > +		cpu = cpumask_first(cpumask_of_node(node));
> > +		if (cpu < nr_cpu_ids) {
> > +			cache_id = get_cpu_cacheinfo_id(cpu, 3);
> > +			if (cache_id != -1)
> > +				set_bit(cache_id, node_caches);
> > +		} else {
> > +			mem_only_nodes++;
> > +		}
> > +	}
> > +	cpus_read_unlock();
> > +
> > +	num_l3_caches = bitmap_weight(node_caches, num_possible_cpus());
> > +	kfree(node_caches);
> > +
> > +	if (!num_l3_caches)
> > +		goto insane;
> > +
> > +	/* sanity check #1: Number of CPU nodes must be multiple of num_l3_caches */
> > +	if ((nr_node_ids - mem_only_nodes) % num_l3_caches)
> > +		goto insane;
> > +
> > +	ret = (nr_node_ids - mem_only_nodes) / num_l3_caches;
> > +
> > +	/* sanity check #2: Only valid results are 1, 2, 3, 4 */
> > +	switch (ret) {
> > +	case 1:
> > +		break;
> > +	case 2:
> > +	case 3:
> > +	case 4:
> > +		pr_info("Sub-NUMA cluster detected with %d nodes per L3 cache\n", ret);
> > +		rdt_resources_all[RDT_RESOURCE_L3].r_resctrl.mon_scope = RESCTRL_NODE;
> > +		break;
> > +	default:
> > +		goto insane;
> > +	}
> > +
> > +	return ret;
> > +insane:
> > +	pr_warn("SNC insanity: CPU nodes = %d num_l3_caches = %d\n",
> > +		(nr_node_ids - mem_only_nodes), num_l3_caches);
> > +	return 1;
> > +}
> 
> I find it confusing how dramatically this SNC detection code changed without
> any explanations. This detection seems to match the SNC detection code from v16 but
> after v16 you posted a new SNC detection implementation that did SNC detection totally
> differently [1] from v16. Instead of keeping with the "new" detection this implements
> what was in v16. Could you please help me understand what motivated the different
> implementations and why the big differences?

Reinette,

Do you like the detection code in that version? You didn't make any
comments about it.

I switched back to the v16 code because that had survived review before
and I just wanted to make the modifications to add both per-L3 and
per-SNC node monitoring files.

I can pull that into the next iteration if you want.

-Tony
> 
> [1] https://lore.kernel.org/lkml/20240327200352.236835-11-tony.luck@intel.com/
