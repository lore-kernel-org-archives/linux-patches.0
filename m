Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F33C18641;
	Thu,  1 May 2025 07:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746085634; cv=none; b=QbNnd5gRtq4+ox0xPg8HqiwhzFtiyXhKxC7JIBuuAZ2kVQNteFQMZQxiMsUgEcl29suVXESdFofMrH2CdwCLo18AS6R0u97ciFehmPNutu7lVFortDr2tjI7hL5f5Yh/j0LeXRortz/r6g3mfYWLkumKoAn7qtYAuScu26lZvnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746085634; c=relaxed/simple;
	bh=hitKx2a5ObtCV4XmG4ol8lDMxn1QvFqjp2dKbjjtppg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=idffWDC6YClXEOMvmrJm6QiAYa/QprCJVt5Yve0ihawaxtMBSpJgbPhCFHjNsPqrxzYFRwZnhZ7ITwZYFD6+hAFEydH/gE+5htIedx4zA5xxpRRKGasre0DhxGYwDxGcr6I1OQA+ie1na1RHHGS9IUYD1H7rYvaNe3TvutiA4yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XnZGiZBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XnZGiZBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7068BC4CEE3;
	Thu,  1 May 2025 07:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746085633;
	bh=hitKx2a5ObtCV4XmG4ol8lDMxn1QvFqjp2dKbjjtppg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XnZGiZBk/IjWG/IUgmT9hwNCLOEkey/cTUpssrMRdTcWRIPGj0Nvb0phUcL949zfP
	 4jSE8Nr5w3kmVtSp0ZDqYycAKGcutm+3jxxmKaAFKn3q30sHpeyWtI/FBxXlq5V0kK
	 EFoS0oW6ADT+V7QifNHLnIVNbVNBSMTSEeWzzwPk=
Date: Thu, 1 May 2025 09:47:10 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.6 000/204] 6.6.89-rc1 review
Message-ID: <2025050132-errand-serotonin-db14@gregkh>
References: <20250429161059.396852607@linuxfoundation.org>
 <f84163ad-2e1f-42ca-8546-7e077e13f4bb@drhqmail203.nvidia.com>
 <1903a129-6e06-47d9-862b-ab23f72a9fea@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1903a129-6e06-47d9-862b-ab23f72a9fea@nvidia.com>

On Thu, May 01, 2025 at 08:27:12AM +0100, Jon Hunter wrote:
> Hi Greg,
> 
> On 30/04/2025 16:04, Jon Hunter wrote:
> > On Tue, 29 Apr 2025 18:41:28 +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.6.89 release.
> > > There are 204 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.89-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Failures detected for Tegra ...
> > 
> > Test results for stable-v6.6:
> >      10 builds:	10 pass, 0 fail
> >      28 boots:	28 pass, 0 fail
> >      116 tests:	104 pass, 12 fail
> > 
> > Linux version:	6.6.89-rc1-gcbfb000abca1
> > Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> >                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
> >                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
> >                  tegra210-p2371-2180, tegra210-p3450-0000,
> >                  tegra30-cardhu-a04
> > 
> > Test failures:	tegra186-p2771-0000: cpu-hotplug
> >                  tegra186-p2771-0000: pm-system-suspend.sh
> >                  tegra194-p2972-0000: boot.py
> >                  tegra194-p2972-0000: pm-system-suspend.sh
> >                  tegra210-p2371-2180: cpu-hotplug
> >                  tegra210-p2371-2180: devices
> >                  tegra210-p3450-0000: cpu-hotplug
> >                  tegra210-p3450-0000: devices
> > 
> 
> For linux-6.6.y I needed to revert both of the following changes to fix the
> above failures ...
> 
> # first bad commit: [d908866131a314dbbdd34a205d2514f92e42bb80] memcg: drain
> obj stock on cpu hotplug teardown
> 
> # first bad commit: [4cfe77123fd1f76f7b1950c0abc6f131b90ae8bb] iommu: Handle
> race with default domain setup

Thanks, I'm going to drop both of these now.

greg k-h
