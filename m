Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510192E5D39;
	Fri, 15 Aug 2025 16:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755276826; cv=none; b=o82zxVuQjGnZ4ADpIdgizS1afqJbHytMfpivUFtikn2cwxz3dPeQN01OVIhL4t+s1DlszgL7IRfSFXkLC9N+FjNa60+mgYEeJROM7FEocIl2qI+sZnr0ex0KBO3u5TFEG7Yw33YeGIwIfeXKXLQ+Ks6gADLCS4cHhTd1IHiioN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755276826; c=relaxed/simple;
	bh=kRaulFfm6o1dK9XZcvujWMGvLmV1wMAk/3iHRG5dBdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b15x9Y73IzYwae0QJVSgXXpCIPiMqT7kjQFmXKCT2yd72ARz9TOjQ7G0i8CKqjDB92CWw+rx5jXc5PRqWoN9PPIOUyMEzIQ/BvIn6nzfJUjV/VPoSOSiDRpYYemwXI294JXKW73WnAyC8fTwVMuWH6tyxxY3fGeIKuBXEiDeYkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUWB8O66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUWB8O66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D79C4CEF1;
	Fri, 15 Aug 2025 16:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755276821;
	bh=kRaulFfm6o1dK9XZcvujWMGvLmV1wMAk/3iHRG5dBdo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aUWB8O66N8a0q0t0LIr4Lw9qsCEEkUcwKTb7XP+lmSomRQ1h0eDsSlP6DLSodSbWM
	 Ot1DcAeaS+lo2a73lVggJq7N6Ar3enZYK95E1Io4SG3rzISAu0UkfyvJ8rr3GhBSAF
	 7RlnaVFEBxNweFh8Nq1DfC3LF2/vsL88RhaNUrGE=
Date: Fri, 15 Aug 2025 18:53:38 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
	conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux@roeck-us.net, lkft-triage@lists.linaro.org,
	patches@kernelci.org, patches@lists.linux.dev, pavel@denx.de,
	rwarsow@gmx.de, shuah@kernel.org, srw@sladewatkins.net,
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re:
Message-ID: <2025081517-observer-equivocal-7219@gregkh>
References: <b892ae8b-c784-4e8c-a5aa-006e0a9c9362@rnnvmail205.nvidia.com>
 <20250813172545.310023-1-jonathanh@nvidia.com>
 <2025081451-afloat-raisin-7cee@gregkh>
 <91238bb8-cc10-4816-948e-eb14cf385f89@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <91238bb8-cc10-4816-948e-eb14cf385f89@nvidia.com>

On Fri, Aug 15, 2025 at 05:20:34PM +0100, Jon Hunter wrote:
> On 14/08/2025 16:36, Greg KH wrote:
> > On Wed, Aug 13, 2025 at 06:25:32PM +0100, Jon Hunter wrote:
> > > On Wed, Aug 13, 2025 at 08:48:28AM -0700, Jon Hunter wrote:
> > > > On Tue, 12 Aug 2025 19:43:28 +0200, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 6.15.10 release.
> > > > > There are 480 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > > 
> > > > > Responses should be made by Thu, 14 Aug 2025 17:42:20 +0000.
> > > > > Anything received after that time might be too late.
> > > > > 
> > > > > The whole patch series can be found in one patch at:
> > > > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.10-rc1.gz
> > > > > or in the git tree and branch at:
> > > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> > > > > and the diffstat can be found below.
> > > > > 
> > > > > thanks,
> > > > > 
> > > > > greg k-h
> > > > 
> > > > Failures detected for Tegra ...
> > > > 
> > > > Test results for stable-v6.15:
> > > >      10 builds:	10 pass, 0 fail
> > > >      28 boots:	28 pass, 0 fail
> > > >      120 tests:	119 pass, 1 fail
> > > > 
> > > > Linux version:	6.15.10-rc1-g2510f67e2e34
> > > > Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> > > >                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
> > > >                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
> > > >                  tegra210-p2371-2180, tegra210-p3450-0000,
> > > >                  tegra30-cardhu-a04
> > > > 
> > > > Test failures:	tegra194-p2972-0000: boot.py
> > > 
> > > I am seeing the following kernel warning for both linux-6.15.y and linux-6.16.y …
> > > 
> > >   WARNING KERN sched: DL replenish lagged too much
> > > 
> > > I believe that this is introduced by …
> > > 
> > > Peter Zijlstra <peterz@infradead.org>
> > >      sched/deadline: Less agressive dl_server handling
> > > 
> > > This has been reported here: https://lore.kernel.org/all/CAMuHMdXn4z1pioTtBGMfQM0jsLviqS2jwysaWXpoLxWYoGa82w@mail.gmail.com/
> > 
> > I've now dropped this.
> > 
> > Is that causing the test failure for you?
> 
> Yes that is causing the test failure. Thanks!

Is the test just noticing the warning message?  Or is it a functional
failure?  Does it also fail on Linus's tree?

thanks,

greg k-h
