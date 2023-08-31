Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26C911CB6
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 17:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5752C433C7;
	Thu, 31 Aug 2023 17:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693502548;
	bh=iImPqkFM0alVdg4CvWUfxDNDltAgQ72o2O/mlA/lRxs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dnW6RjyoeLKpu8UsHELQI8YoKXo4OEg/UU96/JMM2m0LYbZ8hcK7eRQz+tJrIMOWw
	 mJ3HyTWa1PxyhI/A1L1BbOoZXMUlcUh5hIgAbozGbZxvagU6aWw0F3zKTefW3aPAF/
	 P5AnP0zvrwOT5mxOxhF1rwBFRgAGM8EydvwbDtWE=
Date: Thu, 31 Aug 2023 19:22:25 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.19 0/1] 4.19.294-rc1 review
Message-ID: <2023083112-hazelnut-subject-0736@gregkh>
References: <20230831110828.433348914@linuxfoundation.org>
 <fbefb0cd-e056-4504-b0b2-ebd778d4996f@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbefb0cd-e056-4504-b0b2-ebd778d4996f@roeck-us.net>

On Thu, Aug 31, 2023 at 09:10:02AM -0700, Guenter Roeck wrote:
> On Thu, Aug 31, 2023 at 01:09:48PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.294 release.
> > There are 1 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> > Anything received after that time might be too late.
> > 
> 
> arch/arm/mach-ep93xx/timer-ep93xx.c:12:10: fatal error: platform.h: No such file or directory
>    12 | #include "platform.h"
> 
> "ARM: ep93xx: fix missing-prototype warnings" needs to be reverted in
> v4.19.y as well.

Oops, missed that, let me go add it and push out a -rc2.

thanks for the quick test.

greg k-h
