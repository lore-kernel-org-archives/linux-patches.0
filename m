Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B417F
	for <patches@lists.linux.dev>; Tue,  3 May 2022 01:10:00 +0000 (UTC)
Received: by mail-ej1-f54.google.com with SMTP id dk23so30768110ejb.8
        for <patches@lists.linux.dev>; Mon, 02 May 2022 18:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Koda+Kmf6rnMD/zj5Q4WlT42MyjML9+QDJTCHNl5ArY=;
        b=lgXpaChoki38r237kEaHScwsef9q+RhL9t3q/EGcsmq1Nle+XST7WCWWkEQI2W7Gh9
         a875yHgmv5a6UmRrnyGQVo4tIqR3NhkEXHqcM2BwsVfgljT+5wsxZkJ4vDidcBmIQASp
         82E10En8ezVJwvZkCDTTdq1Pn4Hq0PqwzS+9g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Koda+Kmf6rnMD/zj5Q4WlT42MyjML9+QDJTCHNl5ArY=;
        b=HAPQlBbhXgGF+D8jkDWpA8kxPeaApoYWUY/3LqMKOpQxo5e5qPArpNDyo5he86KZxi
         G5ghqe291cC/0GNcTmziuBDiiEpyMMPMU30UyVcbkZ9hQ46X59EOzamFmM1z2sTLJQQk
         MIEiXRiLxxPLQKJG63WZ6SZMUykFD4tkSK0excViuTJuCeGcMr8Wi5gHVNKAzU7ROPLS
         2UdXxE5eo+DubT/OGsJDCGvQ6A/hrM6yUdKjJq1RQi0XuJTpcJlzy6ujltRwwEpYKXwZ
         4f2AM7+FtutgbwiDyxuG1qbt3aU0NPPS1rvztptOqxNaOMV+3QjlgVdoweY3CROzIZLv
         u//g==
X-Gm-Message-State: AOAM531dwXAzqideZLPdUo1ViTRd0XrNThry1N1yrI/rb/nG5MEjaRA4
	i8Jql2a1TFSKeqfTi42toojQ6Rfk642yzzR1
X-Google-Smtp-Source: ABdhPJzC0DlCL2+xY86Ti7Euq6uWny5pPalfSIr0G1PKb5gKUzxH1B6CvJm2GkjpO45Lh3oDSUEGwQ==
X-Received: by 2002:a17:907:9720:b0:6f4:31d4:925f with SMTP id jg32-20020a170907972000b006f431d4925fmr9294530ejc.658.1651540198717;
        Mon, 02 May 2022 18:09:58 -0700 (PDT)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com. [209.85.128.41])
        by smtp.gmail.com with ESMTPSA id x42-20020a50baad000000b00426cae11e63sm4056212ede.43.2022.05.02.18.09.57
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 May 2022 18:09:57 -0700 (PDT)
Received: by mail-wm1-f41.google.com with SMTP id m2-20020a1ca302000000b003943bc63f98so469172wme.4
        for <patches@lists.linux.dev>; Mon, 02 May 2022 18:09:57 -0700 (PDT)
X-Received: by 2002:a05:600c:4f08:b0:391:fe3c:40e6 with SMTP id
 l8-20020a05600c4f0800b00391fe3c40e6mr1254978wmq.34.1651540197013; Mon, 02 May
 2022 18:09:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220429233112.2851665-1-swboyd@chromium.org> <20220429233112.2851665-2-swboyd@chromium.org>
 <CAD=FV=VX8EEgkeLgKwyKvjztcjbA8UhKOUpTr-sS1_Ec=QcWbA@mail.gmail.com>
 <CAKdAkRSOtAD6u_cwKhHeMLgz5dC2hfPvVvqmj+17b4i-nspfgg@mail.gmail.com> <CAE-0n50Y8tZD9Djn9TVaAiHxehFJ2cZKZ1Z09piDk47uw3nK+Q@mail.gmail.com>
In-Reply-To: <CAE-0n50Y8tZD9Djn9TVaAiHxehFJ2cZKZ1Z09piDk47uw3nK+Q@mail.gmail.com>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 2 May 2022 18:09:45 -0700
X-Gmail-Original-Message-ID: <CAD=FV=U4O397gN7+dMF5gQmdtq59S1TTC-GiSiCDenrSzdpFQg@mail.gmail.com>
Message-ID: <CAD=FV=U4O397gN7+dMF5gQmdtq59S1TTC-GiSiCDenrSzdpFQg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: google,cros-ec-keyb: Introduce
 switches only compatible
To: Stephen Boyd <swboyd@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, chrome-platform@lists.linux.dev, 
	Krzysztof Kozlowski <krzk@kernel.org>, Rob Herring <robh+dt@kernel.org>, 
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, Benson Leung <bleung@chromium.org>, 
	Guenter Roeck <groeck@chromium.org>, Hsin-Yi Wang <hsinyi@chromium.org>, 
	"Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Mon, May 2, 2022 at 1:41 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> Quoting Dmitry Torokhov (2022-05-02 10:43:06)
> > On Mon, May 2, 2022 at 10:00 AM Doug Anderson <dianders@chromium.org> wrote:
> > >
> > > That goes against the recently landed commit 4352e23a7ff2 ("Input:
> > > cros-ec-keyb - only register keyboard if rows/columns exist") but
> > > perhaps we should just _undo_ that that since it landed pretty
> > > recently and say that the truly supported way to specify that you only
> > > have keyboards/switches is with the compatible.
> > >
> > > What do you think?
> >
> > I am sorry, I am still confused on what exactly we are trying to solve
> > here? Having a device with the new device tree somehow run an older
> > kernel and fail? Why exactly do we care about this case?
>
> Yes, we're trying to solve the problem where a new device tree is used
> with an older kernel because it doesn't have the driver patch to only
> create an input device for the matrix when rows/columns properties are
> present. Otherwise applying that devicetree patch to an older kernel
> will break bisection.

I mean, we can also just say that we don't care about breaking
bisections and just say that the solution we already landed is fine.
It would certainly be less work at this point.

>
> > We have
> > implemented the notion that without rows/columns properties we will
> > not be creating input device for the matrix portion, all older devices
> > should have it defined, so the newer driver is compatible with them...
> >
>
> Agreed, that solves half the problem. This new compatible eases
> integration so that devicetrees can say they're compatible with the old
> binding that _requires_ the rows/column properties. By making the driver
> change we loosened that requirement, but the binding should have been
> making the properties required at the start because it fails to bind
> otherwise.
>
> My interpretation of what Doug is saying is that we should maintain that
> requirement that rows/columns exists if the original compatible
> google,cros-ec-keyb is present and use the new compatible to indicate
> that there are switches. Combining the two compatibles means there's
> switches and a matrix keyboard, having only the switches compatible
> means only switches, and having only the keyboard compatible means only
> matrix keyboard.

That's not quite what I was saying. See my response to patch #2.
