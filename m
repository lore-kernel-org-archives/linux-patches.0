Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5D2181BA3
	for <patches@lists.linux.dev>; Tue, 14 May 2024 21:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715723586; cv=none; b=SQrS2CgP4VfDVzYACJjo/W25H07O0IOkxX4rU5Rbxi0G+wnk6ZHHtFd+DqB0YenE+q8b9nJ70yU6vzJkZaStNDlSOQ14LdMRxUAB2ibIKlopSKtkkYe+Sqo90wMNIEdvA2Thle6jXSOsL3yuMbKhHCfkeQk2CKWBZorsWr/Wd+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715723586; c=relaxed/simple;
	bh=2M+FInE/lrnYInW0wW9bQowLmoHwZVKEyZK4ZsQUCSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TiGwVXB42kj2Pd+99sqHKIFq/jouSsVu7tuCDLSRJtoqk8ckN0b2LjV1fipG/wOWqWdzqCajCtI6jbbTlOeALMN5HqE5UOwMDT4UULsBBkXjsPjCb1ScrnDYVS1+5WTRev5+N4nweGhf/HqciKZ3L5gYgGu6fJ/axDWHLOz1dCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hXnIOwRu; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hXnIOwRu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715723583; x=1747259583;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2M+FInE/lrnYInW0wW9bQowLmoHwZVKEyZK4ZsQUCSE=;
  b=hXnIOwRuA02nljjByBwJPi/TkiMnCdaiRTeA5+ZP6zIkWtB8bjlV3qbQ
   WPJ2MrMcqjkg/AdUhBBJmvU3LRxlfOQYVyTRfkDjH0PYP3wn6sX4SVTre
   gZsEba5GAQ1lb1Yq8NcXa4ekLhow/ZHob0OsIyaDTt90EfrWOFXTiRN+z
   CHK48smb9x5X80DBJ6xYX2MGOcXtQs6pgZjVwWRviPMkKvCTzv4Hk6iBq
   4Tb/WEZYgSEzCJLPo+gGXDTPwKGG7IrD8sN1YIglJrT6QTs5+YT+h1ZN9
   o6WTav9EvCTxp3lIulArW0A/570cHmRIzFX3UoNAgmk/3u80iIiLi9OYd
   A==;
X-CSE-ConnectionGUID: LVvxafjVR2uFH8dHwB8VAA==
X-CSE-MsgGUID: Ri/txIg0TdiEWklllInyLg==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="11599992"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="11599992"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 14:53:02 -0700
X-CSE-ConnectionGUID: 7w534L2IQomymjeaKL+3gg==
X-CSE-MsgGUID: +VSdj60ATnmZvcKi13jeBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="54042189"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.105])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 14:53:03 -0700
Date: Tue, 14 May 2024 14:53:01 -0700
From: Tony Luck <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v17 7/9] x86/resctrl: Add new monitor files for Sub-NUMA
 cluster (SNC) monitoring
Message-ID: <ZkPdPTbgH-0EpBc4@agluck-desk3>
References: <20240503203325.21512-1-tony.luck@intel.com>
 <20240503203325.21512-8-tony.luck@intel.com>
 <0178e84e-d55f-47bf-b8b0-58e05fcaa108@intel.com>
 <ZkJIZdU2knEUJN7Q@agluck-desk3>
 <f49931b0-d9bf-45f0-ab35-93b1a78f6b97@intel.com>
 <ZkKupOKRu5S7Rkgx@agluck-desk3>
 <2efcae46-736a-4809-8530-7dde3977f3ce@intel.com>
 <SJ1PR11MB60838E2DB2984EF95D34C692FCE32@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <b718c70b-21ea-4c4d-9ecf-387b8276a721@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b718c70b-21ea-4c4d-9ecf-387b8276a721@intel.com>

On Tue, May 14, 2024 at 01:30:05PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/14/2024 11:26 AM, Luck, Tony wrote:
> >> On 5/13/2024 5:21 PM, Tony Luck wrote:
> >>> On Mon, May 13, 2024 at 11:53:17AM -0700, Reinette Chatre wrote:
> >>>> On 5/13/2024 10:05 AM, Tony Luck wrote:
> >>>>> On Fri, May 10, 2024 at 02:24:13PM -0700, Reinette Chatre wrote:
> >>>>> Thanks for the review. Detailed comments below. But overall I'm
> >>>>> going to split patch 7 into a bunch of smaller changes, each with
> >>>>> a better commit message.
> >>>>>
> >>>>>> On 5/3/2024 1:33 PM, Tony Luck wrote:
> >>>>>>
> >>>>>> (Could you please start the changelog with some context?)
> >>>>>>
> >>>>>>> Add a field to the rdt_resource structure to track whether monitoring
> >>>>>>> resources are tracked by hardware at a different scope (NODE) from
> >>>>>>> the legacy L3 scope.
> >>>>>>
> >>>>>> This seems to describe @mon_scope that was introduced in patch #3?
> >>>>>
> >>>>> Not really. Patch #3 made the change so that control an monitor
> >>>>> functions can have different scope. That's still needed as with SNC
> >>>>> enabled the underlying data collection is at the node level for
> >>>>> monitoring, while control stays at the L3 cache scope.
> >>>>>
> >>>>> This new field describes the legacy scope of monitoring, so that
> >>>>> resctrl can provide correctly scoped monitor files for legacy
> >>>>> applications that aren't aware of SNC. So I'm using this both
> >>>>> to indicate when SNC is enabled (with mon_scope != mon_display_scope)
> >>>>> or disabled (when they are the same).
> >>>>
> >>>> This seems to enforce the idea that these new additions aim to be
> >>>> generic on the surface but the only goal is to support SNC.
> >>>
> >>> If you have some more ideas on how to make this more generic and
> >>> less SNC specific I'm all ears.
> >>
> >> It may not end up being totally generic. It should not pretend to be
> >> when it is not. It makes the flows difficult to follow when there are
> >> these unexpected checks/quirks in what claims to be core code.
> > 
> > Do you want some sort of warning comments in pieces of code
> > that are SNC specific?
> 
> I cannot think now where warnings will be appropriate but if you
> find instances then please do. To start the quirks can at least be
> documented. For example, "Only user of <feature> is SNC, which does
> not require <custom> so simplify by <describe shortcut> ..."

The main spot that triggered this line of discussion was changing the
sanity check that operations to read monitors is being done from a
CPU within the right domain. I've added a short comment on the new
check:

-       if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
+       /* Event counts can only be read from a CPU on the same L3 cache */
+       if (d->display_id != get_cpu_cacheinfo_id(smp_processor_id(), r->mon_display_scope))
                return -EINVAL;

But my change embeds the assumption that monitor events are L3 scoped.

Should it be something like this (to keep the non-SNC case generic):

	if (r->mon_scope == r->mon_display_scope) {
		if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
			return -EINVAL;
	} else {
		/*
		 * SNC: OK to read events on any CPU sharing same L3
		 * cache instance.
		 */
		 if (d->display_id != get_cpu_cacheinfo_id(smp_processor_id(), r->mon_display_scope))
		 	return -EINVAL;
	}

> 
> > 
> >>
> >>>>>>>         }
> >>>>>>> +
> >>>>>>> +       return 0;
> >>>>>>> +}
> >>>>>>> +
> >>>>>>> +static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> >>>>>>> +                               struct rdt_mon_domain *d,
> >>>>>>> +                               struct rdt_resource *r, struct rdtgroup *prgrp)
> >>>>>>> +{
> >>>>>>> +       struct kernfs_node *kn, *ckn;
> >>>>>>> +       char name[32];
> >>>>>>> +       bool do_sum;
> >>>>>>> +       int ret;
> >>>>>>> +
> >>>>>>> +       do_sum = r->mon_scope != r->mon_display_scope;
> >>>>>>> +       sprintf(name, "mon_%s_%02d", r->name, d->display_id);
> >>>>>>> +       kn = kernfs_find_and_get_ns(parent_kn, name, NULL);
> >>>>>>> +       if (!kn) {
> >>>>>>> +               /* create the directory */
> >>>>>>> +               kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
> >>>>>>> +               if (IS_ERR(kn))
> >>>>>>> +                       return PTR_ERR(kn);
> >>>>>>> +
> >>>>>>> +               ret = rdtgroup_kn_set_ugid(kn);
> >>>>>>> +               if (ret)
> >>>>>>> +                       goto out_destroy;
> >>>>>>> +               ret = mon_add_all_files(kn, d, r, prgrp, do_sum);
> >>>>>>
> >>>>>> This does not look right. If I understand correctly the private data
> >>>>>> of these event files will have whichever mon domain came up first as
> >>>>>> its domain id. That seems completely arbitrary and does not reflect
> >>>>>> accurate state for this file. Since "do_sum" is essentially a "flag"
> >>>>>> on how this file can be treated, can its "dom_id" not rather be
> >>>>>> the "monitor scope domain id"? Could that not help to eliminate
> >>>>>
> >>>>> You are correct that this should be the "monitor scope domain id" rather
> >>>>> than the first SNC domain that appears. I'll change to use that. I don't
> >>>>> think it helps in removing the per-domain display_id.
> >>>>
> >>>> Wouldn't the file metadata then be the "display_id"?
> >>>
> >>> Yes. The metadata is the display_id for files that need to sum across
> >>> SNC nodes, but the domain id for ones where no summation is needed.
> >>
> >> Right ... and there is a "sum" flag to tell which is which?
> > 
> > Yes. sum==0 means the domid field is the one and only domain to
> > report for this resctrl monitor file. sum==1 means the domid field is
> > the display_id - all domains with this display_id must be summed to
> > provide the result to present to the user.
> > 
> > I've tried to capture that in the kerneldoc comment for struct mon_event.
> > Here's what I'm planning to include in v18 (Outlook will probably mangle
> > the formatting ... just imagine that the text lines up neatly):
> > 
> > diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> > index 49440f194253..3411557d761a 100644
> > --- a/arch/x86/kernel/cpu/resctrl/internal.h
> > +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> > @@ -132,14 +132,19 @@ struct mon_evt {
> >   *                     as kernfs private data
> >   * @rid:               Resource id associated with the event file
> >   * @evtid:             Event id associated with the event file
> > - * @domid:             The domain to which the event file belongs
> > + * @sum:               Set when event must be summed across multiple
> > + *                     domains.
> > + * @domid:             When @sum is zero this is the domain to which
> > + *                     the event file belongs. When sum is one this
> > + *                     is the display_id of all domains to be summed
> 
> Here is where I would like to understand why it cannot just be
> "When sum is one this is the domain id of the scope at which (for which?)
> the events must be summed." Although, you already mentioned this will be
> clear in next posting.
> 
> >   * @u:                 Name of the bit fields struct
> >   */
> >  union mon_data_bits {
> >         void *priv;
> >         struct {
> >                 unsigned int rid                : 10;
> > -               enum resctrl_event_id evtid     : 8;
> > +               enum resctrl_event_id evtid     : 7;
> > +               unsigned int sum                : 1;
> >                 unsigned int domid              : 14;
> >         } u;
> >  };
> > 
> > -Tony

Maybe an example might help. Assume an SNC system with two sockets,
three SNC nodes per socket, only supporting monitoring. The only domain
list created by resctrl is the mon_domains list on the RDT_RESOURCE_L3
resource. And it looks like this (with "disply_list" abbreviated to
"dspl" to keep the picture small):


       <------ SNC NODES ON SOCKET 0 ----->   <------ SNC NODES ON SOCKET 1 ------>
----> +----------+ +----------+ +----------+ +----------+ +----------+ +----------+
      | id = 0   | | id = 1   | | id = 2   | | id = 3   | | id = 4   | | id = 5   |
      |          | |          | |          | |          | |          | |          |
      | dspl = 0 | | dspl = 0 | | dspl = 0 | | dspl = 1 | | dspl = 1 | | dspl = 1 |
      |          | |          | |          | |          | |          | |          |
      +----------+ +----------+ +----------+ +----------+ +----------+ +----------+

Reading the per-SNC node monitor values looks just the same as the
non-SNC case. The struct rmid_read passed across the smp_call*() has
the resource, domain, event, and reading the counters is essentially
unchanged.

Reading a file to sum event counts for SNC nodes on socket 1 needs to
find each of the "struct rdt_mon_domain" that are part of socket 1.
I'm doing that with meta data in the file that says sum=1 (need to add
up something) and domid=1 (the things to be added are those with
display_id = 1). So the code reads:

	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
		if (d->display_id == rr->d->display_id) {
			... call stuff to read and sum for domain "d"
		}
	}

The display_id is "the domain id of the scope at which (for which?)
the events must be summed." in your text above.

> Reinette

-Tony
