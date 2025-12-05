Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E281662E7;
	Fri,  5 Dec 2025 16:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764952411; cv=none; b=DuICwyERoqhVkfLRKgeq7/lWZgXrrAZVXAhTJN8xqZSBPOTDOICXBnwi4TZZcl5UZsq//vZBW8hmnpPbWt0FPX4Wcv0ZngRoLSB//a2YZULqcpmwmjYlmtB5Uxl9TjqkZyZIwCQAPW2qNSi0QK0626VvCo49QdQAg3iHv9KzPJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764952411; c=relaxed/simple;
	bh=6Ycwqt1Z1LrHSIT+fXB6D7RhVa2v5J+69q+B9no9tqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nUumuFnEzcOuffhymRgB3M6dhfwLW7nzz5xv8Gqfu003ySrCXx8c94AF8woFmsNPXOkeug4tsGcHrHlk1KpyxouD4j/2gRk3H7+OcNPHtXggpBCNw9D/bGBApmYclydhIesfNBQ9lotu1wOXO6yt3nQBxXJJjlB2q3GlQLkI7Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3F1kx55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3F1kx55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72F8C116B1;
	Fri,  5 Dec 2025 16:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764952409;
	bh=6Ycwqt1Z1LrHSIT+fXB6D7RhVa2v5J+69q+B9no9tqw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E3F1kx553V0e4rRFHGF/hGzd+Q0Rh3Th2kEhUdqUDE82C8c0TkxTLp5UtgQVs87K5
	 ICatCkc6L9qUyKohotHOY5F4U2aYTFTXro334lkaOcf49mTj8cHbqF/e4ub7WanLhI
	 rw/hlC7ta4tDot4snvWkP38AbMF+WJWdTp8Ib95Y=
Date: Fri, 5 Dec 2025 17:33:19 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Ben Copeland <benjamin.copeland@linaro.org>
Subject: Re: [PATCH 5.15 000/387] 5.15.197-rc2 review
Message-ID: <2025120553-sulphate-cancel-0f77@gregkh>
References: <20251204163821.402208337@linuxfoundation.org>
 <CA+G9fYvz4R6SRM0ZZ6xDtnFcHo-RdQkrE3b9WTM0RCgWNiuieQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvz4R6SRM0ZZ6xDtnFcHo-RdQkrE3b9WTM0RCgWNiuieQ@mail.gmail.com>

On Fri, Dec 05, 2025 at 12:59:37PM +0530, Naresh Kamboju wrote:
> On Thu, 4 Dec 2025 at 22:14, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.197 release.
> > There are 387 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 06 Dec 2025 16:37:24 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.197-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> The powerpc allnoconfig failed with gcc-8 but passed with gcc-12.
> 
> Build regression: powerpc: allnoconfig: gcc-8: Inconsistent kallsyms data
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ### Build error Powerpc
> Inconsistent kallsyms data
> Try make KALLSYMS_EXTRA_PASS=1 as a workaround
> make[1]: *** [Makefile:1244: vmlinux] Error 1
> 
> ### Commit pointing to,
>   Makefile.compiler: replace cc-ifversion with compiler-specific macros
>   commit 88b61e3bff93f99712718db785b4aa0c1165f35c upstream.
> 
> ### Build
>  - https://storage.tuxsuite.com/public/linaro/lkft/builds/36OCnVeYGpKUCXtxVdz6gezHjcQ/
>  - https://storage.tuxsuite.com/public/linaro/lkft/builds/36OCnVeYGpKUCXtxVdz6gezHjcQ/config
> 
> ### Steps to reproduce
>  - tuxmake --runtime podman --target-arch powerpc --toolchain gcc-8
> --kconfig allnoconfig

Odd, this works on 5.10 ok?  What is different about 5.15 that keeps
this from working?

thanks,

greg k-h
