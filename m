Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4B5158874;
	Fri, 31 Jan 2025 08:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738313839; cv=none; b=geNRsLDnszQNfTxoxkORdgj6GKEDslYefwoLLv4WvIRzTy85TWMxDlMdeyqCmx3/p7FXQn+tC9ajja/7JcLS3cSMsEMhqvaYCqEUQjCsT46Jk5Ibfoc0l9c44LSZFUgzVikUH+12dCQRjr+Z4sGdX0NmBqQATAFAXhuLDMVXki4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738313839; c=relaxed/simple;
	bh=luxWJ7FXt6+ana01izRsfu/WQ61S8W7NLfjrWuVweKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mnh48VRV6coRGQVx1KLuq0svGLhDYe2g9LsVV+LNQLhjQY+VonoXsoTd0XE6ZZI6ToUnbN7KPdjPKJZTT1ZjColpRR2eVuxdiE55rcfKIk2lYopAq0PWIbdChd+NqGdljlAcu9GJQpzbHNrjnrr1GoLD2XEemwHCwClxTEZlv3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=meSxrvHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="meSxrvHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A12C4CED1;
	Fri, 31 Jan 2025 08:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738313838;
	bh=luxWJ7FXt6+ana01izRsfu/WQ61S8W7NLfjrWuVweKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=meSxrvHJm1rwLKAuREvnPTC6yJ3+99pcJL7daMTkvL7sKNHttO1JJ3ZHClhAhMBtX
	 Z/CRDGjtHIYy0488EtAdpySy5aCsbkep+MlgXxz/+cGPwaAccL4kV52o0cqn10B5TU
	 Fzfr8CljuPUmj797Knd+58MXBux4xGarPOE0xScQ=
Date: Fri, 31 Jan 2025 09:57:15 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH 5.4 00/91] 5.4.290-rc1 review
Message-ID: <2025013151-culture-sharpie-f779@gregkh>
References: <20250130140133.662535583@linuxfoundation.org>
 <CA+G9fYsiw4GSjL7Sf51OaGM_-uWAQYaLCb14L_RC81nwoZJJzA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsiw4GSjL7Sf51OaGM_-uWAQYaLCb14L_RC81nwoZJJzA@mail.gmail.com>

On Fri, Jan 31, 2025 at 01:05:40AM +0530, Naresh Kamboju wrote:
> On Thu, 30 Jan 2025 at 19:47, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.290 release.
> > There are 91 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 01 Feb 2025 14:01:13 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.290-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> The following build regressions were noticed and reported last time
> on 5.15 and found here again on arc, arm, mips, parisc, powerpc with
> gcc and clang toolchains on 5.4.290-rc1 and 5.10.234-rc1.
> 
> Build regression: arc, arm, mips, parisc, powerpc,
> drivers/usb/core/port.c struct usb_device has no member named
> port_is_suspended

Ick, missed that again.  I'll go fix this up for both branches and push
out -rc2 releases soon.

thanks,

greg k-h
