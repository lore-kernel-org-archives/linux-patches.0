Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7978223DEF;
	Wed,  4 Jun 2025 10:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749033414; cv=none; b=JURw2zgVEyC3Dz5SkapXTtc5JlZ4jdehofFwB5d2pStAfwoW08/IavHUZYOAlwI35wG6x4D97uTHRTCynna6I4YRs+uY1GDCYpfAW7fl6ZGuJ8vVA1TW0yWYrUwz+Y5OqUdSIgAuEH2TKNnmRzW8m3o+TPMQicT987eujvDIHfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749033414; c=relaxed/simple;
	bh=wfRJznO+iEVV9hKNmfFsf/JeU/L4Kcn9A8u9eRc0S1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IFiB/K3zqpTbM+XLbaXlDqGeO79T0CmH2I+byP8yU1UZlH5sKcKGJhNXHJZ1Hts7mi5QwWnavatbAZtN/eI6W2IleBVXS597GRGfLg6DmB23Nmz4T48DlaHoH7NAab15ipVqInXZkdktk3wVzAwPTqVTPl61NJr7RjhEmUryJtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hSPWipAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hSPWipAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE846C4CEE7;
	Wed,  4 Jun 2025 10:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749033413;
	bh=wfRJznO+iEVV9hKNmfFsf/JeU/L4Kcn9A8u9eRc0S1o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hSPWipAfTurWPye4FDGCK29gkbw9vLJsMcZB7kpdC6KGuWpIlnNribc6Nu0KCuSOb
	 muQNDdOuVWYkrvKcuJxNpjeDwK6jMTvCfB7TxPmPTCWX+mn5dBV7zUAJs7yJE7Jxcn
	 2A91Tk1hMgxdb63osfcVs0LfLQg0bePHAs60M0k4=
Date: Wed, 4 Jun 2025 12:36:51 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org,
	Aaron Kling <webgeek1234@gmail.com>
Subject: Re: [PATCH 6.12 00/55] 6.12.32-rc1 review
Message-ID: <2025060419-duchess-rehab-2d6e@gregkh>
References: <20250602134238.271281478@linuxfoundation.org>
 <ff0b4357-e2d4-4d39-aa0e-bb73c59304c1@drhqmail203.nvidia.com>
 <bf1dabf7-0337-40e9-8b8e-4e93a0ffd4cc@nvidia.com>
 <2025060413-entrust-unsold-7bfd@gregkh>
 <b103ae12-150b-4b89-bc77-86e256dac7bc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b103ae12-150b-4b89-bc77-86e256dac7bc@nvidia.com>

On Wed, Jun 04, 2025 at 11:22:53AM +0100, Jon Hunter wrote:
> 
> On 04/06/2025 11:19, Greg Kroah-Hartman wrote:
> > On Wed, Jun 04, 2025 at 10:57:29AM +0100, Jon Hunter wrote:
> > > Hi Greg,
> > > 
> > > On 04/06/2025 10:41, Jon Hunter wrote:
> > > > On Mon, 02 Jun 2025 15:47:17 +0200, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 6.12.32 release.
> > > > > There are 55 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > > 
> > > > > Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> > > > > Anything received after that time might be too late.
> > > > > 
> > > > > The whole patch series can be found in one patch at:
> > > > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.32-rc1.gz
> > > > > or in the git tree and branch at:
> > > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > > > > and the diffstat can be found below.
> > > > > 
> > > > > thanks,
> > > > > 
> > > > > greg k-h
> > > > 
> > > > Failures detected for Tegra ...
> > > > 
> > > > Test results for stable-v6.12:
> > > >       10 builds:	10 pass, 0 fail
> > > >       28 boots:	28 pass, 0 fail
> > > >       116 tests:	115 pass, 1 fail
> > > > 
> > > > Linux version:	6.12.32-rc1-gce2ebbe0294c
> > > > Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> > > >                   tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
> > > >                   tegra194-p3509-0000+p3668-0000, tegra20-ventana,
> > > >                   tegra210-p2371-2180, tegra210-p3450-0000,
> > > >                   tegra30-cardhu-a04
> > > > 
> > > > Test failures:	tegra186-p2771-0000: pm-system-suspend.sh
> > > 
> > > 
> > > I have been looking at this and this appears to be an intermittent failure
> > > that has crept in. Bisect is point to the following change which landed in
> > > v6.12.31 and we did not catch it ...
> > > 
> > > # first bad commit: [d95fdee2253e612216e72f29c65b92ec42d254eb] cpufreq:
> > > tegra186: Share policy per cluster
> > > 
> > > I have tested v6.15 which has this change and I don't see the same issue
> > > there. I have also tested v6.6.y because this was backported to the various
> > > stable branches and I don't see any problems there. Only v6.12.y appears to
> > > be impacted which is odd (although this test only runs on v6.6+ kernels for
> > > this board). However, the testing is conclusive that this change is a
> > > problem for v6.12.y.
> > > 
> > > So I think we do need to revert the above change for v6.12.y but I am not
> > > sure if it makes sense to revert for earlier stable branches too?
> > 
> > Yes, let's revert it for the older ones as well as it would look odd,
> > and our tools might notice that we had "skipped" a stable release tree.
> > 
> > Can you send the revert or do you need us to?
> 
> I can no problem. Do you need a revert for each stable branch or just one
> email with the commit to revert for each stable branch?

Which ever is easier for you, I can handle the git id "fixups" when
applying them to the different branches if you don't want to have to dig
for them.

thanks,

greg k-h
