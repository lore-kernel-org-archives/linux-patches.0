Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E847C1CFBD;
	Sun, 14 Apr 2024 06:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713074989; cv=none; b=XCp7WgG6HYjBjSQ25vvBhe6PbYI9mm8UORC1ajSr8lpNOLmrg7MS4y1ujtLv4lKOLDVSnYuGZu8H7gDIFVaaRVt3EfqkQrlXEajjEA1SoGaGIgU+j7TS8SxedvWfVnqxahIn3cPZ97z/OgVNhS3LI+WFsN0M1uechPbOw7pZArY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713074989; c=relaxed/simple;
	bh=9v+DDn2iRs6/wDy9tYErOIrVROmK2B00lt9ReBYY7sA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kocWrVO4PEN7B09q5cvZ+6xn4yDJed0hGbqVR7KSfaGeyEGsBCCCA34u1rVrptNCZ/zKQ8j6QUfS53Tvs1a+Ln/WWnNfGwoUPH6vlekdN5N0I4yuwf2wwc6Jy7UaIURfbAz6lkbDLxruxDIfQPIA5WFgSDVD01X4LsQ2g/BZZT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTpt42aa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTpt42aa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EACC072AA;
	Sun, 14 Apr 2024 06:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713074988;
	bh=9v+DDn2iRs6/wDy9tYErOIrVROmK2B00lt9ReBYY7sA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HTpt42aaB/isRKM7YijErp1luP3chWgVTtTwVanm6Fx0Tss4POjBzrnjnxx1ILnUb
	 NnY6/6qeug7qTxoMGX7ZylsG0sPotBQp4lfuNweHnlr3HJA9t1ErKWUp2aDByxH7G2
	 NOf0rA7W2lNVnNBax4VRKLbnD9pE4w49Vl+gG48c=
Date: Sun, 14 Apr 2024 08:09:39 +0200
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
Message-ID: <2024041411-stencil-unscathed-bc65@gregkh>
References: <20240411095435.633465671@linuxfoundation.org>
 <9ac4f94c-414e-4c12-bfe0-36aff3e318bc@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ac4f94c-414e-4c12-bfe0-36aff3e318bc@roeck-us.net>

On Sat, Apr 13, 2024 at 07:11:57AM -0700, Guenter Roeck wrote:
> Hi,
> 
> On Thu, Apr 11, 2024 at 11:52:43AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.215 release.
> > There are 294 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.215-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> [ ... ]
> > 
> > Oliver Neukum <oneukum@suse.com>
> >     usb: cdc-wdm: close race between read and workqueue
> > 
> 
> Just in case it has not been reported yet:
> 
> This patch is causing connection failures (timeouts) on all
> Chromebooks using the cdc-wdm driver for cellular modems, with
> all kernel branches where this patch has been applied.
> Reverting it fixes the problem.
> 
> I am copying some of the Google employees involved in identifying
> the regression in case additional feedback is needed.

Can you all respond to Oliver on the linux-usb list where this was
originally submitted to work it out?  This commit has been in the tree
for almost a month now with no reported problems that I can see.

thanks,

greg k-h
