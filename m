Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9551D130E33
	for <patches@lists.linux.dev>; Thu, 25 Jan 2024 17:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706203790; cv=none; b=WMGvO5W3Os4itrI9mowj9sHUHz9adTGUkg4LjusuvY+G7Reb0iYwBsTcpDNQkbXkrnEPOMFtNev+Sa+SWYZx2G3uTmSVI2eX9bQYWiD7lNjSCqG6fW1e33Rnpt0eef8DloytM4/+Bx9MnjCBKuDs5ZsM+dLPzTptRtzOlzBrvfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706203790; c=relaxed/simple;
	bh=rg8k8DSz99hlQQsXagfNAy+1dYhgiafR464X4FhdLDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DPEP5Z8PfuXsD6ZTQmu95nQ6FcNYNbC+UOUPNONXFbYTm71Nrb7t403YCq4yiZBgwtdA9ysjxoR+XiDaHGK+7eNIdDzitE3IHTVWgNyQAX0hiDGTGy3ecuKxHND4w7MC5oTfcLTxWKodfigGrVwuuBg07TONcn0fyJahadIDPY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QtsGlLRx; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QtsGlLRx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706203787; x=1737739787;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rg8k8DSz99hlQQsXagfNAy+1dYhgiafR464X4FhdLDE=;
  b=QtsGlLRxEO77KUILpnmUbUPEBo9fuYajusHFn2O4MFZSKpATWhbUGSiD
   ScQZlqn0SQx6l2ies8kpiPCRCBLANlP5+iClQJEgu0tXUD51s8jXPYaPb
   COta2gZl2EGuBmPWA9SceaVnI4aWSAXV+mhA40uz1xMvjaEXDgK6xEMbf
   7IDD8sS5n2i4wABfXQsZdkDbc6XwZewOTRqtloC8T8Fa35DCuD73pPJK0
   aXOAflryp1PvUBtO61kVKj8Atwix60tl2OTPENchco++Jixb28qDwtP+a
   bDM02qBswi5ByqK/fHp2iSM/lb9HwGC3+eAyFRtUclensmYPl8ibWz/OY
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9613310"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9613310"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 09:29:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2303822"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.74])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 09:29:40 -0800
Date: Thu, 25 Jan 2024 09:29:39 -0800
From: Tony Luck <tony.luck@intel.com>
To: James Morse <james.morse@arm.com>, Borislav Petkov <bp@alien8.de>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
	Peter Newman <peternewman@google.com>,
	"x86@kernel.org" <x86@kernel.org>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	"Shen, Xiaochen" <xiaochen.shen@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v2] x86/resctrl: Implement new mba_MBps throttling
 heuristic
Message-ID: <ZbKag2eJcgR_ro34@agluck-desk3>
References: <45d2891e-989a-45c9-a527-8b14ff5f8748@intel.com>
 <SJ1PR11MB60837D4884419BDC2DCAA2D2FC752@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <bfa5104f-b887-4cc4-a24c-0497b86d9dde@intel.com>
 <20240122182121.GBZa6yIYPtHQx44EU9@fat_crate.local>
 <11fc82e0-961f-4c8d-844f-ad4b99067eb3@intel.com>
 <20240122184755.GCZa64W02KXyeaVXJg@fat_crate.local>
 <SJ1PR11MB6083A27C628E17FB8BBC4922FC752@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <b6ce3e79-aa4a-57e9-8b43-b5be45f75462@arm.com>
 <SJ1PR11MB60830483DCBE64EB726CF7E6FC742@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <ZbBZ9pk2ha99H2Jd@agluck-desk3>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbBZ9pk2ha99H2Jd@agluck-desk3>

On Tue, Jan 23, 2024 at 04:29:42PM -0800, Tony Luck wrote:
> On Tue, Jan 23, 2024 at 05:07:50PM +0000, Luck, Tony wrote:
> > >> I need to grab an SNC system to re-check that everything still works when re-based.
> > >> But right now, this looks like adding the SNC series will be easy (famous last words!).
> > >
> > > Once you're ready - can you point me at something I can use as a stable branch to rebase onto?
> > 
> > I'll be running the tests this afternoon. But I'm somewhat confident that they will pass.
> > 
> > Tree is here: git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git branch "hopeful_snc"
> > 
> > Commits are:
> > 
> > 793635f10aeb x86/resctrl: Update documentation with Sub-NUMA cluster changes
> > dca7ba785d6f x86/resctrl: Sub NUMA Cluster detection and enable
> > e41bd88101c8 x86/resctrl: Introduce snc_nodes_per_l3_cache
> > ccbab7875197 x86/resctrl: Add node-scope to the options for feature scope
> > 2f0db8c7072b x86/resctrl: Split the rdt_domain and rdt_hw_domain structures
> > 22697627cc5f x86/resctrl: Prepare for different scope for control/monitor operations
> > f3ff831a9042 x86/resctrl: Prepare to split rdt_domain structure
> > c0679868ee78 x86/resctrl: Prepare for new domain scope
> > 327b4394f309 x86/resctrl: Implement new mba_MBps throttling heuristic
> > 5b14817cf87e x86/resctrl: Read supported bandwidth sources using CPUID command
> > 5699cd082e1f x86/resctrl: Remove hard-coded memory bandwidth limit
> > 1b908debf53f x86/resctrl: Fix unused variable warning in cache_alloc_hsw_probe()
> > 
> > Only the last of these (1b908debf53f) had been accepted by Boris into TIP x86/cache
> > when I cut this tree yesterday.
> > 
> > Two more applied by Boris today without any changes from what is in my tree, but the
> > commit IDs in TIP are obviously different from in my tree.
> > 
> > 54e35eb8611c x86/resctrl: Read supported bandwidth sources from CPUID
> > 0976783bb123 x86/resctrl: Remove hard-coded memory bandwidth limit
> > 
> > All the others have the normal risk that Boris will find some way to make them better.
> 
> All my SNC tests pass. So this tree is as good as I can make it.
> 
> Boris: After you take/reject "x86/resctrl: Implement new mba_MBps throttling heuristic"
> in TIP x86/cache I will post v14 of the SNC series rebased to that TIP
> branch.

Boris,

I got the tip bot message that you have applied:

  c2427e70c163 ("x86/resctrl: Implement new mba_MBps throttling heuristic")

I see that you also applied:

  fc747eebef73 ("x86/resctrl: Remove redundant variable in mbm_config_write_domain()")

Does that empty your resctrl queue except for the SNC series? If it
does, then I'll rebase SNC patches onto TIP x86/cache.

-Tony
