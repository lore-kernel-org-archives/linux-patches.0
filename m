Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BB11B3958;
	Tue, 15 Oct 2024 17:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729012667; cv=none; b=gjIb6DtREsfESbJmTAO1lnspOFC5Zao84a5mieW3vGhQZwSCnYkLGIMmJF6RyKI72togyYnmKzeFEmGDuDYrFUismL4Uz5NY9e+ejROUshilQoItU7HIYZxRtnQoUxG48WrJ7XQ9hg7S84z1N02/vJd+FCn+KWp+pQnaJUaywvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729012667; c=relaxed/simple;
	bh=/ku1QJJyjsdv1wJAg84kaOn4NlsIWmhliRYpAdq6WHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qK/cWJYDXri21H40hDYe+gLlgc8DWm7W41ynJfYSYxW6DSTFwPUuFIFMAq1HpS7k0f8uEIW6mv4KN/Zcqdmo9Ccgj4UE9+NOBtn5ndmhxR13nKND7YurfL3ZpjJP2aG5DIqbSOYf6NeUoLqWXLIAoI4Uufn8e2h1YWNa0H1FXn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8C72noa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8C72noa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66849C4CEC6;
	Tue, 15 Oct 2024 17:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729012667;
	bh=/ku1QJJyjsdv1wJAg84kaOn4NlsIWmhliRYpAdq6WHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l8C72noaafaYPZAMjDj2Ce2P0OB3y8Kq54MbV9d6UNhbIVKojKtEoc3UcWwkniYwY
	 hSBpBLMt+rw+04hL91yk8TsTQmMtfkrARYNqOlEDAOJgkcg2zYGb7z6/CLr/xMJ0mB
	 UbPlcbkVAt5DSbLzBjuC+dHTGup+Bfp88VeKBMv4=
Date: Tue, 15 Oct 2024 19:17:44 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 000/691] 5.15.168-rc1 review
Message-ID: <2024101515-timothy-overdrawn-b3f7@gregkh>
References: <20241015112440.309539031@linuxfoundation.org>
 <43399648-ea75-4717-b155-73541deacaba@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43399648-ea75-4717-b155-73541deacaba@gmail.com>

On Tue, Oct 15, 2024 at 10:09:15AM -0700, Florian Fainelli wrote:
> On 10/15/24 04:19, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.168 release.
> > There are 691 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.168-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> perf fails to build with:
> 
>   CC /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/evsel.o
> util/evsel.c: In function 'evsel__set_count':
> util/evsel.c:1505:14: error: 'struct perf_counts_values' has no member named
> 'lost'
>  1505 |         count->lost   = lost;
>       |              ^~
> make[6]: *** [/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/build/Makefile.build:97: /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/evsel.o]
> Error 1
> 
> seems like we need to backport upstream
> 89e3106fa25fb1b626a7123dba870159d453e785 ("libperf: Handle read format in
> perf_evsel__read()") to add the 'lost' member.

Is this new?  I can't build perf on any older kernels, but others might
have better luck...

thanks,

greg k-h
