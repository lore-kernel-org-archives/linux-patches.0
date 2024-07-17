Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730AB171C2;
	Wed, 17 Jul 2024 06:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721197365; cv=none; b=Kl271BwkOKVg5+2Ph9xFi4xrVyqhccmwApO5JGbf8MHQv3zkPlA7kikiEKFBEIdCixmjYSdZKVp6vCB5W+CT4r9zB6+tn3sF/vRf0cPaO6j/ijN2J8k5TwN0lsG35Fmi73vfxeE3N78nluCG+jeCcIyiuSwahDMOPENqJnS6lBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721197365; c=relaxed/simple;
	bh=J+VljWJXjRO0mtyXh0weqhbN/ipiXqTsaH5G0ffFjbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I3Pcn/2w1U3keW4/BIQiggAkGkq77wEfaxeeq23qNJwqVmi6WHid0vyMVMZ4VBUfu0IW0uAzpAaCVHYA8vdC6fDOnL60mlUhT5gc0zFk8tDMbl0V1u1UFpvoV9eG1Q9muRBcYOOcWPnawot/vutZ7eMR/IQv4Ci0VAu2W/mofRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z9DozURh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z9DozURh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFA9C32782;
	Wed, 17 Jul 2024 06:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721197365;
	bh=J+VljWJXjRO0mtyXh0weqhbN/ipiXqTsaH5G0ffFjbo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=z9DozURhVBeSFvMM/Ed04PRIgIIMCu+fKIBb74QncrnX6h06JU9mq68gu7n/CdjNa
	 QnYvvx798SdmRp0bYPlVOw16gk5X2ABIz0qDMfqKiqTpB5AbgAB2Jq/umkNFEJvnGv
	 W4dgBSDBzLwGWreUUNdGXhQ5ERnUd/fNGVnoQ/28=
Date: Wed, 17 Jul 2024 08:22:42 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH 5.10 000/108] 5.10.222-rc1 review
Message-ID: <2024071724-wham-contest-04a6@gregkh>
References: <20240716152745.988603303@linuxfoundation.org>
 <CA+G9fYskex_Z+r0wxv7XDdPVHrk=8jBPWH601mY_Q2mKDj-T=A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYskex_Z+r0wxv7XDdPVHrk=8jBPWH601mY_Q2mKDj-T=A@mail.gmail.com>

On Wed, Jul 17, 2024 at 02:17:51AM +0530, Naresh Kamboju wrote:
> On Tue, 16 Jul 2024 at 21:12, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.222 release.
> > There are 108 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.222-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> The 390 builds failed on stable-rc 5.10.222-rc1 review; it has been
> reported on 6.6, 6.1, 5.15 and now on 5.10.
> 
> Started from this round of stable rc on 5.10.222-rc1
> 
>   Good:6db6c4ec363b ("Linux 5.10.221-rc2")
>   BAD: 4ec8d630a600 ("Linux 5.10.222-rc1")
> 
> * s390, build
>   - clang-18-allnoconfig
>   - clang-18-defconfig
>   - clang-18-tinyconfig
>   - clang-nightly-allnoconfig
>   - clang-nightly-defconfig
>   - clang-nightly-tinyconfig
>   - gcc-12-allnoconfig
>   - gcc-12-defconfig
>   - gcc-12-tinyconfig
>   - gcc-8-allnoconfig
>   - gcc-8-defconfig-fe40093d
>   - gcc-8-tinyconfig
> 
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build log:
> -------
> linux/arch/s390/include/asm/processor.h: In function '__load_psw_mask':
> arch/s390/include/asm/processor.h:255:19: error: expected '=', ',',
> ';', 'asm' or '__attribute__' before '__uninitialized'
>   255 |         psw_t psw __uninitialized;
>       |                   ^~~~~~~~~~~~~~~
> arch/s390/include/asm/processor.h:255:19: error: '__uninitialized'
> undeclared (first use in this function)
> arch/s390/include/asm/processor.h:255:19: note: each undeclared
> identifier is reported only once for each function it appears in
> arch/s390/include/asm/processor.h:256:9: warning: ISO C90 forbids
> mixed declarations and code [-Wdeclaration-after-statement]
>   256 |         unsigned long addr;
>       |         ^~~~~~~~
> arch/s390/include/asm/processor.h:258:9: error: 'psw' undeclared
> (first use in this function); did you mean 'psw_t'?
>   258 |         psw.mask = mask;
>       |         ^~~
>       |         psw_t

Should now be fixed, will push out -rc2 releases later today with the
attempted resolution.

greg k-h
