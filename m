Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E927C33C3
	for <patches@lists.linux.dev>; Fri, 20 May 2022 22:23:29 +0000 (UTC)
Received: by mail-ej1-f41.google.com with SMTP id ck4so13714489ejb.8
        for <patches@lists.linux.dev>; Fri, 20 May 2022 15:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wSe3xVUI2FvJ4kebDMAPMIferoZFBFRpydfGGpjOOiI=;
        b=d3g7VML/NPjGnWZ3BdRu1VkDMIeAXgr5VS3O6o6ZCryHnBCT4zEH08/ougquUx7+WC
         LKFYkKA8niA8PKfMmOydnjabGoYoKyLa+N2J6fk3r6mzU2rFMnlNeYTgbeOFDdd1Igqz
         XFWA1sOlbvmNXKnlaOyskUg+txMParmR/z84U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wSe3xVUI2FvJ4kebDMAPMIferoZFBFRpydfGGpjOOiI=;
        b=455tdQRQaQYoHLaHLS9EBdbnrQqTT9NrkN8J2hvolxTOIZhk3d5h6itRBuWmzbMId9
         OFcK5+5Q/yW0goBT0WbHI7yZAmXySX88UU3fFvQ9y5K3h8R1eQPTaQ/ShKpPrsAAwvhP
         6KKgpl7ycvxsHL5rV8w//G7MPQsX9DRKWqM/96dh7/x5jeXAk00aF+di5G08TwnQCE6/
         EWPgwePp+GB7VTCRYjFGmh1DYtSAT2Zzb3ye9zQ1XFhmwAYJy1OHOTUL4hdQRIzUwEKL
         PsnmZmrcRkoZWxaVDe6LeZSPKd7zGZhK/pYmt5an5RZ3FgQejh7EoPPu4TpJ87kXePea
         sP7Q==
X-Gm-Message-State: AOAM532heJYdQzMwo+NF+oIPuwtbpC9NU+IHee+f0gumWO0DoTXEB06A
	Km2i4TduAgK2v3WqZ5l3s0L53pGXVV5fB4KGvjA=
X-Google-Smtp-Source: ABdhPJyhIjV+A/jhUGZ3QdzM3e27yhrFDdxVb9NLnTAqyOfcxCY2xjg8kXVmIlm87xAMYvVlQCaVew==
X-Received: by 2002:a17:907:2ce4:b0:6fe:b0b3:c915 with SMTP id hz4-20020a1709072ce400b006feb0b3c915mr3936438ejc.252.1653085407930;
        Fri, 20 May 2022 15:23:27 -0700 (PDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com. [209.85.128.48])
        by smtp.gmail.com with ESMTPSA id gz13-20020a170907a04d00b006fe9c65ffbcsm2071079ejc.155.2022.05.20.15.23.26
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 15:23:27 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id k126-20020a1ca184000000b003943fd07180so5041611wme.3
        for <patches@lists.linux.dev>; Fri, 20 May 2022 15:23:26 -0700 (PDT)
X-Received: by 2002:a05:600c:acf:b0:397:345f:fe10 with SMTP id
 c15-20020a05600c0acf00b00397345ffe10mr6876190wmr.15.1653085405984; Fri, 20
 May 2022 15:23:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220518172525.3319993-1-swboyd@chromium.org>
In-Reply-To: <20220518172525.3319993-1-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Fri, 20 May 2022 15:23:12 -0700
X-Gmail-Original-Message-ID: <CAD=FV=V1-jZYgPeKDi23=w2YL6y8ZGE7zwOWHdc9xXv6nMDy_w@mail.gmail.com>
Message-ID: <CAD=FV=V1-jZYgPeKDi23=w2YL6y8ZGE7zwOWHdc9xXv6nMDy_w@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: qcom: sc7180-trogdor: Split out keyboard node
 and describe detachables
To: Stephen Boyd <swboyd@chromium.org>
Cc: Andy Gross <agross@kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, 
	LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	linux-arm-msm <linux-arm-msm@vger.kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, 
	Benson Leung <bleung@chromium.org>, Guenter Roeck <groeck@chromium.org>, 
	Hsin-Yi Wang <hsinyi@chromium.org>, "Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Wed, May 18, 2022 at 10:25 AM Stephen Boyd <swboyd@chromium.org> wrote:
>
> Trogdor devices that have a detachable keyboard still have a
> non-detachable keyboard input device present because we include the
> cros-ec-keyboard.dtsi snippet in the top-level sc7180-trogdor.dtsi file
> that every variant board includes. We do this because the
> keyboard-controller node also provides some buttons like the power
> button and volume buttons. Unfortunately, this means we register a
> keyboard input device that doesn't do anything on boards with a
> detachable keyboard.
>
> Change the node's compatible on detachables to the newly introduced
> "google,cros-ec-keyb-switches" compatible to indicate that there are
> only switches and no keyboard to register. Similarly, move the keyboard
> include that defines the keyboard-controller node out of
> sc7180-trogdor.dtsi to boards that actually have a keyboard so that the
> matrix properties are not defined on boards with the switches
> compatible. Future boards can either use the include approach or the
> node definition approach to describe a keyboard with possible switches
> or just some switches.
>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Hsin-Yi Wang <hsinyi@chromium.org>
> Cc: "Joseph S. Barrera III" <joebar@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>
> This is based on an immutable branch from Dmitry (on Cc)
>
>         git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git ib/5.17-cros-ec-keyb
>
> where this patch should be applied on top of so that a bisect doesn't
> break. The driver side change only supports one compatible or the other,
> so we can't apply this patch unless the driver side change is present.
>
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi   | 4 ++++
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi | 6 ++++++
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi    | 2 ++
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi   | 2 ++
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts        | 2 ++
>  arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi          | 1 -
>  6 files changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
> index 14ed09f30a73..a131dba4bf97 100644
> --- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
> @@ -86,6 +86,10 @@ &camcc {
>  };
>
>  &cros_ec {
> +       keyboard-controller {
> +               compatible = "google,cros-ec-keyb-switches";
> +       };
> +
>         cros_ec_proximity: proximity {
>                 compatible = "google,cros-ec-mkbp-proximity";
>                 label = "proximity-wifi";
> diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
> index f32369af1351..5d7ca89f7862 100644
> --- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
> @@ -121,6 +121,12 @@ &camcc {
>         status = "okay";
>  };
>
> +&cros_ec {
> +       keyboard-controller {
> +               compatible = "google,cros-ec-keyb-switches";
> +       };
> +};
> +
>  &panel {
>         compatible = "samsung,atna33xc20";
>         enable-gpios = <&tlmm 12 GPIO_ACTIVE_HIGH>;
> diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
> index 69666f92176a..4601f5afe255 100644
> --- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
> @@ -9,6 +9,8 @@
>  ap_h1_spi: &spi0 {};
>
>  #include "sc7180-trogdor.dtsi"
> +/* Must come after sc7180-trogdor.dtsi to modify cros_ec */
> +#include <arm/cros-ec-keyboard.dtsi>

As pointed out in a separate email [1], I think the include of
sc7180-trogdor.dtsi needs to be removed from this file. I think it's
still OK to include the keyboard.dtsi file here, though, since the
trogdor.dtsi file will always be included before the lazor.dtsi. You
just might need to update the comment.

https://lore.kernel.org/r/CAD=FV=VSMyJrs9bTE2XEC=q7VtZi6YKFaKJQJyLTZhVaYa9-Jg@mail.gmail.com/

Other than that, this looks good to me.

This will, of course, need to be coordinated with Joe's patches adding
the new boards.

-Doug
