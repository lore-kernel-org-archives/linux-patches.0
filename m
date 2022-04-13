Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741B32F23
	for <patches@lists.linux.dev>; Wed, 13 Apr 2022 20:56:12 +0000 (UTC)
Received: by mail-ed1-f44.google.com with SMTP id g20so3911608edw.6
        for <patches@lists.linux.dev>; Wed, 13 Apr 2022 13:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GGJeViK+7nvO370X+XWsM6u8Nu1Bs+YHak1Y1XG2ND4=;
        b=Nmnntj/LVIwy3oeOLpeN9QoktVn4Gy5cYRHXFCyvkB7XueSKlPJszbhcdG9U78y2ad
         u8YKGSNTvuIK1Qs6RbcqVntnhyfwD1HecmNzit4QEsVJrFYQOt1JO7DP2DBYKh7p/2KM
         tIkfENteINhIIpwXj6yI7S3FGN7rNsZJLO5rI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GGJeViK+7nvO370X+XWsM6u8Nu1Bs+YHak1Y1XG2ND4=;
        b=HdaaZ3ge1T68R1Qqy0NTHXNQ4Ht8t3C6uBPo5fKwx+FQ42B/x9aiYssMA2Jg7Ch+Zc
         F+pi41CiJeqPTgm6bH3ApngdzM/2CTOkiw6/D2/KvqwsTmCsYOrX67dlQPWEpWQPEmqO
         Vcr2Tcglfr4Ugoxxbg0sx5fJLDlklydsNS9Ews67Gq1xwwzgbDubAcT6A343ad78N8R2
         3o4YMXdHK1S/TlqTSbnwJGG+1GHMDnH2hTCjWGW0fsjMTPE8Y9OPvP2Krsy4iE3Zy8nD
         CwmQEnwprUesRCA1dAbxHyVu0uxTBubEftd0z77sjSZJMzGiRgkFf+MHMJCipAQJwkPB
         dcVw==
X-Gm-Message-State: AOAM532cVAXAiJQdPRQjSToqGSCSdt8zhNCQxIAiQA5OZBAUcrfgzoHZ
	vpEYx2+RZjm55+wthzx4HRu4KNtaFqqKtFhb
X-Google-Smtp-Source: ABdhPJw1E93xPHHNxsjwTElNtEHkVvn8drQcpqmoB1gghHGJASECcfg81ry8G6TCEvtwuJhGAmpekg==
X-Received: by 2002:a05:6402:11d4:b0:419:5a50:75a4 with SMTP id j20-20020a05640211d400b004195a5075a4mr46095735edw.226.1649883370462;
        Wed, 13 Apr 2022 13:56:10 -0700 (PDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com. [209.85.221.46])
        by smtp.gmail.com with ESMTPSA id b7-20020a170906708700b006da8440d642sm7227ejk.113.2022.04.13.13.56.09
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 13:56:09 -0700 (PDT)
Received: by mail-wr1-f46.google.com with SMTP id k22so4345880wrd.2
        for <patches@lists.linux.dev>; Wed, 13 Apr 2022 13:56:09 -0700 (PDT)
X-Received: by 2002:a5d:64ce:0:b0:208:fff6:22cb with SMTP id
 f14-20020a5d64ce000000b00208fff622cbmr89950wri.301.1649883368489; Wed, 13 Apr
 2022 13:56:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220412220033.1273607-1-swboyd@chromium.org> <20220412220033.1273607-2-swboyd@chromium.org>
In-Reply-To: <20220412220033.1273607-2-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Wed, 13 Apr 2022 13:55:56 -0700
X-Gmail-Original-Message-ID: <CAD=FV=UFbOhs0ggxDbVwKM_8x=ELT85zFd-Wk6dJ_M+Awz+Pxw@mail.gmail.com>
Message-ID: <CAD=FV=UFbOhs0ggxDbVwKM_8x=ELT85zFd-Wk6dJ_M+Awz+Pxw@mail.gmail.com>
Subject: Re: [PATCH 1/2] interconnect: qcom: sc7180: Drop IP0 interconnects
To: Stephen Boyd <swboyd@chromium.org>
Cc: Georgi Djakov <djakov@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, linux-arm-msm <linux-arm-msm@vger.kernel.org>, 
	Linux PM <linux-pm@vger.kernel.org>, Alex Elder <elder@linaro.org>, 
	Bjorn Andersson <bjorn.andersson@linaro.org>, Taniya Das <quic_tdas@quicinc.com>, 
	Mike Tipton <quic_mdtipton@quicinc.com>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Tue, Apr 12, 2022 at 4:20 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> @@ -519,8 +500,6 @@ static const struct of_device_id qnoc_of_match[] = {
>           .data = &sc7180_dc_noc},
>         { .compatible = "qcom,sc7180-gem-noc",
>           .data = &sc7180_gem_noc},
> -       { .compatible = "qcom,sc7180-ipa-virt",
> -         .data = &sc7180_ipa_virt},
>         { .compatible = "qcom,sc7180-mc-virt",
>           .data = &sc7180_mc_virt},
>         { .compatible = "qcom,sc7180-mmss-noc",

I have no objection to ${SUBJECT} change landing and based on all your
research and Alex's review/testing I think it's good to go.

However, now that you're removed the driver that cared about
"qcom,sc7180-ipa-virt", should we also be removing it from the
`bindings/interconnect/qcom,rpmh.yaml` file and the `sc7180.dtsi`
file? I think that removing it from _either_ the driver (like your
patch here does) _or_ the sc7180.dtsi file would fix the bug, right?
...and then removing it from the yaml would just be cleanup...

-Doug
