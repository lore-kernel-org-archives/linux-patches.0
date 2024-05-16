Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C801514D0;
	Thu, 16 May 2024 13:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715864745; cv=none; b=NXJSHMafT7SeUwV3lS0+Y3NpUOJwI4OhMYec7KpD6a7S7fDkshk3GVl4SzzujXnmvJPoRtrlMWqvX0/hDDrtd7e3nt4pfVtNqXCt+rhRYUdjMmsTM+Oil0WVW15yWmpa0G1kepk+lVnbsV8XJ5niy8LoKK6+q1v4HFhVNBmCQCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715864745; c=relaxed/simple;
	bh=Ke1oGpsUlk+WCojKC8HCTnGiWFT9wqfEGpfx0tqlf+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OhJ40iHdHidoaybLH7fFSGk0DeIfeKkS7c9hld9K+vK10IVH9BVYvOXNCQE3wedyZeceluNhvc+0JsRSJBQ4vxzRvpc3M72Nk694xdKWtXVhUc+aitVuIMlL0KtUfiPKvBe6bZlD+gyEoPJ1T5Z3ySQn+GUlPrtEPXI3hXfZguM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYCzIPSC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYCzIPSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D62CC2BD11;
	Thu, 16 May 2024 13:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715864744;
	bh=Ke1oGpsUlk+WCojKC8HCTnGiWFT9wqfEGpfx0tqlf+0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GYCzIPSCn2nAUUIrcWpObh4RyTsjvcjTws2RAdJ0Ib5T+rVksOxvLppjwZcDQ7qKM
	 hkNNguol/fNJodC4nl8pIa2dTyaC1cIL1U2xYjFX2eLhRl9YesYEkh/HjHIyl6XR+h
	 Pid8j6r3XbGsi0W94JzMWVNwY1boexDRZMrP3vB8=
Date: Thu, 16 May 2024 15:05:42 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: rrameshbabu@nvidia.com, kuba@kernel.org, lirongqing@baidu.com,
	vkoul@kernel.org, bumyong.lee@samsung.com, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 00/63] 4.19.314-rc1 review
Message-ID: <2024051635-portly-requisite-32a3@gregkh>
References: <20240514100948.010148088@linuxfoundation.org>
 <ZkX64npLMXs0gdNY@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZkX64npLMXs0gdNY@duo.ucw.cz>

On Thu, May 16, 2024 at 02:24:02PM +0200, Pavel Machek wrote:
> > Vinod Koul <vkoul@kernel.org>
> >     dmaengine: Revert "dmaengine: pl330: issue_pending waits until WFP state"
> > Bumyong Lee <bumyong.lee@samsung.com>
> >     dmaengine: pl330: issue_pending waits until WFP state
> 
> We apply patch just to revert it immediately. Rules say "- It must be
> obviously correct and tested.". You do this often, should the rules be
> fixed?

We apply patches that are cc: stable and having the change, and then the
revert, is the best way forward otherwise we get lots of complaints we
didn't take the first commit.  This way all tools are happy, and people
are not confused as to why we did not take patches we should have.

greg k-h
