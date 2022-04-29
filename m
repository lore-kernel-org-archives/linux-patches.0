Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432BC1385
	for <patches@lists.linux.dev>; Fri, 29 Apr 2022 16:31:21 +0000 (UTC)
Received: by mail-ed1-f51.google.com with SMTP id a1so9688972edt.3
        for <patches@lists.linux.dev>; Fri, 29 Apr 2022 09:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nw+YlCrCylKax0rwrziby2pzqjnCzgXqaGAQj14/FEI=;
        b=cmoLB6uO9PxqaqPypwrFW8YGlt7ClatqYTSlq5iyiVXxV1LWJkogwZIjIiBEj/ZTWb
         Ql4Q1WdT9KBNm9fCsTjjeqtBBYhwi3Ciq7STsT4lGiEvthpET6Bh4xcjHLtOuCNOTEE8
         0GPKsSlrX1YwAn0zCgP4wW0NDfcPxDZpALoXA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nw+YlCrCylKax0rwrziby2pzqjnCzgXqaGAQj14/FEI=;
        b=3AJzly6X4RjTKpeTIMwbmGRXU3qKR9Ge5/tGyG0kMHYfiHxfbVGgt0/xy92msxpH2N
         eOY4lJLEWYpmasz+2zXDVULVLOn7vLNdL/f79G04UeDH+Qn9f+JFIGThOrnQTKkgXo+u
         rs2CEx8SsTnDyj/59A+oqtkhQdBCgyQGGNUoPHe5Orukg3z8zV9zUGRL2MzZAiMKq6qs
         pfJoOEqXcYXpPrCai05Zz04VkLOMwWwDWiyBseq3/hjD2eE02L0WieKK5FAwdxFoiIuI
         R0HgmbZoKblnp2kLBGc5xLnc578uYb1P+DhVeWKi7NgSlNWV65dkytXABhEZ77WNiwq6
         +W5Q==
X-Gm-Message-State: AOAM531w+RC0mX7RdelGmIAnfTdRiNZJlykcw7I3xjuH9bt/hI3B0No/
	zwVUJFzbXIWoQR/spjlp7AwWpwk1+fR3mTke
X-Google-Smtp-Source: ABdhPJywF0tGiSa8FIgOW8hcyhu6+WgwNacSoX4hql0MYg6Spgc9EgEVMTmTTQpjoXUl47ryml1vUQ==
X-Received: by 2002:a50:ee11:0:b0:425:b5b3:a48d with SMTP id g17-20020a50ee11000000b00425b5b3a48dmr68343eds.246.1651249879279;
        Fri, 29 Apr 2022 09:31:19 -0700 (PDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com. [209.85.128.45])
        by smtp.gmail.com with ESMTPSA id m21-20020aa7c2d5000000b0042617ba6395sm3067871edp.31.2022.04.29.09.31.18
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 09:31:18 -0700 (PDT)
Received: by mail-wm1-f45.google.com with SMTP id ay11-20020a05600c1e0b00b0038eb92fa965so7344439wmb.4
        for <patches@lists.linux.dev>; Fri, 29 Apr 2022 09:31:18 -0700 (PDT)
X-Received: by 2002:a05:600c:3c99:b0:392:b49c:7b79 with SMTP id
 bg25-20020a05600c3c9900b00392b49c7b79mr3913552wmb.199.1651249878250; Fri, 29
 Apr 2022 09:31:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220427203026.828183-1-swboyd@chromium.org> <20220427203026.828183-2-swboyd@chromium.org>
In-Reply-To: <20220427203026.828183-2-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Fri, 29 Apr 2022 09:31:05 -0700
X-Gmail-Original-Message-ID: <CAD=FV=Vtnj+8FYdBSvsud9fGEbo7N1HSjXA3rH3f8FMJsuVR1A@mail.gmail.com>
Message-ID: <CAD=FV=Vtnj+8FYdBSvsud9fGEbo7N1HSjXA3rH3f8FMJsuVR1A@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: google,cros-ec-keyb: Introduce switches
 only compatible
To: Stephen Boyd <swboyd@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, Krzysztof Kozlowski <krzk@kernel.org>, Rob Herring <robh+dt@kernel.org>, 
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, Benson Leung <bleung@chromium.org>, 
	Guenter Roeck <groeck@chromium.org>, Hsin-Yi Wang <hsinyi@chromium.org>, 
	"Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Wed, Apr 27, 2022 at 1:30 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> If the device is a detachable, this device won't have a matrix keyboard
> but it may have some button switches, e.g. volume buttons and power
> buttons. Let's add a more specific compatible for this type of device
> that indicates to the OS that there are only switches and no matrix
> keyboard present.
>
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: <devicetree@vger.kernel.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Hsin-Yi Wang <hsinyi@chromium.org>
> Cc: "Joseph S. Barrera III" <joebar@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  .../bindings/input/google,cros-ec-keyb.yaml          | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> index e8f137abb03c..edc1194d558d 100644
> --- a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> +++ b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> @@ -15,14 +15,20 @@ description: |
>    Google's ChromeOS EC Keyboard is a simple matrix keyboard
>    implemented on a separate EC (Embedded Controller) device. It provides
>    a message for reading key scans from the EC. These are then converted
> -  into keycodes for processing by the kernel.
> +  into keycodes for processing by the kernel. This device also supports
> +  switches/buttons like power and volume buttons.
>
>  allOf:
>    - $ref: "/schemas/input/matrix-keymap.yaml#"
>
>  properties:
>    compatible:
> -    const: google,cros-ec-keyb
> +    oneOf:
> +      - items:
> +          - const: google,cros-ec-keyb-switches
> +          - const: google,cros-ec-keyb
> +      - items:
> +          - const: google,cros-ec-keyb

nit: if I come back and read this binding later I'm not sure it would
be obvious which compatible I should pick. Can we give any description
here that indicates that the first choice is for devices that _only_
have buttons and switches (the google,cros-ec-keyb is just for
backward compatibility) and the second choice is for devices that have
a physical keyboard and _also_ possibly some buttons/switches?

I could also imagine people in the future being confused about whether
it's allowed to specify matrix properties even for devices that don't
have a matrix keyboard. It might be worth noting that it's allowed (to
support old drivers that might still be matching against the
google,cros-ec-keyb compatible) but not required.


>    google,needs-ghost-filter:
>      description:
> @@ -50,7 +56,7 @@ examples:
>    - |
>      #include <dt-bindings/input/input.h>
>      cros-ec-keyb {
> -        compatible = "google,cros-ec-keyb";
> +        compatible = "google,cros-ec-keyb-switches", "google,cros-ec-keyb";

Feels like we should create a second example?
