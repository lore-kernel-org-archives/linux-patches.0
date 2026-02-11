Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729EE30C619;
	Wed, 11 Feb 2026 11:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770809664; cv=none; b=VRo6cK4v/tyO4z8BbU04nZSo5PEF0N9l9ejX9eNK01YyaI2i356WaZ5v9qQzkQUYyNhR9yRT71/4eas1thXxp70pWxlQ52RKA0YxvKrDHklYflsZAFnrtYcIECedr6ivXFKr/5i5+V9ONE7SlZYD2pMAF/vNCO6v0z2DeDGcYPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770809664; c=relaxed/simple;
	bh=vMyMBNeMUt3sklnAr4/f2e8cY/XRVFNSUbINEvD2eM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HCtfieAfO1mVqae/88x05Hr5602GxkfwfQ6OYvFsuPfWQodC2fIaX7XJrp/7RM7L49Hwoc76f/vqCRG2nrHAWvEG2JfpZK0soT/2zZY1gJj/r0WkW3E3lYyuAJZmAOWiprIvTFsAZbYJ4WWGBczDwWTvG92XE6vY8+a6pd0Um3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LxO1mt0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LxO1mt0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEEAC4CEF7;
	Wed, 11 Feb 2026 11:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770809664;
	bh=vMyMBNeMUt3sklnAr4/f2e8cY/XRVFNSUbINEvD2eM4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0LxO1mt00/aaWa+nMkx7JtRhGeBv/0RpUeqr6Arvwp/9EL8xlS4V4H83PEhdxgy93
	 BOUK6gpT0+MlzAWf8qQZJzpkI9X6cBigvaB6vCvghEb8ne753O9t9czG/iT8ppe7NA
	 KrUkwbDujoC6LM9bAqcmO9o/Rvd8B2GC10ZXtXxc=
Date: Wed, 11 Feb 2026 12:34:20 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 00/69] 6.1.163-rc1 review
Message-ID: <2026021113-sweep-idealness-305e@gregkh>
References: <20260209142301.913348974@linuxfoundation.org>
 <4542559a-ed5a-4ab9-bdae-0978b2dc4b49@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4542559a-ed5a-4ab9-bdae-0978b2dc4b49@w6rz.net>

On Tue, Feb 10, 2026 at 12:55:28AM -0800, Ron Economos wrote:
> On 2/9/26 06:23, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.163 release.
> > There are 69 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.163-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> There's a build warning on RISC-V.
> 
> arch/riscv/kernel/probes/uprobes.c: In function 'arch_uprobe_copy_ixol':
> arch/riscv/kernel/probes/uprobes.c:164:23: warning: unused variable 'start' [-Wunused-variable]
>   164 |         unsigned long start = (unsigned long)dst;
>       |                       ^~~~~
> 
> This can fixed with the fixup patch that I sent for 6.6.121.
> 
> riscv: Replace function-like macro by static inline function
> 
> commit 0b1ac9743f3d9cfced2ac3cb9f274c0675bd4189
> 
> The cherry-pick applies cleanly.

Now queued up, thanks.

greg k-h
