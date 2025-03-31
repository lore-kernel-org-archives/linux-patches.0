Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D8521B9D9
	for <patches@lists.linux.dev>; Mon, 31 Mar 2025 21:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743456145; cv=none; b=lLE1Rd8fDij1VneeHe3J0hKmR+37XuOY4OxP3YR1+k5uosGMCGsXVRepEAnngA8dCykY1eNYsQqB4pSIrEJ3C5Rl0XfEoO4Fcx3eGhRsmFwRS/y7GVYehhtvY+UwE+gUruTHYkwUD9cSMtmEauaSyyD5R3jk+ITPVfVRzDcak/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743456145; c=relaxed/simple;
	bh=rKav0JmmyVgTRwoYHiKEDVHyDTN/Jdtmh/51Tpk45Zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G/98igF/iXsRbGA8xGaioHT5gYuzf6hKrKCRdUdB8reytfgbIXYynC+uXv5zkwGX/kiG80RHfm3ME+syPumXJ9PdzDUDNNIltAn+R1hO6dIjAC7EcHAVDKNvkz1iW/eoicKXZKs5bO/fV3gNfr11EG7Joe4JJKFZz+4dPaNecCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d6y+J5VL; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d6y+J5VL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743456144; x=1774992144;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rKav0JmmyVgTRwoYHiKEDVHyDTN/Jdtmh/51Tpk45Zs=;
  b=d6y+J5VL47lMweCVPetwvBRNUga/WCY1jEwYB1qYbweQSuBulGIL3P97
   UhC2mBRWHuP/ORGu8DPkSi4OMUZTHJjg3zln5iL78vjzGa+u3tJ/DE9Du
   tt47mzfA5Z2pVMKUARia8OZtPujNKDwupuVUWMfigqk6qO6ADMOC9j/+I
   DKl6g55jELanOD0IacrpZLvWNb1RXP001LQiw9+BmJm/6qYjzO3deVrVl
   AbUjtQBanlqBZy0HA/7SJz2vPg0bv+nvme7nvWwjXQJqFnAOLu0e20yDL
   WF43lPMuuswZkTaFDxL1U/5nxx42KKr/LOxMjs3w31HAVE34i5rQCQz0v
   A==;
X-CSE-ConnectionGUID: 03ViAsXqTGi3DioJz8/VLg==
X-CSE-MsgGUID: lV3tIL+SRCC9W5tQTpuVuA==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="44670579"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="44670579"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 14:22:23 -0700
X-CSE-ConnectionGUID: LJTqj3IGRFyOACY+wGOrPQ==
X-CSE-MsgGUID: FZyT9hCsRB6ZSzOJMLYz9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="126423139"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 14:22:22 -0700
Date: Mon, 31 Mar 2025 14:22:21 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 05/16] x86/resctrl: Add and initialize rdt_resource
 for package scope core monitor
Message-ID: <Z-sHjRxLDwGDP68i@agluck-desk3>
References: <20250321231609.57418-1-tony.luck@intel.com>
 <20250321231609.57418-6-tony.luck@intel.com>
 <1dcd185a-17b9-446f-a19f-fc2355c4c6ea@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1dcd185a-17b9-446f-a19f-fc2355c4c6ea@intel.com>

On Mon, Mar 31, 2025 at 09:18:12AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 3/21/25 4:15 PM, Tony Luck wrote:
> > New resource for monitoring core events reported at package level.
> 
> Could you please add proper (per Documentation/process/maintainer-tip.rst)
> changelogs to all patches in the series?

Will do.

> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  include/linux/resctrl.h            |  1 +
> >  include/linux/resctrl_types.h      |  1 +
> >  fs/resctrl/internal.h              |  2 ++
> >  arch/x86/kernel/cpu/resctrl/core.c | 11 +++++++++++
> >  fs/resctrl/rdtgroup.c              |  2 ++
> >  5 files changed, 17 insertions(+)
> > 
> > diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> > index 25c3ee78de3d..6c895ec220fe 100644
> > --- a/include/linux/resctrl.h
> > +++ b/include/linux/resctrl.h
> > @@ -233,6 +233,7 @@ enum resctrl_scope {
> >  	RESCTRL_L2_CACHE = 2,
> >  	RESCTRL_L3_CACHE = 3,
> >  	RESCTRL_L3_NODE,
> > +	RESCTRL_PACKAGE,
> >  };
> >  
> >  /**
> > diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
> > index a7faf2cd5406..8f967e03af5a 100644
> > --- a/include/linux/resctrl_types.h
> > +++ b/include/linux/resctrl_types.h
> > @@ -39,6 +39,7 @@ enum resctrl_res_level {
> >  	RDT_RESOURCE_L2,
> >  	RDT_RESOURCE_MBA,
> >  	RDT_RESOURCE_SMBA,
> > +	RDT_RESOURCE_INTEL_AET,
> 
> This is fs code so architecture specific code needs to be avoided. Any other
> architecture that may need to report similar data would be forced to use this
> resource name.

Maybe  RDT_RESOURCE_PERF?

> >  
> >  	/* Must be the last */
> >  	RDT_NUM_RESOURCES,
> > diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> > index ec3863d18f68..3a100007301d 100644
> > --- a/fs/resctrl/internal.h
> > +++ b/fs/resctrl/internal.h
> > @@ -240,6 +240,8 @@ struct rdtgroup {
> >  
> >  #define RFTYPE_DEBUG			BIT(10)
> >  
> > +#define RFTYPE_RES_PKG			BIT(11)
> 
> "PKG" is not the resource but instead the scope, no?

Correct. I missed this one when doing some renaming. It should
get a "perf" name (to match what we pick for the RDT_RESOURCE)

> > +
> >  #define RFTYPE_CTRL_INFO		(RFTYPE_INFO | RFTYPE_CTRL)
> >  
> >  #define RFTYPE_MON_INFO			(RFTYPE_INFO | RFTYPE_MON)
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index c316268b4442..c8cc3104f56c 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -99,6 +99,15 @@ struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
> >  			.schema_fmt		= RESCTRL_SCHEMA_RANGE,
> >  		},
> >  	},
> > +	[RDT_RESOURCE_INTEL_AET] =
> > +	{
> > +		.r_resctrl = {
> > +			.rid			= RDT_RESOURCE_INTEL_AET,
> > +			.name			= "PKG",
> 
> The resource name should not be the scope. It should be a name that reflects the
> resource being monitored. In this case it is "core"/"cpu"? I understand that this may
> create confusion since the data is provided at package scope so perhaps the "resource"
> can be "perf" and then all the events can include "core" in their name? If the intention
> is to guide user space in how to interpret the domain IDs then we could consider
> something like "perf_pkg" or even "phys_pkg_perf" that prepares resctrl for future perf
> events that may need reporting at a different scope?

"perf_pkg" looks like a good option. Should it be "PERF_PKG". It appears
to the user in the names of the "mon_data/mon_%s_%.2d" directories. Also
in info/%s_MON.

Resctrl uses "L3" in captitals in those places.

> > +			.mon_scope		= RESCTRL_PACKAGE,
> > +			.mon_domains		= mon_domain_init(RDT_RESOURCE_INTEL_AET),
> > +		},
> > +	},
> >  };
> >  
> >  u32 resctrl_arch_system_num_rmid_idx(void)
> > @@ -430,6 +439,8 @@ static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
> >  		return get_cpu_cacheinfo_id(cpu, scope);
> >  	case RESCTRL_L3_NODE:
> >  		return cpu_to_node(cpu);
> > +	case RESCTRL_PACKAGE:
> > +		return topology_physical_package_id(cpu);
> >  	default:
> >  		break;
> >  	}
> > diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> > index dbfb7d3bc3bc..a90291f57330 100644
> > --- a/fs/resctrl/rdtgroup.c
> > +++ b/fs/resctrl/rdtgroup.c
> > @@ -2179,6 +2179,8 @@ static unsigned long fflags_from_resource(struct rdt_resource *r)
> >  	case RDT_RESOURCE_MBA:
> >  	case RDT_RESOURCE_SMBA:
> >  		return RFTYPE_RES_MB;
> > +	case RDT_RESOURCE_INTEL_AET:
> > +		return RFTYPE_RES_PKG;
> >  	}
> >  
> >  	return WARN_ON_ONCE(1);
> 
> 
> Reinette
