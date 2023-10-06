Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2031F601
	for <patches@lists.linux.dev>; Fri,  6 Oct 2023 12:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X2GNxUhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BABDC433C8;
	Fri,  6 Oct 2023 12:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696596940;
	bh=CaAJAaUkmo9qFT1sX60nD4yOm7k2sG7FItez9Toav58=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X2GNxUhFC7tJomuVmbcvsseypuRzGAo1ahYukNqrvZpo7bRZmjANxOOPmsjPg+gbI
	 I5nxwBLtCFWfNcv/XvvnEB4DZzCgz7F+USMCHnbNGZJ3Zj4BHZ9UXgzUbTg/y1THYo
	 eNjWYI832+Dptq140gHxRMcBE2Vbex9d3jMYi2kc=
Date: Fri, 6 Oct 2023 14:55:37 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: sakari.ailus@linux.intel.com, davthompson@nvidia.com,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.1 000/259] 6.1.56-rc1 review
Message-ID: <2023100624-aneurism-overboard-55ac@gregkh>
References: <20231004175217.404851126@linuxfoundation.org>
 <ZR6rvGqpwdSeOeHt@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZR6rvGqpwdSeOeHt@duo.ucw.cz>

On Thu, Oct 05, 2023 at 02:27:40PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 6.1.56 release.
> > There are 259 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Here are some issues:
> 
> > Sakari Ailus <sakari.ailus@linux.intel.com>
> >     media: via: Use correct dependency for camera sensor drivers
> > Sakari Ailus <sakari.ailus@linux.intel.com>
> >     media: v4l: Use correct dependency for camera sensor drivers
> 
> These are is unsuitable for 6.1 as the VIDEO_CAMERA_SENSOR symbol does
> not exist in 6.1. Please drop.

It is in the 6.1.y tree, please look closer.
