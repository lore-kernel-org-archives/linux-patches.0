Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6F91383
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 18:26:38 +0000 (UTC)
Received: by mail-yb1-f172.google.com with SMTP id x200so32528737ybe.13
        for <patches@lists.linux.dev>; Tue, 19 Apr 2022 11:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1mruETChJ0+tCEUKHTvZNud81HPLW0aPJc6Xrf5tnGg=;
        b=DsydkwpauFoZTteJsIEF/bGMn90fgQ9Nl47j1EELbxIjezLoZaBSF1/6UiUAJ0xmTZ
         /rj1G5jk60dBo4UVM2DgPIR6Vvan/PqzmeB6xOVwQeeE8PYz2WtSq1McY6N65diPpefa
         nAXHC1F8wbCTiYkwaIc8RZnhHY25UEX7C0bnrr/xJ95MNOXRvlc0YXBKz0duc1XPV+dW
         44AkXitfLvlHw2fzAtfAmQe+hCRMaIfProSkZ1Ok1LmTPwUfIZwFjyenRj6afmw4QjFs
         QE2OTQDnzWvTe1fb7XOp93EUJvVWXPYnf62b/6t+FzTu61oqhNT2ln41XNrxF0swOiHJ
         bP1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1mruETChJ0+tCEUKHTvZNud81HPLW0aPJc6Xrf5tnGg=;
        b=PFkkEE2DBYnDfa8vT81s6j7oM5BhG+V5ViTfe9grmEbW5p94gd5HBw1zpp/2r21B0Q
         7uNIzj+gg1FgNwlx9O+12SM5o6T00/hWyiEHkZGuVtmmH8yQ60quiIJmIunFtuQ+XntP
         F5AkluEIDDbialvcvRX7emOa1LdHM6B5eIWaL0y9kZmOngEUzgpn+CBf1VNTW2OyRkSz
         zlD45kwqi7KXkzt+JJ7KS6dbWOSmbnKHlUbc1alJvVgZPw+B2kszoC0F17jq3XiLVghY
         HepbpMyLo1N18SdbY5dmJ0BKL630RqZ658Uql9WKG0xof2cNYumZODsS8NVUiaObdwFi
         OHDA==
X-Gm-Message-State: AOAM5330BH4k4a4/IRr1YbKHDyYcRFUUl+32YuorG8zaqO3S0xXpQ6cc
	KwvmecGTK4RmGo4R2ax/ogTfv9wBo6TqIzA4lpAJeg==
X-Google-Smtp-Source: ABdhPJwIvBSWGeaTpciFQdI7H/y4cHsr0V/oV6NhWT9Ndt5EVDGgE7d9NetVo5AN6D6ckF93iOwY98PK6jBB0w1E5J0=
X-Received: by 2002:a25:d08a:0:b0:641:daac:ff82 with SMTP id
 h132-20020a25d08a000000b00641daacff82mr16009141ybg.643.1650392797011; Tue, 19
 Apr 2022 11:26:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220419000408.3202635-1-swboyd@chromium.org> <Yl4Au/O/am/ZbX9J@chromium.org>
 <CAE-0n507D9W5BFfG2vXqN1cqvnrQKLbLw7YejGb5_kH+7X62sw@mail.gmail.com> <CACeCKac83uiwdAf2RWqc9DxEft2+BSBn5Kp5PMR23UGKJyk5KQ@mail.gmail.com>
In-Reply-To: <CACeCKac83uiwdAf2RWqc9DxEft2+BSBn5Kp5PMR23UGKJyk5KQ@mail.gmail.com>
From: Daisuke Nojiri <dnojiri@google.com>
Date: Tue, 19 Apr 2022 11:26:25 -0700
Message-ID: <CAC0y+Ajf2GTG=ir=gu9T5Q1TXBHMC5qzzA_MEzWAvW5D71Yv8g@mail.gmail.com>
Subject: Re: [PATCH v2] mfd: cros_ec_dev: Only register PCHG device if present
To: Prashant Malani <pmalani@chromium.org>
Cc: Stephen Boyd <swboyd@chromium.org>, Lee Jones <lee.jones@linaro.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	Tzung-Bi Shih <tzungbi@kernel.org>, Daisuke Nojiri <dnojiri@chromium.org>, 
	Benson Leung <bleung@chromium.org>, Guenter Roeck <groeck@chromium.org>, 
	chrome-platform@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

The patch v2 looks good to me.


On Tue, Apr 19, 2022 at 7:59 AM Prashant Malani <pmalani@chromium.org> wrote:
>
> On Tue, Apr 19, 2022 at 7:55 AM Stephen Boyd <swboyd@chromium.org> wrote:
> >
> > Quoting Prashant Malani (2022-04-18 17:22:19)
> > > On Apr 18 17:04, Stephen Boyd wrote:
> > > > +             retval = mfd_add_hotplug_devices(ec->dev,
> > > > +                                     cros_ec_pchg_cells,
> > > > +                                     ARRAY_SIZE(cros_ec_pchg_cells));
> > > > +             if (retval)
> > > > +                     dev_warn(ec->dev, "failed to add pchg: %d\n",
> > > > +                              retval);
> > > Tiny nit: Can this fit in 1 line (100 chars[1])?
> > >
> >
> > I'm matching the style of other lines in this file (this is copy
> > pasta). I'll let the maintainer decide what to do.
>
> Quite a bit of that code predates the char limit update, but OK.
