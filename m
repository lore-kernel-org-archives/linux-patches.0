Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCC0468B
	for <patches@lists.linux.dev>; Sat, 23 Sep 2023 08:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A56C433C8;
	Sat, 23 Sep 2023 08:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695457943;
	bh=7qXTttt6UdnvonzS9jffXdd766F1Tdbk9CNER3h84IM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MNXBIb8ndlRJ4TyzGfGZGZgzvCB9LRjRbTK1BVyWTB9VTuodLVSf34wS4uXCp6e2K
	 GHEEDtg5z6cn1CUslcTkZkqeNo2Y/kjhqTMtLQWJFA3r030IRV2zjwvMaxt3lzR36Z
	 j+yTXw1Aa02fQOdRWTfK3KIRoVermXhajyx3kPEY=
Date: Sat, 23 Sep 2023 10:32:20 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.19 000/273] 4.19.295-rc1 review
Message-ID: <2023092311-roman-colossal-d33b@gregkh>
References: <20230920112846.440597133@linuxfoundation.org>
 <f0e0f90f-d24a-6d71-b3eb-3e15e834f7b2@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0e0f90f-d24a-6d71-b3eb-3e15e834f7b2@roeck-us.net>

On Thu, Sep 21, 2023 at 05:22:04AM -0700, Guenter Roeck wrote:
> On 9/20/23 04:27, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.295 release.
> > There are 273 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building arm:allmodconfig ... failed
> Building arm:imx_v6_v7_defconfig ... failed
> 
> drivers/pci/controller/dwc/pci-imx6.c:645:10: error: 'const struct dw_pcie_host_ops' has no member named 'host_deinit'; did you mean 'host_init'?
>   645 |         .host_deinit = imx6_pcie_host_exit,
>       |          ^~~~~~~~~~~
>       |          host_init
> drivers/pci/controller/dwc/pci-imx6.c:645:24: error: 'imx6_pcie_host_exit' undeclared here (not in a function); did you mean 'imx6_pcie_host_init'?
>   645 |         .host_deinit = imx6_pcie_host_exit,
>       |                        ^~~~~~~~~~~~~~~~~~~
>       |                        imx6_pcie_host_init
> 

Offending patch now dropped, thanks.

greg k-h
