Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF391154456;
	Tue, 12 Nov 2024 08:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731400389; cv=none; b=ggV8L46l1sCAikbSiKqcFbm/Y+uf7tC5kdGc9oz+luObC7JZ2RqLo/m8xNoUwSBUKWrGifjTlou0F1lhj5+CRz+VWG+iE+IO7lPJF3BfDLvC5krmW54JcNftxkIUofDIFjqBLI1cDa8EV69eXY2uweGXJ1gh3UV9wa1O8JHL9L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731400389; c=relaxed/simple;
	bh=Mqg2a10we4b9q1ncG4Uhs7eM/6r8c8yZPQ1+OodAfWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TR6aoyUq1qHxsHQ78thSR4+wDpzo32ZcYDnAG6q/pPYvm+pglj9QbNHHxoATLGtNdrdDUXCEo/aLMm1mbplAEB7YEDXynX94Qs4AkhYHb4J/E4AorRqukeklf6bUdQs+uYVAubh71PZ87KYJMA6Eyq8yd9A6dS7hLwdyJUoeL54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVU0t0dA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVU0t0dA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922B4C4CECD;
	Tue, 12 Nov 2024 08:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731400388;
	bh=Mqg2a10we4b9q1ncG4Uhs7eM/6r8c8yZPQ1+OodAfWg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OVU0t0dAxPeBKCcwQezVNOKnrxyR79KDCr7dnwamlqLqAO5/hfrGQ/p5HJZc46wv9
	 Owqve6xLxO78W1S9dcdDYZpFPAEi5ETQPV/b8SJKc7SvNB5XZy3OEuY2gOfHGAbU1I
	 hJSbPAbK/W+w47pO5HPBIMSSkrppQPNcntQK5Kas=
Date: Tue, 12 Nov 2024 09:33:04 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hagar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.11 000/249] 6.11.7-rc2 review
Message-ID: <2024111257-boogeyman-hatless-9872@gregkh>
References: <20241107064547.006019150@linuxfoundation.org>
 <d440b33c-8634-46c2-8fb6-8ee4e7b43534@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d440b33c-8634-46c2-8fb6-8ee4e7b43534@roeck-us.net>

On Sun, Nov 10, 2024 at 07:53:32AM -0800, Guenter Roeck wrote:
> On 11/6/24 22:47, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.11.7 release.
> > There are 249 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 09 Nov 2024 06:45:18 +0000.
> > Anything received after that time might be too late.
> > 
> [ ... ]
> 
> > Naohiro Aota <naohiro.aota@wdc.com>
> >      btrfs: fix error propagation of split bios
> > 
> 
> This patch triggers:
> 
> ERROR: modpost: "__cmpxchg_called_with_bad_pointer" [fs/btrfs/btrfs.ko] undefined!
> 
> or:
> 
> fs/btrfs/bio.o: In function `btrfs_bio_alloc':
> fs/btrfs/bio.c:73: undefined reference to `__cmpxchg_called_with_bad_pointer'
> fs/btrfs/bio.o: In function `__cmpxchg':
> arch/xtensa/include/asm/cmpxchg.h:78: undefined reference to `__cmpxchg_called_with_bad_pointer'
> 
> on xtensa builds with btrfs enabled.
> 
> Upstream commit e799bef0d9c8 ("xtensa: Emulate one-byte cmpxchg") is
> required to fix the problem.

Now queued up, thanks.

greg k-h
