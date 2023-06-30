Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B785388
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 05:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1336BC433C8;
	Fri, 30 Jun 2023 05:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688104221;
	bh=ESK2G48YltYCxadHZpYQGs+sh5/rH0av8mftNPwo74w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zzgSDOpSRmMfnHUxxICmQO7XNFeYAmAZ0dt9gyjPGuUpC4S3Ks+JemIjUHr5Dqcve
	 3tMucQ4Z5T9Cd1DlaPFdAumMhO0PnTKuKJpXE2gwLmPVTtmtoBxLcn66PbDFFCg5ny
	 yqvmk4YSRWCZ9vyRZGX3xzCZvc0pMjPLGKorh19g=
Date: Fri, 30 Jun 2023 07:50:18 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.3 00/29] 6.3.11-rc1 review
Message-ID: <2023063057-viewpoint-bottle-aec6@gregkh>
References: <20230629184151.705870770@linuxfoundation.org>
 <CAEUSe7__cNqH6d1D96m8XriVckS9MnL6CRfd+iTYXnNkqu9nvQ@mail.gmail.com>
 <2023063037-matrix-urologist-030d@gregkh>
 <CAEUSe7-K199dv5_11O877i4pWYtCkaZU2zrsfVo4-QnNPdPQ+A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe7-K199dv5_11O877i4pWYtCkaZU2zrsfVo4-QnNPdPQ+A@mail.gmail.com>

On Thu, Jun 29, 2023 at 11:25:13PM -0600, Daniel Díaz wrote:
> Hello!
> 
> On Thu, 29 Jun 2023 at 23:19, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Thu, Jun 29, 2023 at 03:54:03PM -0600, Daniel Díaz wrote:
> > > Hello!
> > >
> > > Early report of failures.
> > >
> > > Arm64 fails with GCC-11 on the following configurations:
> > > * lkftconfig
> > > * lkftconfig-64k_page_size
> > > * lkftconfig-debug
> > > * lkftconfig-debug-kmemleak
> > > * lkftconfig-kasan
> > > * lkftconfig-kselftest
> > > * lkftconfig-kunit
> > > * lkftconfig-libgpiod
> > > * lkftconfig-perf
> > > * lkftconfig-rcutorture
> > >
> > > lkftconfig is basically defconfig + a few fragments [1]. The suffixes
> > > mean that we're enabling a few other kconfigs.
> > >
> > > Failure:
> > > -----8<-----
> > > /builds/linux/arch/arm64/mm/fault.c: In function 'do_page_fault':
> > > /builds/linux/arch/arm64/mm/fault.c:576:9: error: 'vma' undeclared
> > > (first use in this function); did you mean 'vmap'?
> > >   576 |         vma = lock_mm_and_find_vma(mm, addr, regs);
> > >       |         ^~~
> > >       |         vmap
> > > /builds/linux/arch/arm64/mm/fault.c:576:9: note: each undeclared
> > > identifier is reported only once for each function it appears in
> > > /builds/linux/arch/arm64/mm/fault.c:579:17: error: label 'done' used
> > > but not defined
> > >   579 |                 goto done;
> > >       |                 ^~~~
> > > make[4]: *** [/builds/linux/scripts/Makefile.build:252:
> > > arch/arm64/mm/fault.o] Error 1
> > > make[4]: Target 'arch/arm64/mm/' not remade because of errors.
> > > ----->8-----
> >
> > Is this also failing in Linus's tree?
> 
> (Sorry for the previous top-post.)
> 
> No, only here on 6.3.

Ok, found the problem, will push out a -rc2 now, thanks for the quick
notice!

greg k-h
