Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6924630CDA5;
	Wed, 27 Aug 2025 10:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756289736; cv=none; b=KyqSdyeguW2AwjkTSsKcqCCUCv58IzAGvk0f0GdEYs/SJP9lzaS1qeJRGFP7zEq8pzFYDwgtEEoaZjbxvaOptviX796efKZOcFsoNN4YzEYiJMhDs1Siv4j0dKm2VYoxFgAIXIovrv5qKApCfq7u+zNvOvXwcIPBIpcR/iCx9Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756289736; c=relaxed/simple;
	bh=OQ+yvCCFCsWaI83eu7/VReKdOT2dxxpJBArhG22r4zU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SUw7z2reNbisMdctmDzZisCVctsltR1cHHOfs3DC8hcggrwomXA4Vj2/k/IvQv4r74Hh6V+4s4mQ6nhEKWEI7M3siChG9sEFs6Gdqw21aRA6cuLjZMerk+DQarBsMzpCCN8U05IZtfQOJRukOVtvPqusH2dqMw3ByAHwMgFzZkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tFfnc+1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tFfnc+1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461B9C113CF;
	Wed, 27 Aug 2025 10:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756289735;
	bh=OQ+yvCCFCsWaI83eu7/VReKdOT2dxxpJBArhG22r4zU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tFfnc+1SSnw7p/ME3+k0aF48AI3oMrKgdEzXuiZL82HfcfRnGuU90yhLlpfYdmghc
	 +lBxLU1oa/s2RnIHcmzXSWobQfm6Q/BZJDP//+py/3SAAgkh21R7qiXQlBq3BWRRSX
	 /H/GjLLy7s3bN4tVFF5B+Xl/p/ir5KqvSiq7wmOY=
Date: Wed, 27 Aug 2025 12:15:33 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anders Roxell <anders.roxell@linaro.org>
Cc: Jon Hunter <jonathanh@nvidia.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 5.4 000/403] 5.4.297-rc1 review
Message-ID: <2025082712-sworn-yonder-e5f3@gregkh>
References: <20250826110905.607690791@linuxfoundation.org>
 <ed898a83-48d1-4cce-87b4-b67ee4fdc047@nvidia.com>
 <2025082705-ascent-parted-b05d@gregkh>
 <CADYN=9JXM14H+N-08GWxs1xigRKHfy_SrCCJGnhuGyDXgGycVg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADYN=9JXM14H+N-08GWxs1xigRKHfy_SrCCJGnhuGyDXgGycVg@mail.gmail.com>

On Wed, Aug 27, 2025 at 11:19:11AM +0200, Anders Roxell wrote:
> On Wed, 27 Aug 2025 at 09:36, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Aug 26, 2025 at 03:46:37PM +0100, Jon Hunter wrote:
> > > Hi Greg,
> > >
> > > On 26/08/2025 12:05, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.4.297 release.
> > > > There are 403 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Thu, 28 Aug 2025 11:08:17 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.297-rc1.gz
> > > > or in the git tree and branch at:
> > > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > > >
> > > > -------------
> > > > Pseudo-Shortlog of commits:
> > >
> > > ...
> > > > Prashant Malani <pmalani@google.com>
> > > >      cpufreq: CPPC: Mark driver with NEED_UPDATE_LIMITS flag
> > >
> > >
> > > The above commit is causing the following build failure ...
> > >
> > >  drivers/cpufreq/cppc_cpufreq.c:410:40: error: ‘CPUFREQ_NEED_UPDATE_LIMITS’ undeclared here (not in a function)
> > >   410 |         .flags = CPUFREQ_CONST_LOOPS | CPUFREQ_NEED_UPDATE_LIMITS,
> > >       |                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~
> > >  make[2]: *** [scripts/Makefile.build:262: drivers/cpufreq/cppc_cpufreq.o] Error 1
> > >
> > >
> > > This is seen with ARM64 but I am guessing will be seen for
> > > other targets too.
> >
> > Thanks, somehow this missed my build tests.  I've dropped it from the
> > tree now and will push out a -rc2.
> 
> [for the record]
> 
> We also see the following build regression on ARM64 with gcc-12 and clang-20.
> 
> Validation is in progress for RC2.
> 
> 
> Build Regression: 5.4.297-rc1 arm64 use of undeclared identifier
> CPUFREQ_NEED_UPDATE_LIMITS
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Should be fixed in -rc2, right?
