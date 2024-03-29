Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF5B101D0
	for <patches@lists.linux.dev>; Fri, 29 Mar 2024 15:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711726300; cv=none; b=Ut2P3P5RcvSToQ6o8nAg8FjO+tSXMewBxeofD6USBOwMKUPrvdyhI7eMBA5hOUvYAVlQjUcKCOoIZfMpTvDrV6EV15TWm5Fcix46OVPkpfvkN90vn4L24WpcMAvL19mcHv06cHUhxSzCPIu9+muPU19VwcllbkSsl24wHLTa3tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711726300; c=relaxed/simple;
	bh=o5wvscSbfKEAAlh6310IOTAWfM+GCnb8Nb2D8Svvj1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LJEVxdg2pHvd8iSgY3WuU7PX0TYTWpYC6d+QmGXLl5GdNwle54QIKd/KKCRpE24aQG4uj8jnIZjgwtRzSgizWSaYKEC0sVXeo44kbZqxAD6JCedOz5o1p2ehcqwt7yAAhu6TGB2fJGMwYvdziExvtdadhxLbuGsvsjXpcBun5W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KG7nAZHV; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KG7nAZHV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711726298; x=1743262298;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=o5wvscSbfKEAAlh6310IOTAWfM+GCnb8Nb2D8Svvj1c=;
  b=KG7nAZHVSFxRPLY8Qs7DvYuzLkil4enE2onSTw4x+yYFXWDXPL8NwnDV
   21NpDjJGLPgJ9jDEgKpEj/ON03EzQFOTOjVWcpTRw+3BaWNyAWx0E+o2d
   YW8JFwyI6TxFLK2AnwIgaFBo8XmRHOJXqEJ1CnlscHY7F/QjzYYPFlQUr
   nis0vzYST340tc8Pe+pkRq1nQWNDR06yxfSMcaZITyQzYVbUyj5VpZU6r
   3A1SbdD1UZWpS4OnwORyYTPZEjaOidqpNeIX1afFR8y6bxt8Ro3X9M6UW
   ceE7Ql6SazCgZbTersDKvhe/1m9W/O4fdenGOhbVAKf+teoQY07L4uRhE
   Q==;
X-CSE-ConnectionGUID: XLfK9PExRaS1IXPiov+IEQ==
X-CSE-MsgGUID: yLlmd8CeRiitF3WADwbZBg==
X-IronPort-AV: E=McAfee;i="6600,9927,11028"; a="10730114"
X-IronPort-AV: E=Sophos;i="6.07,165,1708416000"; 
   d="scan'208";a="10730114"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2024 08:31:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,165,1708416000"; 
   d="scan'208";a="16972603"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.105])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2024 08:31:37 -0700
Date: Fri, 29 Mar 2024 08:31:36 -0700
From: Tony Luck <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-doc@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] Documentation/x86: Document resctrl bandwidth control
 units are MiB
Message-ID: <Zgbe2FFwyHMmmsyM@agluck-desk3>
References: <20240322182016.196544-1-tony.luck@intel.com>
 <56a93ec2-dc01-49be-b917-5134f5794062@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56a93ec2-dc01-49be-b917-5134f5794062@intel.com>

On Thu, Mar 28, 2024 at 06:01:33PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 3/22/2024 11:20 AM, Tony Luck wrote:
> > The memory bandwidth software controller uses 2^20 units rather than
> > 10^6. See mbm_bw_count() which computes bandwidth using the "SZ_1M"
> > Linux define for 0x00100000.
> > 
> > Update the documentation to use MiB when describing this feature.
> > It's too late to fix the mount option "mba_MBps" as that is now an
> > established user interface.
> 
> I see that this is merged already but I do not think this is correct.

I was surprised that Ingo merged it without giving folks a chance to
comment.

> Shouldn't the implementation be fixed instead? Looking at the implementation
> the intent appears to be clear that the goal is to have bandwidth be
> MBps .... that is when looking from documentation to the define
> (MBA_MAX_MBPS) to the comments of the function you reference above
> mbm_bw_count(). For example, "...and delta bandwidth in MBps ..."
> and "...maintain values in MBps..."

Difficult to be sure of intent. But in general when people talk about
"megabytes" in the context of memory they mean 2^20. Storage capacity
on computers was originally in 2^20 units until the marketing teams
at disk drive manufacturers realized they could print numbers 4.8% bigger
on their products by using SI unit 10^6 Mega prefix (rising to 7.3% with
Giga and 10% with Tera).

It is clear that the code uses 2^20 as it converts from bytes using
a right shift by 20.

Fixing the code would change the legacy API. Folks with a schemata
file that sets a limit of 5000 MB/s would find their applications
throttled by an addtional 4.8% on upgrading to a kernel with this
"fix".

> To me this change creates significant confusion since it now contradicts
> with the source code and comments I reference above. Not to mention the
> discrepancy with user documentation.
> 
> If you believe that this should be MiB then should the
> source and comments not also be changed to reflect that? Or alternatively,
> why not just fix mbm_bw_count() to support the documentation and what
> it appears to be intended to do. If users have been using the interface
> expecting MBps then this seems more like a needed bugfix than 
> a needed documentation change.

I agree that the comments need to be fixed. I will spin up a patch.

> Finally, if you make documentation changes, please do build the
> documentation afterwards. This change introduces a warning:
> 
> Memory bandwidth Allocation specified in MiBps
> ---------------------------------------------
> .../linux/Documentation/arch/x86/resctrl.rst:583: WARNING: Title underline too short.

My bad. Ingo has already applied a fix to TIP x86/urgent. I assume that
will be merged to Linus soon.

https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=x86/urgent&id=91491e5fb09624116950f9f2e1767a42e1da786

-Tony
