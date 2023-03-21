Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3EA23BE;
	Tue, 21 Mar 2023 07:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3439C433D2;
	Tue, 21 Mar 2023 07:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679384914;
	bh=XI7OIN6kKxnXA+zf5fix2H550tfCc8AHh9zzh6nh5DY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lu4S0tkpUSiXdf5n67wBH8b+rGSfsNIgBs1SzowX8XbCCXlQodk92D/TyxUCkLWpz
	 kkoIy5CvnwuE2jEHc+Kjr+HbeEJYGBh/LWUk1hyVqhffdmgmDM9Tm+ht+4rSYnFxL9
	 mGzqCIFZEYF85Snkyu69ISjyTo3IEFe8eT52mv6g=
Date: Tue, 21 Mar 2023 08:48:31 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	llvm@lists.linux.dev, Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc1 review
Message-ID: <ZBlhT9ktUq9KCJku@kroah.com>
References: <20230320145507.420176832@linuxfoundation.org>
 <CA+G9fYtCtfSqrje=1wkw1ODpnJorDMFkB1bSVexpyc4gi3X0ZQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtCtfSqrje=1wkw1ODpnJorDMFkB1bSVexpyc4gi3X0ZQ@mail.gmail.com>

On Tue, Mar 21, 2023 at 12:12:40AM +0530, Naresh Kamboju wrote:
> On Mon, 20 Mar 2023 at 20:26, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.21 release.
> > There are 198 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 22 Mar 2023 14:54:29 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.21-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> Results from Linaro’s test farm.
> Regressions on PowerPC build failures.
> 
> > Christophe Leroy <christophe.leroy@csgroup.eu>
> >     powerpc/64: Set default CPU in Kconfig
> >
> 
> We see PowerPC build failures with Clang 16 and nightly on the
> following configurations:
> * cell_defconfig
> * ppc64e_defconfig
> * tqm8xx_defconfig
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Error messages respectively:
> -----8<-----
> error: unknown target CPU 'cell'
> note: valid target CPU values are: generic, 440, 450, 601, 602, 603,
> 603e, 603ev, 604, 604e, 620, 630, g3, 7400, g4, 7450, g4+, 750, 8548,
> 970, g5, a2, e500, e500mc, e5500, power3, pwr3, power4, pwr4, power5,
> pwr5, power5x, pwr5x, power6, pwr6, power6x, pwr6x, power7, pwr7,
> power8, pwr8, power9, pwr9, power10, pwr10, powerpc, ppc, ppc32,
> powerpc64, ppc64, powerpc64le, ppc64le, future
> ----->8-----
> 
> -----8<-----
> error: unknown target CPU 'e500mc64'
> note: valid target CPU values are: generic, 440, 450, 601, 602, 603,
> 603e, 603ev, 604, 604e, 620, 630, g3, 7400, g4, 7450, g4+, 750, 8548,
> 970, g5, a2, e500, e500mc, e5500, power3, pwr3, power4, pwr4, power5,
> pwr5, power5x, pwr5x, power6, pwr6, power6x, pwr6x, power7, pwr7,
> power8, pwr8, power9, pwr9, power10, pwr10, powerpc, ppc, ppc32,
> powerpc64, ppc64, powerpc64le, ppc64le, future
> ----->8-----
> 
> -----8<-----
> error: unknown target CPU '860'
> note: valid target CPU values are: generic, 440, 450, 601, 602, 603,
> 603e, 603ev, 604, 604e, 620, 630, g3, 7400, g4, 7450, g4+, 750, 8548,
> 970, g5, a2, e500, e500mc, e5500, power3, pwr3, power4, pwr4, power5,
> pwr5, power5x, pwr5x, power6, pwr6, power6x, pwr6x, power7, pwr7,
> power8, pwr8, power9, pwr9, power10, pwr10, powerpc, ppc, ppc32,
> powerpc64, ppc64, powerpc64le, ppc64le, future
> ----->8-----
> 
> The bisection pointed to this commit,
>   45f7091aac35 ("powerpc/64: Set default CPU in Kconfig")
> 
> 
> Follow up fix patch is here as per Christophe Leroy comments,
>  powerpc: Disable CPU unknown by CLANG when CC_IS_CLANG
> 

Should now be fixed, I'll push out a -rc2.

greg k-h
