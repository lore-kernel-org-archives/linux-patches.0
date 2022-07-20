Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E588E1FD6
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 22:42:38 +0000 (UTC)
Received: by mail-ej1-f47.google.com with SMTP id oy13so123033ejb.1
        for <patches@lists.linux.dev>; Wed, 20 Jul 2022 15:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KuBSeD48AXgXk0Y7RnBVCdR0V4hjzjRzCq3VFtUSmXU=;
        b=hM1UrZ2kalbQlptKuH3fj5NcVp93Bz/8tn9oJq5IQEFtIepQAjgmF2oYEksVjL31KB
         e9LMOlkKA3bfMgkiuGzd1pbAGoeWM1l3rCYMAEyTFiFQbIUVXsUfBgcDxyeIpATWToPj
         DsMiLq1btPhMB8rNiehlMRFMF/tlaDAlKu2qs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KuBSeD48AXgXk0Y7RnBVCdR0V4hjzjRzCq3VFtUSmXU=;
        b=Y1alwGECtKp0/Xh7Z4mc0LD0KffkoXZZsJoEWcpjj0kZHKtKotQS19CA3gHEt2p1PJ
         fPmWVWdrKW6kCpYwRApm8RASusXOk8Gu9cULO4xomuM6Dr8d3mwX5K6Tym8fHBs1oed/
         jY7QYZvZLeE9ZXXoonEJ71YpQChjj4j3mMDyNYWzmmhH2whY5ivuXmUvg4v8ZAfE3WCP
         0XrIIiPGRwHdjmArKPBtRYPuC/R0+9kydUhjJ9ForWSIgtdJJkWAHpWyfnEszEOqA6LQ
         fIcv1o2QsqCYuaqwmBoaLR753Cxu+kMmqHqJecV9nFsy2eIihoWOVvH32Q2B8ttmyVFl
         Irsg==
X-Gm-Message-State: AJIora+dXIZ2ZUc7ngu3CpSde2L+me5qaGBjqLVl2PnUPSkesDA2v8E8
	chl2XsVHkVCdcN0UAgYcvS0LWgfWeVknjOUD
X-Google-Smtp-Source: AGRyM1vEJBzsA3HG+BsPUgbwL3KfY8Dj7dGkUTGMCf8RmqyoMf77o1Aj5vpWaVlN33DfASuy5N7c3Q==
X-Received: by 2002:a17:906:8a79:b0:72b:871a:57b7 with SMTP id hy25-20020a1709068a7900b0072b871a57b7mr36129836ejc.602.1658356957026;
        Wed, 20 Jul 2022 15:42:37 -0700 (PDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id r10-20020a1709061baa00b0071cef8bafc3sm146437ejg.1.2022.07.20.15.42.34
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 15:42:35 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id u5so5014558wrm.4
        for <patches@lists.linux.dev>; Wed, 20 Jul 2022 15:42:34 -0700 (PDT)
X-Received: by 2002:adf:ead2:0:b0:21d:8b49:6138 with SMTP id
 o18-20020adfead2000000b0021d8b496138mr32970096wrn.138.1658356953852; Wed, 20
 Jul 2022 15:42:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220706191442.1150634-1-swboyd@chromium.org> <CAD=FV=UrYCwm2ByN_5EN3fq-ayMJNjmWfJ5sooRy51ZiCoMcjA@mail.gmail.com>
 <CAF6AEGt_J6f1T+-6KtyCrUJrY2fh7Sz10L1AV1FSe8hueGREtQ@mail.gmail.com>
In-Reply-To: <CAF6AEGt_J6f1T+-6KtyCrUJrY2fh7Sz10L1AV1FSe8hueGREtQ@mail.gmail.com>
From: Doug Anderson <dianders@chromium.org>
Date: Wed, 20 Jul 2022 15:42:19 -0700
X-Gmail-Original-Message-ID: <CAD=FV=W+VWtpTKAoyQpYMFteZy8iYB7-o=ACqkjr7YX7uCxZvg@mail.gmail.com>
Message-ID: <CAD=FV=W+VWtpTKAoyQpYMFteZy8iYB7-o=ACqkjr7YX7uCxZvg@mail.gmail.com>
Subject: Re: [PATCH] drm/msm/dsi: Set panel orientation when directly connected
To: Rob Clark <robdclark@gmail.com>
Cc: Stephen Boyd <swboyd@chromium.org>, Abhinav Kumar <quic_abhinavk@quicinc.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, Sean Paul <sean@poorly.run>, 
	dri-devel <dri-devel@lists.freedesktop.org>, 
	freedreno <freedreno@lists.freedesktop.org>, Hsin-Yi Wang <hsinyi@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Wed, Jul 20, 2022 at 1:46 PM Rob Clark <robdclark@gmail.com> wrote:
>
> On Fri, Jul 8, 2022 at 8:25 AM Doug Anderson <dianders@chromium.org> wrote:
> >
> > Hi,
> >
> > On Wed, Jul 6, 2022 at 12:14 PM Stephen Boyd <swboyd@chromium.org> wrote:
> > >
> > > Set the panel orientation in drm when the panel is directly connected,
> > > i.e. we're not using an external bridge. The external bridge case is
> > > already handled by the panel bridge code, so we only update the path we
> > > take when the panel is directly connected/internal. This silences a
> > > warning splat coming from __drm_mode_object_add() on Wormdingler boards.
> > >
> > > Cc: Hsin-Yi Wang <hsinyi@chromium.org>
> > > Cc: Douglas Anderson <dianders@chromium.org>
> > > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > > ---
> > >
> > > This relies on commit 5e41b01a7808 ("drm/panel: Add an API to allow drm
> > > to set orientation from panel") which is in drm-misc
> > >
> > >  drivers/gpu/drm/msm/dsi/dsi_manager.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> >
> > I don't personally have objections to this, but (to my understanding)
> > "the future" is that everyone should use panel_bridge. If we made the
> > move to panel_bridge today then we wouldn't need to do this. In
> > general I think panel_bridge would end up letting us delete a bunch of
> > code...
> >
> > See commit 4e5763f03e10 ("drm/bridge: ti-sn65dsi86: Wrap panel with
> > panel-bridge") for when this was done by ti-sn65dsi86.
> >
> > Then again, I spent a small amount of time looking into this and it's
> > definitely non-trivial. Still likely worthwhile, but not worth
> > blocking a tiny fix like this. It also should be fairly obvious that
> > we should delete this when we switch to panel_bridge.
> >
> > Thus:
> >
> > Reviewed-by: Douglas Anderson <dianders@chromium.org>
> >
> > I'll assume that we'll just snooze this commit until drm-misc-next
> > merges into a tree that msm-next is based on, which will probably be
> > the next -rc1. If desired and Acked I could land this in
> > drm-misc-next, but it's probably not worth it?
>
> if you want to land this patch via drm-misc, which might be the
> easier/faster route, then:
>
> Acked-by: Rob Clark <robdclark@gmail.com>

As per discussion on IRC, I'm not going to apply this to drm-misc-next.

Given where we are in the cycle landing in drm-misc-next means it
won't be in mainline for a couple versions and I suspect that'll cause
merge conflicts with Dmitry's series [1]. ...and, of course, if
Dmitry's series lands then we don't even need ${SUBJECT} patch...

So I think the plan is:

1. Snooze waiting for the next -rc1 since
drm_connector_set_orientation_from_panel() won't be in mainline until
then.

2. If Dmitry's series looks like a long way off, we could land
${SUBJECT} patch in msm-next as a stopgap fix.


[1] https://lore.kernel.org/r/20220711094320.368062-5-dmitry.baryshkov@linaro.org/

-Doug
