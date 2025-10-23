Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677102FD1DA;
	Thu, 23 Oct 2025 15:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761233860; cv=none; b=nzDGK7vVuMjVNSSMwUNgu/ky+APm3INDovSdw3P7I0ZngFonhECS+b3J0tXhop3nXitAmyvE44n5UTNpuo6orrQakcDwk08bZaGLE07hUqzpGmExDArvuWJ69rXL3DlsVrlNGIj9EkbJ10XHyB4z888WWndDYlIPhgVQIW9G1hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761233860; c=relaxed/simple;
	bh=nZQHZBGJA0dspt1JZdkYmR340SVDu6+R4Nq+hrvBsOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rN743kuQvBMeizvnZs2wUFRKE9icVQ2F/0gylma/AekkzEYxKUw6cl4iFB9bMfPlNj39eKrmCibkuTMp2fVr5Nsaugc3Ct5D3p3VRU/jirwR0BarAZkvonnFaVfRwwFvuqixvqL/98aXf8iB+7uGuDHynTDHNIUDqYRFcc2hh9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDXrlqyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDXrlqyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6298CC4CEE7;
	Thu, 23 Oct 2025 15:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761233859;
	bh=nZQHZBGJA0dspt1JZdkYmR340SVDu6+R4Nq+hrvBsOg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gDXrlqyZTFwM/QhfhBohfhOevY8nWIbnERiRuavTNn6DAHk6p+xbLfB1qkwrjxQNM
	 4+HEKcXbYI0NdLyK+5YDDSLbc9ahcWI49kMzgU2jcnqWCKkLuDQOZNs8JG/xR540Sq
	 8Ey1KHy30p+o1ldgkzzj8KAFXEWOFvKNuP1kQwig=
Date: Thu, 23 Oct 2025 17:37:36 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.17 000/563] 6.17.3-rc1 review
Message-ID: <2025102330-sliding-unturned-31bd@gregkh>
References: <20251013144411.274874080@linuxfoundation.org>
 <7d762aa4-b73d-49be-8150-3971435b8712@roeck-us.net>
 <20251022130852.GA1221362@ax162>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022130852.GA1221362@ax162>

On Wed, Oct 22, 2025 at 03:08:52PM +0200, Nathan Chancellor wrote:
> On Fri, Oct 17, 2025 at 11:03:47AM -0700, Guenter Roeck wrote:
> > On 10/13/25 07:37, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.17.3 release.
> > > There are 563 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Building m68k:allmodconfig ... failed
> > --------------
> > Error log:
> > drivers/vfio/cdx/intr.c: In function 'vfio_cdx_msi_enable':
> > drivers/vfio/cdx/intr.c:41:15: error: implicit declaration of function 'msi_domain_alloc_irqs'; did you mean 'msi_domain_get_virq'? [-Wimplicit-function-declaration]
> >    41 |         ret = msi_domain_alloc_irqs(dev, MSI_DEFAULT_DOMAIN, nvec);
> >       |               ^~~~~~~~~~~~~~~~~~~~~
> >       |               msi_domain_get_virq
> > drivers/vfio/cdx/intr.c: In function 'vfio_cdx_msi_disable':
> > drivers/vfio/cdx/intr.c:135:9: error: implicit declaration of function 'msi_domain_free_irqs_all' [-Wimplicit-function-declaration]
> >   135 |         msi_domain_free_irqs_all(dev, MSI_DEFAULT_DOMAIN);
> ...
> > # first bad commit: [db05b70c5d4c34c748e25697bf7489b909d1d71a] cdx: don't select CONFIG_GENERIC_MSI_IRQ
> 
> Our CI sees this as well with ARCH=hexagon allmodconfig. Commit
> 9f3acb3d9a18 ("vfio/cdx: update driver to build without
> CONFIG_GENERIC_MSI_IRQ") resolves this for me.

Now queued up,t hanks.

greg k-h
