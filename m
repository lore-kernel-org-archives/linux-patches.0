Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0042E090B;
	Wed, 17 Dec 2025 09:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765963527; cv=none; b=LNB0IiMAAP/gxQEtTH0Di7AZfzZlVar0LV+jyIQYLCkX1G0pNCyd79VvYFBFDe0uq+KuWXPuyKz8qkL7pcsIDfzSx+mDu0P4VJDjU7Vx4oyBpbLwnyxOlXq2JJYE6JHRUAo2iCyFIwpuUfp00nDL/Au6w15/e5xFy4rn49jhUkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765963527; c=relaxed/simple;
	bh=b5o62gHNbX5G+pDDguX4+HPkfgHbIu84rraUhDYycpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KLOSXjQdRwMYJq2cRtclIrJ1XTtUOqAvCciovAnoBS1TfKC8mefRKuLBsYik3HoFYFDsmJkz+YMsf02W3h8Sd7ADFYhqCuyX8JyuNNeZqMirSs+7D3c84qhVwYfS0aXtTjxE3DM/hZl9QAihNWBRBJdwtSLo/Kb2OpGAifbpw2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITJhHePS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITJhHePS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF5AC4CEF5;
	Wed, 17 Dec 2025 09:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765963526;
	bh=b5o62gHNbX5G+pDDguX4+HPkfgHbIu84rraUhDYycpM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ITJhHePSFKSANm3l1jmlOObuqZAG79T7bhp0w9Q/vKfRMZppuQnZN587QANBOz3r2
	 tjv3WRfBcNePhJNxpntqkfSRwo3OdMsydthYe9ZaPCW/i6M60sH2ICe0cmbg97tgdd
	 1eCi0hV+J/Wque/THphThTudZWJlLa7krvlyI2bo=
Date: Wed, 17 Dec 2025 10:25:23 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
	conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com,
	jonathanh@nvidia.com, linux-kernel@vger.kernel.org,
	linux@roeck-us.net, lkft-triage@lists.linaro.org,
	patches@kernelci.org, patches@lists.linux.dev, pavel@denx.de,
	rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com,
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org, dan.carpenter@linaro.org,
	nathan@kernel.org, llvm@lists.linux.dev, perex@perex.cz,
	lgirdwood@gmail.com,
	Linux Kernel Functional Testing <lkft@linaro.org>
Subject: Re: [PATCH 6.18 000/614] 6.18.2-rc1 review
Message-ID: <2025121713-greedless-brought-48dc@gregkh>
References: <20251216111401.280873349@linuxfoundation.org>
 <20251216195255.172999-1-naresh.kamboju@linaro.org>
 <2025121719-degrading-drainpipe-fb2e@gregkh>
 <CA+G9fYvc==Vz83Kka7J84XHA-hhig0CKGHixRVBAzGDv-1BA7A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvc==Vz83Kka7J84XHA-hhig0CKGHixRVBAzGDv-1BA7A@mail.gmail.com>

On Wed, Dec 17, 2025 at 01:36:31PM +0530, Naresh Kamboju wrote:
> On Wed, 17 Dec 2025 at 12:00, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Dec 17, 2025 at 01:22:55AM +0530, Naresh Kamboju wrote:
> > > I'm seeing the following allmodconfig and allyesconfig build
> > > failures on arm, arm64, riscv and x86_64.
> > >
> > > ## Build error
> > > sound/soc/codecs/nau8325.c:430:13: error: variable 'n2_max' is uninitialized when used here [-Werror,-Wuninitialized]
> > >   430 |                 *n2_sel = n2_max;
> > >       |                           ^~~~~~
> > > sound/soc/codecs/nau8325.c:389:52: note: initialize the variable 'n2_max' to silence this warning
> > >   389 |         int i, j, mclk, mclk_max, ratio, ratio_sel, n2_max;
> > >       |                                                           ^
> > >       |                                                            = 0
> > > sound/soc/codecs/nau8325.c:431:11: error: variable 'ratio_sel' is uninitialized when used here [-Werror,-Wuninitialized]
> > >   431 |                 ratio = ratio_sel;
> > >       |                         ^~~~~~~~~
> > > sound/soc/codecs/nau8325.c:389:44: note: initialize the variable 'ratio_sel' to silence this warning
> > >   389 |         int i, j, mclk, mclk_max, ratio, ratio_sel, n2_max;
> > >       |                                                   ^
> > >       |                                                    = 0
> > > 2 errors generated.
> > > make[6]: *** [scripts/Makefile.build:287: sound/soc/codecs/nau8325.o] Error 1
> > >
> > > First seen on 6.18.2-rc1
> > > Good: 6.18.1-rc1
> > > Bad:  6.18.2-rc1
> > >
> > > And these build regressions also seen on 6.17.13-rc2.
> >
> > Thanks, I'll go queue up the fix for this.
> 
> This build regression is across the 6.18.2-rc1, 6.17.13-rc2 and 6.12.63-rc1.

The fix was applied to all of these now, thanks.

greg k-h
