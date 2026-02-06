Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0525479CD;
	Fri,  6 Feb 2026 12:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770381074; cv=none; b=pU2AcqoHo4lSuVS0Rdlh0g976b+Wz/WdMHtk3EyeawxVTF1Uy11FPCoSIRgA3JUghQyREdPMJpqLOrQFY9XBSk6f0SrArR6W/hDena9r4bqlulMFAKULciIC6eZABh3W1Uv1xd95qzkiY893obQKA0/GDnmL+Qa+cYpLg7Wlr9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770381074; c=relaxed/simple;
	bh=e+/M0LaReQfQarqlgmkTyqmffY+hV0TF9I92eoN+7Sg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m3V2tbloM111i4SaVmrJCYiSik+llRiT+8alIZYSxCV5z+XEqAr+GZM3SlIkJEX/fV4vYQJar0jTQ90Z5XSOtx9bXxlbdgrrel7mwNyudKZT8uPOxjOGtGZns1mj+QVWzSP82D/y1LoCFPhlO8LRaodxxmIXB4Vlnnq8t0HMzLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zCkdolRV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zCkdolRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE78C116C6;
	Fri,  6 Feb 2026 12:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770381073;
	bh=e+/M0LaReQfQarqlgmkTyqmffY+hV0TF9I92eoN+7Sg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zCkdolRVjN+dN+FHhziqxYqZd6ycdGbM0SLBwOipiZCpuNELOM9ox7t4XCnnFXH+Y
	 Oq6mK6RdHZXeHdI+h30dqtaiTADbT9TiRPZ7BEkzMHUQbtuyvP1XtV0RHJMrePCatj
	 mAWFDulL/KjUB4ZTUugv3aAVpd+ir1jmxvTsyp6s=
Date: Fri, 6 Feb 2026 13:31:10 +0100
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
Message-ID: <2026020601-persecute-avenging-f539@gregkh>
References: <20260204143851.857060534@linuxfoundation.org>
 <CAG=yYwnSJCp6W6+0MGG_aaj+Ao7Qhiza0FKvrP-4wf6f9x1SQQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG=yYwnSJCp6W6+0MGG_aaj+Ao7Qhiza0FKvrP-4wf6f9x1SQQ@mail.gmail.com>

On Fri, Feb 06, 2026 at 05:29:58PM +0530, Jeffrin Thalakkottoor wrote:
>  Build error related
> screenshot  below.
> 
> --------------------<screenshot>-----------------------
> 
> $make -j 4
>   DESCEND objtool
>   DESCEND bpf/resolve_btfids
>   INSTALL libsubcmd_headers
>   INSTALL libbpf_headers
>   INSTALL libsubcmd_headers
> make[5]: *** No rule to make target 'str_error.h', needed by
> '/home/jeffrin/kernel/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/staticobjs/libbpf.o'.
> Stop.
> make[4]: *** [Makefile:152:
> /home/jeffrin/kernel/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/staticobjs/libbpf-in.o]
> Error 2
> make[3]: *** [Makefile:61:
> /home/jeffrin/kernel/linux-stable-rc/tools/bpf/resolve_btfids//libbpf/libbpf.a]
> Error 2
> make[2]: *** [Makefile:76: bpf/resolve_btfids] Error 2
> make[1]: *** [/home/jeffrin/kernel/linux-stable-rc/Makefile:1449:
> tools/bpf/resolve_btfids] Error 2
> make[1]: *** Waiting for unfinished jobs....
>   CALL    scripts/checksyscalls.sh
> make: *** [Makefile:248: __sub-make] Error 2
> -----------------------<screenshot>---------------------------

What .config causes this?

thanks,

greg k-h
