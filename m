Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF0C322E
	for <patches@lists.linux.dev>; Tue,  3 May 2022 16:14:36 +0000 (UTC)
Received: by mail-ej1-f42.google.com with SMTP id y3so34334034ejo.12
        for <patches@lists.linux.dev>; Tue, 03 May 2022 09:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bOowZENKEYBOQ5gQtuLs74mzTNH8Gi+Wvcp/0afqUT4=;
        b=EEwYnpnu/2Fhr2sQHT2uhYWiyPhvmtU8DzHokKeYAXu5vlR0UiuNcMwlij7eWJT/Nd
         KGBSe8Pej98sSFsthhMfgTmsJ5yPc7UFnVb+KTUDaeG/1/BJHloKuzgbBAk7p6W+v8RQ
         xOP2eAJC4V5tKxUYoLIDLfVmxDH3iyr65NTWU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bOowZENKEYBOQ5gQtuLs74mzTNH8Gi+Wvcp/0afqUT4=;
        b=zr+MxH0tpXilS3nKAgwqyNzU9ac6/wz5oRJCEQ367gD4xidg9KfvDMYCwkhnKghgSj
         AWptwObr+JBf/bMIMWv/lPyZQI0EDh4RgmyDznGiVA7IMe+7mbujpE8kVTZF/6DTWSBY
         afH1wFaZaHaXd0fdRhpTwAcgZ8zv3N9lcNGDw04NaYE6+wc/na3sSBWhXs6TEfo0MHUC
         /hdF95ZkhoAnIVrl8eQoD5K5Nuf7WFfYROlxQPsXGdIWMbqT8erAnu0FbgZIOdat5rSi
         lb7H6FIMgFGL969Wef5Uw0NP3XZaSEJLiiP2Xlm8bPp1/A4WTxGZq6u8WpFTJZxhIXIG
         d/RQ==
X-Gm-Message-State: AOAM532MDi/danQ7jUxl8T//gMKSc+8PdNP0v4dMjDhTtkD0c5QrrOZj
	Rh2pq50aAQOy/s0JqWkPqZCM/YmDjoPNnBUC
X-Google-Smtp-Source: ABdhPJwd6XJ3VASmyT89gU9oW7+3baGYxdEjSJhwScrieKOO/RbXZsVxWIQBpuwzru+OqhwerKquJQ==
X-Received: by 2002:a17:906:65d5:b0:6ba:3133:dfb9 with SMTP id z21-20020a17090665d500b006ba3133dfb9mr16819706ejn.56.1651594475215;
        Tue, 03 May 2022 09:14:35 -0700 (PDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com. [209.85.221.48])
        by smtp.gmail.com with ESMTPSA id mm25-20020a170906cc5900b006f3ef214dddsm4789424ejb.67.2022.05.03.09.14.34
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 09:14:35 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id t6so24077487wra.4
        for <patches@lists.linux.dev>; Tue, 03 May 2022 09:14:34 -0700 (PDT)
X-Received: by 2002:adf:f50d:0:b0:20a:e096:ef with SMTP id q13-20020adff50d000000b0020ae09600efmr13256382wro.679.1651594474057;
 Tue, 03 May 2022 09:14:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220503042242.3597561-1-swboyd@chromium.org> <20220503042242.3597561-2-swboyd@chromium.org>
 <2280875f-fbd8-0dfd-5a0a-1d7fceb856e4@linaro.org> <CAD=FV=UEBi9dctmhaAi1z+c+Sj5gtcRrc3FRW294T55dTiAidQ@mail.gmail.com>
 <cd1da207-1f15-f3f1-7190-56b983e75024@kernel.org>
In-Reply-To: <cd1da207-1f15-f3f1-7190-56b983e75024@kernel.org>
From: Doug Anderson <dianders@chromium.org>
Date: Tue, 3 May 2022 09:14:21 -0700
X-Gmail-Original-Message-ID: <CAD=FV=XHNuvhekh=hepGePftaMXnDJGeJP=Lg8VfqmGdKt7HEA@mail.gmail.com>
Message-ID: <CAD=FV=XHNuvhekh=hepGePftaMXnDJGeJP=Lg8VfqmGdKt7HEA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: google,cros-ec-keyb: Introduce
 switches only compatible
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, Stephen Boyd <swboyd@chromium.org>, 
	Dmitry Torokhov <dmitry.torokhov@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, chrome-platform@lists.linux.dev, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob Herring <robh+dt@kernel.org>, 
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, Benson Leung <bleung@chromium.org>, 
	Guenter Roeck <groeck@chromium.org>, Hsin-Yi Wang <hsinyi@chromium.org>, 
	"Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Tue, May 3, 2022 at 8:54 AM Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On 03/05/2022 17:46, Doug Anderson wrote:
> > Hi,
> >
> > On Tue, May 3, 2022 at 8:42 AM Krzysztof Kozlowski
> > <krzysztof.kozlowski@linaro.org> wrote:
> >>
> >> On 03/05/2022 06:22, Stephen Boyd wrote:
> >>> If the ChromeOS board is a detachable, this cros-ec-keyb device won't
> >>> have a matrix keyboard but it may have some button switches, e.g. volume
> >>> buttons and power buttons. The driver still registers a keyboard though
> >>> and that leads to userspace confusion around where the keyboard is.
> >>
> >> (...)
> >>
> >>>
> >>> +if:
> >>> +  properties:
> >>> +    compatible:
> >>> +      contains:
> >>> +        const: google,cros-ec-keyb
> >>> +then:
> >>> +  allOf:
> >>> +    - $ref: "/schemas/input/matrix-keymap.yaml#"
> >>> +  required:
> >>> +    - keypad,num-rows
> >>> +    - keypad,num-columns
> >>> +    - linux,keymap
> >>
> >> else:
> >>   properties:
> >>     function-row-phsymap: false
> >>     google,needs-ghost-filter: false
> >>
> >> Because these are not valid for the non-matrix-keyboard case, right?
> >
> > Isn't that implicit because this file has `unevaluatedProperties: false` ?
>
> But they are evaluated here, aren't they?

Only if the "if" test, though? ...ah, or is this a difference between
"unevaluatedProperties" and "additionalProperties" ?

-Doug
