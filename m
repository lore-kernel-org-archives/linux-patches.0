Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235A12E7BB4;
	Tue, 28 Oct 2025 09:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761642315; cv=none; b=o7LEZWyF5U654uzMqGqCqLkaRVRBysfoqbC3IUthQ+bqf074zZJ7KRHVvpDcIFHT+q0NTg+x2XN7+Qm1J/Sbt7GGSrEGn/AEToeIdy/1DKQ92Xggs/t2zQtihGe3bFXHFh2eWX9KCr4wQUchrHL/x3BGycHxJfwUvmDCjU//+AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761642315; c=relaxed/simple;
	bh=V0eGMEDYNjmZcItSuYC29g2UnX0Z2vl5cwdDrIsClsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VSMTefbTJ8shqGhQQ/pl0WqKppMcqht7oaws/Mdo8yUKYvIEFVHfm0Ui1qOMlay9h2dk+Z9aupzKNBNeXlSFY4H7rwkvN0ZCrvUNalnAvvmwa2j5qtdLcE4maOfM97noAaX4ZZm7qWv8wrDOt836n1oY/m28KjoUFqjV1VrCwU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMyvYEnz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMyvYEnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C599AC4CEE7;
	Tue, 28 Oct 2025 09:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761642314;
	bh=V0eGMEDYNjmZcItSuYC29g2UnX0Z2vl5cwdDrIsClsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=yMyvYEnzpTp2MOjVQmTfUVy9NkK+HpZw70+IgxZWHgaUIJ/ZPNs23ySvUKz8Vw0ds
	 McHxCRsFiSGzvztrmF88bKzDtyqYM1kU5NfT9Lu9kAaRLo1g6xbwOJ+6nxOfEycS3u
	 17bq2xXT2unZREUCwBJASVyJnSeR3vE4vC1iQnMI=
Date: Tue, 28 Oct 2025 09:33:17 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/123] 5.15.196-rc1 review
Message-ID: <2025102850-obedience-filter-efca@gregkh>
References: <20251027183446.381986645@linuxfoundation.org>
 <d61b75c9-a6a1-452c-a2be-34959d354739@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d61b75c9-a6a1-452c-a2be-34959d354739@w6rz.net>

On Mon, Oct 27, 2025 at 09:49:59PM -0700, Ron Economos wrote:
> On 10/27/25 11:34, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.196 release.
> > There are 123 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.196-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> The RISC-V build fails with:
> 
> arch/riscv/kernel/cpu.c: In function 'riscv_of_processor_hartid':
> arch/riscv/kernel/cpu.c:24:33: error: implicit declaration of function
> 'of_get_cpu_hwid'; did you mean 'of_get_cpu_node'?
> [-Werror=implicit-function-declaration]
>    24 |         *hart = (unsigned long) of_get_cpu_hwid(node, 0);
>       |                                 ^~~~~~~~~~~~~~~
>       |                                 of_get_cpu_node
> cc1: some warnings being treated as errors
> 
> The function of_get_cpu_hwid() doesn't exist in Linux 5.15.x. It was
> introduced in 5.16-rc1. The following patches should be reverted:
> 
> 87b94f8227b3b654ea6e7670cefb32dab0e570ed RISC-V: Don't fail in
> riscv_of_parent_hartid() for disabled HARTs
> 
> 568d34c6aafa066bbdb5e7b6aed9c492d81964e8 RISC-V: Don't print details of CPUs
> disabled in DT
> 
> And the stable-dep-of patches for the above should also be reverted since
> they cause warnings:
> 
> 989694ece94da2bbae6c6f3f044994302f923cc8 riscv: cpu: Add 64bit hartid
> support on RV64
> 
> 8c2544fd913bb7b29ee3af79e0b302036689fe7a RISC-V: Minimal parser for "riscv,
> isa" strings
> 
> e0cc917db8fb7b4881ad3e8feb76cefa06f04fe6 RISC-V: Correctly print supported
> extensions
> 
> c616540d6b67830bb4345130e8fa3d8e217249a0 iscv: Use of_get_cpu_hwid()

Thanks, I'll go drop all of these and push out a -rc2

greg k-h
