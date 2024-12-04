Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997B619CC37;
	Wed,  4 Dec 2024 09:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733305715; cv=none; b=dJJRXxY51d63Qw5hISxRC57SkNbgXuc5UyIVleRwhrT6fqJKxJTvnF08XxaZqlyB+CD4uFSPRpXFSca38NrmMGg7oIY22e8fg2+koKfCgcrvvyZNXkpex43Td//3F1SYhx6+9GkBl6A5G4lYOgcmJDMgb9rL7Ri45GKHmGXSxH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733305715; c=relaxed/simple;
	bh=u/P/hlu0k7735Cpyavyp1Y9i5sb+YioZt9K7R7M1cm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aB0msmJkiMRzyevbuaW0aUAs/nORKOgBmFj8jRVkTK45hhVebTY0SD4Jj6MI8TbSOGUf9d+NN2ZGkZoMxcb6cRBn05EWy+wxO80X0+NKMCWDf4brNAT9fA7dFPe05R8Icmc68VwITAxydMUIHHIxVLb4TEWIUyLNLiJXSoMheDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5AZSUID; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5AZSUID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78555C4CED1;
	Wed,  4 Dec 2024 09:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733305715;
	bh=u/P/hlu0k7735Cpyavyp1Y9i5sb+YioZt9K7R7M1cm0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s5AZSUID/ZrRS+n5uuGx6o364AU9I1Ita5ScStCBZsnm+ZW/FsdXH7MwhrBMlX7UB
	 PzFk6m2X2/spcXqHJXJndzmbYdJyuUj/c7OV8Ql1Fc5XDFj2P3mq7DNhya5IZhidQC
	 5PhuvgdsGBgldfMXKw9kHOLJQF+r+KfeYC8Aqrvo=
Date: Wed, 4 Dec 2024 10:48:31 +0100
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
Message-ID: <2024120424-diminish-staple-50d5@gregkh>
References: <20241203141923.524658091@linuxfoundation.org>
 <Z09KXnGlTJZBpA90@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z09KXnGlTJZBpA90@duo.ucw.cz>

On Tue, Dec 03, 2024 at 07:13:50PM +0100, Pavel Machek wrote:
> Hi!
> 
> > ------------------
> > Note, this is the LAST 4.19.y kernel to be released.  After this one, it
> > is end-of-life.  It's been 6 years, everyone should have moved off of it
> > by now.
> > ------------------
> 
> Releasing 130 patches as end-of-life kernel is not good idea. There
> may be regression hiding between them...

It is better to have a regression for a fix then ignoring known fixes
every time.  You seriously would want the final 4.19.y release to be
missing 100+ known fixes?  That's just not ok for anyone who is waiting
until the last week of this kernel to change (and I know many are, which
is odd...)

> > This is the start of the stable review cycle for the 4.19.325 release.
> > There are 138 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Build fails:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/8532423815
> 
>   CC      drivers/pinctrl/uniphier/pinctrl-uniphier-pro4.o
> 3895
>   CC      drivers/pci/of.o
> 3896
> drivers/rtc/rtc-st-lpc.c: In function 'st_rtc_probe':
> 3897
> drivers/rtc/rtc-st-lpc.c:233:11: error: 'IRQF_NO_AUTOEN' undeclared (first use in this function); did you mean 'IRQ_NOAUTOEN'?
> 3898
>            IRQF_NO_AUTOEN, pdev->name, rtc);
> 3899
>            ^~~~~~~~~~~~~~
> 3900
>            IRQ_NOAUTOEN
> 3901
> drivers/rtc/rtc-st-lpc.c:233:11: note: each undeclared identifier is reported only once for each function it appears in
> 3902
>   CC      drivers/pci/quirks.o
> 3903
> make[2]: *** [scripts/Makefile.build:303: drivers/rtc/rtc-st-lpc.o] Error 1
> 3904
> make[1]: *** [scripts/Makefile.build:544: drivers/rtc] Error 2
> 3905
> make[1]: *** Waiting for unfinished jobs....
> 3906
>   CC      drivers/pinctrl/uniphier/pinctrl-uniphier-sld8.o
> 3907
>   CC      drivers/soc/renesas/r8a7743-sysc.o

What arch is this?  And can you not wrap error logs like this please?

thanks,

greg k-h
