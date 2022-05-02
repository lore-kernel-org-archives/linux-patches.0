Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232AD2F56
	for <patches@lists.linux.dev>; Mon,  2 May 2022 20:41:35 +0000 (UTC)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-e5e433d66dso15401663fac.5
        for <patches@lists.linux.dev>; Mon, 02 May 2022 13:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=5nZPdRykT2oZRCTZ5O2rt6kJua5fF29iVxfAJZw56cY=;
        b=IVSPJE8ihIwDhFvrO3rD/jlL576xKDMi1eeWJpOWO+uD1Chq3c6LomeI+6Y97J0GXf
         McHPD0X8Z6YIdPZHS+ll4UY0nTV9J7KkKAXVGj3QZqqZDN5iRnSYigtC0+HincclG/Nl
         5iXv+woyo6jyXItZeODYewOTDV6xTvdx6lUvI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=5nZPdRykT2oZRCTZ5O2rt6kJua5fF29iVxfAJZw56cY=;
        b=pEEW6+ErFQ8e7Rrb1buxYZM+jDzRnRec2PzKGfIvLNkieJed/ENU1Jxt6RLPniIZeZ
         jKLZmiZHZQtjEsv1+eR84CdiN8/1r8iwGOEUmjPxGx5qjjqeAVEKpMGteW/5A5a25GO5
         ys6VQ3z0Ineh423Hz5XbhBex9GY2YCgUUasJEy7voRl2eFW1lmVbHjD0vSS+kaL7D3ti
         5gxbSd19UjOp3bC6WJfcTmCpgPm89Kt/fXTY7OtCQAeO0YiZvRZ8hg3d/0iak9rP44Mz
         gmSuN9PBpzo+CxpmN58gnCmNmPKhsYOtq4t7kuhDdtJtRjkRrxcIOiH3hcZZ6AJy2Agr
         GkQQ==
X-Gm-Message-State: AOAM5301/DI6ntp5IGZknSfZ3FBE0VtcOiOOO/SH4iK6KD7QAus5RaBD
	r3lEgP2Yk4ArkKz2j5+Un+aT8Ab/2eM6S8CSu/NzGQ==
X-Google-Smtp-Source: ABdhPJyd5YZyYiV85jF46KiUVsb/Thob1XWuV7zGasXe6BmSZSN+mOfhQo4EE3YWKhZZ87emmrDAqRHtcbf+3zJohD8=
X-Received: by 2002:a05:6870:558e:b0:e1:db7c:26aa with SMTP id
 n14-20020a056870558e00b000e1db7c26aamr440556oao.63.1651524094100; Mon, 02 May
 2022 13:41:34 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 2 May 2022 13:41:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAKdAkRSOtAD6u_cwKhHeMLgz5dC2hfPvVvqmj+17b4i-nspfgg@mail.gmail.com>
References: <20220429233112.2851665-1-swboyd@chromium.org> <20220429233112.2851665-2-swboyd@chromium.org>
 <CAD=FV=VX8EEgkeLgKwyKvjztcjbA8UhKOUpTr-sS1_Ec=QcWbA@mail.gmail.com> <CAKdAkRSOtAD6u_cwKhHeMLgz5dC2hfPvVvqmj+17b4i-nspfgg@mail.gmail.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Mon, 2 May 2022 13:41:33 -0700
Message-ID: <CAE-0n50Y8tZD9Djn9TVaAiHxehFJ2cZKZ1Z09piDk47uw3nK+Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: google,cros-ec-keyb: Introduce
 switches only compatible
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Doug Anderson <dianders@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	chrome-platform@lists.linux.dev, Krzysztof Kozlowski <krzk@kernel.org>, 
	Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org, 
	Benson Leung <bleung@chromium.org>, Guenter Roeck <groeck@chromium.org>, 
	Hsin-Yi Wang <hsinyi@chromium.org>, "Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Dmitry Torokhov (2022-05-02 10:43:06)
> On Mon, May 2, 2022 at 10:00 AM Doug Anderson <dianders@chromium.org> wrote:
> >
> > That goes against the recently landed commit 4352e23a7ff2 ("Input:
> > cros-ec-keyb - only register keyboard if rows/columns exist") but
> > perhaps we should just _undo_ that that since it landed pretty
> > recently and say that the truly supported way to specify that you only
> > have keyboards/switches is with the compatible.
> >
> > What do you think?
>
> I am sorry, I am still confused on what exactly we are trying to solve
> here? Having a device with the new device tree somehow run an older
> kernel and fail? Why exactly do we care about this case?

Yes, we're trying to solve the problem where a new device tree is used
with an older kernel because it doesn't have the driver patch to only
create an input device for the matrix when rows/columns properties are
present. Otherwise applying that devicetree patch to an older kernel
will break bisection.

> We have
> implemented the notion that without rows/columns properties we will
> not be creating input device for the matrix portion, all older devices
> should have it defined, so the newer driver is compatible with them...
>

Agreed, that solves half the problem. This new compatible eases
integration so that devicetrees can say they're compatible with the old
binding that _requires_ the rows/column properties. By making the driver
change we loosened that requirement, but the binding should have been
making the properties required at the start because it fails to bind
otherwise.

My interpretation of what Doug is saying is that we should maintain that
requirement that rows/columns exists if the original compatible
google,cros-ec-keyb is present and use the new compatible to indicate
that there are switches. Combining the two compatibles means there's
switches and a matrix keyboard, having only the switches compatible
means only switches, and having only the keyboard compatible means only
matrix keyboard.

It sounds OK to me.
