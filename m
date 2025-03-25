Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3424525A351
	for <patches@lists.linux.dev>; Tue, 25 Mar 2025 16:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742918877; cv=none; b=tTUC7/zex7XZPvLfZxBOJpUO5mCdO5MaYtZ0LmzjNBTUpCVjWoAFumcmfYgT/Jbeuj+T5aFMqGObE5oONehZ4UI8MS7fPoaGZM9riY/4V1XKLLdT2EhFPHs5/CZgJtQhxAqicXh0CaqhkAXYFkGoGGctMNdVekNcyGsTikzfGMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742918877; c=relaxed/simple;
	bh=6e1FS+eqBxQFG2Js5x/rV0J66TJrITnWPVuwHWmUG44=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=eE4MIjGTLRR/8fh0KvK3RHwyr3NZK2m/sID+gEiFGz2VrMukZ0FSs3eDaM2JDuOjFO5bbNh1NBvVcCi5DyT3YabynBCpDBGs2D4S6dzw3AEKjh8rKEH/sIZoaC2GFpfXbp16q3Rv/9NsrT3XXIqjI4NaOb+TiIoEY7z3O7g84Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=qj2LXlrp; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="qj2LXlrp"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1742918873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PmBcPArKT86cQNqXZe9hljvX1PmEnOQmPn7lfAPyquI=;
	b=qj2LXlrpWu6oLLUp/hzMPjEtqmvFrOFsofEV9ok4MX6JkcGJ8EHMODf9cjhaaIjVCtRTKz
	O0zLQIaGKjoNrbMeRSkX5xARJ0AzI3R9vM7CHvaaWDPmrkIF5FiESuiBd0ZNcjsXbc+O7Y
	+TpZNXMlDoFon5i1cZdhBEyGu9q6q4zWX5q+OJNFjCmauYGkwXQy+4zNxU9YwmQN4M+WIh
	FvaoX+QQ+Lx1/MM9nPlu/c838/EjL+eIPkuQYTWG260aer3cn9Js/vkYFlBiaF/rdMckyj
	LZ7D/i459c3p6ml5ptVKoodxJWJumiX7OdrIERh+bsJ1AhPCUZqtMM6LUPq9gg==
Date: Tue, 25 Mar 2025 17:07:53 +0100
From: Dragan Simic <dsimic@manjaro.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell
 <anders.roxell@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Heiko Stuebner
 <heiko@sntech.de>, jorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH 6.1 000/198] 6.1.132-rc1 review
In-Reply-To: <CA+G9fYss7RcH=ocag66EM4z26O-6o-gaq+Jo+GOUr2W773vQOw@mail.gmail.com>
References: <20250325122156.633329074@linuxfoundation.org>
 <CA+G9fYss7RcH=ocag66EM4z26O-6o-gaq+Jo+GOUr2W773vQOw@mail.gmail.com>
Message-ID: <8b1620dc4508571f56a0d360e3722174@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Hello Naresh,

On 2025-03-25 16:22, Naresh Kamboju wrote:
> On Tue, 25 Mar 2025 at 17:55, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> 
>> This is the start of the stable review cycle for the 6.1.132 release.
>> There are 198 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, 
>> please
>> let me know.
>> 
>> Responses should be made by Thu, 27 Mar 2025 12:21:27 +0000.
>> Anything received after that time might be too late.
>> 
>> The whole patch series can be found in one patch at:
>>         
>> https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.132-rc1.gz
>> or in the git tree and branch at:
>>         
>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git 
>> linux-6.1.y
>> and the diffstat can be found below.
>> 
>> thanks,
>> 
>> greg k-h
> 
> Regressions on arm64 rk3399 dtb builds failed with gcc-13 the
> stable-rc 6.1.132-rc1
> 
> First seen on the v6.1.131-199-gc8f0cb669e59
>  Good: v6.1.131
>  Bad: 6.1.132-rc1
> 
> * arm64, build
>   - gcc-13-defconfig
> 
> Regression Analysis:
>  - New regression? yes
>  - Reproducibility? Yes
> 
> Build regression: arm64 dtb rockchip non-existent node or label 
> "vcca_0v9"
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ## Build log
> arch/arm64/boot/dts/rockchip/rk3399.dtsi:221.23-266.4: ERROR
> (phandle_references):
>   /pcie@f8000000: Reference to non-existent node or label "vcca_0v9"
> 
>   also defined at 
> arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:665.8-675.3
> 
> ## Source
> * Kernel version: 6.1.132-rc1
> * Git tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> * Git sha: c8f0cb669e590c6c73c274b9fc56270ec33fa06b
> * Git describe: v6.1.131-199-gc8f0cb669e59
> * Project details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.131-199-gc8f0cb669e59/
> 
> ## Build
> * Build log:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.131-199-gc8f0cb669e59/testrun/27755718/suite/build/test/gcc-13-lkftconfig-devicetree/log
> * Build history:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.131-199-gc8f0cb669e59/testrun/27755718/suite/build/test/gcc-13-lkftconfig-devicetree/history/
> * Build details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.131-199-gc8f0cb669e59/testrun/27755718/suite/build/test/gcc-13-lkftconfig-devicetree/details/
> * Build link:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2uoE2WrLPnhBvFm7ejgwd6QJxk8/
> * Kernel config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2uoE2WrLPnhBvFm7ejgwd6QJxk8/config
> 
> ## Steps to reproduce
>  - # tuxmake --runtime podman --target-arch arm64 --toolchain gcc-13
> --kconfig defconfig

This is caused by another patch from the original series failing
to apply due to some bulk regulator renaming.  I'll send backported
version of that patch soon, which should make everything fine.
