Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EB125484D;
	Tue,  2 Dec 2025 15:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764689049; cv=none; b=BGtFOH3d+NNJw99VG4j9RitY+Yc7Q2fUiyECzOkiHs/8lAR092HPzUI07M4Nlglj5W8FTsEDKDIV4UYRyabQkMDk0LgSmodcID8EaWRWWwVu6qxTPR+Fs7+H0lP2099v++1SgqD8pjaw44ulBHtECzI2l1MWOXa7ShbpS60vXEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764689049; c=relaxed/simple;
	bh=YOXREj9WmU3ssWREa84AJ/dpNpRQZnS5aOoxcJvhNVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aakHcOHJxpMx5S+Du7Xzl+T84N8UI4v3gHnuo2+PId9qYbluGWWqlT9t9z0hetAkq1KkDZcr3Kh5bnC+k4De+jCIPoQFDFAQseTtB3Ov9qR0PeMk1d6DJklB/3CoBBJSEYBT+16kBSWqDs5dle0gy1YqzQB5iWccwgj0vph0oaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aSpYq1iw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSpYq1iw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6348CC4CEF1;
	Tue,  2 Dec 2025 15:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764689048;
	bh=YOXREj9WmU3ssWREa84AJ/dpNpRQZnS5aOoxcJvhNVc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aSpYq1iwoz4c8OJpnC9mQCGxFcSq4Ots0LV+iX0z6PkKanplAewgR1WJupU/+1BSW
	 Jtae/uWu82sPih0O/btS5XLOOnxuNHV7Rf2D3f2feZZLVfD3/c5EinnEAeZE6yUuWh
	 1qyhJsJSFc39WWutsGbyM6lBgQGx4fNvZ7rMFu9g=
Date: Tue, 2 Dec 2025 16:24:04 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, sr@sladewatkins.com,
	Ben Copeland <benjamin.copeland@linaro.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>, Hugh Dickins <hughd@google.com>,
	Sasha Levin <sashal@kernel.org>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH 5.4 000/184] 5.4.302-rc2 review
Message-ID: <2025120238-glider-raffle-99ea@gregkh>
References: <20251202095448.089783651@linuxfoundation.org>
 <CA+G9fYvF3cGqi_McG1AtfkMgd5EB_=nmcwiJAGFjZReP8dGKxg@mail.gmail.com>
 <aS7lPZPYuChOTdXU@hyeyoo>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aS7lPZPYuChOTdXU@hyeyoo>

On Tue, Dec 02, 2025 at 10:10:21PM +0900, Harry Yoo wrote:
> On Tue, Dec 02, 2025 at 06:02:33PM +0530, Naresh Kamboju wrote:
> > On Tue, 2 Dec 2025 at 15:41, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.4.302 release.
> > > There are 184 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 04 Dec 2025 09:54:14 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.302-rc2.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > The powerpc builds failed on the stable-rc 5.4.302-rc1 and 5.4.302-rc2.
> > 
> > * powerpc, build
> >   - clang-21-cell_defconfig
> >   - clang-nightly-cell_defconfig
> >   - gcc-12-cell_defconfig
> >   - gcc-12-defconfig
> >   - gcc-12-ppc64e_defconfig
> >   - gcc-12-ppc6xx_defconfig
> >   - gcc-8-cell_defconfig
> >   - gcc-8-defconfig
> >   - gcc-8-ppc64e_defconfig
> >   - gcc-8-ppc6xx_defconfig
> > 
> > Build regressions: powerpc: mm/mprotect.c:: pgtable.h:971:38: error:
> > called object 'pmd_val' is not a function or function pointer
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > The bisection is in progress,
> > meanwhile this patch looks to be causing the build failure,
> > 
> > mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()
> > commit 670ddd8cdcbd1d07a4571266ae3517f821728c3a upstream.
> > 
> > The sequence patch.
> > mm/mprotect: use long for page accountings and retval
> > commit a79390f5d6a78647fd70856bd42b22d994de0ba2 upstream.
> > 
> > ### Build error
> > In file included from include/linux/bug.h:5,
> >                  from include/linux/mmdebug.h:5,
> >                  from include/linux/mm.h:9,
> >                  from include/linux/pagewalk.h:5,
> >                  from mm/mprotect.c:12:
> > mm/mprotect.c: In function 'change_pte_range':
> > arch/powerpc/include/asm/book3s/64/pgtable.h:971:38: error: called
> > object 'pmd_val' is not a function or function pointer
> >   971 | #define pmd_page_vaddr(pmd)     __va(pmd_val(pmd) & ~PMD_MASKED_BITS)
> >       |                                      ^~~~~~~
> > arch/powerpc/include/asm/bug.h:91:32: note: in definition of macro 'WARN_ON'
> >    91 |         int __ret_warn_on = !!(x);                              \
> >       |                                ^
> > arch/powerpc/include/asm/page.h:229:9: note: in expansion of macro
> > 'VIRTUAL_WARN_ON'
> >   229 |         VIRTUAL_WARN_ON((unsigned long)(x) >= PAGE_OFFSET);
> >          \
> >       |         ^~~~~~~~~~~~~~~
> > arch/powerpc/include/asm/book3s/64/pgtable.h:971:33: note: in
> > expansion of macro '__va'
> >   971 | #define pmd_page_vaddr(pmd)     __va(pmd_val(pmd) & ~PMD_MASKED_BITS)
> >       |                                 ^~~~
> > arch/powerpc/include/asm/book3s/64/pgtable.h:1007:21: note: in
> > expansion of macro 'pmd_page_vaddr'
> >  1007 |         (((pte_t *) pmd_page_vaddr(*(dir))) + pte_index(addr))
> >       |                     ^~~~~~~~~~~~~~
> > arch/powerpc/include/asm/book3s/64/pgtable.h:1009:41: note: in
> > expansion of macro 'pte_offset_kernel'
> >  1009 | #define pte_offset_map(dir,addr)        pte_offset_kernel((dir), (addr))
> >       |                                         ^~~~~~~~~~~~~~~~~
> > include/linux/mm.h:2010:24: note: in expansion of macro 'pte_offset_map'
> >  2010 |         pte_t *__pte = pte_offset_map(pmd, address);    \
> >       |                        ^~~~~~~~~~~~~~
> > mm/mprotect.c:48:15: note: in expansion of macro 'pte_offset_map_lock'
> >    48 |         pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> >       |               ^~~~~~~~~~~~~~~~~~~
> > mm/mprotect.c:43:15: note: declared here
> >    43 |         pmd_t pmd_val;
> >       |               ^~~~~~~
> > In file included from arch/powerpc/include/asm/mmu.h:132,
> >                  from arch/powerpc/include/asm/lppaca.h:47,
> >                  from arch/powerpc/include/asm/paca.h:17,
> >                  from arch/powerpc/include/asm/current.h:13,
> >                  from include/linux/thread_info.h:22,
> >                  from include/asm-generic/preempt.h:5,
> >                  from ./arch/powerpc/include/generated/asm/preempt.h:1,
> >                  from include/linux/preempt.h:78,
> >                  from include/linux/spinlock.h:51,
> >                  from include/linux/mmzone.h:8,
> >                  from include/linux/gfp.h:6,
> >                  from include/linux/mm.h:10:
> > arch/powerpc/include/asm/book3s/64/pgtable.h:971:38: error: called
> > object 'pmd_val' is not a function or function pointer
> >   971 | #define pmd_page_vaddr(pmd)     __va(pmd_val(pmd) & ~PMD_MASKED_BITS)
> >       |                                      ^~~~~~~
> > arch/powerpc/include/asm/page.h:230:47: note: in definition of macro '__va'
> >   230 |         (void *)(unsigned long)((phys_addr_t)(x) |
> > PAGE_OFFSET);        \
> >       |                                               ^
> > arch/powerpc/include/asm/book3s/64/pgtable.h:1007:21: note: in
> > expansion of macro 'pmd_page_vaddr'
> >  1007 |         (((pte_t *) pmd_page_vaddr(*(dir))) + pte_index(addr))
> >       |                     ^~~~~~~~~~~~~~
> > arch/powerpc/include/asm/book3s/64/pgtable.h:1009:41: note: in
> > expansion of macro 'pte_offset_kernel'
> >  1009 | #define pte_offset_map(dir,addr)        pte_offset_kernel((dir), (addr))
> >       |                                         ^~~~~~~~~~~~~~~~~
> > include/linux/mm.h:2010:24: note: in expansion of macro 'pte_offset_map'
> >  2010 |         pte_t *__pte = pte_offset_map(pmd, address);    \
> >       |                        ^~~~~~~~~~~~~~
> > mm/mprotect.c:48:15: note: in expansion of macro 'pte_offset_map_lock'
> >    48 |         pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> >       |               ^~~~~~~~~~~~~~~~~~~
> > mm/mprotect.c:43:15: note: declared here
> >    43 |         pmd_t pmd_val;
> >       |               ^~~~~~~
> 
> Hi Naresh, thanks for reporting!
> 
> Whoa, I really didn't expect this.
> 
> I named the variable pmd_val, and during the expansion of
> pte_offset_map_lock(), we call pmd_val(), and the compiler is confused
> because it's calling a variable rather than a function or macro.
> 
> And it didn't show up on my testing environment because on x86_64
> implementation of pte_offset_map_lock() implementation we don't call
> pmd_val(). The fix would be simply renaming the variable.
> 
> To Greg and Sasha; I guess these patches will be dropped for this cycle
> and I'm supposed to send V2, right? These two patches are queued for
> 6.1, 5.15, 5.10 as well.

Ok, I'll go drop these from all of these branches now and wait for a v2.

I'll also push out a -rc3.

thanks,

greg k-h
