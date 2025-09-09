Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52F6340DB0;
	Tue,  9 Sep 2025 16:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757436228; cv=none; b=AhY2tJodFDLaaQawQlLAvfPC4d8wOTYTKxRJSZ0Q6iH4C32v/iIKsZNK9i/CbWVD64b3vnUt3RctFMyHF51dEhYqJ6ECjF8Q8ovJaTgCQsVfN4PUqFJfQYnbOSU7fYKIm50rqrKkLqAZ3EUaWQutR8ZX2BBoy4weWF0eTBOh2nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757436228; c=relaxed/simple;
	bh=ISgrvfKX34egkTYzE2QQK5KYoABA8hWY/I975oRZhj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qGqNwO/0OvXWtWrtKY+M1Q03MxCQn8dXc9P9zfcWUAB8yfYOBu9Bi3HvstRL+mOnuAMV6Hk5UUcm2fduJePuOyANqbQekPEYLnLfkvKjPpsh2UXPFD7khU8UNv1t+++0iEHkOfL3/TTd4lMzyZ8u+MswBON4e4xqr7DWgA1byKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bifwBcDY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bifwBcDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC90DC4CEF4;
	Tue,  9 Sep 2025 16:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757436228;
	bh=ISgrvfKX34egkTYzE2QQK5KYoABA8hWY/I975oRZhj0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bifwBcDYabyV+oxPmGNM9lUPMwW99OwMMrMPfy1srHrdM1DzpXReZkMLlPP6uzmwP
	 0qNmbaRjIioZo0jj48+vKXIwGiQzfF7lLINFpVLqPxOi4YN2sZkCxQH3icvC412xSg
	 b2x4+xSykZAPu5ArhOKpR2NyBxioMQUuOv2TBTKY=
Date: Tue, 9 Sep 2025 18:43:45 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 5.4 00/45] 5.4.299-rc1 review
Message-ID: <2025090939-trash-emphases-cba8@gregkh>
References: <20250907195600.953058118@linuxfoundation.org>
 <82edb13f-134e-4aaf-ae5d-6b9f80b02e68@gmail.com>
 <32b78edd-c8a3-45d1-92df-9facadb61d89@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <32b78edd-c8a3-45d1-92df-9facadb61d89@gmail.com>

On Sun, Sep 07, 2025 at 02:28:40PM -0700, Florian Fainelli wrote:
> 
> 
> On 9/7/2025 2:08 PM, Florian Fainelli wrote:
> > 
> > 
> > On 9/7/2025 12:57 PM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.4.299 release.
> > > There are 45 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/
> > > patch-5.4.299-rc1.gz
> > > or in the git tree and branch at:
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-
> > > rc.git linux-5.4.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on
> > BMIPS_GENERIC:
> > 
> > Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
> > 
> > Looks like we have a minor regression introduced in the 5.4.297 cycle
> > that I will be solving separately:
> 
> Looks like we are missing 9bd9c8026341f75f25c53104eb7e656e357ca1a2 ("usb:
> hub: Fix flushing of delayed work used for post resume purposes") in the
> 5.4.y branch, while we do have a49e1e2e785fb3621f2d748581881b23a364998a
> ("usb: hub: Fix flushing and scheduling of delayed work that tunes runtime
> pm"), looks like the cherry pick is not exactly clean, will work on that
> later today.

Thanks for the backport!
