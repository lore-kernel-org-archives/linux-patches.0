Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A701DF256;
	Fri, 13 Dec 2024 12:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734092360; cv=none; b=jaMuQbMQATnyQAXY8cr/VDMvFda9zpR9KI2gfobkF5iIguuE40YjJK0bFSwVW+CDqoZZaP8hRhEaIlLPc2RjzRs3ovYe0BXws1EEA0qCYhXBmterW7hHGMpVxJUSf+IvdHDVK0t1kBLHPXN0C1tbVBsSBklyyBq1WwNciWs/+tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734092360; c=relaxed/simple;
	bh=V9ONkfSkt72NTj06dq213k8hVFjsmB8vM3cYQuRVE4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kHgowJBChZgIbQO9EfPb91IR0tEju6FXZbzO0lYgDiOxwpVmQg5SMU1GGXA4PUnYPeef1UV6ShVPJZ/m8NKr/HHBiATbEoCWbg8UMQUdCzmqvc7pLQz1aLSeJBmb+Oa+12YKL0l/65IAQCNCNN9Nu3wmp8tD7wtfvmbngVZI3zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYi1Q7It; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYi1Q7It"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF41C4CED0;
	Fri, 13 Dec 2024 12:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734092358;
	bh=V9ONkfSkt72NTj06dq213k8hVFjsmB8vM3cYQuRVE4A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nYi1Q7ItdOhMSEQOxann2ot9ltPpUGpeZQRQtlDBnshsotAQxzbZxDJG2rsatPDSg
	 XKqomGizaEJByq1KsMbuXSGH6PcwsvhoFnJxVkCJ+uqoDr2pIlDFDU7BCmCrCIS05k
	 v62AbhGDRF4/LtI1WfPAgnJSEfhsES4/Bx5LBt5w=
Date: Fri, 13 Dec 2024 13:19:15 +0100
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
	John Stultz <jstultz@google.com>, Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 5.4 000/321] 5.4.287-rc1 review
Message-ID: <2024121303-polyester-entryway-de18@gregkh>
References: <20241212144229.291682835@linuxfoundation.org>
 <CA+G9fYv+i=T0KeWvxhiCOFiMSmpUYeUOWwn_YunEaYTi8oA_Ww@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYv+i=T0KeWvxhiCOFiMSmpUYeUOWwn_YunEaYTi8oA_Ww@mail.gmail.com>

On Fri, Dec 13, 2024 at 01:54:42AM +0530, Naresh Kamboju wrote:
> On Thu, 12 Dec 2024 at 23:08, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.287 release.
> > There are 321 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.287-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> As others reported,
> The arm builds failed on Linux stable-rc linux-5.4.y due to following build
> warnings / errors.
> 
> arm:
>   * build/gcc-12-defconfig
>   * build/clang-19-defconfig
> 
> 
> First seen on Linux stable-rc v5.4.286-322-g3612365cb6b2.
>   Good: v5.4.286
>   Bad:  v5.4.286-322-g3612365cb6b2
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build log:
> -----
> /builds/linux/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c:173:2: error:
> use of undeclared identifier 'DRM_GEM_CMA_DRIVER_OPS'
>   173 |         DRM_GEM_CMA_DRIVER_OPS,
>       |         ^
> 1 error generated.
> make[5]: *** [/builds/linux/scripts/Makefile.build:262:
> drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.o] Error 1
> 
> The commit pointing to,
>   drm/fsl-dcu: Set GEM CMA functions with DRM_GEM_CMA_DRIVER_OPS
>   [ Upstream commit 6a32e55d18b34a787f7beaacc912b30b58022646 ]

Now dropped, I'll push out a -rc2 soon.

thanks,

greg k-h
