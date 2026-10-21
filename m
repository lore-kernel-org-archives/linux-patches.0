Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792568762;
	b=ZdiRhoxcwnv1DDZPCWhG1Kxo48Yb86+/XI2cAUtXEK1yMkBJN80+3RXmEKo6HN5Hlxb8
	 1qIR4L1QvyuDHXvQtwTPUmDx2E3TOsxeM8N2mCy/Oa5+aeJx9e1Ir/a9Mekns1OaIgufN
	 om/ixzt+FkqaF9hZLHW50hi5LiRW7xocHzy07rMIWaX4OPg+fpEIkMue9DQto9kDdxcDp
	 3H6PKrqd+VNCorer3nnxxCrZN7jLatsaT/+HXd3ZJNkIrSZfsZK/q6X66cL+5haV3QN0m
	 2IYy7VOjcZ7S+rqu8Oze+wRPmAZeu4FlWzG9WxAvTtlwJiLFZry1SyfX3kYq2AEVp4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792568762;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=SFN8gYn+RF8fPSaaK8mqyJ5ZeLixW3+cdNYTNRujQ4M=;
	b=VC28TWzVcvVe67Y4xGkT1pyAu01KJ6goMJb0tzu0GBJYeAi5dcesRTDvQMen70RDpoW4
	 P6N4KG5QngJQ3bBb9LEss5Cqgto0V+mcjJYq7lTv07X+Wyi2CwMoj1sgsL2unDHBooxz6
	 +mtFPqa903Gdy+sm9kcG8xW/lR/CwHnUacb1/tK9gmuzVMnKI5sfhXrbAKa1Cz7jYnkcR
	 0ANbf51B2Y+PivKBDQ9gxalYPO9KK7UzuOyvwFpx+npGJ7BknYaxG9/rzGf/ERsZYa1GR
	 zNfvcuJjh79Jm1ngwsoKcoQFNNvd2akMdtkOgTMP84BiVOd2wY74QmDZRI/n6Xm/wjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZuWNFmzA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A32606A31C;
	Wed, 21 Oct 2026 07:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZuWNFmzA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4A21F000C9;
	Wed, 21 Oct 2026 07:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792568761;
	bh=SFN8gYn+RF8fPSaaK8mqyJ5ZeLixW3+cdNYTNRujQ4M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZuWNFmzAE88AW5F68+RnmxHkF8zw17bwz0/kqqdOuNLDoFE/juDrGzCxoRS2tsVM8
	 tfo7cDhYhyIArth896moOZg6icT4Saa3kTYH29v8p199U9rGO5XiTIaXN/+FhNQ38y
	 Dq+Yv8/kzCtuPvPr0Go/C2ApEPE0UL7TBC8VtwGE=
Date: Wed, 21 Oct 2026 09:45:16 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 0000/1651] 6.6.160-rc2 review
Message-ID: <2026102152-yield-ripping-7709@gregkh>
References: <20261020075535.084584701@linuxfoundation.org>
 <beac545f-9a17-4a47-a4cd-7a705302a35c@gmail.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <beac545f-9a17-4a47-a4cd-7a705302a35c@gmail.com>

On Tue, Oct 20, 2026 at 09:14:08AM -0700, Florian Fainelli wrote:
> On 10/20/26 00:57, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.160 release.
> > There are 1651 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 22 Oct 2026 07:53:04 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.160-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> perf build issues are fixed, however we now we get the MIPS kernel to fail
> building with:
> 
> arch/mips/kernel/ftrace.c: In function 'ftrace_dyn_arch_init_insns':
> arch/mips/kernel/ftrace.c:62:6: error: implicit declaration of function
> 'uasm_in_compat_space_p'; did you mean 'uasm_i_dsra_safe'?
> [-Werror=implicit-function-declaration]
>   if (uasm_in_compat_space_p(MCOUNT_ADDR)) {
>       ^~~~~~~~~~~~~~~~~~~~~~
>       uasm_i_dsra_safe
> cc1: some warnings being treated as errors

Looks like this is missing commit e9f98feb1720 ("mips: unhide
uasm_in_compat_space_p() declaration"), so I'll go queue that up now,

thanks.

greg k-h
