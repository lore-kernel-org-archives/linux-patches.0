Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5993229
	for <patches@lists.linux.dev>; Mon, 27 Jun 2022 23:35:40 +0000 (UTC)
Received: by mail-ej1-f43.google.com with SMTP id h23so22192434ejj.12
        for <patches@lists.linux.dev>; Mon, 27 Jun 2022 16:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G4JUc3v4HQm863ZQSGCIjzj/xZC/uwmhPBskGvufwR8=;
        b=coFgLHRTH3mt3KuL21phdf35IlaYa+zTeDnnpiw9K7CsIZiNqfeMGzuiU1ebteiDvT
         TGpgbPOxX+3j92MRFmqescfYo4JXBfo5CDeARrf7/HbqdaktWEhPfvVsMzQtNXtW8KU3
         w/OVnoXeBpMK/nh61ievKHUGKLu8uQfYZDUBk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G4JUc3v4HQm863ZQSGCIjzj/xZC/uwmhPBskGvufwR8=;
        b=TfrC7tp96Sg0/y3uGEI68+UXZdz1RitMFUk1xO+rPJh7eAXZklpd8H7HijWnvZnGyK
         bfx2BpSahy/SdMBSJMdJYb4ntwOxad/f9hyaHP0rAaJe2iiWQ1wH7dDXMprsi2RaMXrQ
         NSsVEuNBL8T3zG7gTi6QRMaRCpnJJCO21zLoLm/vs62B81md5y6BkuEYA8xwHFFLIvj9
         fVF18Frps4RC66feGu4jVw44cTgRjkXeLw0FeTPJU9JpRNGapsezn8lay9WyVoC2uBF2
         5pobuOmAFfV5zsoOT1QnSITyWD9jFdpw0uj3lfz2rnXT3jFrdSMXxMxCcWJnuuJFExPX
         vGuA==
X-Gm-Message-State: AJIora+Ep//QQNo5YFzl8FLVCjBqVg3ocspi/+othU+BPtyLmIL+BvxM
	keNkQTX0n26dnFDm0QPN+71SLRfh+2FhmAXn
X-Google-Smtp-Source: AGRyM1tJhp6VOunUflebq8BJjQOaf4ksghGVRpQIObH2EMg6WWuSvkHje5FZwUFyTHofQABbdiFvew==
X-Received: by 2002:a17:907:d29:b0:726:9e67:df9 with SMTP id gn41-20020a1709070d2900b007269e670df9mr8800841ejc.242.1656372938453;
        Mon, 27 Jun 2022 16:35:38 -0700 (PDT)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com. [209.85.221.50])
        by smtp.gmail.com with ESMTPSA id b21-20020a1709063f9500b006f3ef214dd9sm5566144ejj.63.2022.06.27.16.35.37
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 16:35:37 -0700 (PDT)
Received: by mail-wr1-f50.google.com with SMTP id e28so9987546wra.0
        for <patches@lists.linux.dev>; Mon, 27 Jun 2022 16:35:37 -0700 (PDT)
X-Received: by 2002:a5d:4046:0:b0:21a:3a12:239e with SMTP id
 w6-20020a5d4046000000b0021a3a12239emr14666951wrp.138.1656372937188; Mon, 27
 Jun 2022 16:35:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220627212802.3593012-1-swboyd@chromium.org>
In-Reply-To: <20220627212802.3593012-1-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 27 Jun 2022 16:35:24 -0700
X-Gmail-Original-Message-ID: <CAD=FV=X93M=jHU_pfBLB=EnSLgYuv3kHBvZgo9RFRtaOfeRLzA@mail.gmail.com>
Message-ID: <CAD=FV=X93M=jHU_pfBLB=EnSLgYuv3kHBvZgo9RFRtaOfeRLzA@mail.gmail.com>
Subject: Re: [PATCH v2] arm64: dts: qcom: sc7180-trogdor: Split out keyboard
 node and describe detachables
To: Stephen Boyd <swboyd@chromium.org>
Cc: Andy Gross <agross@kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, 
	LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	linux-arm-msm <linux-arm-msm@vger.kernel.org>, Benson Leung <bleung@chromium.org>, 
	Guenter Roeck <groeck@chromium.org>, Hsin-Yi Wang <hsinyi@chromium.org>, 
	"Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Mon, Jun 27, 2022 at 2:28 PM Stephen Boyd <swboyd@chromium.org> wrote:
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
> Changes from v1 (https://lore.kernel.org/r/20220518172525.3319993-1-swboyd@chromium.org):
>  * Rebased onto Joe's series applied on top of qcom's arm64-fixes-for-4.19
>  * Updated more dtsi files
>
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi        | 4 ++++
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi      | 6 ++++++
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-kingoftown.dtsi    | 2 +-
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi         | 1 +
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-mrbland.dtsi       | 6 ++++++
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-pazquel.dtsi       | 1 +
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi        | 2 ++
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi | 6 ++++++
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts             | 2 ++
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi   | 4 ++++
>  arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi               | 1 -
>  11 files changed, 33 insertions(+), 2 deletions(-)

Reviewed-by: Douglas Anderson <dianders@chromium.org>
