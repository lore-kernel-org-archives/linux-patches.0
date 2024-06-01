Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D055BAD58;
	Sat,  1 Jun 2024 05:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717220360; cv=none; b=czNd9zGrU8fljcrSokWeaj4HfkRggszmlNLq3WP34/lfCehx2zJNOEm3LXGG/V/0pDhoOq+/q+JEWkuWAY1d2SLjlyv12gRruB6vERZ8xlDAFtFrY6lLIqO/4LE+U5cd2pnssEmBw30I82Cd9JZuOnbgq521FWoxe6FhJuMQqcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717220360; c=relaxed/simple;
	bh=59YtFcTEIgzORMsEBTpAtFOGt6Bg8PbHfMg7i59X/jE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lK+RhrVAml64R5vK3I9B+eC28wpgjl02S3kEFwV61K5ccJFHXPyhon0fNYBRAGGszPY8f3xVCAjl26yGE2dhD2daptungXoA5Oxb2lJa2zmmOnt/PFSMewcOngJmssvqWWzuVa31SUZACyxdgS9smfQNJ4z5UmeBvSnQaXfh78M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FocJHcXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FocJHcXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A73DC116B1;
	Sat,  1 Jun 2024 05:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717220359;
	bh=59YtFcTEIgzORMsEBTpAtFOGt6Bg8PbHfMg7i59X/jE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FocJHcXgSZMU56/ixCIudr+HGloHAcGbcnejZz3S0xVLFrox9rZ33sJU5M5JAIcAJ
	 JPvopBiCsVI5QCCTB+bBABWTtnLxjQAXmhkQANPkM5if+cdhh5RPRTa7fWIn/SMMHp
	 ScGM64Kx8GfJLfpdd0rsEy6s57IeXmX/yHWfC6dY=
Date: Sat, 1 Jun 2024 07:39:25 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 000/493] 6.8.12-rc1 review
Message-ID: <2024060112-exile-staring-e25c@gregkh>
References: <20240527185626.546110716@linuxfoundation.org>
 <60fd8015-9fd0-4454-a11c-763c06cef66a@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60fd8015-9fd0-4454-a11c-763c06cef66a@roeck-us.net>

On Fri, May 31, 2024 at 01:27:44PM -0700, Guenter Roeck wrote:
> On 5/27/24 11:50, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.8.12 release.
> > There are 493 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 29 May 2024 18:53:22 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build failures in v6.8.12:
> 
> Building csky:allmodconfig ... failed
> Building m68k:allmodconfig ... failed
> Building xtensa:allmodconfig ... failed
> 
> --------------
> Error log:
> In file included from kernel/sched/build_utility.c:104:
> kernel/sched/isolation.c: In function 'housekeeping_setup':
> kernel/sched/isolation.c:134:53: error: 'setup_max_cpus' undeclared (first use in this function)
>   134 |         if (first_cpu >= nr_cpu_ids || first_cpu >= setup_max_cpus) {
> 
> Commit 3c2f8859ae1ce ("smp: Provide 'setup_max_cpus' definition on UP too")
> might solve the problem.

Thanks for the report, but 6.8.y is now end-of-life :(

greg k-h
