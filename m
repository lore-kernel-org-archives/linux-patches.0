Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CA9273D72;
	Wed, 16 Jul 2025 16:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752681804; cv=none; b=RP2ZjJtZCBJregNBRLFiHOOsGomDktpuOncsuC6QOdVhpZaZ8zKKEvK7qT1w9xWbJAL9ctQcdfGyjSUKSc9werdY+EpDH0O/tW8Jb3oY+5YZ4dzIjPeLd1bos2jHpqTk6Q3ssFlnk4RtbofwEKiUxmkMxswdbWBn5KQwCnbYQrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752681804; c=relaxed/simple;
	bh=KL25neQjHRVRH2nUFQQtiz/QXFM6VYw4vVZ7aot5Efs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MEfwt8BnSbvUqYgKzwuqi1BRJxW5JPC+6rxlEIMltTXIrTOil0eBE9DDizxjyxAIqDXWmkZA75q916slGiluVeJXnNqDbFnjH1Fvl5T1rjdiULtwg9z1xTBy4mDzKCP5+KDgTmCGWOowUPzdoPOo3dLboxeQGBfHMN+FvhvjvXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HScafhf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HScafhf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9368C4CEE7;
	Wed, 16 Jul 2025 16:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752681804;
	bh=KL25neQjHRVRH2nUFQQtiz/QXFM6VYw4vVZ7aot5Efs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HScafhf/0x3WqH21Y6vNQNCNvXjtSXrLhS/QM1UDk64QdHvoejPNRhkufa6TKPhUE
	 CMCx9oQKkDphCjPy4fQDLbLrbk4OSbQjG5DVhfj5A2GJWJgOnaoB1HiQQvUGR7tPU4
	 fzBgDnlf6nFULZugUlA368UaKDmzksLRyS0r87is=
Date: Wed, 16 Jul 2025 18:03:21 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/144] 5.4.296-rc2 review
Message-ID: <2025071615-footprint-ranging-ff94@gregkh>
References: <20250716141302.507854168@linuxfoundation.org>
 <36661855-6678-4fdf-81e0-55d86ae40009@rnnvmail205.nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36661855-6678-4fdf-81e0-55d86ae40009@rnnvmail205.nvidia.com>

On Wed, Jul 16, 2025 at 08:42:50AM -0700, Jon Hunter wrote:
> On Wed, 16 Jul 2025 16:14:18 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.296 release.
> > There are 144 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 18 Jul 2025 14:12:35 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.296-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.4:
>     10 builds:	10 pass, 0 fail
>     24 boots:	24 pass, 0 fail
>     54 tests:	54 pass, 0 fail
> 
> Linux version:	5.4.296-rc2-g6d1abaaa322e
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Great, thanks for the quick test!
