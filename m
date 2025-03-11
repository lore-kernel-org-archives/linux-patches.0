Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB176230BD1;
	Tue, 11 Mar 2025 09:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741686776; cv=none; b=Xc6305n8Gs7/d8VOnP6YW/MfNvzG9g1flh9m06T0EqtMD2SDkYArMZzlArth5g55WoASoN2xuYXsZ8KIh2x9wm5773Xz7pBsZ44dcct0H53pLiKoscWzqoAysRO7DLIBtlF4kGtrp4iSUPL3WFgJ4bY9b+QPlJDShXRfPV0puX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741686776; c=relaxed/simple;
	bh=J2tmnpVcVYDj7jfW55SL3FOk3G+EyfoxP1nQem3juJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wb18P5U+ID1jdybCjipBDJvpoMEMj7HzbjmtbIo2LX3DugRQTNbBIlOMydYWr5PyvqZBPo6aogORWUNFo28egerUDxea9hXtpXcXDge5avA/fTk91Qt/PGAQzN5fpiWBnDKVNNXik01GLHPtOjP+cowlZelJnaMgZpDxs9AIhkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s2/ec8DW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2/ec8DW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD92C4CEEB;
	Tue, 11 Mar 2025 09:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741686776;
	bh=J2tmnpVcVYDj7jfW55SL3FOk3G+EyfoxP1nQem3juJ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s2/ec8DWt+H/JL3KlEQ+dqLAWY5ITkf3xI9NCFjBqVshXnKUB5olX539MXaD+wtqX
	 PwhrNGIMbrJ8+mnPYMWqLl8fNzaXHydZnkEfcUThICsPnoLfhfqQ+aN3MuZJAOLiVV
	 gu4vR/lAMOkp6e1pK4D73gDrlz4rT8MKqFndURdc=
Date: Tue, 11 Mar 2025 10:52:53 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/145] 6.6.83-rc1 review
Message-ID: <2025031142-hurricane-gracious-5403@gregkh>
References: <20250310170434.733307314@linuxfoundation.org>
 <81784d87-b837-4476-974a-87b0333e7e38@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81784d87-b837-4476-974a-87b0333e7e38@w6rz.net>

On Mon, Mar 10, 2025 at 07:31:54PM -0700, Ron Economos wrote:
> On 3/10/25 10:04, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.83 release.
> > There are 145 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.83-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> The build fails on RISC-V with:
> 
> arch/riscv/kernel/suspend.c: In function 'suspend_save_csrs':
> arch/riscv/kernel/suspend.c:14:66: error: 'RISCV_ISA_EXT_XLINUXENVCFG'
> undeclared (first use in this function); did you mean
> 'RISCV_ISA_EXT_ZIFENCEI'?
>    14 |         if (riscv_cpu_has_extension_unlikely(smp_processor_id(),
> RISCV_ISA_EXT_XLINUXENVCFG))
> | ^~~~~~~~~~~~~~~~~~~~~~~~~~
> | RISCV_ISA_EXT_ZIFENCEI
> arch/riscv/kernel/suspend.c:14:66: note: each undeclared identifier is
> reported only once for each function it appears in
> arch/riscv/kernel/suspend.c: In function 'suspend_restore_csrs':
> arch/riscv/kernel/suspend.c:37:66: error: 'RISCV_ISA_EXT_XLINUXENVCFG'
> undeclared (first use in this function); did you mean
> 'RISCV_ISA_EXT_ZIFENCEI'?
>    37 |         if (riscv_cpu_has_extension_unlikely(smp_processor_id(),
> RISCV_ISA_EXT_XLINUXENVCFG))
> | ^~~~~~~~~~~~~~~~~~~~~~~~~~
> | RISCV_ISA_EXT_ZIFENCEI
> make[4]: *** [scripts/Makefile.build:243: arch/riscv/kernel/suspend.o] Error
> 1
> 
> Reverting commit "riscv: Save/restore envcfg CSR during suspend"
> 8bf2e196c94af0a384f7bb545d54d501a1e9c510 fixes the build.

Thanks, offending commit now dropped.

greg k-h
