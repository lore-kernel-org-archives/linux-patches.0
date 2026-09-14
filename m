Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9545416878;
	Mon, 14 Sep 2026 09:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789376946; cv=none; b=OPLGa808yogG8q/xDtrkih29kXGl6TsSPvCfRUf9V419oRZDb6/yjyYm3KQEimC2+VipQv9Tl27dP/nP82N+8VLOZ1OfSt5hNoR9V2X/wfgnIxSRIYiPhb2dC2IbGGaxFrSdugQnNX/+R8pvzV87rcOvVqGecoWokkdwozne8QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789376946; c=relaxed/simple;
	bh=SQX1Ihtp8vlPlp7BIRiTqEhXT1mK3ku5djSZZlHmGy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l4KAd+ha8o0dDIBmWj9uueHITgF7oak4FCVTgATa84BbPcwdCT924ufZmFN7moThCOA2gjqyVhjGby51+/LjSwJuNqNFp9V+thPfCaQnizZ6Z1fuBYs2xeNp6PmBA9+dcv25+7nMdW4rhjXVh4Qi4zAPKdH1kCRt5+KyG6rPtcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SVVHpE37; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVVHpE37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A45F1F000FF;
	Mon, 14 Sep 2026 09:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789376943;
	bh=Az6YCOgA4UVg0WOcnRCLjVKawdm3WH+z7wXhR3hGgVo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SVVHpE37VGWTolIzCcR6v0ldmMA3hfh7eIBrnLClXxMK/BKKYr+/OZntYAfogYRox
	 liVjdgh6bYpWoMJie4obZ7aooKq3ZE0Sd25WzNA6f0PRjVsKM0pJ7R0BJNscEoMTJa
	 4ejYt89e/LeGlFA9p9T/zwRJ4MDScD7V9dpzIV6o=
Date: Mon, 14 Sep 2026 11:08:52 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 7.2 1158/1815] leds: gpio: Make legacy gpiolib interface
 optional
Message-ID: <2026091416-hazy-armrest-2040@gregkh>
References: <20260912065648.999753832@linuxfoundation.org>
 <20260912065716.196499692@linuxfoundation.org>
 <21533d54-3b31-4030-9dd4-9f9b1714bc5d@app.fastmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21533d54-3b31-4030-9dd4-9f9b1714bc5d@app.fastmail.com>

On Sat, Sep 12, 2026 at 12:54:42PM +0200, Arnd Bergmann wrote:
> On Sat, Sep 12, 2026, at 08:48, Greg Kroah-Hartman wrote:
> > 7.2-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > [ Upstream commit 98c5c7b0d4269ecabfc86b8b49ffcfa47979e99d ]
> >
> > There are still a handful of ancient mips/armv5/sh boards that use the
> > gpio_led:gpio member to pass an old-style gpio number, but all modern
> > users have been converted to gpio descriptors.
> 
> I think it's a bit too risky to backport the GPIOLIB_LEGACY cleanup
> to stable kernels. What is this one needed for?

It had:
	Stable-dep-of: 942901eeda93 ("leds: gpio: Clear error pointers for skipped LEDs")

But I've fixed that one up now to not need this and will drop this patch
from 6.18.y and 7.2.y.  Thanks for the review!

greg k-h

> 
>      Arnd
