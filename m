Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC503BBE5;
	Sat,  8 Feb 2025 07:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738999274; cv=none; b=Id1eyq+NQISZ+CcSFIE6gDfqpQrHO8bJeLFdQ9sZSwZ67ziQ7qDWRAesr3YBG2DQa5c0vwBOl/iPkZg6YtkMMHwsDMvN1Dz1xLxg1xttHfi27+a5OuagJ+s7oq+cpXzi9BXc7AxlDjTeb/xJjpJn0helnilflAKgHM4bUvPswKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738999274; c=relaxed/simple;
	bh=4AvSMCW8hMAkgc98W1wQbc55pDMAQI3b/O8HKsMqzdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FvjU/xaKiraPknWYn3c1wxtf73AXQI3QNqllS2M8sIgYQeu/wHTuU+dRraRTDtGZLttpZGibsveQ2FT/wFMMDonbNFWVRXWUOVhV/6eNQjzZut45V3McPUiOGcr5Et99kjyBW154Qp6iobkKSCIaoIiJbvXqmfX8ga2WzeenTP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jsbIehTx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jsbIehTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7FBC4CED6;
	Sat,  8 Feb 2025 07:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738999273;
	bh=4AvSMCW8hMAkgc98W1wQbc55pDMAQI3b/O8HKsMqzdI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jsbIehTxPpoWPNvY9pc+J4DAmeLffs+DKvkDtMpLmIq5pXIYI5HwFMkmhm2XA1axU
	 086Sb2lxMsFheotQvHaB8StsAGP8y491wGqNswmvhkod6CNi1H5z9hCKcaOvAJRP0a
	 Sdvb2OFfz14ah/Fiv8Ew2X2Qlb1Sqsz4kFrRD9iI=
Date: Sat, 8 Feb 2025 08:21:09 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Barry K. Nathan" <barryn@pobox.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	herbert@gondor.apana.org.au, herbert.xu@redhat.com
Subject: Re: [PATCH 6.6 000/389] 6.6.76-rc2 review
Message-ID: <2025020845-oblivion-energetic-4de2@gregkh>
References: <20250206155234.095034647@linuxfoundation.org>
 <13a5abe4-18ea-407e-9435-ab8a36b83c86@pobox.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13a5abe4-18ea-407e-9435-ab8a36b83c86@pobox.com>

On Fri, Feb 07, 2025 at 09:25:08PM -0800, Barry K. Nathan wrote:
> On 2/6/25 08:06, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.76 release.
> > There are 389 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 08 Feb 2025 15:51:12 +0000.
> > Anything received after that time might be too late.
> [snip]
> > Herbert Xu <herbert@gondor.apana.org.au>
> >      crypto: api - Fix boot-up self-test race
> [snip]
> I mentioned in an email to the stable mailing list earlier this week that
> the crypto-api-fix-boot-up-self-test-race patch, on my systems, is causing a
> one-minute freeze followed by a crypto self-test failure. See the log
> excerpt below for an example. (In that email I erroneously said the affected
> kernel was 6.6.76-rc1. It was 6.6.75 plus stable-queue patches, but not
> actually 6.6.76-rc1. Sorry for my mistake.)
> 
> I'm still experiencing this with 6.6.76-rc2. As before, reverting "crypto:
> api - Fix boot-up self-test race" fixes it. I also tried testing 6.6.75 plus
> this patch, and that reproduces the problem. In case it might have been a
> compiler issue, I tried upgrading my build system from Debian bookworm to
> trixie, but the issue reproduces with trixie's gcc 14.2 just as it does with
> bookworm's gcc 12.2.
> 
> I also tested 6.12.13-rc2 and 6.13.2-rc2. Those kernels work fine in my
> testing and do not reproduce this issue.
> 
> To be clear, it's personally not a real problem for me if 6.6.76 is released
> with this patch included -- if necessary, I can just keep reverting this
> patch until I get my systems upgraded to 6.12. However, I figure this is
> still worth reporting, in case it eventually turns out to be something that
> doesn't only affect me.
> 
> Anyway, I'll keep digging to see if I can figure out more. Since essentially
> the same patch that's breaking 6.6 is working just fine on 6.12 and 6.13, I
> feel like I should be able to find more clues. (However, I may be busy for
> the next several days, so I'm not sure how soon I'll be able to make
> progress.)

Thanks for the info, for some reason I thought this was hitting an
already released kernel.  I'll go drop this patch from the 6.6.y queue
now, thanks for pointing it out again.

greg k-h
