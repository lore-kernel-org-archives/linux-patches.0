Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500B63D98
	for <patches@lists.linux.dev>; Tue, 14 Jun 2022 22:41:54 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id b138so4114304iof.13
        for <patches@lists.linux.dev>; Tue, 14 Jun 2022 15:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9+kyzNbwL34JPEo3iqbzLbGd9UuckbxCXwZqzQQStRo=;
        b=kxZU4O5oWw0x6pDNeXPLnBAGs3Pgu48222c3blJk4xg8T3aZUo/tY4zJCYU8/9SHJc
         eqFiPRvDdjVxZPzHJ4Yr1mmtdWKKKeoKPFWWqMd1kR8Gw7kAq7NIgJhcIPmbG1qZz4OM
         yE/QC1aP/kCMscfKbNeK6lvJBePdJir4T9S6g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9+kyzNbwL34JPEo3iqbzLbGd9UuckbxCXwZqzQQStRo=;
        b=5mIbXOE1NiVhsuRoFRC9hy1GXZW2MXWllXo70BwC9r842RhQ9ZM8wlLD9dPiR8Rf8f
         Ia5tGkxSwWDaUWHcZeUR4gY0fXPvDDH1+LEgPCdMwk8gSaDIkR+HOwRXZPi2S+egYBb7
         7lxTxbVVAhNL/hKA+Ld17x8MDQ84NOLQRgsNNjNZ3VgbzlUThEvMnNIfgIUaNb3mw7FK
         3//3BQcEwoH1sXion1+qGPqV5hRkyIZI+p/p7EE8RpMS2iMizoZvIjaNtZCs3Csvv8wE
         Iae4w0U+2guD3x9BIotQMnz1/PycbQBA9VCuA8MVxJHUL5KPpAKniUsh8Nv58Xw6m9V+
         ybtg==
X-Gm-Message-State: AOAM533HcIMmjOramg4v2f3vGjiUCHtK/f+3U2xjEYpUyoJ++7FjVI+Y
	LiHGf0vSFrbpmOruEu9Kdn4RVPfMwqd4buc2
X-Google-Smtp-Source: ABdhPJwnFnmUQsD94+xiAGWyvKwdTdOK0GvQKG3ghlkxIhZoAzbqM/z6tQKH7MdhpT/dgu0kVWF3aQ==
X-Received: by 2002:a05:6638:5b0:b0:331:61eb:618a with SMTP id b16-20020a05663805b000b0033161eb618amr4233620jar.164.1655246513227;
        Tue, 14 Jun 2022 15:41:53 -0700 (PDT)
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com. [209.85.166.50])
        by smtp.gmail.com with ESMTPSA id j18-20020a5d93d2000000b00665862d12bbsm5964894ioo.46.2022.06.14.15.41.52
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 15:41:52 -0700 (PDT)
Received: by mail-io1-f50.google.com with SMTP id h8so10920449iof.11
        for <patches@lists.linux.dev>; Tue, 14 Jun 2022 15:41:52 -0700 (PDT)
X-Received: by 2002:a02:c6c4:0:b0:333:ecb2:fc7f with SMTP id
 r4-20020a02c6c4000000b00333ecb2fc7fmr3785042jan.184.1655246512053; Tue, 14
 Jun 2022 15:41:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220614195144.2794796-1-swboyd@chromium.org> <20220614195144.2794796-2-swboyd@chromium.org>
In-Reply-To: <20220614195144.2794796-2-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Tue, 14 Jun 2022 15:41:38 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WUnMCj2GmMy2xRG8WOba1O4jzkXeUrrUic71eEA0aZrw@mail.gmail.com>
Message-ID: <CAD=FV=WUnMCj2GmMy2xRG8WOba1O4jzkXeUrrUic71eEA0aZrw@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] dt-bindings: cros-ec: Reorganize property availability
To: Stephen Boyd <swboyd@chromium.org>
Cc: Benson Leung <bleung@chromium.org>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, chrome-platform@lists.linux.dev, 
	Guenter Roeck <groeck@chromium.org>, Craig Hesling <hesling@chromium.org>, 
	Tom Hughes <tomhughes@chromium.org>, Alexandru M Stan <amstan@chromium.org>, 
	Tzung-Bi Shih <tzungbi@kernel.org>, Matthias Kaehlcke <mka@chromium.org>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Tue, Jun 14, 2022 at 12:51 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> Various properties in the cros-ec binding only apply to different
> compatible strings. For example, the interrupts and reg property are
> required for all cros-ec devices except for the rpmsg version. Add some
> conditions to update the availability of properties so that they can't
> be used with compatibles that don't support them.
>
> Cc: Rob Herring <robh@kernel.org>
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
>  .../bindings/chrome/google,cros-ec-typec.yaml |  1 +
>  .../bindings/extcon/extcon-usbc-cros-ec.yaml  |  1 +
>  .../i2c/google,cros-ec-i2c-tunnel.yaml        |  1 +
>  .../bindings/mfd/google,cros-ec.yaml          | 29 +++++++++++++------
>  .../bindings/pwm/google,cros-ec-pwm.yaml      |  1 +
>  .../regulator/google,cros-ec-regulator.yaml   |  1 +
>  .../bindings/sound/google,cros-ec-codec.yaml  |  1 +
>  7 files changed, 26 insertions(+), 9 deletions(-)

slight nit that from reading the subject of this patch I'd expect that
it was a no-op. Just a reorganization / cleanup. In fact, it actually
is more than a no-op. It enforces restrictions that should probably
have always been enforced. I think it'd be better if the subject was
something like "tighten property requirements" or something like that.


> @@ -158,12 +154,27 @@ allOf:
>                - google,cros-ec-rpmsg
>      then:
>        properties:
> +        controller-data: false
>          google,cros-ec-spi-pre-delay: false
>          google,cros-ec-spi-msg-delay: false
>          spi-max-frequency: false
>      else:
>        $ref: /schemas/spi/spi-peripheral-props.yaml
>
> +  - if:
> +      properties:
> +        compatible:
> +          not:
> +            contains:
> +              const: google,cros-ec-rpmsg
> +    then:
> +      properties:
> +        mediatek,rpmsg-name: false
> +
> +      required:
> +        - reg
> +        - interrupts

slight nit that think it would be easier to understand this bottom
section if you made the "SPI" and "RPMSG" sections more symmetric to
each other. I think it would be easy to just change the SPI one to say
"not SPI" instead of explicitly listing "i2c" and "rpmsg".

In any case, this overall looks pretty nice to me. My two requests are
both pretty small nits, so either with or without fixing them:

Reviewed-by: Douglas Anderson <dianders@chromium.org>
