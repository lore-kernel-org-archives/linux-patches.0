Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B0A322A
	for <patches@lists.linux.dev>; Fri,  6 Jun 2025 00:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749168593; cv=none; b=mqe59bekm9f4o91Qxz/lPiQCkm4ySK9EAALP2dSL4Yr14HNul5ohwbX4u9Up7NYWyLGEBzcI5GzdL+BzSwdPp/Zq1dmxf2zpkOTrfiBLR9sFHi3MCZPsWKKGYiHvECozrgqnhFDi6zhB0/+l3JxG4Cm6vKXeffQlW5oimCEjWBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749168593; c=relaxed/simple;
	bh=HelkW/bWw8McxxXZHEIrR28siZM+fgO3DHrIn0ODxGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bc/Kbqn/T2bbeU9wqTKX+ankVAISuBaYFteP1DcSmeGWmugE0Ky69glTicgrHLEttJG1DiN3n83LeBWpHV6Qa10HAH13U3yUBXHoCoxN4iUOeahThhuIh6tgesOMbVIi/72SjDmUHGLtAi1gVvNzi5M6wKotz68g9jykyiV1yjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hU3ahuw4; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hU3ahuw4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749168592; x=1780704592;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HelkW/bWw8McxxXZHEIrR28siZM+fgO3DHrIn0ODxGo=;
  b=hU3ahuw4nxEL0uH0hSp+rlEZ3UMay/zp2tA0ZaYT3qRLHmhL3xAkEWYe
   ZxfqtwWYVZIq18B+PxBgSxhHQV9LAOPzqY3DFCOplqXEM5YpSX001EYuK
   LRGKO3GuWb5BYN1++Ij0+xX5sR9+eZ+aUelVLxbYBVjUy/Psy1xgL1sqL
   ao8AfyUXYs4JPnRyTdcf4/FVRLAxY7XBg3vsDAFZfiKLtcek6kFQUjKyU
   6JIepeE03nsgcIXRz3e+7ASxkaO6JvLYH98MzGBixqVdRXkmvkJDSze3E
   pHeFPd2WReEkMUjbLAuOseeN7NftyQ/Bka8Dbpjr4cGzLPFE75dcBZef9
   A==;
X-CSE-ConnectionGUID: zeR7JpoCQbqZjJy5XJNWkQ==
X-CSE-MsgGUID: rPwmdpAVQpCPv0T5LSWFwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11455"; a="55101501"
X-IronPort-AV: E=Sophos;i="6.16,213,1744095600"; 
   d="scan'208";a="55101501"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 17:09:51 -0700
X-CSE-ConnectionGUID: 7BiVIETJSymTZrniWRzO7w==
X-CSE-MsgGUID: O1hvVvTySe6NS5MwRlktaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,213,1744095600"; 
   d="scan'208";a="176629122"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 17:09:51 -0700
Date: Thu, 5 Jun 2025 17:09:49 -0700
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
Subject: Re: [PATCH v5 27/29] fs/resctrl: Add file system mechanism for
 architecture info file
Message-ID: <aEIxzbuFybLBE3xt@agluck-desk3>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-28-tony.luck@intel.com>
 <f25d136c-b1d3-483a-ac77-92464d7fe25c@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f25d136c-b1d3-483a-ac77-92464d7fe25c@intel.com>

On Tue, Jun 03, 2025 at 09:15:02PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/21/25 3:50 PM, Tony Luck wrote:
> > Creation of all files in the resctrl file system is under control of
> > the file system layer.
> > 
> > But some resources may need to add a file to the info/{resource}
> > directory for debug purposes.
> > 
> > Add a new rdt_resource::info_file field for the resource to specify
> > show() and/or write() operations. These will be called with the
> > rdtgroup_mutex held.
> > 
> > Architecture can note the file is only for debug using by setting
> > the rftype::flags RFTYPE_DEBUG bit.
> 
> This needs to change. This punches a crater through the separation
> between fs and arch that we worked hard to achieve. Please make an attempt
> to do so as I am sure you can.

The file I want to create here amy only be of interest in debugging
the telemetry h/w interface. So my next choice is debugfs.

But creation of the debugfs "resctrl" directory is done by file
system code and the debugfs_resctrl variable is only marked "extern" by
fs/resctrl/internal.h, so currently not accessible to architecture code.

Is that a deliberate choice? Would it be OK to make that visible to
architecture code to create files in /sys/kernel/debug/resctrl?

Or should I add my file in a new /sys/kernel/debug/x86/resctrl
directory?

-Tony
