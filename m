Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FBB168AF
	for <patches@lists.linux.dev>; Mon, 22 May 2023 18:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17778C433EF;
	Mon, 22 May 2023 18:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684781926;
	bh=A9BiorKEzoVHUnT2JtkigBVL2qLAn4Nit7bapPjzZ5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mF9crdwvpFoTJMaShPm/o/AUtJeq+vNlOPALaAjKxYEiNsLbVp2BHLVTN+3hhFu2B
	 97jLspIlMzb9m6jWNtblpIgBX4c89CqB6TE6GzZl6+rZYc+TJqhUHDgKAGaY9+k6rq
	 SN13lW67hGKTVJ1UmCDss7IBp9c+wtYJN1r2GIk0=
Date: Mon, 22 May 2023 19:58:44 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/381] 5.10.180-rc1 review
Message-ID: <2023052235-doing-launch-c511@gregkh>
References: <20230515161736.775969473@linuxfoundation.org>
 <ZGNJfAPd8eeVoCJ3@debian>
 <2023051711-thespian-sponsor-8878@gregkh>
 <CA+G9fYvw6HJopruUn4QKPCcqbdgw++AFf1wnwMP9hP1rJsmq3g@mail.gmail.com>
 <2023051704-catnip-vitality-d6cb@gregkh>
 <ZGUwiOkAc25BPi7M@debian>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGUwiOkAc25BPi7M@debian>

On Wed, May 17, 2023 at 08:52:40PM +0100, Sudip Mukherjee (Codethink) wrote:
> On Wed, May 17, 2023 at 11:51:21AM +0200, Greg Kroah-Hartman wrote:
> > On Wed, May 17, 2023 at 03:11:48PM +0530, Naresh Kamboju wrote:
> > > On Wed, 17 May 2023 at 14:21, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Tue, May 16, 2023 at 10:14:36AM +0100, Sudip Mukherjee (Codethink) wrote:
> > > > > Hi Greg,
> > > > >
> > > > > On Mon, May 15, 2023 at 06:24:11PM +0200, Greg Kroah-Hartman wrote:
> > > > > > This is the start of the stable review cycle for the 5.10.180 release.
> > > > > > There are 381 patches in this series, all will be posted as a response
> > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > let me know.
> > > > >
> > > > > Build test (gcc version 11.3.1 20230511):
> > > > > mips: 63 configs -> no failure
> > > > > arm: 104 configs -> no failure
> > > > > arm64: 3 configs -> 1 failure
> > > > > x86_64: 4 configs -> no failure
> > > > > alpha allmodconfig -> no failure
> > > > > powerpc allmodconfig -> no failure
> > > > > riscv allmodconfig -> no failure
> > > > > s390 allmodconfig -> no failure
> > > > > xtensa allmodconfig -> no failure
> > > > >
> > > > > arm64 allmodconfig build fails with the error:
> > > > >
> > > > > /gcc/bin/aarch64-linux-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe___kvm_tlb_flush_vmid_ipa':
> > > > > (.hyp.text+0x1a4c): undefined reference to `__kvm_nvhe_memset'
> > > > > /gcc/bin/aarch64-linux-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe___kvm_tlb_flush_vmid':
> > > > > (.hyp.text+0x1b20): undefined reference to `__kvm_nvhe_memset'
> > > > > /gcc/bin/aarch64-linux-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe___kvm_flush_cpu_context':
> > > > > (.hyp.text+0x1b80): undefined reference to `__kvm_nvhe_memset'
> > > >
> > > > That's odd, I don't see that symbol anywhere in the tree at all.
> > > >
> > > > And the only arm-related kvm changes don't have those symbols either
> > > > (the other kvm changes are x86-only)
> > > >
> > > > Also, no one else has seen this issue.  Can you bisect?
> > > 
> > > This is an old issue,
> > > Many other reported long back [1]
> > > 
> > > [1] https://lore.kernel.org/stable/CADYN=9KSKQx816id-zWepV-E3ozph3k2_i9Rhs6QseFv0hkPfg@mail.gmail.com/
> > 
> > Then maybe someone should submit it properly for inclusion?
> 
> Attached the backported patch. Also verified that my build failure is fixed with it.

Thanks, now queued up.

greg k-h
