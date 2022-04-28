Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC247B
	for <patches@lists.linux.dev>; Thu, 28 Apr 2022 06:24:20 +0000 (UTC)
Received: by mail-oi1-f180.google.com with SMTP id z8so4399871oix.3
        for <patches@lists.linux.dev>; Wed, 27 Apr 2022 23:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=AOUBjawPmRnN8evNXoYGp+/SwIc2Lx8wXlLCMbXCewc=;
        b=eFFoq6CzQtllJEhFXdGNNINBsySKH5Zogv5JnVRsgWjDI/7/fCM0iXGbg8y44gNgYE
         CVtURwJlXlwY2byoC7a7YrZDuayY5qI04K0A0/BYFxuA1Bx1/JQEs7610miyQQZ86ZTl
         dc/ZUERs0AX151PR25GDPOP78Pmgug2/iGiK4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=AOUBjawPmRnN8evNXoYGp+/SwIc2Lx8wXlLCMbXCewc=;
        b=K+Mf7g0KC3xAke1YeBL+B5Ls6w1vrWmnGIbWnplxFdPVFYqW32xyS6EJMoeH+h9MV2
         LaPKwoSb4jg0SpEiujb33J/D7rguiS3Ldxuj48T+ZCe8B3DHcmsdj0g7/yujw3OQEjvs
         P7Mn/+cuFnjrNNUHlIoQ+WrOjxUzsJUZ4XkxLo66WD0jHCfgBpAEABhU53o9gobPGDtz
         sCSFeE1b/P+Un9r4eSEa0k5sd61zVgY35coQL/QTa61dGD5tLPPUjO3hkSnLodbKOVDy
         wNZFcAQB2MJkrdEyiTu4uKGMfEbxTlitBimS5Im7c3dtv39bQsAexpI1uozVp2A17g4e
         iFlA==
X-Gm-Message-State: AOAM531K9RD8ijZysa3K4/4cigFHc9fTtuMcRHpTLxRV7CI0yrcDe2wi
	XEZeRQxukoNWnVihwqcnY5mmlSuZZY/Un7ge8K8pVA==
X-Google-Smtp-Source: ABdhPJxTdgDULp8Ip+gh6w1tifiji7I8A/vnaeGTUOQvBOIBhBkdr1QUO8MYQFS6Fq24/UPeIqz1MmwGQ5SxG5Hr59k=
X-Received: by 2002:a05:6808:1296:b0:325:8fb:68f3 with SMTP id
 a22-20020a056808129600b0032508fb68f3mr10950982oiw.193.1651127060059; Wed, 27
 Apr 2022 23:24:20 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 27 Apr 2022 23:24:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <9248da4f-ca04-82f0-2840-a20797c25d2a@linaro.org>
References: <20220427203026.828183-1-swboyd@chromium.org> <20220427203026.828183-2-swboyd@chromium.org>
 <9248da4f-ca04-82f0-2840-a20797c25d2a@linaro.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 27 Apr 2022 23:24:19 -0700
Message-ID: <CAE-0n52Y=3EEZ6qguNx=hM44BahbH3cuq7x6Bbe5HELKkkvrUw@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: google,cros-ec-keyb: Introduce switches
 only compatible
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, 
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org, 
	Benson Leung <bleung@chromium.org>, Guenter Roeck <groeck@chromium.org>, 
	Douglas Anderson <dianders@chromium.org>, Hsin-Yi Wang <hsinyi@chromium.org>, 
	"Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Krzysztof Kozlowski (2022-04-27 23:12:47)
> On 27/04/2022 22:30, Stephen Boyd wrote:
> > If the device is a detachable, this device won't have a matrix keyboard
> > but it may have some button switches, e.g. volume buttons and power
> > buttons. Let's add a more specific compatible for this type of device
> > that indicates to the OS that there are only switches and no matrix
> > keyboard present.
> >
> > Cc: Krzysztof Kozlowski <krzk@kernel.org>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: <devicetree@vger.kernel.org>
> > Cc: Benson Leung <bleung@chromium.org>
> > Cc: Guenter Roeck <groeck@chromium.org>
> > Cc: Douglas Anderson <dianders@chromium.org>
> > Cc: Hsin-Yi Wang <hsinyi@chromium.org>
> > Cc: "Joseph S. Barrera III" <joebar@chromium.org>
> > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > ---
> >  .../bindings/input/google,cros-ec-keyb.yaml          | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> > index e8f137abb03c..edc1194d558d 100644
> > --- a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> > +++ b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> > @@ -15,14 +15,20 @@ description: |
> >    Google's ChromeOS EC Keyboard is a simple matrix keyboard
> >    implemented on a separate EC (Embedded Controller) device. It provides
> >    a message for reading key scans from the EC. These are then converted
> > -  into keycodes for processing by the kernel.
> > +  into keycodes for processing by the kernel. This device also supports
> > +  switches/buttons like power and volume buttons.
> >
> >  allOf:
> >    - $ref: "/schemas/input/matrix-keymap.yaml#"
> >
> >  properties:
> >    compatible:
> > -    const: google,cros-ec-keyb
> > +    oneOf:
> > +      - items:
> > +          - const: google,cros-ec-keyb-switches
> > +          - const: google,cros-ec-keyb
> > +      - items:
> > +          - const: google,cros-ec-keyb
> >
>
> In such case matrix-keymap properties are not valid, right? The
> matrix-keymap should not be referenced, IOW, you need to move allOf
> below "required" and add:
> if:not:...then: $ref: "/schemas/input/matrix-keymap.yaml
>

Eventually that sounds doable, but for the time being I want to merely
add this new compatible in front of the original compatible so that
updated DTBs still work with older kernels, i.e. the switches still get
registered because the driver works with the original
google,cros-ec-keyb compatible. Given that none of the properties are
required for google,cros-ec-keyb it didn't seem necessary to make having
the google,cros-ec-keyb-switches compatible deny the existence of the
matrix-keymap properties.
