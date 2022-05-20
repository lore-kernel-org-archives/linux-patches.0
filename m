Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3981233C3
	for <patches@lists.linux.dev>; Fri, 20 May 2022 22:16:21 +0000 (UTC)
Received: by mail-ej1-f51.google.com with SMTP id n13so16073277ejv.1
        for <patches@lists.linux.dev>; Fri, 20 May 2022 15:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xvie0QExXbdO9a6ZetpQ6DoZ8RHzFGI7AHEhn57vJjo=;
        b=b0LWh1jkiwtCTs7/NY5t9cERb0AJv432EorW/6rJ05w/AT0CTG5+oyybm3cf5ei2rH
         mUBjXpXoPNZ9pdd2a/OTiuTn0l25LBjH8JcvbQza4Hp0GCHknr9rLKGBVN0yFZ21sbVv
         KvyQap+JZT9Qt3hfwV4wMkZb/MBoSVAX2rvsY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xvie0QExXbdO9a6ZetpQ6DoZ8RHzFGI7AHEhn57vJjo=;
        b=miKY5RIFpx/enYJiJScjX9e8FZ9ocZeBylralt6bbzutI+O2WAmykHJxG25pBJhkeB
         +734tPYAsv400TqwTXVIYP7LUvDeu4poPlcoWMZw8ywGBYoQ2UQECJuYS8zGRSzBE4l0
         9O3yGnod27plOJ9Phb2nyvuzyyo3o48dVWX0pwzv4xjLXuriwSy5kq9kPiSs0IuTVs6M
         CzcNCjnM1OsiU+pFlwWl9S6VxMu9JaYd+XF4/4yfux476j1vr59EtvgotZ9RZbb3LULq
         RddvQ5QlxV23o4JWhOtqMm9woJsW2PEhh8R+z8WsugaBGTCgNSXE46d96qAt2Hi18Nmh
         /7lw==
X-Gm-Message-State: AOAM530d3oeC45QdqzNgOfwrroeyVWZxKLQEgpanGXnByH94VLXD3itL
	liTMshjmSRbpKZ0/tAdLIjVb24B/amlfTLp/dG8=
X-Google-Smtp-Source: ABdhPJxL+Ob59GosNB7sV6LyN3T2CnqbLznjkJd+ycvZ172KAsGMgOg6aOMFsGb0U+RiYIvDsoT2Sw==
X-Received: by 2002:a17:907:162b:b0:6fa:94f3:15d6 with SMTP id hb43-20020a170907162b00b006fa94f315d6mr10459827ejc.330.1653084979229;
        Fri, 20 May 2022 15:16:19 -0700 (PDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id er8-20020a170907738800b006f3ef214e45sm3567422ejc.171.2022.05.20.15.16.17
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 15:16:17 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id j25so13161251wrc.9
        for <patches@lists.linux.dev>; Fri, 20 May 2022 15:16:17 -0700 (PDT)
X-Received: by 2002:a05:6000:1548:b0:20f:c4e3:637a with SMTP id
 8-20020a056000154800b0020fc4e3637amr932134wry.513.1653084976906; Fri, 20 May
 2022 15:16:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220427020339.360855-1-swboyd@chromium.org> <20220427020339.360855-4-swboyd@chromium.org>
In-Reply-To: <20220427020339.360855-4-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Fri, 20 May 2022 15:16:03 -0700
X-Gmail-Original-Message-ID: <CAD=FV=VSMyJrs9bTE2XEC=q7VtZi6YKFaKJQJyLTZhVaYa9-Jg@mail.gmail.com>
Message-ID: <CAD=FV=VSMyJrs9bTE2XEC=q7VtZi6YKFaKJQJyLTZhVaYa9-Jg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] arm64: dts: qcom: Only include sc7180.dtsi in sc7180-trogdor.dtsi
To: Stephen Boyd <swboyd@chromium.org>
Cc: Andy Gross <agross@kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, 
	LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	linux-arm-msm <linux-arm-msm@vger.kernel.org>, 
	"Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Tue, Apr 26, 2022 at 7:03 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> The SoC is always present on sc7180-trogdor.dtsi and thus we should
> include it in the "generic" dtsi file for trogdor. Previously we had
> removed it from there because we had to do the spi6/spi0 swizzle, so
> each trogdor variant board had to include sc7180.dtsi and then
> sc7180-trogdor.dtsi so that the latter dtsi file could modify the right
> spi bus for EC and H1 properties that are common to all trogdor boards.
>
> Now that we're done with that we can replace sc7180.dtsi includes with
> sc7180-trogdor.dtsi and include sc7180.dtsi in sc7180-trogdor.dtsi as
> was originally intended. We still need to include sc7180-trogdor.dtsi
> before the bridge dtsi files though because those rely on the panel
> label.
>
> Cc: "Joseph S. Barrera III" <joebar@chromium.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi            | 1 -
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar-r2.dts        | 2 +-
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar-r3.dts        | 2 +-
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar-r4.dts        | 2 +-
>  .../boot/dts/qcom/sc7180-trogdor-lazor-limozeen-nots-r5.dts    | 2 +-
>  .../boot/dts/qcom/sc7180-trogdor-lazor-limozeen-nots-r9.dts    | 2 +-
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-r4.dts  | 2 +-
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-r9.dts  | 2 +-
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r0.dts           | 2 +-
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r1.dts           | 2 +-
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-kb.dts        | 2 +-
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-lte.dts       | 2 +-
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3.dts           | 2 +-
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-kb.dts        | 2 +-
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-lte.dts       | 2 +-
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9.dts           | 2 +-
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi            | 1 -
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts                 | 1 -
>  arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi                   | 3 ++-
>  19 files changed, 17 insertions(+), 19 deletions(-)

While reviewing a different change, I found something fishy and
tracked it down to ${SUBJECT} patch.

Specifically, after ${SUBJECT} patch then I run `git grep
include.*trogdor.dtsi`. When I do that, I see that
`sc7180-trogdor.dtsi` is double-included in all lazor devices. :( It's
included in the actual dts files and also in the lazor.dtsi file.

That's probably not right. I think we need to remove the one in the
lazor.dtsi file?

-Doug
