Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2661392
	for <patches@lists.linux.dev>; Tue,  9 May 2023 03:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDE7C433D2;
	Tue,  9 May 2023 03:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683601381;
	bh=YPHQfv7IscC0DBbnpqrUWLJ6kDkQr6sORNu5Wm0HuLo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bzGkgGW2BVks9KLVgl3jZFwivq02uB98DtZh6Qz1IStajuD1AfkIzuY8J3h6TQPQV
	 XHBNbSZd/p7LrlweQukb4sTN3LMRt0Lm2nobxtW9J1h6mPkSq0cGxoNwcxcSrZqp6A
	 PVcWYEhlqCIlSpMuOWCwO/fKykRMQ6YN3ExPjc/k=
Date: Tue, 9 May 2023 05:02:58 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, Pierre Gondois <pierre.gondois@arm.com>,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/694] 6.3.2-rc1 review
Message-ID: <2023050932-avenging-annex-0cef@gregkh>
References: <20230508094432.603705160@linuxfoundation.org>
 <0ab5fa02-c2cf-fe09-8825-a25493f6e358@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ab5fa02-c2cf-fe09-8825-a25493f6e358@gmail.com>

On Mon, May 08, 2023 at 03:46:02PM -0700, Florian Fainelli wrote:
> On 5/8/23 02:37, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.3.2 release.
> > There are 694 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 10 May 2023 09:42:40 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.2-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> We also need to bring in this patch from upstream:
> 
> 3522340199cc060b70f0094e3039bdb43c3f6ee1 ("arch_topology: Remove early
> cacheinfo error message if -ENOENT") otherwise we will be spitting out the
> "Early cacheinfo failed, ret = " messages on boot.

Now queued up, thanks!

greg k-h
