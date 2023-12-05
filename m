Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66CA68B8A;
	Tue,  5 Dec 2023 18:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lj3F+Ag5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C20BC433C7;
	Tue,  5 Dec 2023 18:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701800608;
	bh=1u3S+qdTDDJpU1AH8fRxdM6v7mEapa2b3xh7jr42q/o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lj3F+Ag5ozXNa3vw9pJkWyWpOZmMTl8+2HFnH4W/RwXkvCsduK0p1onlXVpCTJmp5
	 2/ugFcqip8aPFmSVrmEWjpBRHj21UKjTnF8MkrqJ7vpxdii/xEfiF0vq0KD1ffM4+U
	 vXh9snhqG0gpkuMFeJp3bGzqjhqHcGiGpTvTpOQ0=
Date: Wed, 6 Dec 2023 03:23:26 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com,
	Gaurav Batra <gbatra@linux.vnet.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 5.15 00/67] 5.15.142-rc1 review
Message-ID: <2023120610-cause-chariot-961b@gregkh>
References: <20231205031519.853779502@linuxfoundation.org>
 <CA+G9fYs-XB29+aZ2kk9psA+MTo8PCh0owWgwGRiq8JK60CuUtg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYs-XB29+aZ2kk9psA+MTo8PCh0owWgwGRiq8JK60CuUtg@mail.gmail.com>

On Tue, Dec 05, 2023 at 10:18:49PM +0530, Naresh Kamboju wrote:
> On Tue, 5 Dec 2023 at 09:10, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.142 release.
> > There are 67 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.142-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> Following powerpc build failures noticed.
> 
> * powerpc, build
>   - clang-17-defconfig - FAILED
>   - gcc-12-defconfig - FAILED
>   - gcc-8-defconfig - FAILED
> 
> build error:
> ---
> arch/powerpc/platforms/pseries/iommu.c: In function 'find_existing_ddw':
> arch/powerpc/platforms/pseries/iommu.c:908:49: error: 'struct dma_win'
> has no member named 'direct'
>   908 |                         *direct_mapping = window->direct;
>       |                                                 ^~
> 
> suspected commit:
> powerpc/pseries/iommu: enable_ddw incorrectly returns direct mapping
> for SR-IOV device
>  [ Upstream commit 3bf983e4e93ce8e6d69e9d63f52a66ec0856672e ]
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks, now dropped from 5.15.y and 6.1.y
