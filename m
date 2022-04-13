Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4022F23
	for <patches@lists.linux.dev>; Wed, 13 Apr 2022 20:44:29 +0000 (UTC)
Received: by mail-ed1-f42.google.com with SMTP id b15so3888236edn.4
        for <patches@lists.linux.dev>; Wed, 13 Apr 2022 13:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9t746E0a3Zsh93FlmUmusMHEf6L1/F6+kRTi3ZPWd3U=;
        b=NpPyUcrQ7ZOjuUtydpO0p2toOxFON7X+5zw1Y63SEiUiNqQ4gztOMnnPJOXGMzYTSC
         5rYy7JDvRCd8Y15GeAIxAzAfXIgI7S33JA/ZAmDD9vgR0zHszTSDxGCrQWWaXRl9v8ue
         GqUiGQHi4etpqlM/9j3h0Rn+mq48g3srPc1X8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9t746E0a3Zsh93FlmUmusMHEf6L1/F6+kRTi3ZPWd3U=;
        b=XAZzd3oKaAmerHQoQAzr1uObThIHtsFy1ZOGfceirmbuj0wK5K884T81C3oED4asTw
         biIO9/Lsbgpvq8+aIiFf7wFu26mfsQTi5g4mpXYHuDe2GO2GEsCp6bi77oLC8JA2qGkC
         U4t9PR1xWTO7+RPxVvYwN9L6uUrYUtq63dQT2Sl/zxCg53jAA8YGUOPR0ph7mSDFmaaR
         OVCgJN08ZI4wNM2YGBfnF5pLK2xrlz8AY/8KYSKpKkvHgy4DAqKr0oi5SGXgIxrm6FDD
         nL60YYKlRRHAaIfWgxW8lNh7ZXngJ4U3q9l8ghuB3dgcbzQ4q+iasuzN+xf+tkeCP90D
         hycQ==
X-Gm-Message-State: AOAM533vRShkQQWRy9GTKvFePS40nCSElm27M9vBp5fCcKxhG5svnb1X
	T64H2Z0tSpRyOIHVbWmQ2M393SHp6jZ3Dg==
X-Google-Smtp-Source: ABdhPJyb8gEhCZE82omUkXC5hsmlIZbfLiKrwTefRuQrtWTFk1m+qeGVjg0w4mHum6umV9PCLYAD9w==
X-Received: by 2002:aa7:d904:0:b0:41d:728c:6cf1 with SMTP id a4-20020aa7d904000000b0041d728c6cf1mr21313524edr.366.1649882666611;
        Wed, 13 Apr 2022 13:44:26 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id g9-20020aa7c849000000b00412fc6bf26dsm1650392edt.80.2022.04.13.13.44.25
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 13:44:25 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id r13so4278745wrr.9
        for <patches@lists.linux.dev>; Wed, 13 Apr 2022 13:44:25 -0700 (PDT)
X-Received: by 2002:adf:c14d:0:b0:207:a28f:f5dd with SMTP id
 w13-20020adfc14d000000b00207a28ff5ddmr420309wre.679.1649882664627; Wed, 13
 Apr 2022 13:44:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220413033334.1514008-1-swboyd@chromium.org> <20220413033334.1514008-2-swboyd@chromium.org>
In-Reply-To: <20220413033334.1514008-2-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Wed, 13 Apr 2022 13:44:12 -0700
X-Gmail-Original-Message-ID: <CAD=FV=Ux8AmWpsphRL2waUSrp_Vioykn5WTui4UpzsGLr4fdcA@mail.gmail.com>
Message-ID: <CAD=FV=Ux8AmWpsphRL2waUSrp_Vioykn5WTui4UpzsGLr4fdcA@mail.gmail.com>
Subject: Re: [PATCH 1/2] Input: cros-ec-keyb: Only register keyboard if
 rows/columns exist
To: Stephen Boyd <swboyd@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, 
	"open list:HID CORE LAYER" <linux-input@vger.kernel.org>, chrome-platform@lists.linux.dev, 
	Benson Leung <bleung@chromium.org>, Guenter Roeck <groeck@chromium.org>, 
	Hsin-Yi Wang <hsinyi@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Tue, Apr 12, 2022 at 8:33 PM Stephen Boyd <swboyd@chromium.org> wrote:
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
> I tried to use mkbp info to query the number of rows and columns, but my
> EC firmware doesn't have commit 8505881ed0b9 ("mkbp: Separate MKBP_INFO
> host command from the keyboard driver") so it always returns 8 and 13
> for the rows and columns. Sigh. With updated firmware we could query it,
> or we could rely on DT like we do already.
>
> Originally I was setting the properties to 0, but
> matrix_keypad_parse_properties() spits out an error message in that case
> and so it seems better to delete the properties and check for their
> existence instead. Another alternative would be to change the compatible
> to be "google,cros-ec-keyb-switches" or something that indicates there
> are only switches and no matrix keyboard.
>
>  drivers/input/keyboard/cros_ec_keyb.c | 9 +++++++++
>  1 file changed, 9 insertions(+)

I do wonder if there will be any unintentional side effects here.
Specifically, even though there is truly no keyboard here, I wonder if
anything in the system is relying on the EC to simulate keypresses
even on tablets where the keyboard isn't actually there...

OK, I guess not. While I think it _used_ to be the case that you could
simulate keyboard inputs from the EC console even for devices w/out a
keyboard, it doesn't seem to be the case anymore. I just tried it and
nothing made it through to the AP.

Seems reasonable to me:

Reviewed-by: Douglas Anderson <dianders@chromium.org>
