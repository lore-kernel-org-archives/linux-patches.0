Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2D3212B28
	for <patches@lists.linux.dev>; Thu,  8 May 2025 18:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746729158; cv=none; b=DRguzjc0Ew/2b+IcX36x94hO8nQPaV2SnXzw/Fv9fX9/pm5aV7l22SLMiGi1DmHxsu9XXjyOdvS3SHyormlZczpGHcCYL5RWssLNxnX8AVOxthBNS6GIokptA5JiKbTkJ/ECh6f653UsLdpsMDZnrK1P6TEkdQiYg6qOVGh8/so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746729158; c=relaxed/simple;
	bh=EDYr3bbdDG5rfawXqXNdwUwojhepOOUb87L8j7hKW70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JfKFXCvNw1j1r7plOPnEEwmh44ggydJwCji/rpHrbwWuLJy2OgnLXL68ufJU/Ud650RbkVIZwA6OpDRxcMcHme2xXgU6AclbAw5VHRbEcPg8nwN1Pw/4iYOKT5o9vzmpuLInHzVOFgXyTTJrY45iVgcBEzf4cUgydb597I8jzYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h7MUludo; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h7MUludo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746729156; x=1778265156;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EDYr3bbdDG5rfawXqXNdwUwojhepOOUb87L8j7hKW70=;
  b=h7MUludoYGQLnRTOh2jRLb/L1OLFJ9Uy6VWWsr4sjl2YY2n1Fm9M9hch
   26wNrot0Vg7Cks0OHibtDVes7YHX16RU8DOwdCAIt8LeErXVNl3NY/K4E
   etZtwddHJc87+mc8vrb5B667S3dqTuXdIIFer/T5pO7Pc9B79OqX744iU
   MLTCFDy1DrV4aSaO7xJyc+nw326Ado4YnU7QQTKWxy/CNsS1KI8QfYehq
   MXc+BHlQXTPQa4/drLiNkCbmtXX/8IPWJN34c9zefcMnCMqKd8VgT5Ms3
   V9xIdrEfv3sf5v7ct7bcK8gLV85yoLU7ypv6DoMdT+h8s98En9FpKTrZ+
   A==;
X-CSE-ConnectionGUID: +D4ByzgDQV+BKLTTP1rWzA==
X-CSE-MsgGUID: GtyLygFPRva/OYgPezzCxQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="58747377"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="58747377"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 11:32:36 -0700
X-CSE-ConnectionGUID: RMhvKwiGTa+Ifcwd2meL4A==
X-CSE-MsgGUID: 7dUXf3dIScK2RT62+JbbFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="167320513"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 11:32:35 -0700
Date: Thu, 8 May 2025 11:32:33 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v4 01/31] x86,fs/resctrl: Drop rdt_mon_features variable
Message-ID: <aBz4wZnuZRGxuAHB@agluck-desk3>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-2-tony.luck@intel.com>
 <eb141d41-25e2-4e8a-bfdb-6d3e6a4e542b@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb141d41-25e2-4e8a-bfdb-6d3e6a4e542b@intel.com>

On Wed, May 07, 2025 at 08:28:56PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 4/28/25 5:33 PM, Tony Luck wrote:
> > The fs/arch boundary is a little muddy for adding new monitor features.
> 
> It is not possible to accurately interpret what is meant with "little muddy".
> Please add specific information that can be verified/reasoned about.

I'll work on something more descriptive/useful.

> > 
> > Clean it up by making the mon_evt structure the source of all information
> > about each event. In this case replace the bitmap of enabled monitor
> > features with an "enabled" bit in the mon_evt structure.
> 
> bit -> boolean?

Will fix ("bit" was left over from earlier implementation).

> > 
> > Change architecture code to inform file system code which events are
> > available on a system with resctrl_enable_mon_event().
> 
> (nit: no need to mention that a patch changes code, it should be implied.)
> 
> This could be, "An architecture uses resctrl_enable_mon_event() to inform
> resctrl fs which events are enabled on the system."

Will update with this.

> (I think we need to be cautious about the "available" vs "enabled"
> distinction.)

Maybe a comment above mon_event_all[]?

/*
 * All available events. Architecture code marks the ones that
 * are supported by a system using resctrl_enable_mon_event()
 * to set .enabled.
 */
struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {

> > 
> > Replace the event and architecture specific:
> > 	resctrl_arch_is_llc_occupancy_enabled()
> > 	resctrl_arch_is_mbm_total_enabled()
> > 	resctrl_arch_is_mbm_local_enabled()
> > functions with calls to resctrl_is_mon_event_enabled() with the
> > appropriate QOS_L3_* enum resctrl_event_id.
> 
> No mention or motivation for the new array. I think the new array is an
> improvement and now it begs the question whether rdt_resource::evt_list is
> still needed? It seems to me that any usage of rdt_resource::evt_list can
> use the new mon_event_all[] instead?

Good suggestion. rdt_resource::evt_list can indeed be dropped. A
standalone patch to do so reduces lines of code:

 include/linux/resctrl.h |  2 --
 fs/resctrl/internal.h   |  2 --
 fs/resctrl/monitor.c    | 18 +-----------------
 fs/resctrl/rdtgroup.c   | 11 ++++++-----
 4 files changed, 7 insertions(+), 26 deletions(-)

But I'll merge into one of the early patches to avoid adding new code to create
the evt_list and then delete it again.

> With struct mon_evt being independent like before this
> patch it almost seems as though it prepared for multiple resources to
> support the same event (do you know history here?). This appears to already
> be thwarted by rdt_mon_features though ... although theoretically it could
> have been "rdt_l3_mon_features".
> Even so, with patch #4 adding the resource ID all event information is
> centralized. Only potential issue may be if multiple resources use the
> same event ... but since the existing event IDs already have resource
> name embedded this does not seem to be of concern?

The existing evt_list approach would corrupt the lists if the same event
were added to multiple resources. Without the list this becomes
possible, but seems neither desirable, nor useful.

I will add a warning to resctrl_enable_mon_event() if architecture
code tries to enable an already enabled event.
> 
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> 
> ...
> 
> > @@ -866,14 +879,13 @@ static struct mon_evt mbm_local_event = {
> >   */
> >  static void l3_mon_evt_init(struct rdt_resource *r)
> >  {
> > +	enum resctrl_event_id evt;
> > +
> >  	INIT_LIST_HEAD(&r->evt_list);
> >  
> > -	if (resctrl_arch_is_llc_occupancy_enabled())
> > -		list_add_tail(&llc_occupancy_event.list, &r->evt_list);
> > -	if (resctrl_arch_is_mbm_total_enabled())
> > -		list_add_tail(&mbm_total_event.list, &r->evt_list);
> > -	if (resctrl_arch_is_mbm_local_enabled())
> > -		list_add_tail(&mbm_local_event.list, &r->evt_list);
> > +	for (evt = 0; evt < QOS_NUM_EVENTS; evt++)
> > +		if (mon_event_all[evt].enabled)
> > +			list_add_tail(&mon_event_all[evt].list, &r->evt_list);
> >  }
> 
> This hunk can create confusion with it adding "all enabled events" to
> a single resource. I understand that at this point only L3 supports monitoring
> and this works ok, but in the context of this work it creates a caveat early
> in series that needs to be fixed later (patch #4). This wrangling becomes
> unnecessary if removing rdt_resource::evt_list.

I'll see if I can get a clean sequence between these patches to avoid
this confusion. Maybe evt_list removal needs to happen here.
> 
> Reinette

-Tony
