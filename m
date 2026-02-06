Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F7633DEC0;
	Fri,  6 Feb 2026 13:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770384008; cv=none; b=acjQhJHE1F1pAEXWV0SC7k8So3ECt270+ucfwVSuzHgnjneBCxEPvNvUgjjzSWuM8Y5OlHQBIXWd0M6hfbbyuA5uTo1q9l9kgnpCfUqZULlvR70vKIaa4zUmlx7YF65s0wUrPNbwEZB40nXjmfi1eD8XKicQp590YZa/xox+cuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770384008; c=relaxed/simple;
	bh=uaU/dMUcVTcHujWPlqo/mvSW1CuYUm0aE/ikpDeezWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QCIBTMDiRJoPqDLBT6KHWhFqnnUHhCmB1mgbmnfgeAoWPJu7zU/vBc95rviCgaxJ28nMwY9SatvZRKO1nhNDHhA4EQJO3+OKl08wUkvNR1Zh5+X67ikY9qx8qaQrrlAvFFjdHDH1DsY1oKu9V/3Nr42M7zckvr5Se2dqWdBhFpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cF7BGvO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cF7BGvO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F16C116C6;
	Fri,  6 Feb 2026 13:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770384008;
	bh=uaU/dMUcVTcHujWPlqo/mvSW1CuYUm0aE/ikpDeezWE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cF7BGvO5/bPKJ0bFdyGQaGD0X3H6GiIb4uQl6/5qXL4BvCXngttPfHoBfRw/Ge2i+
	 Dc3RIYoYFmxdZAfPUUCGCk0sydvNRY1SPFkC3M1ARQ/YtjQyc5QE5w97h8f5H+1xPx
	 Wl0tatDAbNgeIIHZOD3OKiaIKq05xPH9qM12C1m8=
Date: Fri, 6 Feb 2026 14:20:03 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/122] 6.18.9-rc1 review
Message-ID: <2026020652-quarry-clench-2fd8@gregkh>
References: <20260204143851.857060534@linuxfoundation.org>
 <CAG=yYwnSJCp6W6+0MGG_aaj+Ao7Qhiza0FKvrP-4wf6f9x1SQQ@mail.gmail.com>
 <2026020601-persecute-avenging-f539@gregkh>
 <CAG=yYwmqwb-v-31bk5sXcBGtTQ3JGgH4Kse0nWAtbX5f01764A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG=yYwmqwb-v-31bk5sXcBGtTQ3JGgH4Kse0nWAtbX5f01764A@mail.gmail.com>

On Fri, Feb 06, 2026 at 06:47:50PM +0530, Jeffrin Thalakkottoor wrote:
> On Fri, Feb 6, 2026 at 6:01 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Feb 06, 2026 at 05:29:58PM +0530, Jeffrin Thalakkottoor wrote:
> > >  Build error related
> > > screenshot  below.
> > >
> > > --------------------<screenshot>-----------------------
> > >
> > > $make -j 4
> > >   DESCEND objtool
> > >   DESCEND bpf/resolve_btfids
> > >   INSTALL libsubcmd_headers
> > >   INSTALL libbpf_headers
> > >   INSTALL libsubcmd_headers
> > > make[5]: *** No rule to make target 'str_error.h', needed by
> > > '/home/jeffrin/kernel/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/staticobjs/libbpf.o'.
> > > Stop.
> > > make[4]: *** [Makefile:152:
> > > /home/jeffrin/kernel/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/staticobjs/libbpf-in.o]
> > > Error 2
> > > make[3]: *** [Makefile:61:
> > > /home/jeffrin/kernel/linux-stable-rc/tools/bpf/resolve_btfids//libbpf/libbpf.a]
> > > Error 2
> > > make[2]: *** [Makefile:76: bpf/resolve_btfids] Error 2
> > > make[1]: *** [/home/jeffrin/kernel/linux-stable-rc/Makefile:1449:
> > > tools/bpf/resolve_btfids] Error 2
> > > make[1]: *** Waiting for unfinished jobs....
> > >   CALL    scripts/checksyscalls.sh
> > > make: *** [Makefile:248: __sub-make] Error 2
> > > -----------------------<screenshot>---------------------------
> >
> > What .config causes this?
> >
> 
> iam confused . but may be the attached  config  is now giving a clean compile

So it works now?

I'm confused,

greg k-h
