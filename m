Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D55C1EB5E9
	for <patches@lists.linux.dev>; Mon, 21 Apr 2025 18:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745261859; cv=none; b=BRL2Jr6V4FxnbezOjogwt95zDC6wonyhfBd1MbHb/pSp8fS7mU2zvuYcS450ROczNab5uEUHAjH0n2mvy8wSpXipOnQ3Cl55heLSBU3h4LtmY82nloeUvH9kp+KxSmkIsVWzaNRP40qKEdnnUCWl9DM4Oqd2QBq3wldHQaBkzzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745261859; c=relaxed/simple;
	bh=4WHKX4vaIsBShOzVYvS1137NxE73/Gd16QlxKgPn6UQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UZjkT+S2NAsczYG3DeeibmhZu7wNEcxf+UePpT78Vzm/pgsFgw+pDgEQLWStn7QnaspDLS4LQ0wv47FPKDnOqmmSmvPqtB6ZJauVm+cppVAV6+Wdst9Bm8bjOm1aZeOKNFOfTzcfGrGYzRLqG/Zi5To9KAiuEVbeV+qmmbqXb6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z+yjLW3D; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z+yjLW3D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745261858; x=1776797858;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4WHKX4vaIsBShOzVYvS1137NxE73/Gd16QlxKgPn6UQ=;
  b=Z+yjLW3DXTxQ9wexySRFjZWGHVJulkkq6afKQ+3K8C02Q+QDcJN/UIJ8
   xEgDzFujvdV5Asgshojfa17TpicOvLn4tmDoktVy6TwEdLgQyTMdVuGzy
   4hMZiyscXSAsdr+6eSjvTcJ/8vRlAsIVX4d/EOf6aVnlQuKAGJSBTFjqp
   9iEtFBF/m79t66h605kxPihUj+EPjcYYRcbO/N3kcqFiw+28lnOyJ34nx
   vZtDHD4W2dv0eos8uxxO35GFo26f0j9VKp+5Wh/NA9Dq7XmTZHSv2U0HD
   waZgLZQDNt7FN2+RE3/rekdB0hFJbdyPnPZcFFbyVnnlUi91jl+/SYCEB
   Q==;
X-CSE-ConnectionGUID: 6uO/LEQgTAG/U67PBeEQRA==
X-CSE-MsgGUID: F9+dze/cT32Jk9IJjVbW1A==
X-IronPort-AV: E=McAfee;i="6700,10204,11410"; a="58171056"
X-IronPort-AV: E=Sophos;i="6.15,229,1739865600"; 
   d="scan'208";a="58171056"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2025 11:57:38 -0700
X-CSE-ConnectionGUID: 8TYnZeZDRqCJ1tXzEnnOlg==
X-CSE-MsgGUID: 3CrmwYFTT8K3Aceq0v2wFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,229,1739865600"; 
   d="scan'208";a="136946619"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2025 11:57:36 -0700
Date: Mon, 21 Apr 2025 11:57:35 -0700
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
Subject: Re: [PATCH v3 00/26] x86/resctrl telemetry monitoring
Message-ID: <aAaVH4W72fOzQhnh@agluck-desk3>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <53dcb55c-f5b6-4cb8-96b6-07aa1ba1d4d4@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53dcb55c-f5b6-4cb8-96b6-07aa1ba1d4d4@intel.com>

On Fri, Apr 18, 2025 at 02:13:39PM -0700, Reinette Chatre wrote:
> One aspect that is only hinted to in the final documentation patch is
> how users are expected to use this feature. As I understand the number of
> monitor groups supported by resctrl is still guided by the number of RMIDs
> supported by L3 monitoring. This work hints that the telemetry feature may
> not match that number of RMIDs and a monitor group may thus exist but
> when a user attempts to ready any of these perf files it will return
> "unavailable".
> 
> The series attempts to address it by placing the number of RMIDs available
> for this feature in a "num_rmids" file, but since the RMID assigned to a monitor
> group is not exposed to user space (unless debugging enabled) the user does
> not know if a monitor group will support this feature or not. This seems awkward
> to me. Why not limit the number of monitor groups that can be created to the
> minimum number of RMIDs across these resources like what is done for CLOSid?

Reinette,

The mismatch between number of RMIDs supported by different components
is a thorny one, and may keep repeating since it feels like systems are
composed of a bunch of lego-like bricks snapped together from a box of
parts available to the h/w architect.

In this case we have three meanings for "number of RMIDs":

1) The number for legacy features enumerated by CPUID leaf 0xF.

2) The number of registers in MMIO space for each event. This is
enumerated in the XML files and is the value I placed into telem_entry::num_rmids.

3) The number of "h/w counters" (this isn't a strictly accurate
description of how things work, but serves as a useful analogy that
does describe the limitations) feeding to those MMIO registers. This is
enumerated in telemetry_region::num_rmids returned from the call to
intel_pmt_get_regions_by_feature()

If "1" is the smallest of these values, the OS will be limited in
which values can be written to the IA32_PQR_ASSOC MSR. Existing
code will do the right thing by limiting RMID allocation to this
value.

If "2" is greater than "1", then the extra MMIO registers will
sit unused.

If "2" is less than "1" my v3 returns the (problematic) -ENOENT
This can't happen in the CPU that debuts this feature, but the check
is there to prevent running past the end of the MMIO space in case
this does occur some day. I'll fix error path in next version to
make sure this end up with "Unavailable".

If "3" is less than "2" then the system will attach "h/w counters" to
MMIO registers in a "most recently used" algorithm. So if the number
of active RMIDs in some time interval is less than "3" the user will
get good values. But if the number of active RMIDs rises above "3"
then the user will see "Unavailable" returns as "h/w counters" are
reassigned to different RMIDs (making the feature really hard to use).

In the debut CPU the "energy" feature has sufficient "energy" counters
to avoid this. But not enough "perf" counters. I've pushed and the
next CPU with the feature will have enough "h/w counters".

My proposal for v4:

Add new options to the "rdt=" kernel boot parameter for "energy"
and "perf".

Treat the case where there are not enough "h/w counters" as an erratum
and do not enable the feature. User can override with "rdt=perf"
if they want the counters for some special case where they limit
the number of simultaneous active RMIDs.

User can use "rdt=!energy,!perf" if they don't want to see the
clutter of all the new files in each mon_data directory.

I'll maybe look at moving resctrl_mon_resource_init() to rdt_get_tree()
and add a "take min of all RMID limits". But since this is a "can't
happen" scenario I may skip this if it starts to get complicated.

Which leaves what should be in info/PERF_PKG_MON/num_rmids? It's
possible that some CPU implementation will have different MMIO
register counts for "perf" and "energy". It's more than possible
that number of "h/w counters" will be different. But they share the
same info file. My v3 code reports the minimum of the number
of "h/w counters" which is the most conservative option. It tells
the user not to make more mon_data directories than this if they
want usable counters across *both* perf and energy. Though they
will actually keep getting good "energy" results even if then
go past this limit.

-Tony

> 
