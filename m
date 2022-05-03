Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF677F
	for <patches@lists.linux.dev>; Tue,  3 May 2022 00:50:58 +0000 (UTC)
Received: by mail-io1-f52.google.com with SMTP id f4so17690245iov.2
        for <patches@lists.linux.dev>; Mon, 02 May 2022 17:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9J01ulpJYuD85Ua2b4Z3CSKv7anNmbjAMoLL+x9ZEpM=;
        b=NClZTO1lrag4qnroLMDkkbP3isGuZ96PhtjlMZj1F0gnm+ax+Xj8U85biRRxbeFUy4
         7Z39bmQ2sP99StT//gfXtj6MyuFynilZ67Oy2Rcy/kmmSvIlLx/hnwdjd7B3x4zlomA2
         b6kgxvm8ub5U1185hSRCTnkl4b+ME1h+jNO00=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9J01ulpJYuD85Ua2b4Z3CSKv7anNmbjAMoLL+x9ZEpM=;
        b=xSMZkuznqdHdZWlomzsffKD64QERvUpFvlTTqb3gTRLe29vv7S3ELKggKS0CjRF8ni
         IxO2iMXfswQ5wd8EWx6S1gd8ijuFHyyPPJkEysZI6bDPzD1WW10egzGRP0lXt8C2BzYM
         TbILv24ewlSdce71bmJ1LCXKd2qAByYpaq4poAJAAANjcFueIiOR9Z+ocLn6z+mRMo2N
         WGlsKOUdIJ71doDnCOphXmkX6BEu3YNl2Eh1rGoPdfPOLf4SYNf0QSPLLDk6hBKIlfmx
         WIzRY//muG6Ei+IOOVh9zbmBodHhnnk5tyB+7+6Wj4wb0gkzsMAtyWvvGMVQb5UIaVW6
         pLgA==
X-Gm-Message-State: AOAM532UiZdzbG4sgHOPF/2kYebL4Y5XEk25lRHAAZX0dg1SgSHTW+sx
	+6KISwv33Bh41c1FHiutReF0n7puAKVhn5i5HDOl5Gu0jx9YKQ==
X-Google-Smtp-Source: ABdhPJwRFgrMh1pooiPeQoY3V/x6VQ9V4gTsYXNEYYLcxTsk9rJSzar3B8D3rxcceDM7NfH0Ukgctl/xhPy5vBiLNuw=
X-Received: by 2002:a5d:9316:0:b0:657:a364:ceb with SMTP id
 l22-20020a5d9316000000b00657a3640cebmr5054846ion.63.1651539057290; Mon, 02
 May 2022 17:50:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220503004156.3559940-1-swboyd@chromium.org> <20220503004156.3559940-3-swboyd@chromium.org>
In-Reply-To: <20220503004156.3559940-3-swboyd@chromium.org>
From: Gwendal Grignou <gwendal@chromium.org>
Date: Mon, 2 May 2022 17:50:46 -0700
Message-ID: <CAPUE2uvQ0cg0HJ5GrCtUR0v2+BKtSD044NEjB-eGJXS8fExBcQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] iio: sx9324: Add setting for CS idle mode
To: Stephen Boyd <swboyd@chromium.org>
Cc: Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	devicetree@vger.kernel.org, linux-iio@vger.kernel.org, 
	Rob Herring <robh+dt@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Gwendal Grignou <gwendal@chromium.org>

On Mon, May 2, 2022 at 5:42 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> Based on device tree setting, set the CS idle mode.
>
> Cc: Gwendal Grignou <gwendal@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/iio/proximity/sx9324.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/drivers/iio/proximity/sx9324.c b/drivers/iio/proximity/sx9324.c
> index 7f367f63e362..79683f0d4e9a 100644
> --- a/drivers/iio/proximity/sx9324.c
> +++ b/drivers/iio/proximity/sx9324.c
> @@ -57,6 +57,11 @@
>         GENMASK(SX9324_REG_AFE_CTRL0_RINT_SHIFT + 1, \
>                 SX9324_REG_AFE_CTRL0_RINT_SHIFT)
>  #define SX9324_REG_AFE_CTRL0_RINT_LOWEST       0x00
> +#define SX9324_REG_AFE_CTRL0_CSIDLE_SHIFT      4
> +#define SX9324_REG_AFE_CTRL0_CSIDLE_MASK \
> +       GENMASK(SX9324_REG_AFE_CTRL0_CSIDLE_SHIFT + 1, \
> +               SX9324_REG_AFE_CTRL0_CSIDLE_SHIFT)
> +#define SX9324_REG_AFE_CTRL0_RINT_LOWEST       0x00
>  #define SX9324_REG_AFE_CTRL1           0x21
>  #define SX9324_REG_AFE_CTRL2           0x22
>  #define SX9324_REG_AFE_CTRL3           0x23
> @@ -872,6 +877,8 @@ sx9324_get_default_reg(struct device *dev, int idx,
>  {
>         static const char * const sx9324_rints[] = { "lowest", "low", "high",
>                 "highest" };
> +       static const char * const sx9324_csidle[] = { "hz", "hz", "gnd",
> +               "vdd" };
>  #define SX9324_PIN_DEF "semtech,ph0-pin"
>  #define SX9324_RESOLUTION_DEF "semtech,ph01-resolution"
>  #define SX9324_PROXRAW_DEF "semtech,ph01-proxraw-strength"
> @@ -901,6 +908,15 @@ sx9324_get_default_reg(struct device *dev, int idx,
>                 reg_def->def = raw;
>                 break;
>         case SX9324_REG_AFE_CTRL0:
> +               ret = device_property_read_string(dev,
> +                               "semtech,cs-idle-sleep", &res);
> +               if (!ret)
> +                       ret = match_string(sx9324_csidle, ARRAY_SIZE(sx9324_csidle), res);
> +               if (ret >= 0) {
> +                       reg_def->def &= ~SX9324_REG_AFE_CTRL0_CSIDLE_MASK;
> +                       reg_def->def |= ret << SX9324_REG_AFE_CTRL0_CSIDLE_SHIFT;
> +               }
> +
>                 ret = device_property_read_string(dev,
>                                 "semtech,int-comp-resistor", &res);
>                 if (ret)
> --
> https://chromeos.dev
>
