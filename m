Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D795225B5
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 18:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+CeRgYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A2EC433C8;
	Tue, 10 Oct 2023 18:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696963381;
	bh=xuJQBkZ40eoYwA9Ihdt5nQEAu4U80UA46rmFAeOlETI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J+CeRgYmUqznuNK3A1KzeBLqZHQ6qj7M/VIMOvqj6S4LJDKZvHbAb0CjoVfWkmSVz
	 DXuyk2QQe0sIYUDeqO6aboVmJA1mzWP3TBBtiwpfEjLT+ulusGDrdH3COfezqj9cov
	 QwDVkw6uNkkCQ7+fBpVofXKsoJ42YtHLCOOQC58w=
Date: Tue, 10 Oct 2023 20:42:59 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: wqu@suse.com, stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.1 000/162] 6.1.57-rc1 review
Message-ID: <2023101053-heading-chase-e2c2@gregkh>
References: <20231010161046.7861.409509F4@e16-tech.com>
 <2023101008-argue-impart-a6ad@gregkh>
 <20231010194221.C1C3.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231010194221.C1C3.409509F4@e16-tech.com>

On Tue, Oct 10, 2023 at 07:42:22PM +0800, Wang Yugui wrote:
> Hi,
> 
> > On Tue, Oct 10, 2023 at 04:10:48PM +0800, Wang Yugui wrote:
> > > Hi,
> > > 
> > > > This is the start of the stable review cycle for the 6.1.57 release.
> > > > There are 162 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> > > > Anything received after that time might be too late.
> > > 
> > > 
> > > drop this patch from 6.5/6.1/5.15/... please, 
> > >   Qu Wenruo <wqu@suse.com>
> > >      btrfs: reject unknown mount options early
> > > 
> > > becuase of this report.
> > > https://lore.kernel.org/linux-btrfs/f3ac7b74-c011-4d1f-a510-677679fc9743@gmx.com/T/#t
> > 
> > Is there a revert somewhere for this already?
> 
> Yet not.
> 
> but we can suspend to apply this patch(drop this patch) for stable.

Now dropped, thanks.

greg k-h
