Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1CF33D6
	for <patches@lists.linux.dev>; Mon, 25 Apr 2022 21:30:20 +0000 (UTC)
Received: by mail-ej1-f43.google.com with SMTP id m20so11435468ejj.10
        for <patches@lists.linux.dev>; Mon, 25 Apr 2022 14:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HHqpbgvhGzfWr0EyYRxzA6HfxhKAhFMAtOp9U0tnQsw=;
        b=WWZIB1XrA4aY5urSbazaVEZIdf9VBxbccf2WK0voRgvR+yD07WDMYB/1jukoVIx2RX
         H585UqT/CMzahEyJLmbRcPezjMaxqwAK5Nemldbkf3GwKcYSgGEojTcbLIogTmY5th+m
         3flocOyBRkyw8jkmcSKEauCW7738RYVZOxvA0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HHqpbgvhGzfWr0EyYRxzA6HfxhKAhFMAtOp9U0tnQsw=;
        b=DpijdL1GjEJWejjgKad/ECSL4n//YvjSsdxOcx86PlstFbRbORXJab7EtQucYZfaNI
         egT+YmZ1PEA+cmHivf7RQQOpruymBrk1tuDzItg8Facn+ZxGSEktJuG5UbTtQCqP5WtW
         9IdSQ69nmmb0vYbdInb1RYcsoEbw3J/bczhQlvOU+VOTMjVv+JfkoB9WJq43OZ9gp8lA
         AjouEmLtvqiCm72d2rYW8I/kp0HIydmEjV+zJNx/Tj3b8Fo6R5nNmyYqncduf+8fA2Kh
         1kkjOZQQOHdSKrJChgjuaslr0MyV64VJCmmfUAo6DWI/Adz4+To2aNemOuJmTXCPFdbJ
         3P9A==
X-Gm-Message-State: AOAM530KYACuLkuuIsiUN/jozkz/XxSzP9D140GIl7F60mtZrCNhhuCt
	JgHhrbzWrl3ZZiV654KeIE1ITshet+h72EI3
X-Google-Smtp-Source: ABdhPJzDWIotcIiq1N/PiljCfHWjJtaCovdr6Z87T4Xjm2c510PUb/Ewf00i8Fu/Gtg8SOWodfDIFg==
X-Received: by 2002:a17:907:9605:b0:6e8:2f22:b0d4 with SMTP id gb5-20020a170907960500b006e82f22b0d4mr18619488ejc.129.1650922218775;
        Mon, 25 Apr 2022 14:30:18 -0700 (PDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com. [209.85.221.46])
        by smtp.gmail.com with ESMTPSA id fy11-20020a1709069f0b00b006e8b68c92d8sm3876637ejc.162.2022.04.25.14.30.17
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 14:30:17 -0700 (PDT)
Received: by mail-wr1-f46.google.com with SMTP id j15so9450626wrb.2
        for <patches@lists.linux.dev>; Mon, 25 Apr 2022 14:30:17 -0700 (PDT)
X-Received: by 2002:a05:6000:1acb:b0:20a:a4b0:dbc8 with SMTP id
 i11-20020a0560001acb00b0020aa4b0dbc8mr15378477wry.513.1650922217012; Mon, 25
 Apr 2022 14:30:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220425210726.3813477-1-swboyd@chromium.org>
In-Reply-To: <20220425210726.3813477-1-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 25 Apr 2022 14:30:04 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WT+=qMJxNiAniTrX+qonXDgESzUi00+QfN4NW=3rdp+Q@mail.gmail.com>
Message-ID: <CAD=FV=WT+=qMJxNiAniTrX+qonXDgESzUi00+QfN4NW=3rdp+Q@mail.gmail.com>
Subject: Re: [PATCH v2] Input: cros-ec-keyb: Only register keyboard if
 rows/columns exist
To: Stephen Boyd <swboyd@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, Benson Leung <bleung@chromium.org>, 
	Guenter Roeck <groeck@chromium.org>, Hsin-Yi Wang <hsinyi@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Mon, Apr 25, 2022 at 2:07 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> If the device is a detachable, we may still probe this device because
> there are some button switches, e.g. volume buttons and power buttons,
> registered by this driver. Let's allow the device node to be missing row
> and column device properties to indicate that the keyboard matrix
> shouldn't be registered. This removes an input device on Trogdor devices
> such as Wormdingler that don't have a matrix keyboard, but still have
> power and volume buttons. That helps userspace understand there isn't
> a keyboard present when the detachable keyboard is disconnected.
>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Hsin-Yi Wang <hsinyi@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>
> Changes from v1 (https://lore.kernel.org/r/20220413033334.1514008-1-swboyd@chromium.org):
>  * Use device_property_present
>
>  drivers/input/keyboard/cros_ec_keyb.c | 9 +++++++++
>  1 file changed, 9 insertions(+)

Reviewed-by: Douglas Anderson <dianders@chromium.org>
