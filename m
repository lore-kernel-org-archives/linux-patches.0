Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603B82417D9;
	Thu, 14 Aug 2025 15:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755185782; cv=none; b=UOcH1oaV7P1PeU5J2H0FEmxiwrkVYnJQefCDjYJRUumSGzQPgUk9lgL1pwqlj3rRhMw2Vy6Sns7Hj6tXZy0Lt/kO/AtDl22NT37G6d6NfPl1d6A1BKJdfu0PJ015caReiownOWwKJCGQqFVjlWSwHh+ZSACr1m4Fb17hI33T1Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755185782; c=relaxed/simple;
	bh=fIObf5r+EmdA5oHG6zfbCH3/ZfYEQP33Abj3Xq5UHgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tIhHPUm8tf4NjYvo0eWaHLuHnGN0ZQylu5zgwfzzosa5YjqpXEH7YvZ+UULcMVCodGC3LQE6b95VtOMg/zReS7PyXpszyiQ6R/9YVXXQ1sfp70pZr6j8BJ7aM19QrLzn24/EFbIllyJsI1o5EFlrZhhdTKc6VJ8hwJIpfANoJqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVlp0Gps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVlp0Gps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6E8C4CEED;
	Thu, 14 Aug 2025 15:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755185781;
	bh=fIObf5r+EmdA5oHG6zfbCH3/ZfYEQP33Abj3Xq5UHgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JVlp0GpsLTHCrcTIZbwiZa+bI1uh5hfNIws9NaTfmNZi45NelE0A5kBalt5eTRWT3
	 kKJVRYdShn0C1FBZcqYBXIR9mN66fCijPvLZtX3UQ6MP6rAyLn6ikIGxlaaZD4YVCJ
	 FGTBce/Od8S+L+53orjzjWUtE76T06iuMAhgnCfA=
Date: Thu, 14 Aug 2025 17:36:18 +0200
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
Message-ID: <2025081451-afloat-raisin-7cee@gregkh>
References: <b892ae8b-c784-4e8c-a5aa-006e0a9c9362@rnnvmail205.nvidia.com>
 <20250813172545.310023-1-jonathanh@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250813172545.310023-1-jonathanh@nvidia.com>

On Wed, Aug 13, 2025 at 06:25:32PM +0100, Jon Hunter wrote:
> On Wed, Aug 13, 2025 at 08:48:28AM -0700, Jon Hunter wrote:
> > On Tue, 12 Aug 2025 19:43:28 +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.15.10 release.
> > > There are 480 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 14 Aug 2025 17:42:20 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.10-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Failures detected for Tegra ...
> > 
> > Test results for stable-v6.15:
> >     10 builds:	10 pass, 0 fail
> >     28 boots:	28 pass, 0 fail
> >     120 tests:	119 pass, 1 fail
> > 
> > Linux version:	6.15.10-rc1-g2510f67e2e34
> > Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> >                 tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
> >                 tegra194-p3509-0000+p3668-0000, tegra20-ventana,
> >                 tegra210-p2371-2180, tegra210-p3450-0000,
> >                 tegra30-cardhu-a04
> > 
> > Test failures:	tegra194-p2972-0000: boot.py
> 
> I am seeing the following kernel warning for both linux-6.15.y and linux-6.16.y …
> 
>  WARNING KERN sched: DL replenish lagged too much
> 
> I believe that this is introduced by …
> 
> Peter Zijlstra <peterz@infradead.org>
>     sched/deadline: Less agressive dl_server handling
> 
> This has been reported here: https://lore.kernel.org/all/CAMuHMdXn4z1pioTtBGMfQM0jsLviqS2jwysaWXpoLxWYoGa82w@mail.gmail.com/

I've now dropped this.

Is that causing the test failure for you?

thanks,

greg k-h
