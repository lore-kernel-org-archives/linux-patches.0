Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEDC230D1E;
	Fri, 14 Feb 2025 13:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739538481; cv=none; b=Q1+zf3cUu+J2zycgNNxWUPpRljlIFl6WJ+0spGcjwUpeaTMQIImZ/aKfOIUqh1EJwiUp2oWRroj+jp3X9O8a+wABAErLaeBidcU+2OmfZK2+6qNLfEGfPYup586CK6P91yoIf/YT//mHIXtlaXldn1CjxhaIM0crOFEnwrV2Kms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739538481; c=relaxed/simple;
	bh=ODTOjd4Bv0YzvgZUjajJ7VHAs+BhMRmBghGQ5h5yJt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J/XzwlZ17pgLwRq4kt6an41/GB6J1XK1v8MWPHRc34BjhxK5G9j5bfFQupWWp9IwGa/nmLAgIVpuwm73LbedgfuZ+tv3QSZff14fSSduhGXQY7s+8fYFalXSnDS6ABRuPvNZnayV50uq47eXjFXv/rDxycSPLqFFZp5fcfvw7Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hXlffXLn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXlffXLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D980C4CEE7;
	Fri, 14 Feb 2025 13:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739538480;
	bh=ODTOjd4Bv0YzvgZUjajJ7VHAs+BhMRmBghGQ5h5yJt8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hXlffXLn/MnzT1ILAuefEUiB549zb///H6Ib6fpQB9BCKYyRXRzYy0ossXv30WizK
	 laKk8I2A8kAqW4ZinF7qcZG3EGzIcw9Q8uYnNtxKLm0ZRtUxsArJCXv9ZL+isN45jI
	 P3ymlW9OgQOEki5wb6nPgcWNwjhsgdY4WLEeo16k=
Date: Fri, 14 Feb 2025 14:07:57 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH 6.13 000/443] 6.13.3-rc1 review
Message-ID: <2025021439-sixtieth-concrete-c104@gregkh>
References: <20250213142440.609878115@linuxfoundation.org>
 <e7096ec2-68db-fc3e-9c48-f20d3e80df72@applied-asynchrony.com>
 <2025021459-guise-graph-edb3@gregkh>
 <9a44f314-c101-4ed1-98ad-547c84df7cdd@applied-asynchrony.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9a44f314-c101-4ed1-98ad-547c84df7cdd@applied-asynchrony.com>

On Fri, Feb 14, 2025 at 11:12:06AM +0100, Holger Hoffstätte wrote:
> On 2025-02-14 09:42, Greg Kroah-Hartman wrote:
> > On Fri, Feb 14, 2025 at 09:32:06AM +0100, Holger Hoffstätte wrote:
> > > On 2025-02-13 15:22, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 6.13.3 release.
> > > > There are 443 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > 
> > > Builds & runs fine BUT fails to suspend to RAM 99.99% of the time (basically
> > > one success but never again). Display powers down but fans stay on.
> > > 
> > > Tested on multiple systems, all x64. I first suspected amdgpu because why not :)
> > > but it also fails on a system without amdgpu, so that's not it.
> > > 
> > > Reverting to 6.13.2 immediately fixes everything.
> > > 
> > > Common symptom on all machines seems to be
> > > 
> > > [  +0.000134] Disabling non-boot CPUs ...
> > > [  +0.000072] Error taking CPU15 down: -16
> > > [  +0.000002] Non-boot CPUs are not disabled
> > > 
> > > "Error taking down CPUX" is always the highest number of CPU, i.e.
> > > 15 on my 16-core Zen2 laptop, 3 on my 4-core Sandybridge etc.
> > > 
> > > I started to revert suspects but no luck so far:
> > > - acpi parsing order
> > > - amdgpu backlight quirks
> > > - timers/hrtimers
> > > 
> > > Suggestions for other suspects are welcome.
> > 
> > Can you run 'git bisect' to try to find the offending change?
> 
> (cc: Juri Lelli)
> 
> Whoop! Whoop! The sound of da police!
> 
> 2ce2a62881abcd379b714bf41aa671ad7657bdd2 is the first bad commit
> commit 2ce2a62881abcd379b714bf41aa671ad7657bdd2 (HEAD)
> Author: Juri Lelli <juri.lelli@redhat.com>
> Date:   Fri Nov 15 11:48:29 2024 +0000
> 
>     sched/deadline: Check bandwidth overflow earlier for hotplug
>     [ Upstream commit 53916d5fd3c0b658de3463439dd2b7ce765072cb ]
> 
> With this reverted it reliably suspends again.

Thanks!  I'll go revert that one now and push out new -rc releases soon.

greg k-h
