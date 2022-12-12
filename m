Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D950828EC
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 14:30:47 +0000 (UTC)
Received: by mail-vs1-f49.google.com with SMTP id 128so11353446vsz.12
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 06:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=B0oBhmPpqjpCQ3pSDLW0VUeFJCBwI6s931jO+DuoW8A=;
        b=1AtY2omhTg2R3bhoa7ICi4BraTq9+YuOJnGycgdyAw2D30TMTB7ifWTi+nrtNPqKz/
         SsFL2luWSDWxgbuzBIsCkd0qPgaXilyI1jz+HKPCys2yP8+0EPiFUKJbetAIxxZabN1J
         v2RyU/yvlEHYelzthGPocBXxkpL5OcjRlIuy5daBMeqHvLIps6Dj+PMAKuLHU31uLwmI
         7IXTU7XfI/OEiG1XlrLmbF2IYBVr7rjzu1qEMkkO73KKd4VvjmXLitrU6tNxbC8FAS3a
         A+mONHK/XLwRAHbKgUP1D9/kM99nVfEB6RPVa5IRDmL/AIl62QFG3Pqw4oPUAdH2893x
         2gOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B0oBhmPpqjpCQ3pSDLW0VUeFJCBwI6s931jO+DuoW8A=;
        b=S24xKyoPrn+ZqIjPph592+dbJ2kcw1W8AcIxNRSA9e+UR6Z5hpRQ/HrqepFWTO/SGx
         PTeL0/4ogZrp9cFHnmsKGxorYBV41E6s1Raby6GqaxciL43H5n8UfcdlxT1YMHsqBo2S
         F8TmyiVArvK0tpv9RFTObUlMRMnggU/OkmNemViQSs7SIGM4edrmgS4n4NHyHCw3pP8f
         0N/tGz+/uVo2khIrb4CAKcy5KX8smnvB5VVHkH6Gw2TR4Oo19KojtWuzaUFMfLL0YXCR
         7YqmZnXckwK9ed0tww/7VSQS4YgtVJz6M21ygygZ9RV8ydrt4MqAjIMA7+iTxk/s5QKF
         Wy8g==
X-Gm-Message-State: ANoB5pmcwum4DqpUbM4Bzpgs1G7nnFS93q/xOl38kWQGISmTsnD++twY
	HNjQD+4NGwgnvzE5fxu0LpSWrZALaVaMw4impBey+w==
X-Google-Smtp-Source: AA0mqf5MekKZlYJc+gKxPWOq0+oucOPlAOHdRnxap/ZabiNMAKcKonTle6alCR4vKTdvfVr8tsq86TbRVLSTFsh8mO0=
X-Received: by 2002:a05:6102:3109:b0:3b1:3b81:127c with SMTP id
 e9-20020a056102310900b003b13b81127cmr11318131vsh.47.1670855446696; Mon, 12
 Dec 2022 06:30:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221212130926.811961601@linuxfoundation.org> <20221212130929.496490427@linuxfoundation.org>
In-Reply-To: <20221212130929.496490427@linuxfoundation.org>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 12 Dec 2022 15:30:36 +0100
Message-ID: <CAMRc=McmS+JizSqX=y9pBvdr=Ds6t6xt+kK+sTidbcg_6683Hw@mail.gmail.com>
Subject: Re: [PATCH 5.15 061/123] gpiolib: check the ngpios property in core
 gpiolib code
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Linus Walleij <linus.walleij@linaro.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 12, 2022 at 2:31 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Bartosz Golaszewski <brgl@bgdev.pl>
>
> [ Upstream commit 9dbd1ab20509e85cd3fac9479a00c59e83c08196 ]
>
> Several drivers read the 'ngpios' device property on their own, but
> since it's defined as a standard GPIO property in the device tree bindings
> anyway, it's a good candidate for generalization. If the driver didn't
> set its gc->ngpio, try to read the 'ngpios' property from the GPIO
> device's firmware node before bailing out.
>
> Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
> Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Stable-dep-of: ec851b23084b ("gpiolib: fix memory leak in gpiochip_setup_dev()")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpio/gpiolib.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index a87c4cd94f7a..b7b5fe151e1a 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -599,6 +599,7 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
>         int base = gc->base;
>         unsigned int i;
>         int ret = 0;
> +       u32 ngpios;
>
>         /*
>          * First: allocate and populate the internal stat container, and
> @@ -646,6 +647,26 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
>                 goto err_free_dev_name;
>         }
>
> +       /*
> +        * Try the device properties if the driver didn't supply the number
> +        * of GPIO lines.
> +        */
> +       if (gc->ngpio == 0) {
> +               ret = device_property_read_u32(&gdev->dev, "ngpios", &ngpios);
> +               if (ret == -ENODATA)
> +                       /*
> +                        * -ENODATA means that there is no property found and
> +                        * we want to issue the error message to the user.
> +                        * Besides that, we want to return different error code
> +                        * to state that supplied value is not valid.
> +                        */
> +                       ngpios = 0;
> +               else if (ret)
> +                       goto err_free_descs;
> +
> +               gc->ngpio = ngpios;
> +       }
> +
>         if (gc->ngpio == 0) {
>                 chip_err(gc, "tried to insert a GPIO chip with zero lines\n");
>                 ret = -EINVAL;
> --
> 2.35.1
>
>
>

This isn't a fix, please drop it from stable.

Bartosz
