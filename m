Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAF4EC4;
	Wed, 11 Sep 2024 12:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726058926; cv=none; b=KqMiAkT7JlnDUnuLaI1yZXUOuxTULq+/aj4hb7bgEY+yvWeiiJGZvW0SdC/mCtk/uzupI1gWud4EAAmoouLHi3x7DsGStneZyRLqQI5733d5+cBVrmGVyMxWxfNCahBIHrSHt7IBw6P97rldDyOMB9Z49Yu2ogIYeCEJY6rPgWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726058926; c=relaxed/simple;
	bh=v5qKO6icHcs5h0Sx3nrHOjh3khVnL2bP26VIEtOMwf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OdLK8N4sL/BOndYRyIGgtrE6UWyBe4rE9mhvqeBwDVxy7YlhfFuWkeyFHkiWItLnUr8npy6KSz/7h7ASrBQNg419bLWCs0fg4Z5AXfc+/dlWNhD6zE+8XEEE1Wc1m3txbaPuweoqvFePXD3R9+bF4KnMdItcITlutEOcAH71W3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/uQHr1b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/uQHr1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BC0C4CEC5;
	Wed, 11 Sep 2024 12:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726058925;
	bh=v5qKO6icHcs5h0Sx3nrHOjh3khVnL2bP26VIEtOMwf4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=w/uQHr1bRXD/DoU+SvItqGz2X7ZdmGwB76wYc7D4ybI51xCHCQVbn/e+Yt0yM3cE3
	 Ii24qn0H7EDBBZXKFwLj7uzIZnjTpAF2ky+KxvIYZJEyZWm6NXN4cMIrRhyNP9bvLE
	 j64UqbGI64N24VPGY6jBwOggu0qgGYvf1XxMz4dY=
Date: Wed, 11 Sep 2024 14:48:42 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 000/214] 5.15.167-rc1 review
Message-ID: <2024091136-proactive-uncrushed-a7ec@gregkh>
References: <20240910092558.714365667@linuxfoundation.org>
 <cb8e0e51-a934-4aaa-91dc-c4530ece99c7@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb8e0e51-a934-4aaa-91dc-c4530ece99c7@linuxfoundation.org>

On Tue, Sep 10, 2024 at 03:12:17PM -0600, Shuah Khan wrote:
> On 9/10/24 03:30, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.167 release.
> > There are 214 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.167-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> I am seeing a modpost error when I install the kernel. Looks
> ERROR: modpost: module ad7606_par uses symbol ad7606_reset from namespace IIO_AD7606, but does not import it.
> make[1]: *** [scripts/Makefile.modpost:133: modules-only.symvers] Error 1
> make[1]: *** Deleting file 'modules-only.symvers'
> make: *** [Makefile:1825: modules] Error 2
> 
> I am seeing a modpost error when I install the kernel. Looks
> like thge following commit is the problem.
> 
> > 
> > Guillaume Stols <gstols@baylibre.com>
> >      iio: adc: ad7606: remove frstdata check for serial mode

Will drop this, thanks!

greg k-h
