Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0EA7463
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 20:48:40 +0000 (UTC)
Received: by mail-ed1-f45.google.com with SMTP id o22so19013869edc.10
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 13:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=+Cti20S/WWpY7aspWrYZ4xE3P/s0O+PHZV22YRy/CUE=;
        b=RUY2d9i5bIklJBMGlj1kJOw47zUbEvxdY1V+2zngZZk1/gVeOIgKDiz2urgv4l6Cpa
         4SgbFJshe0t5ZmI808R5aNZoUHqzHaqN3nRZzuaTWbgKyuf30NRCp7q12AdrmxbnSCT3
         Hum1AaJKsg24YJxa3NlN8SEYHrrLmnQp1xJAM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=+Cti20S/WWpY7aspWrYZ4xE3P/s0O+PHZV22YRy/CUE=;
        b=Sao281frlhG9+ci8gf43uSfse2ihF4Dnhh4CHBcvU3r9cir+IMr7efbJBojSLkMWfY
         LB/9FtvwWpUyp2oPSdu2LAolxyN3r/8XIbwEeuPXib6BxyNOnBOcmcDqcXFKDuUcFN65
         cR0GghcQh9xCqWzfBGvAOD9XZ2qk+tVZPkTAS2cs8I/AkdE4X1tsYVY0if70YZRpqNYU
         MsHxYWcOAIg7bskCWFGTO+uMMEWOMgf3tdbo6Vso98LTii3GnoIbAdfXtB0eYGGTNTQk
         f90Lv3y31ZARRB3+Gc7Uvh+oKY9vwEX6vdF+3QbnvWGhpoW3ti/A3rCit6z9rpTKmZ/p
         gb/w==
X-Gm-Message-State: ACgBeo2ExduXeGUxXqePVCl0CpNobk9QpM5X4WuMHoQfGsbYqDXJ4Clw
	vBhxBbNxztA+XCj+RkZoFViJ+Ek5PRyRQWNF
X-Google-Smtp-Source: AA6agR7YVFudFDtnRojgwovWsxtmEeZeokWdnt6ZXZv945lg+U2OMSFG6yCD3kV4/F1bTnE+7YLl6Q==
X-Received: by 2002:a05:6402:1004:b0:440:7244:e8a5 with SMTP id c4-20020a056402100400b004407244e8a5mr25059346edu.335.1660769318504;
        Wed, 17 Aug 2022 13:48:38 -0700 (PDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com. [209.85.221.42])
        by smtp.gmail.com with ESMTPSA id ck26-20020a0564021c1a00b0043d7b19abd0sm11326677edb.39.2022.08.17.13.48.37
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 13:48:37 -0700 (PDT)
Received: by mail-wr1-f42.google.com with SMTP id n7so6299354wrv.4
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 13:48:37 -0700 (PDT)
X-Received: by 2002:a05:6000:1564:b0:225:17e4:4084 with SMTP id
 4-20020a056000156400b0022517e44084mr5308854wrz.617.1660769317514; Wed, 17 Aug
 2022 13:48:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220706191442.1150634-1-swboyd@chromium.org> <CAD=FV=UrYCwm2ByN_5EN3fq-ayMJNjmWfJ5sooRy51ZiCoMcjA@mail.gmail.com>
 <CAF6AEGt_J6f1T+-6KtyCrUJrY2fh7Sz10L1AV1FSe8hueGREtQ@mail.gmail.com> <CAD=FV=W+VWtpTKAoyQpYMFteZy8iYB7-o=ACqkjr7YX7uCxZvg@mail.gmail.com>
In-Reply-To: <CAD=FV=W+VWtpTKAoyQpYMFteZy8iYB7-o=ACqkjr7YX7uCxZvg@mail.gmail.com>
From: Doug Anderson <dianders@chromium.org>
Date: Wed, 17 Aug 2022 13:48:25 -0700
X-Gmail-Original-Message-ID: <CAD=FV=W9Gr9MyCg2rsKaA-ssSi5e3W5zO9sC56At+ceN4A2XtA@mail.gmail.com>
Message-ID: <CAD=FV=W9Gr9MyCg2rsKaA-ssSi5e3W5zO9sC56At+ceN4A2XtA@mail.gmail.com>
Subject: Re: [PATCH] drm/msm/dsi: Set panel orientation when directly connected
To: Rob Clark <robdclark@gmail.com>
Cc: Stephen Boyd <swboyd@chromium.org>, Abhinav Kumar <quic_abhinavk@quicinc.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, Sean Paul <sean@poorly.run>, 
	dri-devel <dri-devel@lists.freedesktop.org>, 
	freedreno <freedreno@lists.freedesktop.org>, Hsin-Yi Wang <hsinyi@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Wed, Jul 20, 2022 at 3:42 PM Doug Anderson <dianders@chromium.org> wrote:
>
> Hi,
>
> On Wed, Jul 20, 2022 at 1:46 PM Rob Clark <robdclark@gmail.com> wrote:
> >
> > On Fri, Jul 8, 2022 at 8:25 AM Doug Anderson <dianders@chromium.org> wrote:
> > >
> > > Hi,
> > >
> > > On Wed, Jul 6, 2022 at 12:14 PM Stephen Boyd <swboyd@chromium.org> wrote:
> > > >
> > > > Set the panel orientation in drm when the panel is directly connected,
> > > > i.e. we're not using an external bridge. The external bridge case is
> > > > already handled by the panel bridge code, so we only update the path we
> > > > take when the panel is directly connected/internal. This silences a
> > > > warning splat coming from __drm_mode_object_add() on Wormdingler boards.
> > > >
> > > > Cc: Hsin-Yi Wang <hsinyi@chromium.org>
> > > > Cc: Douglas Anderson <dianders@chromium.org>
> > > > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > > > ---
> > > >
> > > > This relies on commit 5e41b01a7808 ("drm/panel: Add an API to allow drm
> > > > to set orientation from panel") which is in drm-misc
> > > >
> > > >  drivers/gpu/drm/msm/dsi/dsi_manager.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > >
> > > I don't personally have objections to this, but (to my understanding)
> > > "the future" is that everyone should use panel_bridge. If we made the
> > > move to panel_bridge today then we wouldn't need to do this. In
> > > general I think panel_bridge would end up letting us delete a bunch of
> > > code...
> > >
> > > See commit 4e5763f03e10 ("drm/bridge: ti-sn65dsi86: Wrap panel with
> > > panel-bridge") for when this was done by ti-sn65dsi86.
> > >
> > > Then again, I spent a small amount of time looking into this and it's
> > > definitely non-trivial. Still likely worthwhile, but not worth
> > > blocking a tiny fix like this. It also should be fairly obvious that
> > > we should delete this when we switch to panel_bridge.
> > >
> > > Thus:
> > >
> > > Reviewed-by: Douglas Anderson <dianders@chromium.org>
> > >
> > > I'll assume that we'll just snooze this commit until drm-misc-next
> > > merges into a tree that msm-next is based on, which will probably be
> > > the next -rc1. If desired and Acked I could land this in
> > > drm-misc-next, but it's probably not worth it?
> >
> > if you want to land this patch via drm-misc, which might be the
> > easier/faster route, then:
> >
> > Acked-by: Rob Clark <robdclark@gmail.com>
>
> As per discussion on IRC, I'm not going to apply this to drm-misc-next.
>
> Given where we are in the cycle landing in drm-misc-next means it
> won't be in mainline for a couple versions and I suspect that'll cause
> merge conflicts with Dmitry's series [1]. ...and, of course, if
> Dmitry's series lands then we don't even need ${SUBJECT} patch...
>
> So I think the plan is:
>
> 1. Snooze waiting for the next -rc1 since
> drm_connector_set_orientation_from_panel() won't be in mainline until
> then.
>
> 2. If Dmitry's series looks like a long way off, we could land
> ${SUBJECT} patch in msm-next as a stopgap fix.
>
>
> [1] https://lore.kernel.org/r/20220711094320.368062-5-dmitry.baryshkov@linaro.org/

Just checking up. What's the latest thinking here? Do we want to land
Stephen's change as a stopgap?
drm_connector_set_orientation_from_panel() is available in v6.0-rc1.

-Doug
