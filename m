Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E781E49E;
	Tue, 11 Jun 2024 13:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718111165; cv=none; b=mhlM21LUXNi4pHN48I4CYxOXOnEEioxZyjLJ2NxyZFdkc/CI4AygPm9SAjjYT1DbVqp8BhwF61TWdOC9lzXtp0nyHsXUfkU2BaEMnrwmXLkK5RD96rFiwsENidbnsDEudcxj7557tkA3YLm5u4UBUn8f2usqvQGFmDlEVjC1Pzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718111165; c=relaxed/simple;
	bh=jA/69QdB2gFBUSOgBGKkvHcX9B1bO63Yfu8u1le2liY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MBJVTXtpb0wOnwm9AM4IlRuTVrVng/hAW4W9BWGfasGMMW2ztcicf94d2wBYvbyMNdWnd7L+xcvjE4MQCDregEWu6Cx/7eiS6KdeHqT/BpNAZg4+ga75bzRZ29lvhagbQWvbI+MX5GlbnXmGQyBzrdMVWCLKrmLQ9+7rlPRtEeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JKDcaw09; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JKDcaw09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513B2C2BD10;
	Tue, 11 Jun 2024 13:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718111164;
	bh=jA/69QdB2gFBUSOgBGKkvHcX9B1bO63Yfu8u1le2liY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JKDcaw09xPpEoPaDbp+eXsX69dQ+dbufTli7zV3Gym515i4EyQaI8sFEKiZrCqTzh
	 UgDGhvgOkPP14hfYrGox4cavj3nnKGubR541y1tJB/J/qszTjborznH2oJGGXFd4kp
	 5XEgXKdOdjlBJfz7KxPOYj3WiRV7HyvuJPEOtnXc=
Date: Tue, 11 Jun 2024 15:06:01 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Conor Dooley <conor.dooley@microchip.com>
Cc: Ron Economos <re@w6rz.net>, Pavel Machek <pavel@denx.de>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/741] 6.6.33-rc2 review
Message-ID: <2024061140-sandworm-irk-b7c9@gregkh>
References: <20240609113903.732882729@linuxfoundation.org>
 <ZmYDquU9rsJ2HG9g@duo.ucw.cz>
 <ad13afda-6d20-fa88-ae7f-c1a69b1f5a40@w6rz.net>
 <2024061006-overdress-outburst-36ae@gregkh>
 <20240610-scabby-bruising-110970760c41@wendy>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240610-scabby-bruising-110970760c41@wendy>

On Mon, Jun 10, 2024 at 08:26:10AM +0100, Conor Dooley wrote:
> On Mon, Jun 10, 2024 at 08:28:29AM +0200, Greg Kroah-Hartman wrote:
> > On Sun, Jun 09, 2024 at 11:21:55PM -0700, Ron Economos wrote:
> > > On 6/9/24 12:34 PM, Pavel Machek wrote:
> > > > Hi!
> > > > 
> > > > > This is the start of the stable review cycle for the 6.6.33 release.
> > > > > There are 741 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > 6.6 seems to have build problem on risc-v:
> 
> > > > arch/riscv/kernel/suspend.c:14:66: error: 'RISCV_ISA_EXT_XLINUXENVCFG' undeclared (first use in this function); did you mean 'RISCV_ISA_EXT_ZIFENCEI'?
> > > > 694
> > > >     14 |         if (riscv_cpu_has_extension_unlikely(smp_processor_id(), RISCV_ISA_EXT_XLINUXENVCFG))
> > > > 695
> > > >        |                                                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~
> > > > 696
> > > >        |                                                                  RISCV_ISA_EXT_ZIFENCEI
> 
> > > > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/7053222239
> > > > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1324369118
> > > > 
> > > > No problems detected on 6.8-stable and 6.1-stable.
> > > > 
> > > > Best regards,
> > > > 								Pavel
> > > 
> > > I'm seeing the same thing here. Somehow some extra patches got slipped in
> > > between rc1 and rc2. The new patches for RISC-V are:
> > > 
> > > Samuel Holland <samuel.holland@sifive.com>
> > >     riscv: Save/restore envcfg CSR during CPU suspend
> > > 
> > > commit 88b55a586b87994a33e0285c9e8881485e9b77ea
> > > 
> > > Samuel Holland <samuel.holland@sifive.com>
> > >     riscv: Fix enabling cbo.zero when running in M-mode
> > > 
> > > commit 8c6e096cf527d65e693bfbf00aa6791149c58552
> > > 
> > > The first patch "riscv: Save/restore envcfg CSR during CPU suspend" causes
> > > the build failure.
> > > 
> > > 
> > 
> > Yes, these were added because they were marked as fixes for other
> > commits in the series.  I'll unwind them all now as something is going
> > wrong...
> 
> Really we should just backport this envcfg handling to stable, this
> isn't the first (and won't be the last) issue it'll cause. I'll put a
> backport of it on my todo list cos I think last time around it couldn't
> be cherrypicked.

Thanks, I've dropped almost all riscv patches from this queue now.  If
they want to be added back, please send working backports :)

thanks,

greg k-h
