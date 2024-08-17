Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2A312A14C;
	Sat, 17 Aug 2024 07:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723880810; cv=none; b=Um2b9EztFPmy6AlbUTSmYcFW9J3vtHmDl8V/QT0rtyH/V9puzA6Pn2V9YuTAMU/Kxem6lvCTEOoARinIUgNIuX3zZifdHcWRIuC/yFUlJCU9GZ6v8nmNTOTgQ9YOVWQVH2JMXFMgWze2NLhHNYGANh3pBx50Z4SSkLxKK9fmX/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723880810; c=relaxed/simple;
	bh=Ib0ACuWB7kZbkA52/2x04uv+DeKXHOcV5bgNDI9VQjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XrKmQdJIns6z4TTohIsE8OvVOon1OGC4rDCZ82JUSk9+GI+flJAi3GpuW02LnRz0FZtkxkIqTWL1KS/eGkPzAf9AOBiFqFDlDe6uxAlh1lxgGwqyBj3QOkRSTEMDbjV0koWAKmAKYOxZELMTzIDifmFQJL2K1gvltUOqsmxxrqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHGs9nqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHGs9nqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB031C116B1;
	Sat, 17 Aug 2024 07:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723880809;
	bh=Ib0ACuWB7kZbkA52/2x04uv+DeKXHOcV5bgNDI9VQjo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MHGs9nqI9Nnh+G/NUJROr0wa0xu9M1n8BQK9Hmjai9zJNfmI3c/XhjPZD4r7BJnJ0
	 EmHeYlHtFmP7RCZw9ZWz6chRKjTohIS7owIPHTbSHupzPYe4giyeqqbiUmInpTMZhq
	 owXjHU9pVUOuL2kMnVZ965evnaaJrQHZYv7xVgME=
Date: Sat, 17 Aug 2024 09:46:46 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anders Roxell <anders.roxell@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH 5.10 000/350] 5.10.224-rc2 review
Message-ID: <2024081734-unsold-unsliced-a14f@gregkh>
References: <20240816101509.001640500@linuxfoundation.org>
 <CADYN=9+gT_me8D_+KtWqmS9_vZg7=dTat90dPCNSieSjq9sFXg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADYN=9+gT_me8D_+KtWqmS9_vZg7=dTat90dPCNSieSjq9sFXg@mail.gmail.com>

On Sat, Aug 17, 2024 at 07:57:39AM +0200, Anders Roxell wrote:
> On Fri, 16 Aug 2024 at 12:22, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.224 release.
> > There are 350 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 18 Aug 2024 10:14:04 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.224-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The following S390 build failed on stable-rc 5.10.y with gcc-12 and clang due
> to following warnings and errors [1].
> 
> s390:
>   build:
>     * gcc-8-defconfig-fe40093d
>     * gcc-12-defconfig
>     * clang-18-defconfig
> 
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> The bisect points to 0fbb54ce4bff ("KVM: s390: pv: avoid stalls when
> making pages secure")
> as the problematic commit [ Upstream commit
> f0a1a0615a6ff6d38af2c65a522698fb4bb85df6 ].
> 
> Build log:
> --------
> /builds/linux/arch/s390/kernel/uv.c: In function 'make_page_secure':
> /builds/linux/arch/s390/kernel/uv.c:240:19: error: 'UVC_CC_OK'
> undeclared (first use in this function)
>   240 |         if (cc == UVC_CC_OK)
>       |                   ^~~~~~~~~
> /builds/linux/arch/s390/kernel/uv.c:240:19: note: each undeclared
> identifier is reported only once for each function it appears in
> /builds/linux/arch/s390/kernel/uv.c:242:24: error: 'UVC_CC_BUSY'
> undeclared (first use in this function); did you mean 'SIGP_CC_BUSY'?
>   242 |         else if (cc == UVC_CC_BUSY || cc == UVC_CC_PARTIAL)
>       |                        ^~~~~~~~~~~
>       |                        SIGP_CC_BUSY
> /builds/linux/arch/s390/kernel/uv.c:242:45: error: 'UVC_CC_PARTIAL'
> undeclared (first use in this function)
>   242 |         else if (cc == UVC_CC_BUSY || cc == UVC_CC_PARTIAL)
>       |                                             ^~~~~~~~~~~~~~
> /builds/linux/arch/s390/kernel/uv.c: In function 'should_export_before_import':
> /builds/linux/arch/s390/kernel/uv.c:270:40: error: 'mm_context_t' has
> no member named 'protected_count'
>   270 |         return atomic_read(&mm->context.protected_count) > 1;
>       |                                        ^
> /builds/linux/arch/s390/kernel/uv.c:271:1: error: control reaches end
> of non-void function [-Werror=return-type]
>   271 | }
>       | ^
> cc1: some warnings being treated as errors
> make[3]: *** [/builds/linux/scripts/Makefile.build:286:
> arch/s390/kernel/uv.o] Error 1
> 
> 
> Build log link:
> --------
> [1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.223-351-g470450f8c61c/testrun/24890569/suite/build/test/gcc-12-defconfig/log

I'll go drop the offending commits and push out a -rc3 soon, thanks!

greg k-h
