Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFFA29A2;
	Thu, 19 May 2022 19:48:24 +0000 (UTC)
Received: by mail-oi1-f171.google.com with SMTP id n24so7647584oie.12;
        Thu, 19 May 2022 12:48:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VIsxZb3blRqHveZZ1vGHzZvKm0j5k9bs5pNXv4/1iRw=;
        b=4vp6FBhI3qnmoCNqAETCm+nqN2bkXVX5pHKeR4/16WyLQ/mq0gn3H7KkSVK9N59BVD
         auvjKdSTF2Bsur6D39CPiFFfJCf+TqCi9WTM0fNunF61nIHXoR7o+h0uqY4tGRbJ4S/D
         OnXfHPLCo4vBlYsYIJowNDID0z5isGWqkN9cHOITXV0BK6M3bBdMTZ+60LDsB9eLA9D7
         4J1RiXQkHKL3thjklzT3li4OCXBSEJupXmnGRbAg+ggvzbugdmpWe5gmXMlWhp70/vlX
         A3PGt0jw0KK6FHnQuPYYRb2rWSzWgfsqfmuIILStSPR++YqeME/DjKL4OBLFbHGiN+pn
         OEsQ==
X-Gm-Message-State: AOAM530K8NvjMohxklFbrjdoIvsqNhRglCcs2oNdZd14hJ6uqBaBncZ1
	fCcsX3is6JjIQeKJj9v+og==
X-Google-Smtp-Source: ABdhPJznjYxOKubyLqrHc8K4JIoqeBTU25Rk4zIlngny0HhJr/+0rpaykQKsYWnr3T8r+X5F4uMRsA==
X-Received: by 2002:a05:6808:f8a:b0:326:de54:a750 with SMTP id o10-20020a0568080f8a00b00326de54a750mr3381561oiw.272.1652989703540;
        Thu, 19 May 2022 12:48:23 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id d15-20020a056830004f00b0060613c844adsm105593otp.10.2022.05.19.12.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 12:48:22 -0700 (PDT)
Received: (nullmailer pid 2081471 invoked by uid 1000);
	Thu, 19 May 2022 19:48:21 -0000
Date: Thu, 19 May 2022 14:48:21 -0500
From: Rob Herring <robh@kernel.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, devicetree@vger.kernel.org, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, chrome-platform@lists.linux.dev, Guenter Roeck <groeck@chromium.org>, Douglas Anderson <dianders@chromium.org>, Craig Hesling <hesling@chromium.org>, Tom Hughes <tomhughes@chromium.org>, Alexandru M Stan <amstan@chromium.org>, Tzung-Bi Shih <tzungbi@kernel.org>, Matthias Kaehlcke <mka@chromium.org>, Benson Leung <bleung@chromium.org>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v5 3/3] dt-bindings: cros-ec: Add ChromeOS fingerprint
 binding
Message-ID: <20220519194821.GA2071376-robh@kernel.org>
References: <20220512013921.164637-1-swboyd@chromium.org>
 <20220512013921.164637-4-swboyd@chromium.org>
 <20220516152003.GB2659134-robh@kernel.org>
 <CAE-0n53p1mKME=vfed2SB7UXrg9K+-vbp6JPHJBchJc-Pp1Hgg@mail.gmail.com>
 <20220518161348.GC3302100-robh@kernel.org>
 <CAE-0n53CMwtCY6XqYRXBpY5g21cFKyr8BF34t79JfK3dKg8cEg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE-0n53CMwtCY6XqYRXBpY5g21cFKyr8BF34t79JfK3dKg8cEg@mail.gmail.com>

On Wed, May 18, 2022 at 12:56:17PM -0700, Stephen Boyd wrote:
> Quoting Rob Herring (2022-05-18 09:13:48)
> > On Mon, May 16, 2022 at 12:23:03PM -0700, Stephen Boyd wrote:
> > > Quoting Rob Herring (2022-05-16 08:20:03)
> > > > On Wed, May 11, 2022 at 06:39:21PM -0700, Stephen Boyd wrote:
> > > > > diff --git a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> > > > > index 409ecef967ce..e5fe60beb9fe 100644
> > > > > --- a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> > > > > +++ b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> > > > > +      - items:
> > > > > +          - const: google,cros-ec-i2c
> > > > > +      # For implementations of the FPMCU connected through SPI.
> > > > > +      - items:
> > > > > +          - const: google,cros-ec-fp
> > > > > +          - const: google,cros-ec-spi
> > > > > +      # For implementations of the EC is connected through SPI.
> > > > > +      - items:
> > > > > +          - const: google,cros-ec-spi
> > > > > +      # For implementations of the EC is connected through RPMSG.
> > > > > +      - items:
> > > > > +          - const: google,cros-ec-rpmsg
> > > > >
> > > > >    controller-data:
> > > > >      description:
> > > > > @@ -176,6 +189,37 @@ allOf:
> > > > >          - reg
> > > > >          - interrupts
> > > > >
> > > > > +  - if:
> > > > > +      properties:
> > > > > +        compatible:
> > > > > +          contains:
> > > > > +            const: google,cros-ec-fp
> > > > > +    then:
> > > > > +      properties:
> > > > > +        '#address-cells': false
> > > > > +        '#size-cells': false
> > > > > +        typec: false
> > > > > +        ec-pwm: false
> > > > > +        keyboard-controller: false
> > > > > +        proximity: false
> > > > > +        codecs: false
> > > > > +        cbas: false
> > > > > +
> > > > > +      patternProperties:
> > > > > +        "^i2c-tunnel[0-9]*$": false
> > > > > +        "^regulator@[0-9]+$": false
> > > > > +        "^extcon[0-9]*$": false
> > > >
> > > > Is the list of what's allowed shorter? If so, you could list those
> > > > properties and use 'additionalProperties: false'.
> > >
> > > Yes.
> > >
> > > >
> > > > Or maybe this is a sign that this should be a separate schema document.
> > >
> > > I couldn't figure that out. I tried to add new properties here but it
> > > didn't work.
> >
> > Like this?:
> >
> > then:
> >   properties:
> >     allowed-prop-1: true
> >     allowed-prop-2: true
> >     allowed-prop-3: true
> >   additionalProperties: false
> 
> It doesn't seem to combine constraints?
> 
> I get this error:
> 
> 	Documentation/devicetree/bindings/mfd/google,cros-ec.example.dt.yaml:
> 	ec@0: Additional properties are not allowed ('$nodename' was unexpected)

That would be a bug or limitation in the tools. We would need to add 
all the other properties we automatically add as well... I think either 
leaving it as-is or a separate file is going to be the better route 
here.

Rob
