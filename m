Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631CE15AD
	for <patches@lists.linux.dev>; Thu, 16 Jun 2022 00:50:10 +0000 (UTC)
Received: by mail-ot1-f41.google.com with SMTP id h15-20020a9d600f000000b0060c02d737ecso18807otj.1
        for <patches@lists.linux.dev>; Wed, 15 Jun 2022 17:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=2n+TFof2POThL99hyq/41irwfqDc3AvWFjRglyLstd8=;
        b=kkakXjBt/V6u5jkZ8lAGtuG5THuUQOXAXhQ5t7xxQ1bZ867DsPsh6EImLphuq5fs9m
         dHRWyw92ps+4aK9S0iOh5TyCmBMusc0rU7T4dyZ0VTB+re06qoqjCAQlmmn6Bhtq/gEV
         GPzw26VRwLnqQDp/o+uv6K1dgu9zqduUnfe38=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=2n+TFof2POThL99hyq/41irwfqDc3AvWFjRglyLstd8=;
        b=7ZRuxzG4Ww275CDcIP8vB2Osgmzj+2MdELKQHtWomuG6T9TQPGtA1nfiT4jdvLauhP
         G/JY+zMV1qlnTfUrUya+zmQRwtgUW8Jp0YH7wuX5PyLYpnmjBk+dnB5u5X6OHk4O9e4W
         ZAvX1qWMhyv1FJYC2f12rePC7km+E8sasROthhLIrNFXxWYMlo5AT1Urh2ASFuNczTwJ
         VCrR7qf+vB6ybHS+ZSbZCQQdiKZvOCi89Wok6gwHc7VWkHwBpTBEs+NOnP8DIbPYkZfK
         GWkvi9FFCOWqwZx6KiQM425uk+0xLQNhtXpJQ8P7FQK82BFI/ZZKSpdd684RIYXtcOMV
         dYZQ==
X-Gm-Message-State: AJIora+4ipvGikjWe7hLJG6gC3NB9LzGFLBORDCV+w/cNROy3fESXHbZ
	bkMG/cfsK1JM10YbZGEOEQgb7E1Jk+G4cN3l+Qi5tg==
X-Google-Smtp-Source: AGRyM1sFQjWy7A0wLfGZw6Rskgi/CnY4DvjLwxEzj4DpBc8R4s8j8PtToCS9MtRb3a/yZKR0osG6MihBhJdqDZBQNVI=
X-Received: by 2002:a9d:6484:0:b0:60b:eb0b:4054 with SMTP id
 g4-20020a9d6484000000b0060beb0b4054mr1106041otl.159.1655340609475; Wed, 15
 Jun 2022 17:50:09 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 15 Jun 2022 17:50:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAD=FV=UU-AENyChCvVAKH709E4hFtgo4Txa8zFDY=JM1UifA0g@mail.gmail.com>
References: <20220614195144.2794796-1-swboyd@chromium.org> <20220614195144.2794796-3-swboyd@chromium.org>
 <CAD=FV=UU-AENyChCvVAKH709E4hFtgo4Txa8zFDY=JM1UifA0g@mail.gmail.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 15 Jun 2022 17:50:09 -0700
Message-ID: <CAE-0n53v4Ts0D=FUZwCHa-q0gkQnujPWvvq+_8zZmYaAozcVAw@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] dt-bindings: cros-ec: Add ChromeOS fingerprint binding
To: Doug Anderson <dianders@chromium.org>
Cc: Benson Leung <bleung@chromium.org>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, 
	chrome-platform@lists.linux.dev, Guenter Roeck <groeck@chromium.org>, 
	Craig Hesling <hesling@chromium.org>, Tom Hughes <tomhughes@chromium.org>, 
	Alexandru M Stan <amstan@chromium.org>, Tzung-Bi Shih <tzungbi@kernel.org>, 
	Matthias Kaehlcke <mka@chromium.org>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Doug Anderson (2022-06-14 15:41:25)
> On Tue, Jun 14, 2022 at 12:51 PM Stephen Boyd <swboyd@chromium.org> wrote:
> > +
> > +select:
> > +  properties:
> > +    compatible:
> > +      contains:
> > +        const: google,cros-ec-spi
> > +  required:
> > +    - compatible
> > +    - boot0-gpios
>
> I've never personally used "select" before and I'm not sure where it's
> documented. Without knowing anything, it seems weird to me that in
> this file we're matching against a compatible that's not
> google,cros-ec-fp. Randomly grabbing some other example that's similar
> (panel-lvds.yaml) looks more like what I would have expected. AKA in
> this file:
>
> select:
>   properties:
>     compatible:
>       contains:
>         const: google,cros-ec-fp
>   required:
>     - compatible
>
> ...and then in the other file:
>
> select:
>   properties:
>     compatible:
>       contains:
>         const: google,cros-ec-spi
>   not:
>     properties:
>       compatible:
>         contains:
>           const: google,cros-ec-fp
>   required:
>     - compatible
>
>
> Of course, if one of the dt maintainers gives different advice then
> listen to them. ;-)
>

I followed a pwm example, see renesas,tpu-pwm.yaml, but I suspect this
works just as well. I don't really care either way so I'll defer to DT
maintainers here.
