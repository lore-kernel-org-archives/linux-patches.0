Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21713212
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 17:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5AEC433EF;
	Mon, 12 Dec 2022 17:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670865316;
	bh=1r4VeIPQoxBxr+R/GTIMW5mPAXzswVki/cBhc9Sm3EY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oSSWVAtr8pvsCd4WGz3z0UbXPFf1saPmad6R1+2dGMtSpeviasUnz773qCSEn+aGY
	 d/Ii3qrtUjTkpkGo4LCD9cmotgrEA9xNXubfMwUG2P/9W4fayubcyhVUQ4svgpb4wP
	 q4XWHS/V+nB/7/cVbnS7os+oJq/xd5iau5nTn31E=
Date: Mon, 12 Dec 2022 18:15:12 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 060/123] gpiolib: improve coding style for local
 variables
Message-ID: <Y5dhoACgKZDWAYne@kroah.com>
References: <20221212130926.811961601@linuxfoundation.org>
 <20221212130929.453689464@linuxfoundation.org>
 <CAMRc=Mc5e6_1vLh0V97npZMSt0KSTnoFFTSAs0TZyJsbT5fDfw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=Mc5e6_1vLh0V97npZMSt0KSTnoFFTSAs0TZyJsbT5fDfw@mail.gmail.com>

On Mon, Dec 12, 2022 at 03:30:14PM +0100, Bartosz Golaszewski wrote:
> On Mon, Dec 12, 2022 at 2:31 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Bartosz Golaszewski <brgl@bgdev.pl>
> >
> > [ Upstream commit e5ab49cd3d6937b1818b80cb5eb09dc018ae0718 ]
> >
> > Drop unneeded whitespaces and put the variables of the same type
> > together for consistency with the rest of the code.
> >
> > Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> > Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Stable-dep-of: ec851b23084b ("gpiolib: fix memory leak in gpiochip_setup_dev()")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/gpio/gpiolib.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> > index 320baed949ee..a87c4cd94f7a 100644
> > --- a/drivers/gpio/gpiolib.c
> > +++ b/drivers/gpio/gpiolib.c
> > @@ -594,11 +594,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
> >                                struct lock_class_key *request_key)
> >  {
> >         struct fwnode_handle *fwnode = gc->parent ? dev_fwnode(gc->parent) : NULL;
> > -       unsigned long   flags;
> > -       int             ret = 0;
> > -       unsigned        i;
> > -       int             base = gc->base;
> >         struct gpio_device *gdev;
> > +       unsigned long flags;
> > +       int base = gc->base;
> > +       unsigned int i;
> > +       int ret = 0;
> >
> >         /*
> >          * First: allocate and populate the internal stat container, and
> > --
> > 2.35.1
> >
> >
> >
> 
> This isn't a fix, please drop it from stable.

It's required for a follow-on fix in the series, based on the line:

	Stable-dep-of: ec851b23084b ("gpiolib: fix memory leak in gpiochip_setup_dev()")

Do you want that one?  If not, then we can drop them all.

thanks,

greg k-h
