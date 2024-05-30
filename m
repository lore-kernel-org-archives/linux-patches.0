Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B802D05D
	for <patches@lists.linux.dev>; Thu, 30 May 2024 16:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717087013; cv=none; b=CSt6q4TNLCwhPHAN3gw0BrXXBiLyUcEsfHHGQNR7JPtMSwhdXkMhoLZ9grakjWRhvp2iyrn6vDzkgOW6LcVTx4EEesAoR3V0JtmuFmY3dkYZHJhdejfzU6UrPkT1y2N/cuM/dfXOORtYKdZ28bCpqj4uP7KnOZeGNMGarb3l6+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717087013; c=relaxed/simple;
	bh=6sXrUOOyEizRFbd17/Di8hFMxQsHdChcWlX/tTCPTic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oL5aMKRkFPQiEmkDsf076Y6pZISZx/x7ZizsyvybsU2/cuJSGGLpA480VosIyq7kVpUnNJ4TXsZ5f5T37O2AYjyf+2h9xEap+2kdo0ZRfkWx9dcu8TsZNwUYsS3KDCPrp/5j4q/B/Cplu4YGsGGElM8EnuTFakQ38K+Ho6G54pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jhceymwd; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jhceymwd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717087012; x=1748623012;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6sXrUOOyEizRFbd17/Di8hFMxQsHdChcWlX/tTCPTic=;
  b=jhceymwd0n2uaEEZCjXuPK+pIYPkz/6kHRAwI+cWsIJFBZdS22QlBhsd
   rm/n4TFpz5yTc5q0k/xZr44Ap5dG2dFc7OKoOUbVtTX2qYs77Xu+X7sD9
   O/sBPOI0sLvx+JRhAUR9/tPElyP2iZZyW4Oc0ifz+2BW/ePrMr1ReBLi8
   t4lZWYFw/iUwzwwHVSfarEh6ch4jmMdQrLD6Lr8simlGz3icvj356juEt
   8D2tVh46cpJoCTUqh74fdxjCFT+rHrSeYEnPtwG2+GfR7LdAn4p1F9z3D
   DWon1RXoMxp+o6VBjFjPp23c6okTntvXQaLwa2bGvNYr9EFnjOrZkSpdM
   g==;
X-CSE-ConnectionGUID: vZX5eVnlRy+TmDYv4H3JUw==
X-CSE-MsgGUID: Ez40UYzPTUqCLlJmvyI1UA==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="24707715"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="24707715"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 09:36:51 -0700
X-CSE-ConnectionGUID: EAP1kPC6QTu3NnjQF0hFdA==
X-CSE-MsgGUID: wghjxJLASyWE4jUhhrhtsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="59043046"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 09:36:51 -0700
Date: Thu, 30 May 2024 09:36:49 -0700
From: Tony Luck <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v19 00/20] Add support for Sub-NUMA cluster (SNC) systems
Message-ID: <ZlirIUbLw8fLHe0j@agluck-desk3.sc.intel.com>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <08ca8fe7-9da6-41da-aad2-0081b789326c@intel.com>
 <ZleODtL_6D-Q_OMX@agluck-desk3.sc.intel.com>
 <a4d37f57-328f-4456-92bc-5e6469d092c8@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4d37f57-328f-4456-92bc-5e6469d092c8@intel.com>

On Wed, May 29, 2024 at 07:46:27PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/29/24 1:20 PM, Tony Luck wrote:
> > On Tue, May 28, 2024 at 03:55:29PM -0700, Reinette Chatre wrote:
> > > Hi Tony,
> > > > 13:	Wordsmith commit into imperative.
> > > > 	I looked at using kobject_has_children() to check for empty
> > > > 	directory, but it needs a "struct kobject *" and all I have
> > > > 	is "struct kernfs_node *". I'm now checking how many CPUs
> > > 
> > > Consider how kobject_has_children() uses that struct kobject *.
> > > Specifically:
> > > 	return kobj->sd && kobj->sd->dir.subdirs
> > > 
> > > It operates on kobj->sd, which is exactly what you have: struct kernfs_node.
> > 
> > So right. My turn to grumble about other peoples choice of names. If
> > that field was named "kn" instead of "sd" I would have spotted this
> > too.
> > 
> > > > 	remain in ci->shared_cpu_map to detect whether this is the
> > > > 	last SNC node.
> > > 
> > > hmmm, ok, will take a look ... but please finalize discussion of a patch series
> > > before submitting a new series that rejects feedback without discussion and
> > > does something completely different in new version.
> > 
> > Reinette,
> > 
> > So here's what rmdir_mondata_subdir_allrdtgrp() looks like using the
> > subdirs check. It might need an update/better header comment.
> > 
> > -Tony
> > 
> > ---
> > 
> > /*
> >   * Remove all subdirectories of mon_data of ctrl_mon groups
> >   * and monitor groups with given domain id.
> 
> (note comment still considers that domain id is parameter)

Will fix.

> >   */
> > static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> > 					   struct rdt_mon_domain *d)
> > {
> > 	struct rdtgroup *prgrp, *crgrp;
> > 	struct kernfs_node *kn;
> > 	char subname[32];
> 
> I wonder if static checkers will know that this cannot be used
> uninitialized?

I wondered that too. There are no complaints from gcc. How do people
deal with false positives from static checkers? Simplest would be to
provide an initializer:

	char subname[32] = "";

While that might shut up the static check, it would be more confusing
for human readers.

> > 	char name[32];
> > 
> > 	sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
> > 	if (r->mon_scope != RESCTRL_L3_CACHE) {
> > 		/*
> > 		 * SNC mode: Unless the last domain is being removed must
> > 		 * just remove the SNC subdomain.
> > 		 */
> > 		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
> > 	}
> > 
> > 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
> > 		kn = kernfs_find_and_get(prgrp->mon.mon_data_kn, name);
> > 		if (!kn)
> > 			continue;
> > 
> > 		if (kn->dir.subdirs <= 1)
> > 			kernfs_remove(kn);
> > 		else
> > 			kernfs_remove_by_name(kn, subname);
> > 
> > 		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list) {
> > 			kn = kernfs_find_and_get(crgrp->mon.mon_data_kn, name);
> > 			if (!kn)
> > 				continue;
> > 
> > 			if (kn->dir.subdirs <= 1)
> > 				kernfs_remove(kn);
> > 			else
> > 				kernfs_remove_by_name(kn, subname);
> > 		}
> > 	}
> > }
> 
> This solution looks more intuitive to me. I do think that it may be
> missing some kernfs_put()'s?

There aren't any kernfs_put()'s in the existing code.  Resctrl takes
an extra hold on the CTRL_MON and MON directories and jumps though some
hoops to drop that after the directory has been removed. But the monitor
directories have nothing like that.

> Reinette
> 
> ps. Please do give me a couple of days more with this series before you
>     submit a new version.

Sure. Will do.

-Tony
