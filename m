Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D55B26ED32;
	Wed, 22 Oct 2025 13:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761138540; cv=none; b=Phc1uz/6MyFPzcwqXbl0mtqnKWGqYYrDJOeyho8H3fH7P+Q6jrlGU7JfYhlp8pCDslbswvQTnquTjp3JxogIjB7/02qu5y6ad+bNffF1RR85ZxqrehJOD8kgNJ98Clv+HrR0fhGO38sobwswu4A9hzQA03CPcE/BoexEf9WSvMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761138540; c=relaxed/simple;
	bh=swH5suPQCeVJQves/KxlJm9+nx21NfbdyciceqcxPyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rpG4L6ASnu0ApQ1j43cp/85aR5qSv+9yh1uHGjzp15APKGtvvup9uHMrtx8ImYJp8jkTEpAv1UPN7Qq0mN2UshGRWq+uKUTHwj5BvXiU70WmZllnMw/GfMak1AesF2ErAtU7DTJNctNkBXAORRnuF4dv1b0hxr2vpLRUoghJqV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KvshL+6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KvshL+6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FE9C4CEF5;
	Wed, 22 Oct 2025 13:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761138539;
	bh=swH5suPQCeVJQves/KxlJm9+nx21NfbdyciceqcxPyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KvshL+6iQtMaBx4DFThb2VNyLIrQfgIJlW+UC7pKstUq34lvqTQyyqt0QB0nsrs7O
	 3LnqN0c4E2lgL9xYWYmE3JnmKbqV9gn4ttKj+4mj4M8AHCdKzSuvng+Hf8S3fhppYb
	 ugYnZME3WH3yCtEt7Lqwc1/ownyjhJPoxHgSC2rrgSsuxqeCX1YJOMPqdwLAjrRPKC
	 DTKUhvYfNKc4Hb+yZQm7ZlW0SuMR1RK5u9LGUtAplQPMJyGSkL2qLh7P4086V9oOcc
	 0spHm3WxK3GPrSmekdtkJ6OQYhxPn5BpgQQuW8htsnB2o1JDfW1GbDhPGQwXlaDIyp
	 WSvQJugMAu6Mw==
Date: Wed, 22 Oct 2025 15:08:52 +0200
From: Nathan Chancellor <nathan@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.17 000/563] 6.17.3-rc1 review
Message-ID: <20251022130852.GA1221362@ax162>
References: <20251013144411.274874080@linuxfoundation.org>
 <7d762aa4-b73d-49be-8150-3971435b8712@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d762aa4-b73d-49be-8150-3971435b8712@roeck-us.net>

On Fri, Oct 17, 2025 at 11:03:47AM -0700, Guenter Roeck wrote:
> On 10/13/25 07:37, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.17.3 release.
> > There are 563 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building m68k:allmodconfig ... failed
> --------------
> Error log:
> drivers/vfio/cdx/intr.c: In function 'vfio_cdx_msi_enable':
> drivers/vfio/cdx/intr.c:41:15: error: implicit declaration of function 'msi_domain_alloc_irqs'; did you mean 'msi_domain_get_virq'? [-Wimplicit-function-declaration]
>    41 |         ret = msi_domain_alloc_irqs(dev, MSI_DEFAULT_DOMAIN, nvec);
>       |               ^~~~~~~~~~~~~~~~~~~~~
>       |               msi_domain_get_virq
> drivers/vfio/cdx/intr.c: In function 'vfio_cdx_msi_disable':
> drivers/vfio/cdx/intr.c:135:9: error: implicit declaration of function 'msi_domain_free_irqs_all' [-Wimplicit-function-declaration]
>   135 |         msi_domain_free_irqs_all(dev, MSI_DEFAULT_DOMAIN);
...
> # first bad commit: [db05b70c5d4c34c748e25697bf7489b909d1d71a] cdx: don't select CONFIG_GENERIC_MSI_IRQ

Our CI sees this as well with ARCH=hexagon allmodconfig. Commit
9f3acb3d9a18 ("vfio/cdx: update driver to build without
CONFIG_GENERIC_MSI_IRQ") resolves this for me.

Cheers,
Nathan
