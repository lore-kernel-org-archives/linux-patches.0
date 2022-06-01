Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0E63D7B
	for <patches@lists.linux.dev>; Wed,  1 Jun 2022 23:26:17 +0000 (UTC)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-e93bbb54f9so4692074fac.12
        for <patches@lists.linux.dev>; Wed, 01 Jun 2022 16:26:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iJNKOO8QXxNlzBsifQjmX9tXu38uHaRGSzPFyqrc1yQ=;
        b=gU66ky09CBNMRceWW/UGizBfmE93gdRinrrzty1NstHAKmgrJW1d1k1e8Yllv4uXsb
         ve64PwOV2ODOxEKmjumaxfKThgHR1H80E3Z0H8mqor8gjaD+RuS4cyn4TrUUHHxM3BDL
         ULNlj5CaskxrfBJb7+oqQpQDbPwWgt0QNQru+S0Gd2fhCLG7d3lJCcvksgrzB2DNmDb0
         1JKejyKMTDPGqlczUSWuVmxQQfT6ktwoLzroIv12uZOJ4jX9SsCDqYZfgj4ZiyE71P8p
         lZ0kxr8mgKEOkbZdk4J81CQbFXXZ114IxocEiitCTO17KyNcEXpy6D14YNkN9clvdrhH
         9OlA==
X-Gm-Message-State: AOAM532mhyVU6DuwYLPCp6jOCds7wcfStejT/w4kAVa+aCOYkmBpTWZy
	HDHlQRYzHWbu2Tu5E4IsmA==
X-Google-Smtp-Source: ABdhPJw3v7nw/3t83l1+7RJSfsRWFO4E+ExNjYFS+gxyafxmeK1J23WekAZMJNOwY6C3Vq+Zc76yrw==
X-Received: by 2002:a05:6870:548f:b0:f5:dc08:f12c with SMTP id f15-20020a056870548f00b000f5dc08f12cmr1252754oan.12.1654125976450;
        Wed, 01 Jun 2022 16:26:16 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id t9-20020a056870600900b000f5f4ad194bsm719784oaa.25.2022.06.01.16.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 16:26:15 -0700 (PDT)
Received: (nullmailer pid 696078 invoked by uid 1000);
	Wed, 01 Jun 2022 23:26:14 -0000
Date: Wed, 1 Jun 2022 18:26:14 -0500
From: Rob Herring <robh@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Matthias Kaehlcke <mka@chromium.org>, Alexandru M Stan <amstan@chromium.org>, patches@lists.linux.dev, linux-arm-msm <linux-arm-msm@vger.kernel.org>, Julius Werner <jwerner@chromium.org>, Andy Gross <agross@kernel.org>, Stephen Boyd <swboyd@chromium.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Rajendra Nayak <quic_rjendra@quicinc.com>, "Joseph S . Barrera III" <joebar@chromium.org>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, Stephen Boyd <sboyd@codeaurora.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 5/5] dt-bindings: arm: qcom: Add more sc7180
 Chromebook board bindings
Message-ID: <20220601232614.GA504337-robh@kernel.org>
References: <20220520143502.v4.1.I71e42c6174f1cec17da3024c9f73ba373263b9b6@changeid>
 <20220520143502.v4.5.Ie8713bc0377672ed8dd71189e66fc0b77226fb85@changeid>
 <a2bcac04-23ad-d1ae-84f1-924c4dbad42b@linaro.org>
 <CAD=FV=WgYbD9GN_wiR29ikZMzEjKUSZGH588+nnyd3O-dNgChQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=WgYbD9GN_wiR29ikZMzEjKUSZGH588+nnyd3O-dNgChQ@mail.gmail.com>

On Mon, May 23, 2022 at 09:19:03AM -0700, Doug Anderson wrote:
> Hi,
> 
> On Sun, May 22, 2022 at 1:01 AM Krzysztof Kozlowski
> <krzysztof.kozlowski@linaro.org> wrote:
> >
> > On 20/05/2022 23:38, Douglas Anderson wrote:
> > > This adds board bindings for boards that are downstream but not quite
> > > upstream yet.
> > >
> > > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > > Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
> > > ---
> > > Normally this bindings doc would go together in the same series that
> > > adds the device trees. In this case, Joe has been sending patches
> > > supporting these Chromebooks. His most recent posting is:
> > >
> > > https://lore.kernel.org/r/20220510154406.v5.1.Id769ddc5dbf570ccb511db96da59f97d08f75a9c@changeid/
> > >
> > > If he were to add this patch to the end of his v6, however, it would
> > > make things a bit more complicated simply becuase it would cause
> > > conflicts with all the other patches in this series. ...so steady
> > > state it would be correct to keep it in the series with the device
> > > tree files, but for this one time I think it makes sense to keep all
> > > the Chromebook board bindings patches together.
> > >
> > > (no changes since v2)
> > >
> > > Changes in v2:
> > > - Use a "description" instead of a comment for each item.
> > > - Use the marketing name instead of the code name where possible.
> > >
> > >  .../devicetree/bindings/arm/qcom.yaml         | 92 +++++++++++++++++++
> > >  1 file changed, 92 insertions(+)
> > >
> > > diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
> > > index 3d150d1a93cd..277faf59db57 100644
> > > --- a/Documentation/devicetree/bindings/arm/qcom.yaml
> > > +++ b/Documentation/devicetree/bindings/arm/qcom.yaml
> > > @@ -263,6 +263,16 @@ properties:
> > >            - const: google,homestar
> > >            - const: qcom,sc7180
> > >
> > > +      - description: Google Kingoftown (rev0)
> > > +        items:
> > > +          - const: google,kingoftown-rev0
> > > +          - const: qcom,sc7180
> > > +
> > > +      - description: Google Kingoftown (newest rev)
> > > +        items:
> > > +          - const: google,kingoftown
> > > +          - const: qcom,sc7180
> > > +
> > >        - description: Acer Chromebook Spin 513 (rev0)
> > >          items:
> > >            - const: google,lazor-rev0
> > > @@ -364,6 +374,48 @@ properties:
> > >            - const: google,lazor-sku6
> > >            - const: qcom,sc7180
> > >
> > > +      - description: Google Mrbland with AUO panel (rev0)
> > > +        items:
> > > +          - const: google,mrbland-rev0-sku0
> > > +          - const: qcom,sc7180
> > > +
> > > +      - description: Google Mrbland with AUO panel (newest rev)
> > > +        items:
> > > +          - const: google,mrbland-sku1536
> > > +          - const: qcom,sc7180
> > > +
> > > +      - description: Google Mrbland with BOE panel (rev0)
> > > +        items:
> > > +          - const: google,mrbland-rev0-sku16
> >
> > Similar question to patch #3, this could be:
> >
> >
> > +      - description: Google Mrbland
> > +        items:
> > +          - enum:
> > +              - google,mrbland-rev0-sku0     # AUO panel (rev0)
> > +              - google,mrbland-rev0-sku16    # BOE panel (rev0)
> > +          - const: qcom,sc7180
> >
> > and the file gets smaller and easier to read.
> 
> Ah, I guess this answers the question of the description that I asked
> in the previous patch. Of course, this goes opposite of the feedback I
> got from Stephen in previous versions of the patch where he requested
> that I use "description" instead of comments for things. ;-)
> 
> In any case, for now I'll hold off waiting for other opinions here
> since I still feel that the "one entry per dts" is easier to read /
> reason about.

I leave it to the sub-arch maintainers to decide. I somewhat prefer as 
Krzysztof suggested. Some platforms (and most of the ones I converted) 
all the boards for an SoC are one entry (except for the 3 string cases). 
So the above looks like a good middle ground grouping revs or variations 
of boards.

Rob
