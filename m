Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D36233D3
	for <patches@lists.linux.dev>; Tue,  3 May 2022 19:43:34 +0000 (UTC)
Received: by mail-lj1-f175.google.com with SMTP id 17so23313416lji.1
        for <patches@lists.linux.dev>; Tue, 03 May 2022 12:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=84DT2KN71CBoOLaIwfBUH1VIJvywBdMYoVKhebNA7Z0=;
        b=e+2jsHN+LGeoxthUIsOCFTpN/YQD1tLtP5DXh+qPTs7i1ROxuVi1Ik9l9Le5Ad3BEw
         ZkY+XGJkfzyXZtHOt4X3XeSMKy0RejAPjrlNsBVyynuEh4IpJav8ULo1pZO0q7fmC7NW
         5PlZapfM2xTIY/rc03QCq+CdtM6iTB0VRcVwk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=84DT2KN71CBoOLaIwfBUH1VIJvywBdMYoVKhebNA7Z0=;
        b=7fqCxNtFfYyMyyRwQgCnrFdCDccfPRCrlxsjnLR/qU0HXaKdKBowsCVOYziOrMQZ1d
         md78blWJ42DT3tJecfCkCSu+BFdIs+rkpCeaU/dqFs2kVfo9MAWZg4dEQpBfQ3L4Jjwn
         +Vioq503P8Bs7z2rzu3Vl3monGAvrZ3Q+aiizUjSV0Fqq1j70WsPNu4I4daaKTyTkLjT
         AvtwXSfolRG5BZfYgMRvZwEY6ek4yvFy6FeAGriFo3+gDj/dCSB1OZKvjQATxWDBNUsB
         CDD4/Bht1/ehYM5bRv2roK+aTjeP1CHp6RoRW72DQlgCj3H+bV/x8ZzEdfJ2nxxudAJI
         gw6A==
X-Gm-Message-State: AOAM530h9Vyt1KkNlBCRyGEpR55/8NhMXMT92krGoRBkL7V/nWz/jecH
	vqzYqZqVLP8H9iet0zSWpEaPKr152VJA11sW62MglQ==
X-Google-Smtp-Source: ABdhPJwofoBZ0cGQf5xDbeKBgy5o15kRXzCpmBtVOrHD+O0xJDWsEHSnPVpB62ILYjRFVJ/hKSbrJaoKEAfPlO5SpbU=
X-Received: by 2002:a2e:b8c2:0:b0:250:61c6:8398 with SMTP id
 s2-20020a2eb8c2000000b0025061c68398mr4466282ljp.378.1651607012174; Tue, 03
 May 2022 12:43:32 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 3 May 2022 12:43:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAD=FV=XDHwOeQOFevwH9rfd=UN9OcEoOS=HeydYnNAZMUdCaBQ@mail.gmail.com>
References: <20220503042242.3597561-1-swboyd@chromium.org> <20220503042242.3597561-3-swboyd@chromium.org>
 <CAD=FV=XDHwOeQOFevwH9rfd=UN9OcEoOS=HeydYnNAZMUdCaBQ@mail.gmail.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 3 May 2022 12:43:31 -0700
Message-ID: <CAE-0n52xsyFPKiFufS=+S5QMqYoLN=2MOZHWJ7E9orJyCs3=ig@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] Input: cros-ec-keyb - skip keyboard registration
 w/o cros-ec-keyb compatible
To: Doug Anderson <dianders@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, chrome-platform@lists.linux.dev, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org, 
	Benson Leung <bleung@chromium.org>, Guenter Roeck <groeck@chromium.org>, 
	Hsin-Yi Wang <hsinyi@chromium.org>, "Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Doug Anderson (2022-05-03 08:09:11)
> On Mon, May 2, 2022 at 9:22 PM Stephen Boyd <swboyd@chromium.org> wrote:
> >
> > diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
> > index eef909e52e23..04c550aaf897 100644
> > --- a/drivers/input/keyboard/cros_ec_keyb.c
> > +++ b/drivers/input/keyboard/cros_ec_keyb.c
> > @@ -536,14 +536,11 @@ static int cros_ec_keyb_register_matrix(struct cros_ec_keyb *ckdev)
> >         u32 *physmap;
> >         u32 key_pos;
> >         unsigned int row, col, scancode, n_physmap;
> > +       bool register_keyboard;
> >
> > -       /*
> > -        * No rows and columns? There isn't a matrix but maybe there are
> > -        * switches to register in cros_ec_keyb_register_bs() because
> > -        * this is a detachable device.
> > -        */
> > -       if (!device_property_present(dev, "keypad,num-rows") &&
> > -           !device_property_present(dev, "keypad,num-cols"))
> > +       /* Skip matrix registration if no keyboard */
> > +       register_keyboard = device_get_match_data(dev);
> > +       if (!register_keyboard)
> >                 return 0;
>
> I'm a little on the fence about the local variable. It could have been
> shorter as:
>
> /* Skip matrix registration if no keyboard */
> if (!device_get_match_data(dev))
>
> ...but I guess the "register_keyboard" maybe makes it more a little
> more obvious?

Yes, the idea is to make it more obvious to the point that the comment
isn't needed. I'll change it to 'has_keyboard' and then drop the
comment!

>
> In any case, I'm happy either way:
>
> Reviewed-by: Douglas Anderson <dianders@chromium.org>
