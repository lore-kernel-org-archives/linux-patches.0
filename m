Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D28C17C2
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 00:56:29 +0000 (UTC)
Received: by mail-lj1-f172.google.com with SMTP id d20so23546535ljc.12
        for <patches@lists.linux.dev>; Tue, 08 Nov 2022 16:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CtKScdx9gnQYQmQPB7oVdBP1cHmrzQH4xwyrHnP4+9A=;
        b=D+ah90m+YnU29byKX4GGNKZHNHqjZh+KuGfStgg6l0hXgJwuXA1Rxcy3U/5SRO6kv+
         rFcCcHXwbIPFbsktS4yP2GYhAZRgUfdjebYsIGuyPbHWGgXdo8cJjU+t/Z68lT7OKceL
         9fHreuqTrK9t4Q8/xXWAEinSVrg7lVemXWIyc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CtKScdx9gnQYQmQPB7oVdBP1cHmrzQH4xwyrHnP4+9A=;
        b=jPfr9ugETpcQ9fDOA203jFoCoawSXViy+I/oH76wz7Us1b49K8xDugj5SPoKS9CRzg
         OCg01aeOsUGvl5nGJ+IClkFx8HDtSPOrUAivV92fBIJpwBLe/aaGhMkc7RD30p2i9JGU
         s1qkCuoV2ZePD3op9+ezOv5gXODuFjuz7ZO9OwtkXeVBvzcG187sawhlj5EPGBEy7YHi
         8LsdVIjMr9cmmBj+Xumtbzv/yHj6NvnV+JO+XpJRTmCw5c9S8JvB0IVtGN/2c7T1DhRF
         HRJllJm+qw8p0U81tN2FqvJi+0tdef5iQVHPRcFgYPMBRAAo0DSbF0wy4hlEsKz3pYUi
         a1sQ==
X-Gm-Message-State: ACrzQf0I7S22StUbujzS62NvDlzqFGA+6aa/uz6wmR73hVOTdMnkEtH4
	bfDa8/mWqWmwkdl9/BhVg1y7lNA+48BLtCRtKysE9Q==
X-Google-Smtp-Source: AMsMyM4M2a1crQ3CNu1Pi8lGBslb4+eMcIAPSoFMhXpuyk12Jx9+xjd45Yn8NXBbYL9TwfsulJrnIQcbvRrW8x0mFOc=
X-Received: by 2002:a2e:9050:0:b0:277:430d:9f6d with SMTP id
 n16-20020a2e9050000000b00277430d9f6dmr19383175ljg.277.1667955387407; Tue, 08
 Nov 2022 16:56:27 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 8 Nov 2022 16:56:26 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAD=FV=XKHftMn4Ja40fdDggwi78F2pB0A+prs94+fFBhbSvNYw@mail.gmail.com>
References: <20221107191535.624371-1-swboyd@chromium.org> <20221107191535.624371-3-swboyd@chromium.org>
 <CAD=FV=XKHftMn4Ja40fdDggwi78F2pB0A+prs94+fFBhbSvNYw@mail.gmail.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 8 Nov 2022 16:56:26 -0800
Message-ID: <CAE-0n53yS28hwhNASP5KpgGHLAuEb4f_cUUc_iFc6LpzynR62g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: Fully describe fingerprint node
 on Trogdor
To: Doug Anderson <dianders@chromium.org>
Cc: Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>, 
	Alexandru M Stan <amstan@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Doug Anderson (2022-11-07 17:22:51)
> On Mon, Nov 7, 2022 at 11:15 AM Stephen Boyd <swboyd@chromium.org> wrote:
> >
> > diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
> > index 4a5ea17a15ba..65601bea0797 100644
> > --- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
> > +++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
> > @@ -894,13 +894,16 @@ ap_spi_fp: &spi10 {
> >         cs-gpios = <&tlmm 89 GPIO_ACTIVE_LOW>;
> >
> >         cros_ec_fp: ec@0 {
> > -               compatible = "google,cros-ec-spi";
> > +               compatible = "google,cros-ec-fp", "google,cros-ec-spi";
> >                 reg = <0>;
> >                 interrupt-parent = <&tlmm>;
> >                 interrupts = <4 IRQ_TYPE_LEVEL_LOW>;
> >                 pinctrl-names = "default";
> > -               pinctrl-0 = <&fp_to_ap_irq_l>;
> > +               pinctrl-0 = <&fp_to_ap_irq_l>, <&fp_rst_l>, <&fpmcu_boot0>;
> > +               boot0-gpios = <&tlmm 10 GPIO_ACTIVE_HIGH>;
> > +               reset-gpios = <&tlmm 22 GPIO_ACTIVE_LOW>;
>
> This isn't totally a no-op change since the pinctrl entries for
> fp_rst_l and fpmcu_boot0 will now be applied. I assume you've
> confirmed that it works as expected?

Yes my fingerprint still works to unlock. I also confirmed that the bios
sets these pinctrl settings so this is to be more explicit and not rely
on bootloader state.

>
> ...other than the subject (same as patch #1), this LGTM.
>
> Reviewed-by: Douglas Anderson <dianders@chromium.org>

Cool thanks.
