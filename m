Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C208A3220
	for <patches@lists.linux.dev>; Mon,  2 May 2022 22:02:20 +0000 (UTC)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-e2442907a1so15590075fac.8
        for <patches@lists.linux.dev>; Mon, 02 May 2022 15:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=DVGl7FkDnsPKOHoFcMwejH9+UyHbejyve2Ejii4IrCM=;
        b=I/045iRJlecCmWvj4tuUqOFvKpEZtT7cA11HAymgVZw3gEMruV1NZCIRvMymbscBeU
         dEht4NLFVxHkpjemr8/2TfL+kpJYJCZ/mOJFXkrSEyLvNv5ad/bKDKESNL8CtWHitgxT
         dMQp7ewk/SoaMMUwrO7Dk03tZsaGBDSALyKwg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=DVGl7FkDnsPKOHoFcMwejH9+UyHbejyve2Ejii4IrCM=;
        b=ypuym8cMAq9sztZF+TDcHVVcsae31w/E/HgiML1lF1pgYcwDU0hpWX09UT9dVxF4ze
         7arC5iAYxcBtbX3zSCiK/fGJnIgoAnrLXzbZAEwD0mHxi1dXgKIRpg7DLd3Tqf1qUtX2
         4gVSP2N6hatLECBTaxZ0OtmPSlKcr4ZhchCtBrghSFIIGbMn0zmou/n/8z8SYqnF3qEF
         0PYDhZEATjeBkdSvEEYkXNPlj6ufDPjPfQYA7NzvBKo7jLBrfOzmgcWzG9oJb7osuGTT
         LJlSk19VFfCSdzfmtndsakgBmJ8Gc9He8MChuShOYpWJewCPrDKEGaQb9qno6VvO4DTq
         xUtA==
X-Gm-Message-State: AOAM5301Z96rrRBApO34JYGywPAP3ovWICVx77xqb/M4tUgVl/Gk6YPm
	YjU+yoikQFJoc+u6gjd19QuawJfCOk4CVspojKSDNw==
X-Google-Smtp-Source: ABdhPJwTpGO9NuC3l5i+OXoQ4kkKceH1oe/oVVNRdXmv8vDT0lPCWjoekl6+gdZaRBMEUORDvFwfxSO+k5mjMswTPT8=
X-Received: by 2002:a05:6870:40c1:b0:ed:9a12:3f95 with SMTP id
 l1-20020a05687040c100b000ed9a123f95mr525995oal.193.1651528939865; Mon, 02 May
 2022 15:02:19 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 2 May 2022 15:02:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAD=FV=WAbfe9BC5QPDezz3FSEwHRFdQeZpARJYT4b9V1rNp_nA@mail.gmail.com>
References: <20220429233112.2851665-1-swboyd@chromium.org> <20220429233112.2851665-3-swboyd@chromium.org>
 <CAD=FV=WAbfe9BC5QPDezz3FSEwHRFdQeZpARJYT4b9V1rNp_nA@mail.gmail.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Mon, 2 May 2022 15:02:19 -0700
Message-ID: <CAE-0n53x77n2ACuMYsFrdGhSkmO_4f8Uocnb+vKhcgoiY4RPQg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] Input: cros-ec-keyb - skip keyboard registration
 for switches compatible
To: Doug Anderson <dianders@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, chrome-platform@lists.linux.dev, 
	Krzysztof Kozlowski <krzk@kernel.org>, Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org, 
	Benson Leung <bleung@chromium.org>, Guenter Roeck <groeck@chromium.org>, 
	Hsin-Yi Wang <hsinyi@chromium.org>, "Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Doug Anderson (2022-05-02 10:02:54)
> On Fri, Apr 29, 2022 at 4:31 PM Stephen Boyd <swboyd@chromium.org> wrote:
> >
> >
> > diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
> > index eef909e52e23..1bbe2987bf52 100644
> > --- a/drivers/input/keyboard/cros_ec_keyb.c
> > +++ b/drivers/input/keyboard/cros_ec_keyb.c
> > @@ -536,6 +536,12 @@ static int cros_ec_keyb_register_matrix(struct cros_ec_keyb *ckdev)
> >         u32 *physmap;
> >         u32 key_pos;
> >         unsigned int row, col, scancode, n_physmap;
> > +       bool register_keyboard;
> > +
> > +       /* Skip matrix registration if no keyboard */
> > +       register_keyboard = device_get_match_data(dev);
> > +       if (!register_keyboard)
> > +               return 0;
> >
> >         /*
> >          * No rows and columns? There isn't a matrix but maybe there are
>
> As per my comments in patch #1, I wonder if it makes sense to delete
> the "No rows and columns?" logic and settle on the compatible as the
> one true way to specify this.
>

Ok. My only concern is that means we have to check for both compatibles
which is not really how DT compatible strings work. The compatible
string usually finds the more specific compatible that is first in the
list of compatibles in DT. You're essentially proposing that the
switches compatible could be first or last, the order doesn't matter.

If that isn't a problem then we can roll in a revert of commit
4352e23a7ff2 ("Input: cros-ec-keyb - only register keyboard if
rows/columns exist") and leave the rest of this patch alone and it will
implement this logic.
