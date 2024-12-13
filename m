Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAAE1DACA9;
	Fri, 13 Dec 2024 12:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734092683; cv=none; b=X1votKB3TqhObQTobNS8F4RzIIcA3bAXEda9kVM+rNaKzxzurYT+koImHoscp8m+LYWR0gSqhV680j+zg8ApeWyJe0F3WUYfaEKCACJKoJ2ZPY4uaQ6U0nsMEMW5kXVSonFnmYaVCksqOz1jjogRUeWWS2NRET/zpWovREv0gRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734092683; c=relaxed/simple;
	bh=h7Yf9hoG5pmZDET0C/hweumNfc9fPnihksuPcmnl2Fk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ckAxWjT7tsIlcgbEOlPcPKUOo80cCYGn7KfQ3h2nZbKrdVAXZgN5s3yiLOlJKx5mudX2EbVrt4jGw7B70P2FrWvSlYFmvngMfJhbwhydifBnPYzxkBUr37c/GgMGn594/8iQ1+D/HBqn7Frn3OUoJq77lZ4299Tk21phMrZlFWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jqbRJaaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqbRJaaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00094C4CED0;
	Fri, 13 Dec 2024 12:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734092681;
	bh=h7Yf9hoG5pmZDET0C/hweumNfc9fPnihksuPcmnl2Fk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jqbRJaaYWAM9jdSmNeW5lADqPc4Okd8vgPRoDfTMCmJ5suM3coe7dqJ34xcvejlZJ
	 vzYKwLypZyXYINXsiAMzCjUOTBu+SOxImbP5f6A8P8qzALxzJQ8NtNSeqNQg6AIsRY
	 E/Lqx+nAuvGkV1p3oE1nII7m51AdgQAWPnJhyr+4=
Date: Fri, 13 Dec 2024 13:24:38 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 6.1 000/772] 6.1.120-rc1 review
Message-ID: <2024121311-stays-moonlit-ee5e@gregkh>
References: <20241212144349.797589255@linuxfoundation.org>
 <CA+G9fYu+u4a+63vCCeLo1LdWhvK75B9j-znx7kp2ZVtzK_H4AQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYu+u4a+63vCCeLo1LdWhvK75B9j-znx7kp2ZVtzK_H4AQ@mail.gmail.com>

On Fri, Dec 13, 2024 at 02:29:56AM +0530, Naresh Kamboju wrote:
> On Thu, 12 Dec 2024 at 21:23, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.120 release.
> > There are 772 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.120-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The powerpc builds failed on Linux stable-rc linux-6.1.y due to following build
> warnings / errors.
> 
> powerpc:
>   * build/gcc-13-tqm8xx_defconfig
> 
> First seen on Linux stable-rc v6.1.119-773-g9f320894b9c2.
>   Good: v6.1.119
>   Bad: v6.1.119-773-g9f320894b9c2
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build log:
> -----
> /builds/linux/arch/powerpc/include/asm/page_32.h:16: error:
> "ARCH_DMA_MINALIGN" redefined [-Werror]
>    16 | #define ARCH_DMA_MINALIGN       L1_CACHE_BYTES
>       |
> In file included from /builds/linux/include/linux/slab.h:15:
> /builds/linux/include/linux/cache.h:104: note: this is the location of
> the previous definition
>   104 | #define ARCH_DMA_MINALIGN __alignof__(unsigned long long)
>       |
> cc1: all warnings being treated as errors
> 
> The bisection pointed to,
>    mm/slab: decouple ARCH_KMALLOC_MINALIGN from ARCH_DMA_MINALIGN
>    commit 4ab5f8ec7d71aea5fe13a48248242130f84ac6bb upstream.

Ick, this was to fix a different build error.  Looks like I need to
queue up 78615c4ddb73 ("powerpc: move the ARCH_DMA_MINALIGN definition
to asm/cache.h") as well, I'll go do that now...

thanks,

greg k-h
