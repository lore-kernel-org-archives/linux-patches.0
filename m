Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9492335DA77
	for <patches@lists.linux.dev>; Tue, 21 Jul 2026 02:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784599230; cv=none; b=tcXYdMmcrcklfTNGuW7x/s/iTuzmsFo/bbQOQ+SnnRslIZ5/Kw3oM+OESmNr/bNCJomgYPOyuidp0+FbRL+N6CZAoGPv9h5uTAKzGipvsKKSQKj0HqPKX+8Ym3kbXc0s8VdNJjkHMyDlfsXYBfsOzp6qZ+Z2Pel4D6HwifBVzic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784599230; c=relaxed/simple;
	bh=4z4pEhkzhd8PPkfvthIdarxBnEKuefevRkRx3XYfNAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OK99rk2mQxKgE4cDm4UFIKgx2HJV2RYGhpf+ihUbk1wVpaIsa4rz7jDrqytKqpPtst1Exglv826L4+dKcX6qTmm19yLwaGgET4h49+FZXEt3odthcterpWJUk/dfC6GbWdAJvs5V9/WCqdTFoaJOLVWHgQfyLjZFMMRUik/hpuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=D4ca6Z1S; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="D4ca6Z1S"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5316D40E00E6;
	Tue, 21 Jul 2026 02:00:26 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ZeZhYkjDvbXk; Tue, 21 Jul 2026 02:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784599219; bh=bL/dZY2U0rKEklKQIV3GypOp98VrOV9hdHOJVBv5Bwk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D4ca6Z1Sdvge0WW5PEzfN7OyoZgHeSVOg+ovgQk0uI4gR+G5JRY3WwucP8XHefWUk
	 XVlxVg5E/efvS9qeDxMlFO4bzxRvvIi8eO2dSYx7CAtQPpjinpO3BiqhMu2d6Pxsfm
	 p6jpkHIc2lrw/8GeCo59mZiD7AxPrBpfqn6uc1tWBuNSPipiHs4Mn017gCPLcHTH+0
	 fX09K3e6ZlClM4fAlTwtXpBpcp9cVC+xxV+LFxrFXJXYRdzC+Aquk+xWDR/BqLo8Ml
	 g2Ogdew6A2UrdHgXzKX40HUavlJbBJfKax6HYaR90CNXO6NRlrXvbz7e1v0aENE+aA
	 FrdY8XI2pgOM9Fr6Vi9596Mkro0LXm6FPcEs1iYu/yiLl3T1LkM6r+aVyQjupc/Rrx
	 b1d5FjdoC1YmC+MH2yr/5KdN0WVKmVuVgapyTPg5sfeMUKyJFWCowemTH0Tc5ayERb
	 GqFABWwdVM6oSne/UqKp+kCcSRiJGvc0SutUS1eSyx9SxibFgkcxUuRfrYd9m8gmTk
	 MumCPd4TrcpvR13ufetSQTW6imNImcme4SAm3t0NhWrWnm6h2lUg2rhlatkwMyCU4w
	 fiYdId8pAiSpwD7+gXgewSkzICrMmRBYnXxOuwJg5e+s4mBKbVJbXfiaBCqQA8V97X
	 OBNda1pv7QF8OdUFI8xD+umg=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B454740E00DC;
	Tue, 21 Jul 2026 02:00:02 +0000 (UTC)
Date: Mon, 20 Jul 2026 18:59:59 -0700
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: tony.luck@intel.com, james.morse@arm.com, Dave.Martin@arm.com,
	babu.moger@amd.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, ben.horgan@arm.com,
	fustini@kernel.org, fenghuay@nvidia.com, peternewman@google.com,
	yu.c.chen@intel.com, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v5 02/10] x86/resctrl: Protect against bad shift
Message-ID: <20260721015959.GEal7SnxxR8D3801cr@fat_crate.local>
References: <cover.1782857711.git.reinette.chatre@intel.com>
 <bc6ec5102227b4617265e015ce84335a8e902bc6.1782857711.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bc6ec5102227b4617265e015ce84335a8e902bc6.1782857711.git.reinette.chatre@intel.com>

On Tue, Jun 30, 2026 at 09:27:02PM -0700, Reinette Chatre wrote:
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index bca782050198..9b9495174041 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -247,7 +247,11 @@ static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
>  
>  	cpuid_count(0x80000020, subleaf, &eax, &ebx, &ecx, &edx);
>  	hw_res->num_closid = edx + 1;
> -	r->membw.max_bw = 1 << eax;
> +	if (BITS_PER_TYPE(r->membw.max_bw) <= eax) {
> +		pr_warn("Unable to support hardware's maximum bandwidth\n");
> +		return false;
> +	}
> +	r->membw.max_bw = BIT(eax);

Why?

Why go all the effort if the field can be 64 bits?

Why not make max_bw u64 and handle *all* possible values naturally?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
