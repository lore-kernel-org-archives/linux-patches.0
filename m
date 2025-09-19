Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3C81862A;
	Fri, 19 Sep 2025 07:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758266361; cv=none; b=K1AWFrXfoVgNCzkY75kg7PqUoLv9j2V5ATzQUb3rnRwG6LlvkVBEk5rWqdk5XsV+eLa63ZpMbrZfalbrsJA2YU66rPl8u+FjEs56naCxOfq+hjUqLd6SXmg2B8u3BpHSCB277Ud65U58X2XS+iAimUODnbDaUnHOtnDu6Ys1ejI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758266361; c=relaxed/simple;
	bh=h8IcExnL+ufUC/sHx295zmDgmYauyGFmpVaWBmtGSTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AZwmEF+Gl4XfsUKDPuRJyHVS3+j/UegeIoG0KNKGFK7XfFCD9KnJGi0fAPlcHao4PkRxO3kce0B16/LNwXHI3Br3Cn8AqFhzSLQ4RED1oYvoyt/KGlyxBJWZQStQOxt1YwEp7YgmxnZYJX6s97ZVRL+GHawag3GKj+36kbmKHME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LIGtAXJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LIGtAXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F91C4CEF0;
	Fri, 19 Sep 2025 07:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758266360;
	bh=h8IcExnL+ufUC/sHx295zmDgmYauyGFmpVaWBmtGSTQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0LIGtAXJ1K5y+wMv+yLAQ2cmknYeP4bryMH2uopDreHp/jnIL9xdM4f437xCNBBRE
	 VxHQn7BWxAuCRUwbA/eF8PUNti8J6zUm42cE16VJwX5zmxV6jFZD6CGSHMJd6yInu5
	 ei5iQdvr79UBfkGBiPltwpeAvlFVpzDfrhuuJOO4=
Date: Fri, 19 Sep 2025 09:19:16 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anders Roxell <anders.roxell@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.1 00/78] 6.1.153-rc1 review
Message-ID: <2025091903-relish-neuron-30e5@gregkh>
References: <20250917123329.576087662@linuxfoundation.org>
 <CADYN=9Li3gHMJ+weE0khMBmpS1Wcj-XaUeaUZg2Nxdz0qY9sdg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADYN=9Li3gHMJ+weE0khMBmpS1Wcj-XaUeaUZg2Nxdz0qY9sdg@mail.gmail.com>

On Thu, Sep 18, 2025 at 03:28:01PM +0200, Anders Roxell wrote:
> On Wed, 17 Sept 2025 at 15:01, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.153 release.
> > There are 78 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.153-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> While building Linux stable-rc 6.1.153-rc1 the s390 allmodconfig with
> clang-20 toolchain build failed.
> 
> Regression Analysis:
> - New regression? yes
> - Reproducibility? yes
> 
> Build regression: s390 clang-20-allmodconfig
> 
> Build error:
> arch/s390/kernel/perf_cpum_cf.c:556:10: error: variable 'err' is
> uninitialized when used here [-Werror,-Wuninitialized]
>   556 |                 return err;
>       |                        ^~~
> arch/s390/kernel/perf_cpum_cf.c:553:9: note: initialize the variable
> 'err' to silence this warning
>   553 |         int err;
>       |                ^
>       |                 = 0
> 1 error generated.
> 
> The bad commit pointing to,
>   s390/cpum_cf: Deny all sampling events by counter PMU
>   [ Upstream commit ce971233242b5391d99442271f3ca096fb49818d ]

Thanks for the info, I'll go drop this patch from the queue.

greg k-h
