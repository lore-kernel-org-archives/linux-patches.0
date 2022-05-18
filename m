Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1464A1FAB;
	Wed, 18 May 2022 16:13:51 +0000 (UTC)
Received: by mail-oi1-f178.google.com with SMTP id r1so3233499oie.4;
        Wed, 18 May 2022 09:13:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eMRzRjNkhQaoss3LUukTdqhzCy7CcmpSVBk5VUCkb9s=;
        b=NJ9ppQcIdgSAIJCSzTygKorrnj66XPXUmyBaVgwbjz+zLzaNegbRgfAx5UucBBIsU6
         5WRGoblWLzi4U5BAwCbk3ubrX/dCWh5eb00e2VWTai/Ggd8DQm0J4CDSHDeBQ61L3PRd
         AcGinj5b1xmVz0qGXnO4eVXZAD5CoxwvB3pEhAuNb3uBuTMXhS+96rtqa1u0hQgocRsS
         hC7A9/Ql61YwfMTfJfeyKhL0Pjy9IW8OGoU7WWCAuHI7+sGmraawbrvXycxqSatRQpdD
         DqNG5/g0GgfxuAOAClUdabDP6FPoHIQB8fRHXRDoCtL2wxNUktkFM/1itYAZim3yceme
         7FCw==
X-Gm-Message-State: AOAM533Y5lk6MAZ9trPMCj80f84fAeFB/1rcEbgf9Of7+l7ioE1TWH2G
	Ei5c1u+W/61yYamNzok8dA==
X-Google-Smtp-Source: ABdhPJyM9gwyKZVov5+zkaUB7f6qEXaq1g8vl/n6jJMV9V/BxktLQUhEiUx2l0QFmP2O5mN//53iXA==
X-Received: by 2002:a05:6808:130b:b0:326:d1ff:b56f with SMTP id y11-20020a056808130b00b00326d1ffb56fmr405915oiv.222.1652890431032;
        Wed, 18 May 2022 09:13:51 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id d5-20020a056870e24500b000e90544b79fsm1127031oac.41.2022.05.18.09.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 09:13:49 -0700 (PDT)
Received: (nullmailer pid 3422741 invoked by uid 1000);
	Wed, 18 May 2022 16:13:48 -0000
Date: Wed, 18 May 2022 11:13:48 -0500
From: Rob Herring <robh@kernel.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, devicetree@vger.kernel.org, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, chrome-platform@lists.linux.dev, Guenter Roeck <groeck@chromium.org>, Douglas Anderson <dianders@chromium.org>, Craig Hesling <hesling@chromium.org>, Tom Hughes <tomhughes@chromium.org>, Alexandru M Stan <amstan@chromium.org>, Tzung-Bi Shih <tzungbi@kernel.org>, Matthias Kaehlcke <mka@chromium.org>, Benson Leung <bleung@chromium.org>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v5 3/3] dt-bindings: cros-ec: Add ChromeOS fingerprint
 binding
Message-ID: <20220518161348.GC3302100-robh@kernel.org>
References: <20220512013921.164637-1-swboyd@chromium.org>
 <20220512013921.164637-4-swboyd@chromium.org>
 <20220516152003.GB2659134-robh@kernel.org>
 <CAE-0n53p1mKME=vfed2SB7UXrg9K+-vbp6JPHJBchJc-Pp1Hgg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE-0n53p1mKME=vfed2SB7UXrg9K+-vbp6JPHJBchJc-Pp1Hgg@mail.gmail.com>

On Mon, May 16, 2022 at 12:23:03PM -0700, Stephen Boyd wrote:
> Quoting Rob Herring (2022-05-16 08:20:03)
> > On Wed, May 11, 2022 at 06:39:21PM -0700, Stephen Boyd wrote:
> > > diff --git a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> > > index 409ecef967ce..e5fe60beb9fe 100644
> > > --- a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> > > +++ b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> > > @@ -19,15 +19,19 @@ description:
> > >  properties:
> > >    compatible:
> > >      oneOf:
> > > -      - description:
> > > -          For implementations of the EC is connected through I2C.
> > > -        const: google,cros-ec-i2c
> > > -      - description:
> > > -          For implementations of the EC is connected through SPI.
> > > -        const: google,cros-ec-spi
> > > -      - description:
> > > -          For implementations of the EC is connected through RPMSG.
> > > -        const: google,cros-ec-rpmsg
> > > +      # For implementations of the EC is connected through I2C.
> >
> > Using 'description' was preferred.
> 
> I just learned that I should use anyOf instead of oneOf. Confusing!

Uhh, no. It can only be one of these entries at a time.


> >
> > > +      - items:
> > > +          - const: google,cros-ec-i2c
> > > +      # For implementations of the FPMCU connected through SPI.
> > > +      - items:
> > > +          - const: google,cros-ec-fp
> > > +          - const: google,cros-ec-spi
> > > +      # For implementations of the EC is connected through SPI.
> > > +      - items:
> > > +          - const: google,cros-ec-spi
> > > +      # For implementations of the EC is connected through RPMSG.
> > > +      - items:
> > > +          - const: google,cros-ec-rpmsg
> > >
> > >    controller-data:
> > >      description:
> > > @@ -176,6 +189,37 @@ allOf:
> > >          - reg
> > >          - interrupts
> > >
> > > +  - if:
> > > +      properties:
> > > +        compatible:
> > > +          contains:
> > > +            const: google,cros-ec-fp
> > > +    then:
> > > +      properties:
> > > +        '#address-cells': false
> > > +        '#size-cells': false
> > > +        typec: false
> > > +        ec-pwm: false
> > > +        keyboard-controller: false
> > > +        proximity: false
> > > +        codecs: false
> > > +        cbas: false
> > > +
> > > +      patternProperties:
> > > +        "^i2c-tunnel[0-9]*$": false
> > > +        "^regulator@[0-9]+$": false
> > > +        "^extcon[0-9]*$": false
> >
> > Is the list of what's allowed shorter? If so, you could list those
> > properties and use 'additionalProperties: false'.
> 
> Yes.
> 
> >
> > Or maybe this is a sign that this should be a separate schema document.
> 
> I couldn't figure that out. I tried to add new properties here but it
> didn't work.

Like this?:

then:
  properties:
    allowed-prop-1: true
    allowed-prop-2: true
    allowed-prop-3: true
  additionalProperties: false

> And then when I tried to make a different schema document
> it complained that the example for google,cros-ec-spi in here had a
> problem.

You probably need a custom 'select' so that both schemas aren't 
matching. Otherwise a schema is applied if any of the compatible strings 
match.

> Can properties be defined in this section? 

Yes, but discouraged for vendor specific properties. The if/then should 
really be just additional constraints.

Rob
