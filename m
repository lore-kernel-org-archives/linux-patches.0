Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4296CDAF
	for <patches@lists.linux.dev>; Thu, 21 Nov 2024 17:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732210428; cv=none; b=clDDVrHeVTmAonuewbjvtHayBndx8dNK/MCwXNR7NAJO2FyaMqS504C1+hwt96jr2RO/jOCtFskXqu2wE2o7lpD+F8aS7HNeFMoeFS+5qhSOu9Y1L0LI9NzGDwyed96XTs0myhpZvwD06OCuC+n6v4vRjCmR8Rl0KuyWK9UjDqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732210428; c=relaxed/simple;
	bh=l+5rg6F5Ri2+kCpE6vsQzetIKYYVF6RSN2YSgcdjSNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pht0wq68C+b/TJD5+XPky03WUJXhlIWgmQrktw8OXYcLiIMITqFJhqS9mPzRlfZ33kvZx6JO9Zw0g+s6lTykdWh73udRkUHzW2Am58PIqZ6FOvbaY2RJafkKHk1xhrBv62/+XPtT59tYahTF+lXWeuNvefK1T0NuyYDNUowPVgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y+cIMeuf; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y+cIMeuf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732210428; x=1763746428;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=l+5rg6F5Ri2+kCpE6vsQzetIKYYVF6RSN2YSgcdjSNc=;
  b=Y+cIMeuf57AJVLbczZs0OSPpupvm0sh7EKhi9yANbb/h7VHsFwReEo+J
   gUhXKBxx/0Xg2bufBiXHBJZXzeEZ7fPJ06lt54b/HlxCGpSQXKu1FoTKI
   o3OLO18YjGILtPbj4/2mkjyeXyxam9z1dIsl3N2E3g3CXr7gymMg7XwJu
   nj5pFw2N4AaokiVviJvBp1qCv8oXJE+vSFWiVL1Y1LAMLRq2mC0he4rQ0
   lSbhTeXlI80XoAK31fs/EZJ/pyfLntGZNVBdHUitUip1rlCMYhX96CdOg
   CVfujx+fXCjPAq8IGTQGYUtGQ4QrBCB8WcSD+brnUofejHwxiP49H/S0i
   g==;
X-CSE-ConnectionGUID: JEObRMf8RHORJ5bPzGuiOw==
X-CSE-MsgGUID: zw7D4xPnRoys9/E3yMxftA==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="19929673"
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="19929673"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 09:33:48 -0800
X-CSE-ConnectionGUID: zV0y1nmISQ2iIHzzPqLcFQ==
X-CSE-MsgGUID: RyYvtQ3vRdmH2rxhOvFAYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,173,1728975600"; 
   d="scan'208";a="127845120"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 09:33:46 -0800
Date: Thu, 21 Nov 2024 09:33:44 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>, x86@kernel.org,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v9 2/9] x86/resctrl: Prepare for per-ctrl_mon group
 mba_MBps control
Message-ID: <Zz9u-JcQBlxKZia1@agluck-desk3>
References: <20241114001712.80315-1-tony.luck@intel.com>
 <20241114001712.80315-3-tony.luck@intel.com>
 <515914f2-501d-4df3-894a-2d255d18be1c@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515914f2-501d-4df3-894a-2d255d18be1c@intel.com>

On Tue, Nov 19, 2024 at 05:08:42PM -0800, Reinette Chatre wrote:
> Hi Tony,
> 
> On 11/13/24 4:17 PM, Tony Luck wrote:
> > Resctrl uses local memory bandwidth event as input to the feedback
> > loop when the mba_MBps mount option is used. This means that this
> > mount option cannot be used on systems that only support monitoring
> > of total bandwidth.
> > 
> > Prepare to allow users to choose the input event independently for
> > each ctrl_mon group.
> 
Hi Reinette,

> The lack of detail on design and implementation leaves a lot for the
> reader to decipher. For example,
> * the change appears to create a contract that rdtgroup.mba_mbps_event
>   is only valid if mba_sc is enabled, this is "documented" in the
>   structure member comment but not connected to the rest of implementation, not
>   here nor later in series.

I'll add text documenting this to the commit comment here, and also a
comment in the code that defines mba_mbps_default_event.

> * the patch uses *three* different checks to manage new variables:
>   is_mbm_local_enabled(), is_mba_sc(), and supports_mba_mbps(). Reader is
>   left to decipher that all checks are built on is_mbm_local_enabled()
>   and thus it is ok to use these checks before using the value that is only
>   assigned when is_mbm_local_enabled().

With some refactoring I've got that down to just one new additon of
"is_mba_sc()" (protecting the assignment of rdtgrp->mba_mbps_event
in rdtgroup_mkdir_ctrl_mon().

> * clearly mba_mbps_default_event cannot always have a value making reader wonder
>   if enum resctrl_event_id needs a "0", takes some deciphering to get confidence
>   that its assignment when is_mbm_local_enabled() fits under the contract
>   that values are only value when is_mba_sc() and thus any code following contract by
>   first checking for mba_sc should never encounter a 0.

Documented that mba_mbps_default_event remaining "0" is not an issue in
the comment at the definition of mba_mbps_default_event.

> * based on premise of this work reader may consider what happens if
>   system does not support local MBM. more deciphering needed to get confidence
>   that while mba_mbps_default_event will not be set, since is_mba_sc() still
>   depends on local MBM this still fits under contract that mba_mbps_default_event
>   cannot be used in this case.

I think I've cleared up this mystery with commit and code comments.

> Of course, it may just me that needs more help to understand what a patch is doing 
> while having little insight into what it intends to do. I thought by sharing some of
> the questions I felt needed to investigated may give some insight into the difficulty
> a cryptic changelog creates. Review could be helped significantly if the changelog
> provides insight into the design decisions. 

Good point. I've also re-worked the cover letter to provide more
information on the problem and solution implemented by this series.

> ...
> 
> > @@ -3611,6 +3613,8 @@ static int rdtgroup_mkdir_ctrl_mon(struct kernfs_node *parent_kn,
> >  			rdt_last_cmd_puts("kernfs subdir error\n");
> >  			goto out_del_list;
> >  		}
> > +		if (is_mba_sc(NULL))
> > +			rdtgrp->mba_mbps_event = mba_mbps_default_event;
> >  	}
> >  
> >  	goto out_unlock;
> > @@ -3970,6 +3974,8 @@ static void __init rdtgroup_setup_default(void)
> >  	rdtgroup_default.closid = RESCTRL_RESERVED_CLOSID;
> >  	rdtgroup_default.mon.rmid = RESCTRL_RESERVED_RMID;
> >  	rdtgroup_default.type = RDTCTRL_GROUP;
> > +	if (supports_mba_mbps())
> > +		rdtgroup_default.mba_mbps_event = mba_mbps_default_event;
> >  	INIT_LIST_HEAD(&rdtgroup_default.mon.crdtgrp_list);
> >  
> >  	list_add(&rdtgroup_default.rdtgroup_list, &rdt_all_groups);
> 
> I do not see the default resource group's mba_mbps_event ever being reset. This means
> that if the user mounts resctrl, changes mba_mbps_event, umount resctrl, remount
> resctrl, then the default resource group will not have the default mba_mbps_event
> but whatever was set on previous mount. Is this intended? No mention of this behavior in
> changelog.

Good catch. You are correct that a changed event value in the default
CTRL_MON group is preserved across unmount/remount. This was not
intentional. Moving the initialization of rdtgroup_default.mba_mbps_event
into set_mba_sc() fixes this (with the added benefit of removing the
supports_mba_mbps() check).

> Reinette

-Tony
