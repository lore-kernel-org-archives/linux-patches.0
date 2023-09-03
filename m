Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC2E9445
	for <patches@lists.linux.dev>; Sun,  3 Sep 2023 22:45:40 +0000 (UTC)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-99c136ee106so132351066b.1
        for <patches@lists.linux.dev>; Sun, 03 Sep 2023 15:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693781138; x=1694385938; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=icCZ5tdF61yj1pSKhn/ffpI/X+SJfCRYhcOnGB1o1ts=;
        b=xirPy3ugOGYP90koszXEkS/oc7AYlA9SHOcpJAOWXaWDVsN745otNrIwr6jll0mCnh
         egDl1SGQZKyAAQRDx1iA6srD+fO4MxQITyYnzN+nUEZSyIFD+TlXd4YLbQutYa7h1lwh
         /TDcE4hVm9tCmN4vhI5uOpvei/f92NceETa86NAK0dmp281SCzIMeqzmlqLW/WsFALx0
         LZ+dR9LqkrLbxz1qBFqYJc/M/UJkbmJv1m3a9d6NoZPTYimuVfCDJ9BBjyJVMpdhPbaL
         8no5myTndAZOh6w8CZp4E9r269ah4DdlvAONDMYV+7CHEZxWW6Hfr4ogwREZtVjD7ypi
         GOXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693781138; x=1694385938;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=icCZ5tdF61yj1pSKhn/ffpI/X+SJfCRYhcOnGB1o1ts=;
        b=iCwRrJGp29vWIox+iAbUpZaS10XTev9ZI0tlWrR6N9ppjLrOxxzkwsTUS9/Z/ifOBy
         UcIeSK+pPGqVumNdGqBELuQN6zrnb9cPTZqMGRg/Lgznal+VfSkyLIpS3UC4Zloc+950
         yGRvpNezidPxJG6QjowpRcHWpz2UxzlPPbl0+2QI2O6m0+4en7MEjW5YQofRv2NHW4GJ
         9JylGdoXpqnFJZdDq+CpdPpddBTFGvYKM76BLl3teWZVAyyD8Nd7dbtmayJdxTT57ye0
         2GwqNaaX2oeZn4BotNWk3OB4oYaLPBQZAMX/jxAXl1CU+T5MB/X2yULF+aZr/M7Z/5DF
         /XDg==
X-Gm-Message-State: AOJu0YxwVKSTGiS0aQ601Ky9dUTnYvvDeQHtnNEnJg6b7ctiJaDEC2Ov
	LorqTO09gV57C5bMxJs8CoIYTQ==
X-Google-Smtp-Source: AGHT+IH4gRHcH2C56k65qmxY/tgOsFae4qzfQvdNHKXi+ydhfItRS40/B9o9IDmJDqAt517CDjrUBw==
X-Received: by 2002:a17:907:7798:b0:9a1:c669:6e66 with SMTP id ky24-20020a170907779800b009a1c6696e66mr6491833ejc.70.1693781138694;
        Sun, 03 Sep 2023 15:45:38 -0700 (PDT)
Received: from [10.10.15.130] ([192.130.178.91])
        by smtp.gmail.com with ESMTPSA id lz20-20020a170906fb1400b009929d998abcsm5223365ejb.209.2023.09.03.15.45.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Sep 2023 15:45:38 -0700 (PDT)
Message-ID: <cefd4c7a-3b98-4a4c-be03-a8b02d35de3c@linaro.org>
Date: Mon, 4 Sep 2023 01:45:37 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] drm/msm/dp: Simplify DPCD related code with helpers
Content-Language: en-GB
To: Stephen Boyd <swboyd@chromium.org>, Rob Clark <robdclark@gmail.com>,
 Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org,
 freedreno@lists.freedesktop.org, Vinod Polimera <quic_vpolimer@quicinc.com>,
 Kuogee Hsieh <quic_khsieh@quicinc.com>
References: <20230829184735.2841739-1-swboyd@chromium.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20230829184735.2841739-1-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/08/2023 21:47, Stephen Boyd wrote:
> This driver open-codes a few of the DPCD register reads when it can be
> simplified by using the helpers instead. This series reworks the MSM DP
> driver to use the DPCD helpers and removes some dead code along the way.
> There's the potential for even more code reduction around the test
> registers, but I haven't tried to do that yet.

For the whole series:

Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

Using drm_dp_get_phy_test_pattern() / drm_dp_set_phy_test_pattern() 
would be definitely a benefit, especially since the latter one has 
support for DP >= 1.2, while msm DP code doesn't.

> 
> Stephen Boyd (7):
>    drm/msm/dp: Replace open-coded drm_dp_read_dpcd_caps()
>    drm/msm/dp: Use drm_dp_read_sink_count() helper
>    drm/msm/dp: Remove dead code related to downstream cap info
>    drm/msm/dp: Remove aux_cfg_update_done and related code
>    drm/msm/dp: Simplify with drm_dp_{max_link_rate,max_lane_count}()
>    drm/msm/dp: Inline dp_link_parse_sink_count()
>    drm/msm/dp: Remove dp_display_is_ds_bridge()
> 
> Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
> Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
> 
>   drivers/gpu/drm/msm/dp/dp_display.c |   9 +--
>   drivers/gpu/drm/msm/dp/dp_link.c    |  38 +---------
>   drivers/gpu/drm/msm/dp/dp_panel.c   | 105 +++++-----------------------
>   drivers/gpu/drm/msm/dp/dp_panel.h   |  10 +--
>   4 files changed, 22 insertions(+), 140 deletions(-)
> 
> 
> base-commit: 2dde18cd1d8fac735875f2e4987f11817cc0bc2c

-- 
With best wishes
Dmitry

