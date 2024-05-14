Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BFBEBE
	for <patches@lists.linux.dev>; Tue, 14 May 2024 00:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715646510; cv=none; b=Rodh9OdL3FL80UP64mXOIrIhwISMkfsvjst8przp/1Ch+yj6SqSuLM/0lQmrOYlykBhKVlVv+wPTGUPTcrVjVClaCHdHgFnBXRmCS1lwzSHuT6Gn93cW3lfW9pGJCxV+UK6zu8AyQIuewixGXWJX4/ewpPyKl63yRcddSqvpGGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715646510; c=relaxed/simple;
	bh=Qdk1rUb0lcu0MLuAs3C0m38lHdMFLjgGckJx++x9bCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iXuG9CWgD1NJEqXDYck8rOqRhxbac1M02dBuXRM2jFsKWGOxZokPfe1Fw5mD4qnNOK+LGbnS1yi0XWwzWdjfX7dBXLJ+vtvdIb1CIhPxvFCpd7T6Sll2ejA3IhorHw6wt2tEzEfbKPUpx2NYfEjRZw+wKP9HZsIdCFO0lEUG3AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oGvgpSZj; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oGvgpSZj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715646509; x=1747182509;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Qdk1rUb0lcu0MLuAs3C0m38lHdMFLjgGckJx++x9bCs=;
  b=oGvgpSZjDdremUnDyVkSMdIz41lHyqL5mKNzvvFZOEbfGK5orr15fO84
   EnPC4A3DmcKJKo0Wy8s8c6P+r2aehhQg/BoQCNVkN0aQdRWr0qLzyT4U4
   jIFUT0xW0edFT5ZGOPpgIEsDLu4To7Uqye8M41F1pE8BY8fDezgyfgTDF
   Vv83XOzDmqJoe/oJgM019MTE4hGcAFAgKktHeJdO9AKaKDWeuTLC2Idgu
   pKwKoF3dpC+tf/5HsAilLHSVuHIf3DLTbaNCzYVaTQXrCZUfZS7JTEvrk
   iQI2EI5Y75Z5GEdqGHcH3Lb5HUaCYG50L+Yw6k/XIkTTJtiDYXLDXihPy
   A==;
X-CSE-ConnectionGUID: 1acUIvO6QECoP8JuWmaM2A==
X-CSE-MsgGUID: IeisVi3dTZK9omzby7sGpg==
X-IronPort-AV: E=McAfee;i="6600,9927,11072"; a="11820784"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="11820784"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 17:28:28 -0700
X-CSE-ConnectionGUID: W+7yzYiLTK+jBeVd0+KGXg==
X-CSE-MsgGUID: FioQHKtFRy2N4mJwafYy0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="31056292"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 17:28:27 -0700
Date: Mon, 13 May 2024 17:28:26 -0700
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
Message-ID: <ZkKwKlo7JlbjUEjr@agluck-desk3>
References: <20240503203325.21512-1-tony.luck@intel.com>
 <20240503203325.21512-9-tony.luck@intel.com>
 <570e0c1d-8df8-45c6-a9a8-972e1ff2cf66@intel.com>
 <ZkJLO-fNXVxdm6Bb@agluck-desk3>
 <fc2de5b4-8a38-4041-9f61-d1bcdf810317@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc2de5b4-8a38-4041-9f61-d1bcdf810317@intel.com>

On Mon, May 13, 2024 at 11:53:26AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/13/2024 10:17 AM, Tony Luck wrote:
> > On Fri, May 10, 2024 at 02:24:49PM -0700, Reinette Chatre wrote:
> >> Hi Tony,
> >>
> >> On 5/3/2024 1:33 PM, Tony Luck wrote:
> >>> There isn't a simple hardware bit that indicates whether a CPU is
> >>> running in Sub NUMA Cluster (SNC) mode. Infer the state by comparing
> >>> the ratio of NUMA nodes to L3 cache instances.
> >>>
> >>> When SNC mode is detected, reconfigure the RMID counters by updating
> >>> the MSR_RMID_SNC_CONFIG MSR on each socket as CPUs are seen.
> >>>
> >>> Clearing bit zero of the MSR divides the RMIDs and renumbers the ones
> >>> on the second SNC node to start from zero.
> >>>
> >>> Signed-off-by: Tony Luck <tony.luck@intel.com>
> >>> ---
> >>>  arch/x86/include/asm/msr-index.h   |   1 +
> >>>  arch/x86/kernel/cpu/resctrl/core.c | 119 +++++++++++++++++++++++++++++
> >>>  2 files changed, 120 insertions(+)
> >>>
> >>> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> >>> index e72c2b872957..ce54a1ffe1e5 100644
> >>> --- a/arch/x86/include/asm/msr-index.h
> >>> +++ b/arch/x86/include/asm/msr-index.h
> >>> @@ -1165,6 +1165,7 @@
> >>>  #define MSR_IA32_QM_CTR			0xc8e
> >>>  #define MSR_IA32_PQR_ASSOC		0xc8f
> >>>  #define MSR_IA32_L3_CBM_BASE		0xc90
> >>> +#define MSR_RMID_SNC_CONFIG		0xca0
> >>>  #define MSR_IA32_L2_CBM_BASE		0xd10
> >>>  #define MSR_IA32_MBA_THRTL_BASE		0xd50
> >>>  
> >>> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> >>> index a949e69308cd..6a1727ea1dfe 100644
> >>> --- a/arch/x86/kernel/cpu/resctrl/core.c
> >>> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> >>> @@ -21,7 +21,9 @@
> >>>  #include <linux/err.h>
> >>>  #include <linux/cacheinfo.h>
> >>>  #include <linux/cpuhotplug.h>
> >>> +#include <linux/mod_devicetable.h>
> >>>  
> >>> +#include <asm/cpu_device_id.h>
> >>>  #include <asm/intel-family.h>
> >>>  #include <asm/resctrl.h>
> >>>  #include "internal.h"
> >>> @@ -746,11 +748,42 @@ static void clear_closid_rmid(int cpu)
> >>>  	      RESCTRL_RESERVED_CLOSID);
> >>>  }
> >>>  
> >>> +/*
> >>> + * The power-on reset value of MSR_RMID_SNC_CONFIG is 0x1
> >>> + * which indicates that RMIDs are configured in legacy mode.
> >>> + * This mode is incompatible with Linux resctrl semantics
> >>> + * as RMIDs are partitioned between SNC nodes, which requires
> >>> + * a user to know which RMID is allocated to a task.
> >>> + * Clearing bit 0 reconfigures the RMID counters for use
> >>> + * in Sub NUMA Cluster mode. This mode is better for Linux.
> >>> + * The RMID space is divided between all SNC nodes with the
> >>> + * RMIDs renumbered to start from zero in each node when
> >>> + * couning operations from tasks. Code to read the counters
> >>> + * must adjust RMID counter numbers based on SNC node. See
> >>> + * __rmid_read() for code that does this.
> >>> + */
> >>> +static void snc_remap_rmids(int cpu)
> >>> +{
> >>> +	u64 val;
> >>> +
> >>> +	/* Only need to enable once per package. */
> >>> +	if (cpumask_first(topology_core_cpumask(cpu)) != cpu)
> >>> +		return;
> >>> +
> >>> +	rdmsrl(MSR_RMID_SNC_CONFIG, val);
> >>> +	val &= ~BIT_ULL(0);
> >>> +	wrmsrl(MSR_RMID_SNC_CONFIG, val);
> >>> +}
> >>> +
> >>>  static int resctrl_arch_online_cpu(unsigned int cpu)
> >>>  {
> >>>  	struct rdt_resource *r;
> >>>  
> >>>  	mutex_lock(&domain_list_lock);
> >>> +
> >>> +	if (snc_nodes_per_l3_cache > 1)
> >>> +		snc_remap_rmids(cpu);
> >>> +
> >>>  	for_each_capable_rdt_resource(r)
> >>>  		domain_add_cpu(cpu, r);
> >>>  	mutex_unlock(&domain_list_lock);
> >>> @@ -990,11 +1023,97 @@ static __init bool get_rdt_resources(void)
> >>>  	return (rdt_mon_capable || rdt_alloc_capable);
> >>>  }
> >>>  
> >>> +/* CPU models that support MSR_RMID_SNC_CONFIG */
> >>> +static const struct x86_cpu_id snc_cpu_ids[] __initconst = {
> >>> +	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, 0),
> >>> +	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, 0),
> >>> +	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X, 0),
> >>> +	X86_MATCH_INTEL_FAM6_MODEL(GRANITERAPIDS_X, 0),
> >>> +	X86_MATCH_INTEL_FAM6_MODEL(ATOM_CRESTMONT_X, 0),
> >>> +	{}
> >>> +};
> >>> +
> >>> +/*
> >>> + * There isn't a simple hardware bit that indicates whether a CPU is running
> >>> + * in Sub NUMA Cluster (SNC) mode. Infer the state by comparing the
> >>> + * ratio of NUMA nodes to L3 cache instances.
> >>> + * It is not possible to accurately determine SNC state if the system is
> >>> + * booted with a maxcpus=N parameter. That distorts the ratio of SNC nodes
> >>> + * to L3 caches. It will be OK if system is booted with hyperthreading
> >>> + * disabled (since this doesn't affect the ratio).
> >>> + */
> >>> +static __init int snc_get_config(void)
> >>> +{
> >>> +	unsigned long *node_caches;
> >>> +	int mem_only_nodes = 0;
> >>> +	int cpu, node, ret;
> >>> +	int num_l3_caches;
> >>> +	int cache_id;
> >>> +
> >>> +	if (!x86_match_cpu(snc_cpu_ids))
> >>> +		return 1;
> >>> +
> >>> +	node_caches = bitmap_zalloc(num_possible_cpus(), GFP_KERNEL);
> >>> +	if (!node_caches)
> >>> +		return 1;
> >>> +
> >>> +	cpus_read_lock();
> >>> +
> >>> +	if (num_online_cpus() != num_present_cpus())
> >>> +		pr_warn("Some CPUs offline, SNC detection may be incorrect\n");
> >>> +
> >>> +	for_each_node(node) {
> >>> +		cpu = cpumask_first(cpumask_of_node(node));
> >>> +		if (cpu < nr_cpu_ids) {
> >>> +			cache_id = get_cpu_cacheinfo_id(cpu, 3);
> >>> +			if (cache_id != -1)
> >>> +				set_bit(cache_id, node_caches);
> >>> +		} else {
> >>> +			mem_only_nodes++;
> >>> +		}
> >>> +	}
> >>> +	cpus_read_unlock();
> >>> +
> >>> +	num_l3_caches = bitmap_weight(node_caches, num_possible_cpus());
> >>> +	kfree(node_caches);
> >>> +
> >>> +	if (!num_l3_caches)
> >>> +		goto insane;
> >>> +
> >>> +	/* sanity check #1: Number of CPU nodes must be multiple of num_l3_caches */
> >>> +	if ((nr_node_ids - mem_only_nodes) % num_l3_caches)
> >>> +		goto insane;
> >>> +
> >>> +	ret = (nr_node_ids - mem_only_nodes) / num_l3_caches;
> >>> +
> >>> +	/* sanity check #2: Only valid results are 1, 2, 3, 4 */
> >>> +	switch (ret) {
> >>> +	case 1:
> >>> +		break;
> >>> +	case 2:
> >>> +	case 3:
> >>> +	case 4:
> >>> +		pr_info("Sub-NUMA cluster detected with %d nodes per L3 cache\n", ret);
> >>> +		rdt_resources_all[RDT_RESOURCE_L3].r_resctrl.mon_scope = RESCTRL_NODE;
> >>> +		break;
> >>> +	default:
> >>> +		goto insane;
> >>> +	}
> >>> +
> >>> +	return ret;
> >>> +insane:
> >>> +	pr_warn("SNC insanity: CPU nodes = %d num_l3_caches = %d\n",
> >>> +		(nr_node_ids - mem_only_nodes), num_l3_caches);
> >>> +	return 1;
> >>> +}
> >>
> >> I find it confusing how dramatically this SNC detection code changed without
> >> any explanations. This detection seems to match the SNC detection code from v16 but
> >> after v16 you posted a new SNC detection implementation that did SNC detection totally
> >> differently [1] from v16. Instead of keeping with the "new" detection this implements
> >> what was in v16. Could you please help me understand what motivated the different
> >> implementations and why the big differences?
> > 
> > Reinette,
> > 
> > Do you like the detection code in that version? You didn't make any
> > comments about it.
> 
> It was a drop-in replacement for a portion that was not relevant to the
> architecture discussion that I focused on ... hence my surprise that it
> just came and went without any comment.

So it will be back again when I post v18 as it is somewhat simpler
(doesn't rely on allocating a bitmap to count L3 cache instances).

I'll update comments in that patch, in the code, and in the change
log in the cover letter.

> > I switched back to the v16 code because that had survived review before
> > and I just wanted to make the modifications to add both per-L3 and
> > per-SNC node monitoring files.
> > 
> > I can pull that into the next iteration if you want.
> 
> It is not clear to me why you switched back and forth between the detection
> algorithms. I expect big changes to be accompanied with explanation of what changed,
> why one is better than the other, or if they are considered "similar", what
> are the pros/cons. Am I missing something so obvious that causes you to think
> the work does not need the explanation I asked your help with?

The change deserved some comments when it suddenly appeared. One of the
many issues with my detour from the progression. It disappeared because
I reverted to the previously reviewed version.

> Reinette

-Tony
