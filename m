Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A5A801
	for <patches@lists.linux.dev>; Mon, 21 Apr 2025 20:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745265685; cv=none; b=G2GBX1bBgCeW9hxJ5i6B4pFsS6CA2yK0/QVHGgWBnfz6X7k/3tkFtTKUnmAe2e23bou0Ck20/1A10RFbmWMQZLI58uX2VgngUeulldUAz60ELCXBaNsYJcVidXFG8cGLw+odLf/TX9B0/aUOjjvrzbvJoNSrqqah/e8Wb4VwUr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745265685; c=relaxed/simple;
	bh=NLX4MktkSJoZCoIWgyO8hIjw46EXfr2NbMlKo1KiPBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YeKRknhU12j3h22NtKdGNjatCC8QQWzQe9xBt7GTG8fGtVgotadDD8Idb89A2SUBua2UWtSvjqLWItje3BQoWvlRR+Ya56XRaxcY5dtY3cAiL3lCmuH809sWxLjYoP62L6DOjGAIiT6p4CJ1iI+Ob3ivKf/04XowzaYuqS5/58k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZRQKuB2G; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZRQKuB2G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745265683; x=1776801683;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NLX4MktkSJoZCoIWgyO8hIjw46EXfr2NbMlKo1KiPBY=;
  b=ZRQKuB2GdMjhCT7eXYb9LyCslXhHYeMzcXbkccZ/LX+A7158kQnwSZ2F
   XlmKhLFzpJk+A2h7/9HcLSQhZHJwMjkXDbdx8JB8qmRtyvsJOHIWtv50I
   jDyB2+4MZibmGsN3kj+Yef6K3DzVbR8yTww5UwT2xDF307Tb1OGB9DWiU
   eyi3qMn85AVWvSZwn5bcTC7M96B6kwl4J/he+AfPU+mFqtjWgbbjILOX5
   iywYXhL2jXwjmQ8DMyjEHY59evTch2q/NjCKVJFDLMZefqlHiX05/6Q6I
   jybgpv873QypZ8X4vmg17vYt12Tr6GMErbA3THqO84+W0oGcHC/jo1aWn
   A==;
X-CSE-ConnectionGUID: tC4iZqNLRTGOtHABJ9wtMw==
X-CSE-MsgGUID: QYCDep9QRieG7ny9R2enEQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11410"; a="46937782"
X-IronPort-AV: E=Sophos;i="6.15,229,1739865600"; 
   d="scan'208";a="46937782"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2025 13:01:23 -0700
X-CSE-ConnectionGUID: aU6NYig7RxCE2WhtER3YFw==
X-CSE-MsgGUID: JgIeynpySfq6gqSacF2k8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,229,1739865600"; 
   d="scan'208";a="136903109"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2025 13:01:22 -0700
Date: Mon, 21 Apr 2025 13:01:21 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v3 07/26] x86/resctrl: Move L3 initialization out of
 domain_add_cpu_mon()
Message-ID: <aAakETammzi4vGMn@agluck-desk3>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-8-tony.luck@intel.com>
 <698ab022-b6c1-4fca-b42d-26a3b4b2b8e8@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <698ab022-b6c1-4fca-b42d-26a3b4b2b8e8@intel.com>

On Fri, Apr 18, 2025 at 02:51:01PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 4/7/25 4:40 PM, Tony Luck wrote:
> > To prepare for additional types of monitoring domains, move all the
> > L3 specific initialization into a helper function.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  arch/x86/kernel/cpu/resctrl/core.c | 57 ++++++++++++++++++------------
> >  1 file changed, 35 insertions(+), 22 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index d82a4a2db699..703423b0be0e 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -493,33 +493,12 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
> >  	}
> >  }
> >  
> > -static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
> > +static void setup_l3_mon_domain(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos)
> >  {
> > -	int id = get_domain_id_from_scope(cpu, r->mon_scope);
> > -	struct list_head *add_pos = NULL;
> >  	struct rdt_hw_mon_domain *hw_dom;
> > -	struct rdt_domain_hdr *hdr;
> >  	struct rdt_mon_domain *d;
> >  	int err;
> >  
> > -	lockdep_assert_held(&domain_list_lock);
> > -
> > -	if (id < 0) {
> > -		pr_warn_once("Can't find monitor domain id for CPU:%d scope:%d for resource %s\n",
> > -			     cpu, r->mon_scope, r->name);
> > -		return;
> > -	}
> > -
> > -	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
> > -	if (hdr) {
> > -		if (WARN_ON_ONCE(hdr->type != DOMTYPE(r->rid, DOMTYPE_MON)))
> > -			return;
> > -		d = container_of(hdr, struct rdt_mon_domain, hdr);
> > -
> > -		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
> > -		return;
> > -	}
> > -
> 
> Many functions called by this new "setup_l3_mon_domain()" are specific to L3 resource but
> since L3 resource has so far been the only one supported the naming has been generic. Now that
> this function is made resource specific I think it will help make the code clear if the
> L3 specific functions called by it are also renamed. For example, mon_domain_free() can
> be renamed to free_l3_mon_domain() to match the "setup_l3_mon_domain()" introduced here. Also
> arch_mon_domain_online() -> arch_l3_mon_domain_online().

What about "struct rdt_mon_domain"? It is now specific to L3. Should I
change that to rdt_l3_mon_domain" as well (60 lines affected)?

Ditto for rdt_hw_mon_domain (but only 12 lines for this one).

> Seems like resctrl_online_mon_domain() is only temporarily specific to L3 in this series
> (would be helpful if such details are explained in changelog) ... to start it could
> include a check that ensures it is only called on L3 resource and then it will help
> to clarify what this patch does and how following work builds on it.
> 
> >  	hw_dom = kzalloc_node(sizeof(*hw_dom), GFP_KERNEL, cpu_to_node(cpu));
> >  	if (!hw_dom)
> >  		return;
> > @@ -552,6 +531,40 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
> >  	}
> >  }
> >  
> Reinette
> 
