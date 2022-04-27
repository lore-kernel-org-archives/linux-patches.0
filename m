Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCAB7B
	for <patches@lists.linux.dev>; Wed, 27 Apr 2022 15:10:16 +0000 (UTC)
Received: by mail-ed1-f48.google.com with SMTP id be20so2283317edb.12
        for <patches@lists.linux.dev>; Wed, 27 Apr 2022 08:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8bcBCHuka1c7eUCHaJJ1Tf0YnngjHSBeBCkk7aucJRc=;
        b=Bha64TEobiweIEID7s+302mbO83FZsNFeG4G9pC1hn4DLldhg2boTtAWRnZIW4hMUF
         tEcxiUcYoQYdX1hA3zzB/izxzVa9EYpvkdFybz8Yc5m2SSrZZfsI3qdXkKCDux6UJORd
         nTkuWxGNRe424v5bdabJpziKRa/X0pZvUGGqY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8bcBCHuka1c7eUCHaJJ1Tf0YnngjHSBeBCkk7aucJRc=;
        b=azpBiUeAUHxJmxxnpe+JJGo/YZSQ7P7q9W7ccCnkD9Ckl6lwJoM+1elcrjTD2W9nSk
         BQ9acLCDLwDtv9d7I/FYJ+1yTzPaFX54unkLjjO2KpGkt135yUY3x4WKclqQBrOmvuY7
         cpNIIA0mH0pEapsYQoAH4TJjS8YfH3Xdh7ffD1PlFqMfPpm10cXQm+/EIvnvwJnwVunP
         7y/MZCP+1wRMofKfuEeTVDbtZaUTRqZ0HcK2/JPcuIzWRZeaSqmx9dwc+Q97l2MgjYj3
         pzaew1M0Zhj3o/4MEQfwzQroDSrtc4JwUMh97MJ3fAUJpsmLRXcapv3oZXb1+dlFj3No
         RkSg==
X-Gm-Message-State: AOAM532P6DQYXqoewItNCZ1OPxQHmfH2FRnhk8D6jgfyaUuBbR9ddRsr
	NhsYS1MHn3Is6SI3DnDsAa0wuC9TQVqQqrdVgNo=
X-Google-Smtp-Source: ABdhPJw4zdIi8f7Igvz70MXEdcX7uoKIDqk/RJATGsES1eTLjL5lRMqRwL3ssYO3APiAahBRooFoaA==
X-Received: by 2002:a05:6402:270b:b0:424:7dd:9d7b with SMTP id y11-20020a056402270b00b0042407dd9d7bmr30706627edd.92.1651072214244;
        Wed, 27 Apr 2022 08:10:14 -0700 (PDT)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com. [209.85.128.42])
        by smtp.gmail.com with ESMTPSA id kw6-20020a170907770600b006f3cfb1d53dsm900267ejc.137.2022.04.27.08.10.12
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 08:10:12 -0700 (PDT)
Received: by mail-wm1-f42.google.com with SMTP id n32-20020a05600c3ba000b00393ea7192faso1386573wms.2
        for <patches@lists.linux.dev>; Wed, 27 Apr 2022 08:10:12 -0700 (PDT)
X-Received: by 2002:a05:600c:502b:b0:38f:f7c6:3609 with SMTP id
 n43-20020a05600c502b00b0038ff7c63609mr26785973wmr.15.1651072211589; Wed, 27
 Apr 2022 08:10:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220426225748.324759-1-swboyd@chromium.org> <CAD=FV=WMf0Jc9oD7CGoLthguzt2aV31sZmFoenbjn72MfwFYEA@mail.gmail.com>
In-Reply-To: <CAD=FV=WMf0Jc9oD7CGoLthguzt2aV31sZmFoenbjn72MfwFYEA@mail.gmail.com>
From: Doug Anderson <dianders@chromium.org>
Date: Wed, 27 Apr 2022 08:09:59 -0700
X-Gmail-Original-Message-ID: <CAD=FV=Wey2P_=3Lp6M8GEaoyCn1XcYFhfJwfx43a5f_8H0obwg@mail.gmail.com>
Message-ID: <CAD=FV=Wey2P_=3Lp6M8GEaoyCn1XcYFhfJwfx43a5f_8H0obwg@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: qcom: sc7180-trogdor: Remove cros-ec keyboard
 from detachables
To: Stephen Boyd <swboyd@chromium.org>
Cc: Andy Gross <agross@kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, 
	LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	linux-arm-msm <linux-arm-msm@vger.kernel.org>, Benson Leung <bleung@chromium.org>, 
	Guenter Roeck <groeck@chromium.org>, Hsin-Yi Wang <hsinyi@chromium.org>, 
	"Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Tue, Apr 26, 2022 at 5:17 PM Doug Anderson <dianders@chromium.org> wrote:
>
> Hi,
>
> On Tue, Apr 26, 2022 at 3:57 PM Stephen Boyd <swboyd@chromium.org> wrote:
> >
> > Trogdor devices that have a detachable keyboard still have a
> > non-detachable keyboard input device present because we include the
> > cros-ec-keyboard.dtsi snippet in the top-level sc7180-trogdor.dtsi file
> > that every variant board includes. We do this because the
> > keyboard-controller node also provides some buttons like the power
> > button and volume buttons. Unfortunately, this means we register a
> > keyboard input device that doesn't do anything on boards with a
> > detachable keyboard. Let's delete the rows/columns properties of the
> > device node to indicate that there isn't a matrix keyboard on these
> > boards.
> >
> > Cc: Benson Leung <bleung@chromium.org>
> > Cc: Guenter Roeck <groeck@chromium.org>
> > Cc: Douglas Anderson <dianders@chromium.org>
> > Cc: Hsin-Yi Wang <hsinyi@chromium.org>
> > Cc: "Joseph S. Barrera III" <joebar@chromium.org>
> > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > ---
> >  arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi   | 5 +++++
> >  arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi | 5 +++++
> >  2 files changed, 10 insertions(+)
>
> Presumably we need to do this same thing for wormdingler [1]
>
> [1] https://lore.kernel.org/r/20220426151204.1.Id2821de5fde55ebe928e8fc87a71c8d535edb383@changeid
>
> Reviewed-by: Douglas Anderson <dianders@chromium.org>

Do we need to delay landing this patch for a release? I haven't tested
myself, but from re-reading through the code it looks as if
cros_ec_keyb_register_matrix() will return an error code if we have
the device tree patch _without_ commit 4352e23a7ff2 ("Input:
cros-ec-keyb - only register keyboard if rows/columns exist"). That
will cause it to skip registering the buttons/switches, right?

-Doug
