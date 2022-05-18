Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE8F1FDA
	for <patches@lists.linux.dev>; Wed, 18 May 2022 19:56:18 +0000 (UTC)
Received: by mail-ot1-f46.google.com with SMTP id a22-20020a9d3e16000000b00606aeb12ab6so2092657otd.7
        for <patches@lists.linux.dev>; Wed, 18 May 2022 12:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=q6k7TwXQDY275UxkUuTVNtao4TZzazR5moehWbU13Bc=;
        b=g5/fbsGkOpFvl3DvRZPpEo8jogun8jSOWCLsALy94X/VCP6ncGUUeLsIqnLGqdKEzW
         P8/cLn9bNiLprBIroXErfdY4WYJFHqO/bdJITBfN50ZhToYrp0ye5UhOb1QKEHoifbq8
         OKiURvgnNxPbcMitcPLkdDI96p+slNJxk/9w4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=q6k7TwXQDY275UxkUuTVNtao4TZzazR5moehWbU13Bc=;
        b=OWUOz0FtI9mjFLV4QhY+oD2I1IXf41j3OdC+RcGDB5Vn6BS+hEHzudYi+e9zW9d4SS
         fZzn5T66MWuxx+t1VyOiEJtRYt0NA4Vk2k25HpacYcOWdj5Ml9AE7tOX4xPcuzvJqhSr
         bcLxMvlAzEZ7IvPiHqdiNIKPouutQ7O4Ocs6/SIzlNFL08XZRB+sAEInKSaRHgcWB3Qb
         knB7LYxf2/sCJzN0NGZ4eLNVTMkCVXl6V4P/C+iN3gWF9f+CGxtvN6300UxwZfL6E7fg
         /30pqzYy7Dcqf1mDgto1/K+8mZsaDZy5RfK4hpEapQrlshPNZzyx/aGtoRiQaXZQAmCM
         kd8g==
X-Gm-Message-State: AOAM532eSClSt7RqpT6Q/EcAJbwu8Ei5loP/C8PXScD0W81WtsMvwKR0
	cku6MJ7nr1K2JZejyNjFOjZs4wradj2XLFfHvZMcjQ==
X-Google-Smtp-Source: ABdhPJwLifvJOWX3yKWzLoGN0MnHOdrbsoJrvUWC4w9Xr9cAvIQorp5Y2A947/vh4RjZprkumyYkzxKdHOHmmWcv7uE=
X-Received: by 2002:a05:6830:13ce:b0:606:702b:87f0 with SMTP id
 e14-20020a05683013ce00b00606702b87f0mr541140otq.159.1652903777929; Wed, 18
 May 2022 12:56:17 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 18 May 2022 12:56:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20220518161348.GC3302100-robh@kernel.org>
References: <20220512013921.164637-1-swboyd@chromium.org> <20220512013921.164637-4-swboyd@chromium.org>
 <20220516152003.GB2659134-robh@kernel.org> <CAE-0n53p1mKME=vfed2SB7UXrg9K+-vbp6JPHJBchJc-Pp1Hgg@mail.gmail.com>
 <20220518161348.GC3302100-robh@kernel.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 18 May 2022 12:56:17 -0700
Message-ID: <CAE-0n53CMwtCY6XqYRXBpY5g21cFKyr8BF34t79JfK3dKg8cEg@mail.gmail.com>
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

Quoting Rob Herring (2022-05-18 09:13:48)
> On Mon, May 16, 2022 at 12:23:03PM -0700, Stephen Boyd wrote:
> > Quoting Rob Herring (2022-05-16 08:20:03)
> > > On Wed, May 11, 2022 at 06:39:21PM -0700, Stephen Boyd wrote:
> > > > diff --git a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> > > > index 409ecef967ce..e5fe60beb9fe 100644
> > > > --- a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> > > > +++ b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> > > > +      - items:
> > > > +          - const: google,cros-ec-i2c
> > > > +      # For implementations of the FPMCU connected through SPI.
> > > > +      - items:
> > > > +          - const: google,cros-ec-fp
> > > > +          - const: google,cros-ec-spi
> > > > +      # For implementations of the EC is connected through SPI.
> > > > +      - items:
> > > > +          - const: google,cros-ec-spi
> > > > +      # For implementations of the EC is connected through RPMSG.
> > > > +      - items:
> > > > +          - const: google,cros-ec-rpmsg
> > > >
> > > >    controller-data:
> > > >      description:
> > > > @@ -176,6 +189,37 @@ allOf:
> > > >          - reg
> > > >          - interrupts
> > > >
> > > > +  - if:
> > > > +      properties:
> > > > +        compatible:
> > > > +          contains:
> > > > +            const: google,cros-ec-fp
> > > > +    then:
> > > > +      properties:
> > > > +        '#address-cells': false
> > > > +        '#size-cells': false
> > > > +        typec: false
> > > > +        ec-pwm: false
> > > > +        keyboard-controller: false
> > > > +        proximity: false
> > > > +        codecs: false
> > > > +        cbas: false
> > > > +
> > > > +      patternProperties:
> > > > +        "^i2c-tunnel[0-9]*$": false
> > > > +        "^regulator@[0-9]+$": false
> > > > +        "^extcon[0-9]*$": false
> > >
> > > Is the list of what's allowed shorter? If so, you could list those
> > > properties and use 'additionalProperties: false'.
> >
> > Yes.
> >
> > >
> > > Or maybe this is a sign that this should be a separate schema document.
> >
> > I couldn't figure that out. I tried to add new properties here but it
> > didn't work.
>
> Like this?:
>
> then:
>   properties:
>     allowed-prop-1: true
>     allowed-prop-2: true
>     allowed-prop-3: true
>   additionalProperties: false

It doesn't seem to combine constraints?

I get this error:

	Documentation/devicetree/bindings/mfd/google,cros-ec.example.dt.yaml:
	ec@0: Additional properties are not allowed ('$nodename' was unexpected)


with this interdiff. I added the spi properties to reduce the additional
properties that aren't allowed.

---8<----
diff --git a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
index 04b847fd5070..d47c7a273026 100644
--- a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
+++ b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
@@ -18,24 +18,21 @@ description:

 properties:
   compatible:
-    anyOf:
+    oneOf:
       - description:
           For implementations of the EC connected through I2C.
-      - items:
-          - const: google,cros-ec-i2c
+        const: google,cros-ec-i2c
       - description:
           For implementations of the FPMCU connected through SPI.
-      - items:
+        items:
           - const: google,cros-ec-fp
           - const: google,cros-ec-spi
       - description:
           For implementations of the EC connected through SPI.
-      - items:
-          - const: google,cros-ec-spi
+        const: google,cros-ec-spi
       - description:
           For implementations of the EC connected through RPMSG.
-      - items:
-          - const: google,cros-ec-rpmsg
+        const: google,cros-ec-rpmsg

   controller-data:
     description:
@@ -200,19 +197,14 @@ allOf:
             const: google,cros-ec-fp
     then:
       properties:
-        '#address-cells': false
-        '#size-cells': false
-        typec: false
-        ec-pwm: false
-        keyboard-controller: false
-        proximity: false
-        codecs: false
-        cbas: false
-
-      patternProperties:
-        "^i2c-tunnel[0-9]*$": false
-        "^regulator@[0-9]+$": false
-        "^extcon[0-9]*$": false
+        reset-gpios: true
+        boot0-gpios: true
+        vdd-supply: true
+        interrupts: true
+        compatible: true
+        reg: true
+        spi-max-frequency: true
+      additionalProperties: false

       required:
         - reset-gpios

>
> > And then when I tried to make a different schema document
> > it complained that the example for google,cros-ec-spi in here had a
> > problem.
>
> You probably need a custom 'select' so that both schemas aren't
> matching. Otherwise a schema is applied if any of the compatible strings
> match.

I see. Maybe that's better vs. jamming it all into one file.

>
> > Can properties be defined in this section?
>
> Yes, but discouraged for vendor specific properties. The if/then should
> really be just additional constraints.

Ok.
