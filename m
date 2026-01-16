Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F403612E0;
	Fri, 16 Jan 2026 10:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768560681; cv=none; b=gpNL0mypeEHSIKXXd81E5YW74jwWUXHDJxQ4dWyXkgbadE8xOpLZEX7PDSwp98lj3ANBTNTy/H3L4epishgFJ/KFvGff0eS/qv7C3NVXY61DIBvDjRqhquUjp1kiHH4rIKCyH6BvqcLol3EvPq4emJe6qaFJRL+DY8g8+sMNiKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768560681; c=relaxed/simple;
	bh=C/iOXXypU3ALZ5u2DCCVNIJDpsdSLXv3Ax1IBS55cr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CTn5dxSjF8imALFFpqUvJsEN2I4PZNEUZQTltPKC4yTRYRyEKHHM2fyqgCg73CXVR0ZixD3YZggVAyQpgFdAVOE/ra1xLk5rfCs14FihYogx5vhw8RCSRdf2g7dY7vD48BoMayA24+k/g4k73NeHhp6379S2bR42QkWr/drQXXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=szxW9VX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="szxW9VX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F015DC116C6;
	Fri, 16 Jan 2026 10:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768560680;
	bh=C/iOXXypU3ALZ5u2DCCVNIJDpsdSLXv3Ax1IBS55cr4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=szxW9VX83GZ5NfKf/wbY6UGayDmRZBjaljza7alCN+tZWa4T6Mt/gdUThn+eftMSF
	 DvwVhtxzO/cS6dtMplHjETyHXn/x1akB9QTzvUD4Meec8uzaTVPQA5Ug5tc9+/dxS1
	 FJ4kBmmsOf7klsE3uR5y7/3xjeIyiw9j7cLbsdG0=
Date: Fri, 16 Jan 2026 11:51:12 +0100
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
Subject: Re: [PATCH 6.6 00/88] 6.6.121-rc1 review
Message-ID: <2026011656-yodel-explode-757d@gregkh>
References: <20260115164146.312481509@linuxfoundation.org>
 <ee407adc-5458-4bc9-9a26-f6026488fcca@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ee407adc-5458-4bc9-9a26-f6026488fcca@w6rz.net>

On Fri, Jan 16, 2026 at 02:17:49AM -0800, Ron Economos wrote:
> On 1/15/26 08:47, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.121 release.
> > There are 88 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.121-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Built and booted successfully on RISC-V RV64 (HiFive Unmatched).
> 
> There is a new warning caused by commit "riscv: uprobes: Add missing fence.i after building the XOL buffer"
> 
> arch/riscv/kernel/probes/uprobes.c: In function 'arch_uprobe_copy_ixol':
> arch/riscv/kernel/probes/uprobes.c:170:23: warning: unused variable 'start' [-Wunused-variable]
>   170 |         unsigned long start = (unsigned long)dst;
>       |                       ^~~~~
> 
> This can be fixed by adding the upstream companion commit "riscv: Replace
> function-like macro by static inline function", commit id
> 121f34341d396b666d8a90b24768b40e08ca0d61

I would, but it doesn't apply cleanly :(

Can you provide a working backport?

thanks,

greg k-h
