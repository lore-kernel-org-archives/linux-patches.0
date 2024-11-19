Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD7312BF24
	for <patches@lists.linux.dev>; Tue, 19 Nov 2024 01:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731980691; cv=none; b=ay61D08mlZvMe5lgq7XPHUD33Yp2tME2sOIs5kXX6lJrSMJNENcKO5+JspbfxvQyU2MEc82oljWc07jAu7ALmXOQ7pr8fp9QEFA6i0uZcASk2CSjeyvs1qdvFh9cfnEY6JKD1P73+U/v/pab18/4RGqNFFDkolE3o+EpM7q5Ifw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731980691; c=relaxed/simple;
	bh=N+vjto3WoybJMIwY+R3vNKM92qKrEV6rPWUnVraUSr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cnEkwzlIeaaKxeRgYDzYJO20YpKej0fajga57GqyQYPQcuYXPVQ7lwMKYJNCJ5NH0elmefnO1EarmulmYiVhowxV/ePFB3HWWa8vgwI5gjHciWOkxlJuh1MfmCLE4AfZ48pfnokn5zbVShXo9Xb11S4dZyhw95oA9dwucct7cwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mb6xvpOA; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mb6xvpOA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731980690; x=1763516690;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N+vjto3WoybJMIwY+R3vNKM92qKrEV6rPWUnVraUSr4=;
  b=Mb6xvpOAqmpg5KvRO7Mop0YWfV98/UW2GPSzlk+uro9vd5hspfx15A46
   zudN9OphWKEYTWbYGUN46uWTVa5lV5Ni/C2+ZiTk2Xo7a7f7FaW6Yx3ng
   Rn464UWE71PuwGYa0JSOSP8VzMC/P0EctzQyUF0hjybtcCAwVlGCM/efu
   zqRlaXgLU+tgjBJupiJ79/iyl/gr4X3Emk9qnD+WEIJ2magbu5vI4+ICG
   mXvCqi8UfNJ1ozOX15PfjB90oWf8UO9s+Yi2DjqNubosCzky89O451tKo
   pkg9sVGC7yzsJUYYk/ilRDUT7T72kz0pT3oytch01AygKYx2ihfk0yO9v
   Q==;
X-CSE-ConnectionGUID: xlDENMn1QjytI6/7xYqHVg==
X-CSE-MsgGUID: 2WaPx0W9TRm92prunsLAuw==
X-IronPort-AV: E=McAfee;i="6700,10204,11260"; a="32021236"
X-IronPort-AV: E=Sophos;i="6.12,165,1728975600"; 
   d="scan'208";a="32021236"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 17:44:49 -0800
X-CSE-ConnectionGUID: TGlVMKpkSDqje/Epmgi/wA==
X-CSE-MsgGUID: vyRkcRBRQs+GMdjfwTlPUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,165,1728975600"; 
   d="scan'208";a="112706375"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 17:44:49 -0800
Date: Mon, 18 Nov 2024 17:44:47 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: babu.moger@amd.com, Fenghua Yu <fenghua.yu@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>, x86@kernel.org,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v9 3/9] x86/resctrl: Modify update_mba_bw() to use per
 ctrl_mon group event
Message-ID: <Zzvtj8n1_ukhnRWT@agluck-desk3>
References: <20241114001712.80315-1-tony.luck@intel.com>
 <20241114001712.80315-4-tony.luck@intel.com>
 <b4b31f4f-7f09-4ee3-9373-6ffe5ea859a6@amd.com>
 <ZzvVSamxTo9QSWBU@agluck-desk3>
 <e6b74022-5066-4cf5-aaee-5a70da9701e4@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6b74022-5066-4cf5-aaee-5a70da9701e4@intel.com>

On Mon, Nov 18, 2024 at 04:51:38PM -0800, Reinette Chatre wrote:
> Hi Tony,
> 
> On 11/18/24 4:01 PM, Luck, Tony wrote:
> > On Fri, Nov 15, 2024 at 10:21:01AM -0600, Moger, Babu wrote:
> >> Hi Tony,
> > 
> > Thanks for looking at this patch.
> > 
> >>
> >> On 11/13/2024 6:17 PM, Tony Luck wrote:
> >>> Instead of hard-coding the memory bandwidth local event as the
> >>> input to the mba_sc feedback look, use the event that the user
> >>> configured for each ctrl_mon group.
> >>>
> >>> Signed-off-by: Tony Luck <tony.luck@intel.com>
> >>> ---
> >>>   arch/x86/kernel/cpu/resctrl/monitor.c | 23 ++++++++++++++++++-----
> >>>   1 file changed, 18 insertions(+), 5 deletions(-)
> >>>
> >>> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> >>> index 7ef1a293cc13..2176e355e864 100644
> >>> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> >>> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> >>> @@ -752,20 +752,31 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
> >>>   	u32 closid, rmid, cur_msr_val, new_msr_val;
> >>>   	struct mbm_state *pmbm_data, *cmbm_data;
> >>>   	struct rdt_ctrl_domain *dom_mba;
> >>> +	enum resctrl_event_id evt_id;
> >>>   	struct rdt_resource *r_mba;
> >>> -	u32 cur_bw, user_bw, idx;
> >>>   	struct list_head *head;
> >>>   	struct rdtgroup *entry;
> >>> +	u32 cur_bw, user_bw;
> >>> -	if (!is_mbm_local_enabled())
> >>> +	if (!is_mbm_enabled())
> >>>   		return;
> >>>   	r_mba = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
> >>> +	evt_id = rgrp->mba_mbps_event;
> >>> +
> >>> +	if (WARN_ON_ONCE(!is_mbm_event(evt_id)))
> >>> +		return;
> >>
> >> I feel this check is enough.
> >>
> >>> +	if (WARN_ON_ONCE(evt_id == QOS_L3_MBM_LOCAL_EVENT_ID && !is_mbm_local_enabled()))
> >>> +		return;
> >>> +	if (WARN_ON_ONCE(evt_id == QOS_L3_MBM_TOTAL_EVENT_ID && !is_mbm_total_enabled()))
> >>> +		return;
> >>
> >> These two checks are not necessary.  You are already validating it while
> >> initializing(in patch 7).
> > 
> > I added this in response to a comment on v7 from Reinette that evt_id
> > wasn't properly validated here - in conjuction with the change a few
> > lines earlier that relaxed the check for is_mbm_local_enabled() to
> > just is_mbm_enabled().
> 
> right that patch had an issue ... the "initialize" code hardcoded support to be 
> 	r->membw.mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;
> without any checking and then the handler used a relaxed check of
> 	is_mbm_enabled()
> 
> On a system that only supports total MBM the is_mbm_enabled() check will
> pass while the event used will be local MBM.

In the v9 series I believe all the necessary checks are made outside
of the update_mba_bw() function itself.

  update_mba_bw() is only called when is_mba_sc() returns true. Which
  is the value of:
  	rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl.membw.mba_sc
  which can only be set if mbm is enabled.

  So instead of changing the check from is_mbm_local_enabled() to
  is_mbm_enabled() it could be deleted.

  rgrp->mba_mbps_event can only be set to QOS_L3_MBM_LOCAL_EVENT_ID
  until patch 7 when the user can select QOS_L3_MBM_TOTAL_EVENT_ID
  or patch 8 when the initiialization code can pick TOTAL on systems
  that don't support LOCAL.

  So all three of the WARN_ON_ONCE() calls are unnecessary.

Should I drop all these checks in v10?

> 
> > 
> > See: https://lore.kernel.org/r/bb30835f-5be9-44b4-8544-2f528e7fc573@intel.com
> > 
> > In theory all of these tests could be dropped. As you point out the
> > sanity checks are done higher in the call sequence. But some folks
> > like the "belt and braces" approach to such sanity checks.
> 
> If that "higher in the call sequence" can be trusted, yes. That was not the
> case when I made those statements. Sprinkling WARN() that continues execution
> in a known bad state does not seem safe to me either.
> 
> Reinette

-Tony
