Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793539337;
	b=3s4VVZfbBBzo4sPjp9HEADMAa094rELzg1cYq4n30RCz66dWIP1VIN7N8A6LLOz32Umf
	 MjRAYpixiFOyZjASh5orXGEH92eh2IWKVCq0b383T3SuePTmFOVZrrzKA3//qgkjrOmw3
	 CQk4MMWdJonQ1JeWB7CEzTIq6qfFoxpaenAQUCRelJXgEh96YuQELi1CehWOfCk2Ty9Gk
	 BGQ7ooa+xvgjbFcZYIbcvkzI95OsES++h7e2ER24BEUX+hhR6F7xlrsmX7m+oBUsd9gIo
	 L6fIGabz4mHZr6Y8CmjvwsfKbQGLLEO+SE3/IIH39NsTA0k/gT1QsNPLrbb1oTdNMpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793539337;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=geaEcMEl+ei9wD9S1s+3XncmzaUwEsl7gr6NPS3NXfE=;
	b=iMDmGMOX2eYDsyPQAgzJMy5kbc283/k7wswtWJbLy+G8VlbcVD/ADNRArnNLtzqWvEn3
	 jVJwyE7daeJsU8El5cZ7c5uJN0uEBu5KGTvwDADKpq/292l1sdBTZ7TQtzVWT+z1KaC5U
	 aCbY3aEO7ExGwckQgMARv3/sSKe0SENEuRZ9VMJwgTeeD7BiYuexqjThLFCSWEAoFY3Gk
	 FVbzlVM99zEQfVcMGrEjPCGA79QWZfAsLUmolpE/mXfp6aPLNMLfPElQ+ew+p8N46fMhK
	 xr+sWZX+zSabfaC/wdwQ1YpJA0+N5QjIYVxG9Ng/UbI8pTEOAL38H5DCc0qkrzp3Ytg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVrvuxww;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228C7606A324;
	Sun,  1 Nov 2026 13:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVrvuxww
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276FE1F000C1;
	Sun,  1 Nov 2026 13:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793539336;
	bh=geaEcMEl+ei9wD9S1s+3XncmzaUwEsl7gr6NPS3NXfE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cVrvuxww8pnRK8W8x2t2hHp3nWnOObG7ci5vh7APplcjlzy9fqeTywZQJf+Xmu24J
	 XFRDFRwlcj5L1TgovuM5MJ/rsQAK9Y/dkxsQPRsq3lCJ1yoKJjTldceJSuvSdkxzgn
	 e37XNI70rypRxMH116kaNz3AUqiNODedec8pJk8Q=
Date: Sun, 1 Nov 2026 14:22:10 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, sr@sladewatkins.com, linux-tegra@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 6.1 0000/1879] 6.1.191-rc2 review
Message-ID: <2026110101-carnivore-harsh-fe38@gregkh>
References: <20261029073135.159947193@linuxfoundation.org>
 <b85e0697-d669-4b14-859f-52ee295264e4@rnnvmail201.nvidia.com>
 <80816b31-948c-45a8-9f98-4cc55f5bd530@nvidia.com>
 <7e927599-10b7-44f4-828f-e50c0caf5f27@nvidia.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e927599-10b7-44f4-828f-e50c0caf5f27@nvidia.com>

On Sat, Oct 31, 2026 at 02:41:43PM +0000, Jon Hunter wrote:
> Hi Greg,
> 
> On 31/10/2026 09:26, Jon Hunter wrote:
> 
> ...
> 
> > On 31/10/2026 09:24, Jon Hunter wrote:
> >> On Thu, 29 Oct 2026 08:33:04 +0100, Greg Kroah-Hartman wrote:
> >>> This is the start of the stable review cycle for the 6.1.191 release.
> >>> There are 1879 patches in this series, all will be posted as a response
> >>> to this one.  If anyone has any issues with these being applied, please
> >>> let me know.
> >>>
> >>> Responses should be made by Sat, 31 Oct 2026 07:28:30 +0000.
> >>> Anything received after that time might be too late.
> >>>
> >>> The whole patch series can be found in one patch at:
> >>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.191-rc2.gz
> >>> or in the git tree and branch at:
> >>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> >>> and the diffstat can be found below.
> >>>
> >>> thanks,
> >>>
> >>> greg k-h
> >>
> >> Failures detected for Tegra ...
> >>
> >> Test results for stable-v6.1:
> >>     builds:	9 pass, 0 fail
> >>     boots:	28 pass, 4 fail
> >>     tests:	83 pass, 7 fail
> >>
> >> Linux version:	6.1.191-rc2-g3b00df762ebc
> >> Boards tested:	tegra20-ventana
> >>                 tegra30-cardhu-a04
> >>                 tegra124-jetson-tk1
> >>                 tegra210-p2371-2180
> >>                 tegra210-p3450-0000
> >>                 tegra186-p2771-0000
> >>                 tegra186-p3509-0000+p3636-0001
> >>                 tegra194-p2972-0000
> >>                 tegra194-p3509-0000+p3668-0000
> >>
> >> Boot failures:	tegra186-p2771-0000, tegra186-p3509-0000+p3636-0001,
> >>                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000
> >>
> >> Test failures:	tegra124-jetson-tk1: pm-system-suspend.sh
> >>                 tegra20-ventana: pm-system-suspend.sh
> >>                 tegra30-cardhu-a04: pm-system-suspend.sh
> > I am looking into the above boot and suspend issues and will let you
> > know what I find.
> 
> Bisecting is pointing to the below commit and reverting it fixes
> the above issues ...
> 
> # first bad commit: [26c5e136ba4e94ad708333c9bd34039a1de397b0] net: stmmac: protect updates of 64-bit statistics counters

Thanks, I've reverted that one now.

greg k-h
