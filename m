Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2772E8DEB;
	Fri, 24 Jul 2026 06:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784873966; cv=none; b=ppVKWXtxgTKxv/HDVQ4pHefM2YXZmdZL2oAhCCfeds1W5XN54tmpePp/oM6Hni4kgIk2HiVskkoWd37/f5dX3VX6jpUutf/POlyVl0ePbxp0GkAnDTlhK2AYznrJibJOUGVNpiVpjY7CCWC3PU1IFT92bRMLh3tlC93D6Neod7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784873966; c=relaxed/simple;
	bh=ufQ75DQpBBPYEpTzd6UOUn+PR7nv5QC4kmDBdQtnm4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UeMLuPJxP4rxegpMnzHYnklOU0KbrghfjxYkKu2H/t774EyH5nSqwNWRy70e1JiSbf6Xpmazp6LK6C4UK+GMId1lDkPg0Fsg4S3vezEMKT8Xu0hYkR5EvTQD/QC36aeOM6L8uVV2YSuXKQUXx2qeGoPwtO9b6L5sMrmF/mT+IPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNdvmfKf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNdvmfKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0901F1F000E9;
	Fri, 24 Jul 2026 06:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784873965;
	bh=Hfmo4DOrIk8i4elMfDkKwJaEy3pa0lwfAn4CiMWtDug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SNdvmfKfP4lgR4eVudUfb22Hbx+e0BNwuiFKYLrbtYQUxy8oY4wVHHorcf/dz+xAZ
	 G/x8725qHaMCmocw9KXrNd7QVFejKaHfAwlnAEwLd10lXMh7tp/tvdja8lKBLTx6e9
	 qp1TfBDGvvfFj1wx8cRN91GJBeC2mtjzyT2/6xY8=
Date: Fri, 24 Jul 2026 08:17:59 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Frank Scheiner <frank.scheiner@web.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com, cc@epic-linux.org
Subject: Re: [PATCH 6.6 0000/1226] 6.6.145-rc2 review
Message-ID: <2026072447-chloride-plug-638e@gregkh>
References: <20260722143258.264584003@linuxfoundation.org>
 <88255dcb-acac-4a74-a086-b686aaf15eca@web.de>
 <2026072333-creed-overbite-b2a9@gregkh>
 <1e9a0b1d-cc4f-4ac7-ac53-478580181c99@web.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e9a0b1d-cc4f-4ac7-ac53-478580181c99@web.de>

On Thu, Jul 23, 2026 at 02:21:28PM +0200, Frank Scheiner wrote:
> On 23.07.26 09:46, Greg Kroah-Hartman wrote:
> > On Wed, Jul 22, 2026 at 07:25:26PM +0200, Frank Scheiner wrote:
> >> [...]
> >> In our fork of Linux post v6.6 we carry a replay of b4b1ddc that makes
> >> the corresponding changes also for ia64. This is available on [3] (and
> >> also attached to this message) and fixes the build for me.
> >>
> >> [3]: https://github.com/linux-ia64/linux-ia64/commit/a4085ca68e49f49f962ddff46a901ff3468574b8.patch
> >>
> >> Can this be included for linux-6.6.y, so it continues to build for
> >> ia64 as is?
> > 
> > Sure, I'll queue it up.
> 
> Thanks a lot. That should fix our builds.
> 
> > Does anyone still actually use ia64 anymore?  I
> > thought those systems were long dead.
> 
> Dead, no, not at all, maybe left for dead before we took over in 2023.
> But still there were always people taking care of it in the years before
> - keeping it alive for us. Much obliged for that. And today things look
> vastly different compared to 2023. Tomas already mentioned a few things,
> but let me add a few more:
> 
> Today we have it all: distributions that support ia64 (T2, EPIC Slack,
> Afterglow), hardware and simulator support restored, software support
> restored (e.g. Ruby, compilers and more, other things maybe only a
> session with an LLM away), Tomas doing all sorts of optimization work
> that wasn't done in years, other devs bringing in patches for various
> bits of the ecosystem. And just recently out of nowhere ia64 emulators
> popped up, one of it being QEMU based ([1]), currently emulating an
> Itanium 2 system, with MP support and already working well enough for
> MP package builds. There is now even another emulator that tries to
> recreate a Merced based system ([2]).
> 
> [1]: https://github.com/syunnPC/qemu-system-ia64/
> 
> [2]: https://github.com/hotlandsoftware/gemu/
> 
> Please excuse my optimism here, but emulators with MP support will
> bring in a lot more people, the scarce hardware failed to bring in so
> far.
> 
> Of course we are hobbyists, we're doing it for the fun of it. If you
> want to learn more, please head over to:
> 
> https://epic-linux.org/

Cool, but what happens when these last kernels with support for the
platform goes end-of-life?  While running things in emulators is fun,
how will future userspace code that needs newer kernel features ever be
possible?

thanks,

greg k-h
