Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68104C81;
	Wed, 18 Sep 2024 06:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726640230; cv=none; b=gTs/eEow24EYEiTjEu/v05s2BwbfVPEsVtZO1JkTXxdONRIiWbp27HWzHe9mwfnQ+kIT5SNhw0SBj/4wAm/ERBRXPL21Maav03JAYC/fXp21hVEKnnQC98YjTzlmaRxHyE23D2iVZxgrq5dQcCEt+XMQpF2K6FHxoEt1yCdBh0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726640230; c=relaxed/simple;
	bh=DCayEJGyzIxJwqWRFflxI0n03tSHQnbqdCjHQlBPOwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=URQcGtG1Cld/gFoX5C9ViggqdJP5OboeGlZyhpWbC8HktOxhkuz5PnbWHl/gSjKaBR0BrKbKjLpILmOKx1Nqdn7VlKYwU2AREIoy/XBRm6kb9rgDCZWIHMj3+NKKOYsB4IAgkcABJ4NKinPn+NqRYLqjZBBLFRNidXw8EGbyAPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JaRnEY0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JaRnEY0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF22C4CEC3;
	Wed, 18 Sep 2024 06:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726640230;
	bh=DCayEJGyzIxJwqWRFflxI0n03tSHQnbqdCjHQlBPOwM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JaRnEY0wNjEVds+y9Xcp16bAEKIiJY7vQTLcvnFOvGS2JzvSIyUXtXzoh7nrkJcr0
	 qxaxrNYv9o7pC0i4cFPL43tzzQqjrsMxNxs0HXm16kaHkltZJCk1OiAs6e4mWywwko
	 oo+HNmxfcuL2io9hjBZFS2Rz2gMZYEb4ZvoDjc4k=
Date: Wed, 18 Sep 2024 08:17:07 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 6.6 00/91] 6.6.52-rc1 review
Message-ID: <2024091853-thickness-plexiglas-5e83@gregkh>
References: <20240916114224.509743970@linuxfoundation.org>
 <CA+G9fYv+OXhNPn87X4O9w8-HzGP04USge-et0b3Y4ncU9tussg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYv+OXhNPn87X4O9w8-HzGP04USge-et0b3Y4ncU9tussg@mail.gmail.com>

On Tue, Sep 17, 2024 at 04:00:10PM +0530, Naresh Kamboju wrote:
> On Mon, 16 Sept 2024 at 17:38, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.6.52 release.
> > There are 91 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 18 Sep 2024 11:42:05 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.52-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> The s390 builds failed on the Linux stable-rc linux-6.6.y and linux-6.10.y due
> to following build warnings / errors with gcc-13 and clang-19 with defconfig.
> 
> * s390, build
>   - clang-19-allnoconfig
>   - clang-19-defconfig
>   - clang-19-tinyconfig
>   - clang-nightly-allnoconfig
>   - clang-nightly-defconfig
>   - clang-nightly-tinyconfig
>   - gcc-13-allmodconfig
>   - gcc-13-allnoconfig
>   - gcc-13-defconfig
>   - gcc-13-tinyconfig
>   - gcc-8-allnoconfig
>   - gcc-8-defconfig-fe40093d
>   - gcc-8-tinyconfig
> 
> 
> First seen on v6.6.51-92-gfd49ddc1e5f8
>   Good: v6.6.51
>   BAD:  v6.6.51-92-gfd49ddc1e5f8
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> build log:
> --------
> arch/s390/kernel/setup.c: In function 'reserve_lowcore':
> arch/s390/kernel/setup.c:748:31: error: implicit declaration of
> function 'get_lowcore'; did you mean 'setup_lowcore'?
> [-Werror=implicit-function-declaration]
>   748 |         void *lowcore_start = get_lowcore();
>       |                               ^~~~~~~~~~~
>       |                               setup_lowcore
> arch/s390/kernel/setup.c:748:31: warning: initialization of 'void *'
> from 'int' makes pointer from integer without a cast
> [-Wint-conversion]
> arch/s390/kernel/setup.c:752:21: error: '__identity_base' undeclared
> (first use in this function)
>   752 |         if ((void *)__identity_base < lowcore_end) {
>       |                     ^~~~~~~~~~~~~~~
> arch/s390/kernel/setup.c:752:21: note: each undeclared identifier is
> reported only once for each function it appears in
> In file included from include/linux/bits.h:21,
>                  from arch/s390/include/asm/ptrace.h:10,
>                  from arch/s390/include/asm/lowcore.h:13,
>                  from arch/s390/include/asm/current.h:13,
>                  from include/linux/sched.h:12,
>                  from arch/s390/kernel/setup.c:21:
> include/linux/minmax.h:31:9: error: first argument to
> '__builtin_choose_expr' not a constant
>    31 |
> __builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),
>  \
>       |         ^~~~~~~~~~~~~~~~~~~~~

Offending commit now removed from 6.6.y and 6.10.y, thanks!

greg k-h
