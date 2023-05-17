Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4D73D62
	for <patches@lists.linux.dev>; Wed, 17 May 2023 08:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B5EC433EF;
	Wed, 17 May 2023 08:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684313466;
	bh=8BhycqlJAWzVNQ8w1EwRwdnYUlS3UWhW4kfx4xXZ0b8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sOjSHfCZ48rD2SR98tO++PRNtsXhs6EKNm0br8Hqx+xvy5HUKhtRxZCbI3YATetfY
	 fRdfyk4RlHM6Yk2pAk11e9YOWJQj/3k+vMoO1UX97D1QBScn7FYIi5/9YZ5CBX1EFd
	 Z5zMgsNwvdAlS9M8CizEpLOeM2qjnZqmIR+5ipYI=
Date: Wed, 17 May 2023 10:51:03 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/381] 5.10.180-rc1 review
Message-ID: <2023051711-thespian-sponsor-8878@gregkh>
References: <20230515161736.775969473@linuxfoundation.org>
 <ZGNJfAPd8eeVoCJ3@debian>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGNJfAPd8eeVoCJ3@debian>

On Tue, May 16, 2023 at 10:14:36AM +0100, Sudip Mukherjee (Codethink) wrote:
> Hi Greg,
> 
> On Mon, May 15, 2023 at 06:24:11PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.180 release.
> > There are 381 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Build test (gcc version 11.3.1 20230511):
> mips: 63 configs -> no failure
> arm: 104 configs -> no failure
> arm64: 3 configs -> 1 failure
> x86_64: 4 configs -> no failure
> alpha allmodconfig -> no failure
> powerpc allmodconfig -> no failure
> riscv allmodconfig -> no failure
> s390 allmodconfig -> no failure
> xtensa allmodconfig -> no failure
> 
> arm64 allmodconfig build fails with the error:
> 
> /gcc/bin/aarch64-linux-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe___kvm_tlb_flush_vmid_ipa':
> (.hyp.text+0x1a4c): undefined reference to `__kvm_nvhe_memset'
> /gcc/bin/aarch64-linux-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe___kvm_tlb_flush_vmid':
> (.hyp.text+0x1b20): undefined reference to `__kvm_nvhe_memset'
> /gcc/bin/aarch64-linux-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe___kvm_flush_cpu_context':
> (.hyp.text+0x1b80): undefined reference to `__kvm_nvhe_memset'

That's odd, I don't see that symbol anywhere in the tree at all.

And the only arm-related kvm changes don't have those symbols either
(the other kvm changes are x86-only)

Also, no one else has seen this issue.  Can you bisect?

thanks,

greg k-h
