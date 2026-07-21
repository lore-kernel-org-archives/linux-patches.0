Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5131F3B7B97
	for <patches@lists.linux.dev>; Tue, 21 Jul 2026 23:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784675738; cv=none; b=Tcx+4OTNom18lzDEp7UC3Iy6hJ+xWRUViKgM6GyRmClL4DfrDpCwavam3ZceDz1GyDx49R7en45xzxFYymve93R+4kuz1dkLV1FZ2G2ZzFfM7jOCBi3zo5UJVg2ATlnUUAN4Q9YGWfq4phOmJBJkzZ2l7c9h3e5stZtGhiRNePA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784675738; c=relaxed/simple;
	bh=y2UVFUxvy2L9aIkUM6mMxH7oE+Puamsfkx8pg0jYhns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W2D64iyp1orwvP9RJvMNIsNESUEwh6lowR+BgWRIlrVH5HzODq8ye3H8G7F7FfTwa66qX1gVuGvr/3wjUe/TFAm0sZncsJic7S1AKH5MmauXCl0ulp9njvXWJMGOejBZdSDibFW9jV5PVSFLiEOWxZJBC76k3c4VwGALvXYhpX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Volllrk7; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Volllrk7"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C9DE040E014C;
	Tue, 21 Jul 2026 23:15:33 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Z1o9V2myMvNs; Tue, 21 Jul 2026 23:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784675723; bh=7C9wZZCXayvCebsEvJpttlEJY0Ks91HF7m5xE3Iw4Ik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Volllrk7auzrXsRF9csOSnAMTFYt3OrFW3mkOcxfkNjEOXNJ1PyBJJiMrrgLG3ioV
	 3dGEA5EfxzQGyjt6amGdnVLBe8OlJcntiDUcp2aB6VN/2ztz5bHo+xvSkkwANcSBRv
	 lECJgcN3LUb2FqblR/Y4i4vR3m9uZniWlx3zdVeJ3bz5GDpY+Yt8CEvVo/F1tnTIrU
	 PW3zH05LjOnCtGLPQL22VTKYgnzJfte/WDHp51a3q4GCIFUEZwsTr50lzJZZHzz2j/
	 w7cnWEoIwtS3FwOVZR6FOrKSloeySktoBlBH9s+FEnN36GP0MrG4on9I5d+bT7O1eB
	 tZbIbdVX0H344QMxMuH0CGQQZRG27LcnfFoRGD2bXicM1EFVraQCJJ9wEUyHkGx1jJ
	 X4Gl9RE5t6HPMdLJkM3laL9+EDzUpeZjsWqRlW+2i8DWtKOQI2i6hRCxuFlanKyAPB
	 G0v+EEcxQIMod5FA7YgGddf6aWCsyuGsaeMvkm6VlSEjYcKw//c1ds95toRlct5/ut
	 Mfe5TJZTcXYbswsRWPPzSEY7QOAGyQj4tT5LqGQI6jD1UL44aVYKKExJaIQXZyZ3Uj
	 rKBLSrWzd4Ri0s+f85coR4cbewnaq0yCm5t3+TOnsSyehCuAosSiMdUa0M2AdrGptW
	 cA+o2hCx6jqaokrCpWjjr390=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::2b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1723F40E00C3;
	Tue, 21 Jul 2026 23:15:06 +0000 (UTC)
Date: Tue, 21 Jul 2026 16:15:02 -0700
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: tony.luck@intel.com, james.morse@arm.com, Dave.Martin@arm.com,
	babu.moger@amd.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, ben.horgan@arm.com,
	fustini@kernel.org, fenghuay@nvidia.com, peternewman@google.com,
	yu.c.chen@intel.com, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v5 02/10] x86/resctrl: Protect against bad shift
Message-ID: <20260721231502.GGal_9dvrdG9NdUkA4@fat_crate.local>
References: <cover.1782857711.git.reinette.chatre@intel.com>
 <bc6ec5102227b4617265e015ce84335a8e902bc6.1782857711.git.reinette.chatre@intel.com>
 <20260721015959.GEal7SnxxR8D3801cr@fat_crate.local>
 <2184678d-1b67-4d2f-94a3-c4bb22823cd6@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2184678d-1b67-4d2f-94a3-c4bb22823cd6@intel.com>

On Tue, Jul 21, 2026 at 09:14:20AM -0700, Reinette Chatre wrote:
> Hi Boris,
> 
> On 7/20/26 6:59 PM, Borislav Petkov wrote:
> > On Tue, Jun 30, 2026 at 09:27:02PM -0700, Reinette Chatre wrote:
> >> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> >> index bca782050198..9b9495174041 100644
> >> --- a/arch/x86/kernel/cpu/resctrl/core.c
> >> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> >> @@ -247,7 +247,11 @@ static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
> >>  
> >>  	cpuid_count(0x80000020, subleaf, &eax, &ebx, &ecx, &edx);
> >>  	hw_res->num_closid = edx + 1;
> >> -	r->membw.max_bw = 1 << eax;
> >> +	if (BITS_PER_TYPE(r->membw.max_bw) <= eax) {
> >> +		pr_warn("Unable to support hardware's maximum bandwidth\n");
> >> +		return false;
> >> +	}
> >> +	r->membw.max_bw = BIT(eax);
> > 
> > Why?
> > 
> > Why go all the effort if the field can be 64 bits?
> > 
> > Why not make max_bw u64 and handle *all* possible values naturally?
> > 
> 
> resctrl does not support values larger than u32.
> 
> The value represented by max_bw provides the upper limit of control values that
> user space can configure via the schemata file, which in turn represents the
> control value programmed to hardware.
>
> u32 is expected in several places:
> - Parsing of user input in bw_validate() is done via kstrtou32() placing result in
>   "u32 bw". It is this value that is compared against max_bw and would thus need to
>   change as a consequence.
> - Parsing of user input to schemata file via parse_bw() places parsed bandwidth in
>   "u32 bw_val".
> - Upon successful parsing the control value is staged by resctrl fs in
>   resctrl_staged_config::new_ctrl that is u32.
> - On receipt of programming request from resctrl fs, the x86 architectural specific
>   code programs the control value to rdt_hw_ctrl_domain::ctrl_val[] that are u32.
> 
> resctrl, from fs to x86 architecture and now also MPAM, would thus require changes to
> support these AMD systems. If I get the math right this will be systems that support 
> 1073741823.875GB/s and up?
> 
> If resctrl is required to support AMD hardware that can return up to 64bits here
> then that requires more changes than what I am able to take on at this time. From
> my side I prefer to stick to this resctrl safeguard for the scenario and leave support
> for this hardware to AMD.

So that bandwidth limit thing is read from those L3QOS_BW_CONTROL_n MSRs which
have

BW_LEN-1:0 as the range which is the bandwidth limit, at
BW_LEN there's the unlimited bandwidth limit

and that BW_LEN is read from CPUID.

And that is, kinda 12, right now.

And your worry is that some day that limit BW_LEN might go over 31?

Which your math shows how absurd this is.

So what are we actually fixing here?

Something some AI hallucinated that it might be possible at some point in the
very distant, dark future?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
