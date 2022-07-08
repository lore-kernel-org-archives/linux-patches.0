Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FCE2579
	for <patches@lists.linux.dev>; Fri,  8 Jul 2022 15:26:01 +0000 (UTC)
Received: by mail-ej1-f42.google.com with SMTP id u12so38240528eja.8
        for <patches@lists.linux.dev>; Fri, 08 Jul 2022 08:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jgYORBt3h5oNBznarFeGPU7nreEFffTVmMqBLDJdiu4=;
        b=DtmFdPpzZsHOuwOoYohjvI7a3T6485xiQKNorp7om5YF58QOgdZIm+69XDuFDPu6eT
         G0VKI4aJemTOakYgNYfi5goKPkr/OciMNayYQVZC/wYVDtjj4SxaE/DpjQ7w7Sglpy6j
         S9t6UDJqFztUm1k/IXK8WjVFIKnnN4cdaWiLQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jgYORBt3h5oNBznarFeGPU7nreEFffTVmMqBLDJdiu4=;
        b=FuesFB6e9lTiaW2GwWBXkddmMZT0YxBrxB8pKxrcN6lvAUjcOjTidJ/05npQvlkNo3
         2I+u0iOVw1bmDqpFb67x9eHEDqCPTktEDsJFE2TYVTPApdKm10/AGPk6ozVukvQZHGL6
         Bjjq7Dx4YECExckVRXUszfmVfNWelAWdfhhUk1eg9Y6Npsaj/qsrHfJmC/qnge5utMWQ
         fgRkCWmAcheUzhSnD5Lre7RCwjdLQSjrqC5MhsLzYmttBtJo8zDxkIqF3tC8YT1/t4oR
         C32W7QqatZrUYeomCQYoQPgDq2csBhNXIIuF6aJiZt8xT1+yCaWwTn4DOAlUC7U2y2r5
         N4Ig==
X-Gm-Message-State: AJIora/gKvQxrjMSTN2S60VXJ0R/q0tadhlclk44sodcLfpTDBuHehml
	ERQguPQKhTHGxpqcDLTOVudUZ6RA8kxQ0A==
X-Google-Smtp-Source: AGRyM1vMASWmkTPXZdeqnaJdo7+2SPkYp1CuFsdrwcjB9eE2CDFr5tyHddYkfanU++9UEeh1wmIkRA==
X-Received: by 2002:a17:907:60d4:b0:722:e603:cb40 with SMTP id hv20-20020a17090760d400b00722e603cb40mr4248806ejc.272.1657293960045;
        Fri, 08 Jul 2022 08:26:00 -0700 (PDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com. [209.85.221.48])
        by smtp.gmail.com with ESMTPSA id 2-20020a170906218200b0072b3182368fsm94611eju.77.2022.07.08.08.25.58
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jul 2022 08:25:58 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id h17so17866697wrx.0
        for <patches@lists.linux.dev>; Fri, 08 Jul 2022 08:25:58 -0700 (PDT)
X-Received: by 2002:adf:fb12:0:b0:20c:79b2:a200 with SMTP id
 c18-20020adffb12000000b0020c79b2a200mr3937186wrr.617.1657293957904; Fri, 08
 Jul 2022 08:25:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220706191442.1150634-1-swboyd@chromium.org>
In-Reply-To: <20220706191442.1150634-1-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Fri, 8 Jul 2022 08:25:44 -0700
X-Gmail-Original-Message-ID: <CAD=FV=UrYCwm2ByN_5EN3fq-ayMJNjmWfJ5sooRy51ZiCoMcjA@mail.gmail.com>
Message-ID: <CAD=FV=UrYCwm2ByN_5EN3fq-ayMJNjmWfJ5sooRy51ZiCoMcjA@mail.gmail.com>
Subject: Re: [PATCH] drm/msm/dsi: Set panel orientation when directly connected
To: Stephen Boyd <swboyd@chromium.org>
Cc: Rob Clark <robdclark@gmail.com>, Abhinav Kumar <quic_abhinavk@quicinc.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, Sean Paul <sean@poorly.run>, 
	dri-devel <dri-devel@lists.freedesktop.org>, 
	freedreno <freedreno@lists.freedesktop.org>, Hsin-Yi Wang <hsinyi@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Wed, Jul 6, 2022 at 12:14 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> Set the panel orientation in drm when the panel is directly connected,
> i.e. we're not using an external bridge. The external bridge case is
> already handled by the panel bridge code, so we only update the path we
> take when the panel is directly connected/internal. This silences a
> warning splat coming from __drm_mode_object_add() on Wormdingler boards.
>
> Cc: Hsin-Yi Wang <hsinyi@chromium.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>
> This relies on commit 5e41b01a7808 ("drm/panel: Add an API to allow drm
> to set orientation from panel") which is in drm-misc
>
>  drivers/gpu/drm/msm/dsi/dsi_manager.c | 2 ++
>  1 file changed, 2 insertions(+)

I don't personally have objections to this, but (to my understanding)
"the future" is that everyone should use panel_bridge. If we made the
move to panel_bridge today then we wouldn't need to do this. In
general I think panel_bridge would end up letting us delete a bunch of
code...

See commit 4e5763f03e10 ("drm/bridge: ti-sn65dsi86: Wrap panel with
panel-bridge") for when this was done by ti-sn65dsi86.

Then again, I spent a small amount of time looking into this and it's
definitely non-trivial. Still likely worthwhile, but not worth
blocking a tiny fix like this. It also should be fairly obvious that
we should delete this when we switch to panel_bridge.

Thus:

Reviewed-by: Douglas Anderson <dianders@chromium.org>

I'll assume that we'll just snooze this commit until drm-misc-next
merges into a tree that msm-next is based on, which will probably be
the next -rc1. If desired and Acked I could land this in
drm-misc-next, but it's probably not worth it?
