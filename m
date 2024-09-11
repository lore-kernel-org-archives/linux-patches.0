Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB5313AA3E;
	Wed, 11 Sep 2024 12:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726059275; cv=none; b=KUtVdYMbjphPfN1R6JaI9m+U9B4KwMRhiwHthYpYxVMq3UC/N1SWhHsf4ogeiC9X33gyLqLWIQSUjR7onCqeOgYTbn6b3C3g6kMONFYKAuytXkDE4bW7raMmspaPKzAdU6N/3NsUP4cqxlKKZ1uo8Y2/Pct7I3YQnlbFlZoOLeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726059275; c=relaxed/simple;
	bh=gAmWUWLu5Kc7LOL3W8UeyCBstrlv8Yqg6dt+6uIMxbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nUyu6+36MK9x9kZjOZfvXAAOs7XqgHDhsIcirao3uOYw1FDJ9qxxX3QM+JIYCfwvDFKt1tAvGClUZxTB0sXMDzRJHXMG7fSnIjnJPusNFoarK+0wFDDEkoTxz3Vz0Rljjz49dvBeavFwni1vt4GV6U2HloYeT/KXrKu+aFuTnYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxmN0lTK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxmN0lTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFFCC4CEC5;
	Wed, 11 Sep 2024 12:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726059274;
	bh=gAmWUWLu5Kc7LOL3W8UeyCBstrlv8Yqg6dt+6uIMxbA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TxmN0lTKPzrUgFH/wOiXmg+XtU1KsY4993sZ97jl9daVN4IA0XCKnlOFx7LW2t8lt
	 u1EBtEDepj04DtWf2GOJe85xKcmMKu+eX/Zlg/cybz1li4IyiR1YroVtfJjH2p4261
	 J9rMdQ1sAuOaccB4A+QU8T/Gjyqfg9D0mrgqOHrA=
Date: Wed, 11 Sep 2024 14:54:31 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Linux-sh list <linux-sh@vger.kernel.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Peter Zijlstra <peterz@infradead.org>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 6.1 000/192] 6.1.110-rc1 review
Message-ID: <2024091115-aloe-stipend-ee06@gregkh>
References: <20240910092557.876094467@linuxfoundation.org>
 <CA+G9fYufdd0MGMO1NbXgJwN1+wPHB24_Nrok9TMX=fYKXaxXLA@mail.gmail.com>
 <CA+G9fYv1yHoL9r7PkunHPNyPznLxfB9spSFbWvoFBBSwOYrT3g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYv1yHoL9r7PkunHPNyPznLxfB9spSFbWvoFBBSwOYrT3g@mail.gmail.com>

On Tue, Sep 10, 2024 at 08:05:27PM +0530, Naresh Kamboju wrote:
> On Tue, 10 Sept 2024 at 18:24, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Tue, 10 Sept 2024 at 15:36, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.1.110 release.
> > > There are 192 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.110-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> >
> > The SuperH defconfig builds failed due to following build warnings / errors
> > on the stable-rc linux-6.1.y.
> >
> > * SuperH, build
> >   - gcc-8-defconfig
> >   - gcc-11-shx3_defconfig
> >   - gcc-11-defconfig
> >   - gcc-8-shx3_defconfig
> >
> > Build log:
> > --------
> > In file included from  include/linux/mm.h:29,
> >                  from  arch/sh/kernel/asm-offsets.c:14:
> >  include/linux/pgtable.h: In function 'pmdp_get_lockless':
> >  include/linux/pgtable.h:379:20: error: 'pmd_t' has no member named 'pmd_low'
> >   379 |                 pmd.pmd_low = pmdp->pmd_low;
> >       |                    ^
> >  include/linux/pgtable.h:379:35: error: 'pmd_t' has no member named 'pmd_low'
> >   379 |                 pmd.pmd_low = pmdp->pmd_low;
> >       |                                   ^~
> >
> 
> Anders bisected this down to,
> # first bad commit:
>   [4f5373c50a1177e2a195f0ef6a6e5b7f64bf8b6c]
>   mm: Fix pmd_read_atomic()
>     [ Upstream commit 024d232ae4fcd7a7ce8ea239607d6c1246d7adc8 ]
> 
>   AFAICT there's no reason to do anything different than what we do for
>   PTEs. Make it so (also affects SH)

Ok, I'm going to drop this series as it shouldn't be breaking builds :(

thanks,

greg k-h
