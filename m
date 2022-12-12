Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF6833D5
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 18:08:18 +0000 (UTC)
Received: by mail-vk1-f170.google.com with SMTP id e13so309892vkn.11
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 10:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vXLSgPHrhLyITa/VJ/SmFb1U95aXrYkUr0JoPBjWHPI=;
        b=Cf+XEqzxD/Jq5nBI5Tko9b7o50fvBuJP9OEBjB4shGnHMizeg1uIzzoc1ajw2beUOq
         ASUbV7Zqg3NhKiRTALczuxgcZjY9nd4Uc6XKY8M3mlXqIYwA8mYJLeqqshIiHlSMAH3Z
         MFEf47SqRhKEPSlV3vhDjWrj69wCKv8zo8LMvTwdSkLndbId7zyOHjk0jL3dWkmTAe+Z
         4S3/6IHe4mHJRAXSig6noLWi9xXgpkGUTwDL+xz9ebGeILJHGbWCojMLvJOs99oXisfW
         J/rRaWeUffLX5k7Uaz+0QHz59OKuu5MoNN414uE8VbFptoZn5TI6vAbYDW9+tf/gcvWy
         R93A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vXLSgPHrhLyITa/VJ/SmFb1U95aXrYkUr0JoPBjWHPI=;
        b=NVz9b8iC9IcVuLgMloRFlL1SlnZbu6+P6Twxcscy4Kx5I77r8OqawgFk0Jf93OfPX8
         wAPMpzVgV4yXGf7pxA/XDMOkG/d3YZL8h5wsc5U9f6m6o5X4h05EuA1bcdkou62Nicj/
         /GyJkM8ssiuHbE/ParuRCOKulKAAqS7g+Os2qbPJXU4AacU6q6aLkwINjw6ZyJeEWfMo
         H3AYlFvmNVNgKjrtFC/w/yl03F5gN2iah1OqyZnN0qsBslzkAtLwRUVVQZRJbVWWQWPR
         VIPAuoFAceUpbpAoV2a/i4MEdPdSBAXr6eJUkGx6zt7gxbXoAP047usudGg7M/v8a/qV
         3NFA==
X-Gm-Message-State: ANoB5pkvv+Zu0UGxEDmwcW/PbaePJF43ADg3FDmqia4408eu6o7DAf28
	YWO1SMSQETFFG+GuTfWERbCbcMIRGfPg2VQzYelxUg==
X-Google-Smtp-Source: AA0mqf6PMa/zNy1AtzEoewEX6ozwo2cSWoIteF78CEb+GDa5WMnsSISjyhgnOpOv5CVmDuGmXrVRiNtk6C6nw2CJHcs=
X-Received: by 2002:a05:6122:20a9:b0:3c1:534:8487 with SMTP id
 i41-20020a05612220a900b003c105348487mr416037vkd.33.1670868497805; Mon, 12 Dec
 2022 10:08:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221212130926.811961601@linuxfoundation.org> <20221212130929.453689464@linuxfoundation.org>
 <CAMRc=Mc5e6_1vLh0V97npZMSt0KSTnoFFTSAs0TZyJsbT5fDfw@mail.gmail.com> <Y5dhoACgKZDWAYne@kroah.com>
In-Reply-To: <Y5dhoACgKZDWAYne@kroah.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 12 Dec 2022 19:08:06 +0100
Message-ID: <CAMRc=MemrLEFgRX+ru=iN_pW6hqVkMYxzCrohUdNLqD4-TcLaw@mail.gmail.com>
Subject: Re: [PATCH 5.15 060/123] gpiolib: improve coding style for local variables
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Linus Walleij <linus.walleij@linaro.org>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 12, 2022 at 6:15 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Dec 12, 2022 at 03:30:14PM +0100, Bartosz Golaszewski wrote:
> > On Mon, Dec 12, 2022 at 2:31 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > From: Bartosz Golaszewski <brgl@bgdev.pl>
> > >
> > > [ Upstream commit e5ab49cd3d6937b1818b80cb5eb09dc018ae0718 ]
> > >
> > > Drop unneeded whitespaces and put the variables of the same type
> > > together for consistency with the rest of the code.
> > >
> > > Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
> > > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> > > Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > Stable-dep-of: ec851b23084b ("gpiolib: fix memory leak in gpiochip_setup_dev()")
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  drivers/gpio/gpiolib.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> > > index 320baed949ee..a87c4cd94f7a 100644
> > > --- a/drivers/gpio/gpiolib.c
> > > +++ b/drivers/gpio/gpiolib.c
> > > @@ -594,11 +594,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
> > >                                struct lock_class_key *request_key)
> > >  {
> > >         struct fwnode_handle *fwnode = gc->parent ? dev_fwnode(gc->parent) : NULL;
> > > -       unsigned long   flags;
> > > -       int             ret = 0;
> > > -       unsigned        i;
> > > -       int             base = gc->base;
> > >         struct gpio_device *gdev;
> > > +       unsigned long flags;
> > > +       int base = gc->base;
> > > +       unsigned int i;
> > > +       int ret = 0;
> > >
> > >         /*
> > >          * First: allocate and populate the internal stat container, and
> > > --
> > > 2.35.1
> > >
> > >
> > >
> >
> > This isn't a fix, please drop it from stable.
>
> It's required for a follow-on fix in the series, based on the line:
>
>         Stable-dep-of: ec851b23084b ("gpiolib: fix memory leak in gpiochip_setup_dev()")
>
> Do you want that one?  If not, then we can drop them all.
>
> thanks,
>
> greg k-h

Yes, we do want it. Go ahead then, thanks!

Bart
