Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55860139F
	for <patches@lists.linux.dev>; Wed, 22 Jun 2022 13:51:23 +0000 (UTC)
Received: by mail-ej1-f47.google.com with SMTP id h23so34362359ejj.12
        for <patches@lists.linux.dev>; Wed, 22 Jun 2022 06:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1tMe+AiU8DKRx6/oa1fADyFtfsdt5zf5zus2rlM628Y=;
        b=WLrqEPTDWCxELbbCYBkNzQrlci4iuDiO0DU2ioBN9DwcW7jQ7pOE+5VP1zoWQnflXZ
         dTaN6XDGRWpJSvQIkolJpH6dMOgXlqqiGej5wPGxL+YAggm3OuMAv0cl4q4wDs6QtzrH
         M5G/FfnuufzkHuYqhYgUb2JRvxkQexCB3PTug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1tMe+AiU8DKRx6/oa1fADyFtfsdt5zf5zus2rlM628Y=;
        b=Qr4A+h+R8GzIXIm3kK+QGqe9q99acyF4XlCG/qFMDUC4ibgV0Zy4gA7N+rz6Kt7fqG
         0KyZB467QGzOJZf+M2pdVJuciRkpArOQ/AuW/zZHT5ML1Coyenyn+XHfIwmJ+L1nYSsd
         NRatA5O+pGt84yLSz48azdEMNzE/aOqR31SWYJd43LcpWYkLkNLXnxwn097BAJneDrl9
         CWv8kbDk5JKGRfQHkTBstpmEw7B3hQJ52l8fFNiPvSPiRSLjVtSdEkw8P9AXRDVXOhUm
         Wn7hK3jt7PYRM0v93NK+Ao/lbkiqosSYiD/HSETabSVSvd/GnyeCTx6Bpc4F9J8LC/d+
         YjxA==
X-Gm-Message-State: AJIora+EHdzgoQUaK8NNxG0sRXUktZmAcHpjX87MVKc1688vZS11qkLT
	vuVNMFEx+e3ZjlCtJ8SHG0GO2O4PRHImuw==
X-Google-Smtp-Source: AGRyM1vrLz1WgQBmkM3HJT11D6FzaRC5UevB+EU87xaqwBsbsFqgfPfBklWyHFTOI5Cx6T9YlRltrA==
X-Received: by 2002:a17:907:c002:b0:722:eeac:c8ee with SMTP id ss2-20020a170907c00200b00722eeacc8eemr3255911ejc.88.1655905881438;
        Wed, 22 Jun 2022 06:51:21 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id sd12-20020a1709076e0c00b00722e8c47cc9sm1887406ejc.181.2022.06.22.06.51.20
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 06:51:20 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id n1so23275882wrg.12
        for <patches@lists.linux.dev>; Wed, 22 Jun 2022 06:51:20 -0700 (PDT)
X-Received: by 2002:a05:6000:1c0d:b0:216:c9f4:2b83 with SMTP id
 ba13-20020a0560001c0d00b00216c9f42b83mr3489538wrb.405.1655905879653; Wed, 22
 Jun 2022 06:51:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220520143502.v4.1.I71e42c6174f1cec17da3024c9f73ba373263b9b6@changeid>
 <20220520143502.v4.4.I1318c1ae2ce55ade1d092fc21df846360b15c560@changeid> <e5a7367b-af35-b382-0f2a-e68fe07a4123@linaro.org>
In-Reply-To: <e5a7367b-af35-b382-0f2a-e68fe07a4123@linaro.org>
From: Doug Anderson <dianders@chromium.org>
Date: Wed, 22 Jun 2022 06:51:07 -0700
X-Gmail-Original-Message-ID: <CAD=FV=V9nfJq0_Xvfwid8ev1m9zW2n0zRPSo6fPepHOks8E=PA@mail.gmail.com>
Message-ID: <CAD=FV=V9nfJq0_Xvfwid8ev1m9zW2n0zRPSo6fPepHOks8E=PA@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] dt-bindings: arm: qcom: Add / fix sc7280 board bindings
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

On Wed, Jun 22, 2022 at 1:27 AM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 20/05/2022 23:38, Douglas Anderson wrote:
> > This copy-pastes compatibles from sc7280-based boards from the device
> > trees to the yaml file. It also fixes the CRD/IDP bindings which had
> > gotten stale.
> >
> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
> > Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > ---
> > It should be noted that these match the sc7280 boards as of the top of
> > the "for-next" branch of the tree
> > git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git
> >
> > (no changes since v2)
> >
> > Changes in v2:
> > - Use a "description" instead of a comment for each item.
>
> What's the plan for these patches? This is one was reviewed, the 5/5 had
> comments. Is there going to be resend or pick up?
>
> Some other folks work depends on this.

I thought patch 5/5 was waiting on Bjorn to say whether he wanted a
change or was happy the way it was.

In general this series, like all of the Qualcomm dts patches at the
moment, is blocked waiting for Bjorn to have time to land things. I'm
assuming that if Bjorn wants the 5th patch changed then he will still
land the first 4 patches and then I can make changes to 5/5 and send
it as a standalone patch.

-Doug
