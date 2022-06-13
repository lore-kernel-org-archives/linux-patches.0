Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2908C3D8E
	for <patches@lists.linux.dev>; Mon, 13 Jun 2022 23:26:06 +0000 (UTC)
Received: by mail-io1-f45.google.com with SMTP id y12so7747636ior.7
        for <patches@lists.linux.dev>; Mon, 13 Jun 2022 16:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cbxRBPwDsE33S/4VWlMl76EK8aUfLE1juYHGI23Fd9s=;
        b=Q7KcmegsUIXtRK/aUvN0dfl38itVsJxSdSzTcmQADGwvhawJSCjwQwVZ0S8tUk0MLT
         sMnvKm08Vjq/p4mvxxELqyBzAmAjWGgT7rWjMhrgeHhzxIhiWA+1OfCJLNEYSXGBiuwX
         KKgoji0LufhQdFZhgUnLRooUwbeqYKZVNWnzk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cbxRBPwDsE33S/4VWlMl76EK8aUfLE1juYHGI23Fd9s=;
        b=GbPpDqTG/98tGy2RoNJdjcy/rVWh/XRkmJuJUQiUHhlfw7ILOnhDEt5/bX0gVcf+t3
         BJeIaxK6+r3Syriilb6H9kKfHolMv/obhJQ/1d5wXKaG2V9aiVeo6zWcmdRcJgAQ6ffW
         FXJP1J0aEI+TN3owULBZpgD8tZvXRbu7i+laBUn4WdNqmyk2IS1gGQtX+LPXlgfmgGtD
         wORhJYT9o1msxuZgslL13eCEQRy+gnQowXkMeWIcKhE+elCX8EaD3Ln11qzEFLyDqKzV
         RKHn+x68W4T1flvteiPujukqLeWqurI2/08EPausS/I3ULdlbKa+0SxYMvwcYPeqdjLG
         YqRQ==
X-Gm-Message-State: AOAM53064WylqNrGnWD7u07dAVMcT2C1a/vlMsJ3EC0t0iAlvMdqtxBP
	rNMh6HYDrLpg4X6ayLoOS3Pdw+m4wADBmPTuptw2RA==
X-Google-Smtp-Source: ABdhPJz6BzkhxT4qPiTDFCP9A72GGdJ/EGAHIkamJTf26bfTUwgdrW/qNn+EcsJTpA9WG7RlmeDt//ajXwXTAncS/68=
X-Received: by 2002:a05:6602:2d4b:b0:669:f213:c6e1 with SMTP id
 d11-20020a0566022d4b00b00669f213c6e1mr1080945iow.77.1655162766187; Mon, 13
 Jun 2022 16:26:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220613232224.2466278-1-swboyd@chromium.org>
In-Reply-To: <20220613232224.2466278-1-swboyd@chromium.org>
From: Gwendal Grignou <gwendal@chromium.org>
Date: Mon, 13 Jun 2022 16:25:55 -0700
Message-ID: <CAPUE2usiMSi-njO5G9wELOdRuL428Vw9BtS4NfbKX1wtVCMaWA@mail.gmail.com>
Subject: Re: [PATCH] iio:proximity:sx9324: Check ret value of device_property_read_u32_array()
To: Stephen Boyd <swboyd@chromium.org>
Cc: Jonathan Cameron <jic23@kernel.org>, Aashish Sharma <shraash@google.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, linux-iio@vger.kernel.org, 
	kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 13, 2022 at 4:22 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> From: Aashish Sharma <shraash@google.com>
>
> 0-day reports:
>
> drivers/iio/proximity/sx9324.c:868:3: warning: Value stored
> to 'ret' is never read [clang-analyzer-deadcode.DeadStores]
>
> Put an if condition to break out of switch if ret is non-zero.
>
> Signed-off-by: Aashish Sharma <shraash@google.com>
> Fixes: a8ee3b32f5da ("iio:proximity:sx9324: Add dt_binding support")
> Reported-by: kernel test robot <lkp@intel.com>
> [swboyd@chromium.org: Reword commit subject, add fixes tag]
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Gwendal Grignou <gwendal@chromium.org>
> ---
>  drivers/iio/proximity/sx9324.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/iio/proximity/sx9324.c b/drivers/iio/proximity/sx9324.c
> index 70c37f664f6d..63fbcaa4cac8 100644
> --- a/drivers/iio/proximity/sx9324.c
> +++ b/drivers/iio/proximity/sx9324.c
> @@ -885,6 +885,9 @@ sx9324_get_default_reg(struct device *dev, int idx,
>                         break;
>                 ret = device_property_read_u32_array(dev, prop, pin_defs,
>                                                      ARRAY_SIZE(pin_defs));
> +               if (ret)
> +                       break;
> +
>                 for (pin = 0; pin < SX9324_NUM_PINS; pin++)
>                         raw |= (pin_defs[pin] << (2 * pin)) &
>                                SX9324_REG_AFE_PH0_PIN_MASK(pin);
>
> base-commit: f2906aa863381afb0015a9eb7fefad885d4e5a56
> --
> https://chromeos.dev
>
