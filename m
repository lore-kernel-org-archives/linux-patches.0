Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3201381
	for <patches@lists.linux.dev>; Mon, 16 May 2022 19:23:04 +0000 (UTC)
Received: by mail-oi1-f171.google.com with SMTP id y63so19807885oia.7
        for <patches@lists.linux.dev>; Mon, 16 May 2022 12:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=3+ILikSdsnfT9ktihZ+njcMiBi6avoeWbTpOVrY1NxM=;
        b=m8Od8lrXE/NoExJmTS7XYRL0JEh+rwgZMGX6AMz7iGgPCJc+7D9DU49rvjnaOgoaSu
         1G0dIbZbcsjRTfCHNk3yV9IwLJlxvC01/HihdispeZ/uNg8WgXECd9mxIK5QBKHx8kb2
         uE6ftP61i4XGhdJd+DVeLgywcC9UVbt3gWTZA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=3+ILikSdsnfT9ktihZ+njcMiBi6avoeWbTpOVrY1NxM=;
        b=HiZVzxvdUHQ95+jZfRJ9KSPa7Ho4bnE6KxyCVBZCGwYMTXKvHNsOgIcayc7dG8X2D6
         aR9weMRdtJymuypPq1oNY7QvYV5H8x6Afm8WP2UOW523Jg9oOxpuJxGfNqE1mdyyuks5
         RQbI3e8ixIVyT5v5zDK17IKmd78MRBaGLOJZS7HTUXxCZs18Ma2pnmDCqXVy9WayuhnI
         nvCrldtVZdlCTt1BLpuuslGSITWkNFRTs7DVzIV43+WhIa1GtupwUcGh8Ljf6kX5CikO
         riO8Pzf+Q6I0xNKsZfIh4H4nBI8yL/PHBjACHIeebeMFFaTukbV+xo9+RnTLtqIF9DK7
         HHRw==
X-Gm-Message-State: AOAM533yGgx/IPqmknfTIs/IkelPQaYUC+emO3y2KzSnMiOKDX1PnLcP
	E9yzfv8lnw6GPxfKSjDoZY7IK4p4xiNtn2YdmPoN2g==
X-Google-Smtp-Source: ABdhPJyvNeXlbvxsN4Ayayznt+WzvPNN7/UsJfK9N/bTxb48FVDCVCp9ZryMgViVY+QlGSrW/dp0YsJFpfAHJoPOIhk=
X-Received: by 2002:a05:6808:23c3:b0:326:bd8d:7993 with SMTP id
 bq3-20020a05680823c300b00326bd8d7993mr8665634oib.63.1652728984111; Mon, 16
 May 2022 12:23:04 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 16 May 2022 12:23:03 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20220516152003.GB2659134-robh@kernel.org>
References: <20220512013921.164637-1-swboyd@chromium.org> <20220512013921.164637-4-swboyd@chromium.org>
 <20220516152003.GB2659134-robh@kernel.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Mon, 16 May 2022 12:23:03 -0700
Message-ID: <CAE-0n53p1mKME=vfed2SB7UXrg9K+-vbp6JPHJBchJc-Pp1Hgg@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] dt-bindings: cros-ec: Add ChromeOS fingerprint binding
To: Rob Herring <robh@kernel.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	devicetree@vger.kernel.org, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, chrome-platform@lists.linux.dev, 
	Guenter Roeck <groeck@chromium.org>, Douglas Anderson <dianders@chromium.org>, 
	Craig Hesling <hesling@chromium.org>, Tom Hughes <tomhughes@chromium.org>, 
	Alexandru M Stan <amstan@chromium.org>, Tzung-Bi Shih <tzungbi@kernel.org>, 
	Matthias Kaehlcke <mka@chromium.org>, Benson Leung <bleung@chromium.org>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Rob Herring (2022-05-16 08:20:03)
> On Wed, May 11, 2022 at 06:39:21PM -0700, Stephen Boyd wrote:
> > diff --git a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> > index 409ecef967ce..e5fe60beb9fe 100644
> > --- a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> > +++ b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> > @@ -19,15 +19,19 @@ description:
> >  properties:
> >    compatible:
> >      oneOf:
> > -      - description:
> > -          For implementations of the EC is connected through I2C.
> > -        const: google,cros-ec-i2c
> > -      - description:
> > -          For implementations of the EC is connected through SPI.
> > -        const: google,cros-ec-spi
> > -      - description:
> > -          For implementations of the EC is connected through RPMSG.
> > -        const: google,cros-ec-rpmsg
> > +      # For implementations of the EC is connected through I2C.
>
> Using 'description' was preferred.

I just learned that I should use anyOf instead of oneOf. Confusing!

>
> > +      - items:
> > +          - const: google,cros-ec-i2c
> > +      # For implementations of the FPMCU connected through SPI.
> > +      - items:
> > +          - const: google,cros-ec-fp
> > +          - const: google,cros-ec-spi
> > +      # For implementations of the EC is connected through SPI.
> > +      - items:
> > +          - const: google,cros-ec-spi
> > +      # For implementations of the EC is connected through RPMSG.
> > +      - items:
> > +          - const: google,cros-ec-rpmsg
> >
> >    controller-data:
> >      description:
> > @@ -176,6 +189,37 @@ allOf:
> >          - reg
> >          - interrupts
> >
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            const: google,cros-ec-fp
> > +    then:
> > +      properties:
> > +        '#address-cells': false
> > +        '#size-cells': false
> > +        typec: false
> > +        ec-pwm: false
> > +        keyboard-controller: false
> > +        proximity: false
> > +        codecs: false
> > +        cbas: false
> > +
> > +      patternProperties:
> > +        "^i2c-tunnel[0-9]*$": false
> > +        "^regulator@[0-9]+$": false
> > +        "^extcon[0-9]*$": false
>
> Is the list of what's allowed shorter? If so, you could list those
> properties and use 'additionalProperties: false'.

Yes.

>
> Or maybe this is a sign that this should be a separate schema document.

I couldn't figure that out. I tried to add new properties here but it
didn't work. And then when I tried to make a different schema document
it complained that the example for google,cros-ec-spi in here had a
problem. Can properties be defined in this section? Or only listed and
then additionalProperties be marked false?
