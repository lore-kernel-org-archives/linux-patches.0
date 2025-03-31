Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED2921ADC5
	for <patches@lists.linux.dev>; Mon, 31 Mar 2025 22:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743460194; cv=none; b=ot874NZ+6faa3o7RWV++IAnxPw2wJjXQwBGfGh+D5ZZU54oZH1BhdkIh6eToUjQIESXaH8jxbdW5y7ODkPi3uwBUupUdb9/pjQWz4UX0DbC8L/dOj6uEHToVwNiTbio3Rb3z1uPldU+EQec8HNX2phUFrPLQtKsUs3AJ9sQvEbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743460194; c=relaxed/simple;
	bh=dmaYoJ3xIKd2ptaybOmMo55rxMw5JSNXVhC0cyeQVA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nWwLRemrzEFeik/aZIhpJGMHlLczi/jfRzxR7XC2v4hz34xYQpVmHH2bRgprUqBa6cZKTODruIm49rDy+92XSLo0q2Y8A6Cf7bw5igO5wbE7OEVWycKuObAHeB7Ia4S/90r5kTN3294HZt8u696K9jog+M2GHxH5+WFAZyOCPr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ey1JrvV+; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ey1JrvV+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743460194; x=1774996194;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dmaYoJ3xIKd2ptaybOmMo55rxMw5JSNXVhC0cyeQVA0=;
  b=Ey1JrvV+kzhYj+SE5Iwe8zodjMixaQw32jA4fFGXYfuHtIGg25xWc1Lw
   bp52hX/op3upfr5YZZHwsIo5OPfeNjhxmsc17FMokcXtixznNniPTVMe8
   i2Ryd8TWAD0aUX1USmSrAKOHOnRTj8yooXvv4DQBQzHZ26fuoixDuDEIH
   5ZjtOAcK4AcaPxrRgXZm1tuDQnf3AhtHm+e32ZAYvRB94OSvFmgZqV7ew
   YnkQnGXcQVCmv64ofXdNaZL4RaUr43PC9TLIwfuSrzhDCMvxN3uO8+p5n
   L68d1ju7v3mOj3k++twsOUCYYP/xmv+6UIKf+KzeS7MXmi8zNCdlAdcfO
   A==;
X-CSE-ConnectionGUID: 8gKBvQxfT96Ata2Ev219Xw==
X-CSE-MsgGUID: DwibwKTITfeDjvPxFaGdog==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="44674933"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="44674933"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 15:29:51 -0700
X-CSE-ConnectionGUID: BQwwTpHLQ7WI+CfjIujVvw==
X-CSE-MsgGUID: eu5YQbnhRdW/zP3FEugUxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="157121900"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 15:29:50 -0700
Date: Mon, 31 Mar 2025 15:29:48 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 11/16] x86/resctrl: Link known events onto
 RDT_RESOURCE_INTEL_AET.evt_list
Message-ID: <Z-sXXAYQA5iMiMzN@agluck-desk3>
References: <20250321231609.57418-1-tony.luck@intel.com>
 <20250321231609.57418-12-tony.luck@intel.com>
 <10df8cbf-3b7c-461f-8a0d-bcc6b87444c0@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10df8cbf-3b7c-461f-8a0d-bcc6b87444c0@intel.com>

On Mon, Mar 31, 2025 at 09:23:14AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 3/21/25 4:16 PM, Tony Luck wrote:
> > Core code uses this list to populate "mon_data" directories.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  arch/x86/kernel/cpu/resctrl/intel_aet.c | 23 ++++++++++++++++++++++-
> >  1 file changed, 22 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > index e2d8eab997fc..9ac912742ef1 100644
> > --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > @@ -13,6 +13,7 @@
> >  
> >  #include <linux/cpu.h>
> >  #include <linux/cleanup.h>
> > +#include <linux/minmax.h>
> >  #include <linux/slab.h>
> >  #include "fake_intel_aet_features.h"
> >  #include <linux/intel_vsec.h>
> > @@ -308,14 +309,34 @@ void rdt_get_intel_aet_mount(void)
> >  {
> >  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_INTEL_AET].r_resctrl;
> >  	struct rdt_core_mon_domain *d, *tmp;
> > +	struct telem_entry **tentry;
> >  	static int do_one_time;
> > +	struct mon_evt *evt;
> > +	bool ret = false;
> >  
> >  	if (do_one_time)
> >  		return;
> >  
> >  	do_one_time = 1;
> >  
> > -	if (!get_events()) {
> > +	if (!get_events())
> > +		goto done;
> > +
> > +	for (tentry = telem_entry; *tentry; tentry++) {
> > +		if (!(*tentry)->active)
> > +			continue;
> > +		for (int i = 0; (*tentry)->evts[i].evt.name; i++) {
> > +			evt = &(*tentry)->evts[i].evt;
> > +			list_add_tail(&evt->list, &r->evt_list);
> > +			ret = true;
> > +		}
> 
> Architecture code should not be doing this. I expect this will be something
> similar to l3_mon_evt_init() done by fs code after the architecture had
> opportunity to configure which events are supported. 

If we do put all possible events into the architecture code, then it can
do something like:

	for_each_set_bit(evt, &rdt_mon_features, NUM_EVENTS)
		list_add(...);

My speculative patch:
	https://lore.kernel.org/all/20250314202609.5753-1-tony.luck@intel.com/
did this for the existing events, so could build on it.

> I wonder if resctrl_mon_resource_init() could be moved to rdt_get_tree()
> to be called after the new (yet to be named) "resctrl_arch_for_arch_to_do_needed_on_resctrl_mount()"
> resctrl_mon_resource_init() could be enhanced to do any needed resctrl fs
> initialization for this new feature. This will include being able to 
> learn the accurate counts of rmid supported by the system to be able to
> create monitor groups that can be supported by all monitoring resources?
> 
> > +		if (!r->num_rmid)
> > +			r->num_rmid = (*tentry)->num_rmids;
> > +		else
> > +			r->num_rmid = min(r->num_rmid, (*tentry)->num_rmids);
> > +	}
> > +done:
> > +	if (!ret) {
> >  		list_for_each_entry_safe(d, tmp, &r->mon_domains, hdr.list)
> >  			kfree(d);
> >  		r->mon_capable = false;
> 
> Reinette

-Tony
