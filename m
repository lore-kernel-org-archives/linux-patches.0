Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894A09445
	for <patches@lists.linux.dev>; Sun,  3 Sep 2023 22:39:06 +0000 (UTC)
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-401d67434daso9796915e9.2
        for <patches@lists.linux.dev>; Sun, 03 Sep 2023 15:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693780744; x=1694385544; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FCW5fhzFPO36VkzYsA4ot6wHveFpsnR8+rOVU4lQ1Wc=;
        b=joMjSbSUPUr3wlBj6Pjsd4O7c4LHgZc33ph3IHAvZjfn3ff+8gpNBtiSdh/SPQkYoq
         c2Wvmb4dWYD766ZjKUd9mWPH6YjSRx4mg3ieNmnfMTqQ5EiYDyK3mstoJKFQCvjZb5a6
         VgepAUMeJ1+jT4qLXSigxVeoNBdnxpkYfMwpdATS0emGHocI87vnhmwFEBq4ofZaIrVo
         sbYY7+iHSyXB9gDxVJ8UD/w+rnFbnHmsIN8r90K5TfcxR7EjQh69CoM6MKXgSDBxwl5o
         a+9l/6Gip+IkEDb+SA5ENfWwau1rDaMyUJP+XxnNpukfyJuUTTm6A3lQQ+AUM9L0Yn1s
         nzKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693780744; x=1694385544;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FCW5fhzFPO36VkzYsA4ot6wHveFpsnR8+rOVU4lQ1Wc=;
        b=F58aF4h8NNJM+DjBFWoojyZ4YXgocUkm934tSQWwcLzl9gIFVy0WvqoLJzQG6QMGmk
         VbXZbU6lITb+hsqA9NGcsMq4/kSQfpWG9Ol4tTrMSwEOiNS+rgJVyNeLYZB9Iu1Zx8Lt
         VziH5gbsw8KS0TdQT1dZFv1Hho+fTI365+OFWD+UTGC8D/vEsUAYD+NSKzKB+XPSY6OF
         phMnQVwV0DbKE0vdDh8q5Au3CTkJma14dPEv30XLat4CjC+KN8WRa+kACSCbDZKo7fGS
         OlWQelGJjdJzgJK1zxvCltoN5vdbwtrOjZjcXt7hB1IYP06uK5rfdkez2Ue4bm2dQ02R
         IKew==
X-Gm-Message-State: AOJu0Yy0cB7Lc9BnCBAoIhU+7ndodlNu6AVg8doZAWeBv3YaVFGBKvtz
	7YHfTvEcxBgnQQE7xIoWfWb4bg==
X-Google-Smtp-Source: AGHT+IHC4LmuKmR0sAciVcZpljh/BF5lACIe0GOW90jgSls+WPgeE839R/LmWZIlDExfc1NZ5qUZvw==
X-Received: by 2002:a05:6000:1749:b0:31f:3cfd:c700 with SMTP id m9-20020a056000174900b0031f3cfdc700mr2629921wrf.32.1693780744491;
        Sun, 03 Sep 2023 15:39:04 -0700 (PDT)
Received: from [10.10.15.130] ([192.130.178.91])
        by smtp.gmail.com with ESMTPSA id bo9-20020a0564020b2900b0052889d090bfsm4972604edb.79.2023.09.03.15.39.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Sep 2023 15:39:04 -0700 (PDT)
Message-ID: <db42e1b4-3ef7-4af9-80d2-23d84ec5f8dc@linaro.org>
Date: Mon, 4 Sep 2023 01:39:03 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] drm/msm/dp: Remove dead code related to downstream
 cap info
Content-Language: en-GB
To: Stephen Boyd <swboyd@chromium.org>, Rob Clark <robdclark@gmail.com>,
 Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org,
 freedreno@lists.freedesktop.org, Vinod Polimera <quic_vpolimer@quicinc.com>,
 Kuogee Hsieh <quic_khsieh@quicinc.com>
References: <20230829184735.2841739-1-swboyd@chromium.org>
 <20230829184735.2841739-4-swboyd@chromium.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20230829184735.2841739-4-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/08/2023 21:47, Stephen Boyd wrote:
> We read the downstream port count and capability info but never use it
> anywhere. Remove 'ds_port_cnt' and 'ds_cap_info' and any associated code
> from this driver. Fold the check for 'dfp_present' into a call to
> drm_dp_is_branch() at the one place it is used to get rid of any member
> storage related to downstream ports.
> 
> Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
> Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>   drivers/gpu/drm/msm/dp/dp_panel.c | 25 +++----------------------
>   drivers/gpu/drm/msm/dp/dp_panel.h |  6 ------
>   2 files changed, 3 insertions(+), 28 deletions(-)

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry

