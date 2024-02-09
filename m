Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B1133CF1
	for <patches@lists.linux.dev>; Fri,  9 Feb 2024 18:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707504302; cv=none; b=SlA0P4+PDCVd0JMXsPX83PUPP2Bnp7VGheVFBAlAtELqdBIBwMWoE1XplzU2NxjX5vzR0Pjw0PdxlWRPUSLNat0FY4hnsoMRWBDwIS3/kluGt+moppcCzcCFsqonnZh/OTuhfXvlhOGClyIEN+YcmIg42C5gAamSgzFklmF119o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707504302; c=relaxed/simple;
	bh=r99sVZ3dN5h4LRp+rYDgytD8f2JrBqu/IHxuwknZauQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=On9n4SrHai4DaXklZlVRsMSRqxmB0a48630/Lc7lro//wdhdU/TpdvKvUu+aCmFA5sbuPXgxesThrOnewSooeMId+DmWQUtFl4eT0eH/PAC3+ywzdH8Y2hvMoJlMTEO1t2mY76yMhVk2RdlAxZ5kqtdk1g2KMRswKYbImKHBAgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZjTEhcx7; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZjTEhcx7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707504301; x=1739040301;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r99sVZ3dN5h4LRp+rYDgytD8f2JrBqu/IHxuwknZauQ=;
  b=ZjTEhcx77Zw/XJfD2MSOH93V0ZpzSXSkD3RD65nW4bgOcoZeoQVsxWpR
   URxmbc+rdCkLyPX4XwQLvTgXTZweVU3R4t2uWO4LYMEJ7UqnHZJAsBSCJ
   cZLDkB/hX0pp2Drd94ZAzCX7NQwufF+/1PcpxfTGfCDTgdi72t+QSYD/a
   iitoA3VLHOxj+gekdmfRUpCJJGUyWl0y2e2GmDlfvEolPcS4REN1CErBY
   1KRQ4kmK4Zjqggrk2m7TVTLbjnXF6f+SpeGd8smWA41apx8k3UDp5MHNx
   uGlZDAz+MrW0ZkL/pVkOXI7Rxgd5YLtmjykBbKXMdS25vIBosCPRSJ8YG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10979"; a="12568173"
X-IronPort-AV: E=Sophos;i="6.05,257,1701158400"; 
   d="scan'208";a="12568173"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2024 10:45:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,257,1701158400"; 
   d="scan'208";a="2042411"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.74])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2024 10:45:00 -0800
Date: Fri, 9 Feb 2024 10:44:58 -0800
From: Tony Luck <tony.luck@intel.com>
To: "Moger, Babu" <babu.moger@amd.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org,
	Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Drew Fustini <dfustini@baylibre.com>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v15-RFC 1/8] x86/resctrl: Split the RDT_RESOURCE_L3
 resource
Message-ID: <ZcZyqs5hnQqZ5ZV0@agluck-desk3>
References: <20240126223837.21835-1-tony.luck@intel.com>
 <20240130222034.37181-1-tony.luck@intel.com>
 <20240130222034.37181-2-tony.luck@intel.com>
 <c9629380-c97c-4797-b6b3-5044d5beeb97@amd.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9629380-c97c-4797-b6b3-5044d5beeb97@amd.com>

On Fri, Feb 09, 2024 at 09:28:16AM -0600, Moger, Babu wrote:
> >  enum resctrl_res_level {
> > +	RDT_RESOURCE_L3_MON,
> >  	RDT_RESOURCE_L3,
> 
> How about?
> RDT_RESOURCE_L3,
> RDT_RESOURCE_L3_MON,

Does the order matter? I put the L3_MON one first because historically
cache occupancy was the first resctrl tool. But if you have a better
argument for the order, then I can change it.

> >  	RDT_RESOURCE_L2,
> >  	RDT_RESOURCE_MBA,
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index aa9810a64258..c50f55d7790e 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -60,6 +60,16 @@ mba_wrmsr_amd(struct rdt_domain *d, struct msr_param *m,
> >  #define domain_init(id) LIST_HEAD_INIT(rdt_resources_all[id].r_resctrl.domains)
> >  
> >  struct rdt_hw_resource rdt_resources_all[] = {
> > +	[RDT_RESOURCE_L3_MON] =
> > +	{
> > +		.r_resctrl = {
> > +			.rid			= RDT_RESOURCE_L3_MON,
> > +			.name			= "L3",
> 
> L3_MON ?

That was my first choice too. But I found:

$ ls /sys/fs/resctrl/info
L3  L3_MON_MON  last_cmd_status  MB

This would be easy to fix ... just change this code to not append
an extra "_MON" to the directory name:

        for_each_mon_capable_rdt_resource(r) {
                fflags = r->fflags | RFTYPE_MON_INFO;
                sprintf(name, "%s_MON", r->name);
                ret = rdtgroup_mkdir_info_resdir(r, name, fflags);
                if (ret)
                        goto out_destroy;
        }

But I also saw this:
$ ls /sys/fs/resctrl/mon_data/
mon_L3_MON_00  mon_L3_MON_01

which didn't seem to have an easy fix. So I took the easy route and left
the ".name" field as "L3_MON".

-Tony
