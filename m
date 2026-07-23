Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250B640B10C;
	Thu, 23 Jul 2026 10:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784801858; cv=none; b=pbOteQ/pW+CMP23Hxd91LJ8f3FY6XcZe70kHgLuA96n6AT3F/lipgRQAETL3BlZyMxuHBaprbV/mAxw14ZB06e4zP2nHa6uyaGRFpYIbDR8HejBkT44wk16yrRbp5VjWCxodlhSrBzxvIdRSBANiac+EjM5SCiKDiEewV9m7DaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784801858; c=relaxed/simple;
	bh=Q9qivlKsPl+yBwb65TotXNA9y/9myZamnh+XiSud4BE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uUFqvwAgp44xfW9uRfD7zNvVsY8y9t5G/XPt45L9eHJi2vs5WNBSObrVcWnrARca5A0HlAmlR0h2R++or1rebJ1tHTzb8i+JkkQoHxChyM4dqhezY5311YqDbnhrAdyx+3fnt5wyhn7nM73CTuEb6BzcjS+x6Vfzy+FEYqM2g+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9081F00A3A;
	Thu, 23 Jul 2026 10:17:36 +0000 (UTC)
Date: Thu, 23 Jul 2026 12:17:23 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 0000/1226] 6.6.145-rc2 review
Message-ID: <2026072304-dentist-repayment-4761@gregkh>
References: <20260722143258.264584003@linuxfoundation.org>
 <amHSEwZcutUhO5tL@u94a>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amHSEwZcutUhO5tL@u94a>

On Thu, Jul 23, 2026 at 04:37:07PM +0800, Shung-Hsi Yu wrote:
> On Wed, Jul 22, 2026 at 04:33:42PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.145 release.
> > There are 1226 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 24 Jul 2026 14:31:21 +0000.
> > Anything received after that time might be too late.
> 
> BPF selftests compilation is currently broken. But with [1] applied it
> will build, with test_progs, test_progs-no_alu32, test_progs-cpuv4,
> test_maps, test_verifier in BPF selftests all passes[2] on x86_64 and
> aarch64.
> 
> Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
> 
> 1: https://lore.kernel.org/stable/20260723071334.39630-1-shung-hsi.yu@suse.com/
> 2: https://github.com/kernel-patches/linux-stable/actions/runs/29987147891

Ok, I'll go queue those up for 6.12.y and 6.6.y now, thanks!

greg k-h
