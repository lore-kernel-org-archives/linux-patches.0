Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC58F1DEFC1;
	Fri, 13 Dec 2024 11:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734089668; cv=none; b=sliMwfuA1T3bTo747aniZL6pxpJqdRMe24EWag4jvzZufAupjKVkDX/oyGkmpbH4P7jVkm56TwlRSgFnxl3jPRIxxZVRVznV+FCL8Zx6MEbkl4cv7PFbAq82wqwzJXewKFfpmEDk+PDa25riHmrryrduP9tqq8UZAz45DAc+4oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734089668; c=relaxed/simple;
	bh=aWaCOZ8r5I02327/CVzZfqrLjJphOn1zrnuB5mpBb20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nzm80gZs/fdqmipjAWMei6suFJ15rjtEjj+yMj/f4waUBIqmGHz7AZLwhCKFRgeTYTr+ukbUMZJcfRKmo9LNCKJM9RK3JGOxq5qj92xTVLrOo/mMwn8oGiQ6Xqnmoyb7fsnDgdWkxWAt7dbGWZJgDsBRsRTmtHRkRdjSUT3WsZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rw4RuQip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rw4RuQip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD741C4CED0;
	Fri, 13 Dec 2024 11:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734089668;
	bh=aWaCOZ8r5I02327/CVzZfqrLjJphOn1zrnuB5mpBb20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rw4RuQipt7TCsn+VAdAai8q+Kw+DJyFPXBg0fKy/th8khbA9d/58bxxZEwvorTlmh
	 P4Yo6IUUTO9Y9sNWioYGecwpqZzRSa6q1PX+EUBuaIQQKh2oX3ppaVFZ1r+I4W7Plt
	 s71rsY5DNF9tx8EtTxxQtDL68WjOq48U7mvr8Ob4=
Date: Fri, 13 Dec 2024 12:34:25 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	John Stultz <jstultz@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 6.12 000/466] 6.12.5-rc1 review
Message-ID: <2024121358-isolation-tanned-6a2d@gregkh>
References: <20241212144306.641051666@linuxfoundation.org>
 <CA+G9fYuX2BsEOCZPC+2aJZ6mEh10kGY69pEQU3oo1rmK-8kTRg@mail.gmail.com>
 <CA+G9fYu3SmdFKRkSDU0UV=bMs69UHx8UOeuniqTSD9haQ2yBvQ@mail.gmail.com>
 <CA+G9fYvV21_-3QYWh_gmKMRZ89AYn-KM99DbmghsLQJEL2+4Nw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvV21_-3QYWh_gmKMRZ89AYn-KM99DbmghsLQJEL2+4Nw@mail.gmail.com>

On Fri, Dec 13, 2024 at 01:18:07AM +0530, Naresh Kamboju wrote:
> On Fri, 13 Dec 2024 at 01:04, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Thu, 12 Dec 2024 at 23:35, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > >
> > > On Thu, 12 Dec 2024 at 20:30, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 6.12.5 release.
> > > > There are 466 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.5-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > > The riscv builds failed on Linux stable-rc linux-6.12.y due to following build
> > > warnings / errors.
> > >
> > > riscv:
> > >   * build/gcc-13-defconfig
> > >   * build/clang-19-defconfig
> > >   * build/clang-nightly-defconfig
> > >   * build/gcc-8-defconfig
> > >
> > > First seen on Linux stable-rc linux-6.12.y v6.12.4-467-g3f47dc0fd5b1,
> > >   Good: v6.12.4
> > >   Bad:  6.12.5-rc1
> > >
> > >
> > > Build log:
> > > -----------
> > > kernel/time/timekeeping.c: In function 'timekeeping_debug_get_ns':
> > > kernel/time/timekeeping.c:263:17: error: too few arguments to function
> > > 'clocksource_delta'
> > >   263 |         delta = clocksource_delta(now, last, mask);
> > >       |                 ^~~~~~~~~~~~~~~~~
> > > In file included from kernel/time/timekeeping.c:30:
> > > kernel/time/timekeeping_internal.h:18:19: note: declared here
> > >    18 | static inline u64 clocksource_delta(u64 now, u64 last, u64
> > > mask, u64 max_delta)
> > >       |                   ^~~~~~~~~~~~~~~~~
> > > make[5]: *** [scripts/Makefile.build:229: kernel/time/timekeeping.o] Error 1
> >
> > The bisect log pointing to first bad commit,
> >
> >     clocksource: Make negative motion detection more robust
> >     commit 76031d9536a076bf023bedbdb1b4317fc801dd67 upstream.
> 
> This issue was fixed in the upstream by adding the following patch,
>   timekeeping: Remove CONFIG_DEBUG_TIMEKEEPING
>   commit d44d26987bb3df6d76556827097fc9ce17565cb8 upstream

Kind of, it needed another commit as well, I've queued up the needed
ones and will push out a -rc2 soon.

thanks for testing!

greg k-h
