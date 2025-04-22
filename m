Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF1E28F527
	for <patches@lists.linux.dev>; Tue, 22 Apr 2025 16:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745338848; cv=none; b=EihArAcTYWCzGkcwxYg0/aJvH14YjSREAtCBQ3CzuszQ+P3AmCw5Mqpcg0DFyEhAsdCtbS/l/BM844aXorEWu1iveKpKnis+6e9KUbu3oA+Pl1zNKeHPbUAlG5rFTRTO9toD4YoK3Q6E2eEtUWKxDKtzc2IyGXSxkYwNBoa8UOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745338848; c=relaxed/simple;
	bh=nJXm0UWQx6UUywX4WEE0ifqwdFMnxUNPraCKLqa+S4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IQJaGX9KkZkVR70JL6TFK4JfuzQWVGGTweXSM/u+eCihcXdd0lD7T9MgHaqexEUmoE6s77oFpW6hWhPsnf313DyPA772ylmo4GxM5J43p0lbUGRTqOLAR2aowQu7kP0aqX9u6XeIjDRddC0ej+KOFDQ5wKshIrhbedb9NNs/cpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QmeaqQIZ; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QmeaqQIZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745338846; x=1776874846;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nJXm0UWQx6UUywX4WEE0ifqwdFMnxUNPraCKLqa+S4U=;
  b=QmeaqQIZA3CmfBijNxZwhDaeCuOa79QNfl11jIULUPfiZZtnQJSrYH1u
   WQNxuyV5lysMlE2EzgWE4HCdYdeGL2EYksPCGXLSVipfLsNp/VCtNACYJ
   WIRexui78HShqZWgxGlmyOsibyQTkGS6popEZvud07yU15i30qOO6imrY
   +8dT/lcCOf2lfcy3FY8eV2/eXvym2T+D03eJ4Iv3R+3XbglT2w4YOXy+O
   310pJtUgwdqueHHkDlOT8rR7TJ6G8dloLYAT5/NpJsWxxm+S0oNIpZp+2
   9usm8SGiXMBijmQBEVr6uJ2f4Y4h+ElRd4wU+njwfvrcVwaTI11vQDOcE
   Q==;
X-CSE-ConnectionGUID: tbcix8Q2QxqLTNTNaNn50w==
X-CSE-MsgGUID: gTq9cnMTR1OJ2HOKlIOUKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="46609651"
X-IronPort-AV: E=Sophos;i="6.15,231,1739865600"; 
   d="scan'208";a="46609651"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 09:20:46 -0700
X-CSE-ConnectionGUID: DW0UyFIhQMSpDelBOalk1Q==
X-CSE-MsgGUID: aAu202lHTvOwDAIUm3CA6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,231,1739865600"; 
   d="scan'208";a="132006314"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 09:20:45 -0700
Date: Tue, 22 Apr 2025 09:20:43 -0700
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
Message-ID: <aAfB29E8Shqp8JY3@agluck-desk3>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <53dcb55c-f5b6-4cb8-96b6-07aa1ba1d4d4@intel.com>
 <aAaVH4W72fOzQhnh@agluck-desk3>
 <ccb33985-e1d8-449e-b39e-3fccb5fc0783@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccb33985-e1d8-449e-b39e-3fccb5fc0783@intel.com>

On Mon, Apr 21, 2025 at 03:59:15PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 4/21/25 11:57 AM, Luck, Tony wrote:
> > On Fri, Apr 18, 2025 at 02:13:39PM -0700, Reinette Chatre wrote:
> >> One aspect that is only hinted to in the final documentation patch is
> >> how users are expected to use this feature. As I understand the number of
> >> monitor groups supported by resctrl is still guided by the number of RMIDs
> >> supported by L3 monitoring. This work hints that the telemetry feature may
> >> not match that number of RMIDs and a monitor group may thus exist but
> >> when a user attempts to ready any of these perf files it will return
> >> "unavailable".
> >>
> >> The series attempts to address it by placing the number of RMIDs available
> >> for this feature in a "num_rmids" file, but since the RMID assigned to a monitor
> >> group is not exposed to user space (unless debugging enabled) the user does
> >> not know if a monitor group will support this feature or not. This seems awkward
> >> to me. Why not limit the number of monitor groups that can be created to the
> >> minimum number of RMIDs across these resources like what is done for CLOSid?
> > 
> > Reinette,
> > 
> > The mismatch between number of RMIDs supported by different components
> > is a thorny one, and may keep repeating since it feels like systems are
> > composed of a bunch of lego-like bricks snapped together from a box of
> > parts available to the h/w architect.
> 
> With resctrl needing to support multiple architectures' way of doing things,
> needing to support variety within an architecture just seems like another step.
> 
> > 
> > In this case we have three meanings for "number of RMIDs":
> > 
> > 1) The number for legacy features enumerated by CPUID leaf 0xF.
> > 
> > 2) The number of registers in MMIO space for each event. This is
> > enumerated in the XML files and is the value I placed into telem_entry::num_rmids.
> > 
> > 3) The number of "h/w counters" (this isn't a strictly accurate
> > description of how things work, but serves as a useful analogy that
> > does describe the limitations) feeding to those MMIO registers. This is
> > enumerated in telemetry_region::num_rmids returned from the call to
> > intel_pmt_get_regions_by_feature()
> 
> Thank you for explaining this. This was not clear to me.
> 
> > 
> > If "1" is the smallest of these values, the OS will be limited in
> > which values can be written to the IA32_PQR_ASSOC MSR. Existing
> > code will do the right thing by limiting RMID allocation to this
> > value.
> > 
> > If "2" is greater than "1", then the extra MMIO registers will
> > sit unused.
> 
> This is also an issue with this implementation, no? resctrl will not
> allow creating more monitor groups than "1".

On Intel there is no point in creating more groups than "1" allows.
You can't make use of any RMID above that limit because you will get
a #GP fault trying to write to the IA32_PQR_ASSOC MSR.

You could read the extra MMIO registers provided by "2", but they
will always be zero since no execution occurred with an RMID in the
range "1" ... "2".

The "2" is greater than "1" may be relatively common since the h/w
for the telemetry counters is common for SKUs with different numbers
of cores, and thus different values of "1". So low core count
systems will see more telemetry counters than they can actually
make use of. I will make sure not to print a message for this case.

> > If "2" is less than "1" my v3 returns the (problematic) -ENOENT
> > This can't happen in the CPU that debuts this feature, but the check
> > is there to prevent running past the end of the MMIO space in case
> > this does occur some day. I'll fix error path in next version to
> > make sure this end up with "Unavailable".
> 
> This is a concern since this means the interface becomes a "try and see"
> for user space. As I understand a later statement the idea is that
> "2" should be used by user space to know how many "mon_groups" directories
> should be created to get telemetry support. To me this looks to be
> a space that will create a lot of confusion. The moment user space
> creates "2" + 1 "mon_groups" directories it becomes a guessing game
> of what any new monitor group actually supports. After crossing that
> threshold I do not see a good way for going back since if user space
> removes one "mon_data" directory it does get back to "2" but then needs to
> rely on resctrl internals or debugging to know for sure what the new
> monitor group supports.

But I assert that it is a "can't happen" concern. "2" will be >= "1".
See below. I will look at addressing this, unless it gets crazy complex
because of the different enumeration timeline. Delaying calculation of
number of RMIDs until rdt_get_tree() as you have suggested may be the
right thing to do.

"3" is the real problem

> > 
> > If "3" is less than "2" then the system will attach "h/w counters" to
> > MMIO registers in a "most recently used" algorithm. So if the number
> > of active RMIDs in some time interval is less than "3" the user will
> > get good values. But if the number of active RMIDs rises above "3"
> > then the user will see "Unavailable" returns as "h/w counters" are
> > reassigned to different RMIDs (making the feature really hard to use).
> 
> Could the next step be for the architecture to allow user space to
> specify which hardware counters need to be assigned? With a new user
> interface being created for such capability it may be worthwhile to
> consider how it could be used/adapted for this feature. [1]
> 
> > 
> > In the debut CPU the "energy" feature has sufficient "energy" counters
> > to avoid this. But not enough "perf" counters. I've pushed and the
> > next CPU with the feature will have enough "h/w counters".
> > 
> > My proposal for v4:
> > 
> > Add new options to the "rdt=" kernel boot parameter for "energy"
> > and "perf".
> > 
> > Treat the case where there are not enough "h/w counters" as an erratum
> > and do not enable the feature. User can override with "rdt=perf"
> > if they want the counters for some special case where they limit
> > the number of simultaneous active RMIDs.
> 
> This only seems to address the "3" is less than "2" issue. It is not
> so obvious to me that it should be treated as an erratum. Although,
> I could not tell from your description how obvious this issue will be
> to user space. For example, is it clear that if user space
> gets *any* value then it is "good" and "Unavailable" means ... "Unavailable", or
> could a returned value mean "this is partial data that was collected
> during timeframe with hardware counter re-assigned at some point"?

When running jobs with more distinct RMIDs than "3" users are at the
mercy of the h/w replacement algorithm. Resctrl use cases for monitoring
are all "read an event counter; wait for some time; re-read the event
counter; compute the rate". With "h/w counter" reassignment the second
read may get "Unavailable", or worse the "h/w counter" may have been
taken, and the returned so a value will be provided to the user, but
it won't provide the count of events since the first read.

That's why I consider this an erratum. There's just false hope that
you can get a pair of meaningful event counts and no sure indication
that you didn't get garbage.

> > 
> > User can use "rdt=!energy,!perf" if they don't want to see the
> > clutter of all the new files in each mon_data directory.
> > 
> > I'll maybe look at moving resctrl_mon_resource_init() to rdt_get_tree()
> > and add a "take min of all RMID limits". But since this is a "can't
> > happen" scenario I may skip this if it starts to get complicated.
> 
> I do not think that the "2" is less than "1" scenario should be 
> ignored for reasons stated above and in review of this version.
> 
> What if we enhance resctrl's RMID assignment (setting aside for
> a moment PMG assignment) to be directed by user space?

I'll take a look at reducing user reported num_rmids to the minimum
of the "1" and "2" values.

> Below is an idea of an interface that can give user space 
> control over what monitor groups are monitoring. This is very likely not
> the ideal interface but I would like to present it as a start for
> better ideas.
> 
> For example, monitor groups are by default created with most abundant
> (and thus supporting fewest features on fewest resources) RMID.
> The user is then presented with a new file (within each monitor group)
> that lists all available features and which one(s) are active. For example,
> let's consider hypothetical example where PERF_PKG perf has x RMID, PERF_PKG energy
> has y RMID, and L3_MON has z RMID, with x < y < z. By default when user space
> creates a monitor group resctrl will pick "abundant" RMID from range y + 1 to z
> that only supports L3 monitoring:

There is no way for s/w to control the reallocation of "h/w counters"
when "3" is too small. So there is no set of RMIDs that support many
events vs. fewer events. AMD is solving this similar problem with their
scheme to pin h/w counters to specific RMIDs. I discussed such an option
for the "3" case, but it wasn't practical to apply to the upcoming CPU
that has this problem. The long term solution is to ensure that "3" is
always large enough that all RMIDs have equal monitoring capabilities.

> # cat /sys/fs/resctrl/mon_groups/m1/new_file_mon_resource_and_features
> [L3]
> PERF_PKG:energy
> PERF_PKG:perf
> 
> In above case there will be *no* mon_PERF_PKG_XX directories in 
> /sys/fs/resctrl/mon_groups/m1/mon_data.
> 
> *If* user space wants perf/energy telemetry for this monitor
> group then they can enable needed feature with clear understanding that
> it is disruptive to all ongoing monitoring since a new RMID will be assigned.
> For example, if user wants PERF_PKG:energy and PERF_PKG:perf then
> user can do so with:
> 
> # echo PERF_PKG:perf > /sys/fs/resctrl/mon_groups/m1/new_file_mon_resource_and_features
> # cat /sys/fs/resctrl/mon_groups/m1/new_file_mon_resource_and_features
> [L3]
> [PERF_PKG:energy]
> [PERF_PKG:perf]
> 
> After the above all energy and perf files will appear in new mon_PERF_PKG_XX
> directories.
> 
> User space can then have full control of what is monitored by which monitoring
> group. If no RMIDs are available in a particular pool then user space can get
> an "out of space" error and be the one to decide how it should be managed.
> 
> This also could be a way in which the "2" is larger than "1" scenario
> can be addressed. 
> 
> > Which leaves what should be in info/PERF_PKG_MON/num_rmids? It's
> > possible that some CPU implementation will have different MMIO
> > register counts for "perf" and "energy". It's more than possible
> > that number of "h/w counters" will be different. But they share the
> > same info file. My v3 code reports the minimum of the number
> > of "h/w counters" which is the most conservative option. It tells
> > the user not to make more mon_data directories than this if they
> > want usable counters across *both* perf and energy. Though they
> > will actually keep getting good "energy" results even if then
> > go past this limit.
> 
> num_rmids is a source of complications. It does not have a good equivalent
> for MPAM and there has been a few attempts at proposing alternatives that may
> be worth keeping in mind while making changes here:
> https://lore.kernel.org/all/cbe665c2-fe83-e446-1696-7115c0f9fd76@arm.com/
> https://lore.kernel.org/lkml/46767ca7-1f1b-48e8-8ce6-be4b00d129f9@intel.com/
> 
> > 
> > -Tony
> > 
> 
> Reinette
> 
> 
> [1] https://lore.kernel.org/lkml/cover.1743725907.git.babu.moger@amd.com/
> 
> ps. I needed to go back an re-read the original cover-letter a couple of
> times, while doing so I noticed one typo in the Background section: OOMMSM -> OOBMSM.

Noted. Will fix.

-Tony
