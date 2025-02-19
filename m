Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDC61C84A9;
	Wed, 19 Feb 2025 13:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739971212; cv=none; b=H8T0V61L+RBYcpa5u5Ls21dmraaFnhWRFph1RWjHNtnb4SiuT4fUl6fmPShX8Myf/ZmQZEJeRLZPxDdFgYgxyysYPmKO73MS6DYXRd+nYR0xHdxAAro01dMDuTjTonECL+XzfnbaMd8DjUAEXB7DpiLBMWbaEObICVRSTO5Vi5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739971212; c=relaxed/simple;
	bh=iwz/3KbcNFHe2OflQmNBcT9Wd5TDScmLlAHS2b4bhpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kzWmZPNk4mdesMdGYwHb8mz1rb/POY5LTKLKTu7r9jTNfGsUF0BfJV7ZGBSMNLMIOi8t33W+l9n/fBz/UXoc2WClOv9QSSf4CK3xVTeIdZvYTT22QQgrKlbxHnNSi13y3ZBeW9Z27ssZNWVDpyBipicsqRsdrIsp5s9teIIsA2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VN6E63tF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VN6E63tF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D6BC4CED1;
	Wed, 19 Feb 2025 13:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739971212;
	bh=iwz/3KbcNFHe2OflQmNBcT9Wd5TDScmLlAHS2b4bhpk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VN6E63tFCNi7PIutUfSSECzx403ZRowSF9svdgD2wzjfL3lNoLs4QauUhfBwOmxvq
	 L77Jrh3Bmq4TiaLoulqNFOWs5ldJDe0PFt2km6Dx/aREUDefVdqtRgou8TxuaLE/83
	 VyQHPfLd9AEkgFKUKb796IIr6FytWBQTb7VYZWy8=
Date: Wed, 19 Feb 2025 14:20:09 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.12 000/230] 6.12.16-rc1 review
Message-ID: <2025021938-prowling-semisoft-0d2b@gregkh>
References: <20250219082601.683263930@linuxfoundation.org>
 <b5a72621-a76a-41a1-a415-5ab1cabf0108@rnnvmail201.nvidia.com>
 <9836adde-8d67-48b5-944b-1b9f107434a8@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9836adde-8d67-48b5-944b-1b9f107434a8@nvidia.com>

On Wed, Feb 19, 2025 at 01:12:41PM +0000, Jon Hunter wrote:
> Hi Greg,
> 
> On 19/02/2025 13:10, Jon Hunter wrote:
> > On Wed, 19 Feb 2025 09:25:17 +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.12.16 release.
> > > There are 230 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.16-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Failures detected for Tegra ...
> > 
> > Test results for stable-v6.12:
> >      10 builds:	10 pass, 0 fail
> >      26 boots:	26 pass, 0 fail
> >      116 tests:	115 pass, 1 fail
> > 
> > Linux version:	6.12.16-rc1-gcf505a9aecb7
> > Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> >                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
> >                  tegra20-ventana, tegra210-p2371-2180,
> >                  tegra210-p3450-0000, tegra30-cardhu-a04
> > 
> > Test failures:	tegra186-p2771-0000: pm-system-suspend.sh
> 
> 
> The following appear to have crept in again ...
> 
> Juri Lelli <juri.lelli@redhat.com>
>     sched/deadline: Check bandwidth overflow earlier for hotplug
> 
> Juri Lelli <juri.lelli@redhat.com>
>     sched/deadline: Correctly account for allocated bandwidth during hotplug

Yes, but all of them are there this time.  Are you saying none should be
there?  Does 6.14-rc work for you with these targets?

thanks,

greg k-h
