Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE23C221261
	for <patches@lists.linux.dev>; Fri,  9 May 2025 11:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746790180; cv=none; b=pIhGcX5dd/T638D/Q+QbivjjJYWLjHUwky/9z2rbMeFR8tbpXLpaG+QVsVW10rpWAulM0MkHmiFRB8CSqT6/UY6oS03VRR3tCJ3J81ClEeEJHKvBkDLlhtrx8R7LfJ3jPfQgJWI4AUNbJ5tjJDr9bMfE/UcauiFjURspMZcwInI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746790180; c=relaxed/simple;
	bh=mupdWM95kpiTxu8Y1ChYWah5iJPDALut4pvXu7JfoUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jM89ou3xRr5YrUZOocHpXlbPxqaK26aiZ9BiF9LaFewbVSP2qp8PGrH1jMa7hdVfq/zs+H43WaG0o7b5WtZsdxOk6fFg5HymLXSNxL0i9/AXeTANF6Vp8Jnv4FxkGH4RRUYtHK9r6r7qAbFpNpC12tDiR2CkU142SMaLWfLjr6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F2B541595;
	Fri,  9 May 2025 04:29:26 -0700 (PDT)
Received: from e133380.arm.com (e133380.arm.com [10.1.197.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C0E623F58B;
	Fri,  9 May 2025 04:29:35 -0700 (PDT)
Date: Fri, 9 May 2025 12:29:28 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v4 13/31] fs/resctrl: Add support for additional monitor
 event display formats
Message-ID: <aB3nGDzW6pNNkYTB@e133380.arm.com>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-14-tony.luck@intel.com>
 <4aa0904d-9332-4796-90d6-d858711fc611@intel.com>
 <aB0T_Ep2lJzfwjv5@agluck-desk3>
 <2a19f63a-f9b4-4632-bca2-2f64f6fed57b@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a19f63a-f9b4-4632-bca2-2f64f6fed57b@intel.com>

Hi,

(Backtrace retained for context -- see my comment at the end.)

Cheers
---Dave

[...]

On Thu, May 08, 2025 at 04:45:21PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/8/25 1:28 PM, Luck, Tony wrote:
> > On Thu, May 08, 2025 at 08:49:56AM -0700, Reinette Chatre wrote:
> >> On 4/28/25 5:33 PM, Tony Luck wrote:
> >>> Resctrl was written with the assumption that all monitor events
> >>> can be displayed as unsigned decimal integers.
> >>>
> >>> Some telemetry events provide greater precision where architecture code
> >>> uses a fixed point format with 18 binary places.
> >>>
> >>> Add a "display_format" field to struct mon_evt which can specify
> >>> that the value for the event be displayed as an integer for legacy
> >>> events, or as a floating point value with six decimal places converted
> >>> from the fixed point format received from architecture code.
> >>
> >> There was no discussion on this during the previous version.
> >> While this version addresses the issue of architecture changing the
> >> format it does not address the issue of how to handle different
> >> architecture formats. With this change any architecture that may
> >> want to support any of these events will be required to translate
> >> whatever format it uses into the one Intel uses to be translated
> >> again into format for user space. Do you think this is reasonable? 
> >>
> >> Alternatively, resctrl could add additional file that contains the
> >> format so that if an architecture in the future needs to present data
> >> differently, an interface will exist to guide userspace how to parse it.
> >> Creation of such user interface cannot be delayed until the time
> >> it is needed since then these formats would be ABI.
> > 
> > What if resctrl filesystem allows architecture to supply the number
> > of binary places for fixed point values when enabling an event?
> 
> This sounds good. I do not think we are in a position to come up with
> an ideal solution. That would require assumptions of what another
> architecture may or may not do and thus we do not have complete information.
> 
> > 
> > That would allow h/w implementations to pick an appropriate precision
> > for each new event. Different implementations of the same event
> > (e.g. "core_energy") may pick different precision across architectures
> > or between generations of the same architecture.
> > 
> > File system code can then do:
> > 
> > 	if (binary_places == 0)
> > 		display as integer
> > 	else
> > 		convert to floating point (with one decimal place per
> > 		three binary places)
> 
> I do not think this problem needs to be solved in this work but there needs
> to be a plan for how other architectures can be supported. When similar
> enabling needs to be done for that hypothetical architecture then it can
> be implemented ... if it is still valid based on what that architecture actually
> supports.
> It may be sufficient for the "plan" (as above) to be in comments.
> 
> > 
> > Existing events are all integers and won't change (it would be weird
> > for an architecture to report "mbm_local_bytes" with a fixed point
> > rather than integer value).
> > 
> > New events may report in either integer or floating point format
> > with varying amounts of precision. But I'm not sure that would be
> 
> Partly this will depend on the unit of measurement that should form part of
> the definition of the event. For example, events reporting cycles or ticks
> should only be integer, no?
> 
> > a burden for writing tools that can run on different architectures.
> 
> Maybe just a comment in the docs then ... and now I see that you did
> so already. My apologies, I did not get to the last four patches.
> 
> Reinette

Just a thought, but I think that while it's not possible to be fully
generic, a parameter model along the lines of

	quantity = raw_value * ((double)multiplier / divisor) * BASE_UNIT

would cover most things that we have or can reasonably foresee,
including memory bandwidth control values.
raw_value, multiplier and divisor would all be integers.

Since raw_integer can be the value used by the hardware, its precision
can probably be fixed at 1, though we could still report it explicitly.

Fundamental base units would be things like "byte", "bytes per second"
and "none" (i.e., dimensionless quantities).  (Are there others?)


Since we cannot guess for certain what userspace wants to do with the
values, it feels better to let userspace do any scaling calculations
itself, rather than trying to prettify the interface.

For example: scaling memory bandwidth percentages for MPAM is a
nuisance because the hardware uses fixed-point values scaled by a power
of 2, not by 100: the two scales can never match up anywhere except at
multiples of 25%, leading to irregular increments when rounded to an
integer percentage value and uncertainty about what the bandwidth_gran
parameter means.  Round-trip conversions between the two
representations become error-prone due to repeated rounding -- this
proved quite fiddly to get right.  Precision beyond 1% increments may
also be available in the hardware, but is not accessible through the
resctrl interface.

For backwards compatibility we probably shouldn't change that
particular interface, but if we can avoid new instances of the same
kind of problem then that would be a benefit: i.e., explicitly tell
userspace how to scale a given parameter.

Cheers
---Dave
