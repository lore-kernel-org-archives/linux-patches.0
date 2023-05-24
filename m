Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F7C1951F
	for <patches@lists.linux.dev>; Wed, 24 May 2023 15:57:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D40C4339B;
	Wed, 24 May 2023 15:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684943869;
	bh=+KqoP3LhTsQa9GQ0Ybe2LD4KSpKGXfBUa30qiNhCBtQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=daZgqaaeCoiz9eE1VnqIy4YX/SGhIyUvD4NNCpCN+gRWiY07Eoq8/Y3e8pV4rrJTX
	 CujWWx06kJxt7a5ZIj5i0uii3zMRERTcO1OJjWtRpmOY2VN/j/GUZm+HNz8X2i5KDI
	 kushL5JyiOxDkaofe2isWayHQK5jAEcSyn3YehBY=
Date: Wed, 24 May 2023 16:57:46 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/363] 6.3.4-rc2 review
Message-ID: <2023052423-flint-importer-0609@gregkh>
References: <20230523164950.435226211@linuxfoundation.org>
 <52e30fae-36df-f098-2b1f-e7e9d00c8f0b@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52e30fae-36df-f098-2b1f-e7e9d00c8f0b@gmail.com>

On Wed, May 24, 2023 at 08:51:52AM -0700, Florian Fainelli wrote:
> 
> 
> On 5/23/2023 10:01 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.3.4 release.
> > There are 363 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 25 May 2023 16:48:37 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.4-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on
> BMIPS_GENERIC:
> 
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Greg, could you queue up:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3522340199cc060b70f0094e3039bdb43c3f6ee1

Please send this as a separate email, with what trees it should go to,
otherwise it will be lost in this thread.

thanks,

greg k-h
