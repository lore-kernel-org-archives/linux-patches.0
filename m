Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FC91B285;
	Sat, 15 Jun 2024 10:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718448803; cv=none; b=PE/fESkMvBnOAWlZbM8ZFeoB6zXMJenQ05HEFTrgi7MnW+DvbHzTfbkJGmKifsbHC2a9tQ+ZK5l9TwroBSN7z2Y1liZeb1RNjoq+jlqEn7/w9v544pH4U/EExl9RBOq0o2S3Qqt9dSbTep+7drHEae5G9c8CL3tyLDrSFRl1F8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718448803; c=relaxed/simple;
	bh=kfEstT1rbDYivP27kx+VLFlV3ei4+jYeiwimZcp4Hds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pux0ku0KqS747UWWfFpzXowkgcEK0U9wd6IM2vlnOeiQe+Boczj+RRyiybwsCrsfu//YAI1Rj8KpOyFRTqQQ37mRCAAHZ9BM1w4Cdv7814qrUsN5rCE+2jgjQ2iJfs4A3qkR7honRHjBW2QPhAm+IVKz3fyMnn5OfnZN4/AlYks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIh6s1+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIh6s1+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B72C116B1;
	Sat, 15 Jun 2024 10:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718448802;
	bh=kfEstT1rbDYivP27kx+VLFlV3ei4+jYeiwimZcp4Hds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VIh6s1+tvpju/v2WzfJhtuxPdO8Q1RiQBHOUnMp25WWoOHxFRgvWY/IEUihaCU1fc
	 8r1Lt8OLLhvxFQzglisu9jdvwoVQSJUvGyDRBmM1gcYCvtEzuqw5RY/H/utPlo7bfA
	 kDEGFg37B3tyF6C6mNSTXMGOCfHOaXSlvVW+bUXY=
Date: Sat, 15 Jun 2024 12:53:20 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 000/213] 4.19.316-rc1 review
Message-ID: <2024061512-causal-flatterer-4da6@gregkh>
References: <20240613113227.969123070@linuxfoundation.org>
 <5adf6fda-7936-4a45-8372-dde37f993afb@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5adf6fda-7936-4a45-8372-dde37f993afb@roeck-us.net>

On Thu, Jun 13, 2024 at 09:24:09AM -0700, Guenter Roeck wrote:
> On Thu, Jun 13, 2024 at 01:30:48PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.316 release.
> > There are 213 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> > Anything received after that time might be too late.
> >
> 
> $ git grep remove_new
> drivers/hsi/controllers/omap_ssi_core.c:        .remove_new = ssi_remove,
> drivers/hsi/controllers/omap_ssi_port.c:        .remove_new = ssi_port_remove,
> 
> There is no remove_new callback in v4.19.y, so this results in
> 
> drivers/hsi/controllers/omap_ssi_core.c:653:3: error:
>       field designator 'remove_new' does not refer to any field in type
>       'struct platform_driver'
>   653 |         .remove_new = ssi_remove,

Now dropped, thanks!

greg k-h
