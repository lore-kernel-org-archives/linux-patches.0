Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5783204
	for <patches@lists.linux.dev>; Tue,  3 May 2022 15:09:26 +0000 (UTC)
Received: by mail-ed1-f49.google.com with SMTP id z19so20170329edx.9
        for <patches@lists.linux.dev>; Tue, 03 May 2022 08:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EW58m2+b9sI8zBQxJJNwiRm2NLx6RkDOvMaweiiKwJI=;
        b=kP0sjsAoi+T8Qd0UDI0pKRBJxpP0ihheGFQgxyMYs9AHtJ6sFLwBIzKvl2ZQUnbF61
         9n91OBEICBk2fREjbLlMG0LW3/mcvUaEjToNI49hAKWzZMxSTcWX8bjxpDW+dzkEKpcP
         63+I/QdvJSIPvl8JSQmUqWaKUnY52tyVnfi3A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EW58m2+b9sI8zBQxJJNwiRm2NLx6RkDOvMaweiiKwJI=;
        b=oA/MwxVoHO0QnMaJSGpCrI9jX7yl68VLBxk7MLng9fUsbbq8ymBNcRpunHDhkZvQZh
         zoZXC14261jgHeYkfZ9QExmSrUCLD80XDztjRg+9sUsP7QgjcWVbgO6zJqchfKNH6zg4
         SC3Z8gpqLqVy7BrXIlxj162G+lXYnWARXnq1N53LiRiFaJTvQAcgXtl+NikuWMuewhbQ
         5a8NBoiWLaFMRB673jtej75ZMgdrVdU/KJeBSG4qygiCilmwT2LiMY2zniHp1RI9PyMg
         29mXCkopYO2DQxWS6szvReDCItnlp+N2RJ5JG6QYEBLHZ6jcrVYk8wLFaRRc6cFKH2Mu
         o9Tw==
X-Gm-Message-State: AOAM533zk0WmjjEHvl5/XbnxOlY2IdvQ3RuYGsNWgcfQM6nzUvIj8sPA
	NIM+tASp6kptipOIs1f6O2W/JFYL341vJ4ks
X-Google-Smtp-Source: ABdhPJwJeUukfgQ8A/J82pta6nImTV9SJwqUIQjq+tlsZU2JrAOBXkQpq9cgFroyo0qIF3ulaN6trA==
X-Received: by 2002:a05:6402:5216:b0:427:e191:42c8 with SMTP id s22-20020a056402521600b00427e19142c8mr3990448edd.250.1651590564950;
        Tue, 03 May 2022 08:09:24 -0700 (PDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com. [209.85.128.48])
        by smtp.gmail.com with ESMTPSA id mm30-20020a170906cc5e00b006f3ef214e06sm4728836ejb.108.2022.05.03.08.09.23
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 08:09:24 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso1577003wma.0
        for <patches@lists.linux.dev>; Tue, 03 May 2022 08:09:23 -0700 (PDT)
X-Received: by 2002:a05:600c:4e44:b0:394:46b4:7b0e with SMTP id
 e4-20020a05600c4e4400b0039446b47b0emr3671832wmq.29.1651590563205; Tue, 03 May
 2022 08:09:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220503042242.3597561-1-swboyd@chromium.org> <20220503042242.3597561-3-swboyd@chromium.org>
In-Reply-To: <20220503042242.3597561-3-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Tue, 3 May 2022 08:09:11 -0700
X-Gmail-Original-Message-ID: <CAD=FV=XDHwOeQOFevwH9rfd=UN9OcEoOS=HeydYnNAZMUdCaBQ@mail.gmail.com>
Message-ID: <CAD=FV=XDHwOeQOFevwH9rfd=UN9OcEoOS=HeydYnNAZMUdCaBQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] Input: cros-ec-keyb - skip keyboard registration
 w/o cros-ec-keyb compatible
To: Stephen Boyd <swboyd@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, chrome-platform@lists.linux.dev, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob Herring <robh+dt@kernel.org>, 
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, Benson Leung <bleung@chromium.org>, 
	Guenter Roeck <groeck@chromium.org>, Hsin-Yi Wang <hsinyi@chromium.org>, 
	"Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Mon, May 2, 2022 at 9:22 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> In commit 4352e23a7ff2 ("Input: cros-ec-keyb - only register keyboard if
> rows/columns exist") we skipped registration of the keyboard if the
> row/columns property didn't exist, but that has a slight problem for
> existing DTBs. The DTBs have the rows/columns properties, so removing
> the properties to indicate only switches exist makes this keyboard
> driver fail to probe, resulting in broken power and volume buttons. Ease
> the migration of existing DTBs by skipping keyboard registration if the
> google,cros-ec-keyb-switches compatible exists.
>
> The end result is that new DTBs can either choose to remove the matrix
> keymap properties or leave them in place and add this new compatible
> indicating the matrix keyboard properties should be ignored. Existing
> DTBs will continue to work, but they will keep registering the keyboard
> that does nothing. To fix that problem we can add this extra compatible
> to existing devicetrees and the keyboard will stop being registered.
> Finally, if google,cros-ec-keyb is missing then this driver won't even
> attempt to register the matrix keyboard. Of course, this driver won't
> probe until this patch is applied in that scenario, but that's OK. This
> last case is likely only going to be used by new devicetrees created
> after this commit.
>
> Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: <devicetree@vger.kernel.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Hsin-Yi Wang <hsinyi@chromium.org>
> Cc: "Joseph S. Barrera III" <joebar@chromium.org>
> Fixes: 4352e23a7ff2 ("Input: cros-ec-keyb - only register keyboard if rows/columns exist")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/input/keyboard/cros_ec_keyb.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
> index eef909e52e23..04c550aaf897 100644
> --- a/drivers/input/keyboard/cros_ec_keyb.c
> +++ b/drivers/input/keyboard/cros_ec_keyb.c
> @@ -536,14 +536,11 @@ static int cros_ec_keyb_register_matrix(struct cros_ec_keyb *ckdev)
>         u32 *physmap;
>         u32 key_pos;
>         unsigned int row, col, scancode, n_physmap;
> +       bool register_keyboard;
>
> -       /*
> -        * No rows and columns? There isn't a matrix but maybe there are
> -        * switches to register in cros_ec_keyb_register_bs() because
> -        * this is a detachable device.
> -        */
> -       if (!device_property_present(dev, "keypad,num-rows") &&
> -           !device_property_present(dev, "keypad,num-cols"))
> +       /* Skip matrix registration if no keyboard */
> +       register_keyboard = device_get_match_data(dev);
> +       if (!register_keyboard)
>                 return 0;

I'm a little on the fence about the local variable. It could have been
shorter as:

/* Skip matrix registration if no keyboard */
if (!device_get_match_data(dev))

...but I guess the "register_keyboard" maybe makes it more a little
more obvious?

In any case, I'm happy either way:

Reviewed-by: Douglas Anderson <dianders@chromium.org>
