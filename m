Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCCF27A13D
	for <patches@lists.linux.dev>; Thu,  8 May 2025 20:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746736129; cv=none; b=GPxpBilAtnV8/TqdQZE/ghCJQ5ukgjFQwMtgc6bXirInNzWna2jMumZVAMWZBwHsu6Oq/0wiyR2dHbRmkbHv1pZacImEHXNZ3S4Yj3wEwFdCCBoquD2T8OZ727UK5IXX8PGZtt/c2Lso+jRIqI3Bib66aEkUet8GbwLhZh6obb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746736129; c=relaxed/simple;
	bh=FB3CObSvNmqXo36iqoupKjaldVjHQZNvlqB3kZHu8kA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rt+aiORNPRXtx+WpHw4hgGHVARhOUnXDUorlYLf26KCpLBFNSs3g/RIO/IQfvGEb0tVaePrucZ7DbHGcvAnWZ7aql9YhttCALzH/9rDjNvLKMc10fGCMlc7bfF5O1EGmDIiFWN8Ui0lPoueCfPZU4DzjlC+mvt7tXK/IzUB2Vy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k9FVFtZ7; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k9FVFtZ7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746736127; x=1778272127;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FB3CObSvNmqXo36iqoupKjaldVjHQZNvlqB3kZHu8kA=;
  b=k9FVFtZ7QlJ1tGqqpGdlNV2FKEw8Revb6/Rk3YyHlk9OO92nG2jmMXIp
   GZ+uFVvJPTlJxKdr/+fHJ61OgYP/c/U9R3UXUXoQk0JOvG8Q60unPYQ5X
   au1NPeuI6zGugz+lGhfGvk6u4TiYn7t5OVyLZ19D+GacW9JFX4BiAr3jU
   gba16QEmg6YwRLxoyhNQTbpoMB02H4pdMiHmzOSjefyrQRYmjsU6y4l4V
   rZ8LRrmV9PaTScQLjof5XFQ82NOr1fRbAir9h1mYa4zgyjPCwd6UiMt2T
   SaS0FF4JiBnuBLglLbBr+T00P8zPojrXReM3eA0GDU3yiNGL7cUwsuYUQ
   Q==;
X-CSE-ConnectionGUID: IfgqT2LwTDiBw7REh0/idQ==
X-CSE-MsgGUID: UyO8zdQcR9GSRGjNgRxEdA==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="59205568"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="59205568"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 13:28:46 -0700
X-CSE-ConnectionGUID: puZDWQyHR1S8yrl3bdfFVA==
X-CSE-MsgGUID: GFXGe0+gTDCPu8nafAxQjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="136287083"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 13:28:47 -0700
Date: Thu, 8 May 2025 13:28:44 -0700
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
Subject: Re: [PATCH v4 13/31] fs/resctrl: Add support for additional monitor
 event display formats
Message-ID: <aB0T_Ep2lJzfwjv5@agluck-desk3>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-14-tony.luck@intel.com>
 <4aa0904d-9332-4796-90d6-d858711fc611@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4aa0904d-9332-4796-90d6-d858711fc611@intel.com>

On Thu, May 08, 2025 at 08:49:56AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> shortlog nit: "fs/resctrl: Support additional monitor event display formats"
> 
> On 4/28/25 5:33 PM, Tony Luck wrote:
> > Resctrl was written with the assumption that all monitor events
> > can be displayed as unsigned decimal integers.
> > 
> > Some telemetry events provide greater precision where architecture code
> > uses a fixed point format with 18 binary places.
> > 
> > Add a "display_format" field to struct mon_evt which can specify
> > that the value for the event be displayed as an integer for legacy
> > events, or as a floating point value with six decimal places converted
> > from the fixed point format received from architecture code.
> 
> There was no discussion on this during the previous version.
> While this version addresses the issue of architecture changing the
> format it does not address the issue of how to handle different
> architecture formats. With this change any architecture that may
> want to support any of these events will be required to translate
> whatever format it uses into the one Intel uses to be translated
> again into format for user space. Do you think this is reasonable? 
> 
> Alternatively, resctrl could add additional file that contains the
> format so that if an architecture in the future needs to present data
> differently, an interface will exist to guide userspace how to parse it.
> Creation of such user interface cannot be delayed until the time
> it is needed since then these formats would be ABI.

What if resctrl filesystem allows architecture to supply the number
of binary places for fixed point values when enabling an event?

That would allow h/w implementations to pick an appropriate precision
for each new event. Different implementations of the same event
(e.g. "core_energy") may pick different precision across architectures
or between generations of the same architecture.

File system code can then do:

	if (binary_places == 0)
		display as integer
	else
		convert to floating point (with one decimal place per
		three binary places)

Existing events are all integers and won't change (it would be weird
for an architecture to report "mbm_local_bytes" with a fixed point
rather than integer value).

New events may report in either integer or floating point format
with varying amounts of precision. But I'm not sure that would be
a burden for writing tools that can run on different architectures.

> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  include/linux/resctrl_types.h |  5 +++++
> >  fs/resctrl/internal.h         |  2 ++
> >  fs/resctrl/ctrlmondata.c      | 24 +++++++++++++++++++++++-
> >  fs/resctrl/monitor.c          | 21 ++++++++++++---------
> >  4 files changed, 42 insertions(+), 10 deletions(-)
> > 
> > diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
> > index 5ef14a24008c..6245034f6c76 100644
> > --- a/include/linux/resctrl_types.h
> > +++ b/include/linux/resctrl_types.h
> 
> This needs to be internal to resctrl fs.
> resctrl_types.h should only contain the types required in asm/resctrl.h
> 
> > @@ -50,4 +50,9 @@ enum resctrl_event_id {
> >  #define QOS_NUM_MBM_EVENTS	(QOS_L3_MBM_LOCAL_EVENT_ID - QOS_L3_MBM_TOTAL_EVENT_ID + 1)
> >  #define MBM_EVENT_IDX(evt)	((evt) - QOS_L3_MBM_TOTAL_EVENT_ID)
> >  
> > +/* Event value display formats */
> 
> Please add details about what each format means (how it should
> be interpreted).
> 
> Reinette

-Tony
