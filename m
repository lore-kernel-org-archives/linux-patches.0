Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAD52356B0
	for <patches@lists.linux.dev>; Fri,  9 May 2025 16:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746808709; cv=none; b=q9tANx3YLUi9FHFxtAM9Hrqw4qsDpiY+6R6+Zg1wXC7OYhF3Ub/fM3nwxuuQRssTZVhKUhcfWkv1sn9BSV5SpxUedXgZQItOX9AIKTtlBAywm7O2F/ySqH8azdvahJaAjvSccVIdHEh4JwsDm50DGmNCGKiVWOHpb1XqF1n1/Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746808709; c=relaxed/simple;
	bh=STl8VahwXPy5a+n87xzyjRdrrYEIqZvtuylaQJ5drgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=chUM1HdMxasZvXoub2fs70EG82puMr759rA9FeIL7ariZXDIDNRzH59noTnrwc+TqGhI/9ZZmqM7oiCkcPG3da5TWDChhQacGaGcHIdqWWJGgfA8tcHNtbIIUi3nKc2wmg24mp5QoIahlpLttS/jtVpTOSVdm7KlCBp8gzCVYJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ua7k5t7x; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ua7k5t7x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746808707; x=1778344707;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=STl8VahwXPy5a+n87xzyjRdrrYEIqZvtuylaQJ5drgw=;
  b=Ua7k5t7x+K+cIiW4cY2vLJLqXW6gox8PR2UTKBw/NDgoNpaRchfCxfcA
   p8F+yIPexdpvPS8ijXMLTuWtU1jmdsPKGS+2vag+i190xH6ESimzmi6ld
   egIHG27eIeuF5O0ncXJxEbbEnVE7jzCpVDSgQVf1GW/MfjdPO81T8tFzY
   X4JZspnGalAiSyUvCBMnTKQGGalhBamneIpgj3rccE9q/Ozl5HgyN216x
   t0oYV+SI6eStCtwC7I1BTcypBmEzsC4oAcjjWx9moBLxngBcvsCC1jJaD
   FjqPONsj+cUPvv/VTA3BhRCIdGlnm4OXiGl4gNU0lBnr9gttxeqQRVzq3
   A==;
X-CSE-ConnectionGUID: WELF90OOSH+DjnLScT3fsg==
X-CSE-MsgGUID: 3cQFXO5XQMm0GARKp6Lx8g==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48342468"
X-IronPort-AV: E=Sophos;i="6.15,275,1739865600"; 
   d="scan'208";a="48342468"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 09:38:26 -0700
X-CSE-ConnectionGUID: Gf/sWDlRQYS0vGChx7rzCA==
X-CSE-MsgGUID: xxfASkgjSumv6NGb5fIkGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,275,1739865600"; 
   d="scan'208";a="136543245"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 09:38:26 -0700
Date: Fri, 9 May 2025 09:38:25 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Peter Newman <peternewman@google.com>
Cc: Dave Martin <Dave.Martin@arm.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v4 13/31] fs/resctrl: Add support for additional monitor
 event display formats
Message-ID: <aB4vgVi-6VbiOKJ5@agluck-desk3>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-14-tony.luck@intel.com>
 <4aa0904d-9332-4796-90d6-d858711fc611@intel.com>
 <aB0T_Ep2lJzfwjv5@agluck-desk3>
 <2a19f63a-f9b4-4632-bca2-2f64f6fed57b@intel.com>
 <aB3nGDzW6pNNkYTB@e133380.arm.com>
 <CALPaoCjzrGMTEYmTpH=9o_=N24apE0U057p6Mt6Knt9PoyFmzw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALPaoCjzrGMTEYmTpH=9o_=N24apE0U057p6Mt6Knt9PoyFmzw@mail.gmail.com>

On Fri, May 09, 2025 at 04:46:30PM +0200, Peter Newman wrote:
> Hi Dave,
> 
> On Fri, May 9, 2025 at 1:29 PM Dave Martin <Dave.Martin@arm.com> wrote:
> >
> > Hi,
> >
> > (Backtrace retained for context -- see my comment at the end.)
> >
> > Cheers
> > ---Dave
> >
> > [...]
> >
> > On Thu, May 08, 2025 at 04:45:21PM -0700, Reinette Chatre wrote:
> > > Hi Tony,
> > >
> > > On 5/8/25 1:28 PM, Luck, Tony wrote:
> > > > On Thu, May 08, 2025 at 08:49:56AM -0700, Reinette Chatre wrote:
> > > >> On 4/28/25 5:33 PM, Tony Luck wrote:
> > > >>> Resctrl was written with the assumption that all monitor events
> > > >>> can be displayed as unsigned decimal integers.
> > > >>>
> > > >>> Some telemetry events provide greater precision where architecture code
> > > >>> uses a fixed point format with 18 binary places.
> > > >>>
> > > >>> Add a "display_format" field to struct mon_evt which can specify
> > > >>> that the value for the event be displayed as an integer for legacy
> > > >>> events, or as a floating point value with six decimal places converted
> > > >>> from the fixed point format received from architecture code.
> > > >>
> > > >> There was no discussion on this during the previous version.
> > > >> While this version addresses the issue of architecture changing the
> > > >> format it does not address the issue of how to handle different
> > > >> architecture formats. With this change any architecture that may
> > > >> want to support any of these events will be required to translate
> > > >> whatever format it uses into the one Intel uses to be translated
> > > >> again into format for user space. Do you think this is reasonable?
> > > >>
> > > >> Alternatively, resctrl could add additional file that contains the
> > > >> format so that if an architecture in the future needs to present data
> > > >> differently, an interface will exist to guide userspace how to parse it.
> > > >> Creation of such user interface cannot be delayed until the time
> > > >> it is needed since then these formats would be ABI.
> > > >
> > > > What if resctrl filesystem allows architecture to supply the number
> > > > of binary places for fixed point values when enabling an event?
> > >
> > > This sounds good. I do not think we are in a position to come up with
> > > an ideal solution. That would require assumptions of what another
> > > architecture may or may not do and thus we do not have complete information.
> > >
> > > >
> > > > That would allow h/w implementations to pick an appropriate precision
> > > > for each new event. Different implementations of the same event
> > > > (e.g. "core_energy") may pick different precision across architectures
> > > > or between generations of the same architecture.
> > > >
> > > > File system code can then do:
> > > >
> > > >     if (binary_places == 0)
> > > >             display as integer
> > > >     else
> > > >             convert to floating point (with one decimal place per
> > > >             three binary places)
> > >
> > > I do not think this problem needs to be solved in this work but there needs
> > > to be a plan for how other architectures can be supported. When similar
> > > enabling needs to be done for that hypothetical architecture then it can
> > > be implemented ... if it is still valid based on what that architecture actually
> > > supports.
> > > It may be sufficient for the "plan" (as above) to be in comments.
> > >
> > > >
> > > > Existing events are all integers and won't change (it would be weird
> > > > for an architecture to report "mbm_local_bytes" with a fixed point
> > > > rather than integer value).
> > > >
> > > > New events may report in either integer or floating point format
> > > > with varying amounts of precision. But I'm not sure that would be
> > >
> > > Partly this will depend on the unit of measurement that should form part of
> > > the definition of the event. For example, events reporting cycles or ticks
> > > should only be integer, no?
> > >
> > > > a burden for writing tools that can run on different architectures.
> > >
> > > Maybe just a comment in the docs then ... and now I see that you did
> > > so already. My apologies, I did not get to the last four patches.
> > >
> > > Reinette
> >
> > Just a thought, but I think that while it's not possible to be fully
> > generic, a parameter model along the lines of
> >
> >         quantity = raw_value * ((double)multiplier / divisor) * BASE_UNIT
> >
> > would cover most things that we have or can reasonably foresee,
> > including memory bandwidth control values.
> > raw_value, multiplier and divisor would all be integers.
> >
> > Since raw_integer can be the value used by the hardware, its precision
> > can probably be fixed at 1, though we could still report it explicitly.
> >
> > Fundamental base units would be things like "byte", "bytes per second"
> > and "none" (i.e., dimensionless quantities).  (Are there others?)

The energy telemetry counters implemented in this series have:

	core_energy:	Units are Joules
	activity:	Units are Farads (Dynamic Capicitance or "CDyn")

Each of these is reported by h/w as a fixed-point binary value with 18
binary places. I'm proposing reporing these as floating point decimal
value with six decimal places (since 1/2^18 ~= 0.0000038)
Loss of precision from conversion to decimal is likely far smaller than
the error bars on the estimation of these values).

> >
> > Since we cannot guess for certain what userspace wants to do with the
> > values, it feels better to let userspace do any scaling calculations
> > itself, rather than trying to prettify the interface.
> >
> > For example: scaling memory bandwidth percentages for MPAM is a
> > nuisance because the hardware uses fixed-point values scaled by a power
> > of 2, not by 100: the two scales can never match up anywhere except at
> > multiples of 25%, leading to irregular increments when rounded to an
> > integer percentage value and uncertainty about what the bandwidth_gran
> > parameter means.  Round-trip conversions between the two
> > representations become error-prone due to repeated rounding -- this
> > proved quite fiddly to get right.  Precision beyond 1% increments may
> > also be available in the hardware, but is not accessible through the
> > resctrl interface.

Sounds like my fixed-point proposal could be useful for these memory
bandwidth values.

> Google users got annoyed with these rounding errors very quickly and
> asked me to change the MBA interface to the raw, fixed-point value
> used by the MPAM register interface. (but at least shifted down, since
> the MBW_MIN/MAX fields are left-justified)
> 
> >
> > For backwards compatibility we probably shouldn't change that
> > particular interface, but if we can avoid new instances of the same
> > kind of problem then that would be a benefit: i.e., explicitly tell
> > userspace how to scale a given parameter.
> 
> MBA is not programmed by percentage on AMD, so I'm not sure why this
> is considered necessary for backwards compatibility.

Upcoming "region aware" Intel RDT features also present challenges for
backward compatibility as there are going to be separate counters and
controls for each region. Maintaining the use of "percentage" for
controls only gives feeling of familiarity while any tools that are
using the "MB:" line in the schemata file aren't going to work at all.

Sadly, we won't have a direct "MBytes/second" interface (though our
goal is to get to that some day). H/w interface values for throttling
change from legacy 0,10,20,...90 (no throttle up to max) to 255,254...1
(max bandwidth to min).

There's also the bonus feature that memory bandwidth limits can
specify min and max values so hardware can grant jobs some amount
of extra bandwidth when the system is not busy, or throttle just
the low priority jobs when approaching capacity limits.

> -Peter

-Tony
