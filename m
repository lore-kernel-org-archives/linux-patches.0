Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE671849B
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11712C433D7;
	Thu, 27 Oct 2022 17:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890717;
	bh=OthIepUJZIoPch672mR6O1MyRWeTc583C3jgDvQAITY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zEwFnupunEu00yR3dWXQii8wByzqh61KTC5R3dYUX+2hkZ/poSe8hHhK2EPoA4+Nx
	 SjTln3P3ce5lYitnLFqd6yDSo+pAsjNcXaZWCBu94DSNJ65DBx8MV0YZ99hdzqZb/I
	 G2W8ixcEAva62Cajn/T1Q845U1bnA3cpcVezExVU=
Date: Thu, 27 Oct 2022 19:11:45 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/94] 6.0.6-rc1 review
Message-ID: <Y1q70RS+mhz1vD8U@kroah.com>
References: <20221027165057.208202132@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>

On Thu, Oct 27, 2022 at 06:54:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.6 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.

A process change for those who care.

Previously, all of the -rc patches have been sent to
linux-kernel@vger.kernel.org.  That turns out to be a lovely way to
stress-test email servers both on the sending, and receiving side.

The vger postmasters have done a valiant job in fixing up all sorts of
crazy issues that this has caused over the years, moving jobs to
different machines, moving some reciever domains to separate queues or
machines, and trying to debug loony gmail server issues.  They have, and
continue to, do a wonderful job at all of this.

But the stable patch bombs were causing problems, no matter what.  To
help try to aliviate the overally mail load on the main linux-kernel
list, I am now NOT sending all of the patches to lkml, only the -rc
announcements.

If you want to see all of the patches, they will all be cc:ed to the
stable@vger.kernel.org list, and they should all show up almost
instantly on lore.kernel.org as they are getting sent also to the
patches@lists address as well.

So this should provide a bit of breathing room on the main linux-kernel
mailqueue for a while.  And if you do want to see the full set of
patches, either use lore and the assorted tools that can easily get
emails out of it, or subscribe to the stable@vger mailing list.

thanks,

greg "I had a spam assassin rule named after me" k-h
