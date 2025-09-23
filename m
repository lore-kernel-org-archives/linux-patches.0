Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E86130C618
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 10:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758622233; cv=none; b=NCP1du0o4/ugJpq6paAsoZ2aCQyUD5P8nvqQmEjtfIzLUaOA6WlpcTk6HDb9xE8IqdD8BoPy6zJRCiRromAnTmbu0/bx/Zn6DoJ+e1ci4E3CUhr3BCVLivtk5EZTzficPHOSmeKbcWAERQAh0S5Q03/cxv9ybEafVEXiRiApoMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758622233; c=relaxed/simple;
	bh=2RIFizlSxeHsNuz2oosCGKg4PXmOdXwFy8TF8umr80k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pi7KJkRpyrOwEniJyeu21RC+fMGCIU9mC1GpjjtsA15PhWBn586kLKYz2KSx+GRHj2fC1I9NGjNwvByGDmW+DYnd5DQd7Yu8nGYe2XS3m5gOWF7+zygBToxY5wq/TKM/2/RbWWSObp4DvL9P9bEwK3AomRx6j2mdwMQZpb65q/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=S8aVDE2e; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="S8aVDE2e"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B529140E015C;
	Tue, 23 Sep 2025 10:10:21 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Go1d1ADiO-1c; Tue, 23 Sep 2025 10:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1758622217; bh=s9d0/cIPYGN2Qb2jiAt/0OLuPWlA6bUH+WUAfOGd7is=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S8aVDE2e4U30j9UeenAVn3Qm2cl8+gh18hiKeAFMWBa/1Pu9VEBffalWujR9k/bCZ
	 uPPz4eSvSPOpRTjb/qgJ7+dDI51iWh80KzhXnr3TefY4SdHHDFpZQlNCjMJppafLfp
	 Yshiqlbxi4yF2T1kLcDRflUzdGGogJ93/LUb+NxpSd/A2FGWDaRzNoR+ZwBSz2GXaQ
	 l6CW97PrSDFSH0+Tni0ufXcerM12gfy9cGXXniIvIaKntoU4th3ma7Vr+MmDVpPke9
	 rU/q24s1Wfwb5LYxARasNWkrwZbz8I/GEi9rZ1I9LDQJ/rQttHYfboUZ8tW77nWfm8
	 fzkQFsJlft1ocGGXLfua64DtyB4U8kQ+uLoVIZCjXfADH8f1A8zZPrPGWQw4uIbXTQ
	 /g19LRUS3JxnmWJjKX3Sst4pNo+TsuTxyiqWfZr53GVebKIonLSXvQtOtxLwTddkzN
	 MfmHprZRTOztMqjs1x9Hh6ophZtr6qS2G+N47SinGn+4n4HmNZ8SYz1LMNESe09b+k
	 7njwW9moSfck7Kez0AJWwrs9jOiy+x0ULp8tkZJ+Dh+X0O7cKBWB0I1XqR6ceAw/ag
	 ++I3ODeBZeUw+O0iDJKKVX2nal1IuR+S50T+7tyMQ30WE4lih4tezto+xNrvDFuvkS
	 ne2iBPtMAeabLMr3NmGDAuO8=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id E808040E0196;
	Tue, 23 Sep 2025 10:10:03 +0000 (UTC)
Date: Tue, 23 Sep 2025 12:09:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v10 02/28] x86/resctrl: Move L3 initialization into new
 helper function
Message-ID: <20250923100956.GAaNJx9BYhXKkfNJ71@fat_crate.local>
References: <20250912221053.11349-1-tony.luck@intel.com>
 <20250912221053.11349-3-tony.luck@intel.com>
 <67f34897-d5b2-4ea4-9e4b-edea86b7636c@intel.com>
 <aM2cctuXS8NBLeJ5@agluck-desk3>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aM2cctuXS8NBLeJ5@agluck-desk3>

On Fri, Sep 19, 2025 at 11:09:54AM -0700, Luck, Tony wrote:
> I understand that Boris doesn't want to see large amounts of text copied
> from the cover letter into each patch. But there is still a need to meet the
> "Describe your problem" requirement for a good commit message.
> 
> Several of the prepatory patches in this series make changes to expand the
> capabilities of fs/resctrl to handle monitor events from resources other
> than RDT_RESOURCE_L3.
> 
> Is a single short sentence repeated in several patches "too much"?

It probably isn't too much but having boilerplate code in commit messages
feels to the reader - at least to me - like: lemme jump over the boilerplate
code in order to go to the meat of the change. And then the meat of the change
is basically explaining the diff. And then I'm left scratching my head, why is
this even in my mbox.

I dunno, maybe it is just me but I end up doing that pretty often. :-\

For example, this particular commit I'd write somewhere along those lines:

"Carve out the resource monitoring domain init code into a separate helper in
order to be able to initialize new types of monitoring domains besides the
usual L3 ones."

Or so.

Short'n'sweet.

You don't explain what the code does as that should be visible from the diff
itself. You're explaining the why: "hey, I need this code into a separate
helper in order to do bla, so I'm carving it out."

That's it.

IOW, you don't necessarily have to go through the common steps of describing
the problem first, especially when you're doing preparatory, refactoring
patches.

Reading the next patch, the commit message is perfectly fine even without:

"All monitoring events are associated with the L3 resource."

Patch 4 doesn't have a boilerplate sentence and it is perfectly fine as it is.

Patch 5 you can start like this:

"Up until now, all monitoring events were associated with the L3 resource and
it made sense to use the L3 specific "struct rdt_mon_domain *" arguments to
functions manipulating domains...."

And even if you have the gist of the boilerplate, it reads better because it
is not simply slapped there mechanically.

This is not needed:

"Update kerneldoc for mon_data::sum to note that it is only used for
RDT_RESOURCE_L3."

because it is in the diff. Unless there's a reason for it to be called out in
the commit message...? And now I'm wondering why is this called out...

See what I mean?

Patch 6 I'd write like this:

"Use a generic struct rdt_domain_hdr representing a generic domain header in
struct rmid_read in order to support other telemetry events' domains besides
an L3 one. Adjust the code interacting with it to the new struct layout."

Something like that.

IOW, this is basically explaining the intention and *why* the patch is there.
No need for "for the calls from mon_event_read() via smp_call*() to
__mon_event_count() and resctrl_arch_rmid_read() and
resctrl_arch_cntr_read()." as that is functionality details. If one is really
interested, one can apply the patch and stare at it but the *why* is a lot
more important.

Dunno, this is ofc subjective but IMNSVHO, writing things this way makes it
a lot easier to review and understand the why. The what one can figure out.

And *if* one can't figure out the what because there's something non-trivial,
then by all means, call that out in the commit message.

And so on...

I hope I'm making some sense here.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
