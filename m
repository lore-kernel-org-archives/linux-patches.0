Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BDF258E
	for <patches@lists.linux.dev>; Mon, 23 May 2022 16:19:19 +0000 (UTC)
Received: by mail-ej1-f49.google.com with SMTP id gi33so21408244ejc.3
        for <patches@lists.linux.dev>; Mon, 23 May 2022 09:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rYw/iw5eqrvTTFbNpKOcnoOJ2Kv/wRzV7gaeDkDmyZQ=;
        b=KDH1oST/AiaJHfrLYMayk+iaWXCj9iTxFERlgdeUB03jl/+nfweM5fzOIq8/qjW08r
         3Fj9imjyG3zRV9STnTobKyogHyXmWveRTF4GF4xagV61AHpplVxFI5Y6xaMHgxAaykhW
         ws3hZc9n0E3Ro2t3IZkwttto2+eI3UteEWiaM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rYw/iw5eqrvTTFbNpKOcnoOJ2Kv/wRzV7gaeDkDmyZQ=;
        b=Vo7mkPMVie8g6oZyaHknVLb8W39LP5lvwUajT2VR0KLabJFhExFrjtGEYP/vxVEzmH
         FGKtvZG/l4fN4wuARG0JkvyvDcLXEWibAZLwh3LCsdfTR/pgRZ7+pOM/nJQKd+sgKLAu
         Qi5SBZEqQWOdJxiw0NXUd/cC3g+vuk+lIm7kIZ5/TImSzNMKaVrRLWkMZtRmWJdYQ1qQ
         D8tkBh5jd9qkmTbUr7rSfg7oi4iI839r6+S0hfa2ZUwgGPTVkhojWcxGOx/ojQ/yA1pG
         hCzuZTPkO1SIKv1JJMJ9wiH7dGGWvwRNROf2wg15lHcBuqmx094md5nwXpupAZcWdpC5
         vTlQ==
X-Gm-Message-State: AOAM533OFFZIJVKx3ma08v2QFgun9lifHesKoZKaFruo6P581PJbwjKb
	zFKWnDmUDbF/NHdKZb7B0lI0gA10dRwBbMz+
X-Google-Smtp-Source: ABdhPJy6mXAfAyqce1LLg376bCf31xBhMClLpKYQBNEizHWcaTQwpPwInjz4gKdc38nKlOupKSDSiA==
X-Received: by 2002:a17:907:7baa:b0:6fe:b3dc:2378 with SMTP id ne42-20020a1709077baa00b006feb3dc2378mr13590376ejc.266.1653322757582;
        Mon, 23 May 2022 09:19:17 -0700 (PDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id kj20-20020a170907765400b006f3ef214e13sm2659974ejc.121.2022.05.23.09.19.17
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 09:19:17 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id p10so3484506wrg.12
        for <patches@lists.linux.dev>; Mon, 23 May 2022 09:19:16 -0700 (PDT)
X-Received: by 2002:a05:6000:1548:b0:20f:c4e3:637a with SMTP id
 8-20020a056000154800b0020fc4e3637amr10495998wry.513.1653322756477; Mon, 23
 May 2022 09:19:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220520143502.v4.1.I71e42c6174f1cec17da3024c9f73ba373263b9b6@changeid>
 <20220520143502.v4.5.Ie8713bc0377672ed8dd71189e66fc0b77226fb85@changeid> <a2bcac04-23ad-d1ae-84f1-924c4dbad42b@linaro.org>
In-Reply-To: <a2bcac04-23ad-d1ae-84f1-924c4dbad42b@linaro.org>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 23 May 2022 09:19:03 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WgYbD9GN_wiR29ikZMzEjKUSZGH588+nnyd3O-dNgChQ@mail.gmail.com>
Message-ID: <CAD=FV=WgYbD9GN_wiR29ikZMzEjKUSZGH588+nnyd3O-dNgChQ@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] dt-bindings: arm: qcom: Add more sc7180 Chromebook
 board bindings
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, 
	Matthias Kaehlcke <mka@chromium.org>, Alexandru M Stan <amstan@chromium.org>, patches@lists.linux.dev, 
	linux-arm-msm <linux-arm-msm@vger.kernel.org>, Julius Werner <jwerner@chromium.org>, 
	Andy Gross <agross@kernel.org>, Stephen Boyd <swboyd@chromium.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Rajendra Nayak <quic_rjendra@quicinc.com>, 
	"Joseph S . Barrera III" <joebar@chromium.org>, 
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, Stephen Boyd <sboyd@codeaurora.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Sun, May 22, 2022 at 1:01 AM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 20/05/2022 23:38, Douglas Anderson wrote:
> > This adds board bindings for boards that are downstream but not quite
> > upstream yet.
> >
> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
> > ---
> > Normally this bindings doc would go together in the same series that
> > adds the device trees. In this case, Joe has been sending patches
> > supporting these Chromebooks. His most recent posting is:
> >
> > https://lore.kernel.org/r/20220510154406.v5.1.Id769ddc5dbf570ccb511db96da59f97d08f75a9c@changeid/
> >
> > If he were to add this patch to the end of his v6, however, it would
> > make things a bit more complicated simply becuase it would cause
> > conflicts with all the other patches in this series. ...so steady
> > state it would be correct to keep it in the series with the device
> > tree files, but for this one time I think it makes sense to keep all
> > the Chromebook board bindings patches together.
> >
> > (no changes since v2)
> >
> > Changes in v2:
> > - Use a "description" instead of a comment for each item.
> > - Use the marketing name instead of the code name where possible.
> >
> >  .../devicetree/bindings/arm/qcom.yaml         | 92 +++++++++++++++++++
> >  1 file changed, 92 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
> > index 3d150d1a93cd..277faf59db57 100644
> > --- a/Documentation/devicetree/bindings/arm/qcom.yaml
> > +++ b/Documentation/devicetree/bindings/arm/qcom.yaml
> > @@ -263,6 +263,16 @@ properties:
> >            - const: google,homestar
> >            - const: qcom,sc7180
> >
> > +      - description: Google Kingoftown (rev0)
> > +        items:
> > +          - const: google,kingoftown-rev0
> > +          - const: qcom,sc7180
> > +
> > +      - description: Google Kingoftown (newest rev)
> > +        items:
> > +          - const: google,kingoftown
> > +          - const: qcom,sc7180
> > +
> >        - description: Acer Chromebook Spin 513 (rev0)
> >          items:
> >            - const: google,lazor-rev0
> > @@ -364,6 +374,48 @@ properties:
> >            - const: google,lazor-sku6
> >            - const: qcom,sc7180
> >
> > +      - description: Google Mrbland with AUO panel (rev0)
> > +        items:
> > +          - const: google,mrbland-rev0-sku0
> > +          - const: qcom,sc7180
> > +
> > +      - description: Google Mrbland with AUO panel (newest rev)
> > +        items:
> > +          - const: google,mrbland-sku1536
> > +          - const: qcom,sc7180
> > +
> > +      - description: Google Mrbland with BOE panel (rev0)
> > +        items:
> > +          - const: google,mrbland-rev0-sku16
>
> Similar question to patch #3, this could be:
>
>
> +      - description: Google Mrbland
> +        items:
> +          - enum:
> +              - google,mrbland-rev0-sku0     # AUO panel (rev0)
> +              - google,mrbland-rev0-sku16    # BOE panel (rev0)
> +          - const: qcom,sc7180
>
> and the file gets smaller and easier to read.

Ah, I guess this answers the question of the description that I asked
in the previous patch. Of course, this goes opposite of the feedback I
got from Stephen in previous versions of the patch where he requested
that I use "description" instead of comments for things. ;-)

In any case, for now I'll hold off waiting for other opinions here
since I still feel that the "one entry per dts" is easier to read /
reason about.

-Doug
