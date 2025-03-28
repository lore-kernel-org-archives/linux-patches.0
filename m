Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B65C1BBBE5;
	Fri, 28 Mar 2025 14:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743172938; cv=none; b=tQDTLhYNlkFaSp9IByJiqWHPHMqtkpjnwcmtPSc0ZAxTq1sVHGjs7sqV+GXzp+IPLdBr9hf3vxe8A4reLEtM20KJeaG6UZ9F/5HRFNjPSmm6PSARUOHBeMKnexWlvTcTVMYxGZ/q4wPG8GT4kH3OHhW//UwYgZnFhc8UABJkJy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743172938; c=relaxed/simple;
	bh=9kl9o647WBVi548Ir5Sz2CygoNnflg8magY1k477qBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ooPokj0zep4eCHjYm8RxnzyIUSHdanFYm129eQITFtfCbIeD5Md0DrdFX45L90ldCXiaCE4xu4FrdBk4aZ/FmKndUmdqEvg6+as+qv5T/YaCy8QdqtnWAnryo1xDlkQa2mB4o3yyqPpzTIpgiAGOfx43Gp0zdLSQf6REZ3f9ito=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9Tgunk3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9Tgunk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F53DC4CEE4;
	Fri, 28 Mar 2025 14:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743172937;
	bh=9kl9o647WBVi548Ir5Sz2CygoNnflg8magY1k477qBI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A9Tgunk3IvOuhlHzCGe3HJEBbzKK2BRsm6955AIW1LwcAsE4aWE259TDrg9n7/RpO
	 xi2Jz47HlKlgmUcydIhlTmkIRLzEVIhpkMQIwooCELNvNfQmoMXgQ0EeQLTfDDibc/
	 FbA+8iMvaH7/++QEV+1qi9/k/xQtiZCgkWnFvucQ=
Date: Fri, 28 Mar 2025 15:42:14 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.1 000/197] 6.1.132-rc3 review
Message-ID: <2025032803-crafter-perceive-a756@gregkh>
References: <20250328074420.301061796@linuxfoundation.org>
 <e0a881cf-8a00-418d-a10d-c088bfc1059e@rnnvmail201.nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0a881cf-8a00-418d-a10d-c088bfc1059e@rnnvmail201.nvidia.com>

On Fri, Mar 28, 2025 at 07:23:49AM -0700, Jon Hunter wrote:
> On Fri, 28 Mar 2025 08:47:06 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.132 release.
> > There are 197 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 30 Mar 2025 07:43:56 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.132-rc3.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v6.1:
>     10 builds:	10 pass, 0 fail
>     28 boots:	28 pass, 0 fail
>     115 tests:	115 pass, 0 fail
> 
> Linux version:	6.1.132-rc3-g0c858fc73636
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>                 tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Finally!  :)

Thanks for testing.

greg k-h
