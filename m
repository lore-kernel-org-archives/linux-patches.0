Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5598F47
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 10:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4813DC433C7;
	Thu, 31 Aug 2023 10:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693477781;
	bh=DmxDznbQymJ2l8KcXrB0FW74Sx+X6XG0I+epJHJAKgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zlXeIlhhR1EEgvMgKY1aP4Y3gNA9z7wylIZIEs3u5d7Y0zxUSt4lGc5YnKbTE4/jP
	 NIQzb9hHlDGGgvZj6t0aDfhb7LyxRd2zS/MixP6aKcr7V+fXNfrczFle3vh4vhRhtF
	 /6xM/coOxFa/sTSu36TsBI3ySUg6fXvtwfet4vRE=
Date: Thu, 31 Aug 2023 12:29:39 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 000/135] 5.10.192-rc1 review
Message-ID: <2023083132-puzzle-vastly-b840@gregkh>
References: <20230824170617.074557800@linuxfoundation.org>
 <27d08b24-3581-4451-b8db-5df144784d6a@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27d08b24-3581-4451-b8db-5df144784d6a@roeck-us.net>

On Wed, Aug 30, 2023 at 09:44:33AM -0700, Guenter Roeck wrote:
> Hi,
> 
> On Thu, Aug 24, 2023 at 07:07:52PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.192 release.
> > There are 135 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 26 Aug 2023 17:05:50 +0000.
> > Anything received after that time might be too late.
> > 
> [ ... ]
> 
> > Lang Yu <Lang.Yu@amd.com>
> >     drm/amdgpu: install stub fence into potential unused fence pointers
> > 
> 
> This patch is causing continuous log spam in chromeos-5.10, so we are
> going to revert it.
> 
> WARNING: CPU: 1 PID: 13383 at include/linux/dma-fence.h:478 amdgpu_sync_keep_later+0x95/0xbd
> 
> This is just a note to let others know that this may be the cause
> if they see the same problem.

Thanks, I'll go revert it now.

greg k-h
