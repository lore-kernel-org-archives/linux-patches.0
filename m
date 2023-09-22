Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783234174B
	for <patches@lists.linux.dev>; Fri, 22 Sep 2023 16:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7A4C433C8;
	Fri, 22 Sep 2023 16:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695399542;
	bh=r8ZtX/WhNqdykwR8TbeoJiycGFO05185e+m1c96HymE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zGQI7Ussf1xuByWNERNVaFe+5LihRSxsioj+Df775DsgRCi/TXKhBVIxXILY92asa
	 QKWA+t/IfFmqYdSW8qIq3GGa2P12LormGBAzUwWlUwobpkpW/DqJbDyKJKx2SrRD8D
	 W7+LPIJiDuUcGnnHtq+7JUALX4PwPVDVzP/fdLq0=
Date: Fri, 22 Sep 2023 18:18:58 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/139] 6.1.55-rc1 review
Message-ID: <2023092233-frozen-sadden-5f0d@gregkh>
References: <20230920112835.549467415@linuxfoundation.org>
 <7d99c7d8-cf39-4ab8-a385-36af98f4a30a@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d99c7d8-cf39-4ab8-a385-36af98f4a30a@roeck-us.net>

On Thu, Sep 21, 2023 at 09:03:09AM -0700, Guenter Roeck wrote:
> On Wed, Sep 20, 2023 at 01:28:54PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.55 release.
> > There are 139 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 157 pass: 156 fail: 1
> Failed builds:
> 	powerpc:ppc32_allmodconfig
> Qemu test results:
> 	total: 529 pass: 529 fail: 0
> 
> Building powerpc:ppc32_allmodconfig ... failed
> --------------
> Error log:
> drivers/usb/gadget/udc/fsl_qe_udc.c: In function 'ch9getstatus':
> drivers/usb/gadget/udc/fsl_qe_udc.c:1964:17: error: ISO C90 forbids mixed declarations and code

Very odd that this only shows up on this one platform.  I'll go fix it
up, thanks for the report.

greg k-h
