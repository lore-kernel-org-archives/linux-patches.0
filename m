Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5E07B
	for <patches@lists.linux.dev>; Fri, 29 Apr 2022 19:34:59 +0000 (UTC)
Received: by mail-oi1-f172.google.com with SMTP id m11so9532347oib.11
        for <patches@lists.linux.dev>; Fri, 29 Apr 2022 12:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=E0Q3EZPBzEkcXpZcFDBM/8hh0PQ3g9tg+K9PcJx+iK8=;
        b=j7Mu2qjwlrTIhzG1/SRWrea/G70nXiVi41rs9h824BDxboFT2bYoOlddcsk05eFR3S
         riShkXFHtHqTtwVtScs1+WWrcvU4L8FTNKZBoRrV4kvxdbTkP877tUBxbeGUJFZFmDGf
         7d2pu/cIMZUBtgibQB7fc9ptmJimpmjFtBhUM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=E0Q3EZPBzEkcXpZcFDBM/8hh0PQ3g9tg+K9PcJx+iK8=;
        b=5zeeKfpADJvtR6Pp5qo99uSTI2XD9nE6+FZ0FuW9Q0kf98wPepUsuT8rsuTU5/4wFa
         gI8A1Cn7TIJSdVuQvrGFqlE+L86RH1YoJ7E/JwAf62TPTv/KPVVWvLSKbxIj/DPbBTeh
         OgoOo4fSNAnmoxnrxoIE/siXqREUg11evXz0DXH9/nmS+gyhxWJWO8+4ZaNyG1nrIIVt
         L7IPFM04YbrHAdipaHqx1MlqXclDJ04ByIVnST7wlBlSGgb2ksN3XZqhzE+8lpRFcG1O
         f0/kJzriitV662sN08+aWly0aZRHbkk96Ibd1F4NEtR76/WpjIjve+K84aOmUakqxX8x
         2TdA==
X-Gm-Message-State: AOAM5305AkaIyQnUyvGRRAKaHt078maBGckrRkwQLdSSydbFm19QptY+
	y6gImwsYQxMb2MXnmZaD8ZQp0CW4VIGWNqEyknFvWw==
X-Google-Smtp-Source: ABdhPJybWFdvd26gPp93ZZnFPwxpgGugVjji5kYbw3wxJ0sB3egmlQ0aK36Ny0i3uauBxbTztZtUxyMYb/Knjvif090=
X-Received: by 2002:a05:6808:1296:b0:325:8fb:68f3 with SMTP id
 a22-20020a056808129600b0032508fb68f3mr437845oiw.193.1651260897935; Fri, 29
 Apr 2022 12:34:57 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 30 Apr 2022 04:34:57 +0900
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <eb2dd599-f38a-57b2-694e-d91aaadda2b5@kernel.org>
References: <20220427203026.828183-1-swboyd@chromium.org> <20220427203026.828183-2-swboyd@chromium.org>
 <CAD=FV=Vtnj+8FYdBSvsud9fGEbo7N1HSjXA3rH3f8FMJsuVR1A@mail.gmail.com> <eb2dd599-f38a-57b2-694e-d91aaadda2b5@kernel.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Sat, 30 Apr 2022 04:34:57 +0900
Message-ID: <CAE-0n52M0yfwMnuO9HTCCuv2pU3oWkGuyxOS4x7_gVN5QFFGMw@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: google,cros-ec-keyb: Introduce switches
 only compatible
To: Doug Anderson <dianders@chromium.org>, Krzysztof Kozlowski <krzk@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org, 
	Benson Leung <bleung@chromium.org>, Guenter Roeck <groeck@chromium.org>, 
	Hsin-Yi Wang <hsinyi@chromium.org>, "Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Krzysztof Kozlowski (2022-04-29 09:35:58)
> On 29/04/2022 18:31, Doug Anderson wrote:
> >>    - $ref: "/schemas/input/matrix-keymap.yaml#"
> >>
> >>  properties:
> >>    compatible:
> >> -    const: google,cros-ec-keyb
> >> +    oneOf:
> >> +      - items:
> >> +          - const: google,cros-ec-keyb-switches
> >> +          - const: google,cros-ec-keyb
> >> +      - items:
> >> +          - const: google,cros-ec-keyb
> >
> > nit: if I come back and read this binding later I'm not sure it would
> > be obvious which compatible I should pick. Can we give any description
> > here that indicates that the first choice is for devices that _only_
> > have buttons and switches (the google,cros-ec-keyb is just for
> > backward compatibility) and the second choice is for devices that have
> > a physical keyboard and _also_ possibly some buttons/switches?

Sounds fair. I have to figure out how to add a description to the
choices. I guess a comment is the approach?

> >
> > I could also imagine people in the future being confused about whether
> > it's allowed to specify matrix properties even for devices that don't
> > have a matrix keyboard. It might be worth noting that it's allowed (to
> > support old drivers that might still be matching against the
> > google,cros-ec-keyb compatible) but not required.
>
> +1

Sure. I'll work that into the description for the first one with two
compatibles.

>
> >
> >
> >>    google,needs-ghost-filter:
> >>      description:
> >> @@ -50,7 +56,7 @@ examples:
> >>    - |
> >>      #include <dt-bindings/input/input.h>
> >>      cros-ec-keyb {
> >> -        compatible = "google,cros-ec-keyb";
> >> +        compatible = "google,cros-ec-keyb-switches", "google,cros-ec-keyb";
> >
> > Feels like we should create a second example?
>
> +1 as well, because it really would confuse what's the difference
> between them.

Ok.
