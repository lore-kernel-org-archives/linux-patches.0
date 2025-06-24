Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447B217A2E8;
	Tue, 24 Jun 2025 10:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750760288; cv=none; b=FQURR/7QDT9wjvbv7kkKpZm9W7/QznR1jfJGniXSFb6a0d9YUhWYw/2RytBzLbrHuVsxpzJkchUaL4EHaddtVqqzADoydGIxTDZnAqm+aq+VpLDKoTshk6XECsZWAyvI8173FaReWWJ9WlQBeQmUzw1m7v8PqX4psSvQpLiWYbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750760288; c=relaxed/simple;
	bh=H7Gk/NckKVvh/MfBLeEYzkGkI+wdO7PXVtA1Vt7lAyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j4v0iHCc3nsYYkq9w/ebfRrMP0Uvqu6y7pC5fk+bsukPABP8BjQf73fGgWSk+ny0YoA2wptG8NiZH6CuTZ8MgrXBHtLPl1PTPAEsSHn082Tq8hKv4rBsaoACm9VVaqp+4aTfFLpj1mCKnGvDDAXezQGxIMf+D1zNsYrzCQr5fMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCmVGiDy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCmVGiDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927ADC4CEE3;
	Tue, 24 Jun 2025 10:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750760288;
	bh=H7Gk/NckKVvh/MfBLeEYzkGkI+wdO7PXVtA1Vt7lAyo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bCmVGiDyagJ0zN1w6ebouItQ3WIH3bc/glJyADeuNJaV6GfYeq61ENJ30nvIH4Ikt
	 zbBBlIwXDUJ9dqS6wmBPkmzkWDHw+3jG0DgzWZd9Beb0vROQUfOiMsQ/7QQJfj3tnH
	 ChYD5N8u306aGPCvefK4Z5kKWbsIPW5DVq9vMJM4=
Date: Tue, 24 Jun 2025 11:18:04 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Russell King - ARM Linux <linux@armlinux.org.uk>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 5.15 000/411] 5.15.186-rc1 review
Message-ID: <2025062439-tamer-diner-68e9@gregkh>
References: <20250623130632.993849527@linuxfoundation.org>
 <CA+G9fYuU5uSG1MKdYPoaC6O=-w5z6BtLtwd=+QBzrtZ1uQ8VXg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuU5uSG1MKdYPoaC6O=-w5z6BtLtwd=+QBzrtZ1uQ8VXg@mail.gmail.com>

On Tue, Jun 24, 2025 at 02:12:05AM +0530, Naresh Kamboju wrote:
> On Mon, 23 Jun 2025 at 18:39, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.186 release.
> > There are 411 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 25 Jun 2025 13:05:51 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.186-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Regressions on arm64 allyesconfig builds with gcc-12 and clang failed on
> the Linux stable-rc 5.15.186-rc1.
> 
> Regressions found on arm64
> * arm64, build
>   - gcc-12-allyesconfig
> 
> Regression Analysis:
>  - New regression? Yes
>  - Reproducibility? Yes
> 
> Build regression: stable-rc 5.15.186-rc1 arm64
> drivers/scsi/qedf/qedf_main.c:702:9: error: positional initialization
> of field in 'struct' declared with 'designated_init' attribute
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ## Build errors
> drivers/scsi/qedf/qedf_main.c:702:9: error: positional initialization
> of field in 'struct' declared with 'designated_init' attribute
> [-Werror=designated-init]
>   702 |         {
>       |         ^
> drivers/scsi/qedf/qedf_main.c:702:9: note: (near initialization for
> 'qedf_cb_ops')
> cc1: all warnings being treated as errors

I saw this locally, at times, it's random, not always showing up.  Turn
off the gcc randconfig build option and it goes away, which explains the
randomness I guess.

If you can bisect this to a real change that causes it, please let me
know, I couldn't figure it out and so just gave up as I doubt anyone is
really using that gcc plugin for that kernel version.

thanks,

greg k-h
