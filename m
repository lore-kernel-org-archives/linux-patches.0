Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A83211181
	for <patches@lists.linux.dev>; Wed,  1 Nov 2023 11:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHv5tFRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6B8C433C8;
	Wed,  1 Nov 2023 11:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698838095;
	bh=zTevJbffh+9cM71RMMvtJP7fdhsk+r1e28m6D6t6HoU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GHv5tFRl0oNKk4kfZtX8gmvIGzi9cuBDC7YcQhOVCwUo8I3VKBtMCEpOc5t7rV0F5
	 4F1fMM9zs+JwcKmPAAdXoyMi6zVJEAsQOi9KCHU6ki9lV4MaK3VBm8OdIONTNraMwd
	 X/4nc6BG6pGYmUN3NmssuePzXu+0a1PYsRQO+hss=
Date: Wed, 1 Nov 2023 12:28:12 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.5 000/112] 6.5.10-rc1 review
Message-ID: <2023110142-crimp-varied-fe90@gregkh>
References: <20231031165901.318222981@linuxfoundation.org>
 <38fbd463-1160-0212-b9d2-6efeaaa6548e@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <38fbd463-1160-0212-b9d2-6efeaaa6548e@w6rz.net>

On Tue, Oct 31, 2023 at 03:51:39PM -0700, Ron Economos wrote:
> On 10/31/23 10:00 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.5.10 release.
> > There are 112 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 02 Nov 2023 16:58:38 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.10-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> The build fails on RISC-V.
> 
> arch/riscv/mm/hugetlbpage.c: In function ‘set_huge_pte_at’:
> arch/riscv/mm/hugetlbpage.c:188:13: error: ‘sz’ undeclared (first use in
> this function); did you mean ‘s8’?
>   188 |         if (sz >= PGDIR_SIZE)
>       |             ^~
>       |             s8
> arch/riscv/mm/hugetlbpage.c:188:13: note: each undeclared identifier is
> reported only once for each function it appears in
> 
> Caused by commit 16b6f77970f7a690c61de142511c9ac488d83e04
> 
> riscv: fix set_huge_pte_at() for NAPOT mappings when a swap entry is set
> 
> This patch requires mainline commit 62ba41d2761206664a1fdc998051324457da2dd6
> 
> mm: riscv: fix an unsafe pte read in huge_pte_alloc()

Thanks, I'll just drop this commit and wait for someone who cares about
riscv, and 6.5.y (it's only going to be alive for another few weeks), to
resend the needed changes.

greg k-h
