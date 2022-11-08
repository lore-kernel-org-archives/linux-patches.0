Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF72720E6
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 01:23:06 +0000 (UTC)
Received: by mail-ej1-f41.google.com with SMTP id d26so34707715eje.10
        for <patches@lists.linux.dev>; Mon, 07 Nov 2022 17:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o0A0yw55ZieBl6SrkekIUPpMrnlgooteEELcL9ZP3Ec=;
        b=DK54vb1qCybXBrtEEyTCQW0ellpWxVvHx4N75ZCqL1P4rDLkJG0CiGEVVH3XeWq8xh
         8+1IjIRIPFAGUQTO7Sg3OvRkap8WxD6/LXF1uT2MaR2yNYLzsHlI24+cioPAtbMyHm9s
         a0wRssFzUFGXrvEcesGMmXNcOXvAfnaUFFqHI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o0A0yw55ZieBl6SrkekIUPpMrnlgooteEELcL9ZP3Ec=;
        b=YqKU1EGUFlsVMXhfe210hH7LHNyA6JFSPxh+bthcONp4Tx7xctlDBEKhetcmA+ocWU
         frHgXWBeCvzSKeJTNDGOqgxi42/8+6TLeEM1hyAgDhIP3fbYGLUS/nvajs8IJQ1QzvHI
         owcbh4GstEjI3/U5nHtabN+GEZu6MFrZDg8HbY0KkNIgMwk7FKcpMzdg36eddJ/MWWX9
         6S2465ASfrFExCx3eMkbI6UNbL41D0XRu5Xd2f2I02TwgJIr8TcKMnUF+QUsU66mIGmI
         dWN1U66Qj5zBZZ3rKWlK3KZa6XvFqnC+EOAvex7XYKXF7HRTU9dUSp4SlOGLAttax+Jl
         mtxw==
X-Gm-Message-State: ACrzQf01rQp0xVgz8ANTR9DEYf0Zy7MQwMCnMzXfDvgJttwsriN6aPsC
	AbPd+grOd/XabSY49Q6cpdw1T3wVoB/8/LXK
X-Google-Smtp-Source: AMsMyM6v2Zw8fbqT5w/kGfRNywbGc9ntOA6jpbrwxeMDgHQ0kUiXN3+TkzFWFXBu63JaEmR94Qwj0Q==
X-Received: by 2002:a17:907:25c5:b0:783:f5df:900e with SMTP id ae5-20020a17090725c500b00783f5df900emr47620240ejc.491.1667870584693;
        Mon, 07 Nov 2022 17:23:04 -0800 (PST)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id sa28-20020a170906edbc00b007aa9156f7e9sm4085130ejb.32.2022.11.07.17.23.03
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 17:23:04 -0800 (PST)
Received: by mail-wr1-f51.google.com with SMTP id bs21so18724086wrb.4
        for <patches@lists.linux.dev>; Mon, 07 Nov 2022 17:23:03 -0800 (PST)
X-Received: by 2002:adf:d1ec:0:b0:236:880f:2adf with SMTP id
 g12-20020adfd1ec000000b00236880f2adfmr33984142wrd.617.1667870583522; Mon, 07
 Nov 2022 17:23:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221107191535.624371-1-swboyd@chromium.org> <20221107191535.624371-3-swboyd@chromium.org>
In-Reply-To: <20221107191535.624371-3-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 7 Nov 2022 17:22:51 -0800
X-Gmail-Original-Message-ID: <CAD=FV=XKHftMn4Ja40fdDggwi78F2pB0A+prs94+fFBhbSvNYw@mail.gmail.com>
Message-ID: <CAD=FV=XKHftMn4Ja40fdDggwi78F2pB0A+prs94+fFBhbSvNYw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: Fully describe fingerprint node
 on Trogdor
To: Stephen Boyd <swboyd@chromium.org>
Cc: Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>, 
	Alexandru M Stan <amstan@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Mon, Nov 7, 2022 at 11:15 AM Stephen Boyd <swboyd@chromium.org> wrote:
>
> Update the fingerprint node on Trogdor to match the fingerprint DT
> binding. This will allow us to drive the reset and boot gpios from the
> driver when it is re-attached after flashing. We'll also be able to boot
> the fingerprint processor if the BIOS isn't doing it for us.
>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Matthias Kaehlcke <mka@chromium.org>
> Cc: Alexandru M Stan <amstan@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
> index 4a5ea17a15ba..65601bea0797 100644
> --- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
> @@ -894,13 +894,16 @@ ap_spi_fp: &spi10 {
>         cs-gpios = <&tlmm 89 GPIO_ACTIVE_LOW>;
>
>         cros_ec_fp: ec@0 {
> -               compatible = "google,cros-ec-spi";
> +               compatible = "google,cros-ec-fp", "google,cros-ec-spi";
>                 reg = <0>;
>                 interrupt-parent = <&tlmm>;
>                 interrupts = <4 IRQ_TYPE_LEVEL_LOW>;
>                 pinctrl-names = "default";
> -               pinctrl-0 = <&fp_to_ap_irq_l>;
> +               pinctrl-0 = <&fp_to_ap_irq_l>, <&fp_rst_l>, <&fpmcu_boot0>;
> +               boot0-gpios = <&tlmm 10 GPIO_ACTIVE_HIGH>;
> +               reset-gpios = <&tlmm 22 GPIO_ACTIVE_LOW>;

This isn't totally a no-op change since the pinctrl entries for
fp_rst_l and fpmcu_boot0 will now be applied. I assume you've
confirmed that it works as expected?

...other than the subject (same as patch #1), this LGTM.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
