Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14D2189919;
	Thu, 24 Apr 2025 13:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745502085; cv=none; b=tUACv1WdjKX8iZOVw+a1zHL9wMT9FJkj5lzCPMJra02DmzEks23XbTqh0nV1KliNKs8ldwIy2PX/hRaR5Rj3o920fIxpa3cVfG3RsSFeCQf4dnsmt9jd0g6iESOPL692fKOt+9GVLBwPGGEVSJ6fqHxZdlNcqNYJCkmCII4Dk3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745502085; c=relaxed/simple;
	bh=bdQNYTaUzzRiAQCmfYBaszlqWTTCoAZXMgPfghYxtTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gHLDwjp0K3UVRgDMxCj1HtI2OQfflKfTOt8SaV8JHN4Ob5Zf5LLn73+k/4MubJvrtSBc7m1eFxwGM09QzFYDdRpK2zTTO5wVuvtNnMSm4KUtZPtNReB+PK04ije7raMbqch+ysNRhQSylL6cs4B5DKu8kzvatIyUUa/CFFzfoNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KpFe0eR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KpFe0eR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA10EC4CEE8;
	Thu, 24 Apr 2025 13:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745502084;
	bh=bdQNYTaUzzRiAQCmfYBaszlqWTTCoAZXMgPfghYxtTY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KpFe0eR3pfCo+R4TmueP5vPRf9uXEUXBWEsFZgINejfzgcE6wDG3dNxaUjI2Dkfxe
	 8TYZ8UrBgLEe5sQC5hbWpTVlYm5aqi2i4cAePTXQdsomwCMqkxaPCM/Syg3Ax8LWNq
	 nUW1Mpos8LeVuuKOj5Q6K3hnsCldn51rYk56uv14=
Date: Thu, 24 Apr 2025 15:41:22 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Netdev <netdev@vger.kernel.org>,
	clang-built-linux <llvm@lists.linux.dev>,
	Anders Roxell <anders.roxell@linaro.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 6.1 000/291] 6.1.135-rc1 review
Message-ID: <2025042443-ibuprofen-scavenger-c4df@gregkh>
References: <20250423142624.409452181@linuxfoundation.org>
 <CA+G9fYu+FEZ-3ye30Hk2sk1+LFsw7iO5AHueUa9H1Ub=JO-k2g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYu+FEZ-3ye30Hk2sk1+LFsw7iO5AHueUa9H1Ub=JO-k2g@mail.gmail.com>

On Thu, Apr 24, 2025 at 07:01:02PM +0530, Naresh Kamboju wrote:
> On Wed, 23 Apr 2025 at 20:16, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.135 release.
> > There are 291 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.135-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Regressions on arm, riscv and x86_64 with following kernel configs with
> clang-20 and clang-nightly toolchains on stable-rc 6.1.135-rc1.
> 
> Build regressions:
> * arm, build
>   - clang-20-allmodconfig
> 
> * i386, build
>   - clang-nightly-lkftconfig-kselftest
> 
> * riscv, build
>   - clang-20-allmodconfig
> 
> * x86_64, build
>   - clang-20-allmodconfig
>   - clang-nightly-lkftconfig-kselftest
> 
> Regression Analysis:
>  - New regression? Yes
>  - Reproducibility? Yes
> 
> Build regression: arm allmodconfig variable 'is_redirect' is used
> uninitialized whenever 'if' condition is true
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ## Build error:
> net/sched/act_mirred.c:265:6: error: variable 'is_redirect' is used
> uninitialized whenever 'if' condition is true
> [-Werror,-Wsometimes-uninitialized]
>   265 |         if (unlikely(!(dev->flags & IFF_UP)) ||
> !netif_carrier_ok(dev)) {
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Odd this isn't showing up in newer releases, as this is an old commit
and nothing has changed in this file since then (it showed up in 6.8.)

Is there some follow-up commit somewhere that I'm missing that resolved
this issue?

thanks,

greg k-h
