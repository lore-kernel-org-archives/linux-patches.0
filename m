Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8497C13635F;
	Wed, 11 Sep 2024 12:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726058847; cv=none; b=S7zIuGfhZqJkI0ZyjZiWR5DKBVugyrJ02FQ8UOOxRUnsp51vtPttL+KoRvRjrbo7TKqRSWmbLg+Xc4H4IYTzLsF79vUcuxLAFX4x0y084KcWrVHsrJXKX7NR0IS3x9m6geLJxrYA0kYSJ2H81ONK+OqQFAFlqOoB0X1hfplqtpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726058847; c=relaxed/simple;
	bh=JPAvGPrwiG/TmmoyTDmeLA21f6qwPH3TsQYT8MXcOVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sSVnN9/7XeaFUlcmS1l9K64t6N7EOuzpYy4jKxhUkmd7Tv/CawYCG51ek0/vOwWpSInfH7Ej8Kicdr/uRg7wC2IU4VIhh+AP9J30xIUpmyDpnDvlzJd5Soa8t1rNz11EhZ8Oe5PiaTIl8cF7XN5oPRXPoZfyJSyI7ksz23b0Swk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=koU6U+MF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="koU6U+MF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B6CC4CEC5;
	Wed, 11 Sep 2024 12:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726058846;
	bh=JPAvGPrwiG/TmmoyTDmeLA21f6qwPH3TsQYT8MXcOVE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=koU6U+MFSJ+5xZy84WUZ/lsKEoYh0MsN1TIdS1mOuIMLtICslAC+/q2S5YssNbBXL
	 v6BWAXpRh2wnGwYDJCZ0oZSfK7JnCvkBKekohTdo355TV97iwT4reBcosXk8ZGZiFs
	 SLODoSLY5SRo/ZhkNc7GbOP12vbyz9m0dNrZxlRQ=
Date: Wed, 11 Sep 2024 14:47:24 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/186] 5.10.226-rc1 review
Message-ID: <2024091137-parched-scrunch-d9dd@gregkh>
References: <20240910092554.645718780@linuxfoundation.org>
 <39d69408-b8aa-4829-b85d-ecae4fa8f97e@linuxfoundation.org>
 <ac0c439f-86fe-467d-95c4-b4e9e294010f@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac0c439f-86fe-467d-95c4-b4e9e294010f@linuxfoundation.org>

On Tue, Sep 10, 2024 at 03:52:22PM -0600, Shuah Khan wrote:
> On 9/10/24 15:26, Shuah Khan wrote:
> > On 9/10/24 03:31, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.226 release.
> > > There are 186 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.226-rc1.gz
> > > or in the git tree and branch at:
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > 
> > > 
> > > Guillaume Stols <gstols@baylibre.com>
> > >      iio: adc: ad7606: remove frstdata check for serial mode
> > > 
> > 
> > 
> > Kernel: arch/x86/boot/bzImage is ready  (#210)
> > ERROR: modpost: module ad7606_par uses symbol ad7606_reset from namespace IIO_AD7606, but does not import it.
> > make[1]: *** [scripts/Makefile.modpost:123: modules-only.symvers] Error 1
> > make[1]: *** Deleting file 'modules-only.symvers'
> > make: *** [Makefile:1759: modules] Error 2
> > 
> > Same problem. I am building with this commit now and I will
> > update you what happens.
> > 
> 
> Not so easy. Removing this commit gives me the following error.
> drivers/iio/adc/ad7606_par.c: In function ‘ad7606_par16_read_block’:
> drivers/iio/adc/ad7606_par.c:40:25: error: implicit declaration of function ‘ad7606_reset’; did you mean ‘ad7606_probe’? [-Werror=implicit-function-declaration]
>    40 |                         ad7606_reset(st);
>       |                         ^~~~~~~~~~~~

If you remove that commit, this shouldn't be possible as ad7606_par.c
does not call ad7606_reset anymore.  I'll go drop this commit from 5.15
and 5.10 for now until this gets worked out, and that should fix your
build issue.

I'll push out some -rc2 releases to verify.

thanks,

greg k-h
