Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A414477111;
	Tue,  3 Jun 2025 10:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748945197; cv=none; b=LtIHg3cKKY681u6eWyu9B8gGesquqZOQxq+Xo3lBtAXU5FsJ8ooa+ss3tzkFRgSYQfNztctgMLt+AkDs9Qoy+bTqFDKckM72MiCJRfE3hHlJjPoILkIMyQ5GvfWA0vxNV6whB/ygupcjz1KCOBajQtOIJ3RYCnIZ0ZpwfQbaQ7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748945197; c=relaxed/simple;
	bh=kfLvpZoyCcWiupBC2EXSy9QbfYDhhc2hz0Lldz8VPV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fpfZCDig3qL7Tl2/FweMiV4oqPAVZkruIwz5XzWXV4HyKrpIUiYd9SSK7QbEWmVnyZIUOmvQgWFRAswIBreW6drSgCWfM93E9B5duezKZ56LXDyEJoTutWX88kBtEm//1jdZY9z/lADMXVoH/S68bsCDgT6GaJc54Mxjc0RWnMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afSyqfm3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afSyqfm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4C0C4CEED;
	Tue,  3 Jun 2025 10:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748945197;
	bh=kfLvpZoyCcWiupBC2EXSy9QbfYDhhc2hz0Lldz8VPV0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=afSyqfm3Y+Q6z1jNuUOw0nKfXUt2rKZ16qlAS0sol9f8y42cSOwkT16nPJvYKT1U5
	 ByGegBFqyNvsAHR6AysvoUAhe5e2DtcpXRUAxtYNUx3xD7lFfY133TuO8WZStiNVE6
	 mQaWMGDkyOzANdqYZ3+UxWgnqa1Ca0jw0vr7AFHw=
Date: Tue, 3 Jun 2025 12:06:34 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.10 000/270] 5.10.238-rc1 review
Message-ID: <2025060302-reflected-tarot-acfc@gregkh>
References: <20250602134307.195171844@linuxfoundation.org>
 <6dd7aac1-4ca1-46c5-8a07-22a4851a9b34@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6dd7aac1-4ca1-46c5-8a07-22a4851a9b34@sirena.org.uk>

On Tue, Jun 03, 2025 at 10:45:34AM +0100, Mark Brown wrote:
> On Mon, Jun 02, 2025 at 03:44:45PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.238 release.
> > There are 270 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> This fails to boot with a NFS root on Raspberry Pi 3b+, due to
> 558a48d4fabd70213117ec20f476adff48f72365 ("net: phy: microchip: force
> IRQ polling mode for lan88xx") as was also a problem for other stables.

Odd, I see it in the 5.15.y released tree, so did we get a fix for it
with a different commit or should it just be dropped entirely from the
5.10.y queue?

thanks,

greg k-h

