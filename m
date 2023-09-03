Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE609445
	for <patches@lists.linux.dev>; Sun,  3 Sep 2023 22:39:29 +0000 (UTC)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-52bcd4db4bdso1085170a12.3
        for <patches@lists.linux.dev>; Sun, 03 Sep 2023 15:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693780768; x=1694385568; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=64IskuQuClXBpnMvldmQrJ5JN6x55RtC96YOLaP2MLE=;
        b=GWfWbXaE7zl95H/1osjG+JYmbfkgum1YA3WE/dvVr4paOUXWtzh8M1C+b0ilxVsNpA
         1KmPwnM8471YSEua4BmYrdhD6u+0lU7ecQpFM0ZmI0y+3woWSUlrphm5W1FD/aVld1qp
         sPQhg4AqCM6lnjiOmuEVyJl1TDMigNgcUNIma0KZcpFfH4inhb1YrqiiNZnRzvKjKapf
         QXidS8N/lWDPboz4UFTqy4ZOkbo0rg0X0RsuxTiFKomzJO2qPtVXU9Vt4M7McQUH7Ipx
         6t8mLzpe0Bpd2Oc/KC6c2eJ+GKCAMiSIqSQtJKKDVvNPtJdfhKIsfWEMOmtvGaOd/5JY
         niHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693780768; x=1694385568;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=64IskuQuClXBpnMvldmQrJ5JN6x55RtC96YOLaP2MLE=;
        b=dva6V6fObAR6pgx2T7g2BBig2Y3U/63yEYMemCC4gn/MqMDqRdmk6lexW9gipi3+aJ
         lfsw90fYQDHlFl6w4ApunBGPYsbfjaQMrvvZW8NwbXjwDCoqDY/wDZ30oyG1H4aEeY5+
         T0uXX3YIVgM64YGaHoldp8Q5uBo8QxXmIMAaaDoFinGVg19UNyolZz8AQus3vKrW6PVC
         GABeldx7HUvwMfbzYc8Wg0C1WSP5K5MzsuUz3+zY9E0OFy3Fw7VIsD7Jumz6w0oJvGV3
         Db0cm0gilHKgqD37UAQOTncYOox9FMSWPFrFbIXF2qHXKqD9hrPeb0neDVNhku5B5bp2
         E7EQ==
X-Gm-Message-State: AOJu0Yy7XQGNzzIJM2zhrufVOEdJff5yOA60CfQYKgl/kI0FcJ/9+Q8m
	IeY5F8ep5elVFSbo9sbOn7341w==
X-Google-Smtp-Source: AGHT+IEx1q4XhkhCeBmp20jVm4futZYqogZ7sv4YonHFB6mBEBeALQ2rV63p1riW/bCqaQU7aIQdQw==
X-Received: by 2002:aa7:d9cb:0:b0:525:69ec:e1c8 with SMTP id v11-20020aa7d9cb000000b0052569ece1c8mr4984850eds.40.1693780768344;
        Sun, 03 Sep 2023 15:39:28 -0700 (PDT)
Received: from [10.10.15.130] ([192.130.178.91])
        by smtp.gmail.com with ESMTPSA id bo9-20020a0564020b2900b0052889d090bfsm4972604edb.79.2023.09.03.15.39.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Sep 2023 15:39:28 -0700 (PDT)
Message-ID: <900f1290-e7ed-4f61-be10-53955171abb4@linaro.org>
Date: Mon, 4 Sep 2023 01:39:27 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] drm/msm/dp: Simplify with
 drm_dp_{max_link_rate,max_lane_count}()
Content-Language: en-GB
To: Stephen Boyd <swboyd@chromium.org>, Rob Clark <robdclark@gmail.com>,
 Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org,
 freedreno@lists.freedesktop.org, Vinod Polimera <quic_vpolimer@quicinc.com>,
 Kuogee Hsieh <quic_khsieh@quicinc.com>
References: <20230829184735.2841739-1-swboyd@chromium.org>
 <20230829184735.2841739-6-swboyd@chromium.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20230829184735.2841739-6-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/08/2023 21:47, Stephen Boyd wrote:
> These are open-coded versions of common functions. Replace them with the
> common code to improve readability.
> 
> Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
> Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>   drivers/gpu/drm/msm/dp/dp_panel.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry

