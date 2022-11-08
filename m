Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E244017ED
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 01:23:01 +0000 (UTC)
Received: by mail-ed1-f51.google.com with SMTP id u24so20238743edd.13
        for <patches@lists.linux.dev>; Mon, 07 Nov 2022 17:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=huQuPYkl7U+LTfPaignW2xikp2tMlS/JRi7V+K6MHt8=;
        b=irTny37RkM+fGVHhNgcCBJ0iTlIIPXy+dgkSvu7tYO5TGRTQCbks4PWN65k63oXT+5
         jGRQHWb+zGLrTTmThs65Dup5b/mmNc7pV8yHJsJ/mw1/TVYWLGLi5wMvo294yHZ3Fct3
         wc3/hzieeFRLBlrXiJbqEFDE6P27lTrXB1lYs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=huQuPYkl7U+LTfPaignW2xikp2tMlS/JRi7V+K6MHt8=;
        b=s9n2tTRieou9Q8Ti9/JO3H/i2I+/QRbiugblp7kidlsIpatGDB/4BInN1h+1jJsEV2
         Kr47qCa1FLWz/rj6hiC66BM5mFhW3TJJp9FcsxLUg1HWXPm0ufvUmdNaqJ5MAg/3VASS
         1rkCe26tPBHITRA3DYIwAm9OHmB6t5M81rwyfbmSu6DSvezuWQ97FFWN9RQW4UKzBshl
         Zc6JVAEtgGRIbTwjSdvc46k2r9QC/vdcAj57r+JvMKTp0L5l0y9rgU4XgeBPYYdUyloT
         itgPxcF2DNEDPV5+I9dXcmlkDnDyfV5hkP9muFj6u1f2u/YTgR0FyERr/UyXkrvZSF5K
         fFdQ==
X-Gm-Message-State: ACrzQf1r6IywMy9+//xME6/q01LBaOqqaTI3XIsJkkRKq5n2wjOy2KSO
	JCHuFSYg/xDUsZFJsVgyH7n/eiwFIYgB3H4+
X-Google-Smtp-Source: AMsMyM6jklpO5cw9+M7dXLMS3s8J8+6hdzjDAVT04cuAVxCdHpw7s05y7yd+8hyhS+WjLt+L4x6F6g==
X-Received: by 2002:a50:954a:0:b0:463:1969:aaea with SMTP id v10-20020a50954a000000b004631969aaeamr50792894eda.290.1667870579919;
        Mon, 07 Nov 2022 17:22:59 -0800 (PST)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id rk7-20020a170907214700b0078dce9984afsm4021184ejb.220.2022.11.07.17.22.59
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 17:22:59 -0800 (PST)
Received: by mail-wr1-f41.google.com with SMTP id bs21so18723943wrb.4
        for <patches@lists.linux.dev>; Mon, 07 Nov 2022 17:22:59 -0800 (PST)
X-Received: by 2002:a5d:4410:0:b0:236:a8f9:268f with SMTP id
 z16-20020a5d4410000000b00236a8f9268fmr33789345wrq.405.1667870578850; Mon, 07
 Nov 2022 17:22:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221107191535.624371-1-swboyd@chromium.org> <20221107191535.624371-2-swboyd@chromium.org>
In-Reply-To: <20221107191535.624371-2-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 7 Nov 2022 17:22:47 -0800
X-Gmail-Original-Message-ID: <CAD=FV=UJEkNcWWFExQsCD5SXvH_YvoK_K6mtFB0_ojDSNLP8Zg@mail.gmail.com>
Message-ID: <CAD=FV=UJEkNcWWFExQsCD5SXvH_YvoK_K6mtFB0_ojDSNLP8Zg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] arm64: dts: qcom: Fully describe fingerprint node
 on Herobrine
To: Stephen Boyd <swboyd@chromium.org>
Cc: Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>, 
	Alexandru M Stan <amstan@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Mon, Nov 7, 2022 at 11:15 AM Stephen Boyd <swboyd@chromium.org> wrote:
>
> Update the fingerprint node on Herobrine to match the fingerprint DT
> binding. This will allow us to drive the reset and boot gpios from the
> driver when it is re-attached after flashing. We'll also be able to boot
> the fingerprint processor if the BIOS isn't doing it for us.
>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Matthias Kaehlcke <mka@chromium.org>
> Cc: Alexandru M Stan <amstan@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  arch/arm64/boot/dts/qcom/sc7280-herobrine.dtsi | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

From Bjorn's recent comment [1], I think your subject needs modification to:

   arm64: dts: qcom: sc7280: Fully describe fingerprint node on Herobrine

Other than that this seems fine and is a better description of hardware, so:

Reviewed-by: Douglas Anderson <dianders@chromium.org>

I guess we're still leaving gpio77 alone (AKA not describing it in the
fingerprint regulator)?

[1] https://lore.kernel.org/r/20221017224853.stuy5qeqxjxntob4@builder.lan/
