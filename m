Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388BB31A89;
	Sat, 15 Jun 2024 11:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718449854; cv=none; b=R03WUDsrO71EoDOrSWUHa164aDilHyKgfYcgiS9JVRYVd4Vvk+GqwD1LTGy0ryDvy1P+aSM0bghDzeDVfQCy+yJ6uqhm7YMnfGkOVZtp946k99ztWfAUFUPJPx9RNZw9NeochjYfUb/IZc1dd3qjLGrmaMvrXsXF7hMVFCb5zQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718449854; c=relaxed/simple;
	bh=4/d1L5z+cUOqmr43BNSd9R03m3W+RMJLKlqbLFIbEMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FmusINmLNPaf887KK/wkb56CIyZ/hOuLmwHfRV6mlRDnkQJ7kAdWR2z5JDtt+QkKOVUVcvyQUyEbpzC85bOY9Z9KXQaOXE3vGy1aXf7X9VPrDCv95lyheytuAc8Ix4qKX+VDrICXtAN96uaopR8E+hYvlu0nQRQ5gMJZNDeiD8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSj/6T9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSj/6T9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E556EC116B1;
	Sat, 15 Jun 2024 11:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718449853;
	bh=4/d1L5z+cUOqmr43BNSd9R03m3W+RMJLKlqbLFIbEMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pSj/6T9WqQbCeC1f0xQdRGh/c/bxxoQt8qRItTfcpuiDPmeXrh3vG20NVKvmjYVaS
	 uGIVQVhbSP94nCIlxck6CElG7b8L3x0GGZQWqSTGCRuyQ9u2hSfX1SKIsvMqjN+KOF
	 zGPUZyBCsW8w/hy3F9F+Sd7Qe2taF56VNDB7DWd8=
Date: Sat, 15 Jun 2024 13:10:50 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Puranjay Mohan <puranjay12@gmail.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org,
	Puranjay Mohan <puranjay@kernel.org>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 6.6 000/137] 6.6.34-rc1 review
Message-ID: <2024061543-drop-down-calibrate-e6d4@gregkh>
References: <20240613113223.281378087@linuxfoundation.org>
 <CA+G9fYtEkcPasc62FH170nPyJTS83jfdAtHUfgwG+QDuQP060g@mail.gmail.com>
 <CA+G9fYvwJxJdsSeTGsKjKonkiJnDC13t1+mpjHhyCvc_2r3=-w@mail.gmail.com>
 <CANk7y0i5919ih8UML+YtTr6MomemiJVu+4rpsU95TPBWv7bmeA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANk7y0i5919ih8UML+YtTr6MomemiJVu+4rpsU95TPBWv7bmeA@mail.gmail.com>

On Fri, Jun 14, 2024 at 11:36:41AM +0200, Puranjay Mohan wrote:
> Hi Greg and Naresh,
> 
> On Fri, Jun 14, 2024 at 11:15 AM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
> >
> > On Thu, 13 Jun 2024 at 20:15, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > >
> > > On Thu, 13 Jun 2024 at 17:35, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 6.6.34 release.
> > > > There are 137 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.34-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > > The powerpc defconfig builds failed on stable-rc 6.6 branch due to below
> > > build errors with gcc-13, gcc-8 and clang.
> > >
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > >
> > > Build log:
> > > ----
> > > arch/powerpc/net/bpf_jit_comp64.c: In function 'bpf_jit_build_body':
> > > arch/powerpc/net/bpf_jit_comp64.c:1010:73: error: 'fimage' undeclared
> > > (first use in this function); did you mean 'image'?
> > >  1010 |                                 ret =
> > > bpf_jit_emit_func_call_hlp(image, fimage, ctx, func_addr);
> > >       |
> > >          ^~~~~~
> > >       |
> > >          image
> > > arch/powerpc/net/bpf_jit_comp64.c:1010:73: note: each undeclared
> > > identifier is reported only once for each function it appears in
> >
> > Anders bisected this and found following patch,
> >  first bad commit:
> >  [2298022fd5c6c428872f5741592526b8f4aadcf8]
> >   powerpc/64/bpf: fix tail calls for PCREL addressing
> 
> ^ this patch can't be backported directly as it is using 'fimage' that
> was introduced by:
> 90d862f370b6 ("powerpc/bpf: use bpf_jit_binary_pack_[alloc|finalize|free]")
> 
> We need to manually rework this patch for the backport.

Ok, now dropped, thanks!

greg k-h
