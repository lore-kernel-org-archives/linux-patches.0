Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA481850B3;
	Mon, 15 Jul 2024 11:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721043804; cv=none; b=hcmgL73IQT/8L+McKbHXwXuRqIXi8JRXc072otTrF2LID5KMSbV/VaFAZnym83PHsS2MMSTS7oBGoGZA7CfOh/BKohlevHG7Zo7fa5PHWbEE0yYW8SuN4gzbSvBO+F9oLJ8FyAfGYxSOoWmxbv4Zm8/ISXLZmXBaVtLKQhyVa80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721043804; c=relaxed/simple;
	bh=e+MHyCyj9h3QpDGIY8dzDG9OfbTUY49n9aY53EdlVcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G+8vtFqSCL3ZwiptAS6wLwfJ94ediuKGrOPMP8rGusQmucj/127BQN9nnC7qr6XGeb61WNCKnnAoRlQAthhGxsGo/jzFK5YonymSUaSWxJphR22hbgyLr4uc2J0DDbb1L58WyKMEaYcJk9tyyBir4HKcWwRx0S5b5I3Kw8IJsvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqZjWEou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqZjWEou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215E3C32782;
	Mon, 15 Jul 2024 11:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721043803;
	bh=e+MHyCyj9h3QpDGIY8dzDG9OfbTUY49n9aY53EdlVcQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kqZjWEou3Q+C80oY1OIuC4gm2F89DW85dO8PZAuWwzIEKgyFpECOp1YKP0tqcErMW
	 c782+I5icTMl0TRNv4i7iXo3tmrnwmqV6MbNI7iI0Twz6Qajel82rtVJHbcPTVjgLp
	 61pyQLhRHzuEdfxCtRGihfjAH/qRs0NzgsdcFzj8=
Date: Mon, 15 Jul 2024 13:43:21 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Scheiner <frank.scheiner@web.de>
Cc: stable@vger.kernel.org, akpm@linux-foundation.org, allen.lkml@gmail.com,
	broonie@kernel.org, conor@kernel.org, f.fainelli@gmail.com,
	jonathanh@nvidia.com, linux-kernel@vger.kernel.org,
	linux@roeck-us.net, lkft-triage@lists.linaro.org,
	patches@kernelci.org, patches@lists.linux.dev, pavel@denx.de,
	rwarsow@gmx.de, shuah@kernel.org, srw@sladewatkins.net,
	sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org,
	=?utf-8?B?VG9tw6HFoQ==?= Glozar <tglozar@gmail.com>
Subject: Re: [PATCH 5.10 000/284] 5.10.221-rc2 review
Message-ID: <2024071543-footing-vantage-bd4f@gregkh>
References: <20240704094505.095988824@linuxfoundation.org>
 <76458f11-0ca4-4d3b-a9bc-916399f76b54@web.de>
 <2024071237-hypnotize-lethargic-98f2@gregkh>
 <07a7bc4b-9b71-486f-8666-d3b3593d682c@web.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07a7bc4b-9b71-486f-8666-d3b3593d682c@web.de>

On Fri, Jul 12, 2024 at 04:19:39PM +0200, Frank Scheiner wrote:
> On 12.07.24 15:32, Greg KH wrote:
> > I'm confused, which commit should we add, or should we just revert what
> > we have now?
> 
> Sorry for the confusion. Let me try again:
> 
> 1. efi: memmap: Move manipulation routines into x86 arch tree
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.10.y&id=31e0721aeabde29371f624f56ce2f403508527a5
> 
> ...breaks the build for ia64, because it requires a header that does not
> exist before 8ff059b8531f3b98e14f0461859fc7cdd95823e4 for ia64.
> 
> 2. efi: ia64: move IA64-only declarations to new asm/efi.h header
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8ff059b8531f3b98e14f0461859fc7cdd95823e4
> 
> adds this header and fixes the ia64 build, see for example [1].
> 
> [1]:
> https://github.com/linux-ia64/linux-stable-rc/actions/runs/9871144965#summary-27258970494
> 
> From my understanding 31e0721aeabde29371f624f56ce2f403508527a5 should
> not be merged w/o 8ff059b8531f3b98e14f0461859fc7cdd95823e4, which also
> seems to be the case for all other stable kernels from linux-5.12.y up.
> 
> So 8ff059b8531f3b98e14f0461859fc7cdd95823e4 should be added, too, if
> 31e0721aeabde29371f624f56ce2f403508527a5 stays in.

Ok, thanks, now queued up.

> > And I thought that ia64 was dead?
> 
> No, actually it's alive and well - just currently outside of mainline -
> but still in the stable kernels up to linux-6.6.y and for newer kernels
> patched back in. If you want to check on our CI ([2]), all current
> stable kernels build fine for ia64 and run in Ski - but linux-5.10.y
> currently only because I manually added
> 8ff059b8531f3b98e14f0461859fc7cdd95823e4 to the list of patches applied
> by the CI.
> 
> [2]: https://github.com/linux-ia64/linux-stable-rc/actions/runs/9901808825

Will be interesting to see how long it lasts, good luck!

greg k-h
