Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060B35234;
	Mon, 15 Apr 2024 05:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713160391; cv=none; b=X5sBkfVn+LJI/6JjHqHNmnj+2u/rJCBLSHPUEYZ/pU5WDmM7NLvTbCN3/E97wHDnxZ3j/2SIpO/ywVkjndE2Wjl3QFJJTEgkhBphFfnGy9E8Lr/KBG8NXAQYu0lwMHj3oEfeWrRinZrg3bH7MtQsJEnWsriqybFZlXpAsUvT7BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713160391; c=relaxed/simple;
	bh=GPG1/kd4ZB9qwFI4gdErArU3/kBu8MPbHNQ9e6xNK0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kdEDVaCU+P7pBQAEZT5amEiAG/tC93nDwyBKmi+S0mV41FAGZkGkRayxhwfThN4qwhCj+mC9BQUQeEqiqyeCx/gkArol48akR0BuzlQ4pdyN4MS21Ij2JczgRraL4VczzrfFF4XYQd1KavYGaF8AjoYm/qfGERYq5AFHxlGiros=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ziDb84Nt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ziDb84Nt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE54C113CC;
	Mon, 15 Apr 2024 05:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713160389;
	bh=GPG1/kd4ZB9qwFI4gdErArU3/kBu8MPbHNQ9e6xNK0g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ziDb84Nte5ZeFl7xxXB1eJ9NDEBYvtdqzpCm7BFed9Rip2rCXNVNHs86e9sF+xPh8
	 5CUGJqNJZ+fEXEF+ML2IWjdxQBBVVbKvEKV7GbX5E7L8aZAKgiQ3yfzenlFn6OKobZ
	 ZTWLDT6O80MX3ovDIQrE4pmUGVAz9J9u/BwXX+S8=
Date: Mon, 15 Apr 2024 07:53:05 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org, aleksandermj@google.com,
	ejcaruso@google.com, oneukum@suse.com
Subject: Re: [PATCH 5.10 000/294] 5.10.215-rc1 review
Message-ID: <2024041507-landmine-cattle-c911@gregkh>
References: <20240411095435.633465671@linuxfoundation.org>
 <9ac4f94c-414e-4c12-bfe0-36aff3e318bc@roeck-us.net>
 <2024041411-stencil-unscathed-bc65@gregkh>
 <039f041e-ca03-4750-8d69-87aef0ad1752@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <039f041e-ca03-4750-8d69-87aef0ad1752@roeck-us.net>

On Sun, Apr 14, 2024 at 02:18:03PM -0700, Guenter Roeck wrote:
> Hi Greg,
> 
> On Sun, Apr 14, 2024 at 08:09:39AM +0200, Greg Kroah-Hartman wrote:
> > On Sat, Apr 13, 2024 at 07:11:57AM -0700, Guenter Roeck wrote:
> > > Hi,
> > > 
> > > On Thu, Apr 11, 2024 at 11:52:43AM +0200, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.10.215 release.
> > > > There are 294 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.215-rc1.gz
> > > > or in the git tree and branch at:
> > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > > and the diffstat can be found below.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > > 
> > > > -------------
> > > [ ... ]
> > > > 
> > > > Oliver Neukum <oneukum@suse.com>
> > > >     usb: cdc-wdm: close race between read and workqueue
> > > > 
> > > 
> > > Just in case it has not been reported yet:
> > > 
> > > This patch is causing connection failures (timeouts) on all
> > > Chromebooks using the cdc-wdm driver for cellular modems, with
> > > all kernel branches where this patch has been applied.
> > > Reverting it fixes the problem.
> > > 
> > > I am copying some of the Google employees involved in identifying
> > > the regression in case additional feedback is needed.
> > 
> > Can you all respond to Oliver on the linux-usb list where this was
> > originally submitted to work it out?  This commit has been in the tree
> > for almost a month now with no reported problems that I can see.
> > 
> 
> Who knows, maybe only a certain type of usb cellular modems using cdc-wdm
> is affected. Either case, the problem was found less than two days after
> the stable tree merges into ChromeOS, and it took only about a week from
> there to identify the offending patch. I think that was actually an amazing
> job, given the size of those merges and because the failure is not absolute
> but results in unreliable tests due to timeouts.

It is an amazing job, and I wasn't trying to be snarky, I was trying to
say that "that's odd, normally usb problems are found very quickly by
lots of people and you should let the author know about this as there's
nothing I can do about it through this stable report".

I see the post on linux-usb now, thanks.

greg k-h
