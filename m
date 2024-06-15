Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893AF38FB9;
	Sat, 15 Jun 2024 10:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718448822; cv=none; b=n8DlxU5H0eGLQaxZfenJ/z6AQJbwgCtKsFg/WcHm84E/nkAvsHSHsHItF8+c0i9SGEtfPy+oK/OsxPXRHjDAz20GbHUTRGXBC5VAJIapnvj/b1pGMJPiqfPSIBOR1DslAV1HxUgi2AIGkyifipjTEVV60beyNwcFXjZ457BQmrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718448822; c=relaxed/simple;
	bh=tu6TVFlTjlBdAUK3I0se9dieJs3fHXbRED95tRHylDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pjLWgJnzMmn6QTPjtSupec5LPNfhjtfP62Fdx4ugEGyJwZkdj9gayU3PxSq2HUIyQWSvx1rGrAkBgmPaJXrY6oifv5igMADP3pZTPHN2FZu40o7yNFBbs47211pRt4lhU3lE7u75k+pZUQ8TDs/snXoMzTsoGARWPjlI4kNbx88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDXTMb16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDXTMb16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E50C116B1;
	Sat, 15 Jun 2024 10:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718448822;
	bh=tu6TVFlTjlBdAUK3I0se9dieJs3fHXbRED95tRHylDI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YDXTMb16F/k1JB4UJVj6KUHou1XgxUkci0IteuFcV8Isd7Vjg3p6CTwephVuxKmLY
	 /KkJ2y/WgCqd5vSjF3f+2GLWV8YXwIe6TCxfg3UxX/44mB68EMGUJk1d9O6CA2ZPA5
	 BdeCzQKB1qzoWBTMX3fNI/Hele9NssE3RnfJrAT8=
Date: Sat, 15 Jun 2024 12:53:39 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 000/213] 4.19.316-rc1 review
Message-ID: <2024061533-purse-laundry-5d97@gregkh>
References: <20240613113227.969123070@linuxfoundation.org>
 <CA+G9fYtN0R0=i_oP5ZfUxmBuqatTOY9XDfKCw9wjsQVo=YRAaw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtN0R0=i_oP5ZfUxmBuqatTOY9XDfKCw9wjsQVo=YRAaw@mail.gmail.com>

On Sat, Jun 15, 2024 at 04:03:04PM +0530, Naresh Kamboju wrote:
> On Thu, 13 Jun 2024 at 17:07, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.316 release.
> > There are 213 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.316-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> As other reported,
> 
> The arm omap2plus_defconfig builds failed on stable-rc 4.19 due to following
> warnings and errors.
> 
> * arm, build
>   - clang-18-omap2plus_defconfig
>   - gcc-12-omap2plus_defconfig
>   - gcc-8-omap2plus_defconfig
> 
> Build log:
> ---------
> drivers/hsi/controllers/omap_ssi_core.c:653:10: error: 'struct
> platform_driver' has no member named 'remove_new'; did you mean
> 'remove'?
>   653 |         .remove_new = ssi_remove,
>       |          ^~~~~~~~~~
>       |          remove
> drivers/hsi/controllers/omap_ssi_core.c:653:23: error: initialization
> of 'int (*)(struct platform_device *)' from incompatible pointer type
> 'void (*)(struct platform_device *)'
> [-Werror=incompatible-pointer-types]
>   653 |         .remove_new = ssi_remove,
>       |                       ^~~~~~~~~~
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Liks:
> --
>  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.315-214-gafbf71016269/testrun/24321970/suite/build/test/gcc-12-omap2plus_defconfig/log
>  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.315-214-gafbf71016269/testrun/24321970/suite/build/test/gcc-12-omap2plus_defconfig/details/
>  - https://storage.tuxsuite.com/public/linaro/lkft/builds/2hp7W1xcas5CN3psaeGX1n8sAj8/
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
> 

Now fixed up, thanks.

greg k-h
