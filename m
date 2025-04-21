Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96918BEA
	for <patches@lists.linux.dev>; Mon, 21 Apr 2025 19:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745265034; cv=none; b=TJFp6nshe92e+HD54xNvW3eBrWTj0WhxCmMVQiAkSWbRs+KtCaMdyJlkfjvijO2Mumks/MQIVoZ+aMdWubayEfXs38CJT7bHse97SCO2DdIkkRp5EiG+9kOL5c0D5tF9vZQGPc5vKNrN+Rkse9bOPWjjgnxMVmcpXakEUjgfuw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745265034; c=relaxed/simple;
	bh=ybN8/D3DwdDsf4kxotjWKDlJLEajwmwv6kf50pNbrAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=obDvmd37F6oleMceWCz8Ed1hcpG3mcLlrZuzI4RaJAz1/ubY1B63DrXMu7DM22Q52tAnbs+nzGxg9mGdE6MkNbmdkujWKDnACta79/cZmoYjm9zEDfNYS+n4ffh0jII1gW6NzXKVs3wuHE2PKEkC5Kgh/JeaTgW+bHLp0/MYlWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iWSLhc2e; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iWSLhc2e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745265033; x=1776801033;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ybN8/D3DwdDsf4kxotjWKDlJLEajwmwv6kf50pNbrAs=;
  b=iWSLhc2ek9pzuV3rH3XuDT4m4XIsj55Wel9WxwgPbfSU/T0cX4WEbW7i
   AAurZ2qhrAvlLh8RsAFu9FRAR2cFx+8Wpu+tq/5En/+zrUKa98vAXw8XM
   /K0PSMwO9p9RzHipCwZDtLtsDFwox3j0l9PNydrqiQbAT7xpyg/ETYkFZ
   dF2PZ34l6kWBabO2GScEwYsEVNNiF3tP3ea8CyeFwmFBx8Ezq9I3VEmvC
   hWTFeGoqHpnzCES4i6OW8ZFuYkLdo4tWP0Vv797oTdyl2DBzXtqmPDDhY
   +NDRHdUQT174usbRKocsDfnKT8soS33SGtare4PLPsW4rOzyRvasZEsqO
   w==;
X-CSE-ConnectionGUID: mKx4xsAaRY+x7SSQxvtR3Q==
X-CSE-MsgGUID: 8ghKfXZzTJKAdtVH3lFSrg==
X-IronPort-AV: E=McAfee;i="6700,10204,11410"; a="50467272"
X-IronPort-AV: E=Sophos;i="6.15,229,1739865600"; 
   d="scan'208";a="50467272"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2025 12:50:33 -0700
X-CSE-ConnectionGUID: 7pt6h8IkTCSCJYJnRtkvYQ==
X-CSE-MsgGUID: PqlTLV11R/uK0RnTi5v+Lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,229,1739865600"; 
   d="scan'208";a="132112044"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2025 12:50:32 -0700
Date: Mon, 21 Apr 2025 12:50:31 -0700
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
Subject: Re: [PATCH v3 12/26] fs/resctrl: Add hook for architecture code to
 set monitor event attributes
Message-ID: <aAahh0Mv6m1sIq1k@agluck-desk3>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-13-tony.luck@intel.com>
 <948e4fb6-f1c2-4547-b430-7d9ca3af7cf3@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <948e4fb6-f1c2-4547-b430-7d9ca3af7cf3@intel.com>

On Fri, Apr 18, 2025 at 04:11:22PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 4/7/25 4:40 PM, Tony Luck wrote:
> > Architecture code knows whether an event can be read from any CPU, or
> > from a CPU on a specific domain. It also knows what format to use
> > when printing each event value.
> > 
> > Add a hook to set mon_event.any_cpu and mon_event.type.
> 
> If the architecture modifies the output format then the values exposed
> to user space will look different between architectures. User space will
> need to know how to parse the data. We do not want user space to need to
> know which architecture it is running on to determine how to interact with
> user space so this makes me think that this change needs to be accompanied
> with a change that exposes the event format to user space.

Would it be enough to include this in Documentation? I.e. add specific
entries for "core_energy" to say that it is reported as a floating point
value with unit Joules, and "activity" is reported as a floating point
value with unit of Farads.

Alternatively the filesystem code could convert the fixed point values
to integer values of micro-Joules and micro-Farads. Then the filesystem
code can print with "%llu" just like every other event. Would still need
the Documentation entries to explain the units. This has the limitation
that some future implementation that measures in greater precision would
be forced to round to nearest micro-{Joule,Farad}.

File system code controls the formating options available, so options
for architecture code to break the user interface are limited.

-Tony
