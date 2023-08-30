Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825231FBB
	for <patches@lists.linux.dev>; Wed, 30 Aug 2023 12:33:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DB4C433C7;
	Wed, 30 Aug 2023 12:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693398823;
	bh=zUaYDfilxp4gg9z6w6cksTaZVu5PRndfyNsDgGTpsR8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0NohfXnBmpemIF0CiP1QImweQyYeJlVxMrX9W6JP3JIOfNWvPtREb3qeYlw6oGCli
	 HvoJEXLJx6Ta+g2VqpbEIE+qx6jyv0ycVDHFNNH9/PD+HWpB0k7+pjnltBKLu/RC9V
	 noeSkj/wP+wNwdU6Ntj+6Tru36jKGXbr17Goy9BI=
Date: Wed, 30 Aug 2023 14:33:40 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.14 00/57] 4.14.324-rc1 review
Message-ID: <2023083024-litmus-gruffly-dc18@gregkh>
References: <20230828101144.231099710@linuxfoundation.org>
 <98dbc981-56fa-4919-afcc-fdf63e0a1c53@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98dbc981-56fa-4919-afcc-fdf63e0a1c53@roeck-us.net>

On Tue, Aug 29, 2023 at 06:56:51PM -0700, Guenter Roeck wrote:
> On Mon, Aug 28, 2023 at 12:12:20PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.324 release.
> > There are 57 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 139 pass: 133 fail: 6
> Failed builds:
> 	arm:ep93xx_defconfig
> 	mips:mtx1_defconfig
> 	mips:db1xxx_defconfig
> 	powerpc:defconfig
> 	powerpc:allmodconfig
> 	powerpc:cell_defconfig
> Qemu test results:
> 	total: 431 pass: 414 fail: 17
> Failed tests:
> 	<all ppc64:pseries>
> 
> arm:ep93xx_defconfig
> 
> Error log:
> arch/arm/mach-ep93xx/timer-ep93xx.c:12:10: fatal error: platform.h
> 
> That is really an older problem, caused by commit 2e50d55578b0 ("ARM:
> ep93xx: fix missing-prototype warnings") which instead of fixing
> anything in v4.14.y broke its build.
> 
> mips:mtx1_defconfig
> 
> arch/mips/alchemy/common/dbdma.c:33:10: fatal error: linux/dma-map-ops.h: No such file or directory
> 
> Again, an older problem, caused by commit 10130470bb0 ("MIPS: Alchemy:
> fix dbdma2").

Thanks, I'll work on these after this release.

> powerpc:defconfig, powerpc:allmodconfig, powerpc:cell_defconfig
> 
> arch/powerpc/kernel/rtas_flash.c: In function 'rtas_flash_init':
> arch/powerpc/kernel/rtas_flash.c:717:29: error: implicit declaration of function 'kmem_cache_create_usercopy'
> 
> ppc64 boot tests fail to compile with the same error.

This one is now dropped.

greg k-h
