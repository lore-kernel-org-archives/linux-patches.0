Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088741A6805;
	Thu,  9 Jul 2026 14:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783607003; cv=none; b=J+rQqi9Gs563b2/+9uK3zaW5fbZbMbogmsFvlRXJs0X0dQyFzmTJ1N0bRVt6eF/kC5/eYlMi8Uyj2xVOWzI3VUyyZ9gpTMwP4rv39GIPwnrLwqgCJLgoZ+H5kvYnHz02tmb7zLGVPriXm1LUfsnIkTc4zJixeZjBRV3mdpHRG9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783607003; c=relaxed/simple;
	bh=MR5y0K4Xo9/ik81BBpZJrfjRic531n+UEElKNd100Ss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n+agbod6YgJOLBuKuMvKUtiAxsF19ID/va4LFXD02ZnCmNKxINXrsVsRv+EhMu/jmytERPH3iCrLoAQ3P69pz8Y9eYL5DFtA/k3nOpugGwHStPENMrlxAqx/EhknngeFIoNJ08/2mDSGC+RWuORnleCXBZD8ABNQH6MdiUaA6Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JV8r1WV9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JV8r1WV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092971F000E9;
	Thu,  9 Jul 2026 14:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783607001;
	bh=K/oiXgCiEcBjsEwFTwNVfNijYv5O4s+DuURcquYpUeY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JV8r1WV9Vo4ZfTV4gjt9Q4eE5HAKeZMoefAOYrJvJwXXMfFKk664sp9Q4xVhPAB/M
	 EaZK54SFWRtHz6+D6/ImlgTr/RN50FhISwYVFBFPkh2ZLM8OxbbiUtXc5/E8nfUKL0
	 +j54awIIAjA78GmtM1tMumdTx4XgO0PM/ZvCqQsY=
Date: Thu, 9 Jul 2026 16:23:18 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.1 000/121] 7.1.3-rc2 review
Message-ID: <2026070912-cold-overvalue-a5ce@gregkh>
References: <20260703072822.817328079@linuxfoundation.org>
 <b885d245-bf13-45e3-8c60-28417a63fd91@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b885d245-bf13-45e3-8c60-28417a63fd91@gmail.com>

On Thu, Jul 09, 2026 at 03:51:12PM +0200, Florian Fainelli wrote:
> 
> 
> On 7/3/2026 9:35 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 7.1.3 release.
> > There are 121 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 05 Jul 2026 07:28:08 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.3-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, please backport
> 7ee7f48413c42b90230de4a8e40898b757bc8e82 ("perf trace beauty fcntl: Fix
> build with older kernel headers") fo the MIPS build of "perf" to pass:
> 
> Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
> -- 
> Florian
> 
> 

All now queued up, thanks.

greg k-h
