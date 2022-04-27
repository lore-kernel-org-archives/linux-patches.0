Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1884636B
	for <patches@lists.linux.dev>; Wed, 27 Apr 2022 00:17:53 +0000 (UTC)
Received: by mail-ej1-f50.google.com with SMTP id i19so216254eja.11
        for <patches@lists.linux.dev>; Tue, 26 Apr 2022 17:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=34otp1ic0ss1djD2XvGMVif0idr2cQGkKe33kd/rACY=;
        b=RRPUBGP+JGovd3brJQrzeniaOe9vtwrzEuf8ZoaDNHfZ5/xh2IYrUpq2DCGUqCgC9a
         /kdmoLtVb/e6uNWIeSRSDQXO93Z49u8WECf86sUl+Ms7sTyvALfXXEKPzL2/7WnosRp4
         KoiLYuZvPb3aqcb/ylZ40eUUwlQXXniilQpKo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=34otp1ic0ss1djD2XvGMVif0idr2cQGkKe33kd/rACY=;
        b=kzJWQq3ST/AcBl27/uPXewohWx2P3K+xZWDv9Srkc+1vpUuzASc5oj3RU6XJLjRpBJ
         u5C2d84SwL/4W1MhwDYvE4sUhEVxsiziFCcdEN3aPY5viLQsGHxXj6Tvc3e7US/XeEOg
         bsTvfuE69RRC53vXyUFJbjYMF//B2+In58tDBehPX5MNuGSMjYoGzUFSSQDBbkS963BC
         5V9KgUE7xPEkBX9XtLwQoJHcUuM2AoNZ1XYWcHOOGAFifKGJqCt0KU/rKqFgui/00srS
         N/MnZ0UCSwGEWwil+R3b0GjKB9bioRZ1lDypE2MeMg9ouvGnerLkbVHyZUyL76xuAmmd
         HMAA==
X-Gm-Message-State: AOAM533S4MP9teNesKd5AxpJOEtnCc6DA0qJ6aR3xYqku4JDmK3b2Mky
	ZfNrUcoXvFLj7PhlYIzrWDVm1kybGxmPnPW4CG0=
X-Google-Smtp-Source: ABdhPJyyL/v5IwPdlcrac6/46P7//Iu6lA6i5Qs5RB8c297CP0GF1+/vVJ5VcDsaDFhjAuHcUR15Pg==
X-Received: by 2002:a17:906:3ec1:b0:6e8:aae3:90de with SMTP id d1-20020a1709063ec100b006e8aae390demr23772295ejj.127.1651018671174;
        Tue, 26 Apr 2022 17:17:51 -0700 (PDT)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com. [209.85.128.54])
        by smtp.gmail.com with ESMTPSA id ci21-20020a170906c35500b006f394323ccesm3224541ejb.34.2022.04.26.17.17.49
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 17:17:50 -0700 (PDT)
Received: by mail-wm1-f54.google.com with SMTP id ay11-20020a05600c1e0b00b0038eb92fa965so2480300wmb.4
        for <patches@lists.linux.dev>; Tue, 26 Apr 2022 17:17:49 -0700 (PDT)
X-Received: by 2002:a05:600c:3c99:b0:392:b49c:7b79 with SMTP id
 bg25-20020a05600c3c9900b00392b49c7b79mr23337925wmb.199.1651018669353; Tue, 26
 Apr 2022 17:17:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220426225748.324759-1-swboyd@chromium.org>
In-Reply-To: <20220426225748.324759-1-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Tue, 26 Apr 2022 17:17:37 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WMf0Jc9oD7CGoLthguzt2aV31sZmFoenbjn72MfwFYEA@mail.gmail.com>
Message-ID: <CAD=FV=WMf0Jc9oD7CGoLthguzt2aV31sZmFoenbjn72MfwFYEA@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: qcom: sc7180-trogdor: Remove cros-ec keyboard
 from detachables
To: Stephen Boyd <swboyd@chromium.org>
Cc: Andy Gross <agross@kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, 
	LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	linux-arm-msm <linux-arm-msm@vger.kernel.org>, Benson Leung <bleung@chromium.org>, 
	Guenter Roeck <groeck@chromium.org>, Hsin-Yi Wang <hsinyi@chromium.org>, 
	"Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Tue, Apr 26, 2022 at 3:57 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> Trogdor devices that have a detachable keyboard still have a
> non-detachable keyboard input device present because we include the
> cros-ec-keyboard.dtsi snippet in the top-level sc7180-trogdor.dtsi file
> that every variant board includes. We do this because the
> keyboard-controller node also provides some buttons like the power
> button and volume buttons. Unfortunately, this means we register a
> keyboard input device that doesn't do anything on boards with a
> detachable keyboard. Let's delete the rows/columns properties of the
> device node to indicate that there isn't a matrix keyboard on these
> boards.
>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Hsin-Yi Wang <hsinyi@chromium.org>
> Cc: "Joseph S. Barrera III" <joebar@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi   | 5 +++++
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi | 5 +++++
>  2 files changed, 10 insertions(+)

Presumably we need to do this same thing for wormdingler [1]

[1] https://lore.kernel.org/r/20220426151204.1.Id2821de5fde55ebe928e8fc87a71c8d535edb383@changeid

Reviewed-by: Douglas Anderson <dianders@chromium.org>
