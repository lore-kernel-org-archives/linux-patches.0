Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D031D2857F0;
	Wed, 22 Jul 2026 12:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784722843; cv=none; b=a0UZY1XIAVaqhSuWWkLnn18siQ8caRHDzKFjTxAYf3XaEPecaG01Ez88pcKp4WlkJjQjtVPHzv4camFXAOYZQEwF1tnRMFifiRwHYnbR09iX+Szakqk4c+XTy0XhMSrf30nfIa2BtOc/Zvql81g7FvAgWr9UBSg79YzhVNLiyA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784722843; c=relaxed/simple;
	bh=bf76uEemVMNHct9ZjgImhdgE1+yjAfYwnh+iWN1HNrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LIcj1H5jhuk7x2z+fj1OACOUtE/ZOm/fCOtCbjUyZvI8F07AoPpa8BJjxpSC+ppzAM7ACRD9hY80oMbirc9KqX/eVAprAIVU2o9Xz1VcEGZG/lvdlMZq2GPsjEnevJp161r6Amt/ZHb4w24JpjXOlyNbW7z0qniWN25haHToYAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZohLvh2p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZohLvh2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3481F000E9;
	Wed, 22 Jul 2026 12:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784722841;
	bh=0Qe9hqRFJWvUJn68uKni3YY/asf3ARbyKBR06iM04M0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZohLvh2p2tsIke++v9fe6qwwnzDQrP/54GLMsZDnDi5RW33flRg3MiRtc4LzPYOu9
	 0zENqoP8T/9gyi736tGXbOdKPLzl/P7Prv8bdbE0Xg8EusR81MV6HISSmMaZcVEYjK
	 5Zd9261idCO8Pe7U6uocGQRAaAc62r6H1Oj0y01I=
Date: Wed, 22 Jul 2026 14:20:31 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thorsten Leemhuis <linux@leemhuis.info>
Cc: Florian Fainelli <f.fainelli@gmail.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.1 0000/2077] 7.1.5-rc1 review
Message-ID: <2026072247-trickle-brook-edef@gregkh>
References: <20260721152552.646164743@linuxfoundation.org>
 <b7e241f0-2604-4609-ac21-483b95757e10@gmail.com>
 <10b731a1-a278-413e-97b3-7ba203637ebb@leemhuis.info>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10b731a1-a278-413e-97b3-7ba203637ebb@leemhuis.info>

On Wed, Jul 22, 2026 at 06:23:08AM +0200, Thorsten Leemhuis wrote:
> On 7/21/26 19:54, Florian Fainelli wrote:
> > On 7/21/26 07:54, Greg Kroah-Hartman wrote:
> >> This is the start of the stable review cycle for the 7.1.5 release.
> >> There are 2077 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >>
> >> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >>     https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/
> >> patch-7.1.5-rc1.gz
> >> or in the git tree and branch at:
> >>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-
> >> rc.git linux-7.1.y
> >> and the diffstat can be found below.
> > 
> > perf fails to build with:
> > 
> > In file included from builtin-sched.c:28:
> > builtin-sched.c: In function 'latency_switch_event':
> > builtin-sched.c:1196:34: error: 'struct perf_sample' has no member named
> > 'file_offset'
> >  1196 |                            sample->file_offset, cpu);
> >       |                                  ^~
> > 
> > 
> > which is due to 6018a2a9ff1baa45426f7a52f8ec4f7d32fedfce ("perf sched:
> > Replace BUG_ON on invalid CPU with graceful skip"), we need to backport
> > a490187f22b4bfae7ef752edbe3fb13017ca11c ("perf sample: Add file_offset
> > field to struct perf_sample")
> 
> Was that enough to make perf build for you? I also ran into this error:
> 
> util/libdw.c: In function ‘libdw__addr2line’:
> util/libdw.c:204:25: error: implicit declaration of function
> ‘inline_node__clear_frames’ [-Wimplicit-function-declaration]
>   204 |                         inline_node__clear_frames(node);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Which from a quick check was fixed by picking up 674dea094ef659 ("perf
> srcline: Introduce inline_node__clear_frames()"). But then I ran into
> yet another error:
> 
> util/session.c: In function ‘perf_session__deliver_event’:
> util/session.c:1619:14: error: ‘evsel’ undeclared (first use in this
> function)
>  1619 |         if ((evsel->core.attr.sample_type & PERF_SAMPLE_CPU) &&
>       |              ^~~~~
> util/session.c:1619:14: note: each undeclared identifier is reported
> only once for each function it appears in

Argh, I haven't checked perf builds in a long time.  And yes, they are
broken.  Let me go fix these up for 6.18 and 7.1 and then drop all the
perf patches for older kernels as systems should always be using the
newest perf tool, not the older one, anyway.

I'll do that and then push out some -rc2 releases...

thanks,

greg k-h
