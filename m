Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B341D516A;
	Thu,  5 Dec 2024 09:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733391401; cv=none; b=U0IqdTzSw2aVzQsLYano60DvSm3V0jzDoX5N9ceiYN6rsMjdzIUc0ajaoGQQjKSzv3ga1BXotT79L3hMv0vBj+36m04MheMC4hGXk8tf5RHITf/HXEbi7WeH7rBfeoKaLpZwzn9iQjJZCFU3NQ0bk6u/P9HP5pAK65yzJqEMdiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733391401; c=relaxed/simple;
	bh=MtvxtPQXXkdESvM17FbUWJ8ZBd0i1jazUOmBCLv66ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LcI9pFpq0jYXYKsdE1ntxGmTwlTzR02TLSkIzjpp60i9QjwWOpymNT3Pctq4bYItV2vRL3T0KMrlwfMZqnyDHk7opNPujsIXuIwKNCQLAAcsxDbTi8h7oBaHXk/2OG2L4fIyxUQENKorATjWi/Fej3VgGrFe/MHwCkfzBzdz3Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHTo+lSU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHTo+lSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D89C4CED1;
	Thu,  5 Dec 2024 09:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733391401;
	bh=MtvxtPQXXkdESvM17FbUWJ8ZBd0i1jazUOmBCLv66ms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nHTo+lSUSeb99KPYFYRB2nH/XCNwgU0zdOHP7n9zLa6uvqFyEMhtt14AdI9dV0ts5
	 HibYBUJUwskfrm9HJhFFSgXyFI5Oz4fMBsw4TlroWpmeRQUjV79Yx/nHRfX0rlJ4VG
	 mP9uTBW4wEJVJ3smlwMWWYnnETPvvxylnRim04j0=
Date: Thu, 5 Dec 2024 10:36:38 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 000/138] 4.19.325-rc1 review
Message-ID: <2024120503-eloquent-exemption-b3e7@gregkh>
References: <20241203141923.524658091@linuxfoundation.org>
 <Z09KXnGlTJZBpA90@duo.ucw.cz>
 <2024120424-diminish-staple-50d5@gregkh>
 <Z1A+Ku5D0OFOSUm4@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1A+Ku5D0OFOSUm4@duo.ucw.cz>

On Wed, Dec 04, 2024 at 12:34:02PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > > This is the start of the stable review cycle for the 4.19.325 release.
> > > > There are 138 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > 
> > > Build fails:
> > > 
> > > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/8532423815
> > > 
> > >   CC      drivers/pinctrl/uniphier/pinctrl-uniphier-pro4.o
> > > 3895
> > >   CC      drivers/pci/of.o
> > > 3896
> > > drivers/rtc/rtc-st-lpc.c: In function 'st_rtc_probe':
> > > 3897
> > > drivers/rtc/rtc-st-lpc.c:233:11: error: 'IRQF_NO_AUTOEN' undeclared (first use in this function); did you mean 'IRQ_NOAUTOEN'?
> > > 3898
> > >            IRQF_NO_AUTOEN, pdev->name, rtc);
> > > 3899
> > >            ^~~~~~~~~~~~~~
> > > 3900
> > >            IRQ_NOAUTOEN
> > > 3901
> > > drivers/rtc/rtc-st-lpc.c:233:11: note: each undeclared identifier is reported only once for each function it appears in
> > > 3902
> > >   CC      drivers/pci/quirks.o
> > > 3903
> > > make[2]: *** [scripts/Makefile.build:303: drivers/rtc/rtc-st-lpc.o] Error 1
> > > 3904
> > > make[1]: *** [scripts/Makefile.build:544: drivers/rtc] Error 2
> > > 3905
> > > make[1]: *** Waiting for unfinished jobs....
> > > 3906
> > >   CC      drivers/pinctrl/uniphier/pinctrl-uniphier-sld8.o
> > > 3907
> > >   CC      drivers/soc/renesas/r8a7743-sysc.o
> > 
> > What arch is this?  And can you not wrap error logs like this please?
> 
> Not easily. But you can easily get nicely formatted logs +
> architecture details by clicking the hyperlink above.

Sometimes we don't have web access, only email access.  Putting all of
the relevant information in the report is best please, if you wish for
anyone to pay attention to it (i.e. don't make me do extra work for your
test systems...)

I found the offending commit, I think.  Funnily it used IRQ_NOAUTOEN
which is also in other files in 4.19.y yet never defined, so our test
coverage isn't all that good these days.  All the more reason this
kernel needs to be marked end-of-life and never used again.

thanks,

greg k-h
