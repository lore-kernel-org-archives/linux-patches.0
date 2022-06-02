Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4B13D65
	for <patches@lists.linux.dev>; Thu,  2 Jun 2022 20:08:30 +0000 (UTC)
Received: by mail-ej1-f42.google.com with SMTP id s6so473798eja.0
        for <patches@lists.linux.dev>; Thu, 02 Jun 2022 13:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qgACnyK4+wOiS5MKuMTnoonRsVlmK8PYmGJQJvcgO6E=;
        b=gCNQf5treIeOY896E1dwCdHz3vHIg34Tiv2t6JPnU8eRhXoHeu6+4L3Uh/UmmoSB4J
         frLhr+7HqIhSw29Lu1hlJ8Fl7ddyJgm7PH15YadqhbxolK5DpD9Oozcz3nAx9uaLJYZl
         w+l3zgS2iBUS4NjgZcWirSTVwqmGjn+NPH/cw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qgACnyK4+wOiS5MKuMTnoonRsVlmK8PYmGJQJvcgO6E=;
        b=oZ+FKjBzxsGpq6FcAaf2750qxH8lfixGyf9aE37aQYaiAxL/1YF8za+TefBwuoCh55
         sR+UxbF1Q97D9+1kLpVh3GN24O3Oa2FTetTsJgHHKuJkVRyue32FHY/skAlZgk7U3Utr
         o7p5t2MQS1gG5y7qdixuw3GPrLijByi8MkFYf8oOh2euiFkiRFf2pKI1iragzHrY+PFo
         c6zwLY7uvjikVexXhqemZnXI8h7w7R34JAvr/nnBmCyZdiOS6r9O37OJT9edYf7EKiDg
         vb2+PyoCmFvc5yGI/0KejtY/a5fswqeILtlrzC5UIesElA5BRXPgXJxNDIuzPescgNVy
         EauA==
X-Gm-Message-State: AOAM532RT0+QurYzEXzhGMG9IicFK+W1sm+uSTLHems8pRWg84jch+7u
	dHdXSy4v/vWKf2zyhthDDxKFt4606QyxRQ==
X-Google-Smtp-Source: ABdhPJwv5Lvfx57teRzjLMuT3yosfNtn8SADBVBeXbhwoCxmIkoXCIhLJ56ubFh/abnFYQEkdkAbdw==
X-Received: by 2002:a17:907:9810:b0:6fe:90ca:e730 with SMTP id ji16-20020a170907981000b006fe90cae730mr5555582ejc.549.1654200508415;
        Thu, 02 Jun 2022 13:08:28 -0700 (PDT)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com. [209.85.221.53])
        by smtp.gmail.com with ESMTPSA id b5-20020a17090691c500b006feaa22e367sm2037258ejx.165.2022.06.02.13.08.27
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jun 2022 13:08:27 -0700 (PDT)
Received: by mail-wr1-f53.google.com with SMTP id p10so7782683wrg.12
        for <patches@lists.linux.dev>; Thu, 02 Jun 2022 13:08:27 -0700 (PDT)
X-Received: by 2002:a5d:68d2:0:b0:210:31cc:64a6 with SMTP id
 p18-20020a5d68d2000000b0021031cc64a6mr4886531wrw.679.1654200506938; Thu, 02
 Jun 2022 13:08:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220602190621.1646679-1-swboyd@chromium.org>
In-Reply-To: <20220602190621.1646679-1-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Thu, 2 Jun 2022 13:08:14 -0700
X-Gmail-Original-Message-ID: <CAD=FV=X6702aSaEnpXUhF40b0kZuz1QvOBLNg-xcNDYbVCbsDw@mail.gmail.com>
Message-ID: <CAD=FV=X6702aSaEnpXUhF40b0kZuz1QvOBLNg-xcNDYbVCbsDw@mail.gmail.com>
Subject: Re: [PATCH v2] arm64: dts: qcom: Remove duplicate sc7180-trogdor
 include on lazor/homestar
To: Stephen Boyd <swboyd@chromium.org>
Cc: Andy Gross <agross@kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, 
	LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	linux-arm-msm <linux-arm-msm@vger.kernel.org>, 
	"Joseph S. Barrera III" <joebar@chromium.org>, Matthias Kaehlcke <mka@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Thu, Jun 2, 2022 at 12:06 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> The sc7180-trogdor-{lazor,homestar}-*.dtsi files all include
> sc7180-trogdor.dtsi and sc7180-trogdor-lazor.dtsi or
> sc7180-trogdor-homestar.dtsi, so including it here in the
> sc7180-trogdor-{lazor,homestar}.dtsi file means we have a duplicate
> include after commit 19794489fa24 ("arm64: dts: qcom: Only include
> sc7180.dtsi in sc7180-trogdor.dtsi"). We include the sc7180-trogdor.dtsi
> file in a board like sc7180-trogdor-lazor-r1.dts so that we can include
> the display bridge snippet (e.g. sc7180-trogdor-ti-sn65dsi86.dtsi)
> instead of making ever increasing variants like
> sc7180-trogdor-lazor-ti-sn65dsi86.dtsi.
>
> Unfortunately, having the double include like this means the display
> bridge's i2c bus is left disabled instead of enabled by the bridge
> snippet. Any boards that use the i2c bus for the display bridge will
> have the bus disabled when we include sc7180-trogdor.dtsi the second
> time, which picks up the i2c status="disabled" line from sc7180.dtsi.
> This leads to the display not turning on and black screens at boot on
> lazor and homestar devices.
>
> Fix this by dropping the include and making a note that the
> sc7180-trogdor-{lazor,homestar}.dtsi file must be included after
> sc7180-trogdor.dtsi
>
> Reported-by: Douglas Anderson <dianders@chromium.org>
> Cc: "Joseph S. Barrera III" <joebar@chromium.org>
> Cc: Matthias Kaehlcke <mka@chromium.org>
> Fixes: 19794489fa24 ("arm64: dts: qcom: Only include sc7180.dtsi in sc7180-trogdor.dtsi")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>
> It would be great to get this into -rc1 if possible to fix broken
> display.

Reviewed-by: Douglas Anderson <dianders@chromium.org>

I tested and this fixes the "no display" problem on Linus's tree on
both homestar and lazor.

Tested-by: Douglas Anderson <dianders@chromium.org>
