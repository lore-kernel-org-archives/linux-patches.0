Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD86258E
	for <patches@lists.linux.dev>; Mon, 23 May 2022 16:24:34 +0000 (UTC)
Received: by mail-ej1-f48.google.com with SMTP id gi33so21439222ejc.3
        for <patches@lists.linux.dev>; Mon, 23 May 2022 09:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G7LMHKesunD0Xjsfifj+i4ChGcHMQrcfYbEuTuPQdfY=;
        b=aj6E5qsVJYrGiJvSGurWbMCeqmRehL8+I2dJOljymHvfaN/8tZM1uY41O6LWstvuGE
         K6tFibZ5ifzLAcNKtIapH6gQEeMhnymx1+Bivy/FeBsTD1qK9lJ2MM9O8SPZY+xLNPnZ
         r2S2qwTO37YLvZamYaYQC5uMgCV+R9PuoP834=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G7LMHKesunD0Xjsfifj+i4ChGcHMQrcfYbEuTuPQdfY=;
        b=MCrm3JgGcQ2MecWp5edD8At+xwS3CUR7SFAK0dTRHdA3jkSMuUbZZ4kztnUvA6q7lu
         jjMxU8fAnNTPzo5WKK74piNYCzffJKAk9M5wD8BQugn6W2Ak9Xz+1rpVMEX0vUwZ2xDf
         NhSyerrmb9iZ8WVWyit0JChbs6qKEigSjEifOucG9NaayyUHQnODw8zmyk/zTI1r7CEF
         qzgkvuWBkhZgd4l4NV86UTUHg6kX+eFCQkQYgee/vf70iLI/wpAuW4NLy30NYcFaYZ9a
         IQRTKzfxDmpGXpFecpb7/8qgId8puC36J24JMUXF5ZEnkMY8jXBuu9kAcKOgEq3s6FSC
         DjcA==
X-Gm-Message-State: AOAM532tsZcZBvaBs4h2ndITHOc9opxcKqMg70tyzGw5D6anh77eMoTQ
	MdH8YtgyLJdtZBHvhFSZOAA3K9nEalJcD3nN
X-Google-Smtp-Source: ABdhPJxzzHhdq6rhCdNCIO/iWMgL8qOW3HG/yHqDweXTox6lODJVgY8YnyIoTLoATWp7JbIrS+xKyA==
X-Received: by 2002:a17:907:a40b:b0:6fe:7c67:2210 with SMTP id sg11-20020a170907a40b00b006fe7c672210mr20235282ejc.341.1653323071991;
        Mon, 23 May 2022 09:24:31 -0700 (PDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com. [209.85.128.45])
        by smtp.gmail.com with ESMTPSA id ra48-20020a17090769b000b006fe9a2874cdsm4851245ejc.103.2022.05.23.09.24.31
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 09:24:31 -0700 (PDT)
Received: by mail-wm1-f45.google.com with SMTP id r6-20020a1c2b06000000b00396fee5ebc9so8873301wmr.1
        for <patches@lists.linux.dev>; Mon, 23 May 2022 09:24:31 -0700 (PDT)
X-Received: by 2002:a05:600c:3d8c:b0:394:6097:9994 with SMTP id
 bi12-20020a05600c3d8c00b0039460979994mr20836726wmb.29.1653322607614; Mon, 23
 May 2022 09:16:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220520143502.v4.1.I71e42c6174f1cec17da3024c9f73ba373263b9b6@changeid>
 <20220520143502.v4.3.I9804fcd5d6c8552ab25f598dd7a3ea71b15b55f0@changeid> <7c1598a9-476d-0115-ab13-11dfa0d89436@linaro.org>
In-Reply-To: <7c1598a9-476d-0115-ab13-11dfa0d89436@linaro.org>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 23 May 2022 09:16:34 -0700
X-Gmail-Original-Message-ID: <CAD=FV=UC+eFZaUiPQNKBMmLmjx21YpH4Yeg3Yz9NiDLXnh+nDg@mail.gmail.com>
Message-ID: <CAD=FV=UC+eFZaUiPQNKBMmLmjx21YpH4Yeg3Yz9NiDLXnh+nDg@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] dt-bindings: arm: qcom: Add sc7180 Chromebook
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

On Sun, May 22, 2022 at 12:57 AM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 20/05/2022 23:38, Douglas Anderson wrote:
> > This copy-pastes compatibles from sc7180-based boards from the device
> > trees to the yaml file so that `make dtbs_check` will be happy.
> >
> > NOTES:
> > - I make no attempt to try to share an "item" for all sc7180 based
> >   Chromebooks. Because of the revision matching scheme used by the
> >   Chromebook bootloader, at times we need a different number of
> >   revisions listed.
> > - Some of the odd entries in here (like google,homestar-rev23 or the
> >   fact that "Google Lazor Limozeen without Touchscreen" changed from
> >   sku5 to sku6) are not typos but simply reflect reality.
> > - Many revisions of boards here never actually went to consumers, but
> >   they are still in use within various companies that were involved in
> >   Chromebook development. Since Chromebooks are developed with an
> >   "upstream first" methodology, having these revisions supported with
> >   upstream Linux is important. Making it easy for Chromebooks to be
> >   developed with an "upstream first" methodology is valuable to the
> >   upstream community because it improves the quality of upstream and
> >   gets Chromebooks supported with vanilla upstream faster.
> >
> > One other note here is that, though the bootloader effectively treats
> > the list of compatibles in a given device tree as unordered, some
> > people would prefer future boards to list higher-numbered revisions
> > first in the list. Chromebooks here are not changing and typically
> > list lower revisions first just to avoid churn.
> >
> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
> > ---
> >
> > (no changes since v3)
> >
> > Changes in v3:
> > - Split link to Chromebook boot doc into a separate patch.
> > - Added a note to desc about revision ordering within a device tree.
> >
> > Changes in v2:
> > - Add link to doc about how Chromebook devicetrees work.
> > - Use a "description" instead of a comment for each item.
> > - Use the marketing name instead of the code name where possible.
> >
> >  .../devicetree/bindings/arm/qcom.yaml         | 182 +++++++++++++++++-
> >  1 file changed, 181 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
> > index 5ac28e11ea7b..01e40ea40724 100644
> > --- a/Documentation/devicetree/bindings/arm/qcom.yaml
> > +++ b/Documentation/devicetree/bindings/arm/qcom.yaml
> > @@ -219,11 +219,191 @@ properties:
> >                - qcom,ipq8074-hk10-c2
> >            - const: qcom,ipq8074
> >
> > -      - items:
> > +      - description: Qualcomm Technologies, Inc. SC7180 IDP
> > +        items:
> >            - enum:
> >                - qcom,sc7180-idp
> >            - const: qcom,sc7180
> >
> > +      - description: HP Chromebook x2 11c (rev1 - 2)
> > +        items:
> > +          - const: google,coachz-rev1
> > +          - const: google,coachz-rev2
> > +          - const: qcom,sc7180
> > +
> > +      - description: HP Chromebook x2 11c (newest rev)
> > +        items:
> > +          - const: google,coachz
> > +          - const: qcom,sc7180
> > +
> > +      - description: HP Chromebook x2 11c with LTE (rev1 - 2)
> > +        items:
> > +          - const: google,coachz-rev1-sku0
> > +          - const: google,coachz-rev2-sku0
> > +          - const: qcom,sc7180
> > +
> > +      - description: HP Chromebook x2 11c with LTE (newest rev)
> > +        items:
> > +          - const: google,coachz-sku0
> > +          - const: qcom,sc7180
> > +
> > +      - description: Lenovo Chromebook Duet 5 13 (rev2)
> > +        items:
> > +          - const: google,homestar-rev2
> > +          - const: google,homestar-rev23
> > +          - const: qcom,sc7180
> > +
> > +      - description: Lenovo Chromebook Duet 5 13 (rev3)
> > +        items:
> > +          - const: google,homestar-rev3
> > +          - const: qcom,sc7180
> > +
> > +      - description: Lenovo Chromebook Duet 5 13 (newest rev)
> > +        items:
> > +          - const: google,homestar
> > +          - const: qcom,sc7180
> > +
> > +      - description: Acer Chromebook Spin 513 (rev0)
> > +        items:
> > +          - const: google,lazor-rev0
> > +          - const: qcom,sc7180
> > +
> > +      - description: Acer Chromebook Spin 513 (rev1 - 2)
> > +        items:
> > +          - const: google,lazor-rev1
> > +          - const: google,lazor-rev2
> > +          - const: qcom,sc7180
> > +
> > +      - description: Acer Chromebook Spin 513 (rev3 - 8)
> > +        items:
> > +          - const: google,lazor-rev3
> > +          - const: google,lazor-rev4
> > +          - const: google,lazor-rev5
> > +          - const: google,lazor-rev6
> > +          - const: google,lazor-rev7
> > +          - const: google,lazor-rev8
> > +          - const: qcom,sc7180
> > +
> > +      - description: Acer Chromebook Spin 513 (newest rev)
> > +        items:
> > +          - const: google,lazor
> > +          - const: qcom,sc7180
> > +
> > +      - description: Acer Chromebook Spin 513 with KB Backlight (rev1 - 2)
> > +        items:
> > +          - const: google,lazor-rev1-sku2
> > +          - const: google,lazor-rev2-sku2
> > +          - const: qcom,sc7180
> > +
> > +      - description: Acer Chromebook Spin 513 with KB Backlight (rev3 - 8)
> > +        items:
> > +          - const: google,lazor-rev3-sku2
> > +          - const: google,lazor-rev4-sku2
> > +          - const: google,lazor-rev5-sku2
> > +          - const: google,lazor-rev6-sku2
> > +          - const: google,lazor-rev7-sku2
> > +          - const: google,lazor-rev8-sku2
> > +          - const: qcom,sc7180
> > +
> > +      - description: Acer Chromebook Spin 513 with KB Backlight (newest rev)
> > +        items:
> > +          - const: google,lazor-sku2
> > +          - const: qcom,sc7180
> > +
> > +      - description: Acer Chromebook Spin 513 with LTE (rev1 - 2)
> > +        items:
> > +          - const: google,lazor-rev1-sku0
> > +          - const: google,lazor-rev2-sku0
> > +          - const: qcom,sc7180
> > +
> > +      - description: Acer Chromebook Spin 513 with LTE (rev3 - 8)
> > +        items:
> > +          - const: google,lazor-rev3-sku0
> > +          - const: google,lazor-rev4-sku0
> > +          - const: google,lazor-rev5-sku0
> > +          - const: google,lazor-rev6-sku0
> > +          - const: google,lazor-rev7-sku0
> > +          - const: google,lazor-rev8-sku0
> > +          - const: qcom,sc7180
> > +
> > +      - description: Acer Chromebook Spin 513 with LTE (newest rev)
> > +        items:
> > +          - const: google,lazor-sku0
> > +          - const: qcom,sc7180
> > +
> > +      - description: Acer Chromebook 511 (rev4 - rev8)
> > +        items:
> > +          - const: google,lazor-rev4-sku4
> > +          - const: google,lazor-rev5-sku4
> > +          - const: google,lazor-rev6-sku4
> > +          - const: google,lazor-rev7-sku4
> > +          - const: google,lazor-rev8-sku4
> > +          - const: qcom,sc7180
> > +
> > +      - description: Acer Chromebook 511 (newest rev)
> > +        items:
> > +          - const: google,lazor-sku4
> > +          - const: qcom,sc7180
> > +
> > +      - description: Acer Chromebook 511 without Touchscreen (rev4)
> > +        items:
> > +          - const: google,lazor-rev4-sku5
> > +          - const: qcom,sc7180
> > +
> > +      - description: Acer Chromebook 511 without Touchscreen (rev5 - rev8)
> > +        items:
> > +          - const: google,lazor-rev5-sku5
> > +          - const: google,lazor-rev5-sku6
> > +          - const: google,lazor-rev6-sku6
> > +          - const: google,lazor-rev7-sku6
> > +          - const: google,lazor-rev8-sku6
> > +          - const: qcom,sc7180
> > +
> > +      - description: Acer Chromebook 511 without Touchscreen (newest rev)
> > +        items:
> > +          - const: google,lazor-sku6
> > +          - const: qcom,sc7180
> > +
> > +      - description: Sharp Dynabook Chromebook C1 (rev1)
> > +        items:
> > +          - const: google,pompom-rev1
> > +          - const: qcom,sc7180
> > +
> > +      - description: Sharp Dynabook Chromebook C1 (rev2)
> > +        items:
> > +          - const: google,pompom-rev2
>
> I understand why you do not share "item" (your first notes) for some of
> boards, but I don't get why "google,pompom-rev1" cannot be combined with
> "google,pompom-rev2". Do you see any chances to alter the bindings for
> these two boards?
>
> The same for other such cases (not newest revision).

Yeah, I thought about it when I was writing the file and decided
against it. I guess it's just a style decision. If we combine these
two then I guess it raises the question: do we only combine entries
that list a single revision if they're the same board, or do we have
one uber entry at the end of the list that combines all
single-revision sc7180 Chromebooks? ...and in either case, what should
the description be?

Personally, though it takes up more lines of code, I prefer the
simplicity of having each entry here correspond to a single dts file.

Unless you feel really strongly about it, I'd tend to leave the
decision here to Bjorn.

-Doug
