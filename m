Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1B225332E
	for <patches@lists.linux.dev>; Tue, 25 Mar 2025 16:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742918848; cv=none; b=l0m5uRY+tUaqxI0WyCkdQgP2QOed0ni+v+zrId2SHjWQQCHTHgTqzIBNJkU/HLhbHnjPeOGYfnqu24DP03p5C3m4topAwgh1qsZOkgUG5HjYoohZyAjOSF/5YO5Qt75FsajUu9z488WLExyVGamRyrtV55AcNu2JG90e7tQVuzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742918848; c=relaxed/simple;
	bh=AfeinVZchvMBv438BnpRosunMeQS/bsLf199sZ53/es=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=hBOJPpsMdL8T+SPCD9bkPE5foLXGZDocFDSfPMhY5mEyIz2rPCX+nk6sZalJUpMUxDDlDzzaXhbMNnDDRR4f8+QmM03VM8ciifwfxqpBsStoFQB/wcKwv+Hl3gKoETWBDeinvYPJ5M9NTmrtE9S6IkTTKOObSH2HpimJb3jqtoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=wUfVeTSd; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="wUfVeTSd"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1742918837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QCdOLNdtvvawO2bLA9Pq/xQEF8vw52RF0Zlq/SJ2c7c=;
	b=wUfVeTSdLHzAFhu0xYsljK9AL/NIapgRddAqJIa07lxsXIGlgJUt3Gwqs7VSjnfvqky12j
	tofRAlyjRtNI2LmU9bPpPFPuMlaDzj86ewGY3BvH6YutxsxM7xNtwI+mTniyo6HophI5if
	2CD2b+wWt6fScbtF7D/6O1+vUEyIO9TQCThj9NzV14uxa6pae/cESsldjNjMy5MOZUXjGP
	7uRZ51L7//TMWgAO8rXlmiEqlQaLIDfDzbaMpkT30JAE64LNdRGc2f2bxvH+edlBXO8Jlx
	cxEo5Uwr+FAepTbwxvv1IpMwxp9QKmLNUGwxqcXxiTH9AwDSKI4rsQFwW8AN3w==
Date: Tue, 25 Mar 2025 17:07:16 +0100
From: Dragan Simic <dsimic@manjaro.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH 6.6 00/77] 6.6.85-rc1 review
In-Reply-To: <CA+G9fYvWau1nC8wmpWkxG8gWPaRMP9pbkh2eNsAZoUMeRPgzqA@mail.gmail.com>
References: <20250325122144.259256924@linuxfoundation.org>
 <CA+G9fYvWau1nC8wmpWkxG8gWPaRMP9pbkh2eNsAZoUMeRPgzqA@mail.gmail.com>
Message-ID: <a823454af9915fe3acfcb66fd84dc826@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Hello Naresh,

On 2025-03-25 16:07, Naresh Kamboju wrote:
> On Tue, 25 Mar 2025 at 18:05, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> 
>> This is the start of the stable review cycle for the 6.6.85 release.
>> There are 77 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, 
>> please
>> let me know.
>> 
>> Responses should be made by Thu, 27 Mar 2025 12:21:27 +0000.
>> Anything received after that time might be too late.
>> 
>> The whole patch series can be found in one patch at:
>>         
>> https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.85-rc1.gz
>> or in the git tree and branch at:
>>         
>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git 
>> linux-6.6.y
>> and the diffstat can be found below.
>> 
>> thanks,
>> 
>> greg k-h
> 
> 
> Regressions on arm64 rk3399 dtb builds failed with gcc-13 the
> stable-rc 6.6.85-rc1
> 
> First seen on the v6.6.83-245-gc1fb5424adea
>  Good: v6.6.84
>  Bad: 6.6.85-rc1
> 
> * arm64, build
>   - gcc-13-defconfig
> 
> Regression Analysis:
>  - New regression? yes
>  - Reproducibility? Yes
> 
> 
> Build regression: arm64 dtb rockchip non-existent node or label 
> "vcca_0v9"
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ## Build log
> arch/arm64/boot/dts/rockchip/rk3399.dtsi:221.23-266.4: ERROR
> (phandle_references):
> /pcie@f8000000: Reference to non-existent node or label "vcca_0v9"
> 
>   also defined at 
> arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:659.8-669.3
> 
> ## Source
> * Kernel version: 6.6.85-rc1
> * Git tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> * Git sha: c1fb5424adea53e3a4d8b2018c5e974f7772af29
> * Git describe: v6.6.83-245-gc1fb5424adea
> * Project details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.83-245-gc1fb5424adea/
> 
> ## Build
> * Build log:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.83-245-gc1fb5424adea/testrun/27760755/suite/build/test/gcc-13-defconfig/log
> * Build history:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.83-245-gc1fb5424adea/testrun/27763720/suite/build/test/gcc-13-defconfig/history/
> * Build details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.83-245-gc1fb5424adea/testrun/27760755/suite/build/test/gcc-13-defconfig/
> * Build link:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2uoHmBcVLd60GQ0SVHWAaZRZfNd/
> * Kernel config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2uoHmBcVLd60GQ0SVHWAaZRZfNd/config
> 
> ## Steps to reproduce
>  - # tuxmake --runtime podman --target-arch arm64 --toolchain gcc-13
> --kconfig defconfig

This is caused by another patch from the original series failing
to apply due to some bulk regulator renaming.  I'll send backported
version of that patch soon, which should make everything fine.
