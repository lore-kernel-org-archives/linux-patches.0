Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D246201034
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 22:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752014607; cv=none; b=sL+5yOytcr1wGpwaaPeu3PNnrBGrdyrJ1ctqNzJnykAdch1HXcEiaINef3GZq8WMhQUR9iCeeoCx4XuQ9+2K6lAw0PnZczT1/fP8M1QDO+QLAyIiktbM/WSSmHyQN9ITluEHKk1QpZIWnzUeENOu6NRoMXKDJf/Sr+bxWMARE0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752014607; c=relaxed/simple;
	bh=hew1ePhykAjsI9To26HnWi16u2zQDoYS797i5P3C8eM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ba6/T8e5ErfATuF+0Lk429OlBY4gP11GTckOLwuhZs5AO2gTuZuC1Sxz+FhKGxiDKns4SW7QyR16m7zERc3hmv5XiwTIzXYFtMko8ph4CKN+AmQkyEAYKkWG2XyRuN9ZiQh9rLaoKYwGz5vw/HETkSf3RE5uTZwngl5hzaTVUwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NxXW/FgY; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NxXW/FgY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752014605; x=1783550605;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hew1ePhykAjsI9To26HnWi16u2zQDoYS797i5P3C8eM=;
  b=NxXW/FgYtNlzeAZTGezPJR+Qhj21K+kMDh9K5xYj9eWEw+dNBIoyjQDm
   UCRDF0lyGx7hDXJrvx2dhXua3Cgs2rYfxhJfkEjXjpfaqBZcMkNwyQpYb
   pgbCOjiVJGExrVMJZRxJXANr+Sren1W3zw1Ev1Dn81K3p5qCpRUypKD7r
   rYxpMkmDqtZmA6E/m7Ugn4BRsDEeIXsj9W/UHUh9QBWaGyBTuuqlvhI3c
   B6mK5UdYG9n9hZzhyDADRPHUJoDOljrQ1BHUsM/IN3q4D5SbjoLRoAMxj
   6ICJkjWw3Z+2bKTkWiG4yYCq5Q7XSu7amAU+hGUagVOy12Sn/H2iQs55Y
   w==;
X-CSE-ConnectionGUID: gbLP7yeKRAuKSDPSmDGZ9w==
X-CSE-MsgGUID: xLhlrbIoTgOm1lk/Rt5ynQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="56875335"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="56875335"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 15:43:22 -0700
X-CSE-ConnectionGUID: Cm6LicrfSzKZvcKCmdTGBg==
X-CSE-MsgGUID: vdvIkTZ6RtmZfUDS1oOc3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="155731793"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 15:43:20 -0700
Date: Tue, 8 Jul 2025 15:43:18 -0700
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
Message-ID: <aG2fBp5VojStKcCd@agluck-desk3>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <b2de4c92-a883-40b0-92e0-16fac9e386b0@intel.com>
 <aGa8Pg9pSCJ3XjtY@agluck-desk3>
 <aG1sqKBJSfHydDsx@agluck-desk3>
 <5b2d621f-459f-463e-abc6-9157513f1fee@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b2d621f-459f-463e-abc6-9157513f1fee@intel.com>

On Tue, Jul 08, 2025 at 01:49:26PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/8/25 12:08 PM, Luck, Tony wrote:
> > On Thu, Jul 03, 2025 at 10:22:06AM -0700, Luck, Tony wrote:
> >> On Thu, Jul 03, 2025 at 09:45:15AM -0700, Reinette Chatre wrote:
> >>> Hi Tony and Dave,
> >>>
> >>> On 6/26/25 9:49 AM, Tony Luck wrote:
> >>>>  --- 14 ---
> >>>> Add mon_evt::is_floating_point set by resctrl file system code to limit
> >>>> which events architecture code can request be displayed in floating point.
> >>>>
> >>>> Simplified the fixed-point to floating point algorithm. Reinette is
> >>>> correct that the additional "lshift" and "rshift" operations are not
> >>>> required. All that is needed is to multiply the fixed point fractional
> >>>> part by 10**decimal_places, add a rounding amount equivalent to a "1"
> >>>> in the binary place after those supplied. Finally divide by 2**binary_places
> >>>> (with a right shift).
> >>>>
> >>>> Explained in commit comment how I chose the number of decimal places to
> >>>> use for each binary places value.
> >>>>
> >>>> N.B. Dave Martin expressed an opinion that the kernel should not do
> >>>> this conversion. Instead it should enumerate the scaling factor for
> >>>> each event where hardware reported a fixed point value. This patch
> >>>> could be dropped and replaced with one to enumerate scaling factors
> >>>> per event if others agree with Dave.
> >>>
> >>> Could resctrl accommodate both usages? For example, it does not
> >>> look too invasive to add a second file <mon_evt::name>.raw for the
> >>> mon_evt::is_floating_point events that can output something like Dave
> >>> suggested in [1]:
> >>>
> >>> .raw file format could be:
> >>> 	#format:<output that depends on format>
> >>> 	#fixed-point:<value>/<scaling factor>
> >>>
> >>> Example output:
> >>> 	fixed-point:0x60000/0x40000
> >>
> >> Dave: Is that what you want in the ".raw" file? An alternative would be
> >> to put the format information for non-integer events into an
> >> "info" file ("info/{RESOURCE_NAME}_MON/monfeatures.raw.formats"?)
> >> and just put the raw value into the ".raw" file under mon_data.
> > 
> > Note that I thought it easier for users to keep the raw file to just
> > showing a value, rather than including the formatting details in
> > Reinette's proposal.
> 
> Could you please elaborate what makes this easier? It is not obvious to me
> how it is easier for user to open, parse, and close two files rather than one.
> (more below)

I had only considered the case where the format does not change while
the resctrl file system is mounted. So users would read the "info" file
to get the scaling factor once, and then read the event files with a
parser that only has to convert a numerical string.

> > Patch to implement my alternative suggestion below. To the user things
> > look like this:
> > 
> > $ cd /sys/fs/resctrl/mon_data/mon_PERF_PKG_01
> > $ cat core_energy
> > 0.02203
> > $ cat core_energy.raw
> > 5775
> > $ cat /sys/fs/resctrl/info/PERF_PKG_MON/mon_features_raw_scale
> > core_energy 262144
> > activity 262144
> > $ bc -ql
> > 5775 / 262144
> > .02202987670898437500
> > 
> > If this seems useful I can write up a commit message and include
> > as its own patch in v7. Suggestions for better names?
> > 
> 
> I expect users to regularly interact with the monitoring files. For example,
> "read the core_energy of group x every second". An API like above would require
> a contract that the scale value will never change from resctrl mount to
> resctrl unmount. I understand that this implementation supports exactly this by
> allowing an architecture to only enable an event once, but do you think this is
> something that will always be the case? If not then an interface like above will
> require user space to open, parse, close two files instead of one on a frequent basis.
> This is not ideal if user space wants to read monitoring data of multiple
> groups frequently.

While hardware designers do some outlandish things. Changing the format
of an event counter on the fly seems beyond the range of possibility.
How would that even work? A driver would have to rerun enumeration of
the feature every time it read a counter. Or hardware would have to
supply some interrupt to tell s/w that the format changed.

I think it reasonable that resctrl be able to guarantee that the format
described in the info file is valid for the life of the mount.

> I would also like to keep extensibility in mind. We now know that
> unsigned decimal and fixed-point binary needs to be supported. I think any
> new interface used to communicate formatting information to user space should be done
> in a way that can be extended for a new format. That is, for example, why
> I used the actual term "fixed-point" in the example. Something like this avoids
> needing assumptions that a raw value always implies fixed-point format.

This is fair. But could be covered in the "info" file with some more
descriptive way to describe the format. Perhaps:

$ cat /sys/fs/resctrl/info/PERF_PKG_MON/mon_features_raw_scale
core_energy fixed-point scale=262144
activity fixed-point scale=262144

To allow for other types in the future.

> 
> Reinette

-Tony
