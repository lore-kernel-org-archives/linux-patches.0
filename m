Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2A618641;
	Thu,  1 May 2025 07:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746085674; cv=none; b=L7w+6erFET3B7tVI1HNCVo/Iqgm8sr4ojXWzLGqWC8G0Buu0vPCCQz6a/5uTnRED13Oxg/0Gty9t45cGQt8s6siEUgFnUB3BWNjPJcbWxI1cdvVjCStDLkzGhTfyRnWhKmanBMwSF8fFjFIeias2t7/KJnS5H8mjV86f8sPaRbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746085674; c=relaxed/simple;
	bh=rxsfExXPnJgBgaRIvf5MYsQw5+gYsVOVV/3I5MVNPQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mBNe6U7Tnf+8MiKy2NVklygGLuiKb3zBiclXy5s0BzfzIuclTFkTlMQKGAd491RzN9+/3xXwMWgXx7c20Xbx3b7319Kq0mJiz706qGFNpNJIBKIDyZF0yBWN4t0PsTgWduBzYJQqMtC8mMhTLJvnb9+5B6iJ9Wz+ZPfpSjODs64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=faAPb0xh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="faAPb0xh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C07C4CEE3;
	Thu,  1 May 2025 07:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746085673;
	bh=rxsfExXPnJgBgaRIvf5MYsQw5+gYsVOVV/3I5MVNPQo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=faAPb0xh2ETUPEYS5KWmUsJT/9s43cJqP9/XWx8yqotB0M7RQTNhx1lJSZ18itge0
	 XU+my7ypqn7J1CJzz1blcp+Sca2ZVPThZcOOp6BvpztbXXxmA57zWM2CWmmj8S29zu
	 PhHQTj6rljjPQKWiB4q5GG3Vpps4h490fSc9Dnfc=
Date: Thu, 1 May 2025 09:47:50 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.1 000/167] 6.1.136-rc1 review
Message-ID: <2025050118-retiring-ultimatum-b355@gregkh>
References: <20250429161051.743239894@linuxfoundation.org>
 <3403e756-077f-4a6d-b26c-72fed355d117@rnnvmail201.nvidia.com>
 <49b6dadc-3fb3-487e-8dbd-767515877197@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49b6dadc-3fb3-487e-8dbd-767515877197@nvidia.com>

On Wed, Apr 30, 2025 at 04:06:40PM +0100, Jon Hunter wrote:
> Hi Greg,
> 
> On 30/04/2025 16:04, Jon Hunter wrote:
> > On Tue, 29 Apr 2025 18:41:48 +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.1.136 release.
> > > There are 167 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.136-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Failures detected for Tegra ...
> > 
> > Test results for stable-v6.1:
> >      10 builds:	10 pass, 0 fail
> >      28 boots:	28 pass, 0 fail
> >      105 tests:	100 pass, 5 fail
> > 
> > Linux version:	6.1.136-rc1-g961a5173f29d
> > Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> >                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
> >                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
> >                  tegra210-p2371-2180, tegra210-p3450-0000,
> >                  tegra30-cardhu-a04
> > 
> > Test failures:	tegra186-p2771-0000: cpu-hotplug
> >                  tegra194-p2972-0000: pm-system-suspend.sh
> >                  tegra210-p2371-2180: cpu-hotplug
> >                  tegra210-p3450-0000: cpu-hotplug
> 
> 
> Bisect is pointing to the following commit and reverting this does fix
> the issue ...
> 
> # first bad commit: [d908866131a314dbbdd34a205d2514f92e42bb80] memcg: drain obj stock on cpu hotplug teardown

I'll drop this from both 6.1 and 6.6 queues, thanks!

greg k-h
