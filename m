Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A4D3204
	for <patches@lists.linux.dev>; Tue,  3 May 2022 15:46:38 +0000 (UTC)
Received: by mail-io1-f44.google.com with SMTP id z26so19371886iot.8
        for <patches@lists.linux.dev>; Tue, 03 May 2022 08:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DmEYqT+9Ka7njk/TwR9G+Gdm+tqkABc7dcTcU/7kYZY=;
        b=IPLzFJvRDQ9r0mh8TcbmuNu1p2ZCdA+ba9sSjOT1tZkhVfsHcEFr2+YTCL1iNWL6fI
         2UmCRjoVIb5YpVcAKV+QVUbX4nNZeBM0yzyPY5NKn8pVRSa1OAvQJTqAPGL6I1tR9/7p
         o7JiIwX99eJ9jk7iN47UV8C2OJuigQEUnteBo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DmEYqT+9Ka7njk/TwR9G+Gdm+tqkABc7dcTcU/7kYZY=;
        b=EWj8F1IMIr1HOC4XcmtcbHD6KRU2cduxAArWu/QJIqU0mEhQZltPSgFcY7PD9h3+pW
         HRkfDP5uKp+YznU2nxEnbjmhu7NvW403qZtt74gsMZtzOZP8pJJJyzLzQhc7wre2yhjz
         yrlzIKwrdJIzeV8nMKN8WuDXmOcCWmLsmQXnrNa1KjoOIDqS7dGotA9Mh1TlsnY7Hxpt
         RBzzNr8uLDLUiIN0HsSJL8mfN0xoWURmFVi/p84j14qLHWBy+idibe4e53i2HJKWfxM6
         yhrsdkCL/5q1VixreEI2ohDwOLlgVJmpmSAPcP5+oOsp58nRXcddpVyZcVP2Eksp6THs
         NyDw==
X-Gm-Message-State: AOAM532ctxwoOlNEJlu1f/NP+KCaYxh9YIST5s6Os/fcyW4/jHj3l1Hc
	tnd3X4N1rPO0X2Z9nmuI60B+cQJG0VFZMOGs
X-Google-Smtp-Source: ABdhPJzzHjo8fgBhBmLbrJQXMyztYLuhe2zSirAjhYcATQXClHqYQYyRePwnPfHSxHDA6bo7LEuahQ==
X-Received: by 2002:a05:6638:1516:b0:323:712b:cf79 with SMTP id b22-20020a056638151600b00323712bcf79mr7351129jat.290.1651592797169;
        Tue, 03 May 2022 08:46:37 -0700 (PDT)
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com. [209.85.166.182])
        by smtp.gmail.com with ESMTPSA id z18-20020a05663803b200b0032b3a78176asm3959801jap.46.2022.05.03.08.46.36
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 08:46:36 -0700 (PDT)
Received: by mail-il1-f182.google.com with SMTP id y16so9973157ilc.7
        for <patches@lists.linux.dev>; Tue, 03 May 2022 08:46:36 -0700 (PDT)
X-Received: by 2002:a92:c263:0:b0:2cf:c0e:bd81 with SMTP id
 h3-20020a92c263000000b002cf0c0ebd81mr4741427ild.220.1651592796090; Tue, 03
 May 2022 08:46:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220503042242.3597561-1-swboyd@chromium.org> <20220503042242.3597561-2-swboyd@chromium.org>
 <2280875f-fbd8-0dfd-5a0a-1d7fceb856e4@linaro.org>
In-Reply-To: <2280875f-fbd8-0dfd-5a0a-1d7fceb856e4@linaro.org>
From: Doug Anderson <dianders@chromium.org>
Date: Tue, 3 May 2022 08:46:21 -0700
X-Gmail-Original-Message-ID: <CAD=FV=UEBi9dctmhaAi1z+c+Sj5gtcRrc3FRW294T55dTiAidQ@mail.gmail.com>
Message-ID: <CAD=FV=UEBi9dctmhaAi1z+c+Sj5gtcRrc3FRW294T55dTiAidQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: google,cros-ec-keyb: Introduce
 switches only compatible
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Stephen Boyd <swboyd@chromium.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, 
	LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	chrome-platform@lists.linux.dev, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Rob Herring <robh+dt@kernel.org>, 
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, Benson Leung <bleung@chromium.org>, 
	Guenter Roeck <groeck@chromium.org>, Hsin-Yi Wang <hsinyi@chromium.org>, 
	"Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Tue, May 3, 2022 at 8:42 AM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 03/05/2022 06:22, Stephen Boyd wrote:
> > If the ChromeOS board is a detachable, this cros-ec-keyb device won't
> > have a matrix keyboard but it may have some button switches, e.g. volume
> > buttons and power buttons. The driver still registers a keyboard though
> > and that leads to userspace confusion around where the keyboard is.
>
> (...)
>
> >
> > +if:
> > +  properties:
> > +    compatible:
> > +      contains:
> > +        const: google,cros-ec-keyb
> > +then:
> > +  allOf:
> > +    - $ref: "/schemas/input/matrix-keymap.yaml#"
> > +  required:
> > +    - keypad,num-rows
> > +    - keypad,num-columns
> > +    - linux,keymap
>
> else:
>   properties:
>     function-row-phsymap: false
>     google,needs-ghost-filter: false
>
> Because these are not valid for the non-matrix-keyboard case, right?

Isn't that implicit because this file has `unevaluatedProperties: false` ?

-Doug
