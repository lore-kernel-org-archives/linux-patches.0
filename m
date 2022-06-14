Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09432F37
	for <patches@lists.linux.dev>; Tue, 14 Jun 2022 22:41:40 +0000 (UTC)
Received: by mail-io1-f48.google.com with SMTP id y79so10947641iof.2
        for <patches@lists.linux.dev>; Tue, 14 Jun 2022 15:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hvehCBfUTvgEUWe65S6hBli1BzVjPsVtPnt86add/kI=;
        b=A611+FifO5/wxtRT2yw4vt9ZxdMZMO1YdFrBzWAQZ+h2wb9x3Hm3GO3as3VS4HtzOD
         lKFKKkG+nF5VPBDTsFylpJVr5eMnvLGvlpZ2mG+grr6OXUAQwYkoo299LvMG7dVq35g4
         WjtxSCbzIgGtSimJ4tYsqPGIi5f61C2w9oVCo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hvehCBfUTvgEUWe65S6hBli1BzVjPsVtPnt86add/kI=;
        b=hqepPzX9V9gUmujBc51KeM4xAoILMCR3hyjAf1/Cn6XyozOCrMyf0lLRM7E2TINFA4
         8CqFjKs2PbKxWVfoNfmEkN6Jl6mjedoESRCVwVRKPZb61k/ijZdPdG3Urr6vUntO33HB
         EZzciocRY3djCTLYTSBCe9JfblzUJEmdEs6tt4pHVY/Nq9v0Edg1jhjjbz3tde1yyiL4
         f0mGGHr+XLUXFVMIyGe2lwiqADvSzhllZCCG4SyRHEIBpQV/NUVgGTE7e+lVeOWhFh6/
         NunZJedi/Iwa4C+SgoXivOJY2nWxePWEYFvJ12gJSYvuE5eTfsFpoYfthMYJTLD3UhS/
         ajUQ==
X-Gm-Message-State: AOAM531HZqIOd+e4OwhoYADGHA8dtt2rCJzrjsgJj4VjCxZ3EgWvsA2F
	6dsribC1y1WNzt4qYfFlPZzheAdP8A7yNIxj
X-Google-Smtp-Source: ABdhPJxaEh9CkEoNrHp7UDZcsDEACIEF9qSGg/Ns+yRdOgWtoA0mVNSIm+h1xrlJ7l8YDUKt/fgZdw==
X-Received: by 2002:a6b:7218:0:b0:669:d865:bb51 with SMTP id n24-20020a6b7218000000b00669d865bb51mr3616876ioc.52.1655246499818;
        Tue, 14 Jun 2022 15:41:39 -0700 (PDT)
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com. [209.85.166.169])
        by smtp.gmail.com with ESMTPSA id o19-20020a056e02103300b002d396d6a2b4sm5953653ilj.13.2022.06.14.15.41.38
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 15:41:38 -0700 (PDT)
Received: by mail-il1-f169.google.com with SMTP id f7so7654325ilr.5
        for <patches@lists.linux.dev>; Tue, 14 Jun 2022 15:41:38 -0700 (PDT)
X-Received: by 2002:a05:6e02:20e9:b0:2d1:d151:3c53 with SMTP id
 q9-20020a056e0220e900b002d1d1513c53mr4443271ilv.220.1655246498060; Tue, 14
 Jun 2022 15:41:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220614195144.2794796-1-swboyd@chromium.org> <20220614195144.2794796-3-swboyd@chromium.org>
In-Reply-To: <20220614195144.2794796-3-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Tue, 14 Jun 2022 15:41:25 -0700
X-Gmail-Original-Message-ID: <CAD=FV=UU-AENyChCvVAKH709E4hFtgo4Txa8zFDY=JM1UifA0g@mail.gmail.com>
Message-ID: <CAD=FV=UU-AENyChCvVAKH709E4hFtgo4Txa8zFDY=JM1UifA0g@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] dt-bindings: cros-ec: Add ChromeOS fingerprint binding
To: Stephen Boyd <swboyd@chromium.org>
Cc: Benson Leung <bleung@chromium.org>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, chrome-platform@lists.linux.dev, 
	Guenter Roeck <groeck@chromium.org>, Craig Hesling <hesling@chromium.org>, 
	Tom Hughes <tomhughes@chromium.org>, Alexandru M Stan <amstan@chromium.org>, 
	Tzung-Bi Shih <tzungbi@kernel.org>, Matthias Kaehlcke <mka@chromium.org>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Tue, Jun 14, 2022 at 12:51 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> Add a binding to describe the fingerprint processor found on Chromebooks
> with a fingerprint sensor. Previously we've been describing this with
> the google,cros-ec-spi binding but it lacks gpio and regulator control
> used during firmware flashing.
>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: <devicetree@vger.kernel.org>
> Cc: <chrome-platform@lists.linux.dev>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Craig Hesling <hesling@chromium.org>
> Cc: Tom Hughes <tomhughes@chromium.org>
> Cc: Alexandru M Stan <amstan@chromium.org>
> Cc: Tzung-Bi Shih <tzungbi@kernel.org>
> Cc: Matthias Kaehlcke <mka@chromium.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  .../bindings/chrome/google,cros-ec-fp.yaml    | 97 +++++++++++++++++++
>  .../bindings/mfd/google,cros-ec.yaml          |  9 ++
>  2 files changed, 106 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/chrome/google,cros-ec-fp.yaml
>
> diff --git a/Documentation/devicetree/bindings/chrome/google,cros-ec-fp.yaml b/Documentation/devicetree/bindings/chrome/google,cros-ec-fp.yaml
> new file mode 100644
> index 000000000000..48c02bd4585c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/chrome/google,cros-ec-fp.yaml
> @@ -0,0 +1,97 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/chrome/google,cros-ec-fp.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: ChromeOS Embedded Fingerprint Controller
> +
> +description:
> +  Google's ChromeOS embedded fingerprint controller is a device which
> +  implements fingerprint functionality such as unlocking a Chromebook
> +  without typing a password.
> +
> +maintainers:
> +  - Tom Hughes <tomhughes@chromium.org>
> +
> +select:
> +  properties:
> +    compatible:
> +      contains:
> +        const: google,cros-ec-spi
> +  required:
> +    - compatible
> +    - boot0-gpios

I've never personally used "select" before and I'm not sure where it's
documented. Without knowing anything, it seems weird to me that in
this file we're matching against a compatible that's not
google,cros-ec-fp. Randomly grabbing some other example that's similar
(panel-lvds.yaml) looks more like what I would have expected. AKA in
this file:

select:
  properties:
    compatible:
      contains:
        const: google,cros-ec-fp
  required:
    - compatible

...and then in the other file:

select:
  properties:
    compatible:
      contains:
        const: google,cros-ec-spi
  not:
    properties:
      compatible:
        contains:
          const: google,cros-ec-fp
  required:
    - compatible


Of course, if one of the dt maintainers gives different advice then
listen to them. ;-)

-Doug
