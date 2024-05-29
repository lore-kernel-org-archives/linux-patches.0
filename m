Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104D1157E9D
	for <patches@lists.linux.dev>; Wed, 29 May 2024 20:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717014034; cv=none; b=dWZx6r9zovFPJKHDuC6N9X9suzjyuISjjzkOPnsAYdVOzkF/RQWj+GXx9ZFVgAhjUh7Lmj5QMNN0RC/g2c422K62X1resSZb435nCxCMMVQpT2CxUChqeliyl9eqyvuVNgZN9CZIoMeH7cPSC9mY7+tf+tt2qyGgIubSgkk+H3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717014034; c=relaxed/simple;
	bh=/Y28hbBOtK57TCN8FXJojnbsAgLCRqTn2Drt1yM5zRk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h5iWu9gSl1g3b6Z2JSxYxw6rUoeIXm55eAj+ngIIZwscOx+IbBqGqnpXA1z7xCLtG/ZusyrU356awlKRFBVBmb2rnaK78rupi3WYKYYjcJxkdDzXuiTuen9boAnmnooH4kdWsISNOHzCX169objWFYmkKFxF+3T/nNUadEy9MrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D2+SaGAz; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D2+SaGAz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717014033; x=1748550033;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/Y28hbBOtK57TCN8FXJojnbsAgLCRqTn2Drt1yM5zRk=;
  b=D2+SaGAz2mOidEqCJQUguG9ePhtcKSBqRxNY2DCKr1nAAz7vm5R4A0ja
   GgC7K+/clBgK44pRAFudh+VcSjk3fJNxWg/8nsqT6KVPzapi5pN99HMyl
   Q72CVLb5+9DtYVKMTxmNSmtI339JnU3I+cqZkrlSREFh12A75CtYeWs1r
   cpqempUxkdh8DyDyXz+4FNVvoknqpeJ2RGsuFxbJqcTrlJgTAi8ow/Xr6
   UVxzfmDnvE0ugHyq333ezxXbcD6ZSC5FtRIEHdxe75DRPK3Hbyn8G+cuQ
   qGIE6huLq8QfMTK/29AZb26fUcgpMqmDtkQDqemdHXRXpdvdgnN1z1sFr
   A==;
X-CSE-ConnectionGUID: 2wBeBNC+ThaqRHkjKNPhrA==
X-CSE-MsgGUID: M23lQefwRFWD0YuLx35A7w==
X-IronPort-AV: E=McAfee;i="6600,9927,11087"; a="13264779"
X-IronPort-AV: E=Sophos;i="6.08,199,1712646000"; 
   d="scan'208";a="13264779"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2024 13:20:32 -0700
X-CSE-ConnectionGUID: Iy6SnbodRKy2moBrJcINAw==
X-CSE-MsgGUID: IgGj007RROOYQ0mR+V+6RQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,199,1712646000"; 
   d="scan'208";a="36104289"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2024 13:20:32 -0700
Date: Wed, 29 May 2024 13:20:30 -0700
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
Message-ID: <ZleODtL_6D-Q_OMX@agluck-desk3.sc.intel.com>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <08ca8fe7-9da6-41da-aad2-0081b789326c@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08ca8fe7-9da6-41da-aad2-0081b789326c@intel.com>

On Tue, May 28, 2024 at 03:55:29PM -0700, Reinette Chatre wrote:
> Hi Tony,
> > 13:	Wordsmith commit into imperative.
> > 	I looked at using kobject_has_children() to check for empty
> > 	directory, but it needs a "struct kobject *" and all I have
> > 	is "struct kernfs_node *". I'm now checking how many CPUs
> 
> Consider how kobject_has_children() uses that struct kobject *.
> Specifically:
> 	return kobj->sd && kobj->sd->dir.subdirs
> 
> It operates on kobj->sd, which is exactly what you have: struct kernfs_node.

So right. My turn to grumble about other peoples choice of names. If
that field was named "kn" instead of "sd" I would have spotted this
too.

> > 	remain in ci->shared_cpu_map to detect whether this is the
> > 	last SNC node.
> 
> hmmm, ok, will take a look ... but please finalize discussion of a patch series
> before submitting a new series that rejects feedback without discussion and
> does something completely different in new version.

Reinette,

So here's what rmdir_mondata_subdir_allrdtgrp() looks like using the
subdirs check. It might need an update/better header comment.

-Tony

---

/*
 * Remove all subdirectories of mon_data of ctrl_mon groups
 * and monitor groups with given domain id.
 */
static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
					   struct rdt_mon_domain *d)
{
	struct rdtgroup *prgrp, *crgrp;
	struct kernfs_node *kn;
	char subname[32];
	char name[32];

	sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
	if (r->mon_scope != RESCTRL_L3_CACHE) {
		/*
		 * SNC mode: Unless the last domain is being removed must
		 * just remove the SNC subdomain.
		 */
		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
	}

	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
		kn = kernfs_find_and_get(prgrp->mon.mon_data_kn, name);
		if (!kn)
			continue;

		if (kn->dir.subdirs <= 1)
			kernfs_remove(kn);
		else
			kernfs_remove_by_name(kn, subname);

		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list) {
			kn = kernfs_find_and_get(crgrp->mon.mon_data_kn, name);
			if (!kn)
				continue;

			if (kn->dir.subdirs <= 1)
				kernfs_remove(kn);
			else
				kernfs_remove_by_name(kn, subname);
		}
	}
}
