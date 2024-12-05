Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DCB1D5AC6;
	Thu,  5 Dec 2024 09:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733391203; cv=none; b=GXlItlWbx4Rfx9ZCFxxQWFp1L6ULfudX/un1oDF+K/PomsvPHRt8ZZT5jKH9RqUkejlaFaimelX6p3lJPL9Vrsg66VbH78i78sb+4dCa3Vu0tERk/fehd5rT0MtF8sF6f8CgHgAo+0Fim7qlDNcn8EZHOkhSK3W8cCTccElLOjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733391203; c=relaxed/simple;
	bh=2Co+qpnjhsB51FwPGiIQaOPSEEkXuCq6KFXs2VtbA1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f65MrgDH4RWYLGQzlm7IcMRzyVxW9hipxTMJEga3Ek8Cd0DFItuA0A/VpitBjxG0fkvwWTORefNAAjZa7sUzM3pUvqFapbBtFDlLGSAw3EcbcfVIe6gNfFFd9nhmqbGLy9EYgFOmaSv/8nK8Dob0ALgVyk/ZCejqNmGc5f4TTdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XgjEUBZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgjEUBZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00F5C4CED1;
	Thu,  5 Dec 2024 09:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733391203;
	bh=2Co+qpnjhsB51FwPGiIQaOPSEEkXuCq6KFXs2VtbA1A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XgjEUBZ5S/eYxAgzoqIJ+gsVvFqDWpBpSxzwW37pyjEO7UEydOvSgcKQx29DePIKZ
	 3nEaa95Lw7M12DO3Zcf4Thp2Ksq8AxXFvAqlKBfPsRrs0j/efxHAPhIR4+p9WqGDE6
	 brE8QFzdYP7PvDzM/RF1Qobl/E/wG5+xMMMXc3vs=
Date: Thu, 5 Dec 2024 10:33:20 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Matthias Schiffer <matthias.schiffer@tq-group.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Daniel Vetter <daniel.vetter@ffwll.ch>, noralf@tronnes.org,
	Sam Ravnborg <sam@ravnborg.org>, simona@ffwll.ch,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 4.19 000/138] 4.19.325-rc1 review
Message-ID: <2024120512-chest-wanting-7a7d@gregkh>
References: <20241203141923.524658091@linuxfoundation.org>
 <CA+G9fYtXS+Ze5Y8ddtOjZPiYP1NEDhArQhEJYfS3n5pcLdn9Hw@mail.gmail.com>
 <CA+G9fYuDAAZkgNK4_0Y=wDcTUzs7=ggbni4iJDAPbD9ocq992g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuDAAZkgNK4_0Y=wDcTUzs7=ggbni4iJDAPbD9ocq992g@mail.gmail.com>

On Wed, Dec 04, 2024 at 09:02:47PM +0530, Naresh Kamboju wrote:
> On Wed, 4 Dec 2024 at 19:24, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Tue, 3 Dec 2024 at 20:04, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > ------------------
> > > Note, this is the LAST 4.19.y kernel to be released.  After this one, it
> > > is end-of-life.  It's been 6 years, everyone should have moved off of it
> > > by now.
> > > ------------------
> > >
> > > This is the start of the stable review cycle for the 4.19.325 release.
> > > There are 138 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 05 Dec 2024 14:18:57 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.325-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Results from Linaro’s test farm.
> > Regressions on arm.
> >
> > The arm builds failed with gcc-12 and clang-19 due to following
> > build warnings / errors.
> >
> > Build log:
> > ---------
> > drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c:177:9: error:
> > 'DRM_GEM_CMA_DRIVER_OPS' undeclared here (not in a function)
> >   177 |         DRM_GEM_CMA_DRIVER_OPS,
> >       |         ^~~~~~~~~~~~~~~~~~~~~~
> > make[5]: *** [scripts/Makefile.build:303:
> > drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.o] Error 1
> >
> 
> Anders bisected this down to,
> 
> # first bad commit:
>    [5a8529fd9205b37df58a4fd756498407d956b385]
>    drm/fsl-dcu: Use GEM CMA object functions

Thanks, now dropped.

greg k-h
