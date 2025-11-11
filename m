Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5167A328244
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 17:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762882495; cv=none; b=iRYu8nBlb2APjmKBlcDVeC5AjGTrSMD+6N1YdU9Gbu5sIrxEhMqdeA8Yq7luaPs3BxX+V7ITEKgNty9uqFiqK/Yknoyrwabic18RzucsfNo4u2SkK9ZGpQWWHfu5hfN3DzD2VWhJxt4+sic68VRJrujrZqd9ir7aFcnosqHAWgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762882495; c=relaxed/simple;
	bh=lRtd39TzVsOLDLM6mhyvwF9cxQ9l1wDoC0v6x7Tl4VM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TqcQiQJknNx4/y6iyGhjbwzcjP1TUqcf3ZNfGTMIZJCHZkOKOyUZ8AR+qKBhS49C+tfhAdJJnZBja8MgOrLAkR5bSNvYdJalYoOZ/rx0sE1u6fE7ftHBq921uOM+DKccGRAhHgXK7KxfKvKl3Bd7mrUK//zleEfjtPxhUTPfQ1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EBB0C497;
	Tue, 11 Nov 2025 09:34:45 -0800 (PST)
Received: from e133380.arm.com (e133380.arm.com [10.1.197.68])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9ADBD3F5A1;
	Tue, 11 Nov 2025 09:34:51 -0800 (PST)
Date: Tue, 11 Nov 2025 17:34:48 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>, Chen Yu <yu.c.chen@intel.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v13 12/32] x86,fs/resctrl: Support binary fixed point
 event counters
Message-ID: <aRNzuMtoBT90CEAs@e133380.arm.com>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-13-tony.luck@intel.com>
 <aQtiSmZ14b+U/J4U@e133380.arm.com>
 <aRIYZOm6ZtpQFr4m@agluck-desk3>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRIYZOm6ZtpQFr4m@agluck-desk3>

Hi Tony,

On Mon, Nov 10, 2025 at 08:52:52AM -0800, Luck, Tony wrote:
> On Wed, Nov 05, 2025 at 02:42:18PM +0000, Dave Martin wrote:
> > > +static void print_event_value(struct seq_file *m, unsigned int binary_bits, u64 val)
> > > +{
> > > +	unsigned long long frac;
> > > +	char buf[10];
> > 
> > In place of the magic number 10, how about
> > decplaces[MAX_BINARY_BITS] + 1 ?
> > 
> > (I think the compiler should accept that as an initialiser if the array
> > is const.)
> 
> The compiler (gcc 15.2.1) accepts without any warnings. But generates
> different code.
> 
> sparse complains:
> fs/resctrl/ctrlmondata.c:640:45: warning: Variable length array is used.

Hmmm.  Shame.

(Of course, this is only a warning.  sparse may not know how to
determine that the resulting buffer is limited to a sane size, but
looking at the code makes it pretty obvious.  Perhaps best avoided,
though.)

> I may change the hard coded constant to 21 (guaranteed to be big enough
> for a "long long" plus terminating NUL byte.)

I guess.  We may be able to sidestep this, though (see my other reply
about getting rid of buf[] altogether.)

Cheers
---Dave
