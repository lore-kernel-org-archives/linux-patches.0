Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3625B139E
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 14:30:25 +0000 (UTC)
Received: by mail-vs1-f52.google.com with SMTP id k185so11366578vsc.2
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 06:30:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=U2Sl70StxkgITjnsDcQQNOj7ZeEYzAvq2G6yC0OXO/g=;
        b=KS4QU9NDMlTulLnjorjkUu6IRNLKiQS7S2GFn5EQgkY+boWUdl09+sU7dZcgUSBZEd
         mc+vCpRIA4x0jSZj3Vz2MxMsz4r683HMzrNzWko1dUezsY8jkm0qQh+0Nm2v1Pyu1OQ9
         pH33z/SyDQeSruSaHO5KyNie4w2PNO+yb4JVKQN/31mZ/OoakXWnEP7kz5UpqkOSXrMP
         C2nLS8bomkdTW7o1AHC+KqJDfqDfnlsCr0h+R/xLMteZf3pgvBLhQk/L22vRjncGATue
         k025GveFgyVWEguxCgPzB0ULQPksBfJtJgXIQyU9fTEhwJNEUy6KQuAw9RP5TyqLwxBb
         izZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U2Sl70StxkgITjnsDcQQNOj7ZeEYzAvq2G6yC0OXO/g=;
        b=v3saafAcXj4QgASd3MNSBC8Q9FDNPm6z8hfvYZLby2Lgld/URxr3yLVPKFw2BudLBX
         TsbfnkWGZbKAkp0Gg4cYhL2n0BwSP+c9Uae0xNBdxXd3MgUseIpMEZoAVHx3Es0ZA7Ie
         OV4g+yzWbq+9lHf/tgNalGBW8i9KqJUcl9VYcyZ2eDL7ifm/vXQL7HthHr1gv87L1lIr
         3lMjMWotPvgd4SfNOJx2UOGK0WkVffGLIOCa8KCD/dnLTsW8PAgjiRGbPTcCC8i0NdBg
         4Xt91Ti5MsCVzrEz12/CNEFJfdfIm+1FzdBkdeBbNuEtR6AwYoHR5XpPlQMu+Jq3HdhD
         WpBQ==
X-Gm-Message-State: ANoB5pkYZ9uehtfGgJEjK93lfQrA6/sQE5+56Upq1YbUetRO+wanrxav
	UtKmAPYWf8xGhNNUOYUTeVaSY379P/5WIRo/Elu3aw==
X-Google-Smtp-Source: AA0mqf6bml2soIr4eInLtks4Y+ThRZR/Fs/TvFAlImbNfEgbln2P+WWKIUzMBrAPDlx68B33sUGUcoJApEwthzyEgbY=
X-Received: by 2002:a05:6102:722:b0:3b0:eec8:ce04 with SMTP id
 u2-20020a056102072200b003b0eec8ce04mr20162668vsg.16.1670855424910; Mon, 12
 Dec 2022 06:30:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221212130926.811961601@linuxfoundation.org> <20221212130929.453689464@linuxfoundation.org>
In-Reply-To: <20221212130929.453689464@linuxfoundation.org>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 12 Dec 2022 15:30:14 +0100
Message-ID: <CAMRc=Mc5e6_1vLh0V97npZMSt0KSTnoFFTSAs0TZyJsbT5fDfw@mail.gmail.com>
Subject: Re: [PATCH 5.15 060/123] gpiolib: improve coding style for local variables
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Linus Walleij <linus.walleij@linaro.org>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 12, 2022 at 2:31 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Bartosz Golaszewski <brgl@bgdev.pl>
>
> [ Upstream commit e5ab49cd3d6937b1818b80cb5eb09dc018ae0718 ]
>
> Drop unneeded whitespaces and put the variables of the same type
> together for consistency with the rest of the code.
>
> Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Stable-dep-of: ec851b23084b ("gpiolib: fix memory leak in gpiochip_setup_dev()")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpio/gpiolib.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 320baed949ee..a87c4cd94f7a 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -594,11 +594,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
>                                struct lock_class_key *request_key)
>  {
>         struct fwnode_handle *fwnode = gc->parent ? dev_fwnode(gc->parent) : NULL;
> -       unsigned long   flags;
> -       int             ret = 0;
> -       unsigned        i;
> -       int             base = gc->base;
>         struct gpio_device *gdev;
> +       unsigned long flags;
> +       int base = gc->base;
> +       unsigned int i;
> +       int ret = 0;
>
>         /*
>          * First: allocate and populate the internal stat container, and
> --
> 2.35.1
>
>
>

This isn't a fix, please drop it from stable.

Bartosz
