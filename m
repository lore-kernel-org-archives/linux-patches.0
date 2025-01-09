Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D38A2165E3;
	Thu,  9 Jan 2025 11:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736421022; cv=none; b=l/71HGyrxwMqbaTpO/gIG3DGdPZSQ6huk0MMaVPkeygim4ML6FHo/2s4iLEmgMRdh6B+TA7T+i5OVgI0DVUc5Aw8a8duEm4y0Tdaf+mN8NmCLye5INZb39iW2CjhwBYF2SqF36zsaOpm0yI4xyR5dXp/HPsNWXcShHbhkEMv9sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736421022; c=relaxed/simple;
	bh=saPJfGL5HcZGuAmHxJK4KJXlcjFEiRqX297G5X1zF+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aTzb0JHMoZY7vX5z6GK6jOTdFKXVYMs4QpeVjFtBv+UH3CiCnWc7wOpk56T9eCPf4mOpyGDZxBpQfigOt9eLZY51hCtj+wPFhZitXdjHFg3agjvMGfDAoca6C6BuUFQbYnnW7dfg1+mYfZTBQ3+2yqTv+eW7nvumCkC0R45B4xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJBGjWmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJBGjWmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7C7C4CEDF;
	Thu,  9 Jan 2025 11:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736421022;
	bh=saPJfGL5HcZGuAmHxJK4KJXlcjFEiRqX297G5X1zF+4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RJBGjWmNb76Lhi2pJB1shjGv26NDHdPxH2ywlln/VNf1aOVgibN/z7fmp0JL+O4YG
	 tIYsDTiWVoHlnbG8NJYeoEAEQKDvnesPJbuUq5LGc0ptfHIQzMso1pmAatDAtaSHIT
	 R2I4Ij4PigRBwa11wq27TaY0qFUKGIwVDmn/OFaY=
Date: Thu, 9 Jan 2025 12:10:18 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 000/168] 5.15.176-rc1 review
Message-ID: <2025010910-hypocrite-handler-1f1b@gregkh>
References: <20250106151138.451846855@linuxfoundation.org>
 <fc58a412-b154-4286-9097-4f3c5d7d97aa@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fc58a412-b154-4286-9097-4f3c5d7d97aa@w6rz.net>

On Mon, Jan 06, 2025 at 10:32:32PM -0800, Ron Economos wrote:
> On 1/6/25 07:15, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.176 release.
> > There are 168 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.176-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> On RISC-V, the build fails with:
> 
> In file included from mm/kfence/core.c:33:
> ./arch/riscv/include/asm/kfence.h: In function 'kfence_protect_page':
> ./arch/riscv/include/asm/kfence.h:59:9: error: implicit declaration of
> function 'local_flush_tlb_kernel_range'; did you mean
> 'flush_tlb_kernel_range'? [-Werror=implicit-function-declaration]
>    59 |         local_flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |         flush_tlb_kernel_range
> In file included from mm/kfence/report.c:20:
> ./arch/riscv/include/asm/kfence.h: In function 'kfence_protect_page':
> ./arch/riscv/include/asm/kfence.h:59:9: error: implicit declaration of
> function 'local_flush_tlb_kernel_range'; did you mean
> 'flush_tlb_kernel_range'? [-Werror=implicit-function-declaration]
>    59 |         local_flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |         flush_tlb_kernel_range
> 
> This is caused by commit d28e50e231ce20a9b9cad9edce139ac775421ce5 riscv: Fix
> IPIs usage in kfence_protect_page().
> 
> The function local_flush_tlb_kernel_range() doesn't exist for RISC-V in
> 5.15.x and doesn't appear until much later in 6.8-rc1. So probably best to
> drop this patch.

Thanks, now dropped.

greg k-h
