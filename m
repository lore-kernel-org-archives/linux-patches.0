Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF05720EE
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 08:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016D7C433EF;
	Thu, 16 Mar 2023 08:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678953870;
	bh=g296JjalEKy/VmXN5u7aQcjFNhAV8da0ymokVTzYSi0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gv24+HhQmw5Izep9kfmelYR02dlhyPAMXpvjfLOyzWbrUsokwIaNoe51FnW87fm7s
	 YQSIpbEbMqdOhjQv6zU9z8ZbrmzOf/igjfUpokKk20mDpiYsddMYVd7TWYiMaGzYGs
	 ylbI2dz3nRb/1bF3onTbLsBi5b4UWTwoFHPD/EDE=
Date: Thu, 16 Mar 2023 09:04:28 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/141] 6.2.7-rc1 review
Message-ID: <ZBLNjIGh6XzxWqYr@kroah.com>
References: <20230315115739.932786806@linuxfoundation.org>
 <20ff835c-99e1-4611-95d6-3050604c1b32@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20ff835c-99e1-4611-95d6-3050604c1b32@linaro.org>

On Wed, Mar 15, 2023 at 09:13:17AM -0600, Daniel Díaz wrote:
> Hello!
> 
> On 15/03/23 06:11, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.2.7 release.
> > There are 141 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.7-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> We can see this build failure on PowerPC with Clang-16 and Clang-nightly, for cell_defconfig:
> 
> -----8<-----
> error: unknown target CPU 'cell'
> note: valid target CPU values are: generic, 440, 450, 601, 602, 603, 603e, 603ev, 604, 604e, 620, 630, g3, 7400, g4, 7450, g4+, 750, 8548, 970, g5, a2, e500, e500mc, e5500, power3, pwr3, power4, pwr4, power5, pwr5, power5x, pwr5x, power6, pwr6, power6x, pwr6x, power7, pwr7, power8, pwr8, power9, pwr9, power10, pwr10, powerpc, ppc, ppc32, powerpc64, ppc64, powerpc64le, ppc64le, future
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:235: arch/powerpc/boot/cuboot.o] Error 1
> ----->8-----
> 
> 
> Then on GCC-8 and GCC-12, for ppc64e_defconfig, there's this:
> 
> -----8<-----
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:238: arch/powerpc/boot/crt0.o] Error 1
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:238: arch/powerpc/boot/crtsavres.o] Error 1
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:235: arch/powerpc/boot/cuboot.o] Error 1
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:235: arch/powerpc/boot/devtree.o] Error 1
> [...]
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:235: arch/powerpc/boot/fdt_wip.o] Error 1
> make[2]: Target 'arch/powerpc/boot/zImage' not remade because of errors.
> make[1]: *** [/builds/linux/arch/powerpc/Makefile:247: zImage] Error 2
> make[1]: Target '__all' not remade because of errors.
> make: *** [Makefile:242: __sub-make] Error 2
> make: Target '__all' not remade because of errors.
> ----->8-----

I think I've fixed both of these for -rc2, but it's hard to test on my
end.

thanks,

greg k-h
