Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD121C8FA0;
	Tue,  1 Oct 2024 14:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727793568; cv=none; b=q4sgY0BaaliKCgkf1Iv4rysevlXZeVWdzZ7HiKZoCkJbpk/gNy3cVDj0PnN6WJCo3Ywlr1KQMp3J4vQihtXbiTOLNBQ3ArAlHzwIqw7TYTAhHMCtCVyh2R/hUMckaNOqu2OG/46kCUSNDt/lpXl8iP6Z8qnVszOtTbG5ouUW0HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727793568; c=relaxed/simple;
	bh=oZvk3MHVNoX9e05w5PclnvJLZ1cW+m7vI9040iculQY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bl0ov/QK8W9PfwKDOF1kX60iJ9YT9eFNYDf/jKSc4Q4BCEh5Fxt0qIFhD3AKB38Ny2EOB0BtUD7ZgNq4XFOLOYQPyCQcWrASwW8N1zxcojrfQLXRGX3uyeZ68Ogqo9ONmvQs5i1kdIU/dg1foU4bzB2uc/3EdQnorXX+sbzWf9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGPnjjqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGPnjjqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4307BC4CEC6;
	Tue,  1 Oct 2024 14:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727793567;
	bh=oZvk3MHVNoX9e05w5PclnvJLZ1cW+m7vI9040iculQY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CGPnjjqSPJoJvPNZYBFWjxOpElKFdtMzS8baTICRRgfkJc+kl6rmmB6lGQ2wcxRvS
	 8VMKSMHVrqyrcL/Ts1Hc3+lGa/p0Hd9xeCjNF37ZXz1W8cXkxWxxiHTZRddzLpUkyx
	 gK8qTSU5dA8YPR3zAy5fWzKn1wJavOMArAOkCnoc=
Date: Tue, 1 Oct 2024 16:38:06 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: Re: [PATCH 6.10 00/58] 6.10.12-rc1 review
Message-ID: <2024100157-crane-disposal-4896@gregkh>
References: <20240927121718.789211866@linuxfoundation.org>
 <f1697b65-acd4-4031-ba47-64c587408593@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1697b65-acd4-4031-ba47-64c587408593@roeck-us.net>

On Tue, Oct 01, 2024 at 07:24:27AM -0700, Guenter Roeck wrote:
> On 9/27/24 05:23, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.10.12 release.
> > There are 58 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.12-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> > and the diffstat can be found below.
> > 
> 
> Most loongarch builds are broken.
> 
> Building loongarch:defconfig ... failed
> --------------
> Error log:
> arch/loongarch/kvm/vcpu.c: In function 'kvm_set_one_reg':
> arch/loongarch/kvm/vcpu.c:575:35: error: 'struct kvm_vcpu_arch' has no member named 'st'
>   575 |                         vcpu->arch.st.guest_addr = 0;
> 
> This is due to commit 05969a694471 ("LoongArch: KVM: Invalidate guest steal time address
> on vCPU reset"). Note that this commit is not tagged as bug fix. I am copying the author.

Already reverted in my tree, thanks!

greg k-h
