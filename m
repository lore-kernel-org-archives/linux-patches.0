Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5EBDDB8;
	Mon, 10 Jun 2024 06:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718000913; cv=none; b=RNzcAguw4TkEMJqUHVxDiGUUDF+9oeDnq5Y5+0F1WtXRO8JN1rYM96I8AeoLt219GhvcXotv+nTtHt3w959KtbcIZWLtEz2NHOc8F2uZM4JX/cgJ/Xgf190HRcQgIdR7KRxbpZQvZ/pXsQOkx+Qe7gYQqot7VFCu8JfrRvxj04s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718000913; c=relaxed/simple;
	bh=n+45C+dzb+IYsjD+JRFt0LVF45703pUQPGysWo6ZIKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f/IbXXF7Ketd12YhGjpL+L7+pKD20BhYWL6KRcSLtyYU12T/QTMcefBkmjM1PDxyzAijNedQ5TKOEvC5vuDfH7JQok1wiRnO78ZIZPkyCRuh1X3T63k/v5jEySfDiOh3NIOQHQ1YRyvkySRmBDK8qgSmT23IYIfGAhipT/43Sj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xR71rL5T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xR71rL5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5A4C2BBFC;
	Mon, 10 Jun 2024 06:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718000912;
	bh=n+45C+dzb+IYsjD+JRFt0LVF45703pUQPGysWo6ZIKI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xR71rL5TAYFEOcCHdz2R5dRyRmyw9NteBPCGPgornxj0gRD68QN2W2Q06R/KalSJs
	 vQt7j4Yo3yNzYmEseHZahlhp5elSsfmizivcWe/JF8VsfILJx1x30DERMHNX4x8el7
	 vhAmSpkf+nOJPC/WudNmMtLDrlqthqzQKGeQUl0M=
Date: Mon, 10 Jun 2024 08:28:29 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: Pavel Machek <pavel@denx.de>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/741] 6.6.33-rc2 review
Message-ID: <2024061006-overdress-outburst-36ae@gregkh>
References: <20240609113903.732882729@linuxfoundation.org>
 <ZmYDquU9rsJ2HG9g@duo.ucw.cz>
 <ad13afda-6d20-fa88-ae7f-c1a69b1f5a40@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ad13afda-6d20-fa88-ae7f-c1a69b1f5a40@w6rz.net>

On Sun, Jun 09, 2024 at 11:21:55PM -0700, Ron Economos wrote:
> On 6/9/24 12:34 PM, Pavel Machek wrote:
> > Hi!
> > 
> > > This is the start of the stable review cycle for the 6.6.33 release.
> > > There are 741 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 6.6 seems to have build problem on risc-v:
> > 
> >    CC      kernel/locking/qrwlock.o
> > 690
> >    CC      lib/bug.o
> > 691
> >    CC      block/blk-rq-qos.o
> > 692
> > arch/riscv/kernel/suspend.c: In function 'suspend_save_csrs':
> > 693
> > arch/riscv/kernel/suspend.c:14:66: error: 'RISCV_ISA_EXT_XLINUXENVCFG' undeclared (first use in this function); did you mean 'RISCV_ISA_EXT_ZIFENCEI'?
> > 694
> >     14 |         if (riscv_cpu_has_extension_unlikely(smp_processor_id(), RISCV_ISA_EXT_XLINUXENVCFG))
> > 695
> >        |                                                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~
> > 696
> >        |                                                                  RISCV_ISA_EXT_ZIFENCEI
> > 697
> > arch/riscv/kernel/suspend.c:14:66: note: each undeclared identifier is reported only once for each function it appears in
> > 698
> >    CC      io_uring/io-wq.o
> > 699
> > arch/riscv/kernel/suspend.c: In function 'suspend_restore_csrs':
> > 700
> > arch/riscv/kernel/suspend.c:37:66: error: 'RISCV_ISA_EXT_XLINUXENVCFG' undeclared (first use in this function); did you mean 'RISCV_ISA_EXT_ZIFENCEI'?
> > 701
> >     37 |         if (riscv_cpu_has_extension_unlikely(smp_processor_id(), RISCV_ISA_EXT_XLINUXENVCFG))
> > 702
> >        |                                                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~
> > 703
> >        |                                                                  RISCV_ISA_EXT_ZIFENCEI
> > 704
> > make[4]: *** [scripts/Makefile.build:243: arch/riscv/kernel/suspend.o] Error 1
> > 705
> > make[3]: *** [scripts/Makefile.build:480: arch/riscv/kernel] Error 2
> > 706
> > make[2]: *** [scripts/Makefile.build:480: arch/riscv] Error 2
> > 707
> > make[2]: *** Waiting for unfinished jobs....
> > 708
> >    CC      lib/buildid.o
> > 709
> > 
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/7053222239
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1324369118
> > 
> > No problems detected on 6.8-stable and 6.1-stable.
> > 
> > Best regards,
> > 								Pavel
> 
> I'm seeing the same thing here. Somehow some extra patches got slipped in
> between rc1 and rc2. The new patches for RISC-V are:
> 
> Samuel Holland <samuel.holland@sifive.com>
>     riscv: Save/restore envcfg CSR during CPU suspend
> 
> commit 88b55a586b87994a33e0285c9e8881485e9b77ea
> 
> Samuel Holland <samuel.holland@sifive.com>
>     riscv: Fix enabling cbo.zero when running in M-mode
> 
> commit 8c6e096cf527d65e693bfbf00aa6791149c58552
> 
> The first patch "riscv: Save/restore envcfg CSR during CPU suspend" causes
> the build failure.
> 
> 

Yes, these were added because they were marked as fixes for other
commits in the series.  I'll unwind them all now as something is going
wrong...

greg k-h
