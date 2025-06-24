Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91534283FE8;
	Tue, 24 Jun 2025 10:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750760157; cv=none; b=VbTkON2+81X6VsnnAQMY3gpHrKh8qLZ4KoxvakS+gTFJ0V1RoYSCb7DFDJpldisfXppZ2BFadZ0Zaq76BDrAeOvjWt8WgSTqJFRLc2RE5lQr1O+lep6kj7Ulmt2qHzsPhwHJ1OTUcUm5GkLXY4+Eu4GwZi1D4Y4+DbXWa3o7HLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750760157; c=relaxed/simple;
	bh=jUQe1mPxBCuPa1ikbnp69FnCdQgJXf3j0k9yd7kqXcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B2jbeah2wo4CTOJ1jLyTPqxRVNtSX2D47lPcRd7V9ez0rAcuYJD+5WtuLGVT0sQujpVFkvKcodKWFQS8F/EPhW1lFIsQ8oSgZWIyJfYrEaF5GNiFJcZ3M7b+qSVoQLzcuiAVciSbzsAwu5+R/Y3bFJMega14/z91qRKAsACG3NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hc3dYS6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hc3dYS6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A87C4CEE3;
	Tue, 24 Jun 2025 10:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750760157;
	bh=jUQe1mPxBCuPa1ikbnp69FnCdQgJXf3j0k9yd7kqXcc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hc3dYS6GSnNGauU2coiSaJH7KD4ub0xkkoA/lSwF/xTB3aUXt9iMBENj9Txe7mGDK
	 wIL89Iy7HDamnQ4h38H6Gs/38Tj1HjfQc2GyqdjRkw+Zc9d+M/xb+0App5Rpoxul+3
	 heuMi9jcdLe6o8jKeAyr7xlPJaa7uL3HergQRJNw=
Date: Tue, 24 Jun 2025 11:15:54 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
Message-ID: <2025062431-unsorted-morphine-ffd7@gregkh>
References: <20250617152451.485330293@linuxfoundation.org>
 <CA+G9fYtUjjrzghRQVUJ5ct9zNK2ROcRVOizpT-ZyjzZGRSUz1Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtUjjrzghRQVUJ5ct9zNK2ROcRVOizpT-ZyjzZGRSUz1Q@mail.gmail.com>

On Tue, Jun 24, 2025 at 02:35:45AM +0530, Naresh Kamboju wrote:
> On Tue, 17 Jun 2025 at 20:58, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.15.3 release.
> > There are 780 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 19 Jun 2025 15:22:30 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.3-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Regressions on s390 allmodconfig builds with gcc-13 and clang-20 failed on
> the Linux stable-rc 6.15.4-rc1.
> 
> Regressions found on s390
> * s390, build
>   - clang-20-allmodconfig
>   - gcc-13-allmodconfig
> 
> Regression Analysis:
>  - New regression? Yes
>  - Reproducibility? Yes
> 
> Build regression: stable-rc 6.15.4-rc1 s390 allmodconfig
> sdhci-esdhc-imx.c 'sdhc_esdhc_tuning_restore' defined but not used
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ## Build errors
> drivers/mmc/host/sdhci-esdhc-imx.c:1608:13: error:
> 'sdhc_esdhc_tuning_restore' defined but not used
> [-Werror=unused-function]
>  1608 | static void sdhc_esdhc_tuning_restore(struct sdhci_host *host)
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/mmc/host/sdhci-esdhc-imx.c:1586:13: error:
> 'sdhc_esdhc_tuning_save' defined but not used
> [-Werror=unused-function]
>  1586 | static void sdhc_esdhc_tuning_save(struct sdhci_host *host)
>       |             ^~~~~~~~~~~~~~~~~~~~~~
> cc1: all warnings being treated as errors

Looks like this needs 5846efac138a ("mmc: sdhci-esdhc-imx: fix defined
but not used warnings"), but that's not quite right either as it fixes a
different change here, and only applying it still will result in a build
error.  I'll just drop the offending commit here entirely and wait for a
working set of patches to be submitted if the authors want them.

Same for the other branches where this showed up, thanks for the report.

thanks,

greg k-h
