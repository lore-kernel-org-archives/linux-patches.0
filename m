Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D82723A6
	for <patches@lists.linux.dev>; Fri, 25 Nov 2022 07:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CA4C433C1;
	Fri, 25 Nov 2022 07:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669361731;
	bh=R7jrnvlhAIaa2Rt9W0pB40Y3hHbvvTnOSc25lysB9Mc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g3EjvAi+99f3AgmQhCefRRhzRcqyt8IrnmZH8nH1Od+fCuD0goSBUluPcCYvkXplg
	 GgIlVsfCaFR3N5UZyyoOfj1YTmuZAF7jKiJLf3q6QzQp7jcDcGON8J6qnlCAdLKp0Z
	 sTNW9nG8VzwcV/cIIj9DwfPxiCHuRVUhg14VEBQA=
Date: Fri, 25 Nov 2022 08:35:27 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/314] 6.0.10-rc1 review
Message-ID: <Y4BwPwOkjrwMC7+Y@kroah.com>
References: <20221123084625.457073469@linuxfoundation.org>
 <20221123170322.GB3745358@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123170322.GB3745358@roeck-us.net>

On Wed, Nov 23, 2022 at 09:03:22AM -0800, Guenter Roeck wrote:
> On Wed, Nov 23, 2022 at 09:47:25AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.0.10 release.
> > There are 314 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build reference: v6.0.9-315-gdcf677c
> Compiler version: arm-linux-gnueabi-gcc (GCC) 11.3.0
> Assembler version: GNU assembler (GNU Binutils) 2.39
> 
> Building arm:allmodconfig ... failed
> --------------
> Error log:
> drivers/rtc/rtc-cmos.c:1347:13: error: 'rtc_wake_setup' defined but not used [-Werror=unused-function]
>  1347 | static void rtc_wake_setup(struct device *dev)

Now fixed, this commit should not have been added, as it wasn't obvious
that it was fixing an issue only in 6.1-rc, not the stable trees.

Dropped from everywhere.

greg k-h
