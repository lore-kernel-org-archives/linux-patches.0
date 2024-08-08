Received: from gofer.mess.org (gofer.mess.org [88.97.38.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1728B188CB7
	for <patches@lists.linux.dev>; Thu,  8 Aug 2024 08:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=88.97.38.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723105755; cv=none; b=suRvjdmigJMIYo0UWQsZWuqDKUqKNId9y2mZoRrgLEjBUlEEsP7erX8tE4lCaNyequN3X7ue6sqQ+Uf4iGGs31c9WZjNjN5NeogtlwPHmvcjlgPrWqzaprQrmzGMbNEDVTvx/lQbRDOebb02aYAH3GWucDq+4tPLnGJ70QSEeWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723105755; c=relaxed/simple;
	bh=nAnlA9rlnS1tfbtXhBkYA2+p8QW//F4bJ7ddH/ivoZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jDfwVGVmT+5H2HJ3qP/D8zFB1prPoRxwoYPl+a1Qw0gZ7CCvOdOOgH/frYJRG2MilJoLk773O2jSEbM8mmZf5cH7C1kZ8IJIEMaG3odi/kYa5P3eMeRl5SXVG0DCMaRQ7oKSGpmxEVT5Mf++PQAlgc5nlRjrA4XIGXonJndIXGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mess.org; spf=pass smtp.mailfrom=mess.org; dkim=pass (2048-bit key) header.d=mess.org header.i=@mess.org header.b=YqT6ZUeR; arc=none smtp.client-ip=88.97.38.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mess.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mess.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mess.org header.i=@mess.org header.b="YqT6ZUeR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mess.org; s=2020;
	t=1723105745; bh=nAnlA9rlnS1tfbtXhBkYA2+p8QW//F4bJ7ddH/ivoZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YqT6ZUeR7tLJfBaJjKOvGqiqViHTCOaNVcQrVceqtaBWLELYmrxcEcub9fb5oRTMw
	 7NahLxbLRaI5YU4zckYxYCDD46UsSQ11PRGCOYr3o+CRK4ETQlzAx7tMSlnzNaYgQz
	 IM2gaVWYSnqnNTYc9g2lLCvFxmYfMRLwHeJs8N5ZYNpQZcUwXeVQJsS2BLr6/dbzWf
	 8R2K1d9C1CXv32iz+SF8dEu+5pLYtNDn5Sbv7MnlMeDJF+TKhFKe1mbJsVKgvy0UJe
	 pmptdxGko6og2OpjgPjr3DjvxTA56s9oteuZYSnDS5ANcsy87C5x49ZErZQpiATtGs
	 uEwEvNJTOJZPw==
Received: by gofer.mess.org (Postfix, from userid 1000)
	id 413941000C2; Thu,  8 Aug 2024 09:29:05 +0100 (BST)
Date: Thu, 8 Aug 2024 09:29:05 +0100
From: Sean Young <sean@mess.org>
To: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Zheng Yejian <zhengyejian1@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	linux-kernel@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.10 288/809] media: dvb-usb: Fix unexpected infinite
 loop in dvb_usb_read_remote_control()
Message-ID: <ZrSB0dco8KlKphU0@gofer.mess.org>
References: <20240730151724.637682316@linuxfoundation.org>
 <20240730151735.968317438@linuxfoundation.org>
 <20240801165146.38991f60@mir>
 <Zq5KcGd8g4t2d11x@gofer.mess.org>
 <20240803180852.6eb5f0cb@mir>
 <ZrJD_gHZCsphqT-U@gofer.mess.org>
 <20240807032152.493b037c@mir>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807032152.493b037c@mir>

On Wed, Aug 07, 2024 at 03:21:52AM +0200, Stefan Lippers-Hollmann wrote:
> On 2024-08-06, Sean Young wrote:
> > On Sat, Aug 03, 2024 at 06:08:52PM +0200, Stefan Lippers-Hollmann wrote:
> > > On 2024-08-03, Sean Young wrote:
> > > > On Thu, Aug 01, 2024 at 04:51:46PM +0200, Stefan Lippers-Hollmann wrote:
> > > > > On 2024-07-30, Greg Kroah-Hartman wrote:
> > > > > > 6.10-stable review patch.  If anyone has any objections, please let me know.
> [...]
> > > > > > Infinite log printing occurs during fuzz test:
> > > > > >
> > > > > >   rc rc1: DViCO FusionHDTV DVB-T USB (LGZ201) as ...
> > > > > >   ...
> > > > > >   dvb-usb: schedule remote query interval to 100 msecs.
> > > > > >   dvb-usb: DViCO FusionHDTV DVB-T USB (LGZ201) successfully initialized ...
> > > > > >   dvb-usb: bulk message failed: -22 (1/0)
> > > > > >   dvb-usb: bulk message failed: -22 (1/0)
> > > > > >   dvb-usb: bulk message failed: -22 (1/0)
> > > > > >   ...
> > > > > >   dvb-usb: bulk message failed: -22 (1/0)
> > > > > >
> > > > > > Looking into the codes, there is a loop in dvb_usb_read_remote_control(),
> > > > > > that is in rc_core_dvb_usb_remote_init() create a work that will call
> > > > > > dvb_usb_read_remote_control(), and this work will reschedule itself at
> > > > > > 'rc_interval' intervals to recursively call dvb_usb_read_remote_control(),
> > > > > > see following code snippet:
> [...]
> > I don't think this drivers uses the bulk endpoint, and it is missing the
> > corresponding out bulk endpoint.
> >
> > Please could you test the patch below please - that would be very helpful in
> > narrowing down this issue.
> [...]
> 
> After applying this patch, the TeVii s480 works again on both of my
> systems, but there seems to be a new error message in the log
> 
> ds3000_writereg: writereg error(err == -11, reg == 0xa2, value == 0xb7)
> ds3000_writereg: writereg error(err == -11, reg == 0x03, value == 0x12)
> ds3000_writereg: writereg error(err == -11, reg == 0x03, value == 0x12)
> ds3000_writereg: writereg error(err == -11, reg == 0x03, value == 0x02)
> ds3000_writereg: writereg error(err == -11, reg == 0x03, value == 0x02)

I've spent of a lot time reading various code paths, and I don't understand
where this is coming from, which also makes it difficult to add debug printks
too. Without the hardware to debug this, I think we have to revert the commit.

The only idea I've had so far is that we are no longer clearing a halt on
the bulk endpoint, but that seems pretty unlikely for a device that has just
been plugged in.

Stefan, thank you for reporting the issue and testing my patch.


Sean
