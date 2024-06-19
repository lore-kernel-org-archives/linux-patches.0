Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4AE225A8;
	Wed, 19 Jun 2024 14:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718808519; cv=none; b=k164X3md6MrYuo5P9QDtRRttRngjpkOzPS0PO5bNqZ/mcMlcWuhlRYHridmAFKC93uuy6eCjClp8qyRUY6J+RCdE4bRBrJvZAav0bzN8vUzHVe8BC7seRfC1YDAV7P8qaeslA/d7QDISqMUZ6lcsevuEc7B2Kt1xbZ9AGLr/1LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718808519; c=relaxed/simple;
	bh=2YOvS0C9Qi9FYlw1P37gGBlyIrP+q5FHxGp8w3em48o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TXsRai+aH/V7AO6YmJUTEzaTPbEWRgOA25TMxX3k7j2DqvALpV13JK43fonrERpOvLWJc6klHHlqW/Uk173Hh5d3doHmby5f07aeQ02311J55didW72r2A739vCOmmFnprsH3gkha36Ieim263oEVPXPc/lfTvyh05xMgH6QVLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IOjwCfo2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IOjwCfo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446DFC2BBFC;
	Wed, 19 Jun 2024 14:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718808518;
	bh=2YOvS0C9Qi9FYlw1P37gGBlyIrP+q5FHxGp8w3em48o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IOjwCfo2Btn4yZibsXKcXlpqDVu1PammW3+3MMnWPxWgA+gvRDnDwqC4VnHEog17S
	 gBmSIJMFqIyXIlu9Uwf0Xu5zbcdyQYNZ6fkbP9fuSKSBzt9pnoe6FSDsoylkmAqXNK
	 bKfg5nX+5TOKeNyXocyFVR2qvZNNv7oD8mG7xyOc=
Date: Wed, 19 Jun 2024 16:48:35 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Conor Dooley <conor@kernel.org>
Cc: Conor Dooley <conor.dooley@microchip.com>, Ron Economos <re@w6rz.net>,
	Pavel Machek <pavel@denx.de>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, allen.lkml@gmail.com,
	broonie@kernel.org
Subject: Re: [PATCH 6.6 000/741] 6.6.33-rc2 review
Message-ID: <2024061905-reclining-discount-996d@gregkh>
References: <20240609113903.732882729@linuxfoundation.org>
 <ZmYDquU9rsJ2HG9g@duo.ucw.cz>
 <ad13afda-6d20-fa88-ae7f-c1a69b1f5a40@w6rz.net>
 <2024061006-overdress-outburst-36ae@gregkh>
 <20240610-scabby-bruising-110970760c41@wendy>
 <2024061140-sandworm-irk-b7c9@gregkh>
 <20240619-kerchief-grove-20c3996db1aa@spud>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240619-kerchief-grove-20c3996db1aa@spud>

On Wed, Jun 19, 2024 at 03:28:18PM +0100, Conor Dooley wrote:
> On Tue, Jun 11, 2024 at 03:06:01PM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Jun 10, 2024 at 08:26:10AM +0100, Conor Dooley wrote:
> > > On Mon, Jun 10, 2024 at 08:28:29AM +0200, Greg Kroah-Hartman wrote:
> > > > On Sun, Jun 09, 2024 at 11:21:55PM -0700, Ron Economos wrote:
> > > > > On 6/9/24 12:34 PM, Pavel Machek wrote:
> > > > > > Hi!
> > > > > > 
> > > > > > > This is the start of the stable review cycle for the 6.6.33 release.
> > > > > > > There are 741 patches in this series, all will be posted as a response
> > > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > > let me know.
> > > > > > 6.6 seems to have build problem on risc-v:
> > > 
> > > > > > arch/riscv/kernel/suspend.c:14:66: error: 'RISCV_ISA_EXT_XLINUXENVCFG' undeclared (first use in this function); did you mean 'RISCV_ISA_EXT_ZIFENCEI'?
> > > > > > 694
> > > > > >     14 |         if (riscv_cpu_has_extension_unlikely(smp_processor_id(), RISCV_ISA_EXT_XLINUXENVCFG))
> > > > > > 695
> > > > > >        |                                                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~
> > > > > > 696
> > > > > >        |                                                                  RISCV_ISA_EXT_ZIFENCEI
> > > 
> > > > > > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/7053222239
> > > > > > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1324369118
> > > > > > 
> > > > > > No problems detected on 6.8-stable and 6.1-stable.
> > > > > > 
> > > > > > Best regards,
> > > > > > 								Pavel
> > > > > 
> > > > > I'm seeing the same thing here. Somehow some extra patches got slipped in
> > > > > between rc1 and rc2. The new patches for RISC-V are:
> > > > > 
> > > > > Samuel Holland <samuel.holland@sifive.com>
> > > > >     riscv: Save/restore envcfg CSR during CPU suspend
> > > > > 
> > > > > commit 88b55a586b87994a33e0285c9e8881485e9b77ea
> > > > > 
> > > > > Samuel Holland <samuel.holland@sifive.com>
> > > > >     riscv: Fix enabling cbo.zero when running in M-mode
> > > > > 
> > > > > commit 8c6e096cf527d65e693bfbf00aa6791149c58552
> > > > > 
> > > > > The first patch "riscv: Save/restore envcfg CSR during CPU suspend" causes
> > > > > the build failure.
> > > > > 
> > > > > 
> > > > 
> > > > Yes, these were added because they were marked as fixes for other
> > > > commits in the series.  I'll unwind them all now as something is going
> > > > wrong...
> > > 
> > > Really we should just backport this envcfg handling to stable, this
> > > isn't the first (and won't be the last) issue it'll cause. I'll put a
> > > backport of it on my todo list cos I think last time around it couldn't
> > > be cherrypicked.
> > 
> > Thanks, I've dropped almost all riscv patches from this queue now.  If
> > they want to be added back, please send working backports :)
> 
> I went to take a look at this, but since 6.8 is now EOL, I dunno if I
> actually need to do anything here? These were needed because you had
> applied "RISC-V: Enable cbo.zero in usermode", but that's a feature, not
> a fix, so dropping that makes these changes unneeded. IIRC the previous
> time that there was an envcfg related build failure it was on the
> requested backport to 6.7+ in the envcfg addition in "riscv: Add a custom
> ISA extension for the [ms]envcfg CSR", and an assertion failed because
> of a definition for the maximum number of ISA extensions was larger in
> 6.9 than 6.7 and the patch depended on that.

Yes, 6.8.y is end-of-life, nothing needs to be done there anymore.

> For 6.6, I don't think envcfg is needed, unless there was some other
> reason that you backported "RISC-V: Enable cbo.zero in usermode".

I hope not :)

thanks for looking.

greg k-h
