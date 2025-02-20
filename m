Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B10D1EB9FD;
	Thu, 20 Feb 2025 10:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740047647; cv=none; b=AwNYamh1Cc4y57TSE3epARmZBu95+FQbwJWgLBHYGHTP7K8btgzOJFIbWcsHctj1qIYOcGoD6SirG3QUcEujDpPz0YDnJad+Qs/9ltd/xqrbZlSSOd8ZKFGzvGIQgL4WRusHqdYE2c2BSkUGC+VT6ipoE46/GSWfBGMK+0tPj24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740047647; c=relaxed/simple;
	bh=K31js+Y/EcBO6V3WQ4R9CBWdey1VZsrQnmVOn6z2drg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HOIE0uxv3eXraFruPR+G5b7ZbHmk6c54IEoIQ9Ci4f6np4FGzyYAhsofJdn0iQyR7wZNcLhfYgAkTYW6e+OiN4a3MyZ+A2pRBhLAnGNq56honddWtje5xH/KevvWfOpBRKo+v6dwBAiHIv7A5rJDTAbkedwZ1IbKUWHCKMrYRuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5FBJtwn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5FBJtwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2C5C4CED1;
	Thu, 20 Feb 2025 10:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740047646;
	bh=K31js+Y/EcBO6V3WQ4R9CBWdey1VZsrQnmVOn6z2drg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l5FBJtwnQRa2oa4TkBtzPqEQv/qNNXlRPLkkKK+OvNPMg7rNhv4c0apJq4h9kp4pY
	 5LzD/syGrCZYHf5mJKusog796GVFkkwEkYNgsQdnmnKX9R4Z8My0TJiiO4IdbUBjpU
	 xj+nvjdayRN7I3VRW1OmK3mY5MOngmApCi7CrCBA=
Date: Thu, 20 Feb 2025 11:34:04 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.12 000/230] 6.12.16-rc1 review
Message-ID: <2025022040-vintage-dissuade-bcc4@gregkh>
References: <20250219082601.683263930@linuxfoundation.org>
 <b5a72621-a76a-41a1-a415-5ab1cabf0108@rnnvmail201.nvidia.com>
 <9836adde-8d67-48b5-944b-1b9f107434a8@nvidia.com>
 <2025021938-prowling-semisoft-0d2b@gregkh>
 <b686ddb5-aeff-47c2-ba94-b6be9dbafcc1@nvidia.com>
 <2bb3354c-7f77-b07f-55b2-ac3bf5159532@applied-asynchrony.com>
 <15f46da3-8744-4aac-bc2e-ecf06ea3367d@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <15f46da3-8744-4aac-bc2e-ecf06ea3367d@nvidia.com>

On Wed, Feb 19, 2025 at 02:04:23PM +0000, Jon Hunter wrote:
> 
> On 19/02/2025 13:55, Holger Hoffstätte wrote:
> > On 2025-02-19 14:32, Jon Hunter wrote:
> > > 
> > > On 19/02/2025 13:20, Greg Kroah-Hartman wrote:
> > > > On Wed, Feb 19, 2025 at 01:12:41PM +0000, Jon Hunter wrote:
> > > > > Hi Greg,
> > > > > 
> > > > > On 19/02/2025 13:10, Jon Hunter wrote:
> > > > > > On Wed, 19 Feb 2025 09:25:17 +0100, Greg Kroah-Hartman wrote:
> > > > > > > This is the start of the stable review cycle for the 6.12.16 release.
> > > > > > > There are 230 patches in this series, all will be
> > > > > > > posted as a response
> > > > > > > to this one.  If anyone has any issues with these
> > > > > > > being applied, please
> > > > > > > let me know.
> > > > > > > 
> > > > > > > Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
> > > > > > > Anything received after that time might be too late.
> > > > > > > 
> > > > > > > The whole patch series can be found in one patch at:
> > > > > > >     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/
> > > > > > > patch-6.12.16-rc1.gz
> > > > > > > or in the git tree and branch at:
> > > > > > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> > > > > > > stable-rc.git linux-6.12.y
> > > > > > > and the diffstat can be found below.
> > > > > > > 
> > > > > > > thanks,
> > > > > > > 
> > > > > > > greg k-h
> > > > > > 
> > > > > > Failures detected for Tegra ...
> > > > > > 
> > > > > > Test results for stable-v6.12:
> > > > > >       10 builds:    10 pass, 0 fail
> > > > > >       26 boots:    26 pass, 0 fail
> > > > > >       116 tests:    115 pass, 1 fail
> > > > > > 
> > > > > > Linux version:    6.12.16-rc1-gcf505a9aecb7
> > > > > > Boards tested:    tegra124-jetson-tk1, tegra186-p2771-0000,
> > > > > >                   tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
> > > > > >                   tegra20-ventana, tegra210-p2371-2180,
> > > > > >                   tegra210-p3450-0000, tegra30-cardhu-a04
> > > > > > 
> > > > > > Test failures:    tegra186-p2771-0000: pm-system-suspend.sh
> > > > > 
> > > > > 
> > > > > The following appear to have crept in again ...
> > > > > 
> > > > > Juri Lelli <juri.lelli@redhat.com>
> > > > >      sched/deadline: Check bandwidth overflow earlier for hotplug
> > > > > 
> > > > > Juri Lelli <juri.lelli@redhat.com>
> > > > >      sched/deadline: Correctly account for allocated
> > > > > bandwidth during hotplug
> > > > 
> > > > Yes, but all of them are there this time.  Are you saying none should be
> > > > there?  Does 6.14-rc work for you with these targets?
> > 
> > > The 1st one definitely shouldn't. That one is still under debug for
> > > v6.14 [0]. I can try reverting only that one and seeing if it now
> > > passes with the 2nd.
> > Most certainly not - you need all three or none:
> > https://lore.kernel.org/stable/905eb8ab-2635-e030-b671-
> > ab045b55f24c@applied-asynchrony.com/
> > 
> > > [0] https://lore.kernel.org/linux-tegra/ba51a43f-796d-4b79-808a-
> > > b8185905638a@nvidia.com/
> > 
> > I was about to link to that.. please try 6.14-rc and see if it works for
> > you.
> 
> 6.14-rc is still failing for this board. Like I said, and per the above
> thread, that issue is still being debugged.

Ok, I'm dropping them all from both 6.13 and 6.12 now and will push out
-rc2 versions soon.

thanks,

greg k-h
