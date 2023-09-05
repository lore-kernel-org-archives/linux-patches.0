Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB57FC1C
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 21:52:40 +0000 (UTC)
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-500c7796d8eso4804832e87.1
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 14:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693950758; x=1694555558; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=poTEsy/DpCYMp8kn/k9olR9s+199uTi+MS4Yqzd7g30=;
        b=Iwv2FWD2DrEjvqg9nNFRcifJrZ/JOeub3CIH5T7eUkYKv3ixg7dVc+WUVUNUzjbQTi
         9/yNe7irrZX8TRbloCGdjGK60Z3Lvzpy2BSuCL9bS3tDl0SrluF7EyAL6JEGfcLyS3Y0
         QRdc4usEPvW+edNe9KdfX2KkZO9nEBVEhwzY8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693950758; x=1694555558;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=poTEsy/DpCYMp8kn/k9olR9s+199uTi+MS4Yqzd7g30=;
        b=UQ/DgNoq43hTXUUAGXZzqmssDF8SI26lHzJcOb2ubnbQ9eE2xN+/QVuRLRuXz3GxJi
         t9EGaoh9fiDFodJcV2t6t5JnnTpKd6+V07iClKSZNloSQeq0zYOt1UfMuefJCf1g4V1+
         xhsO6MhEG18rnDqBo+9g8Mj3N/8KWQWi7t5LNfLEfKhQa0OOi0x/LbZJZ+mKqpE7P38/
         HB4/Jbjcg0Nof8vOmB22NhmEJsdR+XgNg/LcLVMsxMCsdokxSP+xMeJxTlUydLF49B9S
         4CvXtnYuBi5oJIdmpXWVwqI3TV1qx+s+SMmeAbz956gv9OzNm7FLVffW/6aMWnJrgPUV
         fOag==
X-Gm-Message-State: AOJu0YxEAWnqO+pTtNW7yWeKwBAXeeWCnPc64U/aY6YH4L+aAPOpGC07
	weiXlBpQGM+rOkOaxgQDfCRi4ENtyq9EXPcGvbTEyw==
X-Google-Smtp-Source: AGHT+IE3JWihciGf0rRrSsH9PjyDJ4bYAVgfmGDiVcDY3TEzyqBgkL1t/dLNdH5Gs/1zTaB+TQSko2czegvMLQZy5cI=
X-Received: by 2002:a19:671a:0:b0:4fe:1681:9378 with SMTP id
 b26-20020a19671a000000b004fe16819378mr706226lfc.66.1693950758130; Tue, 05 Sep
 2023 14:52:38 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 5 Sep 2023 16:52:37 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <726d4be5-d207-4176-bc0d-43492eb2c4e5@linaro.org>
References: <20230829184735.2841739-1-swboyd@chromium.org> <20230829184735.2841739-8-swboyd@chromium.org>
 <726d4be5-d207-4176-bc0d-43492eb2c4e5@linaro.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 5 Sep 2023 16:52:37 -0500
Message-ID: <CAE-0n50Ka++WMKey_Nqm1drkQZLj6gnPSf=P2NX9=diQ_qCgtg@mail.gmail.com>
Subject: Re: [PATCH 7/7] drm/msm/dp: Remove dp_display_is_ds_bridge()
To: Abhinav Kumar <quic_abhinavk@quicinc.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, Rob Clark <robdclark@gmail.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org, 
	freedreno@lists.freedesktop.org, Vinod Polimera <quic_vpolimer@quicinc.com>, 
	Kuogee Hsieh <quic_khsieh@quicinc.com>
Content-Type: text/plain; charset="UTF-8"

Quoting Dmitry Baryshkov (2023-09-03 15:40:49)
> On 29/08/2023 21:47, Stephen Boyd wrote:
> > This function is simply drm_dp_is_branch() so use that instead of
> > open-coding it.
> >
> > Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
> > Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
> > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > ---
> >   drivers/gpu/drm/msm/dp/dp_display.c | 9 +--------
> >   1 file changed, 1 insertion(+), 8 deletions(-)
>
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

Thanks.

>
> >
> > diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
> > index 76f13954015b..96bbf6fec2f1 100644
> > --- a/drivers/gpu/drm/msm/dp/dp_display.c
> > +++ b/drivers/gpu/drm/msm/dp/dp_display.c
> > @@ -341,19 +341,12 @@ static const struct component_ops dp_display_comp_ops = {
> >       .unbind = dp_display_unbind,
> >   };
> >
> > -static bool dp_display_is_ds_bridge(struct dp_panel *panel)
> > -{
> > -     return (panel->dpcd[DP_DOWNSTREAMPORT_PRESENT] &
> > -             DP_DWN_STRM_PORT_PRESENT);
> > -}
> > -
> >   static bool dp_display_is_sink_count_zero(struct dp_display_private *dp)
>
> Nit: you might as well inline this function

Ok. I'll send a followup to this series with a patch for that. I found
that with an Apple dongle it always prints out a message to the kernel
log when I have HDMI disconnected that there isn't a sink connected,
which is annoying.

So at least two more patches are incoming.
