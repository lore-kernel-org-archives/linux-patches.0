Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F5D1EFFB0;
	Tue, 22 Apr 2025 08:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745311906; cv=none; b=a/XTTlWgUfRG9uXgRoMF3JzWoAFpC0gZ09wVhz6oGAQk4QeID7h6u/mBn6sIyPevH1qYtwvHYhBl3TFb5e9DZpzoZNXmc+hahv0tywrqVyLgr+k8dbchxQ43xcBfWWQiQt8Swc0Ol3PbNYFmzCvx6ZI28w0EkOvBRf03BqcsXHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745311906; c=relaxed/simple;
	bh=xPNfdAgaEW5nPRdCDrfF7RY71YYTB3w3AcKN8iIfMkk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TDpuiLFew/7VTFLNrl2rX/r89gZe+aequLG48D4NI3CZdycvLEsL2D6J/5E3Hpo3Ch5SWKCewQDVgPMvcQn19dqhYI0wkKOYgQMJrLXpfizeBHtKZCjPYDu4xdBDFqtEfbdLnw6AbKouj20Y3rXSnZxit5CiKD/rm3bDE5je5Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vidqjDRQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vidqjDRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CB8C4CEE9;
	Tue, 22 Apr 2025 08:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745311905;
	bh=xPNfdAgaEW5nPRdCDrfF7RY71YYTB3w3AcKN8iIfMkk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vidqjDRQNUN4ioPdYeru/dBlENvAXzjWWzlEskIZDHWCGUL2k/ka3sDIDnv4+rr0+
	 9I8oYJ6/RV/ldOlMoSCqbGtdgaiLmGVN9+PJJj4Wkcl50HWDeTDpUNGG26voorJW/O
	 shva/5r5ozN0NlT5q1fJPYmwSI9TQ68VlNPbTMk4=
Date: Tue, 22 Apr 2025 10:51:43 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/205] 6.1.134-rc2 review
Message-ID: <2025042236-endeared-mobile-3fb8@gregkh>
References: <20250409115832.610030955@linuxfoundation.org>
 <90288944-3f5b-45b7-ae7d-c7a54398db55@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90288944-3f5b-45b7-ae7d-c7a54398db55@roeck-us.net>

On Fri, Apr 11, 2025 at 07:29:38AM -0700, Guenter Roeck wrote:
> On 4/9/25 05:02, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.134 release.
> > There are 205 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 11 Apr 2025 11:58:02 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building loongarch:defconfig ... failed
> --------------
> Error log:
> In file included from arch/loongarch/net/bpf_jit.c:7:
> arch/loongarch/net/bpf_jit.h: In function 'emit_nop':
> arch/loongarch/net/bpf_jit.h:30:22: error: 'INSN_NOP' undeclared
> 
> Caused by commit e9ccb262b39a ("LoongArch: BPF: Fix off-by-one error
> in build_prologue()"). INSN_NOP was introduced with commit 19e5eb15b00c5
> in v6.2.
> 
> Also, the description of e9ccb262b39a says "With BPF progs mixing bpf2bpf
> and tailcalls...". Support for that was introduced in v6.4 with commit
> bb035ef0cc91 ("LoongArch: BPF: Support mixing bpf2bpf and tailcalls"),
> so I do wonder if e9ccb262b39a was really needed in 6.1.

Thanks for letting me know, now reverted.

greg k-h
