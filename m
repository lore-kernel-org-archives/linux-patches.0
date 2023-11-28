Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FF61E48E;
	Tue, 28 Nov 2023 15:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGn+1/T/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D9EC433C7;
	Tue, 28 Nov 2023 15:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701186355;
	bh=8rY6TA3NSAkF9JG5HOzJ8ff3+LplvArK8YdCLW++XDU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uGn+1/T/NHZhQPL0TOkHSv62Ex0ajuoXyWKc9Ux3u9VD2TYBHlu/abZ17jIxwqd3q
	 yDtkumKn4Z/SZdG4Pc79tLKJ5bFcK9RPj1n4e4Nqne6Xbqq+1YrfjwdfeJIWXHp5PF
	 CIQF7Eu8XQOQOQV4/IXuBmcdqrLVRbM0C/hEoyMU=
Date: Tue, 28 Nov 2023 15:45:52 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Conor Dooley <conor.dooley@microchip.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/366] 6.1.64-rc4 review
Message-ID: <2023112838-blandness-exodus-5ff8@gregkh>
References: <20231126154359.953633996@linuxfoundation.org>
 <20231128-perceive-impulsive-754e8e2e2bbf@wendy>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128-perceive-impulsive-754e8e2e2bbf@wendy>

On Tue, Nov 28, 2023 at 11:38:30AM +0000, Conor Dooley wrote:
> On Sun, Nov 26, 2023 at 03:46:28PM +0000, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.64 release.
> > There are 366 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> I missed testing 6.1.63 so I noticed this only here, but my CI is
> complaining about seeing some
> [    0.000000] Couldn't find cpu id for hartid [0]
> during boot.
> 
> It was caused by
> 
> commit 3df98bd3196665f2fd37fcc5b2d483a24a314095
> Author: Anup Patel <apatel@ventanamicro.com>
> Date:   Fri Oct 27 21:12:53 2023 +0530
> 
>     RISC-V: Don't fail in riscv_of_parent_hartid() for disabled HARTs
>     
>     [ Upstream commit c4676f8dc1e12e68d6511f9ed89707fdad4c962c ]
>     
>     The riscv_of_processor_hartid() used by riscv_of_parent_hartid() fails
>     for HARTs disabled in the DT. This results in the following warning
>     thrown by the RISC-V INTC driver for the E-core on SiFive boards:
>     
>     [    0.000000] riscv-intc: unable to find hart id for /cpus/cpu@0/interrupt-controller
>     
>     The riscv_of_parent_hartid() is only expected to read the hartid
>     from the DT so we directly call of_get_cpu_hwid() instead of calling
>     riscv_of_processor_hartid().
>     
>     Fixes: ad635e723e17 ("riscv: cpu: Add 64bit hartid support on RV64")
>     Signed-off-by: Anup Patel <apatel@ventanamicro.com>
>     Reviewed-by: Atish Patra <atishp@rivosinc.com>
>     Link: https://lore.kernel.org/r/20231027154254.355853-2-apatel@ventanamicro.com
>     Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> and there is already a fix for this in Linus' tree though that you can
> pick:
> 52909f176802 ("RISC-V: drop error print from riscv_hartid_to_cpuid()")
> 
> That's just one error print that realistically has no impact on the
> operation of the system, and is not introduced by this particular
> version, so
> 
> Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks, I'll go queue that patch up now too, can't hurt :)

greg k-h
