Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB90CDDC7;
	Mon, 27 Nov 2023 12:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1unsdqfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10A4C433C7;
	Mon, 27 Nov 2023 12:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701088958;
	bh=aaKzm9i45LO58fVj2NpSXP+hjRQ7QKMZXrEwp83qEB4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=1unsdqfov2BkJ1pGOY10t3XNL0cFdCiYdAEURB5PGMJFoLfjIwXgexbkHns54Cvvc
	 2rOTHTymcJxnZzl3qiEbMsOaievkSvjVWl1UnnG49StDWSXLvEHnLsdX1GZfhG6lYj
	 mzJPnr7n3DvyaUZGl01TN0pyCRRvjT5fQ8CndaRs=
Date: Mon, 27 Nov 2023 12:42:35 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 000/292] 5.15.140-rc3 review
Message-ID: <2023112722-delicacy-arrange-59bd@gregkh>
References: <20231126154348.824037389@linuxfoundation.org>
 <3632c7da-24ba-4259-a590-5c46f899d43f@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3632c7da-24ba-4259-a590-5c46f899d43f@roeck-us.net>

On Sun, Nov 26, 2023 at 08:24:57AM -0800, Guenter Roeck wrote:
> On 11/26/23 07:46, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.140 release.
> > There are 292 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> > Anything received after that time might be too late.
> > 
> 
> For v5.15.139-293-g0dd3c4f0979f (-rc3), powerpc:defconfig:
> 
> arch/powerpc/platforms/pseries/iommu.c: In function 'find_existing_ddw':
> arch/powerpc/platforms/pseries/iommu.c:908:49: error: 'struct dma_win' has no member named 'direct'
>   908 |                         *direct_mapping = window->direct;
> 
> 
> git blame points to commit 19bed3228b3aa ("powerpc/pseries/iommu: enable_ddw
> incorrectly returns direct mapping for SR-IOV device").

Ugh, forgot to drop this one from 5.15.y, now done.

thanks,

greg k-h
