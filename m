Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096FA2820DC;
	Tue,  3 Jun 2025 09:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748942454; cv=none; b=LVblrY4nGkdmKUtfewECpg3QIu1Yj7iFEsx4L/c6OpDbYUToy4LBkev6Np8kH8kaxvsKNGLQxbbCAK23FMXX7MN1a7vpD0ucpatr7gHa3X3c/dLoGmzwOAjYNvyf6uel8B1QCap7pmX2+IMkDoWHTan4aLS2bWJa2GTs9ze50t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748942454; c=relaxed/simple;
	bh=wruKkw7Qj49iQx5rNva3OWVbdf3DOXVS42X25c+Pg6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AkkCKbvYeXZ0yvRtZRRV7JHnJphyNMmTmoINzHO6t8RLZAAB6MYBSCI2DKOhLxhSeyxYkYDeAi2ZOMmy30Ut141fUDaxct2iOm8aPUoou0+11LK6J5duSZi1DYLcv12WkvAWB6CEJ0eIFlNpq6rGumfcjAK05cQY6Wq8vYQ/YkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vtPkP4hl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vtPkP4hl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E003FC4CEED;
	Tue,  3 Jun 2025 09:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748942453;
	bh=wruKkw7Qj49iQx5rNva3OWVbdf3DOXVS42X25c+Pg6c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vtPkP4hlyLwu12xoHwWAvTqttUompNwLW8xwPMykmMfHZ/Q1Q4eiZuhL90UbeUsQJ
	 0Y1JNIspim/H2aF5VioNKIXHqsYStxh3rp3EcgK+9GdXr87DsT/ejyCy5d/J4ew5mJ
	 Xuzh4qm/azSCx0W5J92ePfFUkonof4iZSNZ0BgQA=
Date: Tue, 3 Jun 2025 09:56:50 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 000/207] 5.15.185-rc1 review
Message-ID: <2025060337-dictation-trench-dc12@gregkh>
References: <20250602134258.769974467@linuxfoundation.org>
 <e3201002-8157-4fe4-9b21-39f3e5e5054a@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e3201002-8157-4fe4-9b21-39f3e5e5054a@w6rz.net>

On Tue, Jun 03, 2025 at 12:00:16AM -0700, Ron Economos wrote:
> On 6/2/25 06:46, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.185 release.
> > There are 207 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.185-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Build failure on RISC-V.
> 
> drivers/clocksource/timer-riscv.c: In function 'riscv_timer_dying_cpu':
> drivers/clocksource/timer-riscv.c:82:9: error: implicit declaration of
> function 'riscv_clock_event_stop' [-Werror=implicit-function-declaration]
>    82 |         riscv_clock_event_stop();
>       |         ^~~~~~~~~~~~~~~~~~~~~~
> 
> Caused by the patch "clocksource/drivers/timer-riscv: Stop stimecmp when cpu
> hotplug" commit 60a72ebfdd28510eee8f53a7aadecca1349d4603
> 
> The function riscv_clock_event_stop() wasn't added until v6.7-rc1, so this
> patch should be dropped.

Thanks for letting me know, now dropped from 5.10.y and 5.15.y

greg k-h
