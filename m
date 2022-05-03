Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669087F
	for <patches@lists.linux.dev>; Tue,  3 May 2022 01:06:54 +0000 (UTC)
Received: by mail-ej1-f51.google.com with SMTP id l18so30725103ejc.7
        for <patches@lists.linux.dev>; Mon, 02 May 2022 18:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+GS/UD7rTSn/SrbnLBVwvNdcnYAN1i32IbtuzZWmvMs=;
        b=GjPF8T0LFSfzHmDfzTyaQdTHc7/c7Au3dfdO9t7Jo7HNtVLIYTlK7boOyvbs8TaHWd
         u9Fc4NyJgxlRHYIObzxW3VHsk8uI5SiIRPIDVCqgNVN2nW1uFL7RyBgX5amGCEBX1Dqa
         wMPbnPQOsxEp8F4lvG7gMmlYdyq2+7Bca8HEw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+GS/UD7rTSn/SrbnLBVwvNdcnYAN1i32IbtuzZWmvMs=;
        b=mUJz9X116UJyGLXL0R5XnbvgHW4+GpYo/j/UojiEKj5t4lPAVyVmOHBPDTufK0hLim
         2bRtFyrx0aQ/WQRPGOUd4t2TmEF8CpebZ1GgWWR+rDDu/qM2wMxN/D8rx0X+X5SvHR3r
         m6Y7d4t3uxXrXhPTQFQHwbV2b8t3gIOw59F2moEnPWci2c6ozvqEGlppBm6FXndZ8pju
         p/JQKnARkFyt2lX7gLjfQBeEElbd1zaOZwf2Gmrpd4uL/sJ776e0sIWa6QHzUUNBjWd6
         zipF4aPIh9l+8ECX9pVDH0mZ1UacCqqfgsx1TQFmRnpyUjPh2lqRuiWFJaUWOBwg0Q6X
         pW9Q==
X-Gm-Message-State: AOAM530H6qaYdClNagmyFRtyQflRdcdrSRIYtECblJrdJ5BQ4owySynu
	SaYwu+7wg/9N1FeJ0QkuDtjxkV0Dzh2MuZeE
X-Google-Smtp-Source: ABdhPJzU4d6W7azZ1HbRFctif0LtSSBFA3SD2VvDn/CGU4WETbL8sb/xiZ1KDTEDxue07vUcnz3McA==
X-Received: by 2002:a17:907:6d87:b0:6f3:d7cd:7df6 with SMTP id sb7-20020a1709076d8700b006f3d7cd7df6mr13115477ejc.248.1651540012419;
        Mon, 02 May 2022 18:06:52 -0700 (PDT)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com. [209.85.221.50])
        by smtp.gmail.com with ESMTPSA id s8-20020aa7cb08000000b0042617ba638csm7195365edt.22.2022.05.02.18.06.51
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 May 2022 18:06:51 -0700 (PDT)
Received: by mail-wr1-f50.google.com with SMTP id x18so21526297wrc.0
        for <patches@lists.linux.dev>; Mon, 02 May 2022 18:06:51 -0700 (PDT)
X-Received: by 2002:a5d:6d09:0:b0:20c:53a9:cc30 with SMTP id
 e9-20020a5d6d09000000b0020c53a9cc30mr10094457wrq.513.1651540011049; Mon, 02
 May 2022 18:06:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220429233112.2851665-1-swboyd@chromium.org> <20220429233112.2851665-3-swboyd@chromium.org>
 <CAD=FV=WAbfe9BC5QPDezz3FSEwHRFdQeZpARJYT4b9V1rNp_nA@mail.gmail.com> <CAE-0n53x77n2ACuMYsFrdGhSkmO_4f8Uocnb+vKhcgoiY4RPQg@mail.gmail.com>
In-Reply-To: <CAE-0n53x77n2ACuMYsFrdGhSkmO_4f8Uocnb+vKhcgoiY4RPQg@mail.gmail.com>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 2 May 2022 18:06:39 -0700
X-Gmail-Original-Message-ID: <CAD=FV=W5SeUNAiQi_h8LyUn+7EQG1Sf9N6Nq9HtVnQWqr0Ltsw@mail.gmail.com>
Message-ID: <CAD=FV=W5SeUNAiQi_h8LyUn+7EQG1Sf9N6Nq9HtVnQWqr0Ltsw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] Input: cros-ec-keyb - skip keyboard registration
 for switches compatible
To: Stephen Boyd <swboyd@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, chrome-platform@lists.linux.dev, 
	Krzysztof Kozlowski <krzk@kernel.org>, Rob Herring <robh+dt@kernel.org>, 
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, Benson Leung <bleung@chromium.org>, 
	Guenter Roeck <groeck@chromium.org>, Hsin-Yi Wang <hsinyi@chromium.org>, 
	"Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Mon, May 2, 2022 at 3:02 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> Quoting Doug Anderson (2022-05-02 10:02:54)
> > On Fri, Apr 29, 2022 at 4:31 PM Stephen Boyd <swboyd@chromium.org> wrote:
> > >
> > >
> > > diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
> > > index eef909e52e23..1bbe2987bf52 100644
> > > --- a/drivers/input/keyboard/cros_ec_keyb.c
> > > +++ b/drivers/input/keyboard/cros_ec_keyb.c
> > > @@ -536,6 +536,12 @@ static int cros_ec_keyb_register_matrix(struct cros_ec_keyb *ckdev)
> > >         u32 *physmap;
> > >         u32 key_pos;
> > >         unsigned int row, col, scancode, n_physmap;
> > > +       bool register_keyboard;
> > > +
> > > +       /* Skip matrix registration if no keyboard */
> > > +       register_keyboard = device_get_match_data(dev);
> > > +       if (!register_keyboard)
> > > +               return 0;
> > >
> > >         /*
> > >          * No rows and columns? There isn't a matrix but maybe there are
> >
> > As per my comments in patch #1, I wonder if it makes sense to delete
> > the "No rows and columns?" logic and settle on the compatible as the
> > one true way to specify this.
> >
>
> Ok. My only concern is that means we have to check for both compatibles
> which is not really how DT compatible strings work. The compatible
> string usually finds the more specific compatible that is first in the
> list of compatibles in DT. You're essentially proposing that the
> switches compatible could be first or last, the order doesn't matter.

It's not quite what I was proposing. I think my summary really sums it up:

1. If you have a matrix keyboard and maybe also some buttons/switches
then use the compatible: google,cros-ec-keyb

2. If you only have buttons/switches but you want to be compatible
with the old driver in Linux that looked for the compatible
"google,cros-ec-keyb" and required the matrix properties, use the
compatible: "google,cros-ec-keyb-switches", "google,cros-ec-keyb"

3. If you have only buttons/switches and don't need compatibility with
old Linux drivers, use the compatible: "google,cros-ec-keyb-switches"

...but just to say it another way:

* If you have the compatible "google,cros-ec-keyb-switches" I mean to
say that you _only_ have switches and buttons. You'd _never_ have this
compatible string if you truly have a matrix keyboard. If you have
this, it will always be first.

* If you only have switches and buttons but you care about backward
compatibility then you can add a fallback compatible second:
"google,cros-ec-keyb"

* In order for the fallback compatible to be at all useful as a
fallback (it's only useful at all if you're on an old driver), if you
specify it you should pretend that you have matrix properties even
though you don't really have them, just like we used to do.

-Doug
