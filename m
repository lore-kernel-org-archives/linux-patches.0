Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076187711F;
	Wed, 15 Jan 2025 15:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736953670; cv=none; b=eM8v5OBTOoBjzYlVspAjqnMInphwcy4EbapVTTOwf2Hsqw6zG/a2E0Wp8h2aJ4XoCbRam1JY+IoPItRZ9tIqz8T4sNkQHLkFkh3PVwDTso6p9uor/hFyRzjttnH5Klsr6RpN+4ZX7WJjvrhjgteKhusA150Jvo6eNgaTLwhY1Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736953670; c=relaxed/simple;
	bh=6tNY2Q8TLfNr3PgrRY67w8rUseQLL2cKPwzfJgy6s1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BN1W8yMhatyfB/6rEzVUHXeMzgN9OgZ91xQof5lbVY2Fwq6cmLcYusg9wEhiDI5F6Ojx9lhdh4DZ7BRKupOzH/1+lYIb0IHoGH7XL6HpKGelhtUrmtq1uxpzVkc8Eg6XZJuDC34t4p2StU1eFAvr/OW4v6hRgkizRHdd6TSH3gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2hHCbCq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hHCbCq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE09AC4CED1;
	Wed, 15 Jan 2025 15:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736953669;
	bh=6tNY2Q8TLfNr3PgrRY67w8rUseQLL2cKPwzfJgy6s1M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2hHCbCq1bcRvlmPNCNdcVWDY7pKTNQRquwo6xCz+YKQUve8IXHtpMFiy7gRGxxnB8
	 sb0VnmdHeoFxJixQbj7rcNzFY95rm2ZySgJMJES2o8iv4nh0mDxWx7xhizH8BWGNe5
	 EI3Og8PpOqw5uKBSr1vPhqKMJDw4WRKLjUmvLemY=
Date: Wed, 15 Jan 2025 16:07:45 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: Pavel Machek <pavel@denx.de>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/92] 6.1.125-rc1 review
Message-ID: <2025011506-pronto-antirust-6ded@gregkh>
References: <20250115103547.522503305@linuxfoundation.org>
 <Z4evJUkzHauW+zOU@duo.ucw.cz>
 <eb167e35-ab0d-4037-aa44-3fa74a450e69@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb167e35-ab0d-4037-aa44-3fa74a450e69@w6rz.net>

On Wed, Jan 15, 2025 at 06:09:06AM -0800, Ron Economos wrote:
> On 1/15/25 04:50, Pavel Machek wrote:
> > Hi!
> > 
> > > This is the start of the stable review cycle for the 6.1.125 release.
> > > There are 92 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > Still building, but we already have failures on risc-v.
> > 
> > drivers/usb/core/port.c: In function 'usb_port_shutdown':
> > 2912
> > drivers/usb/core/port.c:417:26: error: 'struct usb_device' has no member named 'port_is_suspended'
> > 2913
> >    417 |         if (udev && !udev->port_is_suspended) {
> > 2914
> >        |                          ^~
> > 2915
> > make[4]: *** [scripts/Makefile.build:250: drivers/usb/core/port.o] Error 1
> > 2916
> > make[4]: *** Waiting for unfinished jobs....
> > 2917
> >    CC      drivers/gpu/drm/radeon/radeon_test.o
> > 
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1626266073
> > 
> > Best regards,
> > 								Pavel
> 
> I'm seeing the build failure here also. Looks like it's due to not having
> CONFIG_PM set in the config. The member "port_is_suspended" is inside of an
> #ifdef CONFIG_PM in include/linux/usb.h. The #ifdef CONFIG_PM has been
> removed at some point.

Yeah, it was fixed up in 6.4 with commit 130eac417085 ("xhci: use
pm_ptr() instead of #ifdef for CONFIG_PM conditionals"), which is why we
didn't see this as a dependency.  I'll see if I can figure that out
tomorrow for how to backport it as it doesn't apply cleanly.

thanks,

greg k-h
