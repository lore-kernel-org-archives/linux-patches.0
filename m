Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DB03FF1
	for <patches@lists.linux.dev>; Thu, 12 May 2022 23:45:07 +0000 (UTC)
Received: by mail-ed1-f45.google.com with SMTP id g23so7984688edy.13
        for <patches@lists.linux.dev>; Thu, 12 May 2022 16:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V8uYgTXib/6BjhyAwPvyH9p+W39RRdBBH4HTP3NeUrE=;
        b=NkK5kPK5fIrUVGWgs+G9GyiaTiTnt5AJgzEKT+dmRktub3KA9K295ltiHCVtsmJ/t/
         x4Z76G4eFJ4PCnRDRHT4mBC/tPRg7JhJc5QIiBfjq8rb6o3pR4E8xPOCHPfXsVBXObaP
         IJjabM2xCsvBa3UCWB37Mr/RUrFPgxrNSwGFg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V8uYgTXib/6BjhyAwPvyH9p+W39RRdBBH4HTP3NeUrE=;
        b=bG8UHmLh1eoGDozV+XjrToXIa2Y6pRh0h5+ZmLEqdRMx+x6aC+Avw1dXxtrUaD9n43
         js8b3e8K+71M7IIma0h2al2pc3d2TtpN+olshpPyGvLgQS5EmFQVnXOPUrlosSO5IY5t
         X6vxsNPcUfbfBvo6v5DyR2kjYSnjFki33Qe4EL5q2rqmMI+27ruCG5nkr10SylO6pW7v
         xvbXbkrr3ssgBhRF1DZB+zXsZC+92q9N+692rEM4iEV7O96+2L/ZSiR6Nq5oY00wEX6X
         S149KChsC1kTyDnOm8srP8SYnAy+8DgnaXdLQLKPEQzFzegKYiaG7ZswZW+iCvrP5viG
         qDCg==
X-Gm-Message-State: AOAM530yw3mXtI0jsMLlDDczw/GVzKWqQH4vbFeffJE1ldn04KR4KcKs
	g8FwNjIZs8fpNv8IRW7wbgfpQ/z9q3PWbRwN34Y=
X-Google-Smtp-Source: ABdhPJzx1dwkxJLlnlI3tCTwXJPsSnuAnJ8R/ub/m0SDKWnctzeF4UdcCavTXSmlaMRYGi+jtVc0GA==
X-Received: by 2002:a05:6402:155a:b0:425:c0b1:ab07 with SMTP id p26-20020a056402155a00b00425c0b1ab07mr37699329edx.258.1652399105359;
        Thu, 12 May 2022 16:45:05 -0700 (PDT)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com. [209.85.128.43])
        by smtp.gmail.com with ESMTPSA id yl15-20020a17090693ef00b006f3ef214de7sm216522ejb.77.2022.05.12.16.45.04
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 16:45:04 -0700 (PDT)
Received: by mail-wm1-f43.google.com with SMTP id bg25so3884526wmb.4
        for <patches@lists.linux.dev>; Thu, 12 May 2022 16:45:04 -0700 (PDT)
X-Received: by 2002:a05:600c:3d8c:b0:394:6097:9994 with SMTP id
 bi12-20020a05600c3d8c00b0039460979994mr12323884wmb.29.1652399103788; Thu, 12
 May 2022 16:45:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220512013921.164637-1-swboyd@chromium.org> <20220512013921.164637-4-swboyd@chromium.org>
In-Reply-To: <20220512013921.164637-4-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Thu, 12 May 2022 16:44:51 -0700
X-Gmail-Original-Message-ID: <CAD=FV=W4k8-Ab+diBic5rbannRr1ZKB=cdHNEOC3Emr0nyzQjQ@mail.gmail.com>
Message-ID: <CAD=FV=W4k8-Ab+diBic5rbannRr1ZKB=cdHNEOC3Emr0nyzQjQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] dt-bindings: cros-ec: Add ChromeOS fingerprint binding
To: Stephen Boyd <swboyd@chromium.org>
Cc: Rob Herring <robh+dt@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, 
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, chrome-platform@lists.linux.dev, 
	Guenter Roeck <groeck@chromium.org>, Craig Hesling <hesling@chromium.org>, 
	Tom Hughes <tomhughes@chromium.org>, Alexandru M Stan <amstan@chromium.org>, 
	Tzung-Bi Shih <tzungbi@kernel.org>, Matthias Kaehlcke <mka@chromium.org>, 
	Benson Leung <bleung@chromium.org>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Wed, May 11, 2022 at 6:39 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> @@ -176,6 +189,37 @@ allOf:
>          - reg
>          - interrupts
>
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: google,cros-ec-fp
> +    then:
> +      properties:
> +        '#address-cells': false
> +        '#size-cells': false
> +        typec: false
> +        ec-pwm: false
> +        keyboard-controller: false
> +        proximity: false
> +        codecs: false
> +        cbas: false
> +
> +      patternProperties:
> +        "^i2c-tunnel[0-9]*$": false
> +        "^regulator@[0-9]+$": false
> +        "^extcon[0-9]*$": false
> +
> +      required:
> +        - reset-gpios
> +        - boot0-gpios
> +        - vdd-supply
> +    else:
> +      properties:
> +        reset-gpios: false
> +        boot0-gpios: false
> +        vdd-supply: false

Wow, that's a huge pain to have to specify it this way, but I don't
know of any other way to make things happy and still have the
"google,cros-ec-spi" fallback that we decided on having in previous
versions.


>  additionalProperties: false
>
>  examples:
> @@ -231,4 +275,22 @@ examples:
>              compatible = "google,cros-ec-rpmsg";
>          };
>      };
> +
> +  - |

nit: all the other examples have a little "# For <blah>" comment
before them. It's not really necessary, but do we want one here to
match?

In any case, it seems OK to me.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
