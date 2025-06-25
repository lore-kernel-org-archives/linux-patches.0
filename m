Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07E42750F8;
	Wed, 25 Jun 2025 08:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750841572; cv=none; b=ZEgyFaqWlEs7dbssdoQ0IsZwdxlD2qEW2bkb8GNv0ntFkU0xwxwr/sjlgTN50q31WEW5wCYzUuH0VTbhj3oV0bxhRsK5+MsX6yK6DmV7IexaSPuWmX/PI8ChrNvs+XVMVq96wCM36ruPbmDt7/01nBHhBsgNsgrZRqAQiuADf6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750841572; c=relaxed/simple;
	bh=SF3bLEabkpsMFTOBi7CdbNK4kPMG1GvDh9vgEQ/j9xM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZGGKCqiuzaWasCXNVIyV3aY6vd/yTWnYXNe6NP0H/RHHOG43AinIqlvz4F2Hk+vviOw8OYE05bhfY8H975tdRHHp+MSzdasoeTkNA49ZykewizTbDzYQgokjOvGD2kVlG7bRqjBfVoY/l5Lm6miC+NYehT3xvMN9QPilPdtrw64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ilQxjYbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ilQxjYbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF550C4CEEA;
	Wed, 25 Jun 2025 08:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750841571;
	bh=SF3bLEabkpsMFTOBi7CdbNK4kPMG1GvDh9vgEQ/j9xM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ilQxjYbWiAqEXKQVEksDS67eR3x2Rz+JpKAEMXa3PUr4dzW3lHpUKjqwVJkVpaWqT
	 TJtEkP3k49gedFELsxQnqiB7KWfiO/jtgBekLKy1MbXdi2a6qRwn0h0UE1UCxS/1jo
	 k2yH6HZhXfVebcZy7KWxZrEUrwa0ZqnBOnAQR9dY=
Date: Wed, 25 Jun 2025 09:52:49 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/222] 5.4.295-rc1 review
Message-ID: <2025062530-friend-certainly-f8e4@gregkh>
References: <20250623130611.896514667@linuxfoundation.org>
 <cf271495-270e-4a0a-a93e-fe8c44e4eabd@rnnvmail204.nvidia.com>
 <c84768f2-17d7-4edd-8f6e-d0f2a74ef559@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c84768f2-17d7-4edd-8f6e-d0f2a74ef559@nvidia.com>

On Wed, Jun 25, 2025 at 08:34:47AM +0100, Jon Hunter wrote:
> Hi Greg,
> 
> On 25/06/2025 08:16, Jon Hunter wrote:
> > On Mon, 23 Jun 2025 15:05:35 +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.4.295 release.
> > > There are 222 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 25 Jun 2025 13:05:50 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.295-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Failures detected for Tegra ...
> > 
> > Test results for stable-v5.4:
> >      10 builds:	7 pass, 3 fail
> >      18 boots:	18 pass, 0 fail
> >      39 tests:	39 pass, 0 fail
> > 
> > Linux version:	5.4.295-rc1-gca8c5417d1e6
> > Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> >                  tegra194-p2972-0000, tegra20-ventana,
> >                  tegra210-p2371-2180, tegra210-p3450-0000,
> >                  tegra30-cardhu-a04
> > 
> > Builds failed:	arm+multi_v7
> 
> 
> I am seeing the following build error for ARM with the
> multi_v7_defconfig on our builders ...
> 
>   CC      drivers/firmware/qcom_scm-32.o
> /tmp/cc9gP1cd.s: Assembler messages:
> /tmp/cc9gP1cd.s:45: Error: selected processor does not support `smc #0' in ARM mode
> /tmp/cc9gP1cd.s:94: Error: selected processor does not support `smc #0' in ARM mode
> /tmp/cc9gP1cd.s:160: Error: selected processor does not support `smc #0' in ARM mode
> /tmp/cc9gP1cd.s:295: Error: selected processor does not support `smc #0' in ARM mode
> make[3]: *** [/home/jonathanh/nvidia/mlt-linux_next/kernel/scripts/Makefile.build:262: drivers/firmware/qcom_scm-32.o] Error 1
> 
> 
> Bisect is pointing to ...
> 
> # first bad commit: [0c23125c509b41be51f0d5acb843b079a098a40c] kbuild: Update assembler calls to use proper flags and language target
> 
> Reverting this fixes it but I also needed to revert the following due to dependencies ...
> 
> Nathan Chancellor <nathan@kernel.org>
>     kbuild: Add KBUILD_CPPFLAGS to as-option invocation
> 
> Nathan Chancellor <nathan@kernel.org>
>     kbuild: Add CLANG_FLAGS to as-instr

I've also dropped the others in this series and will push out a -rc2
soon, thanks for testing and letting me know.

greg k-h
