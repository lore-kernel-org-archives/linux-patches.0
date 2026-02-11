Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2711D7995;
	Wed, 11 Feb 2026 12:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770813523; cv=none; b=G6+Ye48dJCgCeWLZUx2Ozm2G5fzji+QBaxxnupN6e9S1UFmwRMO8aRn/4FIqaxJCzHbmXCUvbmoUlKQvoK8NwTrkpx2ZDedjyIpYF8pjpbL0bwpaRrW+MybQMI9ZbFUarWP9oIlzEvYHWhh/3HFzlNk7derOkMXTcuZtlnnpRhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770813523; c=relaxed/simple;
	bh=tyv7GhUsCcgFvglanygPA4t9+2a1vPLKvDr0sxXJpNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UIlADjz0hIx2QN0UajBiLKPjvDSvYPv/78RLGD81uzVQWdJCkabj3VMYc9ZoMhwQL4LSu5QTLurwgEb/HvvutyP/tYcIDJSUBPmkM2m8segA4WvBdbYO5x2SCH8PnjqHD3tZfvQ4kFpViuRouBKR1f7HnwtCbEoXU4nVQSAtoWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bifrKcUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bifrKcUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA32AC4CEF7;
	Wed, 11 Feb 2026 12:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770813523;
	bh=tyv7GhUsCcgFvglanygPA4t9+2a1vPLKvDr0sxXJpNc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bifrKcUkJY49dZxHCD5NLb6xBBhWc6dkXDItKGWeB33YMW8Ul326GhyP520iqMvR2
	 yTSPIUAKiF89U3UZ4cTRzEl7YVtIPJNU+oZPrhV5RvihmU14C0/7NKHSCnSFRuBDTT
	 6owcZBdhtojjvarBo0UV75TsIrWXrGo58Eoy7Ptc=
Date: Wed, 11 Feb 2026 13:38:40 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 00/86] 6.6.124-rc1 review
Message-ID: <2026021127-posh-anchor-1e47@gregkh>
References: <20260209142304.770150175@linuxfoundation.org>
 <20260211085248.EAEE.409509F4@e16-tech.com>
 <20260211110620.0A4D.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260211110620.0A4D.409509F4@e16-tech.com>

On Wed, Feb 11, 2026 at 11:06:21AM +0800, Wang Yugui wrote:
> Hi,
> 
> > Hi,
> > 
> > > This is the start of the stable review cycle for the 6.6.124 release.
> > > There are 86 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.124-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > > and the diffstat can be found below.
> > 
> > 6.6.123 boot well, but 6.6.124-rc1 failed to boot here.
> > 
> > error message:
> > dracut: fatal: iscsiroot requested but kernel/initrd does not support iscsi.
> > 
> > 'git bisect' yet not done, and report this problem firstly.
> 
> 6.6.124-rc1 without 'x86-kfence-fix-booting-on-32bit-non-pae-systems.patch' (revert), 
> boot well here.
> 
> but 6.1.163-rc1 with 'x86-kfence-fix-booting-on-32bit-non-pae-systems.patch'
> boot well.

Does 6.19 work properly on this hardware too?

thanks,

greg k-h
