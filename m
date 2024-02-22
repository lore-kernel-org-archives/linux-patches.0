Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A821799E
	for <patches@lists.linux.dev>; Thu, 22 Feb 2024 09:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708594264; cv=none; b=GShInftnvJtPlfxub1vY8oR+GOn6ZAUTIuh5ufjONYMJJVHuStB3ZGGCA7YJlyrTU0OTJjANu86HE1EBt2TiRGOKNNcm1AD/B/xrTKxqZnH6BhVohiOkY9jLeNzm2/dmSbeKJuEU5wZ+vLSsOrcBW6ydcvvgppxiR+qYxxRzMnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708594264; c=relaxed/simple;
	bh=9G7lJI5IDfPGdHdX5zwaUalzO36IGTyW3HIIjqi8i+0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kesNvvao6BrEylzUX6v7dgN21S3uGNPfDHOB4xgaCwHbPyh2VgGT13c/uFQKUfFpN0d7G2E95Enw53WKFt3NqXzfIhzs1/ju5HfTXTP7GnaWnDs2FfrDUoyINgbLCRQZZuAIDbd/OQE/F/n+ujtA99IrQa/A44Xiba5HzNhsoro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=GbZUUdGc; arc=none smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="GbZUUdGc"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-471c0ec6d69so42489137.0
        for <patches@lists.linux.dev>; Thu, 22 Feb 2024 01:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1708594262; x=1709199062; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1PlLc1PUqmILNE+p63A9C2ACu1wPfn85XBn9cLMW2dc=;
        b=GbZUUdGcv5ePv4eFI32vO73s1MwxtZxhVTYzu2mfC/hrDLkRSUnAsk/NhgLtM6yIUC
         1wXpwY9nSsI/XTFLmliVmjXf3I9elwKZzHBkZQWREvZvGDJjYETO0jUI/4g6c99TY+wI
         IKslf5ChyQ6K/QQwOmrTK5yXYD/XyLR0wiKuWBR+BPn5PMs1C42FFarZkESeL8tzw5vr
         2JfZ5XAAO6vexw0zLzmsFfvCPjztXbe7Ffw7nWBZj2Rad+XwgyU9U/QjsYM5GJgjH5xM
         FKlyIUuQb5cALQlXLdtABUV4awGkcoKxHdy0rlpAxDE09fHw4osWIy3OhWReovU/pvii
         fjEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708594262; x=1709199062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1PlLc1PUqmILNE+p63A9C2ACu1wPfn85XBn9cLMW2dc=;
        b=AmIWgiAZGr1uCWUan+hvb40UT6tuO6KmGLPkmDFZPfojEpfgKu8yIPtl4FZRQcrkdN
         odnArbIupqxL200SxzWDKW+S3FkPsaG2TWVg9a0P9NDGiuBO+VG+FAeY1rm9tH9jyksX
         QbgpPA4VNvlHtIb+Gg4RDzZ/iSPMZ0rf/pJtkKfytzGJJxiLJogavlf7CiT0/E/8q6yU
         l95WJp6bi5Dv2HvLToUmMezG/aTzFzFhyaWY5YhKO4nomVFhZzrFujkRYoOz0FKzyQqn
         ur601/v+YDQx7tf+rnp36AgklKPw2YnvF/4LCL2PiDqfocS5x8Efel9w+YM1uEwt1Np4
         Tidw==
X-Forwarded-Encrypted: i=1; AJvYcCX9IX7I686lwfNPTQrEXkT8+4lUZPC9i42hbEUdU8IRAn6/eqbiPACsSCxaWoQBdAiGg2JYri5Zuea7ra0muaAPrzHYI4jSug==
X-Gm-Message-State: AOJu0Yz0voTFpY+GKguAtzICD8+crZqSHL9tNh7zmswsobrfU0S3KZ4A
	hfXnUVnpD0cbGoAJCoLOfvDccGdGBRI+TijaDUHstzMVtyM9HK5Sv20GMKS6HZ+7asJ7/e4FP96
	s61PlsGTaPu/8psYXBbOIOjk3+XmyJg1joigfHg==
X-Google-Smtp-Source: AGHT+IEToLxGWX/9/V3sCdh/JRMTTDjiprSrSqjpvWgISAjno61KBiZrERpbtPCIbor9/5i13hG+MwHnX47Z9DOnSow=
X-Received: by 2002:a67:fc58:0:b0:470:4e67:3b38 with SMTP id
 p24-20020a67fc58000000b004704e673b38mr13429459vsq.14.1708594262009; Thu, 22
 Feb 2024 01:31:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240221015920.676063-1-swboyd@chromium.org>
In-Reply-To: <20240221015920.676063-1-swboyd@chromium.org>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 22 Feb 2024 10:30:51 +0100
Message-ID: <CAMRc=Md5BZxS-sCZO9oK9y02kf-Rh04DpaM8-cXk6KoJiDzmWw@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Pass consumer device through to core in devm_fwnode_gpiod_get_index()
To: Stephen Boyd <swboyd@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, linux-gpio@vger.kernel.org, 
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 21, 2024 at 2:59=E2=80=AFAM Stephen Boyd <swboyd@chromium.org> =
wrote:
>
> This devm API takes a consumer device as an argument to setup the devm
> action, but throws it away when calling further into gpiolib. This leads
> to odd debug messages like this:
>
>  (NULL device *): using DT '/gpio-keys/switch-pen-insert' for '(null)' GP=
IO lookup
>
> Let's pass the consumer device down, by directly calling what
> fwnode_gpiod_get_index() calls but pass the device used for devm. This
> changes the message to look like this instead:
>
>  gpio-keys gpio-keys: using DT '/gpio-keys/switch-pen-insert' for '(null)=
' GPIO lookup
>
> Note that callers of fwnode_gpiod_get_index() will still see the NULL
> device pointer debug message, but there's not much we can do about that
> because the API doesn't take a struct device.
>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Fixes: 8eb1f71e7acc ("gpiolib: consolidate GPIO lookups")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/gpio/gpiolib-devres.c |  2 +-
>  drivers/gpio/gpiolib.c        | 14 +++++++-------
>  drivers/gpio/gpiolib.h        |  8 ++++++++
>  3 files changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/gpio/gpiolib-devres.c b/drivers/gpio/gpiolib-devres.=
c
> index fe9ce6b19f15..4987e62dcb3d 100644
> --- a/drivers/gpio/gpiolib-devres.c
> +++ b/drivers/gpio/gpiolib-devres.c
> @@ -158,7 +158,7 @@ struct gpio_desc *devm_fwnode_gpiod_get_index(struct =
device *dev,
>         if (!dr)
>                 return ERR_PTR(-ENOMEM);
>
> -       desc =3D fwnode_gpiod_get_index(fwnode, con_id, index, flags, lab=
el);
> +       desc =3D gpiod_find_and_request(dev, fwnode, con_id, index, flags=
, label, false);
>         if (IS_ERR(desc)) {
>                 devres_free(dr);
>                 return desc;
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 44c8f5743a24..c6667a887ecb 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -4133,13 +4133,13 @@ static struct gpio_desc *gpiod_find_by_fwnode(str=
uct fwnode_handle *fwnode,
>         return desc;
>  }
>
> -static struct gpio_desc *gpiod_find_and_request(struct device *consumer,
> -                                               struct fwnode_handle *fwn=
ode,
> -                                               const char *con_id,
> -                                               unsigned int idx,
> -                                               enum gpiod_flags flags,
> -                                               const char *label,
> -                                               bool platform_lookup_allo=
wed)
> +struct gpio_desc *gpiod_find_and_request(struct device *consumer,
> +                                        struct fwnode_handle *fwnode,
> +                                        const char *con_id,
> +                                        unsigned int idx,
> +                                        enum gpiod_flags flags,
> +                                        const char *label,
> +                                        bool platform_lookup_allowed)
>  {
>         unsigned long lookupflags =3D GPIO_LOOKUP_FLAGS_DEFAULT;
>         struct gpio_desc *desc;
> diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
> index a4a2520b5f31..c6e5fb9aa212 100644
> --- a/drivers/gpio/gpiolib.h
> +++ b/drivers/gpio/gpiolib.h
> @@ -202,6 +202,14 @@ static inline int gpiod_request_user(struct gpio_des=
c *desc, const char *label)
>         return ret;
>  }
>
> +struct gpio_desc *gpiod_find_and_request(struct device *consumer,
> +                                        struct fwnode_handle *fwnode,
> +                                        const char *con_id,
> +                                        unsigned int idx,
> +                                        enum gpiod_flags flags,
> +                                        const char *label,
> +                                        bool platform_lookup_allowed);
> +
>  int gpiod_configure_flags(struct gpio_desc *desc, const char *con_id,
>                 unsigned long lflags, enum gpiod_flags dflags);
>  int gpio_set_debounce_timeout(struct gpio_desc *desc, unsigned int debou=
nce);
>
> base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
> --
> https://chromeos.dev
>

This doesn't apply on top of the for-next branch of the GPIO tree,
please rebase and resend.

Bart
