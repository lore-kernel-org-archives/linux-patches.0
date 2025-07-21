Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1C62D949A;
	Mon, 21 Jul 2025 13:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753105706; cv=none; b=MFWwzAW4l8n+xVMebZa7pyF5BPnEUEPA9PwOXaV001CdAesYYpkBl+0ZYpmacFKVcalQUeNHb2UoCHNn22QSdJNrjE+bpXOIUXD4c7QYLyCNWSpWes3v9uoug5DDwg5nRvIRwJdzFOwsnFIdxQ20PEHnICFehEwmQAJTMLOx5VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753105706; c=relaxed/simple;
	bh=RuuXVACjpr6OxTBTs3xZJKt8lhSYCQ+elVlHb9lJzTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GDwygedTMLY/eV+4IqXADWFC6AlGIADs/7OsznqpISSYWfPuLs5M8XHI258Wy0GnLKKD6PSdDT/pKYL4gyuPjGDTaT0h69q/ik/Q5oFKzgfBLG7PzIdQz39OL/VqTVH3wtyciuBzONT2phe7IiXC2C0nbo1DDOQPac/xE/2jDB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNMhDQVz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNMhDQVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4225C4CEED;
	Mon, 21 Jul 2025 13:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753105705;
	bh=RuuXVACjpr6OxTBTs3xZJKt8lhSYCQ+elVlHb9lJzTU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aNMhDQVzgfijhBLtLAuXhThMkYDoic7hTjxR+AwatNg7zjM39MAI6taMf3d7DYTcw
	 QQJGAPYeXUgkwM0f91Z5xQYWXuFrJ7BqdRFTe33cIeKFzM0dQLyhspkeB8KwoZ7hmy
	 K+PZRKyFNccBmT9TkfuCnGtKaC2fwtYdths/wEWU=
Date: Mon, 21 Jul 2025 15:48:22 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 000/411] 5.15.186-rc1 review
Message-ID: <2025072105-tactics-flail-4035@gregkh>
References: <20250623130632.993849527@linuxfoundation.org>
 <70823da1-a24d-4694-bf8a-68ca7f85e8a3@roeck-us.net>
 <CAFBinCD8MKFbqzG2ge5PFgU74bgZVhmCwCXt+1UK8b=QDndVuw@mail.gmail.com>
 <2025071238-decency-backboard-09dd@gregkh>
 <CAFBinCANe9oajzfZ_OGHoA-TtGC-CQdOm_O5TG8ke8m_NNE5NQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFBinCANe9oajzfZ_OGHoA-TtGC-CQdOm_O5TG8ke8m_NNE5NQ@mail.gmail.com>

On Mon, Jul 14, 2025 at 09:56:11PM +0200, Martin Blumenstingl wrote:
> Hi Greg,
> 
> On Sat, Jul 12, 2025 at 2:37 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Jul 08, 2025 at 06:05:14PM +0200, Martin Blumenstingl wrote:
> > > Hi Guenter,
> > >
> > > On Mon, Jul 7, 2025 at 8:05 PM Guenter Roeck <linux@roeck-us.net> wrote:
> > > >
> > > > On Mon, Jun 23, 2025 at 03:02:24PM +0200, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 5.15.186 release.
> > > > > There are 411 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > >
> > > > > Responses should be made by Wed, 25 Jun 2025 13:05:51 +0000.
> > > > > Anything received after that time might be too late.
> > > > >
> > > > ...
> > > > > Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> > > > >     drm/meson: use unsigned long long / Hz for frequency types
> > > > >
> > > >
> > > > This patch triggers:
> > > >
> > > > Building arm:allmodconfig ... failed
> > > > --------------
> > > > Error log:
> > > > drivers/gpu/drm/meson/meson_vclk.c:399:17: error: this decimal constant is unsigned only in ISO C90 [-Werror]
> > > >   399 |                 .pll_freq = 2970000000,
> > > >
> > > > and other similar problems. This is with gcc 13.4.0.
> > > Sorry to hear that this is causing issues.
> > > Are you only seeing this with the backport on top of 5.15 or also on
> > > top of mainline or -next?
> > >
> > > If it's only for 5.15 then personally I'd be happy with just skipping
> > > this patch (and the ones that depend on it).
> >
> > It's already merged, and I see these errors in the Android build reports
> > now.  I think they've just disabled the driver entirely to get around it :(
> Can you confirm that only 5.15 is affected - or do you also see
> problems with other stable versions?
> 
> > > 5.15 is scheduled to be sunset in 16 months and I am not aware of many
> > > people running Amlogic SoCs with mainline 5.15.
> >
> > Great, can we send a "CONFIG_BROKEN" patch for this then?
> In my own words: you're asking for a patch for the next 5.15 release
> which adds "depends on BROKEN" to the meson drm driver. Is this
> correct?

Yes, given that it seems no one uses it there :)

thanks,

greg k-h
