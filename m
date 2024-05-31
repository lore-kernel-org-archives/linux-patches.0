Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F3B1367
	for <patches@lists.linux.dev>; Fri, 31 May 2024 00:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717115168; cv=none; b=sEq1uoLCo0LJGWox9TQ1OmXyGbRerRupfWM6zO/3K4AkyZeiqP2+38iZB2OyJjUfTHXBzhr4NS1kr98/XBdhAROvO0QbDkWwVLcRplVrItcSpUbNR7zCZU2lDwP45+6f7RUXPM/fF01D6CkVTnhEUd6J7DWuSAL/mpYgYQdh4uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717115168; c=relaxed/simple;
	bh=2Ky422DEIg3Jw2hTeXVdbGZmfah7IqL0/fd8RjVrXYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LWU+nrV7qtyjoy7eFDIwPttQxTBsm9lmaWJ1TpPFNO8qa021ZIU4UGlS6TZ1mFO7sG6Fkd6tihKY3FjyLJvNBj/bfyD3nI0vd745AhtMoK2m9/pvE20dZWcFpbFId4u5U/PHYHmFC8Eb79B+eEqSU778tKHqLUrZOwCOH5JKFnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bw96Wql6; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bw96Wql6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717115166; x=1748651166;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=2Ky422DEIg3Jw2hTeXVdbGZmfah7IqL0/fd8RjVrXYQ=;
  b=bw96Wql6p9A2pYMVBIXbr+vg5HN8h0jheMR7d+/8UmSrQjLjYPGnXqhk
   nGge/yOn1Y5syDNLy4p3W3fleDeUsMmrOxW96piQAfZkJifd2+V7zh0+7
   R2RDpACg8oGIqtLWFmHZ/bnzNKiUrXh73UU8ecX4b1Pa2tQB1HidBVlw3
   g2KFcS2YWyGe2XsepXGcnCF364tshAyjb7cD1lBm1+kOqjDajuob3QHeh
   Q1JrUR8WgNa2lY5pbZ+/8yqq6mqSgASDbc0NLlsF6t3gE8rxol0wGXw64
   ux6/tNBppwV9x5fuWlA221mv5w5t46ljzgao/1oIzQXwLe+6ciyg2V7WQ
   Q==;
X-CSE-ConnectionGUID: KOfRYkBIQG6aEb7hvCntaw==
X-CSE-MsgGUID: q6GMiBpCTfqIXoliA5n0aw==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="31174388"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="31174388"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 17:26:05 -0700
X-CSE-ConnectionGUID: t983usbUQuSTBLOpcIAgLA==
X-CSE-MsgGUID: K5mKGmECQnWD1/FSUh7mbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="35952940"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 17:26:04 -0700
Date: Thu, 30 May 2024 17:26:03 -0700
From: Tony Luck <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v19 08/20] x86/resctrl: Prepare for new Sub-NUMA Cluster
 (SNC) monitor files
Message-ID: <ZlkZG5bgsU6hY0Ok@agluck-desk3.sc.intel.com>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <20240528222006.58283-9-tony.luck@intel.com>
 <fe9a4cd5-f74d-4c89-8667-8b5b1841b84e@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fe9a4cd5-f74d-4c89-8667-8b5b1841b84e@intel.com>

On Thu, May 30, 2024 at 01:21:01PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/28/24 3:19 PM, Tony Luck wrote:
> > When SNC is enabled monitoring data is collected at the SNC node
> > granularity, but must be reported at L3-cache granularity for
> > backwards compatibility in addition to reporting at the node
> > level.
> > 
> > Add a "ci" field to the rdt_mon_domain structure to save the
> > cache information about the enclosing L3 cache for the domain.
> > This provides:
> > 
> > 1) The cache id which is needed to compose the name of the legacy
> > monitoring directory, and to determine which domains should be
> > summed to provide L3-scoped data.
> > 
> > 2) The shared_cpu_map which is needed to determine which CPUs can
> > be used to read the RMID counters with the MSR interface.
> > 
> > This is the first step to an eventual goal of monitor reporting files
> > like this (for a system with two SNC nodes per L3):
> > 
> > $ cd /sys/fs/resctrl/mon_data
> > $ tree mon_L3_00
> > mon_L3_00			<- 00 here is L3 cache id
> > ├── llc_occupancy		\  These files provide legacy support
> > ├── mbm_local_bytes		 > for non-SNC aware monitor apps
> > ├── mbm_total_bytes		/  that expect data at L3 cache level
> > ├── mon_sub_L3_00		<- 00 here is SNC node id
> > │   ├── llc_occupancy		\  These files are finer grained
> > │   ├── mbm_local_bytes		 > data from each SNC node
> > │   └── mbm_total_bytes		/
> > └── mon_sub_L3_01
> >      ├── llc_occupancy		\
> >      ├── mbm_local_bytes		 > As above, but for node 1.
> >      └── mbm_total_bytes		/
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >   include/linux/resctrl.h                   |  2 ++
> >   arch/x86/kernel/cpu/resctrl/internal.h    | 21 +++++++++++++++++++++
> >   arch/x86/kernel/cpu/resctrl/core.c        |  7 ++++++-
> >   arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  1 -
> >   arch/x86/kernel/cpu/resctrl/rdtgroup.c    |  1 -
> >   5 files changed, 29 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> > index 64b6ad1b22a1..d733e1f6485d 100644
> > --- a/include/linux/resctrl.h
> > +++ b/include/linux/resctrl.h
> > @@ -96,6 +96,7 @@ struct rdt_ctrl_domain {
> >   /**
> >    * struct rdt_mon_domain - group of CPUs sharing a resctrl monitor resource
> >    * @hdr:		common header for different domain types
> > + * @ci:			cache info for this domain
> >    * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
> >    * @mbm_total:		saved state for MBM total bandwidth
> >    * @mbm_local:		saved state for MBM local bandwidth
> > @@ -106,6 +107,7 @@ struct rdt_ctrl_domain {
> >    */
> >   struct rdt_mon_domain {
> >   	struct rdt_domain_hdr		hdr;
> > +	struct cacheinfo		*ci;
> >   	unsigned long			*rmid_busy_llc;
> >   	struct mbm_state		*mbm_total;
> >   	struct mbm_state		*mbm_local;
> > diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> > index 135190e0711c..eb70d3136ced 100644
> > --- a/arch/x86/kernel/cpu/resctrl/internal.h
> > +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> > @@ -2,6 +2,7 @@
> >   #ifndef _ASM_X86_RESCTRL_INTERNAL_H
> >   #define _ASM_X86_RESCTRL_INTERNAL_H
> > +#include <linux/cacheinfo.h>
> >   #include <linux/resctrl.h>
> >   #include <linux/sched.h>
> >   #include <linux/kernfs.h>
> > @@ -509,6 +510,26 @@ static inline bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level l)
> >   int resctrl_arch_set_cdp_enabled(enum resctrl_res_level l, bool enable);
> > +/*
> > + * Get the cacheinfo structure of the cache associated with @cpu at level @level.
> > + * cpuhp lock must be held.
> > + */
> > +static inline struct cacheinfo *get_cpu_cacheinfo_level(int cpu, int level)
> > +{
> > +	struct cpu_cacheinfo *ci = get_cpu_cacheinfo(cpu);
> > +	int i;
> > +
> > +	for (i = 0; i < ci->num_leaves; i++) {
> > +		if (ci->info_list[i].level == level) {
> > +			if (ci->info_list[i].attributes & CACHE_ID)
> > +				return &ci->info_list[i];
> > +			break;
> > +		}
> > +	}
> > +
> > +	return NULL;
> > +}
> > +
> 
> This does not belong in resctrl. It really looks to partner well with existing
> cache helpers in include/linux/cacheinfo.h that already contains get_cpu_cacheinfo_id().
> Considering the existing naming get_cpu_cacheinfo() may be more appropriate.

Reinette,

The name get_cpu_cacheinfo() already exists and does something different
(returns a "struct cpu_cacheinfo *" rather than a "struct cacheinfo *").

How does this look for the change to <linux/cacheinfo.h> ... add a new
function get_cpu_cacheinfo_level() and then use it as a helper for the
existing get_cpu_cacheinfo_id()

-Tony

---

diff --git a/include/linux/cacheinfo.h b/include/linux/cacheinfo.h
index 2cb15fe4fe12..301b0b24f446 100644
--- a/include/linux/cacheinfo.h
+++ b/include/linux/cacheinfo.h
@@ -113,10 +113,10 @@ int acpi_get_cache_info(unsigned int cpu,
 const struct attribute_group *cache_get_priv_group(struct cacheinfo *this_leaf);
 
 /*
- * Get the id of the cache associated with @cpu at level @level.
+ * Get the cacheinfo structure for cache associated with @cpu at level @level.
  * cpuhp lock must be held.
  */
-static inline int get_cpu_cacheinfo_id(int cpu, int level)
+static inline struct cacheinfo *get_cpu_cacheinfo_level(int cpu, int level)
 {
 	struct cpu_cacheinfo *ci = get_cpu_cacheinfo(cpu);
 	int i;
@@ -124,12 +124,23 @@ static inline int get_cpu_cacheinfo_id(int cpu, int level)
 	for (i = 0; i < ci->num_leaves; i++) {
 		if (ci->info_list[i].level == level) {
 			if (ci->info_list[i].attributes & CACHE_ID)
-				return ci->info_list[i].id;
-			return -1;
+				return &ci->info_list[i];
+			return NULL;
 		}
 	}
 
-	return -1;
+	return NULL;
+}
+
+/*
+ * Get the id of the cache associated with @cpu at level @level.
+ * cpuhp lock must be held.
+ */
+static inline int get_cpu_cacheinfo_id(int cpu, int level)
+{
+	struct cacheinfo *ci = get_cpu_cacheinfo_level(cpu, level);
+
+	return ci ? ci->id : -1;
 }
 
 #ifdef CONFIG_ARM64
