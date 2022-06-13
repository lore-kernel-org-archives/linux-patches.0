Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E407A
	for <patches@lists.linux.dev>; Mon, 13 Jun 2022 22:19:54 +0000 (UTC)
Received: by mail-ej1-f53.google.com with SMTP id n10so13732452ejk.5
        for <patches@lists.linux.dev>; Mon, 13 Jun 2022 15:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iiyBV98F9xICzYyJTkP6FjyBl5T6Mi+mUKFDOCM92KU=;
        b=klyXrSi658IJdvf/FimbWgaAprMRP4Gl89sPeMRWaYsKtTIDlGXNU84jXtksjGeKuZ
         YN9DZqiH7mqKnbYfiYAjbb9DY3FfRyVIIjHjdvbZi1N9Vlffy8nv8b1GWSGUVT4q76wg
         yITIyKDsl8jEx4zN2uftjpdy0R/hCB2jOH9eg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iiyBV98F9xICzYyJTkP6FjyBl5T6Mi+mUKFDOCM92KU=;
        b=slSWjLEmkq91/0gC7gQ27nRimzZS+Mv/DB15GW0ssDP1Ge91kYlGUZR4LKc17T2AEl
         vpvdbyTm0z+L0vqnBB7PNbyrRUK4CY5LD3qrwqguKQQ6EEW45vpMf0xHgUcyZ7An50Es
         zwSsav+hdnCHVUEEojywhZxQwBURi57QMQhGsFh3ArLj34stDT8iIZewLFRUq7tK2t/k
         vLmX0J0/C8gls5BgdQ0t1dNKfNpHLHW+szTOmQpA2u5lvn3Bt4jAA7QKhLQo0iv9ku4X
         iy/XMT8UE1N5IgX3eW227WWgsJNqVxTCE0pG9a/Jgv7kOJ9yauBdPz3yPwJQEDzfGeH8
         e/Lw==
X-Gm-Message-State: AOAM533sSFHWMET5eeeiIaQqIJoRwAmFpxe0CFMbnR127L1LMroiE2sr
	87g9A8pemxbH2dzKCuDkwNJT7o0v2n5MPA==
X-Google-Smtp-Source: ABdhPJxt2fvxi4xsNRUnHTU3DihHWuPnBVBhk6kK1GbZyqshYzLjURFrzBye7k8WVag9XldnYpHiXg==
X-Received: by 2002:a17:907:6d12:b0:711:d524:8c88 with SMTP id sa18-20020a1709076d1200b00711d5248c88mr1603317ejc.615.1655158792274;
        Mon, 13 Jun 2022 15:19:52 -0700 (PDT)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com. [209.85.128.49])
        by smtp.gmail.com with ESMTPSA id z15-20020aa7cf8f000000b004307c8e1c3fsm5694089edx.34.2022.06.13.15.19.51
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 15:19:51 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id m39-20020a05600c3b2700b0039c511ebbacso5279265wms.3
        for <patches@lists.linux.dev>; Mon, 13 Jun 2022 15:19:51 -0700 (PDT)
X-Received: by 2002:a05:600c:202:b0:39c:40de:ec19 with SMTP id
 2-20020a05600c020200b0039c40deec19mr852639wmi.29.1655158790748; Mon, 13 Jun
 2022 15:19:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220602190621.1646679-1-swboyd@chromium.org> <CAD=FV=X6702aSaEnpXUhF40b0kZuz1QvOBLNg-xcNDYbVCbsDw@mail.gmail.com>
In-Reply-To: <CAD=FV=X6702aSaEnpXUhF40b0kZuz1QvOBLNg-xcNDYbVCbsDw@mail.gmail.com>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 13 Jun 2022 15:19:38 -0700
X-Gmail-Original-Message-ID: <CAD=FV=UH35GLqzhCuJzqBX12BNw7m4hkF0qdCeAGxOwdnMVqmA@mail.gmail.com>
Message-ID: <CAD=FV=UH35GLqzhCuJzqBX12BNw7m4hkF0qdCeAGxOwdnMVqmA@mail.gmail.com>
Subject: Re: [PATCH v2] arm64: dts: qcom: Remove duplicate sc7180-trogdor
 include on lazor/homestar
To: Stephen Boyd <swboyd@chromium.org>
Cc: Andy Gross <agross@kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, 
	LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	linux-arm-msm <linux-arm-msm@vger.kernel.org>, 
	"Joseph S. Barrera III" <joebar@chromium.org>, Matthias Kaehlcke <mka@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Thu, Jun 2, 2022 at 1:08 PM Doug Anderson <dianders@chromium.org> wrote:
>
> Hi,
>
> On Thu, Jun 2, 2022 at 12:06 PM Stephen Boyd <swboyd@chromium.org> wrote:
> >
> > The sc7180-trogdor-{lazor,homestar}-*.dtsi files all include
> > sc7180-trogdor.dtsi and sc7180-trogdor-lazor.dtsi or
> > sc7180-trogdor-homestar.dtsi, so including it here in the
> > sc7180-trogdor-{lazor,homestar}.dtsi file means we have a duplicate
> > include after commit 19794489fa24 ("arm64: dts: qcom: Only include
> > sc7180.dtsi in sc7180-trogdor.dtsi"). We include the sc7180-trogdor.dtsi
> > file in a board like sc7180-trogdor-lazor-r1.dts so that we can include
> > the display bridge snippet (e.g. sc7180-trogdor-ti-sn65dsi86.dtsi)
> > instead of making ever increasing variants like
> > sc7180-trogdor-lazor-ti-sn65dsi86.dtsi.
> >
> > Unfortunately, having the double include like this means the display
> > bridge's i2c bus is left disabled instead of enabled by the bridge
> > snippet. Any boards that use the i2c bus for the display bridge will
> > have the bus disabled when we include sc7180-trogdor.dtsi the second
> > time, which picks up the i2c status="disabled" line from sc7180.dtsi.
> > This leads to the display not turning on and black screens at boot on
> > lazor and homestar devices.
> >
> > Fix this by dropping the include and making a note that the
> > sc7180-trogdor-{lazor,homestar}.dtsi file must be included after
> > sc7180-trogdor.dtsi
> >
> > Reported-by: Douglas Anderson <dianders@chromium.org>
> > Cc: "Joseph S. Barrera III" <joebar@chromium.org>
> > Cc: Matthias Kaehlcke <mka@chromium.org>
> > Fixes: 19794489fa24 ("arm64: dts: qcom: Only include sc7180.dtsi in sc7180-trogdor.dtsi")
> > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > ---
> >
> > It would be great to get this into -rc1 if possible to fix broken
> > display.
>
> Reviewed-by: Douglas Anderson <dianders@chromium.org>
>
> I tested and this fixes the "no display" problem on Linus's tree on
> both homestar and lazor.
>
> Tested-by: Douglas Anderson <dianders@chromium.org>

Given that this fixes problems in mainline, it would be keen to see it
land sooner rather than later. Is it blocked on anything?

Thanks!

-Doug
