Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE4628ED
	for <patches@lists.linux.dev>; Thu,  7 Jul 2022 21:21:21 +0000 (UTC)
Received: by mail-oi1-f174.google.com with SMTP id o133so927802oig.13
        for <patches@lists.linux.dev>; Thu, 07 Jul 2022 14:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=XuQp9w2Vs1aOFFH2QgkEWHPslvL9Ld8qwnD4BupNY0w=;
        b=SXzFCD6PiakxSAJDlRX45oXMcaTKoAYue/mlyleZo0TLGj9D1x5FZiOFOc1bW5MMxm
         zMeQR1uETxWfCgYwRwvbM/aZQlHNFz3jwfNhmuBK0Tl46qx6avBJt0Vj5QJf9fSg63nT
         Laq+DqlvwhqfjZOD9GmtHldsC/NJuFdb8LnFw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=XuQp9w2Vs1aOFFH2QgkEWHPslvL9Ld8qwnD4BupNY0w=;
        b=PULfowJ0+fzXBDuJm0Tq6Ose4y6SMaSutS982UIHm5dtPniA8GWCLnKbrybhdWMpx3
         OiXgcdjjJCez/m3RmeVvgjpVHD22hc7XAgj/Z8l9gXwmU4fkX893foOdjr8hCDGDUwJW
         InirWOTbBJvUbs1uoUmawqA/vyCowjsy4AOglm3J643oYyoCkK+/aLE6bSmsjzuVzyIS
         MusmZfRm/oyvlXT7JknX60a/AuqXyisWM2gM1YlxJaPKA5wL+ZpGeR1xoCXnKMjEVY3N
         W2ifdDTddM+Ee/ODDt4MYSlzl63q/7Nls2kfzt8qdYyVduf2gmZ3ShKbwWFfDILZ7Rv2
         4gPw==
X-Gm-Message-State: AJIora85wh3PrYtSHjXYA4jo/LZK2UpPUsbzmKbWMnPIczyxzasNHv7k
	PI+4EtR1n+vqzO2oOyqyc/zedUzPbd4Vup/gu9PqUg==
X-Google-Smtp-Source: AGRyM1u86hlfujAKJCwkQGNNNhGQ5OK4EZsg7vgXL8Rcuq1ObSFJPCM5Km3thPxlp2kWX7YX6S9fOpbX+fbPsKGN5IA=
X-Received: by 2002:a05:6808:171c:b0:334:9342:63ef with SMTP id
 bc28-20020a056808171c00b00334934263efmr4885oib.63.1657228880881; Thu, 07 Jul
 2022 14:21:20 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 7 Jul 2022 14:21:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <40b6a28c-0237-55d7-2f5d-1c571f27e7d6@quicinc.com>
References: <20220706191442.1150634-1-swboyd@chromium.org> <40b6a28c-0237-55d7-2f5d-1c571f27e7d6@quicinc.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Thu, 7 Jul 2022 14:21:20 -0700
Message-ID: <CAE-0n51KOMLP4XJHw2CPNikzfhY0xdjeCScYwvCZ7gAYJM+8Fw@mail.gmail.com>
Subject: Re: [PATCH] drm/msm/dsi: Set panel orientation when directly connected
To: Abhinav Kumar <quic_abhinavk@quicinc.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, Rob Clark <robdclark@gmail.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org, 
	freedreno@lists.freedesktop.org, Hsin-Yi Wang <hsinyi@chromium.org>, 
	Douglas Anderson <dianders@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Abhinav Kumar (2022-07-07 14:11:08)
>
>
> On 7/6/2022 12:14 PM, Stephen Boyd wrote:
> > Set the panel orientation in drm when the panel is directly connected,
> > i.e. we're not using an external bridge. The external bridge case is
> > already handled by the panel bridge code, so we only update the path we
> > take when the panel is directly connected/internal. This silences a
> > warning splat coming from __drm_mode_object_add() on Wormdingler boards.
> >
> > Cc: Hsin-Yi Wang <hsinyi@chromium.org>
> > Cc: Douglas Anderson <dianders@chromium.org>
> > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > ---
> >
> > This relies on commit 5e41b01a7808 ("drm/panel: Add an API to allow drm
> > to set orientation from panel") which is in drm-misc
> >
> >   drivers/gpu/drm/msm/dsi/dsi_manager.c | 2 ++
> >   1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/gpu/drm/msm/dsi/dsi_manager.c b/drivers/gpu/drm/msm/dsi/dsi_manager.c
> > index cb84d185d73a..9333f7095acd 100644
> > --- a/drivers/gpu/drm/msm/dsi/dsi_manager.c
> > +++ b/drivers/gpu/drm/msm/dsi/dsi_manager.c
> > @@ -268,6 +268,8 @@ static int msm_dsi_manager_panel_init(struct drm_connector *conn, u8 id)
> >               return PTR_ERR(panel);
> >       }
> >
> > +     drm_connector_set_orientation_from_panel(conn, panel);
> > +
>
> This should be moved below the !panel check since you are passing panel
> as one of the params.

drm_connector_set_orientation_from_panel() checks for a NULL panel
pointer and sets to UNKNOWN. If I moved this below the !panel check then
I'd have to split that condition for !IS_BONDED_DSI() which was more
diff.

>
> I looked up the doc and it says that for unknown(default cases) this is
> a no-op so I think this change is fine otherwise.
>
> "It is allowed to call this function with a panel_orientation of
> DRM_MODE_PANEL_ORIENTATION_UNKNOWN, in which case it is a no-op."

Ok, so you're fine with this patch?

>
>
> >       if (!panel || !IS_BONDED_DSI())
> >               goto out;
> >
> >
> > base-commit: 15b9ca1641f0c3cd74885280331e9172c62a125e
