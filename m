Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5776FBA37
	for <patches@lists.linux.dev>; Sun,  3 Sep 2023 22:40:52 +0000 (UTC)
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5008faf4456so1324343e87.3
        for <patches@lists.linux.dev>; Sun, 03 Sep 2023 15:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693780850; x=1694385650; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4uZeHrs3brpLA9BIYNN/FvNUjPGrJaqU0dAdN56uTls=;
        b=Lsub6f3ckBaToH76U2bcOWU7AM/OvVEO+oY+5znojSgxiv496rMyQPOx+UhFI3lgAp
         2S4V1xZrmx8xIHj4jHD7DuVTwSrt78of3WOvevEqrUlOU+kwQyy63rbhE53G3kPo3bV/
         VHqAGQg697O8o0PlLXhZUqqEUM/0H3WgR3NmaSOea71yQOZMu18Qlh0Beun+RVW2atzM
         es5Z8SisPSmVZUmufJL965KNo5fTgO1AQQlcOMBpvWYPas6ADD143z2U7PFD9JY4cVHY
         Bvqlfy0Tylw1OFczsjluXzneUqYSMeSNIxppFD204snnDBO4r0cSOodIZfHC5+cbWbIu
         5U5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693780850; x=1694385650;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4uZeHrs3brpLA9BIYNN/FvNUjPGrJaqU0dAdN56uTls=;
        b=mIPOqFBJA0KJONDQNqMFtn+9/IA7MmMF2zIHhtvE7PCvpsaZA2gDJUXs6lQle/WdCY
         Y/sOzJVd0H+0Kutbn0UeStWnSdjq98BjCsBg24PR8CDImeLZkyzKUKFZk3EGX4tCj9CV
         dVfWxwfckfYi+CEYTLJ6vpjE7M15j2IM39ey9yyVRxYYR45wMKfE48/s3NsRRA6y/sLg
         JXUNSlgod2OaxWdJxW0luHd6oCnp4sNyx8rCK2lWR4Wp3VKxQtUj78xK9Sh8xTLwdyE2
         uFVMmzIIdhIq3CvISviy2U68F+5uS1zKa9d59P3FaA1YdutLgQnAGkI4gluATNPvem5V
         mRag==
X-Gm-Message-State: AOJu0YyKpxA9Fk7g+MkjledzYAeSNhtpLpUc3nvEa33mGtgBcSyAa+al
	pZA+1vJym/jJH62jG9htb7i9r5fkZk9rKJBs+Mo=
X-Google-Smtp-Source: AGHT+IFmWZRk24SDi37FSiWwzAUFzDGcudEUHjvx8xHvUKUKpT4Ml6Ym6mavr1lOx4JWTmr2YnXbNA==
X-Received: by 2002:a05:6512:3083:b0:500:9524:f733 with SMTP id z3-20020a056512308300b005009524f733mr6407395lfd.20.1693780850292;
        Sun, 03 Sep 2023 15:40:50 -0700 (PDT)
Received: from [10.10.15.130] ([192.130.178.91])
        by smtp.gmail.com with ESMTPSA id bo9-20020a0564020b2900b0052889d090bfsm4972604edb.79.2023.09.03.15.40.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Sep 2023 15:40:49 -0700 (PDT)
Message-ID: <726d4be5-d207-4176-bc0d-43492eb2c4e5@linaro.org>
Date: Mon, 4 Sep 2023 01:40:49 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] drm/msm/dp: Remove dp_display_is_ds_bridge()
Content-Language: en-GB
To: Stephen Boyd <swboyd@chromium.org>, Rob Clark <robdclark@gmail.com>,
 Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org,
 freedreno@lists.freedesktop.org, Vinod Polimera <quic_vpolimer@quicinc.com>,
 Kuogee Hsieh <quic_khsieh@quicinc.com>
References: <20230829184735.2841739-1-swboyd@chromium.org>
 <20230829184735.2841739-8-swboyd@chromium.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20230829184735.2841739-8-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/08/2023 21:47, Stephen Boyd wrote:
> This function is simply drm_dp_is_branch() so use that instead of
> open-coding it.
> 
> Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
> Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>   drivers/gpu/drm/msm/dp/dp_display.c | 9 +--------
>   1 file changed, 1 insertion(+), 8 deletions(-)

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

> 
> diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
> index 76f13954015b..96bbf6fec2f1 100644
> --- a/drivers/gpu/drm/msm/dp/dp_display.c
> +++ b/drivers/gpu/drm/msm/dp/dp_display.c
> @@ -341,19 +341,12 @@ static const struct component_ops dp_display_comp_ops = {
>   	.unbind = dp_display_unbind,
>   };
>   
> -static bool dp_display_is_ds_bridge(struct dp_panel *panel)
> -{
> -	return (panel->dpcd[DP_DOWNSTREAMPORT_PRESENT] &
> -		DP_DWN_STRM_PORT_PRESENT);
> -}
> -
>   static bool dp_display_is_sink_count_zero(struct dp_display_private *dp)

Nit: you might as well inline this function

>   {
>   	drm_dbg_dp(dp->drm_dev, "present=%#x sink_count=%d\n",
>   			dp->panel->dpcd[DP_DOWNSTREAMPORT_PRESENT],
>   		dp->link->sink_count);
> -	return dp_display_is_ds_bridge(dp->panel) &&
> -		(dp->link->sink_count == 0);
> +	return drm_dp_is_branch(dp->panel->dpcd) && dp->link->sink_count == 0;
>   }
>   
>   static void dp_display_send_hpd_event(struct msm_dp *dp_display)

-- 
With best wishes
Dmitry

