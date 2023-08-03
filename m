Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86218BE5
	for <patches@lists.linux.dev>; Thu,  3 Aug 2023 07:32:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E0FC433C8;
	Thu,  3 Aug 2023 07:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691047967;
	bh=L26Jabm/XZ5nSH+ICAegBePuqyUpEFwDLG3L+XJ3gu4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g98pF1V6lUZZPKqTJXT/+1pBe2AlSCWIF74BMqblS7n4lZxR+FoHBcffEEcO1qTSb
	 zL8Wa42huBw8hNwc0jnmAn5yM45RimOLVBZ3uBnfR4kfXygU7FbSHuQQrZ+kNK3dF2
	 DETmaAOvs21fcIHhkeHInYb/YiPof4S61uT+FsFE=
Date: Thu, 3 Aug 2023 09:32:44 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/225] 6.1.43-rc2 review
Message-ID: <2023080308-mountain-gyration-06ff@gregkh>
References: <20230802065510.869511253@linuxfoundation.org>
 <e5e1bccd-8e73-43c6-bc7c-052428e7c3d3@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5e1bccd-8e73-43c6-bc7c-052428e7c3d3@roeck-us.net>

On Wed, Aug 02, 2023 at 04:18:19PM -0700, Guenter Roeck wrote:
> On Wed, Aug 02, 2023 at 09:41:55AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.43 release.
> > There are 225 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 04 Aug 2023 06:54:28 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 157 pass: 157 fail: 0
> Qemu test results:
> 	total: 521 pass: 519 fail: 2
> Failed tests:
> 	arm:fuji-bmc:aspeed_g5_defconfig:notests:mem1G:mtd128,0,8,1:net,nic:aspeed-bmc-facebook-fuji:rootfs
> 	arm:bletchley-bmc,fmc-model=mt25qu02g,spi-model=mt25qu02g:aspeed_g5_defconfig:notests:mem1G:mtd256:net,nic:aspeed-bmc-facebook-bletchley:rootfs
> 
> The failed tests crash while attempting to boot from a f2fs root file
> system, suggesting that f2fs support may be broken.

Thanks for letting me know.  I've now dropped the f2fs patches from this
queue.

greg k-h
