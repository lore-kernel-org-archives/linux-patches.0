Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792381C1F20;
	Sat,  1 Feb 2025 15:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738424085; cv=none; b=tHHcqVU3DGrAA4p2+FNSUI9VG/hgzJin1bBicVc9ICoqVEBPlyDCLDpgZUea2LXXJZYeyClVrQfjil2vsTAXnl3xWw0lOfQI8TI7VAdrE1QbnBNuADp9o5m1JfcSGio7JMwkaDNirABSKCbyILIGvKsbEN/e01DlVIt4mMoP56A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738424085; c=relaxed/simple;
	bh=ostiqecq5Wa/yigzPqdXvv0v50SYq25TGGFKSxDePsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qjrn3GBUWWla97yAaMQYlcc2FPG7N1gj0BJ6eK+V6wSNFcw+JLF4p55atKe5QhRRluXdYBNXwZjImYXTi4WrT0g5DQFfKnanOOhpnmncOGhNqhXiFDfHudC4RNN+PebpTTHTABlIWWhH1P/Lqqg5EdyUMev3WAZRH88ot8bArcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lf17L8YO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lf17L8YO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E035C4CED3;
	Sat,  1 Feb 2025 15:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738424085;
	bh=ostiqecq5Wa/yigzPqdXvv0v50SYq25TGGFKSxDePsw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lf17L8YO1pUR07BKuAlZtaI14o6HvWD+80g2LegAO7uGyvJXROkdkOOfzJUJNvbnh
	 89pWGuwlf/IQqCajZQx13uAE1n9X46xaP43KQHzSUNCNHR/OcaImzG9OQ4bStS1f9y
	 472JZosqwCxEXJD6VNy705it4qkYaELUI/aVH9DY=
Date: Sat, 1 Feb 2025 16:34:41 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.4 00/94] 5.4.290-rc2 review
Message-ID: <2025020131-stiffen-cleaver-3d44@gregkh>
References: <20250131112114.030356568@linuxfoundation.org>
 <CA+G9fYtT36DGS=6+2u35Ki1nyo0UR2A1ee3ifUfqga6D+K2egg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtT36DGS=6+2u35Ki1nyo0UR2A1ee3ifUfqga6D+K2egg@mail.gmail.com>

On Sat, Feb 01, 2025 at 08:38:48PM +0530, Naresh Kamboju wrote:
> On Fri, 31 Jan 2025 at 16:51, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.290 release.
> > There are 94 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 02 Feb 2025 11:20:53 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.290-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> As other reported,
> the riscv build failed with defconfig with gcc and clang toolchain on the
> stable-rc 5.4.290-rc1 and 5.4.290-rc2
> 
> * riscv, build
>   - clang-19-allnoconfig
>   - clang-19-allyesconfig
>   - clang-19-defconfig
>   - clang-19-tinyconfig
>   - gcc-12-allnoconfig
>   - gcc-12-allyesconfig
>   - gcc-12-defconfig
>   - gcc-12-tinyconfig
>   - gcc-8-allnoconfig
>   - gcc-8-allyesconfig
>   - gcc-8-defconfig
>   - gcc-8-tinyconfig
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Build regression: riscv kernel traps.c error: use of undeclared
> identifier 'handle_exception'
> 
> Build error:
> ---
> arch/riscv/kernel/traps.c:164:23: error: use of undeclared identifier
> 'handle_exception'
>   164 |         csr_write(CSR_TVEC, &handle_exception);
>       |                              ^
> 1 warning and 1 error generated

Offending commits now dropped, thanks.

greg k-h
