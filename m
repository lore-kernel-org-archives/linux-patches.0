Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2210364DC;
	Fri, 26 Jul 2024 06:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721975583; cv=none; b=Oh/5XF4KoizdYDgYQ6EvLF31lNLF/b4yli8xBt9trzQUtNErouDoNfx0ppET4qnZ43/l6N2/dP6gt06ej9cNmzO+bQYbaY5UI/cz6xJM0C4DTJ4vPV4h2wDo+dW+OMpuPvIMJtHllPYwcUk3SL5cOOIUIgpe1XEr9qbw9Ca3PUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721975583; c=relaxed/simple;
	bh=LhmpSFRImNhxYoL4ax/b0424qCJAA3V6P/KQf12ysbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bU7XBAeiTmEPKwunIPqczltxG8vHwBqU+p67PMIRITmNkciD1oxWb1L8oG2o76B0/qx3CBVQFOAz9B4hBwFRRk3/nQVM9PPrM5VOP2ZSKubjbvanJuIn0QEDZ+fT2hqASN+PXJNEgoeSmkJoilLWME5P8hObyHMg/+zhEXpzQaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fyr4r7RQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fyr4r7RQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AA7C32782;
	Fri, 26 Jul 2024 06:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721975583;
	bh=LhmpSFRImNhxYoL4ax/b0424qCJAA3V6P/KQf12ysbo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fyr4r7RQ75gZItslnwo2VMuQpShKw5/zjjrYPOsU2tI+J+5tQYPaSm1pHS1Sp5ZEe
	 ZjsPiDlLZauPHW6ws5Muqwey2pIwtU0f7hvxVqYZvL2SWMuPKufITFentHFD2r4Pxl
	 CWWHbN3BVDNjPTm8WXrk13HyreBnwTNfhG+bMR0Q=
Date: Fri, 26 Jul 2024 08:33:00 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Anders Roxell <anders.roxell@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH 5.15 00/87] 5.15.164-rc1 review
Message-ID: <2024072645-delighted-barbecue-154f@gregkh>
References: <20240725142738.422724252@linuxfoundation.org>
 <CA+G9fYvCyg1hXaci_j-RB4YgATb458ZqRjJSye4qub9zYrmL_A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvCyg1hXaci_j-RB4YgATb458ZqRjJSye4qub9zYrmL_A@mail.gmail.com>

On Thu, Jul 25, 2024 at 10:18:49PM +0530, Naresh Kamboju wrote:
> On Thu, 25 Jul 2024 at 20:22, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.164 release.
> > There are 87 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.164-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The following build errors noticed while building arm configs with toolchains
> gcc-12 and clang-18 on stable-rc linux-5.15.y
> 
> First seen on today builds 25-July-2024.
> 
>   GOOD: b84034c8f228 ("Linux 5.15.163-rc2")
>   BAD:  1d0703aa8114 ("Linux 5.15.164-rc1")
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build log:
> -------
> from drivers/net/wireless/ralink/rt2x00/rt2800lib.c:25:
> drivers/net/wireless/ralink/rt2x00/rt2800lib.c: In function
> 'rt2800_txpower_to_dev':
> include/linux/build_bug.h:78:41: error: static assertion failed:
> "clamp() low limit (char)(-7) greater than high limit (char)(15)"
>    78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
>       |                                         ^~~~~~~~~~~~~~
> include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
>    77 | #define static_assert(expr, ...) __static_assert(expr,
> ##__VA_ARGS__, #expr)
>       |                                  ^~~~~~~~~~~~~~~
> include/linux/minmax.h:66:17: note: in expansion of macro 'static_assert'
>    66 |
> static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)),
>  \
>       |                 ^~~~~~~~~~~~~
> include/linux/minmax.h:76:17: note: in expansion of macro '__clamp_once'
>    76 |                 __clamp_once(val, lo, hi, __UNIQUE_ID(__val),
>          \
>       |                 ^~~~~~~~~~~~
> include/linux/minmax.h:180:36: note: in expansion of macro '__careful_clamp'
>   180 | #define clamp_t(type, val, lo, hi)
> __careful_clamp((type)(val), (type)(lo), (type)(hi))
>       |                                    ^~~~~~~~~~~~~~~
> drivers/net/wireless/ralink/rt2x00/rt2800lib.c:3993:24: note: in
> expansion of macro 'clamp_t'
>  3993 |                 return clamp_t(char, txpower, MIN_A_TXPOWER,
> MAX_A_TXPOWER);
>       |                        ^~~~~~~
> 

Thanks, I've added a commit that should resolve this now.  I'll push out
a -rc2 in a bit.

greg k-h
