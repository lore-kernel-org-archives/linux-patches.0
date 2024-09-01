Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCC23FC7;
	Sun,  1 Sep 2024 16:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725206475; cv=none; b=MVDOmPi45XI0DMs7gUdukOtAoqBeau4rDEu16hxEESBXKZjEfxXLY15nxVj76GlBdys63eDsysIoqnfjDnaD8ty9VNlC+3XflMoi4DpRQhx9kC7r3sS5gCpTjZgcyZD2gz1dZjHJtqonK3PJC0GmfqNW7eUYRAyKmCJHLBwW2sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725206475; c=relaxed/simple;
	bh=ynozkS1VXwufho3gIhMC1eiy7XFxoyfxs5oohDXOf84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ot2Z1Ug7bck4gF5PU1mS+8hZFTBmAv3aXnNZJDQRSCuWA8s28wBaUIg0HKv7S0UsurKmMsNGaQX8Kyk2aF4xpm/30tXdF0URQHSjNbDolzxTvWGyJtSha5aeU71yamVJNywzUgoOH6gkJYrOwoVFwvob8fM9e2V6xvYwcGPZ5wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/ZcHapl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/ZcHapl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955DFC4CEC3;
	Sun,  1 Sep 2024 16:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725206475;
	bh=ynozkS1VXwufho3gIhMC1eiy7XFxoyfxs5oohDXOf84=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A/ZcHaplgLq1Y+BM/2C+YflsroVTsxTQJ59sMSw04PgGzptv6DSdX6XokguTC76pe
	 CO9m4hOEyXiaCjrGBp13xDZimIFEhHVjMU32wdEfo5d4OSz0Mx5cwmcQOfK7MKHoCu
	 NRB57sSGbcfHAhkNYGuf7Oro1u8MFTG7JO6tkwiU=
Date: Sun, 1 Sep 2024 18:01:12 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/321] 6.1.107-rc1 review
Message-ID: <2024090104-recliner-divisibly-c33d@gregkh>
References: <20240827143838.192435816@linuxfoundation.org>
 <4f4ac35e-e31c-4f67-b809-a5de4d4b273a@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f4ac35e-e31c-4f67-b809-a5de4d4b273a@roeck-us.net>

On Sat, Aug 31, 2024 at 02:19:12PM -0700, Guenter Roeck wrote:
> On 8/27/24 07:35, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.107 release.
> > There are 321 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> > Anything received after that time might be too late.
> > 
> [ ... ]
> 
> > Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>
> >      fbdev: offb: replace of_node_put with __free(device_node)
> > 
> 
> This patch triggers:
> 
> Building powerpc:defconfig ... failed
> Building powerpc:ppc64e_defconfig ... failed
> Building powerpc:ppc6xx_defconfig ... failed
> --------------
> Error log:
> drivers/video/fbdev/offb.c: In function 'offb_init_palette_hacks':
> drivers/video/fbdev/offb.c:358:24: error: cleanup argument not a function
>   358 |                 struct device_node *pciparent __free(device_node) = of_get_parent(dp);
>       |                        ^~~~~~~~~~~
> make[5]: *** [scripts/Makefile.build:250: drivers/video/fbdev/offb.o] Error 1

Thanks for the report, should now be fixed up.

greg k-h
