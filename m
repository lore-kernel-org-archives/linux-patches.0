Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5556D28A1C9
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 17:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751563330; cv=none; b=MQBmiqDivPl6+F07EqjBi5fdB9YdJ+9KqoCghyDim2JgTxSgfemKbxhJZkrDEzzQTw76Qa/kHZRpR1NhOCmdGEUBb9NbmEzAOgEmfdHApESadre6bXKQuvDt/a+CW4Ubj3lgfLIMfA+W6IsSBL8KV/2s8Wv70L9WN6c1gdGY19A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751563330; c=relaxed/simple;
	bh=Qw+IYDTpeU25wnsb845P44ht13JehRjuPI0KIa8k8PQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bP0acGEIEDxyUlUyq2g3KITUia2Y6E2npMnuXB3Fo77/KP60gtXsUl9UDOzS0hPQlemRZ29nnTVivLzWRlHJjLkhJEqV88Wf104WyKlk7OSwWaripsSCwPqylxOg8gwk8Y5G+IA1la8vLD5bfsIn0BOb+BTA+n63nHvnIZm6Dss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=epzG8Wsh; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="epzG8Wsh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751563329; x=1783099329;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Qw+IYDTpeU25wnsb845P44ht13JehRjuPI0KIa8k8PQ=;
  b=epzG8Wshflk79KSf1njXVraUkfCrtxeBKGiqqruAOag/ahLlRGSxYYF1
   gvsoGYPUB7BuimKsi1EGpoLgHE0Hb1OI4UuqDOD6gPjd8WiN9E1o5C1yC
   GcPyHPDJVMYHhIdEkmB3hzKuj/Xd+bYCJJEK/kfnBB567HIh1XZaogcfD
   TkzR8n1FXv4LsXWm6rgx5avra/rBvJr8MDho0yQijv6kNyR/AujXqwb2S
   wS1AOmrFsObxYrlSMhUGqCYCyj+6UWT2sW4Rlh4Vc2mpVxOye8zMkdUjV
   WmtKBKFq9OwpqqP63Dt9gWAlUv9Md7rRt8WcqSh887Yscla5hzZUpNGLj
   w==;
X-CSE-ConnectionGUID: L34tpyJASimKKGwQQyhiAQ==
X-CSE-MsgGUID: M3bKR7ehQo6zyeahHlhjeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="64951487"
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="64951487"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 10:22:08 -0700
X-CSE-ConnectionGUID: 3zxplcqwR4Gi+sL3lJbOrA==
X-CSE-MsgGUID: oo8s2FnVTJuPzOxBOrRnhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="154793762"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 10:22:07 -0700
Date: Thu, 3 Jul 2025 10:22:06 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v6 00/30] x86,fs/resctrl telemetry monitoring
Message-ID: <aGa8Pg9pSCJ3XjtY@agluck-desk3>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <b2de4c92-a883-40b0-92e0-16fac9e386b0@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2de4c92-a883-40b0-92e0-16fac9e386b0@intel.com>

On Thu, Jul 03, 2025 at 09:45:15AM -0700, Reinette Chatre wrote:
> Hi Tony and Dave,
> 
> On 6/26/25 9:49 AM, Tony Luck wrote:
> >  --- 14 ---
> > Add mon_evt::is_floating_point set by resctrl file system code to limit
> > which events architecture code can request be displayed in floating point.
> > 
> > Simplified the fixed-point to floating point algorithm. Reinette is
> > correct that the additional "lshift" and "rshift" operations are not
> > required. All that is needed is to multiply the fixed point fractional
> > part by 10**decimal_places, add a rounding amount equivalent to a "1"
> > in the binary place after those supplied. Finally divide by 2**binary_places
> > (with a right shift).
> > 
> > Explained in commit comment how I chose the number of decimal places to
> > use for each binary places value.
> > 
> > N.B. Dave Martin expressed an opinion that the kernel should not do
> > this conversion. Instead it should enumerate the scaling factor for
> > each event where hardware reported a fixed point value. This patch
> > could be dropped and replaced with one to enumerate scaling factors
> > per event if others agree with Dave.
> 
> Could resctrl accommodate both usages? For example, it does not
> look too invasive to add a second file <mon_evt::name>.raw for the
> mon_evt::is_floating_point events that can output something like Dave
> suggested in [1]:
> 
> .raw file format could be:
> 	#format:<output that depends on format>
> 	#fixed-point:<value>/<scaling factor>
> 
> Example output:
> 	fixed-point:0x60000/0x40000

Dave: Is that what you want in the ".raw" file? An alternative would be
to put the format information for non-integer events into an
"info" file ("info/{RESOURCE_NAME}_MON/monfeatures.raw.formats"?)
and just put the raw value into the ".raw" file under mon_data.

> 
> Reinette
> 
> [1] https://lore.kernel.org/lkml/aEhMWBemtev%2Ff3yf@e133380.arm.com/

-Tony
