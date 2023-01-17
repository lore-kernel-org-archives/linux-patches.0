Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B352906
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 14:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63817C43396;
	Tue, 17 Jan 2023 14:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673965241;
	bh=HVjYbcbIJqfuU8LXS8YoP7sbskPMk0r1wpvuZF2N8Cw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UHf+qHkbZA9FT63mH1FDa9Wd82xAZTZWBymhF99aIszJNfGADZLMw66RzpP820Cek
	 WVRpRh2kmw0bXz2Y4a5RW0yd3qj1c6Xz1R4DaThB/1EuhOZulso1+oLCFBCv0xElmd
	 RLU7rQrI6DGlFZ9mDSIM8A3KIJxD3vKh+nUg2ZHU=
Date: Tue, 17 Jan 2023 15:20:33 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/64] 5.10.164-rc1 review
Message-ID: <Y8ausb2O0NOkIaid@kroah.com>
References: <20230116154743.577276578@linuxfoundation.org>
 <Y8aWCCF8bvmMnj0g@debian>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8aWCCF8bvmMnj0g@debian>

On Tue, Jan 17, 2023 at 12:35:20PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Jan 16, 2023 at 04:51:07PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.164 release.
> > There are 64 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> > Anything received after that time might be too late.
> 
> Build test (gcc version 11.3.1 20221127):
> mips: 63 configs -> no failure
> arm: 104 configs -> 1 failure
> arm64: 3 configs -> 1 failure
> x86_64: 4 configs -> no failure
> alpha allmodconfig -> no failure
> powerpc allmodconfig -> no failure
> riscv allmodconfig -> no failure
> s390 allmodconfig -> no failure
> xtensa allmodconfig -> no failure
> 
> Note:
> arm and arm64 builds fail with the error:
> drivers/gpu/drm/msm/dp/dp_aux.c: In function 'dp_aux_isr':
> drivers/gpu/drm/msm/dp/dp_aux.c:427:14: error: 'isr' undeclared (first use in this function); did you mean 'idr'?
>   427 |         if (!isr)
>       |              ^~~
>       |

Should now be fixed in -rc2.

thanks,

greg k-h
