Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557582147E8
	for <patches@lists.linux.dev>; Mon, 31 Mar 2025 22:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743460926; cv=none; b=Gd78A1M5o8kxIldnom+ODE6fgvdZoU8adLqu52DXfXtO8DMmtrfYlkAE7YwgnC5kcbwhY0dGO135y0V49rMKfa06hy25K9kOBwaAVAktPp5oXEDbnexJ6sPmI4Q5MQTOplDyFy1wun2dMOoPxr++mp10Y+Tfh3EUgq80g5+7h8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743460926; c=relaxed/simple;
	bh=1THhMP195YYDmMD2h5H3KfvN8N3O3voYonfAzP+gNkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WFI29BArqDGb6b3xa7iui4I8lauXkLK1hQduZ4hpkjQzqXIU0Rix2DPhyFdBiuV2MUrFeNF6qFMfOVJRdfPs6wK3fFfHkwkIDACR5oN6hOHf1eX2XVhjv9hGXp4ZUdR+MpUdGq2wReh3GsYvG2Si2Hk/j9ubxcJSweyrzvu9Rbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZxZ2w1J3; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZxZ2w1J3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743460926; x=1774996926;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1THhMP195YYDmMD2h5H3KfvN8N3O3voYonfAzP+gNkA=;
  b=ZxZ2w1J3diLT6dUIL1vZEwRrk+jmYj15Ywpm7WSWXVIc7KEwZNutNsrc
   4vx10QwQ1vu/JRbZq/FX38ooZkwnBE+WW2gQLjc88y7JVg7oo4Kri7Rll
   8khcO07gaNa2k+xIpWUWJ6b3Tb+jaI4Zm5CdG07yLtZ8cQFbd0ofCuZ+z
   TfGKLyzxCGf5caxNdIlRxJ6/YbpmLydun1pX4RDAoCeK+XO00B4C1G4Ow
   g4U/2jmTsGZMvr0iny+e10sRLW6I3ZA2DxA5J8OXYUYzwZISUfHD0v3+f
   YIQ1GFRViAv0r49NaNyBWigAU2OoTKkEX1XKbZT7XTtxRmPu6B3b6hAA1
   Q==;
X-CSE-ConnectionGUID: 4aiYJ7QkQBu730MKWFVz/g==
X-CSE-MsgGUID: YAoVQqZeREateKCTOVldPg==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="70127531"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="70127531"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 15:42:05 -0700
X-CSE-ConnectionGUID: Blfg9Kj6TLq8B9bkheorxQ==
X-CSE-MsgGUID: IwzK/hHgRZS9pIjtkfB9Tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="126729615"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 15:42:04 -0700
Date: Mon, 31 Mar 2025 15:42:02 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 13/16] x86/resctrl: Add code to display core telemetry
 events
Message-ID: <Z-saOq25hb8sPV7r@agluck-desk3>
References: <20250321231609.57418-1-tony.luck@intel.com>
 <20250321231609.57418-14-tony.luck@intel.com>
 <bb1ceb6c-e855-41c6-b15b-cf3eeafd7da8@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb1ceb6c-e855-41c6-b15b-cf3eeafd7da8@intel.com>

On Mon, Mar 31, 2025 at 09:23:48AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> (nit: "Add code to" can be dropped from shortlog)
> 
> On 3/21/25 4:16 PM, Tony Luck wrote:
> > These can be read from any CPU. Rely on the smp_call*() functions
> > picking the current CPU when given a free choice from cpu_online_mask.
> > 
> > There may be multiple devices tracking each package, so scan all of them
> > and add up counters.
> > 
> > Output format depends on the data type. Either a 63 bit integer, or a
> > fixed point decimal.
> > 
> 
> At this point the architecture and fs code is very intertwined. I hope that
> some of the items I mentioned in earlier patches will help to support a clear
> separation that will make the code that follows from here on easier to split
> between arch and fs. 
> For example, I think this may end up with the new event enums defined in
> include/linux/resctrl_types.h to support new architectural helpers
> that take the enum as argument that the fs code can use to request the
> event value from the architecture. 

I have a solution for the separtion for this. Each mon_evt structure
gets two new fields.

The first is "bool any_cpu;" if this is set to true the event can
be read from any CPU (and we can use James suggestion to pick from
"online_cpu_mask" instead of "d->hdr.cpu_mask" and let the optimizations
in smp_call*() avoid the IPI.

The second is a "enum format" field that specifies how to display the
value returned to FS code from architecture. Existing events all
print as a decimal number. I need to add the binary fixed point with
18 binary places to be printed as a floating point number.

Note that this solution needs to copy these fields from the
mon_evt structure to the mon_data_bits union (this is easier
if James' pending patch to convert to a mon_data structure removes the
restriction that all fields fit into 32-bits).
> 
> Reinette

-Tony
