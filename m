Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320F4219A86
	for <patches@lists.linux.dev>; Mon, 31 Mar 2025 21:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743455386; cv=none; b=bOs4+XWcKWQXV4iiGUMEmccBI8fcog9ylDrtSJzX0QY1n8PkfFemow32tZhXI9BmxfQohH/OtF+nPTstwhekG8NCmd34wIrKAp6VkMhXy+q+tk8XnE5ErRrBPnXn60+0fFsR7gzqKm1NlJ4XujptupjsbFeMD80BpXzdjDWA0vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743455386; c=relaxed/simple;
	bh=0PdwCXHaWxCcWBHDdCYwmX9WuzivXoiVTmd9yF67r1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s3k1K3vuBNJ9hcKIvh1kJJ/gb8lEMWNvXNvJW4YpvUs5HW8gEX+PsT3t1O0juXf77csAIiIDjJbuhcwSew7i3SXEBsvktgQnlUmapUGuunvo4XkcEi6eUx5weo09wpumsz39BLbWF2w8Zp+VijoXHld4NJ0GzYw9q35EfilHRzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BgK4/tyE; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BgK4/tyE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743455383; x=1774991383;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0PdwCXHaWxCcWBHDdCYwmX9WuzivXoiVTmd9yF67r1A=;
  b=BgK4/tyE/AkL5UABVozxD/Uq5r6RQAtieDIQ8dG88kohC+OfdAZ94OWz
   ApXsGZQGu9dK5JcLQ2Pj798Pu1El9sIqcyDHpbSCVTW61mqO3rMErRobL
   fvMkkQGiByyGuDSRcBwXFi2bD/d2woo+3fRQNotMo7nGTpil43aeB3Wrs
   CdL7vyrDZ7YHWznbPov+nH6HvZ6j8rkrf0igRh4gllC0NVoAlfrjPcY5U
   YpWg3jVKgyr9pqBg6G2LjWq+K3IsMkbOmFBbPGJPFl8rDGrpzulZfU5Pn
   AhVev/2lhpFlMuU5GiT96+GuFIW7BjbbYLdIDFibCWVBEXF+RdLyEWjOz
   g==;
X-CSE-ConnectionGUID: Q7svB+5kQlW5Iq0RSEeo9g==
X-CSE-MsgGUID: lfFB9TsLSzW4yamlsRLvlA==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="44771191"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="44771191"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 14:09:42 -0700
X-CSE-ConnectionGUID: UuDmdYRbSV+IzxDgg4ckDg==
X-CSE-MsgGUID: 3XWJYOVsR5uDg4FXFNBMEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="126191150"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 14:09:42 -0700
Date: Mon, 31 Mar 2025 14:09:40 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 01/16] x86/rectrl: Fake OOBMSM interface
Message-ID: <Z-sElKJOGyw3eflV@agluck-desk3>
References: <20250321231609.57418-1-tony.luck@intel.com>
 <20250321231609.57418-2-tony.luck@intel.com>
 <b69bee17-6a84-4cb2-ab8a-2793c2fe7c49@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b69bee17-6a84-4cb2-ab8a-2793c2fe7c49@intel.com>

On Mon, Mar 31, 2025 at 09:14:55AM -0700, Reinette Chatre wrote:
> Hi Tony,

Thanks for the review.

> (nit in shortlog: rectrl -> resctrl)
> 
> On 3/21/25 4:15 PM, Tony Luck wrote:
> > Real version is coming soon ... this is here so the remaining parts
> > will build (and run ... assuming a 2 socket system that supports RDT
> > monitoring ... only missing part is that the event counters just
> > report fixed values).
> > 
> > Real version of this would just add the INTEL_AET_RESCTRL Kconfig
> > option with dependency checks on
> >   INTEL_VSEC=y && INTEL_AET_TELEMETRY=y && INTEL_AET_DISCOVERY=y
> > 
> > Just for RFC discussion.
> 
> Would appreciate a bit more detail about what OOBMSM provides
> to be able to understand this series.

Short answer is just what you see in this structure:

struct telemetry_region {
   struct oobmsm_plat_info plat_info;
   void __iomem            *addr;
   size_t                  size;
   u32                     guid;
   u32                     num_rmids;
};

I've passed on your suggestion for some comments on the
definition to David Box, since this structure will be part
of his patches to enable the discovery of OOBMSM features.

The trail for breadcrumbs from this to event counters is:
1) Lookup the "guid" in XML files at https://github.com/intel/Intel-PMT
2) Each of those lists each event counter in the MMIO region referred
to by the <addr,size> fields in excruciating detail. E.g. for the first
register (at offset 0 from "addr"):

  <TELI:description>Accumulated core energy usage across all cores running RMID 0</TELI:description>
          <TELI:SampleType>Snapshot</TELI:SampleType>
          <TransFormInputs xmlns="http://schemas.intel.com/telemetry/base/common">
                  <TransFormInput varName="parameter_0">
                          <sampleGroupIDREF>Container_0</sampleGroupIDREF>
                          <sampleIDREF>RMID_0_CORE_ENERGY</sampleIDREF>
                  </TransFormInput>
          </TransFormInputs>
          <TELI:transformREF>U63.45.18</TELI:transformREF>
  </TELI:T_AggregatorSample>
  <TELI:T_AggregatorSample sampleName="RMID_0_CORE_ENERGY_VALID" sampleGroup="RMID_0_CORE_ENERGY" datatypeIDREF="tcounter_valid" sampleID="1">
          <TELI:description>If set, RMID_0_CORE_ENERGY counter reading is valid</TELI: description>
          <TELI:SampleType>Snapshot</TELI:SampleType>
          <TransFormInputs xmlns="http://schemas.intel.com/telemetry/base/common">
                  <TransFormInput varName="parameter_0">
                          <sampleGroupIDREF>Container_0</sampleGroupIDREF>
                          <sampleIDREF>RMID_0_CORE_ENERGY_VALID</sampleIDREF>
                  </TransFormInput>
          </TransFormInputs>
          <TELI:transformREF>passthru</TELI:transformREF>
  </TELI:T_AggregatorSample>

This verbosity repeats for each of the events for RMID 0, then for RMID 1, 2, ...

The important bits for Linux are the name, the type, and the valid bit.

I will add more comments to the Linux structures when they are added
in one of the later patches in this series.
> 
> Even though changelog mentions "event counters" I am not able to
> recognize any unique events provided by this interface. Instead it
> just seems to provide a memory region that is entirely up to resctrl
> to interpret based on the "unique identifier" hinted to in cover letter.
> I could not find any description that connects the "unique identifier"
> to the "guid" used in following patches. I think it will be helpful to
> upfront connect the high level "unique identifier" with the "guid" that
> the patches use to make this obvious.
> 
> Closest information to something that can be used by resctrl is
> "num_rmids". Could you please add information on how "num_rmids" relates
> to the memory region that is only specified via an addr and size?
> 
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  .../cpu/resctrl/fake_intel_aet_features.h     | 73 +++++++++++++++++++
> >  .../cpu/resctrl/fake_intel_aet_features.c     | 65 +++++++++++++++++
> >  arch/x86/Kconfig                              |  1 +
> >  arch/x86/kernel/cpu/resctrl/Makefile          |  1 +
> >  drivers/platform/x86/intel/pmt/Kconfig        |  3 +
> >  5 files changed, 143 insertions(+)
> >  create mode 100644 arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.h
> >  create mode 100644 arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c
> > 
> > diff --git a/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.h b/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.h
> > new file mode 100644
> > index 000000000000..c835c4108abc
> > --- /dev/null
> > +++ b/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.h
> > @@ -0,0 +1,73 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +/* Bits stolen from OOBMSM VSEC discovery code */
> > +
> > +enum pmt_feature_id {
> > +	FEATURE_INVALID			= 0x0,
> > +	FEATURE_PER_CORE_PERF_TELEM	= 0x1,
> > +	FEATURE_PER_CORE_ENV_TELEM	= 0x2,
> > +	FEATURE_PER_RMID_PERF_TELEM	= 0x3,
> > +	FEATURE_ACCEL_TELEM		= 0x4,
> > +	FEATURE_UNCORE_TELEM		= 0x5,
> > +	FEATURE_CRASH_LOG		= 0x6,
> > +	FEATURE_PETE_LOG		= 0x7,
> > +	FEATURE_TPMI_CTRL		= 0x8,
> > +	FEATURE_RESERVED		= 0x9,
> > +	FEATURE_TRACING			= 0xA,
> > +	FEATURE_PER_RMID_ENERGY_TELEM	= 0xB,
> > +	FEATURE_MAX			= 0xB,
> > +};
> > +
> > +/**
> > + * struct oobmsm_plat_info - Platform information for a device instance
> > + * @cdie_mask:       Mask of all compute dies in the partition
> > + * @package_id:      CPU Package id
> > + * @partition:       Package partition id when multiple VSEC PCI devices per package
> > + * @segment:         PCI segment ID
> > + * @bus_number:      PCI bus number
> > + * @device_number:   PCI device number
> > + * @function_number: PCI function number
> > + *
> > + * Structure to store platform data for a OOBMSM device instance.
> > + */
> > +struct oobmsm_plat_info {
> > +	u16 cdie_mask;
> > +	u8 package_id;
> > +	u8 partition;
> > +	u8 segment;
> > +	u8 bus_number;
> > +	u8 device_number;
> > +	u8 function_number;
> > +};
> > +
> > +enum oobmsm_supplier_type {
> > +	OOBMSM_SUP_PLAT_INFO,
> > +	OOBMSM_SUP_DISC_INFO,
> > +	OOBMSM_SUP_S3M_SIMICS,
> > +	OOBMSM_SUP_TYPE_MAX
> > +};
> > +
> > +struct oobmsm_mapping_supplier {
> > +	struct device *supplier_dev[OOBMSM_SUP_TYPE_MAX];
> > +	struct oobmsm_plat_info plat_info;
> > +	unsigned long features;
> > +};
> > +
> > +struct telemetry_region {
> > +	struct oobmsm_plat_info	plat_info;
> > +	void __iomem		*addr;
> > +	size_t			size;
> > +	u32			guid;
> > +	u32			num_rmids;
> > +};
> 
> Could there be some description of what a "telemetry_region" is and
> how the members should be interpreted by resctrl?

As mentioned above. I passed this request to David Box.

> > +
> > +struct pmt_feature_group {
> > +	enum pmt_feature_id	id;
> > +	int			count;
> > +	struct kref		kref;
> > +	struct telemetry_region	regions[];
> > +};
> > +
> > +struct pmt_feature_group *intel_pmt_get_regions_by_feature(enum pmt_feature_id id);
> > +
> > +void intel_pmt_put_feature_group(struct pmt_feature_group *feature_group);
> > diff --git a/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c b/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c
> > new file mode 100644
> > index 000000000000..b537068d99fb
> > --- /dev/null
> > +++ b/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c
> > @@ -0,0 +1,65 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +#include <linux/cleanup.h>
> > +#include <linux/minmax.h>
> > +#include <linux/slab.h>
> > +#include "fake_intel_aet_features.h"
> > +#include <linux/intel_vsec.h>
> > +#include <linux/resctrl.h>
> > +
> > +#include "internal.h"
> > +
> > +#define ENERGY_QWORDS	((576 * 2) + 3)
> > +#define PERF_QWORDS	((576 * 7) + 3)
> > +
> > +static long pg[4 * ENERGY_QWORDS + 2 * PERF_QWORDS];
> > +
> > +static int __init fill(void)
> > +{
> > +	u64 val = 0;
> > +
> > +	for (int i = 0; i < sizeof(pg); i += sizeof(val)) {
> > +		pg[i / sizeof(val)] = BIT_ULL(63) + val;
> > +		val++;
> > +	}
> > +	return 0;
> > +}
> > +device_initcall(fill);
> > +
> > +#define PKG_REGION(_entry, _guid, _addr, _pkg)	\
> > +	[_entry] = { .guid = _guid, .addr = (void __iomem *)_addr, .plat_info = { .package_id = _pkg }}
> > +
> > +static struct pmt_feature_group fake_energy = {
> > +	.count = 4,
> > +	.regions = {
> > +		PKG_REGION(0, 0x26696143, &pg[0 * ENERGY_QWORDS], 0),
> > +		PKG_REGION(1, 0x26696143, &pg[1 * ENERGY_QWORDS], 0),
> > +		PKG_REGION(2, 0x26696143, &pg[2 * ENERGY_QWORDS], 1),
> > +		PKG_REGION(3, 0x26696143, &pg[3 * ENERGY_QWORDS], 1)
> > +	}
> > +};
> > +
> > +static struct pmt_feature_group fake_perf = {
> > +	.count = 2,
> > +	.regions = {
> > +		PKG_REGION(0, 0x26557651, &pg[4 * ENERGY_QWORDS + 0 * PERF_QWORDS], 0),
> > +		PKG_REGION(1, 0x26557651, &pg[4 * ENERGY_QWORDS + 1 * PERF_QWORDS], 1)
> > +	}
> > +};
> 
> Could there be some guidance on how to interpret the hardcoded data? For example,
> one group contains two regions and the other four. Was this just done for testing
> to ensure implementation supports multiple regions per package or ...? 
> Is it expected that multiple feature groups could have different number of regions?
> I also think initializing the id would be helpful to understand the example better.

You are correct. The varying number of regions was simply to exercise
the code that needs to aggregate values from multiple regions. The
first implementation of this has homogeneous aggregators all working
for the same events from the same CPUs. But I don't see that as a
requirement. I could envision a system with different aggregators
for different events, perhaps servicing different groups of CPUs on
the same package.

> > +
> > +struct pmt_feature_group *
> > +intel_pmt_get_regions_by_feature(enum pmt_feature_id id)
> > +{
> > +	switch (id) {
> > +	case FEATURE_PER_RMID_ENERGY_TELEM:
> > +		return &fake_energy;
> > +	case FEATURE_PER_RMID_PERF_TELEM:
> > +		return &fake_perf;
> > +	default:
> > +		return ERR_PTR(-ENOENT);
> > +	}
> > +	return ERR_PTR(-ENOENT);
> > +}
> > +
> > +void intel_pmt_put_feature_group(struct pmt_feature_group *feature_group)
> > +{
> > +}
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index ea29d22a621f..6112cb6cad05 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -504,6 +504,7 @@ config X86_CPU_RESCTRL
> >  	bool "x86 CPU resource control support"
> >  	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
> >  	depends on MISC_FILESYSTEMS
> > +	select INTEL_AET_RESCTRL	if X86_64
> 
> I expect something like this will stay (i.e. not part of the "Fake" code).
> In this case, should this perhaps only be selected on Intel (CPU_SUP_INTEL)?
> (nit: the tab is unexpected)

Yes, this part isn't fake, and is should depend on CPU_SUP_INTEL.

> >  	select ARCH_HAS_CPU_RESCTRL
> >  	select RESCTRL_FS
> >  	select RESCTRL_FS_PSEUDO_LOCK
> > diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
> > index 909be78ec6da..2c3b09f95127 100644
> > --- a/arch/x86/kernel/cpu/resctrl/Makefile
> > +++ b/arch/x86/kernel/cpu/resctrl/Makefile
> > @@ -2,6 +2,7 @@
> >  obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
> >  obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
> >  obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
> > +obj-$(CONFIG_INTEL_AET_RESCTRL)		+= fake_intel_aet_features.o
> >  
> >  # To allow define_trace.h's recursive include:
> >  CFLAGS_pseudo_lock.o = -I$(src)
> > diff --git a/drivers/platform/x86/intel/pmt/Kconfig b/drivers/platform/x86/intel/pmt/Kconfig
> > index e916fc966221..6d3b1f64efe9 100644
> > --- a/drivers/platform/x86/intel/pmt/Kconfig
> > +++ b/drivers/platform/x86/intel/pmt/Kconfig
> > @@ -38,3 +38,6 @@ config INTEL_PMT_CRASHLOG
> >  
> >  	  To compile this driver as a module, choose M here: the module
> >  	  will be called intel_pmt_crashlog.
> > +
> > +config INTEL_AET_RESCTRL
> > +	bool
> 
> I expect that this will also stay ... if so, could this be expanded to
> have needed dependency and also be accompanied by some documentation. Something like
> "Architecture selects this when ...." This will make it clear that this is
> not something a user will select during kernel build while also explaining
> what it is used for.

This part will also stay. I will add a comment as you suggest.

> Reinette

-Tony
