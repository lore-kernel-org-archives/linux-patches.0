Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD441BE842
	for <patches@lists.linux.dev>; Tue,  2 Jul 2024 17:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940604; cv=none; b=ZP4NLZCu3R74xidl3GXXvHVByf7lJ4e1NaHEt6cp77TOK+6/0s2zTA3gkBkYTWFCQ8neCCnDI1LTmxTijuaHJR3KAiKjzVbIlD7QiSfXkEk1vX84baNZqODm5rsdLM/sBIKC1YqKJg5I58G5+At4m8clwWnxPIHggZL/YX1U9XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940604; c=relaxed/simple;
	bh=C3j60canvGPUuCR7dSKydtKZSnkNQmPoIPzquCxsWus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NI6HHRxCGEF8QIwAKeHTPMDmUsc3PCoDH8Yyc4pGtDjoA2fRajInMaWRon1+CB389QCVSlwIlpftAljVN8OV+4C6qHkrbsPWSI43kq2yj3OLiWtWbqbLK4r1Wj5po/NCBMTp9WAvnVPJtCO19myWNl+exdmFFlgUBIvxyH34//M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T7XC8jpQ; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T7XC8jpQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719940602; x=1751476602;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=C3j60canvGPUuCR7dSKydtKZSnkNQmPoIPzquCxsWus=;
  b=T7XC8jpQIC2Gyv5lekRk3lCctAhsRgljnQkRX1Sqp0KWSWRwULqi5VA1
   ro9pR9edZcDNaTSFat12FtquPGWiXGoIFmkUz94Apry3+cVHX2/W0RANm
   wc1/b7zxoNdNFD7oouNGLdMnqk/R2aGHiobTsbyB9dQn4Krkb53wSioe9
   XptB+JzB8tk2bZkWyVsCKX1AVW9OveAtPl+TzbLOCUp+QE/jm60vHUHMO
   Mfp9Ji1LCfSuWMIRNM2D6nNmMjEFeRfVsWpbvuXPa6XCNPqLSpbidaHJ8
   6/fnCN+tjno7ihqZGFA3QXLM63iiG2DUI2v/hzaxN5qWT/ZkrCDMpaEIx
   Q==;
X-CSE-ConnectionGUID: osnaIqrARgilTGGh0RrOLA==
X-CSE-MsgGUID: XUGf5idMRiq1L/3+YIIqXA==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="20032505"
X-IronPort-AV: E=Sophos;i="6.09,178,1716274800"; 
   d="scan'208";a="20032505"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 10:16:42 -0700
X-CSE-ConnectionGUID: /2yoOLtkS7esvdn37AdY4w==
X-CSE-MsgGUID: sdejj7ZzTiWc2l1X95wlNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,178,1716274800"; 
   d="scan'208";a="76709409"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 10:16:41 -0700
Date: Tue, 2 Jul 2024 10:16:39 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v23 14/19] x86/resctrl: Handle removing directories in
 Sub-NUMA Cluster (SNC) mode
Message-ID: <ZoQ1937ntIdMNQwL@agluck-desk3.sc.intel.com>
References: <20240628215619.76401-1-tony.luck@intel.com>
 <20240628215619.76401-15-tony.luck@intel.com>
 <20240702085337.GAZoPAEaEBtT18iD3V@fat_crate.local>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702085337.GAZoPAEaEBtT18iD3V@fat_crate.local>

On Tue, Jul 02, 2024 at 10:53:37AM +0200, Borislav Petkov wrote:
> On Fri, Jun 28, 2024 at 02:56:14PM -0700, Tony Luck wrote:
...
> ... and this are almost identical hunks.
> 
> Why isn't there a helper which gets called here?

A helper will avoid this duplication. Draft below. Is this
what you want? Is the function name OK. I wasn't sure if the
"mon" looked better at the beginning. Or as rmdir_one_mon_subdir()

I've also fixed up part 17 to use msr_clear_bit()

Are you still digging through the patches?

-Tony

static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subname)
{
	struct kernfs_node *kn;

	kn = kernfs_find_and_get(pkn, name);
	if (!kn)
		return;
	kernfs_put(kn);

	if (kn->dir.subdirs <= 1)
		kernfs_remove(kn);
	else
		kernfs_remove_by_name(kn, subname);
}

/*
 * Remove all subdirectories of mon_data of ctrl_mon groups
 * and monitor groups for the given domain.
 * Remove files and directories containing "sum" of domain data
 * when last domain being summed is removed.
 */
static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
					   struct rdt_mon_domain *d)
{
	struct rdtgroup *prgrp, *crgrp;
	char subname[32];
	bool snc_mode;
	char name[32];

	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci->id : d->hdr.id);
	if (snc_mode)
		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);

	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
		mon_rmdir_one_subdir(prgrp->mon.mon_data_kn, name, subname);

		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list)
			mon_rmdir_one_subdir(crgrp->mon.mon_data_kn, name, subname);
	}
}
