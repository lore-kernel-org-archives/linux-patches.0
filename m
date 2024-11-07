Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF18502B1;
	Thu,  7 Nov 2024 06:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730961178; cv=none; b=a76KyHTgI0zhNDPn4v89FgUSJWErHmkOJ0xE7KLyEa6/elL2cJ+SajlPIq+DeeCfh55UhBdLBY7lIhIvdPqyM+v+jFlYLUOi3+qD+JUKRqxBYA7Uh/5zUQr2VljnIxVZztLeZ48/eo8Xx6ls8tYT/AtWXa9+o6EwZZBSDg/RjVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730961178; c=relaxed/simple;
	bh=myrDbv2t73PVH9vtOBTOScWV0P6NL6nTv3L/kGSCJJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Av5jVKP15B38PTDPPlVq4ZqvxxfQyG8PPdbr2CvmzI9hc9JzK1crUAboMbz/emDt1SUONV4QGE/ukL/HLZRkpNKNoOkPQ3FuQ586FMZMKGs/FZ76CfVwuqtQmVmAafkKo2WigbhAq5qJsFAsof/8ntj0kj/P++CEwSSPaTcO/hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yx2b7Bow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yx2b7Bow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275CFC4CEDF;
	Thu,  7 Nov 2024 06:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730961177;
	bh=myrDbv2t73PVH9vtOBTOScWV0P6NL6nTv3L/kGSCJJE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=yx2b7Bow8ASTyv59p10ZQrdDvU2GhNSoGwXo7xM4+woapoIKmifOvMNh3tyH0zH43
	 6Bl2qBITZNOlLuODyIaCeB4z1S5eDyxsJemsjvPMjsMS9j5m280+/Ksx0CowyCFBG7
	 cyRekFtXVei915j4lYC+UG0DKOBI+og78v8N2ZvQ=
Date: Thu, 7 Nov 2024 07:32:39 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hagar@microsoft.com, broonie@kernel.org,
	Wang Jianzheng <wangjianzheng@vivo.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 4.19 000/350] 4.19.323-rc1 review
Message-ID: <2024110725-culminate-figurine-2eb0@gregkh>
References: <20241106120320.865793091@linuxfoundation.org>
 <CA+G9fYu-X4w24M9NgwWU4=vOsMxq8CzmCGo+BC-=t9e-R0NwnQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYu-X4w24M9NgwWU4=vOsMxq8CzmCGo+BC-=t9e-R0NwnQ@mail.gmail.com>

On Wed, Nov 06, 2024 at 02:46:04PM +0000, Naresh Kamboju wrote:
> On Wed, 6 Nov 2024 at 12:07, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.323 release.
> > There are 350 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.323-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The arm builds failed with gcc-8, gcc-12 on the Linux stable-rc
> linux-4.19.y and linux-5.4.y.
> 
> First seen on Linux v4.19.322-351-ge024cd330026
>   Good: v4.19.321-96-g00a71bfa9b89
>   Bad:  v4.19.322-351-ge024cd330026
> 
> arm:
>   build:
>     * gcc-8-lkftconfig
>     * gcc-12-lkftconfig
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build log:
> ---------
> drivers/pinctrl/mvebu/pinctrl-dove.c: In function 'dove_pinctrl_probe':
> drivers/pinctrl/mvebu/pinctrl-dove.c:791:9: error: implicit
> declaration of function 'devm_platform_get_and_ioremap_resource'; did
> you mean 'devm_platform_ioremap_resource'?
> [-Werror=implicit-function-declaration]
>   base = devm_platform_get_and_ioremap_resource(pdev, 0, &mpp_res);
>          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>          devm_platform_ioremap_resource
> drivers/pinctrl/mvebu/pinctrl-dove.c:791:7: warning: assignment to
> 'void *' from 'int' makes pointer from integer without a cast
> [-Wint-conversion]
>   base = devm_platform_get_and_ioremap_resource(pdev, 0, &mpp_res);
>        ^
> cc1: some warnings being treated as errors
> 
> 
> Build image:
> -----------
>  - https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTbkOSx8FRoSUpBZX23UatyPIP/
> - https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTbkOSx8FRoSUpBZX23UatyPIP/build.log
>  - https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTbkOSx8FRoSUpBZX23UatyPIP/config
>  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.322-351-ge024cd330026/testrun/25686486/suite/build/test/gcc-12-lkftconfig/details/
>  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.284-463-g21641076146f/testrun/25690547/suite/build/test/gcc-12-lkftconfig/log
> 
> Steps to reproduce:
> ------------
>    - tuxmake --runtime podman --target-arch arm --toolchain gcc-12
> --kconfig https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTbkOSx8FRoSUpBZX23UatyPIP/config
> 
> metadata:
> ----
>   git describe: v4.19.322-351-ge024cd330026
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>   git sha: e024cd330026af478986a90829dd6ff03e3c1f92
>   kernel config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTbkOSx8FRoSUpBZX23UatyPIP/config
>   build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTbkOSx8FRoSUpBZX23UatyPIP/
>   toolchain: gcc-12 and gcc-8
>   config: lkftconfig
>   arch: arm

Thanks, I'll go fix this up in 4.19 and 5.4 and push out new -rc2
releases now.

greg k-h
