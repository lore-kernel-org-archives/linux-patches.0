Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB20728E22;
	Sat, 25 Nov 2023 15:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKxrMxyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F402BC433CD;
	Sat, 25 Nov 2023 15:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700926126;
	bh=1KRaU8TeoE9R72zXc6PRzxHhQWJkjHiZQSnThUh/uXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wKxrMxyIxupNOzJYPbr7vxyQKCRFvF1GhWt/ObgAa4sCBcjvm4By+TFneQH+3vRfY
	 VPh41O1aJT8Xet92ixoYidWAuyHZ/Rw7bCZWpOLc+POmkatBCvEn/f/d9zNjutTaKS
	 7NEj26T1nUWT0ql+V+SIrBGpBTjCEzF4GG4Wy4Ow=
Date: Sat, 25 Nov 2023 15:28:43 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nam Cao <namcao@linutronix.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.1 000/372] 6.1.64-rc1 review
Message-ID: <2023112529-another-defrost-0851@gregkh>
References: <20231124172010.413667921@linuxfoundation.org>
 <20231124222543.qaM-plhi@linutronix.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231124222543.qaM-plhi@linutronix.de>

On Fri, Nov 24, 2023 at 11:25:43PM +0100, Nam Cao wrote:
> On Fri, Nov 24, 2023 at 05:46:27PM +0000, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.64 release.
> > There are 372 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 26 Nov 2023 17:19:17 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.64-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> I got the following build error with riscv64 defconfig:
> 
>   CC      drivers/perf/riscv_pmu_sbi.o
> In file included from /home/namcao/linux-deb/linux/arch/riscv/include/asm/ptrace.h:10,
>                  from /home/namcao/linux-deb/linux/arch/riscv/include/uapi/asm/bpf_perf_event.h:5,
>                  from /home/namcao/linux-deb/linux/include/uapi/linux/bpf_perf_event.h:11,
>                  from /home/namcao/linux-deb/linux/include/linux/perf_event.h:18,
>                  from /home/namcao/linux-deb/linux/include/linux/perf/riscv_pmu.h:12,
>                  from /home/namcao/linux-deb/linux/drivers/perf/riscv_pmu_sbi.c:14:
> /home/namcao/linux-deb/linux/drivers/perf/riscv_pmu_sbi.c: In function ‘pmu_sbi_ovf_handler’:
> /home/namcao/linux-deb/linux/drivers/perf/riscv_pmu_sbi.c:582:40: error: ‘riscv_pmu_irq_num’ undeclared (first use in this function); did you mean ‘riscv_pmu_irq’?
>   582 |                 csr_clear(CSR_SIP, BIT(riscv_pmu_irq_num));
>       |                                        ^~~~~~~~~~~~~~~~~
> /home/namcao/linux-deb/linux/arch/riscv/include/asm/csr.h:400:45: note: in definition of macro ‘csr_clear’
>   400 |         unsigned long __v = (unsigned long)(val);               \
>       |                                             ^~~
> /home/namcao/linux-deb/linux/drivers/perf/riscv_pmu_sbi.c:582:36: note: in expansion of macro ‘BIT’
>   582 |                 csr_clear(CSR_SIP, BIT(riscv_pmu_irq_num));
>       |                                    ^~~
> /home/namcao/linux-deb/linux/drivers/perf/riscv_pmu_sbi.c:582:40: note: each undeclared identifier is reported only once for each function it appears in
>   582 |                 csr_clear(CSR_SIP, BIT(riscv_pmu_irq_num));
>       |                                        ^~~~~~~~~~~~~~~~~
> /home/namcao/linux-deb/linux/arch/riscv/include/asm/csr.h:400:45: note: in definition of macro ‘csr_clear’
>   400 |         unsigned long __v = (unsigned long)(val);               \
>       |                                             ^~~
> /home/namcao/linux-deb/linux/drivers/perf/riscv_pmu_sbi.c:582:36: note: in expansion of macro ‘BIT’
>   582 |                 csr_clear(CSR_SIP, BIT(riscv_pmu_irq_num));
>       |                                    ^~~

Should now be fixed, I'll push out a -rc2 soon to verify.

thanks,

greg k-h
