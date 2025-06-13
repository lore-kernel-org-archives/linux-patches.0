Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1C01A254C
	for <patches@lists.linux.dev>; Fri, 13 Jun 2025 18:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749840633; cv=none; b=gceFPfwLqPBi7IacjCFHe2qbgu5HN/YbYBCETQrNZGAgWtcNrmEFckJjFxMsYodunwbpbL82bQloDtsTZztt0JKGXWClbrLu5/MnjyU7DuLPo9JkHaJransL1/r+5QhapVS4y4JEi/zK9hKPiNRUtRR36/YCqHQqc9E4HBilMPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749840633; c=relaxed/simple;
	bh=i/Gfxl/wiPrxxvaYYAkwLreZvqrQzGxv+RxlokwTDU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mDueW5G4e70tHqIaRDuXB8P1UNZFxhEBvF/tOTDUKPmqptbGaY2RZOvFdl6sl5v38jxPYRfgEOVo/vGHbzP6ELuOZVlPC9LP7hVFAB80sNYOH/vwxMU+4Mw0jMftV27qUcs/VNHAvE2dPQdWelaJtQQmBeKyu83DKELhOouZX6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lt+eNgSk; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lt+eNgSk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749840630; x=1781376630;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=i/Gfxl/wiPrxxvaYYAkwLreZvqrQzGxv+RxlokwTDU0=;
  b=lt+eNgSkUPzES+s2A2oPDReFvwAvBIxqsfberQiixUfKtgG5YxnIP7Xd
   PG96+nXDqe3J+YbAPf8pilh3VO3kns27eJ+vhEkg47++bQVN04Y4aHbvv
   74HWvFROyGkXUx9uY3+4t6VJZSUHf0KOyERlQn+jgR/tiNqjcuLImEM1h
   ViJJTXLMeSe9c75FmTVsbCnXIMUpl149zvZk32wqfzK3wbGlFZ5nzDEJi
   /6ZUhKrcE4Rs5eHZMXNgsRUD4g7W7Z3IfWupjEsX/9O1ShB9azI2IIxlr
   4GtIm7H4Wwm7xpu6ze41jC2F6Skaq42vQw5X5+97Qb4yjhbq0+PImZioJ
   w==;
X-CSE-ConnectionGUID: wrGLse5rSZCZDU+cF55FUA==
X-CSE-MsgGUID: ZJPQyWnmQ5i27IvgUiJepw==
X-IronPort-AV: E=McAfee;i="6800,10657,11463"; a="51983735"
X-IronPort-AV: E=Sophos;i="6.16,234,1744095600"; 
   d="scan'208";a="51983735"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 11:50:29 -0700
X-CSE-ConnectionGUID: ajKwJW+JRo2+gvj049xEag==
X-CSE-MsgGUID: XvjvCcJmQc6A877hJNAUOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,234,1744095600"; 
   d="scan'208";a="178795645"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 11:50:29 -0700
Date: Fri, 13 Jun 2025 11:50:27 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: James Morse <james.morse@arm.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v5 00/29] x86/resctrl telemetry monitoring
Message-ID: <aExy8_zLNMrH2UeZ@agluck-desk3>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <61133be0-1ace-457c-9b0f-d6dde3003389@arm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <61133be0-1ace-457c-9b0f-d6dde3003389@arm.com>

On Fri, Jun 13, 2025 at 05:57:26PM +0100, James Morse wrote:
> Hi Tony,
> 
> I'm still going through this, but here is my attempt to describe what equivalents arm has
> in this area.
> 
> 
> On 21/05/2025 23:50, Tony Luck wrote:
> > Background
> > ----------
> > 
> > Telemetry features are being implemented in conjunction with the
> > IA32_PQR_ASSOC.RMID value on each logical CPU. This is used to send
> > counts for various events to a collector in a nearby OOBMSM device to be
> > accumulated with counts for each <RMID, event> pair received from other
> > CPUs. Cores send event counts when the RMID value changes, or after each
> > 2ms elapsed time.
> 
> This is a shared memory area where an external agent (the OOBMSM) has logged measurement data?

Yes. Effectively shared memory (but in another address space so need to
use readq(addr) rather than just *addr to read values to keep sparse
happy).

> Arm's equivalent to this is two things.
> For things close to the CPU (e.g. stalls_llc_miss) these would be an PMU (possibly uncore
> PMU) which follow a convention on their register layout meaning the general purpose pmu
> driver should be able to drive them. The meaning of the events is described to user-space
> via the perf json file. The kernel knows how to read event:6, but not what event:6 means.
> The spec for this mentions MPAM, values can be monitored by ~RMID, but none of this is
> managed by the MPAM driver.
> 
> The other thing arm has that is a bit like this is SCMI, which is a packet format for
> talking to an on-die microcontroller to get platform specific temperature, voltage and
> clock values. Again, this is another bit of kernel infrastructure that has its own way of
> doing things. I don't see this filtering things by ~RMID ... but I guess its possible.
> That can have shared memory areas (termed 'fast channels'). I think they are an array of
> counter values, and something in the packet stream tells you which one is which.
> 
> 
> Neither of these need picking up by the MPAM driver to expose via resctrl. But I'd like to
> get that information across where possible so that user-space can be portable.
> 
> 
> > Each OOBMSM device may implement multiple event collectors with each
> > servicing a subset of the logical CPUs on a package.  In the initial
> > hardware implementation, there are two categories of events: energy
> > and perf.
> > 
> > 1) Energy - Two counters
> > core_energy: This is an estimate of Joules consumed by each core. It is
> > calculated based on the types of instructions executed, not from a power
> > meter. This counter is useful to understand how much energy a workload
> > is consuming.
> > 
> > activity: This measures "accumulated dynamic capacitance". Users who
> > want to optimize energy consumption for a workload may use this rather
> > than core_energy because it provides consistent results independent of
> > any frequency or voltage changes that may occur during the runtime of
> > the application (e.g. entry/exit from turbo mode).
> 
> > 2) Performance - Seven counters
> > These are similar events to those available via the Linux "perf" tool,
> > but collected in a way with much lower overhead (no need to collect data
> > on every context switch).
> > 
> > stalls_llc_hit - Counts the total number of unhalted core clock cycles
> > when the core is stalled due to a demand load miss which hit in the LLC
> > 
> > c1_res - Counts the total C1 residency across all cores. The underlying
> > counter increments on 100MHz clock ticks
> > 
> > unhalted_core_cycles - Counts the total number of unhalted core clock
> > cycles
> > 
> > stalls_llc_miss - Counts the total number of unhalted core clock cycles
> > when the core is stalled due to a demand load miss which missed all the
> > local caches
> > 
> > c6_res - Counts the total C6 residency. The underlying counter increments
> > on crystal clock (25MHz) ticks
> > 
> > unhalted_ref_cycles - Counts the total number of unhalted reference clock
> > (TSC) cycles
> > 
> > uops_retired - Counts the total number of uops retired
> > 
> > The counters are arranged in groups in MMIO space of the OOBMSM device.
> > E.g. for the energy counters the layout is:
> > 
> > Offset: Counter
> > 0x00	core energy for RMID 0
> > 0x08	core activity for RMID 0
> > 0x10	core energy for RMID 1
> > 0x18	core activity for RMID 1
> > ...
> 
> For the performance counters especially, on arm I'd be trying to get these values by
> teaching perf about the CLOSID/RMID values, so that perf events are only incremented for
> tasks in a particular control/monitor group.
> (why that might be relevant is below)

Yes. If perf is enhanced to take CLOSID/RMID into account when
accumulating event counts it can provide the same functionality.

Higher overhead since perf needs to sample event counters of
interest on every context switch instead of data collection
being handled by hardware.

On the other hand the perf approach is more flexible as you can
pick any event to sample per-RMID instead of the fixed set that
the h/w designer chose.

> 
> > Resctrl User Interface
> > ----------------------
> > 
> > Because there may be multiple OOBMSM collection agents per processor
> > package, resctrl accumulates event counts from all agents on a package
> > and presents a single value to users. This will provide a consistent
> > user interface on future platforms that vary the number of collectors,
> > or the mappings from logical CPUs to collectors.
> 
> Great!
> 
> 
> > Users will continue to see the legacy monitoring files in the "L3"
> > directories and the telemetry files in the new "PERF_PKG" directories
> > (with each file providing the aggregated value from all OOBMSM collectors
> > on that package).
> > 
> > $ tree /sys/fs/resctrl/mon_data/
> > /sys/fs/resctrl/mon_data/
> > ├── mon_L3_00
> > │   ├── llc_occupancy
> > │   ├── mbm_local_bytes
> > │   └── mbm_total_bytes
> > ├── mon_L3_01
> > │   ├── llc_occupancy
> > │   ├── mbm_local_bytes
> > │   └── mbm_total_bytes
> 
> > ├── mon_PERF_PKG_00
> 
> Where do the package ids come from? How can user-space find out which CPUs are in package-0?

Resctrl gets the id from topology_physical_package_id(cpu);
> 
> I don't see a package_id in either /sys/devices/system/cpu/cpu0/topology or
> Documentation/ABI/stable/sysfs-devices-system-cpu.

These package IDs show up on x86 with these file names:

$ grep ^ /sys/devices/system/cpu/cpu0/topology/*package*
/sys/devices/system/cpu/cpu0/topology/package_cpus:0000,00000fff,ffffff00,0000000f,ffffffff
/sys/devices/system/cpu/cpu0/topology/package_cpus_list:0-35,72-107
/sys/devices/system/cpu/cpu0/topology/physical_package_id:0

> 
> > │   ├── activity
> > │   ├── c1_res
> > │   ├── c6_res
> > │   ├── core_energy
> > │   ├── stalls_llc_hit
> > │   ├── stalls_llc_miss
> > │   ├── unhalted_core_cycles
> > │   ├── unhalted_ref_cycles
> > │   └── uops_retired
> > └── mon_PERF_PKG_01
> >     ├── activity
> >     ├── c1_res
> >     ├── c6_res
> >     ├── core_energy
> >     ├── stalls_llc_hit
> >     ├── stalls_llc_miss
> >     ├── unhalted_core_cycles
> >     ├── unhalted_ref_cycles
> >     └── uops_retired
> 
> Looks good to me.
> 
> The difficulty MPAM platforms have had with mbm_total_bytes et al is the "starts counting
> from the beginning of time" property. Having to enable mbm_total_bytes before it counts
> would have allowed MPAM to report an error if it couldn't enable more than N counters at a
> time. (ABMC suggests AMD platforms have a similar problem).

Resctrl goes to some lengths to have mbm_total_bytes start from zero
when you mkdir a group even when some old RMID is re-used that has
got some left over value from its previous lifetime. This isn't
overly painful because resctrl has to carry lots of per-RMID state
to handle the wraparound of the narrow counters.

The Intel telemetry counters are 63 bits (lose one bit for the VALID
indication). So wrap around is no concern at all for most of them
as it happens in centuries/millennia. Potentially the uops_retired
counter might wrap in months, but that only happens if every logical
CPU is running with the same RMID for that whole time. So I've chosen
to ignore wraparound. As a result counters don't start from zero when
a group is created. I don't see this as an issue because all use cases
are "read a counter; wait some interval; re-read the counter; compute
the rate" which doesn't require starting from zero.

> 
> How do you feel about having to enable these before they start counting?
> 
> This would allow the MPAM driver to open the event via perf if it has a corresponding
> feature/counter, then provide the value from perf via resctrl.

You'd have resctrl report "Unavailable" for these until connecting the
plumbing to perf to provide data?

> 
> Another headache is how we describe the format of the contents of these files... a  made
> up example: residency counts could be in absolute time, or percentages. I've been bitten
> by the existing schemata strings being implicitly in a particular format, meaning
> conversions have to happen. I'm not sure whether some architecture/platform would trip
> over the same problem here.

Reinette is adamant that format of each resctrl event file must be
fixed. So if different systems report residency in different ways,
you'd either have to convert to some common format, or if that isn't
possible, those would have to appear in resctrl as different filenames.
E.g. "residency_absolute" and "residency_percentage".

> 
> > Resctrl Implementation
> > ----------------------
> > 
> > The OOBMSM driver exposes "intel_pmt_get_regions_by_feature()"
> > that returns an array of structures describing the per-RMID groups it
> > found from the VSEC enumeration. Linux looks at the unique identifiers
> > for each group and enables resctrl for all groups with known unique
> > identifiers.
> > 
> > The memory map for the counters for each <RMID, event> pair is described
> > by the XML file. This is too unwieldy to use in the Linux kernel, so a
> > simplified representation is built into the resctrl code.
> 
> (I hope there are only a few combinations!)

Almost certain to have a new description for each CPU generation since
the number of RMIDs is embedded in the description. If the overall
structure stays the same, then each new instance is described by a
dozen or so lines of code to initialize a data structure, so I think
an acceptable level of pain.

> 
> > Note that the
> > counters are in MMIO space instead of accessed using the IA32_QM_EVTSEL
> > and IA32_QM_CTR MSRs. This means there is no need for cross-processor
> > calls to read counters from a CPU in a specific domain.
> 
> Huzzah! RISC-V has this property, and many MPAM platforms do, (...but not all...)
> 
> 
> > The counters can be read from any CPU.
> > 
> > High level description of code changes:
> > 
> > 1) New scope RESCTRL_PACKAGE
> > 2) New struct rdt_resource RDT_RESOURCE_PERF_PKG
> > 3) Refactor monitor code paths to split existing L3 paths from new ones. In some cases this ends up with:
> >         switch (r->rid) {
> >         case RDT_RESOURCE_L3:
> >                 helper for L3
> >                 break;
> >         case RDT_RESOURCE_PERF_PKG:
> >                 helper for PKG
> >                 break;
> >         }
> > 4) New source code file "intel_aet.c" for the code to enumerate, configure, and report event counts.
> > 
> > With only one platform providing this feature, it's tricky to tell
> > exactly where it is going to go. I've made the event definitions
> > platform specific (based on the unique ID from the VSEC enumeration). It
> > seems possible/likely that the list of events may change from generation
> > to generation.
> 
> My thinking about this from a perf angle was to have named events for those things that
> resctrl supports, but allow events to be specified by number, and funnel those through
> resctrl_arch_rmid_read() so that the arch code can interpret them as a counter type-id or
> an offset in some array. The idea was to allow platform specific counters to be read
> without any kernel changes, reducing the pressure to add resctrl support for counters that
> may only ever be present in a single platform.
> 
> With the XML data you have, would it be possible to add new 'events' to this interface via
> sysfs/configfs? Or does too much depend on the data identified by that GUID...

Maybe. There are a number of parameters that need to be provided for an
event:
1) Scope. Must be something that resctrl already knows (and is actively
using?) L2/L3 cache, node, package.
2) Base address(es) for counters for this event.
3) Parameters for F(RMID) to compute offset from base
4) Type of access (mmio_read, MSR_read, other?)
5) post-process needed after read (check for valid? maybe other things)

Might be best to try some PoC implementation to see which of those are
required vs. overkill. Also to see whatI missed from the list.
> 
> 
> Thanks,
> 
> James

-Tony
