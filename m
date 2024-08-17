Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D939612A14C;
	Sat, 17 Aug 2024 07:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723880939; cv=none; b=ccnrYOxXNOCQHEuzE+KmdRXB/wUWbmxHQw/CuyUhWduGKaMOgfVpMXarRYqDQ+jYSvSfS1Q1m/KN5k12LpgI0HTLnVkGtN3+h51dIcUmh2gs8zojhfl30hHWOJDahckllJe0Sa5N6WSZi8TZbYuR8LWfNRSq3wQZ7SsZi9Cxy80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723880939; c=relaxed/simple;
	bh=YeQ0ew4nTAWmBwFPfDIPG+3FOTLvmmDX/j4ac/Z9frQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bMp5ZZM2FjW2RuAconmVwuaDaLrI2wr1PJPe93pHf4dl0mB9kdKsWapPsDjOjqL1xLjh/qdDcfsg3SP260xCKR9c3pyoNEwGc0nAX0qvXbFnW/1CEVDwiL5H0Rr0fBhdVTlHltfj0ztGsLtOh0d4sAw0zaQ0Y6n721FV1K7HfOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDmwuR3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDmwuR3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183D1C116B1;
	Sat, 17 Aug 2024 07:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723880938;
	bh=YeQ0ew4nTAWmBwFPfDIPG+3FOTLvmmDX/j4ac/Z9frQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qDmwuR3oqJXLmggJPYmDacYgPfLt7YpmtJGpR4ZkJ+f73R5cTVh6nNzzXQ6egYL3c
	 OjPUlQzFUouDwKdD+qSu6hd1Hf/MQYBDwdIV+rPgh045j1zZUd3VF3zZd/rlF9Nciw
	 7v2JoUDjVpTZ3XzH54fdUiHmVtguLByxgjiLdTI8=
Date: Sat, 17 Aug 2024 09:48:55 +0200
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
Subject: Re: [PATCH 5.15 000/483] 5.15.165-rc2 review
Message-ID: <2024081743-frisbee-unbutton-476d@gregkh>
References: <20240816101524.478149768@linuxfoundation.org>
 <CADYN=9KMRjaxqtcc-Yo9ZDK3b2HH7gzJiwTrUXz7t0x0TO6=uA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADYN=9KMRjaxqtcc-Yo9ZDK3b2HH7gzJiwTrUXz7t0x0TO6=uA@mail.gmail.com>

On Sat, Aug 17, 2024 at 07:55:42AM +0200, Anders Roxell wrote:
> On Fri, 16 Aug 2024 at 12:22, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.165 release.
> > There are 483 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 18 Aug 2024 10:14:00 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.165-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The following S390 build failed on stable-rc 5.15.y with gcc-12 and clang due
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
> The bisect points to 85cf9455e504 ("KVM: s390: pv: avoid stalls when
> making pages secure")
> as the problematic commit [ Upstream commit
> f0a1a0615a6ff6d38af2c65a522698fb4bb85df6 ].
> 
> Build log:
> --------
> /builds/linux/arch/s390/kernel/uv.c: In function 'make_page_secure':
> /builds/linux/arch/s390/kernel/uv.c:219:19: error: 'UVC_CC_OK'
> undeclared (first use in this function)
>   219 |         if (cc == UVC_CC_OK)
>       |                   ^~~~~~~~~
> /builds/linux/arch/s390/kernel/uv.c:219:19: note: each undeclared
> identifier is reported only once for each function it appears in
> /builds/linux/arch/s390/kernel/uv.c:221:24: error: 'UVC_CC_BUSY'
> undeclared (first use in this function); did you mean 'SIGP_CC_BUSY'?
>   221 |         else if (cc == UVC_CC_BUSY || cc == UVC_CC_PARTIAL)
>       |                        ^~~~~~~~~~~
>       |                        SIGP_CC_BUSY
> /builds/linux/arch/s390/kernel/uv.c:221:45: error: 'UVC_CC_PARTIAL'
> undeclared (first use in this function)
>   221 |         else if (cc == UVC_CC_BUSY || cc == UVC_CC_PARTIAL)
>       |                                             ^~~~~~~~~~~~~~
> /builds/linux/arch/s390/kernel/uv.c: In function 'should_export_before_import':
> /builds/linux/arch/s390/kernel/uv.c:249:40: error: 'mm_context_t' has
> no member named 'protected_count'
>   249 |         return atomic_read(&mm->context.protected_count) > 1;
>       |                                        ^
> /builds/linux/arch/s390/kernel/uv.c:250:1: error: control reaches end
> of non-void function [-Werror=return-type]
>   250 | }
>       | ^
> cc1: some warnings being treated as errors
> 
> 
> Build log link:
> --------
> [1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.164-484-gaff234a5be72/testrun/24890486/suite/build/test/gcc-12-defconfig/log

I'll go fix this up and push out a rc3, thanks.

greg k-h
