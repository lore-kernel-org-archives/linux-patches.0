Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE60117CA17
	for <patches@lists.linux.dev>; Fri, 31 May 2024 18:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717179437; cv=none; b=MOZeGhUBe75AiCYiHcQlt5x0++C3bMedq1fskRkzQDP9CyoqACfg9xbMfXZEWwdq5dji5ej7xbtGkoKrnG2mkwW2atC1hIGHhYXIgWXP+WZuIR5jGC/o4XufxO8bLh5ypLG7WkBiGtb1a18SSofMleohB88sy0yEnIPEYxeqkuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717179437; c=relaxed/simple;
	bh=ZLaZ5wYoFOg8aDq07s8Jwn3a+uSyEfHns+ryEjsrshA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UrAv8C63UpwOQAJz8o2/MWuwTJKo7ldL/3rEUmu8jAPFEeFXdY7pVMX3TxNaR0HJd6gw5OPTZqwkkJmiplZWTo0OHDYg3bKccLRaS313SOpOGihEwy3XIQu43WXltL2jAz/jVFovFzfSh2/Ram8S3KLBbNULYU8lOsoJDfBdEH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kcasG8/b; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kcasG8/b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717179436; x=1748715436;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZLaZ5wYoFOg8aDq07s8Jwn3a+uSyEfHns+ryEjsrshA=;
  b=kcasG8/bqdLilotXELTQdVvp0fo0JZp0ZH3frN//Gp8qZ4IDUrZ2kAav
   emTxS/Lj3x2or6gE4sA7WqAbuZyH4sIKQIkjytD6jEr0N+xB28+t3uHjW
   n1/FEiBtBXZxQyUR+xWzuE7+JIClK2jWI0vCEXFvJtm7wxHdcC2B+nlN/
   VEX1p9EQaNno0H2v9PivZDsLZV4/zhcn4RXj5kCofajLaVrMtqINfG7Uu
   6V7qu0P4VuZ/Dy6yiU1e6lKiHFty5vvPJ9FoFVKMkYMadRYABcHmZpebm
   o7VNvTXrCRWzL4zTLOgklCyLnGTvM461NoMy6f3zlJHltwHYcXmbRyRj9
   w==;
X-CSE-ConnectionGUID: 48aHq+NjSIq+2+pvmT8/xA==
X-CSE-MsgGUID: LDZ36ghYQQ6MzP1IJyf32w==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="24856083"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="24856083"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 11:17:15 -0700
X-CSE-ConnectionGUID: gzXxzQaaSfitNbIruoYuNA==
X-CSE-MsgGUID: TLmHuW19RZepR63bDO16pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="67435198"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 11:17:15 -0700
Date: Fri, 31 May 2024 11:17:13 -0700
From: Tony Luck <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v19 06/20] x86/resctrl: Introduce snc_nodes_per_l3_cache
Message-ID: <ZloUKaU9tm_lIe05@agluck-desk3.sc.intel.com>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <20240528222006.58283-7-tony.luck@intel.com>
 <b0e17f5e-210d-4aa3-9410-f1829b570c4b@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0e17f5e-210d-4aa3-9410-f1829b570c4b@intel.com>

On Thu, May 30, 2024 at 01:20:39PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/28/24 3:19 PM, Tony Luck wrote:
> > Intel Sub-NUMA Cluster (SNC) is a feature that subdivides the CPU cores
> > and memory controllers on a socket into two or more groups. These are
> > presented to the operating system as NUMA nodes.
> > 
> > This may enable some workloads to have slightly lower latency to memory
> > as the memory controller(s) in an SNC node are electrically closer to the
> > CPU cores on that SNC node. This cost may be offset by lower bandwidth
> > since the memory accesses for each core can only be interleaved between
> > the memory controllers on the same SNC node.
> > 
> > Resctrl monitoring on an Intel system depends upon attaching RMIDs to tasks
> > to track L3 cache occupancy and memory bandwidth. There is an MSR that
> > controls how the RMIDs are shared between SNC nodes.
> > 
> > The default mode divides them numerically. E.g. when there are two SNC
> > nodes on a socket the lower number half of the RMIDs are given to the
> > first node, the remainder to the second node. This would be difficult
> > to use with the Linux resctrl interface as specific RMID values assigned
> > to resctrl groups are not visible to users.
> > 
> > The other mode divides the RMIDs and renumbers the ones on the second
> > SNC node to start from zero.
> > 
> > Even with this renumbering SNC mode requires several changes in resctrl
> > behavior for correct operation.
> > 
> > Add a static global to arch/x86/kernel/cpu/resctrl/monitor.c to indicate
> > how many SNC domains share an L3 cache instance.  Initialize this to
> > "1". Runtime detection of SNC mode will adjust this value.
> > 
> > Update all places to take appropriate action when SNC mode is enabled:
> > 1) The number of logical RMIDs per L3 cache available for use is the
> >     number of physical RMIDs divided by the number of SNC nodes.
> > 2) Likewise the "mon_scale" value must be divided by the number of SNC
> >     nodes.
> > 3) Add a function to convert from logical RMID values (assigned to
> >     tasks and loaded into the IA32_PQR_ASSOC MSR on context switch)
> >     to physical RMID values to load into IA32_QM_EVTSEL MSR when
> >     reading counters on each SNC node.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >   arch/x86/kernel/cpu/resctrl/monitor.c | 37 ++++++++++++++++++++++++---
> >   1 file changed, 33 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> > index 89d7e6fcbaa1..b9b4d2b5ca82 100644
> > --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> > +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> > @@ -97,6 +97,8 @@ unsigned int resctrl_rmid_realloc_limit;
> >   #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
> > +static int snc_nodes_per_l3_cache = 1;
> > +
> >   /*
> >    * The correction factor table is documented in Documentation/arch/x86/resctrl.rst.
> >    * If rmid > rmid threshold, MBM total and local values should be multiplied
> > @@ -185,10 +187,37 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
> >   	return entry;
> >   }
> > -static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
> > +/*
> > + * When Sub-NUMA Cluster (SNC) mode is not enabled, the physical RMID
> > + * is the same as the logical RMID.
> > + *
> > + * When SNC mode is enabled the physical RMIDs are distributed across
> > + * the SNC nodes. E.g. with two SNC nodes per L3 cache and 200 physical
> > + * RMIDs are divided with 0..99 on the first node and 100..199 on
> > + * the second node. Compute the value of the physical RMID to pass to
> > + * resctrl_arch_rmid_read().
> 
> Please stop rushing version after version. I do not think you read the
> above after you wrote it. The sentences run into each other.

Re-written. Would you like to try reviewing these patches one at a time
as I fix them? That will:

a) Slow me down.
b) Avoid me building subsequent patches on earlier mistakes.
c) Give you bite-sized chunks to review in each sitting (I think
   the overall direction of the series is well enough understood
   at this point).

I've attached the updated version of patch 6 at the end of this e-mail.

> Could this be specific about what is meant by "physical" and "logical" RMID?
> To me "physical RMID" implies the RMID used by hardware and "logical RMID"
> is the RMID used by software ... but when it comes to SNC it is actually:
> "physical RMID" - RMID used by MSR_IA32_QM_EVTSEL
> "logical RMID" - RMID used by software and the MSR_IA32_PQR_ASSOC register
> 
> > + *
> > + * Caller is responsible to make sure execution running on a CPU in
> 
> "is responsible" and "make sure" means the same, no?
> 
> "make sure execution running"?

Also re-written.

> (Looking ahead in this series and coming back to this, this looks like
> rushed work that you in turn expect folks spend quality time reviewing.)
> 
> > + * the domain to be read.
> > + */
> > +static int logical_rmid_to_physical_rmid(int lrmid)
> > +{
> > +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> > +	int cpu = smp_processor_id();
> > +
> > +	if (snc_nodes_per_l3_cache  == 1)
> > +		return lrmid;
> > +
> > +	return lrmid + (cpu_to_node(cpu) % snc_nodes_per_l3_cache) * r->num_rmid;
> > +}
> > +
> > +static int __rmid_read(u32 lrmid,
> > +		       enum resctrl_event_id eventid, u64 *val)
> 
> This line does not need to be split.

Joined now. I also pulled in your suggestion from a later patch to
rename this __rmid_read_phys() and do the logical to physical RMID
translation at the two callsites.

> >   {
> >   	u64 msr_val;
> > +	int prmid;
> > +	prmid = logical_rmid_to_physical_rmid(lrmid);
> >   	/*
> >   	 * As per the SDM, when IA32_QM_EVTSEL.EvtID (bits 7:0) is configured
> >   	 * with a valid event code for supported resource type and the bits
> > @@ -197,7 +226,7 @@ static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
> >   	 * IA32_QM_CTR.Error (bit 63) and IA32_QM_CTR.Unavailable (bit 62)
> >   	 * are error bits.
> >   	 */
> > -	wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid);
> > +	wrmsr(MSR_IA32_QM_EVTSEL, eventid, prmid);
> >   	rdmsrl(MSR_IA32_QM_CTR, msr_val);
> >   	if (msr_val & RMID_VAL_ERROR)
> > @@ -1022,8 +1051,8 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
> >   	int ret;
> >   	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
> > -	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale;
> > -	r->num_rmid = boot_cpu_data.x86_cache_max_rmid + 1;
> > +	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
> > +	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;
> >   	hw_res->mbm_width = MBM_CNTR_WIDTH_BASE;
> >   	if (mbm_offset > 0 && mbm_offset <= MBM_CNTR_WIDTH_OFFSET_MAX)
> 
> Reinette

-Tony

Proposed v6 patch with fixes applied. I didn't include a URL
to the RDT architecture spec I reference in the comment  for
logical_rmid_to_physical_rmid() because Intel URLs are notoriously
unstable. But I did check that a web search finds the document based on
the title. With Google it was second hit for me. Bing lists it as first
result.

From ab33bacb9bf4dcf7b04310c1296b9dacddc4cd80 Mon Sep 17 00:00:00 2001
From: Tony Luck <tony.luck@intel.com>
Date: Thu, 30 May 2024 09:45:35 -0700
Subject: [PATCH] x86/resctrl: Introduce snc_nodes_per_l3_cache

Intel Sub-NUMA Cluster (SNC) is a feature that subdivides the CPU cores
and memory controllers on a socket into two or more groups. These are
presented to the operating system as NUMA nodes.

This may enable some workloads to have slightly lower latency to memory
as the memory controller(s) in an SNC node are electrically closer to the
CPU cores on that SNC node. This cost may be offset by lower bandwidth
since the memory accesses for each core can only be interleaved between
the memory controllers on the same SNC node.

Resctrl monitoring on an Intel system depends upon attaching RMIDs to tasks
to track L3 cache occupancy and memory bandwidth. There is an MSR that
controls how the RMIDs are shared between SNC nodes.

The default mode divides them numerically. E.g. when there are two SNC
nodes on a socket the lower number half of the RMIDs are given to the
first node, the remainder to the second node. This would be difficult
to use with the Linux resctrl interface as specific RMID values assigned
to resctrl groups are not visible to users.

RMID sahring mode divides the RMIDs and renumbers the ones on the second
SNC node to start from zero.

Even with this renumbering SNC mode requires several changes in resctrl
behavior for correct operation.

Add a static global to arch/x86/kernel/cpu/resctrl/monitor.c to indicate
how many SNC domains share an L3 cache instance.  Initialize this to
"1". Runtime detection of SNC mode will adjust this value.

Update all places to take appropriate action when SNC mode is enabled:
1) The number of logical RMIDs per L3 cache available for use is the
   number of physical RMIDs divided by the number of SNC nodes.
2) Likewise the "mon_scale" value must be divided by the number of SNC
   nodes.
3) Add a function to convert from logical RMID values (assigned to
   tasks and loaded into the IA32_PQR_ASSOC MSR on context switch)
   to physical RMID values to load into IA32_QM_EVTSEL MSR when
   reading counters on each SNC node.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 52 +++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 89d7e6fcbaa1..0b05dfb5ab67 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -97,6 +97,8 @@ unsigned int resctrl_rmid_realloc_limit;
 
 #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
 
+static int snc_nodes_per_l3_cache = 1;
+
 /*
  * The correction factor table is documented in Documentation/arch/x86/resctrl.rst.
  * If rmid > rmid threshold, MBM total and local values should be multiplied
@@ -185,7 +187,39 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
 	return entry;
 }
 
-static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
+/*
+ * When Sub-NUMA Cluster (SNC) mode is not enabled the RMID value
+ * loaded into IA32_PQR_ASSOC for the CPU to accumulate data is
+ * the same as the RMID value loaded into IA32_QM_EVTSEL to
+ * retrieve the current value of counters from IA32_QM_CTR.
+ *
+ * When SNC mode is enabled in RMID sharing mode there are fewer
+ * RMID values available to accumulate data (RMIDs are divided
+ * evenly between SNC nodes that share an L3 cache). Here we refer
+ * to the value loaded into IA32_PQR_ASSOC as the "logical RMID".
+ *
+ * Data is collected independently on each SNC node and can be retrieved
+ * using the "physical RMID" value computed by this function. The
+ * cpu argument can be any CPU in the SNC domain for the node.
+ *
+ * Note that the scope of the IA32_QM_EVTSEL and IA32_QM_CTR MSRs is
+ * still at the L3 cache scope. So a physical RMID may be read from any
+ * CPU that shares the L3 cache with the desired SNC node domain.
+ *
+ * For more details and examples see the "RMID Sharing Mode" section
+ * in the "Intel Resource Director Technology Architecture Specification".
+ */
+static int logical_rmid_to_physical_rmid(int cpu, int lrmid)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+
+	if (snc_nodes_per_l3_cache  == 1)
+		return lrmid;
+
+	return lrmid + (cpu_to_node(cpu) % snc_nodes_per_l3_cache) * r->num_rmid;
+}
+
+static int __rmid_read_phys(u32 prmid, enum resctrl_event_id eventid, u64 *val)
 {
 	u64 msr_val;
 
@@ -197,7 +231,7 @@ static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
 	 * IA32_QM_CTR.Error (bit 63) and IA32_QM_CTR.Unavailable (bit 62)
 	 * are error bits.
 	 */
-	wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid);
+	wrmsr(MSR_IA32_QM_EVTSEL, eventid, prmid);
 	rdmsrl(MSR_IA32_QM_CTR, msr_val);
 
 	if (msr_val & RMID_VAL_ERROR)
@@ -233,14 +267,17 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
 			     enum resctrl_event_id eventid)
 {
 	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
+	int cpu = cpumask_any(&d->hdr.cpu_mask);
 	struct arch_mbm_state *am;
+	u32 prmid;
 
 	am = get_arch_mbm_state(hw_dom, rmid, eventid);
 	if (am) {
 		memset(am, 0, sizeof(*am));
 
+		prmid = logical_rmid_to_physical_rmid(cpu, rmid);
 		/* Record any initial, non-zero count value. */
-		__rmid_read(rmid, eventid, &am->prev_msr);
+		__rmid_read_phys(prmid, eventid, &am->prev_msr);
 	}
 }
 
@@ -275,8 +312,10 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
 {
 	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
+	int cpu = cpumask_any(&d->hdr.cpu_mask);
 	struct arch_mbm_state *am;
 	u64 msr_val, chunks;
+	u32 prmid;
 	int ret;
 
 	resctrl_arch_rmid_read_context_check();
@@ -284,7 +323,8 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
 	if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
 		return -EINVAL;
 
-	ret = __rmid_read(rmid, eventid, &msr_val);
+	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
+	ret = __rmid_read_phys(prmid, eventid, &msr_val);
 	if (ret)
 		return ret;
 
@@ -1022,8 +1062,8 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
 	int ret;
 
 	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
-	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale;
-	r->num_rmid = boot_cpu_data.x86_cache_max_rmid + 1;
+	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
+	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;
 	hw_res->mbm_width = MBM_CNTR_WIDTH_BASE;
 
 	if (mbm_offset > 0 && mbm_offset <= MBM_CNTR_WIDTH_OFFSET_MAX)
-- 
2.45.0

