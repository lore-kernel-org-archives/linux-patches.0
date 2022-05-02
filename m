Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCE72F2A
	for <patches@lists.linux.dev>; Mon,  2 May 2022 17:01:00 +0000 (UTC)
Received: by mail-ej1-f54.google.com with SMTP id i19so28837104eja.11
        for <patches@lists.linux.dev>; Mon, 02 May 2022 10:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pw2/oXmpaIHCVTryeNN1ZqUEyp67KQCQZki+AHhMtg4=;
        b=WFLlqSaRxtRM1eXCMOy3bfOnfmy/O0CNxC/Kvxvq/ZIAe6jSq6QKKTxR2533G2Ma+M
         cJ7mlkEywoFDQhZG7+kRn8mhBuqtd3heRlnY0oV+pOFJG3vEXsS/ZpfmMuuJ838fRTyq
         Xk6I4ysRfS7pCyUZj4MDQtXlPkIN333kbsYkE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pw2/oXmpaIHCVTryeNN1ZqUEyp67KQCQZki+AHhMtg4=;
        b=GlpmlczLODLnW/b8iDCHrTX+TWQIMZ0tKv+KClqQTLABKFEBTciD4GT75YbC8iGRS0
         YmaR4MVkGjkmsRja3ZnmUzeM6BeiPndfkUU+zPWgRre7ZRuiUVULCSdhUzjA1XCInPfw
         3XmsS3NLxl7/M6/EwnLYhasvvAKLVF3bV21KKrI/+6wd2OfnPkIblj72VMMicteTBjvO
         q7XAT4Gq0Vevw1T4VCVrkS8/ckBi4Gclvs6EguVMR1wQjBTCsnj7ErZYVigZvQ6V4KWl
         +dhBYboLly/msBv8bCi0+esILN5unba7VkxptmPIN35QGR6XFvHA/xu3DxbSq8gpNsJX
         wHSQ==
X-Gm-Message-State: AOAM531VbmUNIBJ6udOSFWdTsdiS292KO5C7mOMxJZD+XH/h34yWhrkI
	17GakDqj4hspeQ8m2K5Owng0TA6vod4D6SOM
X-Google-Smtp-Source: ABdhPJzkMJ6NK/ZJpAg1f01noaI7YKuMl0P+6LJ4ZMMklndurBJutaeq+9r7uskE56Dd7+TT7RT5kQ==
X-Received: by 2002:a17:907:6092:b0:6f3:9d63:3b45 with SMTP id ht18-20020a170907609200b006f39d633b45mr12626354ejc.703.1651510858357;
        Mon, 02 May 2022 10:00:58 -0700 (PDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com. [209.85.128.48])
        by smtp.gmail.com with ESMTPSA id em20-20020a170907289400b006f3ef214e04sm3757393ejc.106.2022.05.02.10.00.56
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 May 2022 10:00:56 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id a14-20020a7bc1ce000000b00393fb52a386so10515775wmj.1
        for <patches@lists.linux.dev>; Mon, 02 May 2022 10:00:56 -0700 (PDT)
X-Received: by 2002:a05:600c:4e44:b0:394:46b4:7b0e with SMTP id
 e4-20020a05600c4e4400b0039446b47b0emr57531wmq.29.1651510855777; Mon, 02 May
 2022 10:00:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220429233112.2851665-1-swboyd@chromium.org> <20220429233112.2851665-2-swboyd@chromium.org>
In-Reply-To: <20220429233112.2851665-2-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 2 May 2022 10:00:44 -0700
X-Gmail-Original-Message-ID: <CAD=FV=VX8EEgkeLgKwyKvjztcjbA8UhKOUpTr-sS1_Ec=QcWbA@mail.gmail.com>
Message-ID: <CAD=FV=VX8EEgkeLgKwyKvjztcjbA8UhKOUpTr-sS1_Ec=QcWbA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: google,cros-ec-keyb: Introduce
 switches only compatible
To: Stephen Boyd <swboyd@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, chrome-platform@lists.linux.dev, 
	Krzysztof Kozlowski <krzk@kernel.org>, Rob Herring <robh+dt@kernel.org>, 
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, Benson Leung <bleung@chromium.org>, 
	Guenter Roeck <groeck@chromium.org>, Hsin-Yi Wang <hsinyi@chromium.org>, 
	"Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Fri, Apr 29, 2022 at 4:31 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> If the device is a detachable, this device won't have a matrix keyboard
> but it may have some button switches, e.g. volume buttons and power
> buttons. Let's add a more specific compatible for this type of device
> that indicates to the OS that there are only switches and no matrix
> keyboard present. If only the switches compatible is present, then the
> matrix keyboard properties are denied. This lets us gracefully migrate
> devices that only have switches over to the new compatible string.

I know the history here so I know the reasons for the 3 choices, but
I'm not sure I'd fully understand it just from the description above.
Maybe a summary in the CL desc would help?

Summary:

1. If you have a matrix keyboard and maybe also some buttons/switches
then use the compatible: google,cros-ec-keyb

2. If you only have buttons/switches but you want to be compatible
with the old driver in Linux that looked for the compatible
"google,cros-ec-keyb" and required the matrix properties, use the
compatible: "google,cros-ec-keyb-switches", "google,cros-ec-keyb"

3. If you have only buttons/switches and don't need compatibility with
old Linux drivers, use the compatible: "google,cros-ec-keyb-switches"


> Similarly, start enforcing that the keypad rows/cols and keymap
> properties exist if the google,cros-ec-keyb compatible is present. This
> more clearly describes what the driver is expecting, i.e. that the
> kernel driver will fail to probe if the row or column or keymap
> properties are missing and only the google,cros-ec-keyb compatible is
> present.
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
>  .../bindings/input/google,cros-ec-keyb.yaml   | 95 +++++++++++++++++--
>  1 file changed, 89 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> index e8f137abb03c..c1b079449cf3 100644
> --- a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> +++ b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> @@ -15,14 +15,19 @@ description: |
>    Google's ChromeOS EC Keyboard is a simple matrix keyboard
>    implemented on a separate EC (Embedded Controller) device. It provides
>    a message for reading key scans from the EC. These are then converted
> -  into keycodes for processing by the kernel.
> -
> -allOf:
> -  - $ref: "/schemas/input/matrix-keymap.yaml#"
> +  into keycodes for processing by the kernel. This device also supports
> +  switches/buttons like power and volume buttons.
>
>  properties:
>    compatible:
> -    const: google,cros-ec-keyb
> +    oneOf:
> +      - items:
> +          - const: google,cros-ec-keyb-switches
> +      - items:
> +          - const: google,cros-ec-keyb-switches
> +          - const: google,cros-ec-keyb
> +      - items:
> +          - const: google,cros-ec-keyb
>
>    google,needs-ghost-filter:
>      description:
> @@ -41,15 +46,40 @@ properties:
>        where the lower 16 bits are reserved. This property is specified only
>        when the keyboard has a custom design for the top row keys.
>
> +dependencies:
> +  function-row-phsymap: [ 'linux,keymap' ]
> +  google,needs-ghost-filter: [ 'linux,keymap' ]
> +
>  required:
>    - compatible
>
> +allOf:
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: google,cros-ec-keyb
> +    then:
> +      allOf:
> +        - $ref: "/schemas/input/matrix-keymap.yaml#"
> +  - if:
> +      not:
> +        properties:
> +          compatible:
> +            contains:
> +              const: google,cros-ec-keyb-switches
> +    then:
> +      required:
> +        - keypad,num-rows
> +        - keypad,num-columns
> +        - linux,keymap

I think that:

1. If you only have buttons/switches and care about backward
compatibility, you use the "two compatibles" version.

2. If you care about backward compatibility then you _must_ include
the matrix properties.

Thus I would be tempted to say that we should just have one "if" test
that says that if matrix properties are allowed then they're also
required.

That goes against the recently landed commit 4352e23a7ff2 ("Input:
cros-ec-keyb - only register keyboard if rows/columns exist") but
perhaps we should just _undo_ that that since it landed pretty
recently and say that the truly supported way to specify that you only
have keyboards/switches is with the compatible.

What do you think?

-Doug
