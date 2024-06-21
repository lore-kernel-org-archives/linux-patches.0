Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFEC81AC1
	for <patches@lists.linux.dev>; Fri, 21 Jun 2024 15:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718983502; cv=none; b=FSEzF/Nx2jdQjRc7ORMQlhkBTd1JTDHtYpqaPd8YpsEsSDMyNqhRnj4TkBQbKVfiE3ooqzWmzhihj6BikinqDTb3/XCWtgiRXDeuBbck5WXiX7E5X6GiefTPH2q06XMWMG1r+dnC/ryiqi47xAEiiJhSJEI6vd6YjDwL+fWzJXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718983502; c=relaxed/simple;
	bh=bmkYWAVI1sPzC2Tz8D+HXizAK7xoAr/bIp5KhRtXd+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LBZbuqKpxLMdTpXcNTNy95+2ZCJJP/6Tfxo+NldeRuBavCLu29vnq0+ltwatsf3LKZNTFE4f+wSxEhyMiDYGj5wboNaFKN5V+fuqExk+413TP11hH0MFpIkmOYEXbAiom1ElZV7iDNxn7SsCFmVs5ZIoxT6dmTQ8vDnIa1v+6MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oohu9eJK; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oohu9eJK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718983500; x=1750519500;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bmkYWAVI1sPzC2Tz8D+HXizAK7xoAr/bIp5KhRtXd+k=;
  b=Oohu9eJKUa38Yw5WCKEXgH9bLp0LcvdjeykQp3ijByjgQI8TV3jIIHIu
   b5oTafz1aHOUMxuYKHZjMfASW9KLQL8OcnBAhWsWkcKwaaLWH0vxKFBf+
   MD6UnJKG/EbScyDYI4TPeOwkSL5x8goIpch1rqiN7aoG1z9kmZAJV3s15
   SUYxzDSUrJcieakOOcR6Ws3iA0q9FpNN62Fwnf4JvljLjV061z6Jpy9cV
   q65imI3tBdszJRDixoVEoWwh0fh4z5dunPC/dCaBwNYR6R2b1K0ALDhJz
   bphlLVgh1VoAibdgChzcQC3pqg1BuLi/1sGYC5z6eftnsqNalnKWr/7HZ
   A==;
X-CSE-ConnectionGUID: 8hQh94QfQtKPyCrRo5OpZA==
X-CSE-MsgGUID: KrhSgQ1tTA+i1I2MmUPT8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11110"; a="27156131"
X-IronPort-AV: E=Sophos;i="6.08,255,1712646000"; 
   d="scan'208";a="27156131"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 08:25:00 -0700
X-CSE-ConnectionGUID: XFuC6ewVRFSjZIKv8NlNrg==
X-CSE-MsgGUID: 9HN/t6cYS06enMWdrKY6Vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,255,1712646000"; 
   d="scan'208";a="47561224"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 08:24:59 -0700
Date: Fri, 21 Jun 2024 08:24:57 -0700
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
Subject: Re: [PATCH v20 07/18] x86/resctrl: Block use of mba_MBps mount
 option on Sub-NUMA Cluster (SNC) systems
Message-ID: <ZnWbSTY64N9_aSWA@agluck-desk3.sc.intel.com>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-8-tony.luck@intel.com>
 <649913a3-0694-48b6-b4fc-0ec6e5e85bbc@intel.com>
 <SJ1PR11MB608342C2230D448CF27EAC26FCC82@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <74ed79c1-b024-4b22-9858-14c1e5284a20@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74ed79c1-b024-4b22-9858-14c1e5284a20@intel.com>

On Thu, Jun 20, 2024 at 06:56:56PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 6/20/24 3:07 PM, Luck, Tony wrote:
> > > > When SNC is enabled there is a mismatch between the MBA control function
> > > > which operates at L3 cache scope and the MBM monitor functions which
> > > > measure memory bandwidth on each SNC node.
> > > > 
> > > > Block use of the mba_MBps when scopes for MBA/MBM do not match.
> > > > 
> > > > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > > > ---
> > > >    arch/x86/kernel/cpu/resctrl/rdtgroup.c | 4 +++-
> > > >    1 file changed, 3 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> > > > index eb3bbfa96d5a..a0a43dbe011b 100644
> > > > --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> > > > +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> > > > @@ -2339,10 +2339,12 @@ static void mba_sc_domain_destroy(struct rdt_resource *r,
> > > >     */
> > > >    static bool supports_mba_mbps(void)
> > > >    {
> > > > +   struct rdt_resource *rmbm = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> > > >      struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
> > > > 
> > > >      return (is_mbm_local_enabled() &&
> > > > -           r->alloc_capable && is_mba_linear());
> > > > +           r->alloc_capable && is_mba_linear() &&
> > > > +           r->ctrl_scope == rmbm->mon_scope);
> > > >    }
> > > > 
> > > >    /*
> > > 
> > > The function comments of supports_mba_mbps() needs an update to accompany
> > > this new requirement.
> > 
> > Will add comment on extra requirement.
> > 
> > > I also think that the "mba_MBps" mount option is now complicated enough to
> > > warrant a clear error to user space when using it fails. invalfc() is
> > > available for this and enables user space to get detailed log message
> > > from a read() on an fd created by fsopen().
> > > 
> > > Perhaps something like (please check line length and feel free to improve
> > > since as is it may quite cryptic):
> > >        rdt_parse_param(...)
> > >        {
> > > 
> > > 
> > >        ...
> > >        case Opt_mba_mbps:
> > >                if (!supports_mba_mbps())
> > >                        return invalfc(fc, "mba_MBps requires both MBM and (linear scale) MBA at L3 scope");
> > >        ...
> > >        }
> > 
> > Line length is indeed a problem (108 characters). Usual line split methods barely help as the moving the
> > string to the next line and aligning with the "(" only saves 4 characters.
> > 
> > How about this (suggestions for a shorter variable name - line is 97 characters)
> > 
> > static char mba_mbps_invalid[] = "mba_MBps requires both MBM and (linear scale) MBA at L3 scope";
> > 
> > rdt_parse_param(...)
> > {
> > 	...
> > 	case Opt_mba_mbps:
> > 		if (!supports_mba_mbps())
> > 			return invalfc(fc, mba_mbps_invalid);
> > 	...
> > }
> 
> On 6/20/24 3:12 PM, Luck, Tony wrote:
> > > static char mba_mbps_invalid[] = "mba_MBps requires both MBM and (linear scale) MBA at L3 scope";
> > 
> > checkpatch recommends "static const char ..." pushing this over 100 chars :-(
> > 
> 
> How about something like below that reaches 96:
> 
> 	case Opt_mba_mbps:
> 		if (!supports_mba_mbps())
> 			return invalfc(fc,
> 				       "mba_MBps requires both MBM and linear MBA at L3 scope");
> 

Reinette,

Alternative option. Move the messaging into supports_mba_mbps() and
split into shorter pieces for each reason. The other callers of
supports_mba_mbps() that are just re-checking status would pass
a NULL argument.

If this looks reasonable I can do it in two patches. First to add
invalfc() for the existing cases. Second to add the SNC change.

-Tony

---

static bool supports_mba_mbps(struct fs_context *fc)
{
			return invalfc(fc, mba_mbps_invalid);
	struct rdt_resource *rmbm = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;

	if (!is_mbm_local_enabled()) {
		if (fc)
			invalfc(fc, "mba_MBps requires local MBM");
		return false;
	}
	if (!r->alloc_capable) {
		if (fc)
			invalfc(fc, "mba_MBps requires MBA");
		return false;
	}
	if (!is_mba_linear()) {
		if (fc)
			invalfc(fc, "mba_MBps requires linear MBA");
		return false;
	}
	if (r->ctrl_scope != rmbm->mon_scope) {
		if (fc)
			invalfc(fc, "mba_MBps requires MBM/MBA at L3 scope");
		return false;
	}

	return true;
}

rdt_parse_param(...)
{
	...
	case Opt_mba_mbps:
		if (!supports_mba_mbps(fc))
			return -EINVAL;
	...
}
