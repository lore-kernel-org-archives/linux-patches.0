Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D5D19309C;
	Thu, 29 Aug 2024 14:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724941040; cv=none; b=NtNP7+147G54gbX8uBtAKUgUz7UNSr3uctnEES1AtmLguYPVZBg4zwcNEU8qeYhHZKnfAJkzQa2Cz8VOe5Wsdosx2ECBPAy5KBjAkaSDDYzRzFD0NVjeH90V2aBNq6NzthrpHzyFFshjTa7fR/3Zd/R8cclOQ8v2RXxzLWIlJ4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724941040; c=relaxed/simple;
	bh=j/rNjIEUKeyPjudOzlF1BHdfKpEzw0uEXfFIlVr4Brk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g+3miqfHjhQ5GYLiBjokR8Uy1cL7wBui/JxIq2r3ljayf2LzXNniCn/NvNTHS8AsGOkVjD3XfBk2GpLswctf0gxsd/CyxawYAGAUuaQMmXgYfiabLGqnNeflAvSgtiBFeDwSzPEWXYlOHL1L/FUWzc0KF2cibJVCfc2hSUjB0XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Sd/gkXb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Sd/gkXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6700C4CEC3;
	Thu, 29 Aug 2024 14:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724941039;
	bh=j/rNjIEUKeyPjudOzlF1BHdfKpEzw0uEXfFIlVr4Brk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2Sd/gkXb5X6teaRdaPuUjogPVNlSigSRb9MAxOF9RZZGqfeoM3Il14NSjwUnszeLJ
	 BPGA4h5xDwx+fevGcqTdqv7yqzIlkmox10OFh7qwPrhOuIOu3f7w84GpGQU70alvnv
	 DgcSME1oEZG+NcgTC5iZF/bkxm9y64i8mq73LZx4=
Date: Thu, 29 Aug 2024 16:17:16 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	rcu <rcu@vger.kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>,
	Zhen Lei <thunder.leizhen@huawei.com>
Subject: Re: [PATCH 6.1 000/321] 6.1.107-rc1 review
Message-ID: <2024082907-removable-alto-536a@gregkh>
References: <20240827143838.192435816@linuxfoundation.org>
 <CA+G9fYuS47-zRgv9GY3XO54GN_4EHPFe7jGR50ZoChEYeN0ihg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuS47-zRgv9GY3XO54GN_4EHPFe7jGR50ZoChEYeN0ihg@mail.gmail.com>

On Tue, Aug 27, 2024 at 11:37:42PM +0530, Naresh Kamboju wrote:
> On Tue, 27 Aug 2024 at 20:47, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.107 release.
> > There are 321 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.107-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The tinyconfig builds failed due to following build warnings / errors on the
> stable-rc linux-6.1.y and linux-6.6.y
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build error:
> -------
> In file included from /kernel/rcu/update.c:49:
> /kernel/rcu/rcu.h: In function 'debug_rcu_head_callback':
> /kernel/rcu/rcu.h:218:17: error: implicit declaration of function
> 'kmem_dump_obj'; did you mean 'mem_dump_obj'?
> [-Werror=implicit-function-declaration]
>   218 |                 kmem_dump_obj(rhp);
>       |                 ^~~~~~~~~~~~~
>       |                 mem_dump_obj
> cc1: some warnings being treated as errors

Also now fixed here, thanks.

greg k-h
