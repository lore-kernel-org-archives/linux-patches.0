Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155F5EBB
	for <patches@lists.linux.dev>; Wed,  2 Aug 2023 06:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBD5C433C7;
	Wed,  2 Aug 2023 06:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690959054;
	bh=kA6LMeMa5KWRXjA4E8xeiCqx2O/5yf0NT93jEs4o2gE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wkhzKWPyWi+DmqzYYFnOGjY59X9M0Yn+CWLhHo9O47R1POH9UoojuU26yWNE1musW
	 /dkzDSDBGFJ+KCqv6kmLLgRwoNC00YMKpHQ/Rr5LLFrI/sAzhsSvs63VCZsjgsO4v4
	 OXX9SEfohahWhrtMDq6zCwlmC4a5LaxJrO8zZ5d4=
Date: Wed, 2 Aug 2023 08:50:51 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 5.15 000/155] 5.15.124-rc1 review
Message-ID: <2023080219-starlight-entryway-0203@gregkh>
References: <20230801091910.165050260@linuxfoundation.org>
 <CA+G9fYtCYSQ2fzmJU0t7ZCOUWjeRp9+Dn3gJ=4oRJP_CJttOcw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtCYSQ2fzmJU0t7ZCOUWjeRp9+Dn3gJ=4oRJP_CJttOcw@mail.gmail.com>

On Wed, Aug 02, 2023 at 07:27:03AM +0530, Naresh Kamboju wrote:
> On Tue, 1 Aug 2023 at 14:52, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.124 release.
> > There are 155 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 03 Aug 2023 09:18:38 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.124-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Following patch caused build regression on stable-rc 5.15 and stable-rc 6.1,
> 
> Regressions found on arm:
> 
>   - build/gcc-12-orion5x_defconfig
>   - build/clang-nightly-orion5x_defconfig
>   - build/gcc-8-orion5x_defconfig
>   - build/clang-16-orion5x_defconfig
> 
> gpio: mvebu: Make use of devm_pwmchip_add
> [ Upstream commit 1945063eb59e64d2919cb14d54d081476d9e53bb ]
> 
> Build log:
> ------
> drivers/gpio/gpio-mvebu.c: In function 'mvebu_pwm_probe':
> drivers/gpio/gpio-mvebu.c:877:16: error: implicit declaration of
> function 'devm_pwmchip_add'; did you mean 'pwmchip_add'?
> [-Werror=implicit-function-declaration]
>   877 |         return devm_pwmchip_add(dev, &mvpwm->chip);
>       |                ^~~~~~~~~~~~~~~~
>       |                pwmchip_add
> cc1: some warnings being treated as errors
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Ah, looks like 88da4e811311 ("pwm: Add a stub for devm_pwmchip_add()")
is needed, I'll queue that up for 5.15 and 6.1 and push out new -rc
releases.

thanks,

greg k-h
