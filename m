Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394521A2FCB;
	Thu,  4 Jul 2024 07:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720078223; cv=none; b=IhNmukaAMUUWoQKSJjxEDZCmgtkgtDjTzubQ/aEawJOAroBGv9tXtW7oepvfPbJUEebfMuNpwEYehHOhUVHztZLvtKsgJN5AWPj1F1NcZoqUM7o4ApjVypl2boG8j6+qXDy4S/9Q843sUCt+3CTjlUS7wbAx78TtiaVC/J8aAUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720078223; c=relaxed/simple;
	bh=+XsSWaLUJdjgW6Z1Yd0izygnXPmE2jOzvUc6dpxUa+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=psGm80K+g/mMJbVx3Rw3qoLqnC3jlv6h2vHiXVF/KFNFG803AgRT6sI0oHCE4Io5UJjKDP26EU+rByJR503hf/DAIk56wdCNqyP0q2Zo8up9GXNPjecZTwWbTSw59HRud+e0Vt1SsyuLFwAFyoD6gVZAieG0TsjCrS4E2N4Ctys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uY1ughWE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uY1ughWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350EEC3277B;
	Thu,  4 Jul 2024 07:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720078222;
	bh=+XsSWaLUJdjgW6Z1Yd0izygnXPmE2jOzvUc6dpxUa+4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uY1ughWENbV8QUsIX5F2WqorH3to6TH7dUVMkCfSEGcXui6eV7Y2+xgu3TsY1DSNO
	 bY8kzwmOvI+cOj7ccTba2nyaAmcq+g9EjbIbK97XWtJru9eQX50wEPYhZgmBNo4z/I
	 6AD1jyTSEq1mUORKrG0L4M/WAJLJnwQS/OWCCIC4=
Date: Thu, 4 Jul 2024 09:30:19 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Kees Cook <keescook@chromium.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 6.6 000/163] 6.6.37-rc1 review
Message-ID: <2024070458-compile-amused-7d1c@gregkh>
References: <20240702170233.048122282@linuxfoundation.org>
 <CA+G9fYs=KkeYFMS01s3VZmeSYd1zJphinPFCk1G2AJ7LZ=+8=A@mail.gmail.com>
 <CA+G9fYvcbdKN8B9t-ukO2aZCOwkjNme8+XhLcL-=wcd+XXRP6g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvcbdKN8B9t-ukO2aZCOwkjNme8+XhLcL-=wcd+XXRP6g@mail.gmail.com>

On Wed, Jul 03, 2024 at 06:04:57PM +0530, Naresh Kamboju wrote:
> On Wed, 3 Jul 2024 at 14:27, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Tue, 2 Jul 2024 at 22:48, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.6.37 release.
> > > There are 163 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.37-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > The following powerpc builds failed on stable-rc 6.6.
> >
> > powerpc:
> >  - gcc-13-defconfig
> >  - clang-18-defconfig
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > Build log:
> > ---------
> > arch/powerpc/net/bpf_jit_comp.c: In function 'bpf_int_jit_compile':
> > arch/powerpc/net/bpf_jit_comp.c:208:17: error: ignoring return value
> > of 'bpf_jit_binary_lock_ro' declared with attribute
> > 'warn_unused_result' [-Werror=unused-result]
> >   208 |                 bpf_jit_binary_lock_ro(bpf_hdr);
> >       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > cc1: all warnings being treated as errors
> >
> 
> Anders bisected this down to,
> first bad commit: [28ae2e78321b5ac25958b3fcae0dcc80116e0c50]
>   bpf: Take return from set_memory_rox() into account with
> bpf_jit_binary_lock_ro()

Thanks, that's due to some changes that happened in 6.7 in this area,
I've queued those changes up now and will push out a -rc2 later today.

greg k-h
